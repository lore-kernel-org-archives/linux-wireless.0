Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:36999 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0AHRcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:32:04 -0500
Date: Fri, 8 Jan 2010 18:32:01 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 10/11] mwl8k: keep TX_DONE interrupt masked while transmit reclaim is running
Message-ID: <20100108173201.GD1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By making use of the CLEAR_SEL feature of the mwl8k host interface
interrupt controller, we can keep the TX_DONE interrupt source masked
while the transmit reclaim tasklet is running (NAPI style) without
having to touch the interrupt controller's interrupt mask register
when entering or exiting polling mode, and without having to do any
more register reads/writes than we do now.

When CLEAR_SEL is enabled on the TX_DONE interrupt source, reading
the interrupt status register will clear the TX_DONE status bit if
it was set, allowing it to be set again if a new TX_DONE event arrives
while we are running the TX reclaim tasklet, but such a new event will
then not trigger another PCI interrupt until a zero is written to the
TX_DONE interrupt status register bit.

I.e., if we write a zero to the TX_DONE interrupt source bit in the
interrupt status register when the TX reclaim tasklet thinks it's
done, a PCI interrupt will be triggered if a new TX_DONE event arrived
from the hardware between us deciding that there is no more work to do
and re-enabling the TX_DONE interrupt source, thereby avoiding the
classic NAPI poll mode exit race that would otherwise occur.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   77 +++++++++++++++++++++++++-----------------
 1 files changed, 46 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 6598efc..3f55aa0 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -202,8 +202,8 @@ struct mwl8k_priv {
 	 */
 	struct work_struct finalize_join_worker;
 
-	/* Tasklet to reclaim TX descriptors and buffers after tx */
-	struct tasklet_struct tx_reclaim_task;
+	/* Tasklet to perform TX reclaim.  */
+	struct tasklet_struct poll_tx_task;
 };
 
 /* Per interface specific private data */
@@ -2963,13 +2963,16 @@ static irqreturn_t mwl8k_interrupt(int irq, void *dev_id)
 	u32 status;
 
 	status = ioread32(priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
-	iowrite32(~status, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
-
 	if (!status)
 		return IRQ_NONE;
 
-	if (status & MWL8K_A2H_INT_TX_DONE)
-		tasklet_schedule(&priv->tx_reclaim_task);
+	if (status & MWL8K_A2H_INT_TX_DONE) {
+		status &= ~MWL8K_A2H_INT_TX_DONE;
+		tasklet_schedule(&priv->poll_tx_task);
+	}
+
+	if (status)
+		iowrite32(~status, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
 
 	if (status & MWL8K_A2H_INT_RX_READY) {
 		while (rxq_process(hw, 0, 1))
@@ -2990,6 +2993,35 @@ static irqreturn_t mwl8k_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void mwl8k_tx_poll(unsigned long data)
+{
+	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
+	struct mwl8k_priv *priv = hw->priv;
+	int limit;
+	int i;
+
+	limit = 32;
+
+	spin_lock_bh(&priv->tx_lock);
+
+	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+		limit -= mwl8k_txq_reclaim(hw, i, limit, 0);
+
+	if (!priv->pending_tx_pkts && priv->tx_wait != NULL) {
+		complete(priv->tx_wait);
+		priv->tx_wait = NULL;
+	}
+
+	spin_unlock_bh(&priv->tx_lock);
+
+	if (limit) {
+		writel(~MWL8K_A2H_INT_TX_DONE,
+		       priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
+	} else {
+		tasklet_schedule(&priv->poll_tx_task);
+	}
+}
+
 
 /*
  * Core driver operations.
@@ -3026,7 +3058,7 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 	}
 
 	/* Enable tx reclaim tasklet */
-	tasklet_enable(&priv->tx_reclaim_task);
+	tasklet_enable(&priv->poll_tx_task);
 
 	/* Enable interrupts */
 	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
@@ -3059,7 +3091,7 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 	if (rc) {
 		iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 		free_irq(priv->pdev->irq, hw);
-		tasklet_disable(&priv->tx_reclaim_task);
+		tasklet_disable(&priv->poll_tx_task);
 	}
 
 	return rc;
@@ -3084,7 +3116,7 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 		dev_kfree_skb(priv->beacon_skb);
 
 	/* Stop tx reclaim tasklet */
-	tasklet_disable(&priv->tx_reclaim_task);
+	tasklet_disable(&priv->poll_tx_task);
 
 	/* Return all skbs to mac80211 */
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
@@ -3643,23 +3675,6 @@ static const struct ieee80211_ops mwl8k_ops = {
 	.ampdu_action		= mwl8k_ampdu_action,
 };
 
-static void mwl8k_tx_reclaim_handler(unsigned long data)
-{
-	int i;
-	struct ieee80211_hw *hw = (struct ieee80211_hw *) data;
-	struct mwl8k_priv *priv = hw->priv;
-
-	spin_lock_bh(&priv->tx_lock);
-	for (i = 0; i < MWL8K_TX_QUEUES; i++)
-		mwl8k_txq_reclaim(hw, i, INT_MAX, 0);
-
-	if (priv->tx_wait != NULL && !priv->pending_tx_pkts) {
-		complete(priv->tx_wait);
-		priv->tx_wait = NULL;
-	}
-	spin_unlock_bh(&priv->tx_lock);
-}
-
 static void mwl8k_finalize_join_worker(struct work_struct *work)
 {
 	struct mwl8k_priv *priv =
@@ -3859,9 +3874,8 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	INIT_WORK(&priv->finalize_join_worker, mwl8k_finalize_join_worker);
 
 	/* TX reclaim tasklet */
-	tasklet_init(&priv->tx_reclaim_task,
-			mwl8k_tx_reclaim_handler, (unsigned long)hw);
-	tasklet_disable(&priv->tx_reclaim_task);
+	tasklet_init(&priv->poll_tx_task, mwl8k_tx_poll, (unsigned long)hw);
+	tasklet_disable(&priv->poll_tx_task);
 
 	/* Power management cookie */
 	priv->cookie = pci_alloc_consistent(priv->pdev, 4, &priv->cookie_dma);
@@ -3890,7 +3904,8 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_CLEAR_SEL);
+	iowrite32(MWL8K_A2H_INT_TX_DONE,
+		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_CLEAR_SEL);
 	iowrite32(0xffffffff, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
 
 	rc = request_irq(priv->pdev->irq, mwl8k_interrupt,
@@ -4018,7 +4033,7 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 	ieee80211_unregister_hw(hw);
 
 	/* Remove tx reclaim tasklet */
-	tasklet_kill(&priv->tx_reclaim_task);
+	tasklet_kill(&priv->poll_tx_task);
 
 	/* Stop hardware */
 	mwl8k_hw_reset(priv);
-- 
1.5.6.4
