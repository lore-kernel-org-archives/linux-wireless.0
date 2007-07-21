Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:48133 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758358AbXGUU7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 16:59:39 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: tx_status() simpflifies code
Message-Id: <20070721205847.A55567B40A0@zog.reactivated.net>
Date: Sat, 21 Jul 2007 21:58:47 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

Introduced a static tx_status() function to simplify the code. The
code takes now also care if no status report for the transmitted
packet has been requested.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.c |   57 +++++++++++++---------
 1 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index 9a2d6f3..2b998c7 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -313,6 +313,34 @@ static int init_tx_skb_control_block(struct sk_buff *skb,
 }
 
 /**
+ * tx_status - reports tx status of a packet if required
+ * @dev - a &struct ieee80211_hw pointer
+ * @skb - a sk-buffer
+ * @status - the tx status of the packet without control information
+ *
+ * This information calls ieee80211_tx_status_irqsafe() if required by the
+ * control information. It copies the control information into the status
+ * information.
+ *
+ * If no status information has been requested, the skb is freed.
+ */
+static void tx_status(struct ieee80211_hw *dev, struct sk_buff *skb,
+	              struct ieee80211_tx_status *status)
+{
+	struct zd_tx_skb_control_block *cb = (struct zd_tx_skb_control_block *)
+		skb->cb;
+
+	ZD_ASSERT(cb->control != NULL);
+	if ((cb->control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)) {
+		memcpy(&status->control, cb->control, sizeof(status->control));
+		clear_tx_skb_control_block(skb);
+		ieee80211_tx_status_irqsafe(dev, skb, status);
+	} else {
+		kfree_tx_skb(skb);
+	}
+}
+
+/**
  * zd_mac_tx_failed - callback for failed frames
  * @dev: the mac80211 wireless device
  *
@@ -322,20 +350,14 @@ static int init_tx_skb_control_block(struct sk_buff *skb,
  */
 void zd_mac_tx_failed(struct ieee80211_hw *dev)
 {
-	struct sk_buff_head *ack_wait_queue = &zd_dev_mac(dev)->ack_wait_queue;
+	struct sk_buff_head *q = &zd_dev_mac(dev)->ack_wait_queue;
 	struct sk_buff *skb;
-	struct ieee80211_tx_status status;
-	struct zd_tx_skb_control_block *cb;
+	struct ieee80211_tx_status status = {{0}};
 
-	skb = skb_dequeue(ack_wait_queue);
+	skb = skb_dequeue(q);
 	if (skb == NULL)
 		return;
-	cb = (struct zd_tx_skb_control_block *)skb->cb;
-	ZD_ASSERT(cb->control != NULL);
-	memset(&status, 0, sizeof(status));
-	memcpy(&status.control, cb->control, sizeof(status.control));
-	clear_tx_skb_control_block(skb);
-	ieee80211_tx_status_irqsafe(dev, skb, &status);
+	tx_status(dev, skb, &status);
 }
 
 /**
@@ -358,11 +380,7 @@ void zd_mac_tx_to_dev(struct sk_buff *skb, int error)
 		skb_pull(skb, sizeof(struct zd_ctrlset));
 		if (unlikely(error)) {
 			struct ieee80211_tx_status status = {{0}};
-
-			memcpy(&status.control,
-				cb->control, sizeof(status.control));
-			clear_tx_skb_control_block(skb);
-			ieee80211_tx_status_irqsafe(dev, skb, &status);
+			tx_status(dev, skb, &status);
 		} else {
 			struct sk_buff_head *q =
 				&zd_dev_mac(dev)->ack_wait_queue;
@@ -370,7 +388,6 @@ void zd_mac_tx_to_dev(struct sk_buff *skb, int error)
 			skb_queue_tail(q, skb);
 			while (skb_queue_len(q) > ZD_MAC_MAX_ACK_WAITERS)
 				zd_mac_tx_failed(dev);
-			return;
 		}
 	} else {
 		kfree_tx_skb(skb);
@@ -636,21 +653,15 @@ static int filter_ack(struct ieee80211_hw *dev, struct ieee80211_hdr *rx_hdr,
 	spin_lock_irqsave(&q->lock, flags);
 	for (skb = q->next; skb != (struct sk_buff *)q; skb = skb->next) {
 		struct ieee80211_hdr *tx_hdr;
-		struct zd_tx_skb_control_block *cb =
-			(struct zd_tx_skb_control_block *)skb->cb;
 
-		ZD_ASSERT(cb->control != NULL);
 		tx_hdr = (struct ieee80211_hdr *)skb->data;
 		if (likely(!compare_ether_addr(tx_hdr->addr2, rx_hdr->addr1)))
 		{
 			struct ieee80211_tx_status status = {{0}};
-			memcpy(&status.control,
-		               cb->control, sizeof(status.control));
 			status.flags = IEEE80211_TX_STATUS_ACK;
 			status.ack_signal = stats->ssi;
 			__skb_unlink(skb, q);
-			clear_tx_skb_control_block(skb);
-			ieee80211_tx_status_irqsafe(dev, skb, &status);
+			tx_status(dev, skb, &status);
 			goto out;
 		}
 	}
-- 
1.5.2.2

