// Add simple validator to LibraSystem's validator set.

//! account: bob, 1000000, 0, validator
//! account: alex, 0, 0, address

//! sender: bob
script {
    use 0x1::LibraSystem;
    use 0x1::ValidatorConfig;
    fun main() {
        // test bob is a validator
        assert(ValidatorConfig::is_valid({{bob}}) == true, 98);
        assert(LibraSystem::is_validator({{bob}}) == true, 98);
    }
}
// check: "Keep(EXECUTED)"

//! new-transaction
//! sender: libraroot
script {
use 0x1::LibraAccount;
fun main(creator: &signer) {
//    LibraAccount::create_validator_account(
//        creator, &r, 0xAA, x"00000000000000000000000000000000"
    LibraAccount::create_validator_account(
        creator, 0xAA, x"00000000000000000000000000000000", b"owner_name"
    );

}
}
// check: "Keep(EXECUTED)"

//! new-transaction
//! sender: libraroot
//! args: 0, {{alex}}, {{alex::auth_key}}, b"alex"
stdlib_script::create_validator_account
// check: "Keep(EXECUTED)"

//! new-transaction
//! sender: libraroot
//! execute-as: alex
script {
use 0x1::ValidatorConfig;
fun main(lr_account: &signer, alex_signer: &signer) {
    ValidatorConfig::publish(alex_signer, lr_account, b"alex");
}
}
// check: "Discard(INVALID_WRITE_SET)"

//! new-transaction
script {
use 0x1::ValidatorConfig;
fun main() {
    let _ = ValidatorConfig::get_config({{alex}});
}
}
// check: "Keep(ABORTED { code: 7,"

// TODO(valerini): enable the following test once the sender format is supported
// //! new-transaction
// //! sender: 0xAA
// script {
// fun main() {
//
//     // add itself as a validator
// }
// }
//
// // check: "Keep(EXECUTED)"
// // check: NewEpochEvent
