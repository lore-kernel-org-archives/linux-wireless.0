Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40189 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbZHRDxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:53:13 -0400
Date: Tue, 18 Aug 2009 05:53:14 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 14/29] mwl8k: don't hardcode the number of transmit queues
Message-ID: <20090818035314.GS18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use MWL8K_TX_QUEUES instead of a hardcoded "4" in a couple of places.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 86b6b5d..f482922 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1080,17 +1080,17 @@ struct mwl8k_txq_info {
 };
 
 static int mwl8k_scan_tx_ring(struct mwl8k_priv *priv,
-				struct mwl8k_txq_info txinfo[],
-				u32 num_queues)
+				struct mwl8k_txq_info *txinfo)
 {
 	int count, desc, status;
 	struct mwl8k_tx_queue *txq;
 	struct mwl8k_tx_desc *tx_desc;
 	int ndescs = 0;
 
-	memset(txinfo, 0, num_queues * sizeof(struct mwl8k_txq_info));
+	memset(txinfo, 0, MWL8K_TX_QUEUES * sizeof(struct mwl8k_txq_info));
+
 	spin_lock_bh(&priv->tx_lock);
-	for (count = 0; count < num_queues; count++) {
+	for (count = 0; count < MWL8K_TX_QUEUES; count++) {
 		txq = priv->txq + count;
 		txinfo[count].len = txq->tx_stats.len;
 		txinfo[count].head = txq->tx_head;
@@ -1135,7 +1135,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw, u32 delay_ms)
 	spin_unlock_bh(&priv->tx_lock);
 
 	if (count) {
-		struct mwl8k_txq_info txinfo[4];
+		struct mwl8k_txq_info txinfo[MWL8K_TX_QUEUES];
 		int index;
 		int newcount;
 
@@ -1152,8 +1152,8 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw, u32 delay_ms)
 		printk(KERN_ERR "%s(%u) TIMEDOUT:%ums Pend:%u-->%u\n",
 		       __func__, __LINE__, delay_ms, count, newcount);
 
-		mwl8k_scan_tx_ring(priv, txinfo, 4);
-		for (index = 0; index < 4; index++)
+		mwl8k_scan_tx_ring(priv, txinfo);
+		for (index = 0; index < MWL8K_TX_QUEUES; index++)
 			printk(KERN_ERR
 				"TXQ:%u L:%u H:%u T:%u FW:%u DRV:%u U:%u\n",
 					index,
-- 
1.5.6.4
