Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59594 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab0ISRmc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 13:42:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 2/4] compat: backport some usb urb functions
Date: Sun, 19 Sep 2010 19:42:09 +0200
Message-Id: <1284918131-32065-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284918131-32065-1-git-send-email-hauke@hauke-m.de>
References: <1284918131-32065-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions have to be backported, because they were thread-unsafe.
This is commit b3e670443b7fb8a2d29831b62b44a039c283e351 in mainline kernel.

CC: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile               |    1 +
 compat/compat-2.6.28.c        |   56 -----------------------
 compat/compat-2.6.36.c        |  100 +++++++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.28.h |    2 -
 include/linux/compat-2.6.36.h |   12 +++++
 5 files changed, 113 insertions(+), 58 deletions(-)
 create mode 100644 compat/compat-2.6.36.c

diff --git a/compat/Makefile b/compat/Makefile
index b067be2..1f053f2 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -27,4 +27,5 @@ compat-$(CONFIG_COMPAT_KERNEL_31) += compat-2.6.31.o
 compat-$(CONFIG_COMPAT_KERNEL_32) += compat-2.6.32.o
 compat-$(CONFIG_COMPAT_KERNEL_33) += compat-2.6.33.o
 compat-$(CONFIG_COMPAT_KERNEL_35) += compat-2.6.35.o
+compat-$(CONFIG_COMPAT_KERNEL_36) += compat-2.6.36.o
 compat-$(CONFIG_COMPAT_KERNEL_37) += compat-2.6.37.o
diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
index bfb645a..c11ba40 100644
--- a/compat/compat-2.6.28.c
+++ b/compat/compat-2.6.28.c
@@ -225,62 +225,6 @@ EXPORT_SYMBOL_GPL(usb_poison_anchored_urbs);
 #endif
 
 /**
- * usb_get_from_anchor - get an anchor's oldest urb
- * @anchor: the anchor whose urb you want
- *
- * this will take the oldest urb from an anchor,
- * unanchor and return it
- */
-struct urb *usb_get_from_anchor(struct usb_anchor *anchor)
-{
-	struct urb *victim;
-	unsigned long flags;
-
-	spin_lock_irqsave(&anchor->lock, flags);
-	if (!list_empty(&anchor->urb_list)) {
-		victim = list_entry(anchor->urb_list.next, struct urb,
-				    anchor_list);
-		usb_get_urb(victim);
-		spin_unlock_irqrestore(&anchor->lock, flags);
-		usb_unanchor_urb(victim);
-	} else {
-		spin_unlock_irqrestore(&anchor->lock, flags);
-		victim = NULL;
-	}
-
-	return victim;
-}
-
-EXPORT_SYMBOL_GPL(usb_get_from_anchor);
-
-/**
- * usb_scuttle_anchored_urbs - unanchor all an anchor's urbs
- * @anchor: the anchor whose urbs you want to unanchor
- *
- * use this to get rid of all an anchor's urbs
- */
-void usb_scuttle_anchored_urbs(struct usb_anchor *anchor)
-{
-	struct urb *victim;
-	unsigned long flags;
-
-	spin_lock_irqsave(&anchor->lock, flags);
-	while (!list_empty(&anchor->urb_list)) {
-		victim = list_entry(anchor->urb_list.prev, struct urb,
-				    anchor_list);
-		usb_get_urb(victim);
-		spin_unlock_irqrestore(&anchor->lock, flags);
-		/* this may free the URB */
-		usb_unanchor_urb(victim);
-		usb_put_urb(victim);
-		spin_lock_irqsave(&anchor->lock, flags);
-	}
-	spin_unlock_irqrestore(&anchor->lock, flags);
-}
-
-EXPORT_SYMBOL_GPL(usb_scuttle_anchored_urbs);
-
-/**
  * usb_anchor_empty - is an anchor empty
  * @anchor: the anchor you want to query
  *
diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
new file mode 100644
index 0000000..bd9335d
--- /dev/null
+++ b/compat/compat-2.6.36.c
@@ -0,0 +1,100 @@
+/*
+ * Copyright 2010    Hauke Mehrtens <hauke@hauke-m.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 2.6.36.
+ */
+
+#include <linux/compat.h>
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)
+
+#include <linux/usb.h>
+
+#ifdef CONFIG_COMPAT_USB_URB_THREAD_FIX
+/* Callers must hold anchor->lock */
+static void __usb_unanchor_urb(struct urb *urb, struct usb_anchor *anchor)
+{
+	urb->anchor = NULL;
+	list_del(&urb->anchor_list);
+	usb_put_urb(urb);
+	if (list_empty(&anchor->urb_list))
+		wake_up(&anchor->wait);
+}
+
+/**
+ * usb_unlink_anchored_urbs - asynchronously cancel transfer requests en masse
+ * @anchor: anchor the requests are bound to
+ *
+ * this allows all outstanding URBs to be unlinked starting
+ * from the back of the queue. This function is asynchronous.
+ * The unlinking is just tiggered. It may happen after this
+ * function has returned.
+ *
+ * This routine should not be called by a driver after its disconnect
+ * method has returned.
+ */
+void compat_usb_unlink_anchored_urbs(struct usb_anchor *anchor)
+{
+	struct urb *victim;
+
+	while ((victim = usb_get_from_anchor(anchor)) != NULL) {
+		usb_unlink_urb(victim);
+		usb_put_urb(victim);
+	}
+}
+EXPORT_SYMBOL_GPL(compat_usb_unlink_anchored_urbs);
+
+/**
+ * usb_get_from_anchor - get an anchor's oldest urb
+ * @anchor: the anchor whose urb you want
+ *
+ * this will take the oldest urb from an anchor,
+ * unanchor and return it
+ */
+struct urb *compat_usb_get_from_anchor(struct usb_anchor *anchor)
+{
+	struct urb *victim;
+	unsigned long flags;
+
+	spin_lock_irqsave(&anchor->lock, flags);
+	if (!list_empty(&anchor->urb_list)) {
+		victim = list_entry(anchor->urb_list.next, struct urb,
+				    anchor_list);
+		usb_get_urb(victim);
+		__usb_unanchor_urb(victim, anchor);
+	} else {
+		victim = NULL;
+	}
+	spin_unlock_irqrestore(&anchor->lock, flags);
+
+	return victim;
+}
+EXPORT_SYMBOL_GPL(compat_usb_get_from_anchor);
+
+/**
+ * usb_scuttle_anchored_urbs - unanchor all an anchor's urbs
+ * @anchor: the anchor whose urbs you want to unanchor
+ *
+ * use this to get rid of all an anchor's urbs
+ */
+void compat_usb_scuttle_anchored_urbs(struct usb_anchor *anchor)
+{
+	struct urb *victim;
+	unsigned long flags;
+
+	spin_lock_irqsave(&anchor->lock, flags);
+	while (!list_empty(&anchor->urb_list)) {
+		victim = list_entry(anchor->urb_list.prev, struct urb,
+				    anchor_list);
+		__usb_unanchor_urb(victim, anchor);
+	}
+	spin_unlock_irqrestore(&anchor->lock, flags);
+}
+EXPORT_SYMBOL_GPL(compat_usb_scuttle_anchored_urbs);
+#endif /* CONFIG_COMPAT_USB_URB_THREAD_FIX */
+
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36) */
diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index 649fbbc..1de39ad 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -62,8 +62,6 @@ extern void usb_unpoison_urb(struct urb *urb);
 extern void usb_poison_anchored_urbs(struct usb_anchor *anchor);
 #endif
 
-extern struct urb *usb_get_from_anchor(struct usb_anchor *anchor);
-extern void usb_scuttle_anchored_urbs(struct usb_anchor *anchor);
 extern int usb_anchor_empty(struct usb_anchor *anchor);
 #endif /* CONFIG_USB */
 #endif
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 5b48215..2df34d6 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -5,6 +5,8 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36))
 
+#include <linux/usb.h>
+
 #define kparam_block_sysfs_write(a)
 #define kparam_unblock_sysfs_write(a)
 
@@ -15,6 +17,16 @@ struct va_format {
 
 #define device_rename(dev, new_name) device_rename(dev, (char *)new_name)
 
+#ifdef CONFIG_COMPAT_USB_URB_THREAD_FIX
+#define usb_scuttle_anchored_urbs(anchor)	compat_usb_scuttle_anchored_urbs(anchor)
+#define usb_get_from_anchor(anchor)	compat_usb_get_from_anchor(anchor)
+#define usb_unlink_anchored_urbs(anchor)	compat_usb_unlink_anchored_urbs(anchor)
+
+extern void compat_usb_unlink_anchored_urbs(struct usb_anchor *anchor);
+extern struct urb *compat_usb_get_from_anchor(struct usb_anchor *anchor);
+extern void compat_usb_scuttle_anchored_urbs(struct usb_anchor *anchor);
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.0.4

