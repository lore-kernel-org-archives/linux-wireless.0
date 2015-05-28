Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbbE1PtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 11:49:09 -0400
Subject: [PATCH 19/20] KEYS: Restrict signature verification to keys
 appropriate to the purpose [ver #5]
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Thu, 28 May 2015 16:49:01 +0100
Message-ID: <20150528154901.1259.4403.stgit@warthog.procyon.org.uk> (sfid-20150528_174951_141935_BC9DD36A)
In-Reply-To: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Restrict the verification of X.509 certificates such that a certificate can
only be verified if either:

 (1) A certificate is signed with the key it holds.

 (2) A certificate is signed with a key that has keyCertSign set in its
     keyUsage extension and has no purpose restriction set.

Restrict the verification of PKCS#7 messages such that a signature can only be
verified by a matching key if the key does not have keyCertSign set and either
of the following is true:

 (1) The key has no purpose restriction and the PKCS#7 is not a firmware
     signature.

 (2) The key has a recognised purpose restriction that matches the use to
     which the PKCS#7 signature is being put.

In the event that a restriction mismatch occurs, EKEYREJECTED will be returned
and an error similar to one of the following will be logged to dmesg:

	PKEY: Firmware signed with non-firmware key (module sig)
	PKEY: Restricted usage key (module sig) used for wrong purpose (kexec sig)

The PKCS#7 test key type is given the usage to specify in a module parameter.
For example:

	echo 1 >/sys/module/pkcs7_test_key/parameters/usage
	keyctl padd pkcs7_test foo @s </tmp/stuff.pkcs7

will attempt to check the signature on stuff.pkcs7 as if it contains a
firmware blob (1 being KEY_VERIFYING_FIRMWARE_SIGNATURE).

Not-yet-signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/asymmetric_type.c |    9 +++++
 crypto/asymmetric_keys/pkcs7_key_type.c  |   19 +++++++++-
 crypto/asymmetric_keys/pkcs7_trust.c     |   14 +++++---
 crypto/asymmetric_keys/pkcs7_verify.c    |   21 ++++++++---
 crypto/asymmetric_keys/public_key.c      |   55 ++++++++++++++++++++++++++++--
 crypto/asymmetric_keys/public_key.h      |    3 +-
 crypto/asymmetric_keys/signature.c       |    6 ++-
 crypto/asymmetric_keys/x509_parser.h     |    3 +-
 crypto/asymmetric_keys/x509_public_key.c |   15 +++++---
 include/crypto/pkcs7.h                   |    4 ++
 include/crypto/public_key.h              |    3 +-
 include/keys/asymmetric-subtype.h        |    3 +-
 include/keys/asymmetric-type.h           |   13 +++++++
 include/keys/system_keyring.h            |    2 +
 kernel/module_signing.c                  |    3 +-
 kernel/system_keyring.c                  |    7 +++-
 16 files changed, 148 insertions(+), 32 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 9047175fe818..6367d3734533 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -20,6 +20,15 @@
 
 MODULE_LICENSE("GPL");
 
+const char *const asymmetric_key_verification_names[NR__ASYMMETRIC_KEY_VERIFICATION] = {
+	[KEY_VERIFYING_MODULE_SIGNATURE]	= "mod sig",
+	[KEY_VERIFYING_FIRMWARE_SIGNATURE]	= "firmware sig",
+	[KEY_VERIFYING_KEXEC_SIGNATURE]		= "kexec sig",
+	[KEY_VERIFYING_KEY_SIGNATURE]		= "key sig",
+	[KEY_VERIFYING_KEY_SELF_SIGNATURE]	= "key self sig",
+};
+EXPORT_SYMBOL_GPL(asymmetric_key_verification_names);
+
 static LIST_HEAD(asymmetric_key_parsers);
 static DECLARE_RWSEM(asymmetric_key_parsers_sem);
 
diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_keys/pkcs7_key_type.c
index 751f8fd7335d..ce5eb0346d83 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -12,17 +12,24 @@
 #define pr_fmt(fmt) "PKCS7key: "fmt
 #include <linux/key.h>
 #include <linux/err.h>
-#include <linux/key-type.h>
+#include <linux/module.h>
+#include <keys/asymmetric-type.h>
 #include <crypto/pkcs7.h>
 #include <keys/user-type.h>
 #include <keys/system_keyring.h>
 #include "pkcs7_parser.h"
 
+unsigned pkcs7_usage;
+module_param_named(usage, pkcs7_usage, uint, S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(pkcs7_usage,
+		 "Usage to specify when verifying the PKCS#7 message");
+
 /*
  * Preparse a PKCS#7 wrapped and validated data blob.
  */
 static int pkcs7_preparse(struct key_preparsed_payload *prep)
 {
+	enum asymmetric_key_verification usage = pkcs7_usage;
 	struct pkcs7_message *pkcs7;
 	const void *data, *saved_prep_data;
 	size_t datalen, saved_prep_datalen;
@@ -31,6 +38,11 @@ static int pkcs7_preparse(struct key_preparsed_payload *prep)
 
 	kenter("");
 
+	if (usage >= NR__ASYMMETRIC_KEY_VERIFICATION) {
+		pr_err("Invalid usage type %d\n", usage);
+		return -EINVAL;
+	}
+
 	saved_prep_data = prep->data;
 	saved_prep_datalen = prep->datalen;
 	pkcs7 = pkcs7_parse_message(saved_prep_data, saved_prep_datalen);
@@ -39,11 +51,12 @@ static int pkcs7_preparse(struct key_preparsed_payload *prep)
 		goto error;
 	}
 
-	ret = pkcs7_verify(pkcs7);
+	ret = pkcs7_verify(pkcs7, usage);
 	if (ret < 0)
 		goto error_free;
 
-	ret = pkcs7_validate_trust(pkcs7, system_trusted_keyring, &trusted);
+	ret = pkcs7_validate_trust(pkcs7, system_trusted_keyring, usage,
+				   &trusted);
 	if (ret < 0)
 		goto error_free;
 	if (!trusted)
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 90d6d47965b0..bbe3dc9755e4 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -25,7 +25,8 @@
  */
 static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 				    struct pkcs7_signed_info *sinfo,
-				    struct key *trust_keyring)
+				    struct key *trust_keyring,
+				    enum asymmetric_key_verification usage)
 {
 	struct public_key_signature *sig = &sinfo->sig;
 	struct x509_certificate *x509, *last = NULL, *p;
@@ -65,6 +66,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 			 */
 			pr_devel("sinfo %u: Cert %u as key %x\n",
 				 sinfo->index, x509->index, key_serial(key));
+			usage = KEY_VERIFYING_KEY_SIGNATURE;
 			goto matched;
 		}
 		if (key == ERR_PTR(-ENOMEM))
@@ -95,6 +97,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 			x509 = last;
 			pr_devel("sinfo %u: Root cert %u signer is key %x\n",
 				 sinfo->index, x509->index, key_serial(key));
+			usage = KEY_VERIFYING_KEY_SIGNATURE;
 			goto matched;
 		}
 		if (PTR_ERR(key) != -ENOKEY)
@@ -121,7 +124,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 	return -ENOKEY;
 
 matched:
-	ret = verify_signature(key, sig);
+	ret = verify_signature(key, sig, usage);
 	trusted = test_bit(KEY_FLAG_TRUSTED, &key->flags);
 	key_put(key);
 	if (ret < 0) {
@@ -148,7 +151,8 @@ verified:
  * pkcs7_validate_trust - Validate PKCS#7 trust chain
  * @pkcs7: The PKCS#7 certificate to validate
  * @trust_keyring: Signing certificates to use as starting points
- * @_trusted: Set to true if trustworth, false otherwise
+ * @usage: The use to which the key is being put.
+ * @_trusted: Set to true if trustworthy, false otherwise
  *
  * Validate that the certificate chain inside the PKCS#7 message intersects
  * keys we already know and trust.
@@ -171,6 +175,7 @@ verified:
  */
 int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
 			 struct key *trust_keyring,
+			 enum asymmetric_key_verification usage,
 			 bool *_trusted)
 {
 	struct pkcs7_signed_info *sinfo;
@@ -182,7 +187,8 @@ int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
 		p->seen = false;
 
 	for (sinfo = pkcs7->signed_infos; sinfo; sinfo = sinfo->next) {
-		ret = pkcs7_validate_trust_one(pkcs7, sinfo, trust_keyring);
+		ret = pkcs7_validate_trust_one(pkcs7, sinfo, trust_keyring,
+					       usage);
 		switch (ret) {
 		case -ENOKEY:
 			continue;
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 404f89a0f852..74edabd3b36a 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -208,7 +208,8 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 				   x509->raw_issuer_size) != 0)
 				return 0;
 
-			ret = x509_check_signature(x509->pub, x509);
+			ret = x509_check_signature(x509->pub, x509,
+						   KEY_VERIFYING_KEY_SELF_SIGNATURE);
 			if (ret < 0)
 				goto maybe_missing_crypto_in_x509;
 			x509->signer = x509;
@@ -262,7 +263,8 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 				sinfo->index);
 			return 0;
 		}
-		ret = x509_check_signature(p->pub, x509);
+		ret = x509_check_signature(p->pub, x509,
+					   KEY_VERIFYING_KEY_SIGNATURE);
 		if (ret < 0)
 			return ret;
 		x509->signer = p;
@@ -290,7 +292,8 @@ maybe_missing_crypto_in_x509:
  * Verify one signed information block from a PKCS#7 message.
  */
 static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
-			    struct pkcs7_signed_info *sinfo)
+			    struct pkcs7_signed_info *sinfo,
+			    enum asymmetric_key_verification usage)
 {
 	int ret;
 
@@ -315,7 +318,8 @@ static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
 		 sinfo->signer->index, sinfo->index);
 
 	/* Verify the PKCS#7 binary against the key */
-	ret = public_key_verify_signature(sinfo->signer->pub, &sinfo->sig);
+	ret = public_key_verify_signature(sinfo->signer->pub, &sinfo->sig,
+					  usage);
 	if (ret < 0)
 		return ret;
 
@@ -328,6 +332,7 @@ static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
 /**
  * pkcs7_verify - Verify a PKCS#7 message
  * @pkcs7: The PKCS#7 message to be verified
+ * @usage: The use to which the key is being put
  *
  * Verify a PKCS#7 message is internally consistent - that is, the data digest
  * matches the digest in the AuthAttrs and any signature in the message or one
@@ -339,6 +344,9 @@ static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
  *
  * Returns, in order of descending priority:
  *
+ *  (*) -EKEYREJECTED if a key was selected that had a usage restriction at
+ *      odds with the specified usage, or:
+ *
  *  (*) -EKEYREJECTED if a signature failed to match for which we found an
  *	appropriate X.509 certificate, or:
  *
@@ -350,7 +358,8 @@ static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
  *  (*) 0 if all the signature chains that don't incur -ENOPKG can be verified
  *	(note that a signature chain may be of zero length), or:
  */
-int pkcs7_verify(struct pkcs7_message *pkcs7)
+int pkcs7_verify(struct pkcs7_message *pkcs7,
+		 enum asymmetric_key_verification usage)
 {
 	struct pkcs7_signed_info *sinfo;
 	struct x509_certificate *x509;
@@ -366,7 +375,7 @@ int pkcs7_verify(struct pkcs7_message *pkcs7)
 	}
 
 	for (sinfo = pkcs7->signed_infos; sinfo; sinfo = sinfo->next) {
-		ret = pkcs7_verify_one(pkcs7, sinfo);
+		ret = pkcs7_verify_one(pkcs7, sinfo, usage);
 		if (ret < 0) {
 			if (ret == -ENOPKG) {
 				sinfo->unsupported_crypto = true;
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 7790f58d00bf..9e354d8e86bf 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -94,12 +94,56 @@ void public_key_destroy(void *payload)
 EXPORT_SYMBOL_GPL(public_key_destroy);
 
 /*
+ * Apply key usage policy.
+ */
+static int public_key_usage_policy(enum asymmetric_key_verification usage,
+				   enum pkey_usage_restriction restriction)
+{
+	switch (usage) {
+	case KEY_VERIFYING_MODULE_SIGNATURE:
+		if (restriction != PKEY_RESTRICTED_TO_MODULE_SIGNING &&
+		    restriction != PKEY_USAGE_NOT_SPECIFIED)
+			goto wrong_purpose;
+		return 0;
+	case KEY_VERIFYING_FIRMWARE_SIGNATURE:
+		if (restriction != PKEY_RESTRICTED_TO_FIRMWARE_SIGNING) {
+			pr_warn("Firmware signed with non-firmware key (%s)\n",
+				public_key_restrictions[restriction]);
+			return -EKEYREJECTED;
+		}
+		return 0;
+	case KEY_VERIFYING_KEXEC_SIGNATURE:
+		if (restriction != PKEY_RESTRICTED_TO_KEXEC_SIGNING &&
+		    restriction != PKEY_USAGE_NOT_SPECIFIED)
+			goto wrong_purpose;
+		return 0;
+	case KEY_VERIFYING_KEY_SIGNATURE:
+		if (restriction != PKEY_RESTRICTED_TO_KEY_SIGNING &&
+		    restriction != PKEY_USAGE_NOT_SPECIFIED)
+			goto wrong_purpose;
+		return 0;
+	case KEY_VERIFYING_KEY_SELF_SIGNATURE:
+		return 0;
+	default:
+		BUG();
+	}
+
+wrong_purpose:
+	pr_warn("Restricted usage key (%s) used for wrong purpose (%s)\n",
+		public_key_restrictions[restriction],
+		asymmetric_key_verification_names[usage]);
+	return -EKEYREJECTED;
+}
+
+/*
  * Verify a signature using a public key.
  */
 int public_key_verify_signature(const struct public_key *pk,
-				const struct public_key_signature *sig)
+				const struct public_key_signature *sig,
+				enum asymmetric_key_verification usage)
 {
 	const struct public_key_algorithm *algo;
+	int ret;
 
 	BUG_ON(!pk);
 	BUG_ON(!pk->mpi[0]);
@@ -126,15 +170,20 @@ int public_key_verify_signature(const struct public_key *pk,
 		return -EINVAL;
 	}
 
+	ret = public_key_usage_policy(usage, pk->usage_restriction);
+	if (ret < 0)
+		return ret;
+
 	return algo->verify_signature(pk, sig);
 }
 EXPORT_SYMBOL_GPL(public_key_verify_signature);
 
 static int public_key_verify_signature_2(const struct key *key,
-					 const struct public_key_signature *sig)
+					 const struct public_key_signature *sig,
+					 enum asymmetric_key_verification usage)
 {
 	const struct public_key *pk = key->payload.data;
-	return public_key_verify_signature(pk, sig);
+	return public_key_verify_signature(pk, sig, usage);
 }
 
 /*
diff --git a/crypto/asymmetric_keys/public_key.h b/crypto/asymmetric_keys/public_key.h
index 5c37a22a0637..d8585ac3a8e9 100644
--- a/crypto/asymmetric_keys/public_key.h
+++ b/crypto/asymmetric_keys/public_key.h
@@ -33,4 +33,5 @@ extern const struct public_key_algorithm RSA_public_key_algorithm;
  * public_key.c
  */
 extern int public_key_verify_signature(const struct public_key *pk,
-				       const struct public_key_signature *sig);
+				       const struct public_key_signature *sig,
+				       enum asymmetric_key_verification usage);
diff --git a/crypto/asymmetric_keys/signature.c b/crypto/asymmetric_keys/signature.c
index 7525fd183574..8b69cbff1dbc 100644
--- a/crypto/asymmetric_keys/signature.c
+++ b/crypto/asymmetric_keys/signature.c
@@ -22,11 +22,13 @@
  * verify_signature - Initiate the use of an asymmetric key to verify a signature
  * @key: The asymmetric key to verify against
  * @sig: The signature to check
+ * @usage: The use to which the key is being put.
  *
  * Returns 0 if successful or else an error.
  */
 int verify_signature(const struct key *key,
-		     const struct public_key_signature *sig)
+		     const struct public_key_signature *sig,
+		     enum asymmetric_key_verification usage)
 {
 	const struct asymmetric_key_subtype *subtype;
 	int ret;
@@ -42,7 +44,7 @@ int verify_signature(const struct key *key,
 	if (!subtype->verify_signature)
 		return -ENOTSUPP;
 
-	ret = subtype->verify_signature(key, sig);
+	ret = subtype->verify_signature(key, sig, usage);
 
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index dcdb5c94f514..e4dc470c8fbd 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -55,4 +55,5 @@ extern struct x509_certificate *x509_cert_parse(const void *data, size_t datalen
  */
 extern int x509_get_sig_params(struct x509_certificate *cert);
 extern int x509_check_signature(const struct public_key *pub,
-				struct x509_certificate *cert);
+				struct x509_certificate *cert,
+				enum asymmetric_key_verification usage);
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 8a4e3a29ec31..aaaa6bf8a0f6 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -208,7 +208,8 @@ EXPORT_SYMBOL_GPL(x509_get_sig_params);
  * Check the signature on a certificate using the provided public key
  */
 int x509_check_signature(const struct public_key *pub,
-			 struct x509_certificate *cert)
+			 struct x509_certificate *cert,
+			 enum asymmetric_key_verification usage)
 {
 	int ret;
 
@@ -218,7 +219,7 @@ int x509_check_signature(const struct public_key *pub,
 	if (ret < 0)
 		return ret;
 
-	ret = public_key_verify_signature(pub, &cert->sig);
+	ret = public_key_verify_signature(pub, &cert->sig, usage);
 	if (ret == -ENOPKG)
 		cert->unsupported_crypto = true;
 	pr_debug("Cert Verification: %d\n", ret);
@@ -251,9 +252,10 @@ static int x509_validate_trust(struct x509_certificate *cert,
 					  cert->akid_id, cert->akid_skid,
 					  false);
 	if (!IS_ERR(key))  {
-		if (!use_builtin_keys
-		    || test_bit(KEY_FLAG_BUILTIN, &key->flags))
-			ret = x509_check_signature(key->payload.data, cert);
+		if (!use_builtin_keys ||
+		    test_bit(KEY_FLAG_BUILTIN, &key->flags))
+			ret = x509_check_signature(key->payload.data, cert,
+						   KEY_VERIFYING_KEY_SIGNATURE);
 		key_put(key);
 	}
 	return ret;
@@ -308,7 +310,8 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	if ((!cert->akid_skid && !cert->akid_id) ||
 	    asymmetric_key_id_same(cert->skid, cert->akid_skid) ||
 	    asymmetric_key_id_same(cert->id, cert->akid_id)) {
-		ret = x509_check_signature(cert->pub, cert); /* self-signed */
+		ret = x509_check_signature(cert->pub, cert,
+					   KEY_VERIFYING_KEY_SELF_SIGNATURE);
 		if (ret < 0)
 			goto error_free_cert;
 	} else if (!prep->trusted) {
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index 0999eac6313f..56388a6d8505 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -29,12 +29,14 @@ extern const char *pkcs7_get_firmware_name(const struct pkcs7_message *pkcs7);
  */
 extern int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
 				struct key *trust_keyring,
+				enum asymmetric_key_verification usage,
 				bool *_trusted);
 
 /*
  * pkcs7_verify.c
  */
-extern int pkcs7_verify(struct pkcs7_message *pkcs7);
+extern int pkcs7_verify(struct pkcs7_message *pkcs7,
+			enum asymmetric_key_verification usage);
 
 extern int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
 				      const void *data, size_t datalen);
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index d15c74cb1f98..c2f51bd7aef5 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -110,7 +110,8 @@ struct public_key_signature {
 
 struct key;
 extern int verify_signature(const struct key *key,
-			    const struct public_key_signature *sig);
+			    const struct public_key_signature *sig,
+			    enum asymmetric_key_verification usage);
 
 struct asymmetric_key_id;
 extern struct key *x509_request_asymmetric_key(struct key *keyring,
diff --git a/include/keys/asymmetric-subtype.h b/include/keys/asymmetric-subtype.h
index b6a47f09ef2b..bc83a0a2d10d 100644
--- a/include/keys/asymmetric-subtype.h
+++ b/include/keys/asymmetric-subtype.h
@@ -39,7 +39,8 @@ struct asymmetric_key_subtype {
 
 	/* Verify the signature on a key of this subtype (optional) */
 	int (*verify_signature)(const struct key *key,
-				const struct public_key_signature *sig);
+				const struct public_key_signature *sig,
+				enum asymmetric_key_verification usage);
 };
 
 /**
diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index c0754abb2f56..329e1f1b185b 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -60,6 +60,19 @@ extern struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
 							    size_t len_2);
 
 /*
+ * The use to which an asymmetric is being put when verifying a signature.
+ */
+enum asymmetric_key_verification {
+	KEY_VERIFYING_MODULE_SIGNATURE,
+	KEY_VERIFYING_FIRMWARE_SIGNATURE,
+	KEY_VERIFYING_KEXEC_SIGNATURE,
+	KEY_VERIFYING_KEY_SIGNATURE,
+	KEY_VERIFYING_KEY_SELF_SIGNATURE,
+	NR__ASYMMETRIC_KEY_VERIFICATION
+};
+extern const char *const asymmetric_key_verification_names[NR__ASYMMETRIC_KEY_VERIFICATION];
+
+/*
  * The payload is at the discretion of the subtype.
  */
 
diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
index 30303745f845..3f5fee29ce8a 100644
--- a/include/keys/system_keyring.h
+++ b/include/keys/system_keyring.h
@@ -29,8 +29,10 @@ static inline struct key *get_system_trusted_keyring(void)
 #endif
 
 #ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+enum asymmetric_key_verification;
 extern int system_verify_data(const void *data, unsigned long len,
 			      const void *raw_pkcs7, size_t pkcs7_len,
+			      enum asymmetric_key_verification usage,
 			      const char *firmware_name);
 #endif
 
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index 9361711897ce..2ac070a89496 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -72,5 +72,6 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 		return -EBADMSG;
 	}
 
-	return system_verify_data(mod, modlen, mod + modlen, sig_len, NULL);
+	return system_verify_data(mod, modlen, mod + modlen, sig_len,
+				  KEY_VERIFYING_MODULE_SIGNATURE, NULL);
 }
diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
index ccb2814f89c1..1ae70cbcb377 100644
--- a/kernel/system_keyring.c
+++ b/kernel/system_keyring.c
@@ -113,10 +113,12 @@ late_initcall(load_system_certificate_list);
  * @len: Size of @data.
  * @raw_pkcs7: The PKCS#7 message that is the signature.
  * @pkcs7_len: The size of @raw_pkcs7.
+ * @usage: The use to which the key is being put.
  * @firmware_name: The required firmware name or NULL.
  */
 int system_verify_data(const void *data, unsigned long len,
 		       const void *raw_pkcs7, size_t pkcs7_len,
+		       enum asymmetric_key_verification usage,
 		       const char *firmware_name)
 {
 	struct pkcs7_message *pkcs7;
@@ -156,11 +158,12 @@ int system_verify_data(const void *data, unsigned long len,
 		goto error;
 	}
 
-	ret = pkcs7_verify(pkcs7);
+	ret = pkcs7_verify(pkcs7, usage);
 	if (ret < 0)
 		goto error;
 
-	ret = pkcs7_validate_trust(pkcs7, system_trusted_keyring, &trusted);
+	ret = pkcs7_validate_trust(pkcs7, system_trusted_keyring, usage,
+				   &trusted);
 	if (ret < 0)
 		goto error;
 

