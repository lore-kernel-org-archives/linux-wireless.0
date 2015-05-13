Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33453 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbbEMSab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 14:30:31 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, jlee@suse.com, tiwai@suse.de,
	casey@schaufler-ca.com, keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>
Subject: [RFC v2 2/6] kernel: generalize module signing as system data signing
Date: Wed, 13 May 2015 11:23:52 -0700
Message-Id: <1431541436-17007-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20150513_203043_867169_6E43B790)
In-Reply-To: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
References: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This generalizes the module signing code as helpers, we do
this as we'll later re-use this same code for firmware and
other system data signing.

Acked-by: Rusty Russell <rusty@rustcorp.com.au> (module parts)
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Kyle McMartin <kyle@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 init/Kconfig                                     | 24 ++++++----
 kernel/Makefile                                  |  2 +-
 kernel/module.c                                  |  4 +-
 kernel/{module-internal.h => sysdata-internal.h} |  4 +-
 kernel/{module_signing.c => sysdata_signing.c}   | 58 ++++++++++++------------
 kernel/system_keyring.c                          |  2 +-
 6 files changed, 49 insertions(+), 45 deletions(-)
 rename kernel/{module-internal.h => sysdata-internal.h} (79%)
 rename kernel/{module_signing.c => sysdata_signing.c} (64%)

diff --git a/init/Kconfig b/init/Kconfig
index fb98cba..a75c587 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1793,6 +1793,19 @@ config BASE_SMALL
 	default 0 if BASE_FULL
 	default 1 if !BASE_FULL
 
+config SYSDATA_SIG
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
+
 menuconfig MODULES
 	bool "Enable loadable module support"
 	option modules
@@ -1866,16 +1879,7 @@ config MODULE_SRCVERSION_ALL
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
+	select SYSDATA_SIG
 	help
 	  Check modules for valid signatures upon load: the signature
 	  is simply appended to the module. For more information see
diff --git a/kernel/Makefile b/kernel/Makefile
index 60c302c..ed6a32b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -47,7 +47,7 @@ endif
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += system_keyring.o system_certificates.o
 obj-$(CONFIG_MODULES) += module.o
-obj-$(CONFIG_MODULE_SIG) += module_signing.o
+obj-$(CONFIG_SYSDATA_SIG) += sysdata_signing.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
diff --git a/kernel/module.c b/kernel/module.c
index 9e51b37..6a3f629 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -60,7 +60,7 @@
 #include <linux/pfn.h>
 #include <linux/bsearch.h>
 #include <uapi/linux/module.h>
-#include "module-internal.h"
+#include "sysdata-internal.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -2404,7 +2404,7 @@ static int module_sig_check(struct load_info *info)
 	    memcmp(mod + info->len - markerlen, MODULE_SIG_STRING, markerlen) == 0) {
 		/* We truncate the module to discard the signature */
 		info->len -= markerlen;
-		err = mod_verify_sig(mod, &info->len);
+		err = sysdata_verify_sig(mod, &info->len);
 	}
 
 	if (!err) {
diff --git a/kernel/module-internal.h b/kernel/sysdata-internal.h
similarity index 79%
rename from kernel/module-internal.h
rename to kernel/sysdata-internal.h
index 915e123..0aa573e 100644
--- a/kernel/module-internal.h
+++ b/kernel/sysdata-internal.h
@@ -1,4 +1,4 @@
-/* Module internals
+/* System Data internals
  *
  * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -9,4 +9,4 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
-extern int mod_verify_sig(const void *mod, unsigned long *_modlen);
+extern int sysdata_verify_sig(const void *data, unsigned long *_len);
diff --git a/kernel/module_signing.c b/kernel/sysdata_signing.c
similarity index 64%
rename from kernel/module_signing.c
rename to kernel/sysdata_signing.c
index 8eb20cc..adc44d4 100644
--- a/kernel/module_signing.c
+++ b/kernel/sysdata_signing.c
@@ -1,4 +1,4 @@
-/* Module signature checker
+/* System Data signature checker
  *
  * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -14,10 +14,10 @@
 #include <keys/system_keyring.h>
 #include <crypto/public_key.h>
 #include <crypto/pkcs7.h>
-#include "module-internal.h"
+#include "sysdata-internal.h"
 
 /*
- * Module signature information block.
+ * System Data signature information block.
  *
  * The constituents of the signature section are, in order:
  *
@@ -26,7 +26,7 @@
  *	- Signature data
  *	- Information block
  */
-struct module_signature {
+struct sysdata_signature {
 	u8	algo;		/* Public-key crypto algorithm [0] */
 	u8	hash;		/* Digest algorithm [0] */
 	u8	id_type;	/* Key identifier type [PKEY_ID_PKCS7] */
@@ -37,10 +37,10 @@ struct module_signature {
 };
 
 /*
- * Verify a PKCS#7-based signature on a module.
+ * Verify a PKCS#7-based signature on system data.
  */
-static int mod_verify_pkcs7(const void *mod, unsigned long modlen,
-			    const void *raw_pkcs7, size_t pkcs7_len)
+static int data_verify_pkcs7(const void *data, unsigned long len,
+			     const void *raw_pkcs7, size_t pkcs7_len)
 {
 	struct pkcs7_message *pkcs7;
 	bool trusted;
@@ -51,7 +51,7 @@ static int mod_verify_pkcs7(const void *mod, unsigned long modlen,
 		return PTR_ERR(pkcs7);
 
 	/* The data should be detached - so we need to supply it. */
-	if (pkcs7_supply_detached_data(pkcs7, mod, modlen) < 0) {
+	if (pkcs7_supply_detached_data(pkcs7, data, len) < 0) {
 		pr_err("PKCS#7 signature with non-detached data\n");
 		ret = -EBADMSG;
 		goto error;
@@ -77,42 +77,42 @@ error:
 }
 
 /*
- * Verify the signature on a module.
+ * Verify the signature on system data.
  */
-int mod_verify_sig(const void *mod, unsigned long *_modlen)
+int sysdata_verify_sig(const void *data, unsigned long *_len)
 {
-	struct module_signature ms;
-	size_t modlen = *_modlen, sig_len;
+	struct sysdata_signature ds;
+	size_t len = *_len, sig_len;
 
-	pr_devel("==>%s(,%zu)\n", __func__, modlen);
+	pr_devel("==>%s(,%zu)\n", __func__, len);
 
-	if (modlen <= sizeof(ms))
+	if (len <= sizeof(ds))
 		return -EBADMSG;
 
-	memcpy(&ms, mod + (modlen - sizeof(ms)), sizeof(ms));
-	modlen -= sizeof(ms);
+	memcpy(&ds, data + (len - sizeof(ds)), sizeof(ds));
+	len -= sizeof(ds);
 
-	sig_len = be32_to_cpu(ms.sig_len);
-	if (sig_len >= modlen)
+	sig_len = be32_to_cpu(ds.sig_len);
+	if (sig_len >= len)
 		return -EBADMSG;
-	modlen -= sig_len;
-	*_modlen = modlen;
+	len -= sig_len;
+	*_len = len;
 
-	if (ms.id_type != PKEY_ID_PKCS7) {
+	if (ds.id_type != PKEY_ID_PKCS7) {
 		pr_err("Module is not signed with expected PKCS#7 message\n");
 		return -ENOPKG;
 	}
 
-	if (ms.algo != 0 ||
-	    ms.hash != 0 ||
-	    ms.signer_len != 0 ||
-	    ms.key_id_len != 0 ||
-	    ms.__pad[0] != 0 ||
-	    ms.__pad[1] != 0 ||
-	    ms.__pad[2] != 0) {
+	if (ds.algo != 0 ||
+	    ds.hash != 0 ||
+	    ds.signer_len != 0 ||
+	    ds.key_id_len != 0 ||
+	    ds.__pad[0] != 0 ||
+	    ds.__pad[1] != 0 ||
+	    ds.__pad[2] != 0) {
 		pr_err("PKCS#7 signature info has unexpected non-zero params\n");
 		return -EBADMSG;
 	}
 
-	return mod_verify_pkcs7(mod, modlen, mod + modlen, sig_len);
+	return data_verify_pkcs7(data, len, data + len, sig_len);
 }
diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
index 875f64e..1eb0c86 100644
--- a/kernel/system_keyring.c
+++ b/kernel/system_keyring.c
@@ -16,7 +16,7 @@
 #include <linux/err.h>
 #include <keys/asymmetric-type.h>
 #include <keys/system_keyring.h>
-#include "module-internal.h"
+#include "sysdata-internal.h"
 
 struct key *system_trusted_keyring;
 EXPORT_SYMBOL_GPL(system_trusted_keyring);
-- 
2.3.2.209.gd67f9d5.dirty

