Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49670 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdJMK2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 06:28:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] backports: remove CRYPTO_CCM backport
Date: Fri, 13 Oct 2017 12:28:18 +0200
Message-Id: <20171013102818.26226-1-johannes@sipsolutions.net> (sfid-20171013_122827_605829_EB6C540D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This never actually worked properly as far as I can tell,
and now it looks like it won't even compile due to the
real crypto_memneq() backport.

Just remove it - distro kernels have it enabled and all
others should just enable it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 backport/compat/Kconfig     | 11 -------
 backport/compat/Makefile    |  1 -
 backport/compat/backports.h | 10 ------
 backport/compat/main.c      |  9 +-----
 patches/crypto-ccm.patch    | 78 ---------------------------------------------
 5 files changed, 1 insertion(+), 108 deletions(-)
 delete mode 100644 patches/crypto-ccm.patch

diff --git a/backport/compat/Kconfig b/backport/compat/Kconfig
index 542cf0cca781..492efbfc7d9f 100644
--- a/backport/compat/Kconfig
+++ b/backport/compat/Kconfig
@@ -102,17 +102,6 @@ config BPAUTO_USERSEL_BUILD_ALL
 	  It's only really useful for compat testing, so
 	  you probably shouldn't enable it.
 
-config BPAUTO_CRYPTO_CCM
-	depends on CRYPTO_AEAD
-	depends on CRYPTO_CTR
-	bool
-
-config BPAUTO_BUILD_CRYPTO_CCM
-	bool
-	default n if CRYPTO_CCM
-	default y if BPAUTO_CRYPTO_CCM
-	#c-file crypto/ccm.c
-
 config BPAUTO_CRYPTO_SKCIPHER
 	tristate
 	depends on KERNEL_4_3
diff --git a/backport/compat/Makefile b/backport/compat/Makefile
index ead22a0099fc..69cfd514da71 100644
--- a/backport/compat/Makefile
+++ b/backport/compat/Makefile
@@ -37,7 +37,6 @@ compat-$(CPTCFG_KERNEL_4_7) += backport-4.7.o
 compat-$(CPTCFG_KERNEL_4_8) += backport-4.8.o
 compat-$(CPTCFG_KERNEL_4_10) += backport-4.10.o
 
-compat-$(CPTCFG_BPAUTO_BUILD_CRYPTO_CCM) += crypto-ccm.o
 compat-$(CPTCFG_BPAUTO_CRYPTO_SKCIPHER) += crypto-skcipher.o
 
 compat-$(CPTCFG_BPAUTO_BUILD_SYSTEM_DATA_VERIFICATION) += verification/verify.o
diff --git a/backport/compat/backports.h b/backport/compat/backports.h
index ccc8972b41f6..538488887fca 100644
--- a/backport/compat/backports.h
+++ b/backport/compat/backports.h
@@ -3,16 +3,6 @@
 
 #include <linux/version.h>
 
-#ifdef CPTCFG_BPAUTO_BUILD_CRYPTO_CCM
-int crypto_ccm_module_init(void);
-void crypto_ccm_module_exit(void);
-#else
-static inline int crypto_ccm_module_init(void)
-{ return 0; }
-static inline void crypto_ccm_module_exit(void)
-{}
-#endif
-
 #ifdef CPTCFG_BPAUTO_BUILD_WANT_DEV_COREDUMP
 int devcoredump_init(void);
 void devcoredump_exit(void);
diff --git a/backport/compat/main.c b/backport/compat/main.c
index 5d45e3dad3e3..0bf04201a0bd 100644
--- a/backport/compat/main.c
+++ b/backport/compat/main.c
@@ -53,16 +53,10 @@ EXPORT_SYMBOL_GPL(backport_dependency_symbol);
 
 static int __init backport_init(void)
 {
-	int ret = crypto_ccm_module_init();
+	int ret = devcoredump_init();
 	if (ret)
 		return ret;
 
-	ret = devcoredump_init();
-	if (ret) {
-		crypto_ccm_module_exit();
-		return ret;
-	}
-
 	printk(KERN_INFO "Loading modules backported from " CPTCFG_KERNEL_NAME
 #ifndef BACKPORTS_GIT_TRACKED
 		" version " CPTCFG_KERNEL_VERSION
@@ -86,7 +80,6 @@ subsys_initcall(backport_init);
 
 static void __exit backport_exit(void)
 {
-	crypto_ccm_module_exit();
 	devcoredump_exit();
 }
 module_exit(backport_exit);
diff --git a/patches/crypto-ccm.patch b/patches/crypto-ccm.patch
deleted file mode 100644
index 2136689eca91..000000000000
--- a/patches/crypto-ccm.patch
+++ /dev/null
@@ -1,78 +0,0 @@
---- a/compat/crypto-ccm.c
-+++ b/compat/crypto-ccm.c
-@@ -14,13 +14,44 @@
- #include <crypto/internal/hash.h>
- #include <crypto/internal/skcipher.h>
- #include <crypto/scatterwalk.h>
-+#include <crypto/algapi.h>
- #include <linux/err.h>
- #include <linux/init.h>
- #include <linux/kernel.h>
- #include <linux/module.h>
- #include <linux/slab.h>
-+#include <linux/version.h>
- 
--#include "internal.h"
-+#if LINUX_VERSION_IS_LESS(3,13,0)
-+/* consider properly backporting this? */
-+static int crypto_memneq(const void *a, const void *b, size_t size)
-+{
-+	unsigned long neq = 0;
-+
-+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-+	while (size >= sizeof(unsigned long)) {
-+		neq |= *(unsigned long *)a ^ *(unsigned long *)b;
-+		/* OPTIMIZER_HIDE_VAR(neq); */
-+		barrier();
-+		a += sizeof(unsigned long);
-+		b += sizeof(unsigned long);
-+		size -= sizeof(unsigned long);
-+	}
-+#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
-+	while (size > 0) {
-+		neq |= *(unsigned char *)a ^ *(unsigned char *)b;
-+		/* OPTIMIZER_HIDE_VAR(neq); */
-+		barrier();
-+		a += 1;
-+		b += 1;
-+		size -= 1;
-+	}
-+	return neq != 0UL ? 1 : 0;
-+}
-+#endif
-+
-+/* from internal.h */
-+struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
- 
- struct ccm_instance_ctx {
- 	struct crypto_skcipher_spawn ctr;
-@@ -1001,7 +1032,7 @@ static struct crypto_template crypto_cbc
- 	.module = THIS_MODULE,
- };
- 
--static int __init crypto_ccm_module_init(void)
-+int __init crypto_ccm_module_init(void)
- {
- 	int err;
- 
-@@ -1033,19 +1064,10 @@ out_undo_cbcmac:
- 	goto out;
- }
- 
--static void __exit crypto_ccm_module_exit(void)
-+void __exit crypto_ccm_module_exit(void)
- {
- 	crypto_unregister_template(&crypto_rfc4309_tmpl);
- 	crypto_unregister_template(&crypto_ccm_tmpl);
- 	crypto_unregister_template(&crypto_ccm_base_tmpl);
- 	crypto_unregister_template(&crypto_cbcmac_tmpl);
- }
--
--module_init(crypto_ccm_module_init);
--module_exit(crypto_ccm_module_exit);
--
--MODULE_LICENSE("GPL");
--MODULE_DESCRIPTION("Counter with CBC MAC");
--MODULE_ALIAS_CRYPTO("ccm_base");
--MODULE_ALIAS_CRYPTO("rfc4309");
--MODULE_ALIAS_CRYPTO("ccm");
-- 
2.14.2
