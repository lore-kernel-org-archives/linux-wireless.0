Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54558 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0FFJMi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 05:12:38 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] compat: move kparam_{block,unblock}_sysfs_write
Date: Sun,  6 Jun 2010 11:12:25 +0200
Message-Id: <1275815547-30313-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1275815547-30313-1-git-send-email-hauke@hauke-m.de>
References: <1275815547-30313-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kparam_block_sysfs_write and kparam_unblock_sysfs_write are not in
kernel 2.6.35, move them to backport from kernel 2.6.36.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.35.h |    3 ---
 include/linux/compat-2.6.36.h |   13 +++++++++++++
 include/linux/compat-2.6.h    |    1 +
 3 files changed, 14 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/compat-2.6.36.h

diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index b38d6de..886815d 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -23,9 +23,6 @@ static inline wait_queue_head_t *sk_sleep(struct sock *sk)
 	return sk->sk_sleep;
 }
 
-#define kparam_block_sysfs_write(a)
-#define kparam_unblock_sysfs_write(a)
-
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
 
 #endif /* LINUX_26_35_COMPAT_H */
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
new file mode 100644
index 0000000..0307108
--- /dev/null
+++ b/include/linux/compat-2.6.36.h
@@ -0,0 +1,13 @@
+#ifndef LINUX_26_36_COMPAT_H
+#define LINUX_26_36_COMPAT_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36))
+
+#define kparam_block_sysfs_write(a)
+#define kparam_unblock_sysfs_write(a)
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
+
+#endif /* LINUX_26_36_COMPAT_H */
diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index 6171cd9..ef51195 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -28,5 +28,6 @@
 #include <linux/compat-2.6.33.h>
 #include <linux/compat-2.6.34.h>
 #include <linux/compat-2.6.35.h>
+#include <linux/compat-2.6.36.h>
 
 #endif /* LINUX_26_COMPAT_H */
-- 
1.7.0.4

