Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:56785 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYGWJ7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 05:59:23 -0400
From: Daniel Wagner <wagi@monom.org>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Daniel Wagner <wagi@monom.org>
Subject: [PATCH] rt2x00mac: In error case stop netdev queue, free skb and return NETDEV_TX_OK
Date: Wed, 23 Jul 2008 11:27:59 +0200
Message-Id: <1216805279-19149-1-git-send-email-wagi@monom.org> (sfid-20080723_115928_859863_E9CEFEAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not allowed to use NETDEV_TX_BUSY in tx path anymore.

Signed-off-by: Daniel Wagner <wagi@monom.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 77af1df..64a70c6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -46,7 +46,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 	skb = dev_alloc_skb(size + rt2x00dev->hw->extra_tx_headroom);
 	if (!skb) {
 		WARNING(rt2x00dev, "Failed to create RTS/CTS frame.\n");
-		return NETDEV_TX_BUSY;
+		return -1;
 	}
 
 	skb_reserve(skb, rt2x00dev->hw->extra_tx_headroom);
@@ -84,7 +84,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 
 	if (rt2x00queue_write_tx_frame(queue, skb)) {
 		WARNING(rt2x00dev, "Failed to send RTS/CTS frame.\n");
-		return NETDEV_TX_BUSY;
+		return -1;
 	}
 
 	return NETDEV_TX_OK;
@@ -143,12 +143,14 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	    !rt2x00dev->ops->hw->set_rts_threshold) {
 		if (rt2x00queue_available(queue) <= 1) {
 			ieee80211_stop_queue(rt2x00dev->hw, qid);
-			return NETDEV_TX_BUSY;
+			dev_kfree_skb_any(skb);
+			return NETDEV_TX_OK;
 		}
 
 		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb)) {
 			ieee80211_stop_queue(rt2x00dev->hw, qid);
-			return NETDEV_TX_BUSY;
+			dev_kfree_skb_any(skb);
+			return NETDEV_TX_OK;
 		}
 	}
 
@@ -166,7 +168,8 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (rt2x00queue_write_tx_frame(queue, skb)) {
 		ieee80211_stop_queue(rt2x00dev->hw, qid);
-		return NETDEV_TX_BUSY;
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
 	}
 
 	if (rt2x00queue_threshold(queue))
-- 
1.5.6.2

