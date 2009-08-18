Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45754 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbZHRDyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:54:10 -0400
Date: Tue, 18 Aug 2009 05:54:10 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 19/29] mwl8k: get rid of mwl8k_start() workqueue use
Message-ID: <20090818035410.GX18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  105 ++++++++++-------------------------------
 1 files changed, 26 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 5516058..69e6879 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2500,106 +2500,53 @@ static int mwl8k_queue_work(struct ieee80211_hw *hw,
 	return rc;
 }
 
-struct mwl8k_start_worker {
-	struct mwl8k_work_struct header;
-};
-
-static int mwl8k_start_wt(struct work_struct *wt)
-{
-	struct mwl8k_start_worker *worker = (struct mwl8k_start_worker *)wt;
-	struct ieee80211_hw *hw = worker->header.hw;
-	struct mwl8k_priv *priv = hw->priv;
-	int rc = 0;
-
-	if (priv->vif != NULL) {
-		rc = -EIO;
-		goto mwl8k_start_exit;
-	}
-
-	/* Turn on radio */
-	if (mwl8k_cmd_802_11_radio_enable(hw)) {
-		rc = -EIO;
-		goto mwl8k_start_exit;
-	}
-
-	/* Purge TX/RX HW queues */
-	if (mwl8k_cmd_set_pre_scan(hw)) {
-		rc = -EIO;
-		goto mwl8k_start_exit;
-	}
-
-	if (mwl8k_cmd_set_post_scan(hw, "\x00\x00\x00\x00\x00\x00")) {
-		rc = -EIO;
-		goto mwl8k_start_exit;
-	}
-
-	/* Enable firmware rate adaptation */
-	if (mwl8k_cmd_setrateadaptmode(hw, 0)) {
-		rc = -EIO;
-		goto mwl8k_start_exit;
-	}
-
-	/* Disable WMM. WMM gets enabled when stack sends WMM parms */
-	if (mwl8k_set_wmm(hw, 0)) {
-		rc = -EIO;
-		goto mwl8k_start_exit;
-	}
-
-	/* Disable sniffer mode */
-	if (mwl8k_enable_sniffer(hw, 0))
-		rc = -EIO;
-
-mwl8k_start_exit:
-	return rc;
-}
-
 static int mwl8k_start(struct ieee80211_hw *hw)
 {
-	struct mwl8k_start_worker *worker;
 	struct mwl8k_priv *priv = hw->priv;
 	int rc;
 
-	/* Enable tx reclaim tasklet */
-	tasklet_enable(&priv->tx_reclaim_task);
-
 	rc = request_irq(priv->pdev->irq, &mwl8k_interrupt,
 			 IRQF_SHARED, MWL8K_NAME, hw);
 	if (rc) {
 		printk(KERN_ERR "%s: failed to register IRQ handler\n",
 		       priv->name);
-		rc = -EIO;
-		goto mwl8k_start_disable_tasklet;
+		return -EIO;
 	}
 
+	/* Enable tx reclaim tasklet */
+	tasklet_enable(&priv->tx_reclaim_task);
+
 	/* Enable interrupts */
 	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 
-	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
-	if (worker == NULL) {
-		rc = -ENOMEM;
-		goto mwl8k_start_disable_irq;
-	}
+	rc = mwl8k_fw_lock(hw);
+	if (!rc) {
+		rc = mwl8k_cmd_802_11_radio_enable(hw);
 
-	worker->header.sleep = 1;
+		if (!rc)
+			rc = mwl8k_cmd_set_pre_scan(hw);
 
-	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_start_wt);
-	kfree(worker);
-	if (!rc)
-		return rc;
+		if (!rc)
+			rc = mwl8k_cmd_set_post_scan(hw,
+					"\x00\x00\x00\x00\x00\x00");
 
-	if (rc == -ETIMEDOUT)
-		printk(KERN_ERR "%s() timed out\n", __func__);
+		if (!rc)
+			rc = mwl8k_cmd_setrateadaptmode(hw, 0);
 
-	rc = -EIO;
+		if (!rc)
+			rc = mwl8k_set_wmm(hw, 0);
 
-mwl8k_start_disable_irq:
-	spin_lock_irq(&priv->tx_lock);
-	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-	spin_unlock_irq(&priv->tx_lock);
-	free_irq(priv->pdev->irq, hw);
+		if (!rc)
+			rc = mwl8k_enable_sniffer(hw, 0);
 
-mwl8k_start_disable_tasklet:
-	tasklet_disable(&priv->tx_reclaim_task);
+		mwl8k_fw_unlock(hw);
+	}
+
+	if (rc) {
+		iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
+		free_irq(priv->pdev->irq, hw);
+		tasklet_disable(&priv->tx_reclaim_task);
+	}
 
 	return rc;
 }
-- 
1.5.6.4
