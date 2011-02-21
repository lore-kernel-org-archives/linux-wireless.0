Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55248 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1BUWcd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 17:32:33 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat: backport tty_{lock,unlock,locked}
Date: Mon, 21 Feb 2011 23:32:23 +0100
Message-Id: <1298327544-18943-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1298327544-18943-1-git-send-email-hauke@hauke-m.de>
References: <1298327544-18943-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.36.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 74d2309..0e3b774 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -9,6 +9,7 @@
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
 #include <linux/pm_qos_params.h>
+#include <linux/smp_lock.h>
 
 #define kparam_block_sysfs_write(a)
 #define kparam_unblock_sysfs_write(a)
@@ -101,6 +102,23 @@ int no_printk(const char *s, ...) { return 0; }
 #define alloc_workqueue(name, flags, max_active) __create_workqueue(name, flags, max_active, 0)
 #endif
 
+#define EXTPROC	0200000
+#define TIOCPKT_IOCTL		64
+
+static inline void tty_lock(void) __acquires(kernel_lock)
+{
+#ifdef CONFIG_LOCK_KERNEL
+	/* kernel_locked is 1 for !CONFIG_LOCK_KERNEL */
+	WARN_ON(kernel_locked());
+#endif
+	lock_kernel();
+}
+static inline void tty_unlock(void) __releases(kernel_lock)
+{
+	unlock_kernel();
+}
+#define tty_locked()           (kernel_locked())
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.1

