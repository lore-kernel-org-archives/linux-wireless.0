Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078AbbEVPV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 11:21:56 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com>
References: <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: dhowells@redhat.com, ming.lei@canonical.com, rusty@rustcorp.com.au,
	torvalds@linux-foundation.org, seth.forshee@canonical.com,
	linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	jlee@suse.com, tiwai@suse.de, casey@schaufler-ca.com,
	keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v3 0/2] firmware: add PKCS#7 firmware signature support
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 22 May 2015 16:21:20 +0100
Message-ID: <12977.1432308080@warthog.procyon.org.uk> (sfid-20150522_172231_241669_6A1DE346)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Assuming we want to tag firmware signatures with the name of the firmware blob
as passed to request_firmware(), the attached patch would provide the PKCS#7
side of the support you need.

David
---
commit ef479eb8e645a95ef172918e4df215ecdc823e42
Author: David Howells <dhowells@redhat.com>
Date:   Fri May 22 10:13:37 2015 +0100

    PKCS#7: Add an optional authenticated attribute to hold firmware name
    
    Modify the sign-file program to take a "-F <firmware name>" parameter.  The
    name is a utf8 string that, if given, is inserted in a PKCS#7 authenticated
    attribute from where it can be extracted by the kernel.  Authenticated
    attributes are added to the signature digest.
    
    If the attribute is present, the signature would be assumed to be for
    firmware and would not be permitted with module signing or kexec.  The name
    associated with the attribute would be compared to the name passed to
    request_firmware() and the load request would be denied if they didn't
    match.
    
    If not present, the signature would be rejected if used for firmware.
    
    One oddity is that the attribute is per-signature, so if a second signature
    was added (which PKCS#7 supports), it would have to have the attribute added
    separately to that signature also.
    
    Note that the OID I have selected is an unregistered element of the Red Hat
    OID space to serve as an example.  An OID would need to be allocated for
    this purpose.
    
    The kernel then parses this out, saves the string and makes sure the same
    string (or lack thereof) is present from all signers.  Then when
    system_verify_data() is called, it is passed a NULL if the attribute is
    expected not to be present and the name from request_firmware() if it is
    expected to be present.  Verification is rejected if there's a mismatch.

    This should probably be combined with tagging the X.509 certificate to
    indicate what it can be used for.
    
    Not-yet-signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 3bd5a1e4c493..01d19f37437a 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
+#include <linux/ctype.h>
 #include "public_key.h"
 #include "pkcs7_parser.h"
 #include "pkcs7-asn1.h"
@@ -29,6 +30,13 @@ struct pkcs7_parse_context {
 	enum OID	last_oid;		/* Last OID encountered */
 	unsigned	x509_index;
 	unsigned	sinfo_index;
+	unsigned	firmware_name_len;
+	enum {
+		maybe_firmware_sig,
+		is_firmware_sig,
+		isnt_firmware_sig
+	} firmware_sig_state : 8;
+	bool		signer_has_firmware_name;
 	const void	*raw_serial;
 	unsigned	raw_serial_size;
 	unsigned	raw_issuer_size;
@@ -73,6 +81,7 @@ void pkcs7_free_message(struct pkcs7_message *pkcs7)
 			pkcs7->signed_infos = sinfo->next;
 			pkcs7_free_signed_info(sinfo);
 		}
+		kfree(pkcs7->firmware_name);
 		kfree(pkcs7);
 	}
 }
@@ -310,6 +319,8 @@ int pkcs7_sig_note_authenticated_attr(void *context, size_t hdrlen,
 				      const void *value, size_t vlen)
 {
 	struct pkcs7_parse_context *ctx = context;
+	char *p;
+	int i;
 
 	pr_devel("AuthAttr: %02x %zu [%*ph]\n", tag, vlen, (unsigned)vlen, value);
 
@@ -320,6 +331,45 @@ int pkcs7_sig_note_authenticated_attr(void *context, size_t hdrlen,
 		ctx->sinfo->msgdigest = value;
 		ctx->sinfo->msgdigest_len = vlen;
 		return 0;
+
+	case OID_firmwareName:
+		if (tag != ASN1_UTF8STR || vlen == 0)
+			return -EBADMSG;
+		
+		/* If there's more than one signature, they must have the same
+		 * firmware name.
+		 */
+		switch (ctx->firmware_sig_state) {
+		case maybe_firmware_sig:
+			for (i = 0; i < vlen; i++)
+				if (!isprint(((const char *)value)[i]))
+					return -EBADMSG;
+			p = kmalloc(vlen + 1, GFP_KERNEL);
+			if (!p)
+				return -ENOMEM;
+			memcpy(p, value, vlen);
+			p[vlen] = 0;
+			ctx->msg->firmware_name = p;
+			ctx->firmware_name_len = vlen;
+			ctx->firmware_sig_state = is_firmware_sig;
+			pr_debug("Found firmware name '%s'\n", p);
+			ctx->signer_has_firmware_name = true;
+			return 0;
+
+		case is_firmware_sig:
+			if (ctx->firmware_name_len != vlen ||
+			    memcmp(ctx->msg->firmware_name, value, vlen) != 0) {
+				pr_warn("Mismatched firmware names\n");
+				return -EBADMSG;
+			}
+			ctx->signer_has_firmware_name = true;
+			return 0;
+
+		case isnt_firmware_sig:
+			pr_warn("Mismatched presence of firmware name\n");
+			return -EBADMSG;
+		}
+
 	default:
 		return 0;
 	}
@@ -334,12 +384,39 @@ int pkcs7_sig_note_set_of_authattrs(void *context, size_t hdrlen,
 {
 	struct pkcs7_parse_context *ctx = context;
 
+	/* Make sure we either have all or no firmware names */
+	switch (ctx->firmware_sig_state) {
+	case maybe_firmware_sig:
+		ctx->firmware_sig_state = isnt_firmware_sig;
+	case isnt_firmware_sig:
+		break;
+	case is_firmware_sig:
+		if (!ctx->signer_has_firmware_name) {
+			pr_warn("Mismatched presence of firmware name\n");
+			return -EBADMSG;
+		}
+		ctx->signer_has_firmware_name = false;
+		break;
+	}
+
 	/* We need to switch the 'CONT 0' to a 'SET OF' when we digest */
 	ctx->sinfo->authattrs = value - (hdrlen - 1);
 	ctx->sinfo->authattrs_len = vlen + (hdrlen - 1);
 	return 0;
 }
 
+/**
+ * pkcs7_get_firmware_name - Get firmware name extension value
+ * @pkcs7: The preparsed PKCS#7 message to access
+ *
+ * Get the value of the firmware name extension if there was one or NULL
+ * otherwise.
+ */
+const char *pkcs7_get_firmware_name(const struct pkcs7_message *pkcs7)
+{
+	return pkcs7->firmware_name;
+}
+
 /*
  * Note the issuing certificate serial number
  */
diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index efc7dc9b8f9c..03a30f8578e2 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -50,6 +50,7 @@ struct pkcs7_message {
 	struct x509_certificate *certs;	/* Certificate list */
 	struct x509_certificate *crl;	/* Revocation list */
 	struct pkcs7_signed_info *signed_infos;
+	char *firmware_name;		/* Firmware name if present */
 
 	/* Content Data (or NULL) */
 	enum OID	data_type;	/* Type of Data */
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index e235ab4957ee..0999eac6313f 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -22,6 +22,7 @@ extern void pkcs7_free_message(struct pkcs7_message *pkcs7);
 extern int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
 				  const void **_data, size_t *_datalen,
 				  bool want_wrapper);
+extern const char *pkcs7_get_firmware_name(const struct pkcs7_message *pkcs7);
 
 /*
  * pkcs7_trust.c
diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
index 9791c907cdb7..30303745f845 100644
--- a/include/keys/system_keyring.h
+++ b/include/keys/system_keyring.h
@@ -30,7 +30,8 @@ static inline struct key *get_system_trusted_keyring(void)
 
 #ifdef CONFIG_SYSTEM_DATA_VERIFICATION
 extern int system_verify_data(const void *data, unsigned long len,
-			      const void *raw_pkcs7, size_t pkcs7_len);
+			      const void *raw_pkcs7, size_t pkcs7_len,
+			      const char *firmware_name);
 #endif
 
 #endif /* _KEYS_SYSTEM_KEYRING_H */
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index c2bbf672b84e..b5e0cc621a8b 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -88,6 +88,10 @@ enum OID {
 	OID_authorityKeyIdentifier,	/* 2.5.29.35 */
 	OID_extKeyUsage,		/* 2.5.29.37 */
 
+	/* Signing */
+	OID_firmwareName,		/* 1.3.6.1.4.1.2312.99.1 */
+	OID_firmwareOnlyKey,		/* 1.3.6.1.4.1.2312.99.2 */
+	
 	OID__NR
 };
 
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index 70ad463f6df0..9361711897ce 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -72,5 +72,5 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 		return -EBADMSG;
 	}
 
-	return system_verify_data(mod, modlen, mod + modlen, sig_len);
+	return system_verify_data(mod, modlen, mod + modlen, sig_len, NULL);
 }
diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
index 95f2dcbc7616..cc2d648d1916 100644
--- a/kernel/system_keyring.c
+++ b/kernel/system_keyring.c
@@ -113,11 +113,14 @@ late_initcall(load_system_certificate_list);
  * @len: Size of @data.
  * @raw_pkcs7: The PKCS#7 message that is the signature.
  * @pkcs7_len: The size of @raw_pkcs7.
+ * @firmware_name: The required firmware name or NULL.
  */
 int system_verify_data(const void *data, unsigned long len,
-		       const void *raw_pkcs7, size_t pkcs7_len)
+		       const void *raw_pkcs7, size_t pkcs7_len,
+		       const char *firmware_name)
 {
 	struct pkcs7_message *pkcs7;
+	const char *p7_firmware_name;
 	bool trusted;
 	int ret;
 
@@ -125,6 +128,27 @@ int system_verify_data(const void *data, unsigned long len,
 	if (IS_ERR(pkcs7))
 		return PTR_ERR(pkcs7);
 
+	ret = -EINVAL;
+	p7_firmware_name = pkcs7_get_firmware_name(pkcs7);
+	if (firmware_name) {
+		if (!p7_firmware_name) {
+			pr_err("Expected name '%s' in firmware signature but not present\n",
+			       firmware_name);
+			goto error;
+		}
+		if (strcmp(p7_firmware_name, firmware_name) != 0) {
+			pr_err("Expected name '%s' in firmware signature but got '%s'\n",
+			       firmware_name, p7_firmware_name);
+			goto error;
+		}
+	} else {
+		if (p7_firmware_name) {
+			pr_err("Unexpected firmware name in signature '%s'\n",
+			       p7_firmware_name);
+			goto error;
+		}
+	}
+	
 	/* The data should be detached - so we need to supply it. */
 	if (pkcs7_supply_detached_data(pkcs7, data, len) < 0) {
 		pr_err("PKCS#7 signature with non-detached data\n");
diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index ad0aa21bd3ac..c07af47fa57a 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -43,6 +43,8 @@ void format(void)
 {
 	fprintf(stderr,
 		"Usage: scripts/sign-file [-dp] <hash algo> <key> <x509> <module> [<dest>]\n");
+	fprintf(stderr,
+		"       scripts/sign-file [-dp] -F <firmware name> <hash algo> <key> <x509> <firmware> [<dest>]\n");
 	exit(2);
 }
 
@@ -105,12 +107,14 @@ static int pem_pw_cb(char *buf, int len, int w, void *v)
 int main(int argc, char **argv)
 {
 	struct module_signature sig_info = { .id_type = PKEY_ID_PKCS7 };
+	const char *firmware_name = NULL;
 	char *hash_algo = NULL;
 	char *private_key_name, *x509_name, *module_name, *dest_name;
 	bool save_pkcs7 = false, replace_orig;
 	bool sign_only = false;
 	unsigned char buf[4096];
 	unsigned long module_size, pkcs7_size;
+	PKCS7_SIGNER_INFO *signer;
 	const EVP_MD *digest_algo;
 	EVP_PKEY *private_key;
 	PKCS7 *pkcs7;
@@ -125,10 +129,11 @@ int main(int argc, char **argv)
 	key_pass = getenv("KBUILD_SIGN_PIN");
 
 	do {
-		opt = getopt(argc, argv, "dp");
+		opt = getopt(argc, argv, "dpF:");
 		switch (opt) {
 		case 'p': save_pkcs7 = true; break;
 		case 'd': sign_only = true; save_pkcs7 = true; break;
+		case 'F': firmware_name = optarg; break;
 		case -1: break;
 		default: format();
 		}
@@ -213,8 +218,28 @@ int main(int argc, char **argv)
 			   PKCS7_NOCERTS | PKCS7_PARTIAL | PKCS7_BINARY | PKCS7_DETACHED | PKCS7_STREAM);
 	ERR(!pkcs7, "PKCS7_sign");
 
-	ERR(!PKCS7_sign_add_signer(pkcs7, x509, private_key, digest_algo, PKCS7_NOCERTS | PKCS7_BINARY),
-	    "PKCS7_sign_add_signer");
+	signer = PKCS7_sign_add_signer(pkcs7, x509, private_key, digest_algo, PKCS7_NOCERTS | PKCS7_BINARY);
+	ERR(!signer, "PKCS7_sign_add_signer");
+
+	if (firmware_name) {
+		/* Add an entry into the authenticated attributes to note the
+		 * firmware name if this is a firmware signature.
+		 */
+		ASN1_UTF8STRING *str;
+		int nid;
+
+		// As an example, use an OID of redhat.99.1 - which is not assigned
+		nid = OBJ_create("1.3.6.1.4.1.2312.99.1", NULL, NULL);
+		ERR(!nid, "OBJ_create");
+
+		str = M_ASN1_UTF8STRING_new();
+		ERR(!str, "M_ASN1_UTF8STRING_new");
+		ERR(!ASN1_STRING_set(str, firmware_name, strlen(firmware_name)),
+		    "ASN1_STRING_set");
+		ERR(!PKCS7_add_signed_attribute(signer, nid, V_ASN1_UTF8STRING, str),
+		    "PKCS7_add_signed_attribute");
+	}
+
 	ERR(PKCS7_final(pkcs7, bm, PKCS7_NOCERTS | PKCS7_BINARY) < 0,
 	    "PKCS7_final");
 
