Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52571 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab1BAVEW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 16:04:22 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: add support for kernel 2.6.38
Date: Tue,  1 Feb 2011 22:04:13 +0100
Message-Id: <1296594253-21273-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1296594253-21273-1-git-send-email-hauke@hauke-m.de>
References: <1296594253-21273-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.38.h |   17 -----------------
 include/linux/compat-2.6.39.h |   27 +++++++++++++++++++++++++++
 include/linux/compat-2.6.h    |    1 +
 3 files changed, 28 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/compat-2.6.39.h

diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index 0521156..004fe27 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -8,23 +8,6 @@
 #include <linux/kernel.h>
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
 /* rename member in struct mmc_host in include/linux/mmc/host.h */
 #define max_segs	max_hw_segs
 
diff --git a/include/linux/compat-2.6.39.h b/include/linux/compat-2.6.39.h
new file mode 100644
index 0000000..c0c98fd
--- /dev/null
+++ b/include/linux/compat-2.6.39.h
@@ -0,0 +1,27 @@
+#ifndef LINUX_26_39_COMPAT_H
+#define LINUX_26_39_COMPAT_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39))
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
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)) */
+
+#endif /* LINUX_26_39_COMPAT_H */
diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index 2706797..478f833 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -31,5 +31,6 @@
 #include <linux/compat-2.6.36.h>
 #include <linux/compat-2.6.37.h>
 #include <linux/compat-2.6.38.h>
+#include <linux/compat-2.6.39.h>
 
 #endif /* LINUX_26_COMPAT_H */
-- 
1.7.1

