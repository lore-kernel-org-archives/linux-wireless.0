Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55255 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab1KFVZO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Nov 2011 16:25:14 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: backport system_nrt_wq
Date: Sun,  6 Nov 2011 22:25:03 +0100
Message-Id: <1320614704-28855-1-git-send-email-hauke@hauke-m.de> (sfid-20111106_222517_682756_776D17D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The workqueue system_nrt_wq is not available in kernel version < 2.6.36.
This backport code creates such a queue but this old kernel does not
have WQ_NON_REENTRANT, so we use a single threaded queue instead as it
should meat the same restrictions.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.36.c        |   15 +++++++++++++++
 compat/main.c                 |    2 ++
 include/linux/compat-2.6.36.h |   15 +++++++++++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index 5faefb4..aab25df 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -92,5 +92,20 @@ void compat_usb_scuttle_anchored_urbs(struct usb_anchor *anchor)
 	spin_unlock_irqrestore(&anchor->lock, flags);
 }
 EXPORT_SYMBOL_GPL(compat_usb_scuttle_anchored_urbs);
+
+struct workqueue_struct *system_nrt_wq __read_mostly;
+EXPORT_SYMBOL_GPL(system_nrt_wq);
+
+void compat_system_workqueue_create()
+{
+	system_nrt_wq = create_singlethread_workqueue("events_nrt");
+	WARN_ON(system_nrt_wq);
+}
+
+void compat_system_workqueue_destroy()
+{
+	destroy_workqueue(system_nrt_wq);
+}
+
 #endif /* CONFIG_COMPAT_USB_URB_THREAD_FIX */
 
diff --git a/compat/main.c b/compat/main.c
index a1a48d0..f830488 100644
--- a/compat/main.c
+++ b/compat/main.c
@@ -36,6 +36,7 @@ static int __init compat_init(void)
 {
 	/* pm-qos for kernels <= 2.6.24, this is a no-op on newer kernels */
 	compat_pm_qos_power_init();
+	compat_system_workqueue_create();
 
 	printk(KERN_INFO
 	       COMPAT_PROJECT " backport release: "
@@ -52,6 +53,7 @@ module_init(compat_init);
 static void __exit compat_exit(void)
 {
 	compat_pm_qos_power_deinit();
+	compat_system_workqueue_destroy();
 
         return;
 }
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index f4d6f80..29ade27 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -134,6 +134,21 @@ static inline void skb_tx_timestamp(struct sk_buff *skb)
 {
 }
 
+extern struct workqueue_struct *system_nrt_wq;
+
+void compat_system_workqueue_create(void);
+void compat_system_workqueue_destroy(void);
+
+#else
+
+static inline void compat_system_workqueue_create(void)
+{
+}
+
+static inline void compat_system_workqueue_destroy(void)
+{
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.4.1

