Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39318 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924Ab2DZSIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:19 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC c 3/9] compat: move br_port_exists
Date: Thu, 26 Apr 2012 20:07:46 +0200
Message-Id: <1335463674-13003-6-git-send-email-hauke@hauke-m.de> (sfid-20120426_200825_608498_28D7D424)
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.36.h |   17 -----------------
 include/linux/if.h            |   28 ++++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/if.h

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 8f6ecc4..833143e 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -179,23 +179,6 @@ extern unsigned int work_busy(struct work_struct *work);
 #define schedule_delayed_work_on(cpu, dwork, delay) compat_schedule_delayed_work_on(cpu, dwork, delay)
 #define flush_scheduled_work(a) compat_flush_scheduled_work(a)
 
-#define br_port_exists(dev)	(dev->br_port)
-
-#else
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
-#define br_port_exists(dev)	(dev->priv_flags & IFF_BRIDGE_PORT)
-
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
diff --git a/include/linux/if.h b/include/linux/if.h
new file mode 100644
index 0000000..64cd9e7
--- /dev/null
+++ b/include/linux/if.h
@@ -0,0 +1,28 @@
+#ifndef _COMPAT_LINUX_IF_H
+#define _COMPAT_LINUX_IF_H
+
+#include_next <linux/if.h>
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36))
+
+#define br_port_exists(dev)	(dev->br_port)
+
+#else
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
+#define br_port_exists(dev)	(dev->priv_flags & IFF_BRIDGE_PORT)
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
+#endif	/* _COMPAT_LINUX_IF_H */
-- 
1.7.9.5

