Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:54474 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950AbXGUU7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 16:59:02 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: remove buggy tx queue code
Message-Id: <20070721205837.4463A7B409F@zog.reactivated.net>
Date: Sat, 21 Jul 2007 21:58:36 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

The queue management code was buggy. Cough, cough. I didn't deal
with the situation that the ack_wait_queue, formerly known as
tx_queue, would fill. After the tx queue has been stopped and no
further packets are transmitted the access point has little reason
to send us additional ACK packets, which would remove entries from
the ack_wait_queue. In such a situation the tx queue kept blocked.

This patch removes the offending code and renamed tx_queue to
ack_wait_queue to make it purpose a little bit more
comprehensible. The alert reader will recognize that the patch
doesn't remove the counter for the submitted packets. This is no
accident, because I plan to stop the upper layer tx queues based
on this counter.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.c |   89 ++++-------------------
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.h |   10 +--
 2 files changed, 15 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index 373916a..2461507 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -260,7 +260,7 @@ static int zd_mac_stop(struct ieee80211_hw *dev)
 	struct zd_mac *mac = zd_dev_mac(dev);
 	struct zd_chip *chip = &mac->chip;
 	struct sk_buff *skb;
-	struct sk_buff_head *tx_queue = &mac->tx_queue;
+	struct sk_buff_head *ack_wait_queue = &mac->ack_wait_queue;
 
 	/*
 	 * The order here deliberately is a little different from the open()
@@ -276,68 +276,13 @@ static int zd_mac_stop(struct ieee80211_hw *dev)
 	zd_chip_disable_int(chip);
 
 
-	while ((skb = skb_dequeue(tx_queue)))
+	while ((skb = skb_dequeue(ack_wait_queue)))
 		kfree_tx_skb(skb);
 
 	return 0;
 }
 
 /**
- * tx_frames - returns the number of incompleted frames
- * @mac: a &struct zd_mac pointer
- *
- * This is the number of frames, which have not been completed so far.
- * Packets without ACKs are completed if the have been transmitted to the
- * decice and all others if they have been removed from the tx_queue.
- */
-static int tx_frames(struct zd_mac *mac)
-{
-	return skb_queue_len(&mac->tx_queue) + zd_usb_tx_frames(&mac->chip.usb);
-}
-
-/**
- * try_stop - if necessary closes the incoming network queues
- * @dev: a &struct ieee80211_hw pointer
- *
- * If the number of incompleted frames is higher than @tx_high, the function
- * stops the incoming queues of the mac80211 stack. Nothing happens if the
- * queues have already been stopped.
- */
-static void try_stop(struct ieee80211_hw *dev)
-{
-	unsigned long flags;
-	struct zd_mac *mac = zd_dev_mac(dev);
-
-	spin_lock_irqsave(&mac->lock, flags);
-	if (!mac->tx_stopped && tx_frames(mac) > mac->tx_high) {
-		ieee80211_stop_queues(dev);
-		mac->tx_stopped = 1;
-	}
-	spin_unlock_irqrestore(&mac->lock, flags);
-}
-
-/**
- * try_wakeup - wake queue
- * @dev: a &struct ieee80211_hw pointer
- *
- * If the number of incompleted frames drops under the the low level and the
- * upper-layer transfer queues have been stopped, the queues will be wakened
- * again.
- */
-static void try_wakeup(struct ieee80211_hw *dev)
-{
-	unsigned long flags;
-	struct zd_mac *mac = zd_dev_mac(dev);
-
-	spin_lock_irqsave(&mac->lock, flags);
-	if (mac->tx_stopped && tx_frames(mac) <= mac->tx_low) {
-		ieee80211_wake_queues(dev);
-		mac->tx_stopped = 0;
-	}
-	spin_unlock_irqrestore(&mac->lock, flags);
-}
-
-/**
  * init_tx_skb_control_block - initializes skb control block
  * @skb: a &sk_buff pointer
  * @dev: pointer to the mac80221 device
@@ -374,7 +319,7 @@ static int init_tx_skb_control_block(struct sk_buff *skb,
  *
  * Informs the MAC layer that the frame has successfully transferred to the
  * device. If an ACK is required and the transfer to the device has been
- * successful, the packets are put on the @tx_queue with
+ * successful, the packets are put on the @ack_wait_queue with
  * the control set removed.
  */
 void zd_mac_tx_to_dev(struct sk_buff *skb, int error)
@@ -393,13 +338,12 @@ void zd_mac_tx_to_dev(struct sk_buff *skb, int error)
 			clear_tx_skb_control_block(skb);
 			ieee80211_tx_status_irqsafe(dev, skb, &status);
 		} else {
-			skb_queue_tail(&zd_dev_mac(dev)->tx_queue, skb);
+			skb_queue_tail(&zd_dev_mac(dev)->ack_wait_queue, skb);
 			return;
 		}
 	} else {
 		kfree_tx_skb(skb);
 	}
-	try_wakeup(dev);
 }
 
 static int zd_calc_tx_length_us(u8 *service, u8 cs_rate, u16 tx_length)
@@ -569,7 +513,6 @@ static int zd_mac_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		clear_tx_skb_control_block(skb);
 		return r;
 	}
-	try_stop(dev);
 	return 0;
 }
 
@@ -583,12 +526,12 @@ static int zd_mac_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
  */
 void zd_mac_tx_failed(struct ieee80211_hw *dev)
 {
-	struct sk_buff_head *tx_queue = &zd_dev_mac(dev)->tx_queue;
+	struct sk_buff_head *ack_wait_queue = &zd_dev_mac(dev)->ack_wait_queue;
 	struct sk_buff *skb;
 	struct ieee80211_tx_status status;
 	struct zd_tx_skb_control_block *cb;
 
-	skb = skb_dequeue(tx_queue);
+	skb = skb_dequeue(ack_wait_queue);
 	if (skb == NULL)
 		return;
 	cb = (struct zd_tx_skb_control_block *)skb->cb;
@@ -597,7 +540,6 @@ void zd_mac_tx_failed(struct ieee80211_hw *dev)
 	memcpy(&status.control, cb->control, sizeof(status.control));
 	clear_tx_skb_control_block(skb);
 	ieee80211_tx_status_irqsafe(dev, skb, &status);
-	try_wakeup(dev);
 }
 
 struct zd_rt_hdr {
@@ -678,18 +620,16 @@ static int filter_ack(struct ieee80211_hw *dev, struct ieee80211_hdr *rx_hdr,
 {
 	u16 fc = le16_to_cpu(rx_hdr->frame_control);
 	struct sk_buff *skb;
-	struct sk_buff_head *tx_queue;
+	struct sk_buff_head *q;
 	unsigned long flags;
 
 	if ((fc & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) !=
 	    (IEEE80211_FTYPE_CTL | IEEE80211_STYPE_ACK))
 		return 0;
 
-	tx_queue = &zd_dev_mac(dev)->tx_queue;
-	spin_lock_irqsave(&tx_queue->lock, flags);
-	for (skb = tx_queue->next; skb != (struct sk_buff *)tx_queue;
-	     skb = skb->next)
-	{
+	q = &zd_dev_mac(dev)->ack_wait_queue;
+	spin_lock_irqsave(&q->lock, flags);
+	for (skb = q->next; skb != (struct sk_buff *)q; skb = skb->next) {
 		struct ieee80211_hdr *tx_hdr;
 		struct zd_tx_skb_control_block *cb =
 			(struct zd_tx_skb_control_block *)skb->cb;
@@ -703,15 +643,14 @@ static int filter_ack(struct ieee80211_hw *dev, struct ieee80211_hdr *rx_hdr,
 		               cb->control, sizeof(status.control));
 			status.flags = IEEE80211_TX_STATUS_ACK;
 			status.ack_signal = stats->ssi;
-			__skb_unlink(skb, tx_queue);
+			__skb_unlink(skb, q);
 			clear_tx_skb_control_block(skb);
 			ieee80211_tx_status_irqsafe(dev, skb, &status);
-			try_wakeup(dev);
 			goto out;
 		}
 	}
 out:
-	spin_unlock_irqrestore(&tx_queue->lock, flags);
+	spin_unlock_irqrestore(&q->lock, flags);
 	return 1;
 }
 
@@ -893,9 +832,7 @@ struct ieee80211_hw *zd_mac_alloc(struct usb_interface *intf)
 	dev->queues = 1;
 	dev->extra_tx_headroom = sizeof(struct zd_ctrlset);
 
-	mac->tx_low = ZD_MAC_TX_LOW;
-	mac->tx_high = ZD_MAC_TX_HIGH;
-	skb_queue_head_init(&mac->tx_queue);
+	skb_queue_head_init(&mac->ack_wait_queue);
 
 	for (i = 0; i < 2; i++) {
 		if (ieee80211_register_hwmode(dev, &mac->modes[i])) {
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
index ded3dea..1d4753e 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
@@ -114,7 +114,7 @@ struct rx_status {
 #define ZD_RX_CRC16_ERROR		0x40
 #define ZD_RX_ERROR			0x80
 
-enum mac_flags {
+enum mac_flags { 
 	MAC_FIXED_CHANNEL = 0x01,
 };
 
@@ -140,9 +140,6 @@ struct zd_tx_skb_control_block {
 
 #define ZD_MAC_STATS_BUFFER_SIZE 16
 
-#define ZD_MAC_TX_HIGH 6
-#define ZD_MAC_TX_LOW 2
-
 struct zd_mac {
 	struct zd_chip chip;
 	spinlock_t lock;
@@ -155,10 +152,7 @@ struct zd_mac {
 	int mode;
 	int associated;
 	u8 *hwaddr;
-	struct sk_buff_head tx_queue;
-	int tx_high;
-	int tx_low;
-	int tx_stopped;
+	struct sk_buff_head ack_wait_queue;
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];
 	struct ieee80211_hw_mode modes[2];
-- 
1.5.2.2

