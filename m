Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46367 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1HOScz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 14:32:55 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: add support for linux 3.1
Date: Mon, 15 Aug 2011 20:32:50 +0200
Message-Id: <1313433170-31172-1-git-send-email-hauke@hauke-m.de> (sfid-20110815_203258_608764_0760D4C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

br_port_exists is not in mainline, will it ever?

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.h |    1 +
 include/linux/compat-3.1.h |   17 -----------------
 include/linux/compat-3.2.h |   27 +++++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/compat-3.2.h

diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index e4ca6aa..d933602 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -34,5 +34,6 @@
 #include <linux/compat-2.6.39.h>
 #include <linux/compat-3.0.h>
 #include <linux/compat-3.1.h>
+#include <linux/compat-3.2.h>
 
 #endif /* LINUX_26_COMPAT_H */
diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index cff6521..93bb1f6 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -5,23 +5,6 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0))
 
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
 #define genl_dump_check_consistent(cb, user_hdr, family)
 
 #define IFF_TX_SKB_SHARING	0x10000	/* The interface supports sharing
diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
new file mode 100644
index 0000000..9cba461
--- /dev/null
+++ b/include/linux/compat-3.2.h
@@ -0,0 +1,27 @@
+#ifndef LINUX_3_2_COMPAT_H
+#define LINUX_3_2_COMPAT_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0))
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
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)) */
+
+#endif /* LINUX_3_2_COMPAT_H */
-- 
1.7.4.1

