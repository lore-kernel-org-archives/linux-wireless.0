Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbbGQQQj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:16:39 -0400
Subject: [PATCH 08/27] MODSIGN: Extract the blob PKCS#7 signature verifier
 from module signing
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:16:33 +0100
Message-ID: <20150717161633.2578.77118.stgit@warthog.procyon.org.uk> (sfid-20150717_181655_355621_168C1306)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extract the function that drives the PKCS#7 signature verification given a
data blob and a PKCS#7 blob out from the module signing code and lump it with
the system keyring code as it's generic.  This makes it independent of module
config options and opens it to use by the firmware loader.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Luis R. Rodriguez <mcgrof@suse.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Kyle McMartin <kyle@kernel.org>
---

 include/keys/system_keyring.h |    5 ++++
 init/Kconfig                  |   29 ++++++++++++++++--------
 kernel/module_signing.c       |   44 +-----------------------------------
 kernel/system_keyring.c       |   50 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+), 53 deletions(-)

diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
index 72665eb80692..9791c907cdb7 100644
--- a/include/keys/system_keyring.h
+++ b/include/keys/system_keyring.h
@@ -28,4 +28,9 @@ static inline struct key *get_system_trusted_keyring(void)
 }
 #endif
 
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+extern int system_verify_data(const void *data, unsigned long len,
+			      const void *raw_pkcs7, size_t pkcs7_len);
+#endif
+
 #endif /* _KEYS_SYSTEM_KEYRING_H */
diff --git a/init/Kconfig b/init/Kconfig
index e16d9e587cee..14b3d8422502 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1752,6 +1752,24 @@ config SYSTEM_TRUSTED_KEYRING
 
 	  Keys in this keyring are used by module signature checking.
 
+config SYSTEM_DATA_VERIFICATION
+	def_bool n
+	select SYSTEM_TRUSTED_KEYRING
+	select KEYS
+	select CRYPTO
+	select ASYMMETRIC_KEY_TYPE
+	select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+	select PUBLIC_KEY_ALGO_RSA
+	select ASN1
+	select OID_REGISTRY
+	select X509_CERTIFICATE_PARSER
+	select PKCS7_MESSAGE_PARSER
+	help
+	  Provide PKCS#7 message verification using the contents of the system
+	  trusted keyring to provide public keys.  This then can be used for
+	  module verification, kexec image verification and firmware blob
+	  verification.
+
 config PROFILING
 	bool "Profiling support"
 	help
@@ -1860,16 +1878,7 @@ config MODULE_SRCVERSION_ALL
 config MODULE_SIG
 	bool "Module signature verification"
 	depends on MODULES
-	select SYSTEM_TRUSTED_KEYRING
-	select KEYS
-	select CRYPTO
-	select ASYMMETRIC_KEY_TYPE
-	select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
-	select PUBLIC_KEY_ALGO_RSA
-	select ASN1
-	select OID_REGISTRY
-	select X509_CERTIFICATE_PARSER
-	select PKCS7_MESSAGE_PARSER
+	select SYSTEM_DATA_VERIFICATION
 	help
 	  Check modules for valid signatures upon load: the signature
 	  is simply appended to the module. For more information see
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index 8eb20cc66b39..70ad463f6df0 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -10,10 +10,8 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/err.h>
 #include <keys/system_keyring.h>
 #include <crypto/public_key.h>
-#include <crypto/pkcs7.h>
 #include "module-internal.h"
 
 /*
@@ -37,46 +35,6 @@ struct module_signature {
 };
 
 /*
- * Verify a PKCS#7-based signature on a module.
- */
-static int mod_verify_pkcs7(const void *mod, unsigned long modlen,
-			    const void *raw_pkcs7, size_t pkcs7_len)
-{
-	struct pkcs7_message *pkcs7;
-	bool trusted;
-	int ret;
-
-	pkcs7 = pkcs7_parse_message(raw_pkcs7, pkcs7_len);
-	if (IS_ERR(pkcs7))
-		return PTR_ERR(pkcs7);
-
-	/* The data should be detached - so we need to supply it. */
-	if (pkcs7_supply_detached_data(pkcs7, mod, modlen) < 0) {
-		pr_err("PKCS#7 signature with non-detached data\n");
-		ret = -EBADMSG;
-		goto error;
-	}
-
-	ret = pkcs7_verify(pkcs7);
-	if (ret < 0)
-		goto error;
-
-	ret = pkcs7_validate_trust(pkcs7, system_trusted_keyring, &trusted);
-	if (ret < 0)
-		goto error;
-
-	if (!trusted) {
-		pr_err("PKCS#7 signature not signed with a trusted key\n");
-		ret = -ENOKEY;
-	}
-
-error:
-	pkcs7_free_message(pkcs7);
-	pr_devel("<==%s() = %d\n", __func__, ret);
-	return ret;
-}
-
-/*
  * Verify the signature on a module.
  */
 int mod_verify_sig(const void *mod, unsigned long *_modlen)
@@ -114,5 +72,5 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 		return -EBADMSG;
 	}
 
-	return mod_verify_pkcs7(mod, modlen, mod + modlen, sig_len);
+	return system_verify_data(mod, modlen, mod + modlen, sig_len);
 }
diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
index 4cda71ee51c7..95f2dcbc7616 100644
--- a/kernel/system_keyring.c
+++ b/kernel/system_keyring.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <keys/asymmetric-type.h>
 #include <keys/system_keyring.h>
+#include <crypto/pkcs7.h>
 
 struct key *system_trusted_keyring;
 EXPORT_SYMBOL_GPL(system_trusted_keyring);
@@ -103,3 +104,52 @@ dodgy_cert:
 	return 0;
 }
 late_initcall(load_system_certificate_list);
+
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+
+/**
+ * Verify a PKCS#7-based signature on system data.
+ * @data: The data to be verified.
+ * @len: Size of @data.
+ * @raw_pkcs7: The PKCS#7 message that is the signature.
+ * @pkcs7_len: The size of @raw_pkcs7.
+ */
+int system_verify_data(const void *data, unsigned long len,
+		       const void *raw_pkcs7, size_t pkcs7_len)
+{
+	struct pkcs7_message *pkcs7;
+	bool trusted;
+	int ret;
+
+	pkcs7 = pkcs7_parse_message(raw_pkcs7, pkcs7_len);
+	if (IS_ERR(pkcs7))
+		return PTR_ERR(pkcs7);
+
+	/* The data should be detached - so we need to supply it. */
+	if (pkcs7_supply_detached_data(pkcs7, data, len) < 0) {
+		pr_err("PKCS#7 signature with non-detached data\n");
+		ret = -EBADMSG;
+		goto error;
+	}
+
+	ret = pkcs7_verify(pkcs7);
+	if (ret < 0)
+		goto error;
+
+	ret = pkcs7_validate_trust(pkcs7, system_trusted_keyring, &trusted);
+	if (ret < 0)
+		goto error;
+
+	if (!trusted) {
+		pr_err("PKCS#7 signature not signed with a trusted key\n");
+		ret = -ENOKEY;
+	}
+
+error:
+	pkcs7_free_message(pkcs7);
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(system_verify_data);
+
+#endif /* CONFIG_SYSTEM_DATA_VERIFICATION */

