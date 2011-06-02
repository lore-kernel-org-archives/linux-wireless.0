Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51475 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab1FBQbV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:31:21 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] compat: add support for kernel 3.0
Date: Thu,  2 Jun 2011 18:31:01 +0200
Message-Id: <1307032264-14663-2-git-send-email-hauke@hauke-m.de> (sfid-20110602_183124_866581_CD31D52E)
In-Reply-To: <1307032264-14663-1-git-send-email-hauke@hauke-m.de>
References: <1307032264-14663-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel 2.6.40 is now 3.0. The br_port_exists() is function is not in
3.0 yet, so it should go to compat-3.1.h

Add to compat-3.0-stable

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.40.h |   29 -----------------------------
 include/linux/compat-2.6.h    |    2 +-
 include/linux/compat-3.1.h    |   27 +++++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 30 deletions(-)
 delete mode 100644 include/linux/compat-2.6.40.h
 create mode 100644 include/linux/compat-3.1.h

diff --git a/include/linux/compat-2.6.40.h b/include/linux/compat-2.6.40.h
deleted file mode 100644
index b3fc8f7..0000000
--- a/include/linux/compat-2.6.40.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef LINUX_26_40_COMPAT_H
-#define LINUX_26_40_COMPAT_H
-
-#include <linux/version.h>
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40))
-
-#include <linux/rcupdate.h>
-
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
-#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40)) */
-
-#endif /* LINUX_26_40_COMPAT_H */
diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index 8e45fc0..893a159 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -32,6 +32,6 @@
 #include <linux/compat-2.6.37.h>
 #include <linux/compat-2.6.38.h>
 #include <linux/compat-2.6.39.h>
-#include <linux/compat-2.6.40.h>
+#include <linux/compat-3.1.h>
 
 #endif /* LINUX_26_COMPAT_H */
diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
new file mode 100644
index 0000000..855490e
--- /dev/null
+++ b/include/linux/compat-3.1.h
@@ -0,0 +1,27 @@
+#ifndef LINUX_3_1_COMPAT_H
+#define LINUX_3_1_COMPAT_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0))
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
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)) */
+
+#endif /* LINUX_3_1_COMPAT_H */
-- 
1.7.4.1

