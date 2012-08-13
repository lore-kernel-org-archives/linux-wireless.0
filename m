Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45428 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab2HMT7M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 15:59:12 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: add tty_{un}lock() for kernel < 3.7
Date: Mon, 13 Aug 2012 21:59:01 +0200
Message-Id: <1344887941-18365-1-git-send-email-hauke@hauke-m.de> (sfid-20120813_215916_898912_7ADD3FC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The change of tty_{un}lock() in kernel 3.5 was reverted, but now it was
added again for kernel 3.7.

This patch does the needed changes to backport this commit:
commit 89c8d91e31f267703e365593f6bfebb9f6d2ad01
Author: Alan Cox <alan@linux.intel.com>
Date:   Wed Aug 8 16:30:13 2012 +0100

    tty: localise the lock

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.5.h |    5 -----
 include/linux/compat-3.7.h |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index 3aec3bd..9cffead 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -239,11 +239,6 @@ struct tc_fq_codel_xstats {
 };
 #endif /* TCA_CODEL_MAX */
 
-
-/* Backports tty_lock: Localise the lock */
-#define tty_lock(__tty) tty_lock()
-#define tty_unlock(__tty) tty_unlock()
-
 /* Backport ether_addr_equal */
 static inline bool ether_addr_equal(const u8 *addr1, const u8 *addr2)
 {
diff --git a/include/linux/compat-3.7.h b/include/linux/compat-3.7.h
index e113e80..9271c2e 100644
--- a/include/linux/compat-3.7.h
+++ b/include/linux/compat-3.7.h
@@ -6,10 +6,15 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,7,0))
 
 #include <linux/workqueue.h>
+#include <linux/tty.h>
 
 bool mod_delayed_work(struct workqueue_struct *wq, struct delayed_work *dwork,
 		      unsigned long delay);
 
+/* Backports tty_lock: Localise the lock */
+#define tty_lock(__tty) tty_lock()
+#define tty_unlock(__tty) tty_unlock()
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,7,0)) */
 
 #endif /* LINUX_3_7_COMPAT_H */
-- 
1.7.9.5

