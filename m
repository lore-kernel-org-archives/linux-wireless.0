Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49520 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0KET1N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 15:27:13 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: fix build with kernel 2.6.37rc1
Date: Fri,  5 Nov 2010 20:27:02 +0100
Message-Id: <1288985223-30264-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some backports are also needed when compiling against kernel 2.6.37.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.37.h |   20 --------------------
 include/linux/compat-2.6.38.h |   30 ++++++++++++++++++++++++++++++
 include/linux/compat-2.6.h    |    1 +
 3 files changed, 31 insertions(+), 20 deletions(-)
 create mode 100644 include/linux/compat-2.6.38.h

diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index 716f528..6c026a3 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -7,23 +7,6 @@
 
 #include <linux/skbuff.h>
 
-/*
- * This is not part of The 2.6.37 kernel yet but we
- * we use it to optimize the backport code we
- * need to implement. Instead of using ifdefs
- * to check what version of the check we use
- * we just replace all checks on current code
- * with this. I'll submit this upstream too, that
- * way all we'd have to do is to implement this
- * for older kernels, then we would not have to
- * edit the upstrema code for backport efforts.
- */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
-#define br_port_exists(dev)	(dev->priv_flags & IFF_BRIDGE_PORT)
-#else
-#define br_port_exists(dev)	(dev->br_port)
-#endif
-
 #define SDIO_CLASS_BT_AMP	0x09	/* Type-A Bluetooth AMP interface */
 
 extern struct kobj_ns_type_operations net_ns_type_operations;
@@ -110,9 +93,6 @@ int genl_unregister_family(struct genl_family *family);
 #define genl_register_mc_group(_fam, _grp) genl_register_mc_group(&(_fam)->family, _grp)
 #define genl_unregister_mc_group(_fam, _grp) genl_unregister_mc_group(&(_fam)->family, _grp)
 
-/* rename member in struct mmc_host in include/linux/mmc/host.h */
-#define max_segs	max_hw_segs
-
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)) */
 
 #endif /* LINUX_26_37_COMPAT_H */
diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
new file mode 100644
index 0000000..fa77a89
--- /dev/null
+++ b/include/linux/compat-2.6.38.h
@@ -0,0 +1,30 @@
+#ifndef LINUX_26_38_COMPAT_H
+#define LINUX_26_38_COMPAT_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38))
+
+/*
+ * This is not part of The 2.6.37 kernel yet but we
+ * we use it to optimize the backport code we
+ * need to implement. Instead of using ifdefs
+ * to check what version of the check we use
+ * we just replace all checks on current code
+ * with this. I'll submit this upstream too, that
+ * way all we'd have to do is to implement this
+ * for older kernels, then we would not have to
+ * edit the upstrema code for backport efforts.
+ */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+#define br_port_exists(dev)	(dev->priv_flags & IFF_BRIDGE_PORT)
+#else
+#define br_port_exists(dev)	(dev->br_port)
+#endif
+
+/* rename member in struct mmc_host in include/linux/mmc/host.h */
+#define max_segs	max_hw_segs
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38)) */
+
+#endif /* LINUX_26_38_COMPAT_H */
diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index 25490f2..2706797 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -30,5 +30,6 @@
 #include <linux/compat-2.6.35.h>
 #include <linux/compat-2.6.36.h>
 #include <linux/compat-2.6.37.h>
+#include <linux/compat-2.6.38.h>
 
 #endif /* LINUX_26_COMPAT_H */
-- 
1.7.1

