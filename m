Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49171 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524AbZJVShK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:10 -0400
Date: Thu, 22 Oct 2009 20:19:37 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 03/28] mwl8k: minor transmit quiescing rework
Message-ID: <20091022181937.GE1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Minor changes to the transmit quiescing logic:
- Clarify the locking rules for ->tx_wait: only the holder of fw_mutex
  can wait for the TX path to become idle, but tx_wait itself is read
  and cleared by the TX reclaim tasklet under tx_lock.
- Inline mwl8k_txq_busy() in its callers.
- There's no need to kick the transmitter again in
  mwl8k_tx_wait_empty(), since it will have been kicked when the
  packets currently in the TX ring were added to it.
- If the TX ring didn't drain in time, run mwl8k_scan_tx_ring() after
  reading priv->pending_pkts without dropping tx_lock in between.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 252ef9c..ba7b8ef 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -142,12 +142,14 @@ struct mwl8k_priv {
 	struct mutex fw_mutex;
 	struct task_struct *fw_mutex_owner;
 	int fw_mutex_depth;
-	struct completion *tx_wait;
 	struct completion *hostcmd_wait;
 
 	/* lock held over TX and TX reap */
 	spinlock_t tx_lock;
 
+	/* TX quiesce completion, protected by fw_mutex and tx_lock */
+	struct completion *tx_wait;
+
 	struct ieee80211_vif *vif;
 
 	struct ieee80211_channel *current_channel;
@@ -1064,11 +1066,6 @@ static inline void mwl8k_tx_start(struct mwl8k_priv *priv)
 	ioread32(priv->regs + MWL8K_HIU_INT_CODE);
 }
 
-static inline int mwl8k_txq_busy(struct mwl8k_priv *priv)
-{
-	return priv->pending_tx_pkts;
-}
-
 struct mwl8k_txq_info {
 	u32 fw_owned;
 	u32 drv_owned;
@@ -1088,7 +1085,6 @@ static int mwl8k_scan_tx_ring(struct mwl8k_priv *priv,
 
 	memset(txinfo, 0, MWL8K_TX_QUEUES * sizeof(struct mwl8k_txq_info));
 
-	spin_lock_bh(&priv->tx_lock);
 	for (count = 0; count < MWL8K_TX_QUEUES; count++) {
 		txq = priv->txq + count;
 		txinfo[count].len = txq->tx_stats.len;
@@ -1107,30 +1103,26 @@ static int mwl8k_scan_tx_ring(struct mwl8k_priv *priv,
 				txinfo[count].unused++;
 		}
 	}
-	spin_unlock_bh(&priv->tx_lock);
 
 	return ndescs;
 }
 
 /*
- * Must be called with hw->fw_mutex held and tx queues stopped.
+ * Must be called with priv->fw_mutex held and tx queues stopped.
  */
 static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
-	DECLARE_COMPLETION_ONSTACK(cmd_wait);
+	DECLARE_COMPLETION_ONSTACK(tx_wait);
 	u32 count;
 	unsigned long timeout;
 
 	might_sleep();
 
 	spin_lock_bh(&priv->tx_lock);
-	count = mwl8k_txq_busy(priv);
-	if (count) {
-		priv->tx_wait = &cmd_wait;
-		if (priv->radio_on)
-			mwl8k_tx_start(priv);
-	}
+	count = priv->pending_tx_pkts;
+	if (count)
+		priv->tx_wait = &tx_wait;
 	spin_unlock_bh(&priv->tx_lock);
 
 	if (count) {
@@ -1138,20 +1130,20 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 		int index;
 		int newcount;
 
-		timeout = wait_for_completion_timeout(&cmd_wait,
+		timeout = wait_for_completion_timeout(&tx_wait,
 					msecs_to_jiffies(5000));
 		if (timeout)
 			return 0;
 
 		spin_lock_bh(&priv->tx_lock);
 		priv->tx_wait = NULL;
-		newcount = mwl8k_txq_busy(priv);
+		newcount = priv->pending_tx_pkts;
+		mwl8k_scan_tx_ring(priv, txinfo);
 		spin_unlock_bh(&priv->tx_lock);
 
 		printk(KERN_ERR "%s(%u) TIMEDOUT:5000ms Pend:%u-->%u\n",
 		       __func__, __LINE__, count, newcount);
 
-		mwl8k_scan_tx_ring(priv, txinfo);
 		for (index = 0; index < MWL8K_TX_QUEUES; index++)
 			printk(KERN_ERR "TXQ:%u L:%u H:%u T:%u FW:%u "
 			       "DRV:%u U:%u\n",
@@ -2397,7 +2389,7 @@ static irqreturn_t mwl8k_interrupt(int irq, void *dev_id)
 
 	if (status & MWL8K_A2H_INT_QUEUE_EMPTY) {
 		if (!mutex_is_locked(&priv->fw_mutex) &&
-		    priv->radio_on && mwl8k_txq_busy(priv))
+		    priv->radio_on && priv->pending_tx_pkts)
 			mwl8k_tx_start(priv);
 	}
 
@@ -2800,7 +2792,7 @@ static void mwl8k_tx_reclaim_handler(unsigned long data)
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
 		mwl8k_txq_reclaim(hw, i, 0);
 
-	if (priv->tx_wait != NULL && mwl8k_txq_busy(priv) == 0) {
+	if (priv->tx_wait != NULL && !priv->pending_tx_pkts) {
 		complete(priv->tx_wait);
 		priv->tx_wait = NULL;
 	}
@@ -2932,11 +2924,12 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	mutex_init(&priv->fw_mutex);
 	priv->fw_mutex_owner = NULL;
 	priv->fw_mutex_depth = 0;
-	priv->tx_wait = NULL;
 	priv->hostcmd_wait = NULL;
 
 	spin_lock_init(&priv->tx_lock);
 
+	priv->tx_wait = NULL;
+
 	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
 		rc = mwl8k_txq_init(hw, i);
 		if (rc)
-- 
1.5.6.4
