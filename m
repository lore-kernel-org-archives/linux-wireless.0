Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:36996 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0AHRbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:31:48 -0500
Date: Fri, 8 Jan 2010 18:31:47 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 09/11] mwl8k: allow limiting the amount of transmit reclaim done
Message-ID: <20100108173147.GC1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a limit argument to mwl8k_txq_reclaim(), to allow limiting the
number of packets that it will reclaim, and make it return the number
of packets that it reclaimed.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 759c94f..6598efc 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1249,13 +1249,15 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 		     MWL8K_TXD_STATUS_OK_RETRY |		\
 		     MWL8K_TXD_STATUS_OK_MORE_RETRY))
 
-static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
+static int
+mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_tx_queue *txq = priv->txq + index;
-	int wake = 0;
+	int processed;
 
-	while (txq->stats.len > 0) {
+	processed = 0;
+	while (txq->stats.len > 0 && limit--) {
 		int tx;
 		struct mwl8k_tx_desc *tx_desc;
 		unsigned long addr;
@@ -1302,11 +1304,13 @@ static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
 
 		ieee80211_tx_status_irqsafe(hw, skb);
 
-		wake = 1;
+		processed++;
 	}
 
-	if (wake && priv->radio_on && !mutex_is_locked(&priv->fw_mutex))
+	if (processed && priv->radio_on && !mutex_is_locked(&priv->fw_mutex))
 		ieee80211_wake_queue(hw, index);
+
+	return processed;
 }
 
 /* must be called only when the card's transmit is completely halted */
@@ -1315,7 +1319,7 @@ static void mwl8k_txq_deinit(struct ieee80211_hw *hw, int index)
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_tx_queue *txq = priv->txq + index;
 
-	mwl8k_txq_reclaim(hw, index, 1);
+	mwl8k_txq_reclaim(hw, index, INT_MAX, 1);
 
 	kfree(txq->skb);
 	txq->skb = NULL;
@@ -3084,7 +3088,7 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 
 	/* Return all skbs to mac80211 */
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
-		mwl8k_txq_reclaim(hw, i, 1);
+		mwl8k_txq_reclaim(hw, i, INT_MAX, 1);
 }
 
 static int mwl8k_add_interface(struct ieee80211_hw *hw,
@@ -3647,7 +3651,7 @@ static void mwl8k_tx_reclaim_handler(unsigned long data)
 
 	spin_lock_bh(&priv->tx_lock);
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
-		mwl8k_txq_reclaim(hw, i, 0);
+		mwl8k_txq_reclaim(hw, i, INT_MAX, 0);
 
 	if (priv->tx_wait != NULL && !priv->pending_tx_pkts) {
 		complete(priv->tx_wait);
@@ -4021,7 +4025,7 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 
 	/* Return all skbs to mac80211 */
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
-		mwl8k_txq_reclaim(hw, i, 1);
+		mwl8k_txq_reclaim(hw, i, INT_MAX, 1);
 
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
 		mwl8k_txq_deinit(hw, i);
-- 
1.5.6.4
