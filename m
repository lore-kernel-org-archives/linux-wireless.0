Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:56661 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950AbXGUU6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 16:58:43 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: Control mac80211 tx queues by submitted URBs
Message-Id: <20070721205843.755587B40A1@zog.reactivated.net>
Date: Sat, 21 Jul 2007 21:58:43 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

This patch controls the mac80211 tx queues by the number of
submitted URBs.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_usb.c |   44 ++++++++++++++++++++---
 drivers/net/wireless/mac80211/zd1211rw/zd_usb.h |   19 +++-------
 2 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c b/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
index 30ae209..9b4950f 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
@@ -736,7 +736,10 @@ void zd_usb_disable_tx(struct zd_usb *usb)
 		usb_free_urb(list_entry(pos, struct urb, urb_list));
 	}
 	tx->enabled = 0;
-	atomic_set(&tx->submitted_urbs, 0);
+	tx->submitted_urbs = 0;
+	/* The stopped state is ignored, relying on ieee80211_wake_queues()
+	 * in a potentionally following zd_usb_enable_tx().
+	 */
 	spin_unlock_irqrestore(&tx->lock, flags);
 }
 
@@ -754,7 +757,9 @@ void zd_usb_enable_tx(struct zd_usb *usb)
 
 	spin_lock_irqsave(&tx->lock, flags);
 	tx->enabled = 1;
-	atomic_set(&tx->submitted_urbs, 0);
+	tx->submitted_urbs = 0;
+	ieee80211_wake_queues(zd_usb_to_dev(usb));
+	tx->stopped = 0;
 	spin_unlock_irqrestore(&tx->lock, flags);
 }
 
@@ -808,6 +813,34 @@ out:
 	spin_unlock_irqrestore(&tx->lock, flags);
 }
 
+static void tx_dec_submitted_urbs(struct zd_usb *usb)
+{
+	struct zd_usb_tx *tx = &usb->tx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	--tx->submitted_urbs;
+	if (tx->stopped && tx->submitted_urbs <= ZD_USB_TX_LOW) {
+		ieee80211_wake_queues(zd_usb_to_dev(usb));
+		tx->stopped = 0;
+	}
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+static void tx_inc_submitted_urbs(struct zd_usb *usb)
+{
+	struct zd_usb_tx *tx = &usb->tx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	++tx->submitted_urbs;
+	if (!tx->stopped && tx->submitted_urbs > ZD_USB_TX_HIGH) {
+		ieee80211_stop_queues(zd_usb_to_dev(usb));
+		tx->stopped = 1;
+	}
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
 /**
  * tx_urb_complete - completes the execution of an URB
  * @urb: a URB
@@ -842,8 +875,8 @@ free_urb:
 	zd_mac_tx_to_dev(skb, urb->status);
 	cb = (struct zd_tx_skb_control_block *)skb->cb;
 	usb = &zd_dev_mac(cb->dev)->chip.usb;
-	atomic_dec(&usb->tx.submitted_urbs);
 	free_tx_urb(usb, urb);
+	tx_dec_submitted_urbs(usb);
 	return;
 resubmit:
 	r = usb_submit_urb(urb, GFP_ATOMIC);
@@ -883,7 +916,7 @@ int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb)
 	r = usb_submit_urb(urb, GFP_ATOMIC);
 	if (r)
 		goto error;
-	atomic_inc(&usb->tx.submitted_urbs);
+	tx_inc_submitted_urbs(usb);
 	return 0;
 error:
 	free_tx_urb(usb, urb);
@@ -918,8 +951,9 @@ static inline void init_usb_tx(struct zd_usb *usb)
 	struct zd_usb_tx *tx = &usb->tx;
 	spin_lock_init(&tx->lock);
 	tx->enabled = 0;
+	tx->stopped = 0;
 	INIT_LIST_HEAD(&tx->free_urb_list);
-	atomic_set(&tx->submitted_urbs, 0);
+	tx->submitted_urbs = 0;
 }
 
 void zd_usb_init(struct zd_usb *usb, struct ieee80211_hw *dev,
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_usb.h b/drivers/net/wireless/mac80211/zd1211rw/zd_usb.h
index 7c58301..530f3b3 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_usb.h
@@ -26,6 +26,9 @@
 
 #include "zd_def.h"
 
+#define ZD_USB_TX_HIGH  5
+#define ZD_USB_TX_LOW   2
+
 enum devicetype {
 	DEVICE_ZD1211  = 0,
 	DEVICE_ZD1211B = 1,
@@ -183,12 +186,14 @@ struct zd_usb_rx {
  * @submitted_urbs: atomic integer that counts the URBs having sent to the
  *	device, which haven't been completed
  * @enabled: enabled flag, indicates whether tx is enabled
+ * @stopped: indicates whether higher level tx queues are stopped
  */
 struct zd_usb_tx {
 	spinlock_t lock;
 	struct list_head free_urb_list;
-	atomic_t submitted_urbs;
+	int submitted_urbs;
 	int enabled;
+	int stopped;
 };
 
 /* Contains the usb parts. The structure doesn't require a lock because intf
@@ -237,18 +242,6 @@ void zd_usb_disable_tx(struct zd_usb *usb);
 
 int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb);
 
-/**
- * zd_usb_tx_frames - frames in transfer to the device
- * @usb: a &struct zd_usb pointer
- *
- * This function returns the number of frames, which are currently
- * transmitted to the device.
- */
-static inline int zd_usb_tx_frames(struct zd_usb *usb)
-{
-	return atomic_read(&usb->tx.submitted_urbs);
-}
-
 int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 	         const zd_addr_t *addresses, unsigned int count);
 
-- 
1.5.2.2

