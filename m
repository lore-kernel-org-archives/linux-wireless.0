Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:33977 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYGWRRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 13:17:05 -0400
From: Daniel Wagner <wagi@monom.org>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Daniel Wagner <wagi@monom.org>
Subject: [PATCH v2] rt2x00mac: In error case stop netdev queue, free skb and return NETDEV_TX_OK
Date: Wed, 23 Jul 2008 19:17:01 +0200
Message-Id: <1216833421-29186-1-git-send-email-wagi@monom.org> (sfid-20080723_191708_211721_48267172)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not allowed to use NETDEV_TX_BUSY in tx path anymore.

Signed-off-by: Daniel Wagner <wagi@monom.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>

---
v2: - Return non fishy error values.
    - Use a exit_fail goto for the error path.
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |   44 ++++++++++++++-----------------
 1 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 77af1df..bb0ce51 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -37,6 +37,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_tx_info *rts_info;
 	struct sk_buff *skb;
 	int size;
+	int retval = 0;
 
 	if (tx_info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
 		size = sizeof(struct ieee80211_cts);
@@ -44,9 +45,9 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 		size = sizeof(struct ieee80211_rts);
 
 	skb = dev_alloc_skb(size + rt2x00dev->hw->extra_tx_headroom);
-	if (!skb) {
+	if (unlikely(!skb)) {
 		WARNING(rt2x00dev, "Failed to create RTS/CTS frame.\n");
-		return NETDEV_TX_BUSY;
+		return -ENOMEM;
 	}
 
 	skb_reserve(skb, rt2x00dev->hw->extra_tx_headroom);
@@ -82,12 +83,11 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 				  frag_skb->data, size, tx_info,
 				  (struct ieee80211_rts *)(skb->data));
 
-	if (rt2x00queue_write_tx_frame(queue, skb)) {
+	retval = rt2x00queue_write_tx_frame(queue, skb);
+	if (retval)
 		WARNING(rt2x00dev, "Failed to send RTS/CTS frame.\n");
-		return NETDEV_TX_BUSY;
-	}
 
-	return NETDEV_TX_OK;
+	return retval;
 }
 
 int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
@@ -106,11 +106,8 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * Note that we can only stop the TX queues inside the TX path
 	 * due to possible race conditions in mac80211.
 	 */
-	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags)) {
-		ieee80211_stop_queues(hw);
-		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
-	}
+	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags))
+		goto exit_fail;
 
 	/*
 	 * Determine which queue to put packet on.
@@ -141,15 +138,11 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if ((tx_info->flags & (IEEE80211_TX_CTL_USE_RTS_CTS |
 			       IEEE80211_TX_CTL_USE_CTS_PROTECT)) &&
 	    !rt2x00dev->ops->hw->set_rts_threshold) {
-		if (rt2x00queue_available(queue) <= 1) {
-			ieee80211_stop_queue(rt2x00dev->hw, qid);
-			return NETDEV_TX_BUSY;
-		}
-
-		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb)) {
-			ieee80211_stop_queue(rt2x00dev->hw, qid);
-			return NETDEV_TX_BUSY;
-		}
+		if (rt2x00queue_available(queue) <= 1)
+			goto exit_fail;
+
+		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb))
+			goto exit_fail;
 	}
 
 	/*
@@ -164,15 +157,18 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		ieee80211hdr->seq_ctrl |= cpu_to_le16(intf->seqno);
 	}
 
-	if (rt2x00queue_write_tx_frame(queue, skb)) {
-		ieee80211_stop_queue(rt2x00dev->hw, qid);
-		return NETDEV_TX_BUSY;
-	}
+	if (rt2x00queue_write_tx_frame(queue, skb))
+		goto exit_fail;
 
 	if (rt2x00queue_threshold(queue))
 		ieee80211_stop_queue(rt2x00dev->hw, qid);
 
 	return NETDEV_TX_OK;
+
+ exit_fail:
+	ieee80211_stop_queue(rt2x00dev->hw, qid);
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_tx);
 
-- 
1.5.6.2

