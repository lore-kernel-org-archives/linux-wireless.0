Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57155 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZK3RM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:12:58 -0500
Date: Mon, 30 Nov 2009 18:13:04 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 07/12] mwl8k: allow more time for transmit rings to drain
Message-ID: <20091130171304.GJ20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before issuing any firmware commands, we wait for the transmit rings
to drain, to prevent control versus data path synchronization issues.
In some cases, this can end up taking longer than the current hardcoded
limit of 5 seconds, for example if the transmit rings are filled with
packets for a host that has dropped off the air and we end up
retransmitting every pending packet at the lowest rate a couple of
times.

This patch changes mwl8k_tx_wait_empty() to only bail out on timeout
expiry if there was no change in the number of packets pending in the
transmit rings during the waiting period.  If at least one transmit
ring entry was reclaimed while we were waiting, we are apparently still
making progress, and we'll allow waiting for another timeout period.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  133 ++++++++++++++++++++++--------------------
 1 files changed, 70 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 2d4724b..8f7546f 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1237,99 +1237,106 @@ static inline void mwl8k_tx_start(struct mwl8k_priv *priv)
 	ioread32(priv->regs + MWL8K_HIU_INT_CODE);
 }
 
-struct mwl8k_txq_info {
-	u32 fw_owned;
-	u32 drv_owned;
-	u32 unused;
-	u32 len;
-	u32 head;
-	u32 tail;
-};
-
-static int mwl8k_scan_tx_ring(struct mwl8k_priv *priv,
-				struct mwl8k_txq_info *txinfo)
+static void mwl8k_dump_tx_rings(struct ieee80211_hw *hw)
 {
-	int count, desc, status;
-	struct mwl8k_tx_queue *txq;
-	struct mwl8k_tx_desc *tx_desc;
-	int ndescs = 0;
+	struct mwl8k_priv *priv = hw->priv;
+	int i;
 
-	memset(txinfo, 0, MWL8K_TX_QUEUES * sizeof(struct mwl8k_txq_info));
+	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
+		struct mwl8k_tx_queue *txq = priv->txq + i;
+		int fw_owned = 0;
+		int drv_owned = 0;
+		int unused = 0;
+		int desc;
 
-	for (count = 0; count < MWL8K_TX_QUEUES; count++) {
-		txq = priv->txq + count;
-		txinfo[count].len = txq->stats.len;
-		txinfo[count].head = txq->head;
-		txinfo[count].tail = txq->tail;
 		for (desc = 0; desc < MWL8K_TX_DESCS; desc++) {
-			tx_desc = txq->txd + desc;
-			status = le32_to_cpu(tx_desc->status);
+			struct mwl8k_tx_desc *tx_desc = txq->txd + desc;
+			u32 status;
 
+			status = le32_to_cpu(tx_desc->status);
 			if (status & MWL8K_TXD_STATUS_FW_OWNED)
-				txinfo[count].fw_owned++;
+				fw_owned++;
 			else
-				txinfo[count].drv_owned++;
+				drv_owned++;
 
 			if (tx_desc->pkt_len == 0)
-				txinfo[count].unused++;
+				unused++;
 		}
-	}
 
-	return ndescs;
+		printk(KERN_ERR "%s: txq[%d] len=%d head=%d tail=%d "
+		       "fw_owned=%d drv_owned=%d unused=%d\n",
+		       wiphy_name(hw->wiphy), i,
+		       txq->stats.len, txq->head, txq->tail,
+		       fw_owned, drv_owned, unused);
+	}
 }
 
 /*
  * Must be called with priv->fw_mutex held and tx queues stopped.
  */
+#define MWL8K_TX_WAIT_TIMEOUT_MS	1000
+
 static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	DECLARE_COMPLETION_ONSTACK(tx_wait);
-	u32 count;
-	unsigned long timeout;
+	int retry;
+	int rc;
 
 	might_sleep();
 
+	/*
+	 * The TX queues are stopped at this point, so this test
+	 * doesn't need to take ->tx_lock.
+	 */
+	if (!priv->pending_tx_pkts)
+		return 0;
+
+	retry = 0;
+	rc = 0;
+
 	spin_lock_bh(&priv->tx_lock);
-	count = priv->pending_tx_pkts;
-	if (count)
-		priv->tx_wait = &tx_wait;
-	spin_unlock_bh(&priv->tx_lock);
+	priv->tx_wait = &tx_wait;
+	while (!rc) {
+		int oldcount;
+		unsigned long timeout;
 
-	if (count) {
-		struct mwl8k_txq_info txinfo[MWL8K_TX_QUEUES];
-		int index;
-		int newcount;
+		oldcount = priv->pending_tx_pkts;
 
+		spin_unlock_bh(&priv->tx_lock);
 		timeout = wait_for_completion_timeout(&tx_wait,
-					msecs_to_jiffies(5000));
-		if (timeout)
-			return 0;
-
+			    msecs_to_jiffies(MWL8K_TX_WAIT_TIMEOUT_MS));
 		spin_lock_bh(&priv->tx_lock);
-		priv->tx_wait = NULL;
-		newcount = priv->pending_tx_pkts;
-		mwl8k_scan_tx_ring(priv, txinfo);
-		spin_unlock_bh(&priv->tx_lock);
 
-		printk(KERN_ERR "%s(%u) TIMEDOUT:5000ms Pend:%u-->%u\n",
-		       __func__, __LINE__, count, newcount);
+		if (timeout) {
+			WARN_ON(priv->pending_tx_pkts);
+			if (retry) {
+				printk(KERN_NOTICE "%s: tx rings drained\n",
+				       wiphy_name(hw->wiphy));
+			}
+			break;
+		}
 
-		for (index = 0; index < MWL8K_TX_QUEUES; index++)
-			printk(KERN_ERR "TXQ:%u L:%u H:%u T:%u FW:%u "
-			       "DRV:%u U:%u\n",
-					index,
-					txinfo[index].len,
-					txinfo[index].head,
-					txinfo[index].tail,
-					txinfo[index].fw_owned,
-					txinfo[index].drv_owned,
-					txinfo[index].unused);
+		if (priv->pending_tx_pkts < oldcount) {
+			printk(KERN_NOTICE "%s: timeout waiting for tx "
+			       "rings to drain (%d -> %d pkts), retrying\n",
+			       wiphy_name(hw->wiphy), oldcount,
+			       priv->pending_tx_pkts);
+			retry = 1;
+			continue;
+		}
+
+		priv->tx_wait = NULL;
+
+		printk(KERN_ERR "%s: tx rings stuck for %d ms\n",
+		       wiphy_name(hw->wiphy), MWL8K_TX_WAIT_TIMEOUT_MS);
+		mwl8k_dump_tx_rings(hw);
 
-		return -ETIMEDOUT;
+		rc = -ETIMEDOUT;
 	}
+	spin_unlock_bh(&priv->tx_lock);
 
-	return 0;
+	return rc;
 }
 
 #define MWL8K_TXD_SUCCESS(status)				\
-- 
1.5.6.4
