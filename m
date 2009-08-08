Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53701 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934121AbZHHMii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 08:38:38 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/7] [compat-2.6] Remove unsed code.
Date: Sat,  8 Aug 2009 14:38:16 +0200
Message-Id: <1249735096-27071-7-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
References: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.28.c |   40 ----------------------------------------
 compat/compat-2.6.28.h |    3 ---
 2 files changed, 0 insertions(+), 43 deletions(-)

diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
index 33871a2..965be80 100644
--- a/compat/compat-2.6.28.c
+++ b/compat/compat-2.6.28.c
@@ -167,46 +167,6 @@ struct urb *usb_get_from_anchor(struct usb_anchor *anchor)
 
 EXPORT_SYMBOL_GPL(usb_get_from_anchor);
 
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
- * usb_anchor_empty - is an anchor empty
- * @anchor: the anchor you want to query
- *
- * returns 1 if the anchor has no urbs associated with it
- */
-int usb_anchor_empty(struct usb_anchor *anchor)
-{
-	return list_empty(&anchor->urb_list);
-}
-
-EXPORT_SYMBOL_GPL(usb_anchor_empty);
-
 
 void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
 {
diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
index e25259f..0a305d2 100644
--- a/compat/compat-2.6.28.h
+++ b/compat/compat-2.6.28.h
@@ -47,9 +47,6 @@ extern void usb_poison_anchored_urbs(struct usb_anchor *anchor);
 #endif
 
 extern struct urb *usb_get_from_anchor(struct usb_anchor *anchor);
-extern void usb_scuttle_anchored_urbs(struct usb_anchor *anchor);
-extern int usb_anchor_empty(struct usb_anchor *anchor);
-
 
 void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar);
 
-- 
1.6.2.1

