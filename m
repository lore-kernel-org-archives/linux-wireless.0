Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:37001 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab0AHRcT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:32:19 -0500
Date: Fri, 8 Jan 2010 18:32:18 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 11/11] mwl8k: move receive processing to tasklet
Message-ID: <20100108173218.GE1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Like how TX reclaim is done in a tasklet, move receive processing
to tasklet context as well.  This can have nice benefits for CPU
utilisation and throughput, especially at 3-stream rates.

(Use the same CLEAR_SEL trick as the TX reclaim tasklet does, to
avoid having to touch the interrupt mask registers.)

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   47 +++++++++++++++++++++++++++++++++---------
 1 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3f55aa0..13b0e32 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -204,6 +204,9 @@ struct mwl8k_priv {
 
 	/* Tasklet to perform TX reclaim.  */
 	struct tasklet_struct poll_tx_task;
+
+	/* Tasklet to perform RX.  */
+	struct tasklet_struct poll_rx_task;
 };
 
 /* Per interface specific private data */
@@ -2971,14 +2974,14 @@ static irqreturn_t mwl8k_interrupt(int irq, void *dev_id)
 		tasklet_schedule(&priv->poll_tx_task);
 	}
 
-	if (status)
-		iowrite32(~status, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
-
 	if (status & MWL8K_A2H_INT_RX_READY) {
-		while (rxq_process(hw, 0, 1))
-			rxq_refill(hw, 0, 1);
+		status &= ~MWL8K_A2H_INT_RX_READY;
+		tasklet_schedule(&priv->poll_rx_task);
 	}
 
+	if (status)
+		iowrite32(~status, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
+
 	if (status & MWL8K_A2H_INT_OPC_DONE) {
 		if (priv->hostcmd_wait != NULL)
 			complete(priv->hostcmd_wait);
@@ -3022,6 +3025,24 @@ static void mwl8k_tx_poll(unsigned long data)
 	}
 }
 
+static void mwl8k_rx_poll(unsigned long data)
+{
+	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
+	struct mwl8k_priv *priv = hw->priv;
+	int limit;
+
+	limit = 32;
+	limit -= rxq_process(hw, 0, limit);
+	limit -= rxq_refill(hw, 0, limit);
+
+	if (limit) {
+		writel(~MWL8K_A2H_INT_RX_READY,
+		       priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
+	} else {
+		tasklet_schedule(&priv->poll_rx_task);
+	}
+}
+
 
 /*
  * Core driver operations.
@@ -3057,8 +3078,9 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 		return -EIO;
 	}
 
-	/* Enable tx reclaim tasklet */
+	/* Enable TX reclaim and RX tasklets.  */
 	tasklet_enable(&priv->poll_tx_task);
+	tasklet_enable(&priv->poll_rx_task);
 
 	/* Enable interrupts */
 	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
@@ -3092,6 +3114,7 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 		iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 		free_irq(priv->pdev->irq, hw);
 		tasklet_disable(&priv->poll_tx_task);
+		tasklet_disable(&priv->poll_rx_task);
 	}
 
 	return rc;
@@ -3115,8 +3138,9 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 	if (priv->beacon_skb != NULL)
 		dev_kfree_skb(priv->beacon_skb);
 
-	/* Stop tx reclaim tasklet */
+	/* Stop TX reclaim and RX tasklets.  */
 	tasklet_disable(&priv->poll_tx_task);
+	tasklet_disable(&priv->poll_rx_task);
 
 	/* Return all skbs to mac80211 */
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
@@ -3873,9 +3897,11 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	/* Finalize join worker */
 	INIT_WORK(&priv->finalize_join_worker, mwl8k_finalize_join_worker);
 
-	/* TX reclaim tasklet */
+	/* TX reclaim and RX tasklets.  */
 	tasklet_init(&priv->poll_tx_task, mwl8k_tx_poll, (unsigned long)hw);
 	tasklet_disable(&priv->poll_tx_task);
+	tasklet_init(&priv->poll_rx_task, mwl8k_rx_poll, (unsigned long)hw);
+	tasklet_disable(&priv->poll_rx_task);
 
 	/* Power management cookie */
 	priv->cookie = pci_alloc_consistent(priv->pdev, 4, &priv->cookie_dma);
@@ -3904,7 +3930,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-	iowrite32(MWL8K_A2H_INT_TX_DONE,
+	iowrite32(MWL8K_A2H_INT_TX_DONE | MWL8K_A2H_INT_RX_READY,
 		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_CLEAR_SEL);
 	iowrite32(0xffffffff, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
 
@@ -4032,8 +4058,9 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 
 	ieee80211_unregister_hw(hw);
 
-	/* Remove tx reclaim tasklet */
+	/* Remove TX reclaim and RX tasklets.  */
 	tasklet_kill(&priv->poll_tx_task);
+	tasklet_kill(&priv->poll_rx_task);
 
 	/* Stop hardware */
 	mwl8k_hw_reset(priv);
-- 
1.5.6.4
