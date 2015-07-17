Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbbGQQUL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:20:11 -0400
Subject: [PATCH 26/27] PKCS#7: Add an optional authenticated attribute to
 hold firmware name
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:20:03 +0100
Message-ID: <20150717162003.2578.69528.stgit@warthog.procyon.org.uk> (sfid-20150717_182059_329951_907773E5)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

The kernel then parses this out, saves the string and makes sure the same
string (or lack thereof) is present from all signers.  Then when
system_verify_data() is called, it is passed a NULL if the attribute is
expected not to be present and the name from request_firmware() if it is
expected to be present.  Verification is rejected if there's a mismatch.

I have allocated an type OID for this attribute from Red Hat OID space:

	1.3.6.1.4.1.2312.16	Linux kernel
	1.3.6.1.4.1.2312.16.2	- PKCS#7/CMS SignerInfo attribute types
	1.3.6.1.4.1.2312.16.2.1	  - firmwareName

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_parser.c |   77 +++++++++++++++++++++++++++++++++
 crypto/asymmetric_keys/pkcs7_parser.h |    1 
 include/crypto/pkcs7.h                |    1 
 include/keys/system_keyring.h         |    3 +
 include/linux/oid_registry.h          |    3 +
 kernel/module_signing.c               |    2 -
 kernel/system_keyring.c               |   26 +++++++++++
 scripts/sign-file.c                   |   39 +++++++++++++++--
 8 files changed, 144 insertions(+), 8 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 826e2f3f507b..e644e991a1e7 100644
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
@@ -76,6 +84,7 @@ void pkcs7_free_message(struct pkcs7_message *pkcs7)
 			pkcs7->signed_infos = sinfo->next;
 			pkcs7_free_signed_info(sinfo);
 		}
+		kfree(pkcs7->firmware_name);
 		kfree(pkcs7);
 	}
 }
@@ -407,6 +416,8 @@ int pkcs7_sig_note_authenticated_attr(void *context, size_t hdrlen,
 				      const void *value, size_t vlen)
 {
 	struct pkcs7_parse_context *ctx = context;
+	char *p;
+	int i;
 
 	pr_devel("AuthAttr: %02x %zu [%*ph]\n", tag, vlen, (unsigned)vlen, value);
 
@@ -417,6 +428,45 @@ int pkcs7_sig_note_authenticated_attr(void *context, size_t hdrlen,
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
@@ -431,12 +481,39 @@ int pkcs7_sig_note_set_of_authattrs(void *context, size_t hdrlen,
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
index 790dd7cec82c..44422fe61d78 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -52,6 +52,7 @@ struct pkcs7_message {
 	struct x509_certificate *certs;	/* Certificate list */
 	struct x509_certificate *crl;	/* Revocation list */
 	struct pkcs7_signed_info *signed_infos;
+	char		*firmware_name;	/* Firmware name if present */
 	u8		version;	/* Version of cert (1 -> PKCS#7 or CMS; 3 -> CMS) */
 
 	/* Content Data (or NULL) */
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
index 1af63a2616a8..cf7b94873748 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -93,6 +93,9 @@ enum OID {
 	OID_moduleSigningOnlyKey,	/* 1.3.6.1.4.1.2312.16.1.2 */
 	OID_kexecSigningOnlyKey,	/* 1.3.6.1.4.1.2312.16.1.3 */
 
+	/* Red Hat-space kernel OIDs for PKCS#7/CMS attributes */
+	OID_firmwareName,		/* 1.3.6.1.4.1.2312.16.2.1 */
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
index 95f2dcbc7616..ccb2814f89c1 100644
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
index de213e5c0cd3..bdac3a745865 100755
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
 
@@ -105,6 +107,7 @@ static int pem_pw_cb(char *buf, int len, int w, void *v)
 int main(int argc, char **argv)
 {
 	struct module_signature sig_info = { .id_type = PKEY_ID_PKCS7 };
+	const char *firmware_name = NULL;
 	char *hash_algo = NULL;
 	char *private_key_name, *x509_name, *module_name, *dest_name;
 	bool save_cms = false, replace_orig;
@@ -112,6 +115,7 @@ int main(int argc, char **argv)
 	unsigned char buf[4096];
 	unsigned long module_size, cms_size;
 	unsigned int use_keyid = 0;
+	CMS_SignerInfo *signer;
 	const EVP_MD *digest_algo;
 	EVP_PKEY *private_key;
 	CMS_ContentInfo *cms;
@@ -126,11 +130,12 @@ int main(int argc, char **argv)
 	key_pass = getenv("KBUILD_SIGN_PIN");
 
 	do {
-		opt = getopt(argc, argv, "dpk");
+		opt = getopt(argc, argv, "dpkF:");
 		switch (opt) {
 		case 'p': save_cms = true; break;
 		case 'd': sign_only = true; save_cms = true; break;
 		case 'k': use_keyid = CMS_USE_KEYID; break;
+		case 'F': firmware_name = optarg; break;
 		case -1: break;
 		default: format();
 		}
@@ -212,12 +217,36 @@ int main(int argc, char **argv)
 
 	/* Load the CMS message from the digest buffer. */
 	cms = CMS_sign(NULL, NULL, NULL, NULL,
-		       CMS_NOCERTS | CMS_PARTIAL | CMS_BINARY | CMS_DETACHED | CMS_STREAM);
+		       CMS_NOCERTS | CMS_PARTIAL | CMS_BINARY |
+		       CMS_DETACHED | CMS_STREAM);
 	ERR(!cms, "CMS_sign");
 
-	ERR(!CMS_add1_signer(cms, x509, private_key, digest_algo,
-			     CMS_NOCERTS | CMS_BINARY | CMS_NOSMIMECAP | use_keyid),
-	    "CMS_sign_add_signer");
+	signer = CMS_add1_signer(cms, x509, private_key, digest_algo,
+				 CMS_NOCERTS | CMS_BINARY | CMS_NOSMIMECAP |
+				 use_keyid);
+	ERR(!signer, "CMS_sign_add_signer");
+
+	if (firmware_name) {
+		/* Add an entry into the authenticated attributes to note the
+		 * firmware name if this is a firmware signature.
+		 */
+		ASN1_UTF8STRING *str;
+		X509_ATTRIBUTE *attr;
+		int nid;
+
+		nid = OBJ_create("1.3.6.1.4.1.2312.16.2.1", NULL, NULL);
+		ERR(!nid, "OBJ_create");
+
+		str = M_ASN1_UTF8STRING_new();
+		ERR(!str, "M_ASN1_UTF8STRING_new");
+		ERR(!ASN1_STRING_set(str, firmware_name, strlen(firmware_name)),
+		    "ASN1_STRING_set");
+		attr = X509_ATTRIBUTE_create(nid, V_ASN1_UTF8STRING, str);
+		ERR(!attr, "X509_ATTRIBUTE_create");
+		ERR(!CMS_signed_add1_attr(signer, attr),
+		    "CMS_signed_add1_attr");
+	}
+
 	ERR(CMS_final(cms, bm, NULL, CMS_NOCERTS | CMS_BINARY) < 0,
 	    "CMS_final");
 

