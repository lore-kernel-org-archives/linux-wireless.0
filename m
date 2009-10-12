Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56601 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757662AbZJLVUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:20:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [compat-stable] fix build with recent mainline kernel
Date: Mon, 12 Oct 2009 23:19:10 +0200
Message-Id: <1255382358-20760-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DIV_ROUND_CLOSEST is needed by the b44 driver
refresh patch for rfkill

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.29.h         |    7 +++++++
 compat/patches/03-rfkill.patch |   22 +++++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/compat/compat-2.6.29.h b/compat/compat-2.6.29.h
index 8ea43cb..fc7d983 100644
--- a/compat/compat-2.6.29.h
+++ b/compat/compat-2.6.29.h
@@ -43,6 +43,13 @@ static inline struct sk_buff *skb_queue_prev(const struct sk_buff_head *list,
 
 extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
 
+#define DIV_ROUND_CLOSEST(x, divisor)(			\
+{							\
+	typeof(divisor) __divisor = divisor;		\
+	(((x) + ((__divisor) / 2)) / (__divisor));	\
+}							\
+)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
 
 #endif /*  LINUX_26_29_COMPAT_H */
diff --git a/compat/patches/03-rfkill.patch b/compat/patches/03-rfkill.patch
index dadcb9a..d7a7e7f 100644
--- a/compat/patches/03-rfkill.patch
+++ b/compat/patches/03-rfkill.patch
@@ -71,10 +71,10 @@ This would do the policing from within mac80211.
  #include <linux/mutex.h>
 -#include <linux/rfkill.h>
 +#include <linux/rfkill_backport.h>
+ #include <linux/sched.h>
  #include <linux/spinlock.h>
  #include <linux/miscdevice.h>
- #include <linux/wait.h>
-@@ -61,7 +61,7 @@
+@@ -62,7 +62,7 @@
  	const struct rfkill_ops	*ops;
  	void			*data;
  
@@ -83,7 +83,7 @@ This would do the policing from within mac80211.
  	struct led_trigger	led_trigger;
  	const char		*ledtrigname;
  #endif
-@@ -122,7 +122,7 @@
+@@ -123,7 +123,7 @@
  static bool rfkill_epo_lock_active;
  
  
@@ -92,7 +92,7 @@ This would do the policing from within mac80211.
  static void rfkill_led_trigger_event(struct rfkill *rfkill)
  {
  	struct led_trigger *trigger;
-@@ -316,7 +316,7 @@
+@@ -317,7 +317,7 @@
  	rfkill_event(rfkill);
  }
  
@@ -101,7 +101,7 @@ This would do the policing from within mac80211.
  static atomic_t rfkill_input_disabled = ATOMIC_INIT(0);
  
  /**
-@@ -776,7 +776,7 @@
+@@ -777,7 +777,7 @@
  }
  
  static struct class rfkill_class = {
@@ -110,7 +110,7 @@ This would do the policing from within mac80211.
  	.dev_release	= rfkill_release,
  	.dev_attrs	= rfkill_dev_attrs,
  	.dev_uevent	= rfkill_dev_uevent,
-@@ -922,7 +922,7 @@
+@@ -923,7 +923,7 @@
  	if (!rfkill->persistent || rfkill_epo_lock_active) {
  		schedule_work(&rfkill->sync_work);
  	} else {
@@ -119,7 +119,7 @@ This would do the policing from within mac80211.
  		bool soft_blocked = !!(rfkill->state & RFKILL_BLOCK_SW);
  
  		if (!atomic_read(&rfkill_input_disabled))
-@@ -1150,7 +1150,7 @@
+@@ -1151,7 +1151,7 @@
  	list_for_each_entry_safe(ev, tmp, &data->events, list)
  		kfree(ev);
  
@@ -128,7 +128,7 @@ This would do the policing from within mac80211.
  	if (data->input_handler)
  		if (atomic_dec_return(&rfkill_input_disabled) == 0)
  			printk(KERN_DEBUG "rfkill: input handler enabled\n");
-@@ -1161,7 +1161,7 @@
+@@ -1162,7 +1162,7 @@
  	return 0;
  }
  
@@ -137,7 +137,7 @@ This would do the policing from within mac80211.
  static long rfkill_fop_ioctl(struct file *file, unsigned int cmd,
  			     unsigned long arg)
  {
-@@ -1193,7 +1193,7 @@
+@@ -1194,7 +1194,7 @@
  	.write		= rfkill_fop_write,
  	.poll		= rfkill_fop_poll,
  	.release	= rfkill_fop_release,
@@ -146,7 +146,7 @@ This would do the policing from within mac80211.
  	.unlocked_ioctl	= rfkill_fop_ioctl,
  	.compat_ioctl	= rfkill_fop_ioctl,
  #endif
-@@ -1223,7 +1223,7 @@
+@@ -1224,7 +1224,7 @@
  		goto out;
  	}
  
@@ -155,7 +155,7 @@ This would do the policing from within mac80211.
  	error = rfkill_handler_init();
  	if (error) {
  		misc_deregister(&rfkill_miscdev);
-@@ -1239,7 +1239,7 @@
+@@ -1240,7 +1240,7 @@
  
  static void __exit rfkill_exit(void)
  {
-- 
1.6.2.1

