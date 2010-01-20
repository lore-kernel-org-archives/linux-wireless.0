Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54474 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab0ATTdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 14:33:35 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: fix build with CONFIG_USB=m
Date: Wed, 20 Jan 2010 20:33:16 +0100
Message-Id: <1264015996-30679-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The usb compat code was not build if usb was build as module in kernel.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.28.c        |    4 ++--
 compat/compat-2.6.29.c        |    2 +-
 include/linux/compat-2.6.28.h |    2 +-
 include/linux/compat-2.6.29.h |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
index a141859..115bd23 100644
--- a/compat/compat-2.6.28.c
+++ b/compat/compat-2.6.28.c
@@ -17,7 +17,7 @@
 /* 2.6.28 compat code goes here */
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
-#if defined(CONFIG_USB)
+#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
 /*
  * Compat-wireless notes for USB backport stuff:
  *
@@ -166,7 +166,7 @@ EXPORT_SYMBOL(pcmcia_loop_config);
 
 #endif /* CONFIG_PCMCIA */
 
-#if defined(CONFIG_USB)
+#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
 
 void usb_unpoison_urb(struct urb *urb)
 {
diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
index 48e72a3..c8e0183 100644
--- a/compat/compat-2.6.29.c
+++ b/compat/compat-2.6.29.c
@@ -16,7 +16,7 @@
 #include <linux/etherdevice.h>
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
-#if defined(CONFIG_USB)
+#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
 /**
  * usb_unpoison_anchored_urbs - let an anchor be used successfully again
  * @anchor: anchor the requests are bound to
diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index 13a0367..2cab320 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -52,7 +52,7 @@ int pcmcia_loop_config(struct pcmcia_device *p_dev,
 /* USB anchors were added as of 2.6.23 */
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
 
-#if defined(CONFIG_USB)
+#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
 #if 0
 extern void usb_poison_urb(struct urb *urb);
 #endif
diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index 27f1325..c3572a2 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -47,7 +47,7 @@ static inline struct net_device_stats *dev_get_stats(struct net_device *dev)
 }
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
-#if defined(CONFIG_USB)
+#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
 extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
 #endif /* CONFIG_USB */
 #endif
-- 
1.6.3.3

