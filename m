Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:52578 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1DULbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 07:31:12 -0400
From: Nishant Sarmukadam <nishants@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, pnemavat@marvell.com,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH V3 1/4] mwl8k: Do not stop tx queues
Date: Thu, 21 Apr 2011 16:34:56 +0530
Message-Id: <1303383899-3262-1-git-send-email-nishants@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pradeep Nemavat <pnemavat@marvell.com>

This is in preparation to support life time expiry of packets in the
hardware to avoid head-of-line blocking where a slow client can
hog a tx queue and affect the traffic to a faster client from the same
queue. Time stamp the packets in driver to allow dropping them in the
hardware if they are queued for more than 500ms.

If queues are stopped, packets will be queued up outside the driver.
Since we will be able to timestamp the packets only after they hit the
driver, the timestamp will be less accurate since we cannot consider
the time the packets spent in queues outside the driver. With this commit,
to achieve accurate timestamping, the tx queues will not be stopped in
normal conditions. The only scenarios where the queues will be stopped are
when firmware commands are executing or if the interface is brought down.
Now, we need to be prepared for a situation where packets hit the driver
even after the tx queues are full. Drop all such packets in the driver itself.

Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ebaae35..7968301 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1666,10 +1666,6 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 		processed++;
 	}
 
-	if (index < MWL8K_TX_WMM_QUEUES && processed && priv->radio_on &&
-	    !mutex_is_locked(&priv->fw_mutex))
-		ieee80211_wake_queue(hw, index);
-
 	return processed;
 }
 
@@ -1951,13 +1947,14 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 
 	txq = priv->txq + index;
 
-	if (index >= MWL8K_TX_WMM_QUEUES && txq->len >= MWL8K_TX_DESCS) {
-		/* This is the case in which the tx packet is destined for an
-		 * AMPDU queue and that AMPDU queue is full.  Because we don't
-		 * start and stop the AMPDU queues, we must drop these packets.
-		 */
-		dev_kfree_skb(skb);
+	if (txq->len >= MWL8K_TX_DESCS) {
+		if (start_ba_session) {
+			spin_lock(&priv->stream_lock);
+			mwl8k_remove_stream(hw, stream);
+			spin_unlock(&priv->stream_lock);
+		}
 		spin_unlock_bh(&priv->tx_lock);
+		dev_kfree_skb(skb);
 		return;
 	}
 
@@ -1985,9 +1982,6 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	if (txq->tail == MWL8K_TX_DESCS)
 		txq->tail = 0;
 
-	if (txq->head == txq->tail && index < MWL8K_TX_WMM_QUEUES)
-		ieee80211_stop_queue(hw, index);
-
 	mwl8k_tx_start(priv);
 
 	spin_unlock_bh(&priv->tx_lock);
-- 
1.6.0.3

