Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:20731 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYEJMKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:35 -0400
Received: by nf-out-0910.google.com with SMTP id d3so883151nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:34 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/5] rt2x00: use multi-queue master netdevice
Date: Sat, 10 May 2008 13:50:34 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101349.19481.IvDoorn@gmail.com>
In-Reply-To: <200805101349.19481.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805101350.34592.IvDoorn@gmail.com> (sfid-20080510_141044_729900_D69E4CFB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make rt2x00 use the skb mapping functions provided by patch:
	mac80211: use multi-queue master netdevice
This also fixes a bug where the ATIM qid to be passed to
mac80211 to start the queue again, this would be disallowed
by mac80211, but the right queue (Where the skb was mapped to
would still be down).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   10 +++++-----
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00queue.h |   13 -------------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    3 ++-
 4 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index c5cedb2..fe952f0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -81,7 +81,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
-	enum data_queue_qid qid = mac80211_queue_to_qid(control->queue);
+	enum data_queue_qid qid = skb_get_queue_mapping(skb);
 	struct data_queue *queue;
 	struct skb_frame_desc *skbdesc;
 	u16 frame_control;
@@ -129,12 +129,12 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 			       IEEE80211_TXCTL_USE_CTS_PROTECT)) &&
 	    !rt2x00dev->ops->hw->set_rts_threshold) {
 		if (rt2x00queue_available(queue) <= 1) {
-			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+			ieee80211_stop_queue(rt2x00dev->hw, qid);
 			return NETDEV_TX_BUSY;
 		}
 
 		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb, control)) {
-			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+			ieee80211_stop_queue(rt2x00dev->hw, qid);
 			return NETDEV_TX_BUSY;
 		}
 	}
@@ -146,12 +146,12 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	memset(skbdesc, 0, sizeof(*skbdesc));
 
 	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb, control)) {
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		ieee80211_stop_queue(rt2x00dev->hw, qid);
 		return NETDEV_TX_BUSY;
 	}
 
 	if (rt2x00queue_full(queue))
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		ieee80211_stop_queue(rt2x00dev->hw, qid);
 
 	if (rt2x00dev->ops->lib->kick_tx_queue)
 		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, qid);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index fa7de41..e9b16f5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -164,6 +164,7 @@ void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc)
 {
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
 	u32 word;
 
 	txdesc->control = &entry_priv->control;
@@ -187,7 +188,7 @@ void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
 	 * is reenabled when the txdone handler has finished.
 	 */
 	if (!rt2x00queue_full(entry->queue))
-		ieee80211_wake_queue(rt2x00dev->hw, entry_priv->control.queue);
+		ieee80211_wake_queue(rt2x00dev->hw, qid);
 
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index c6edc52..ac52b9c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -80,19 +80,6 @@ enum data_queue_qid {
 };
 
 /**
- * mac80211_queue_to_qid - Convert mac80211 queue to rt2x00 qid
- * @queue: mac80211 queue.
- */
-static inline enum data_queue_qid mac80211_queue_to_qid(unsigned int queue)
-{
-	/* Regular TX queues are mapped directly */
-	if (queue < 4)
-		return queue;
-	WARN_ON(1);
-	return QID_OTHER;
-}
-
-/**
  * enum skb_frame_desc_flags: Flags for &struct skb_frame_desc
  *
  * @FRAME_DESC_DRIVER_GENERATED: Frame was generated inside driver
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 957078a..e6ced50 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -132,6 +132,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	struct txdone_entry_desc txdesc;
 	__le32 *txd = (__le32 *)entry->skb->data;
+	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
 	u32 word;
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
@@ -175,7 +176,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * is reenabled when the txdone handler has finished.
 	 */
 	if (!rt2x00queue_full(entry->queue))
-		ieee80211_wake_queue(rt2x00dev->hw, entry_priv->control.queue);
+		ieee80211_wake_queue(rt2x00dev->hw, qid);
 }
 
 int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
-- 
1.5.5.1

