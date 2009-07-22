Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40889 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZGVUh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 16:37:56 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] [compat-2.6] Move usb_unpoison_anchored_urbs to compat-2.6.29.h
Date: Wed, 22 Jul 2009 22:37:48 +0200
Message-Id: <1248295068-26942-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1248295068-26942-1-git-send-email-hauke@hauke-m.de>
References: <1248295068-26942-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The declaration of usb_unpoison_anchored_urbs was introduced in kernel 2.6.29.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.28.h |    1 -
 compat/compat-2.6.29.h |    3 +++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
index 9bc1231..40b5320 100644
--- a/compat/compat-2.6.28.h
+++ b/compat/compat-2.6.28.h
@@ -37,7 +37,6 @@ extern void usb_unpoison_urb(struct urb *urb);
 #if 0
 extern void usb_poison_anchored_urbs(struct usb_anchor *anchor);
 #endif
-extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
 
 extern struct urb *usb_get_from_anchor(struct usb_anchor *anchor);
 extern void usb_scuttle_anchored_urbs(struct usb_anchor *anchor);
diff --git a/compat/compat-2.6.29.h b/compat/compat-2.6.29.h
index f4086e9..8ea43cb 100644
--- a/compat/compat-2.6.29.h
+++ b/compat/compat-2.6.29.h
@@ -8,6 +8,7 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
 
 #include <linux/skbuff.h>
+#include <linux/usb.h>
 
 /**
  *	skb_queue_is_first - check if skb is the first entry in the queue
@@ -40,6 +41,8 @@ static inline struct sk_buff *skb_queue_prev(const struct sk_buff_head *list,
 	return skb->prev;
 }
 
+extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
 
 #endif /*  LINUX_26_29_COMPAT_H */
-- 
1.6.2.1

