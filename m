Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:52609 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0BGIVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 03:21:00 -0500
Subject: [PATCH 02/10] mwl8k: remove get_tx_stats() mac80211 op
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Lennert Buytenhek <buytenh@marvell.com>
Date: Sun, 07 Feb 2010 10:20:52 +0200
Message-ID: <20100207082052.31474.32263.stgit@tikku>
In-Reply-To: <20100207082044.31474.48583.stgit@tikku>
References: <20100207082044.31474.48583.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_tx_stats() will be removed from mac80211.

mwl8k used struct ieee80211_tx_queue_stats internally to track the queue
lenght. Replace struct ieee80211_tx_queue_stats with a simple len field
in struct mwl8k_tx_queue. Limit and count fields seemed to be unused.

Compile-tested only.

Cc: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---
 drivers/net/wireless/mwl8k.c |   35 +++++++----------------------------
 1 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f0f08f3..0cfdb9d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -119,7 +119,7 @@ struct mwl8k_tx_queue {
 	/* sw appends here */
 	int tail;
 
-	struct ieee80211_tx_queue_stats stats;
+	unsigned int len;
 	struct mwl8k_tx_desc *txd;
 	dma_addr_t txd_dma;
 	struct sk_buff **skb;
@@ -1136,8 +1136,7 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 	int size;
 	int i;
 
-	memset(&txq->stats, 0, sizeof(struct ieee80211_tx_queue_stats));
-	txq->stats.limit = MWL8K_TX_DESCS;
+	txq->len = 0;
 	txq->head = 0;
 	txq->tail = 0;
 
@@ -1213,7 +1212,7 @@ static void mwl8k_dump_tx_rings(struct ieee80211_hw *hw)
 		printk(KERN_ERR "%s: txq[%d] len=%d head=%d tail=%d "
 		       "fw_owned=%d drv_owned=%d unused=%d\n",
 		       wiphy_name(hw->wiphy), i,
-		       txq->stats.len, txq->head, txq->tail,
+		       txq->len, txq->head, txq->tail,
 		       fw_owned, drv_owned, unused);
 	}
 }
@@ -1299,7 +1298,7 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 	int processed;
 
 	processed = 0;
-	while (txq->stats.len > 0 && limit--) {
+	while (txq->len > 0 && limit--) {
 		int tx;
 		struct mwl8k_tx_desc *tx_desc;
 		unsigned long addr;
@@ -1321,8 +1320,8 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 		}
 
 		txq->head = (tx + 1) % MWL8K_TX_DESCS;
-		BUG_ON(txq->stats.len == 0);
-		txq->stats.len--;
+		BUG_ON(txq->len == 0);
+		txq->len--;
 		priv->pending_tx_pkts--;
 
 		addr = le32_to_cpu(tx_desc->pkt_phys_addr);
@@ -1454,8 +1453,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	wmb();
 	tx->status = cpu_to_le32(MWL8K_TXD_STATUS_FW_OWNED | txstatus);
 
-	txq->stats.count++;
-	txq->stats.len++;
+	txq->len++;
 	priv->pending_tx_pkts++;
 
 	txq->tail++;
@@ -3818,24 +3816,6 @@ static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return rc;
 }
 
-static int mwl8k_get_tx_stats(struct ieee80211_hw *hw,
-			      struct ieee80211_tx_queue_stats *stats)
-{
-	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_tx_queue *txq;
-	int index;
-
-	spin_lock_bh(&priv->tx_lock);
-	for (index = 0; index < MWL8K_TX_QUEUES; index++) {
-		txq = priv->txq + index;
-		memcpy(&stats[index], &txq->stats,
-			sizeof(struct ieee80211_tx_queue_stats));
-	}
-	spin_unlock_bh(&priv->tx_lock);
-
-	return 0;
-}
-
 static int mwl8k_get_stats(struct ieee80211_hw *hw,
 			   struct ieee80211_low_level_stats *stats)
 {
@@ -3871,7 +3851,6 @@ static const struct ieee80211_ops mwl8k_ops = {
 	.set_rts_threshold	= mwl8k_set_rts_threshold,
 	.sta_notify		= mwl8k_sta_notify,
 	.conf_tx		= mwl8k_conf_tx,
-	.get_tx_stats		= mwl8k_get_tx_stats,
 	.get_stats		= mwl8k_get_stats,
 	.ampdu_action		= mwl8k_ampdu_action,
 };

