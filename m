Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58883 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758329Ab1CaQVv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:21:51 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] compat: add support for kernel 2.6.39
Date: Thu, 31 Mar 2011 18:21:33 +0200
Message-Id: <1301588495-16583-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1301588495-16583-1-git-send-email-hauke@hauke-m.de>
References: <1301588495-16583-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.39.h |   17 -----------------
 include/linux/compat-2.6.40.h |   27 +++++++++++++++++++++++++++
 include/linux/compat-2.6.h    |    1 +
 3 files changed, 28 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/compat-2.6.40.h

diff --git a/include/linux/compat-2.6.39.h b/include/linux/compat-2.6.39.h
index bf4442b..2c62d90 100644
--- a/include/linux/compat-2.6.39.h
+++ b/include/linux/compat-2.6.39.h
@@ -8,23 +8,6 @@
 #include <linux/tty.h>
 #include <linux/irq.h>
 
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
 #define tiocmget(tty) tiocmget(tty, NULL)
 #define tiocmset(tty, set, clear) tiocmset(tty, NULL, set, clear)
 
diff --git a/include/linux/compat-2.6.40.h b/include/linux/compat-2.6.40.h
new file mode 100644
index 0000000..42f9fee
--- /dev/null
+++ b/include/linux/compat-2.6.40.h
@@ -0,0 +1,27 @@
+#ifndef LINUX_26_40_COMPAT_H
+#define LINUX_26_40_COMPAT_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40))
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
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40)) */
+
+#endif /* LINUX_26_40_COMPAT_H */
diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index 478f833..8e45fc0 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -32,5 +32,6 @@
 #include <linux/compat-2.6.37.h>
 #include <linux/compat-2.6.38.h>
 #include <linux/compat-2.6.39.h>
+#include <linux/compat-2.6.40.h>
 
 #endif /* LINUX_26_COMPAT_H */
-- 
1.7.1

