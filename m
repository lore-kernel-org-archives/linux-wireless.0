Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:36790 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755377Ab1DFKcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 06:32:04 -0400
Subject: [PATCH] mwl8k: do not free unrequested irq
From: Nishant Sarmukadam <nishants@marvell.com>
Reply-To: nishants@marvell.com
To: <linux-wireless@vger.kernel.org>
CC: <buytenh@wantstofly.org>
Content-Type: text/plain
Date: Wed, 6 Apr 2011 14:18:46 +0530
Message-ID: <1302079726.3447.49.camel@localhost.localdomain>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Cavagnolo <brian@cozybit.com>

When the mwl8k driver attempts and fails to switch from sta to ap
firmware (or vice-versa) in the mwl8k_add_interface routine, the
mwl8k_stop routine will be called. This routine must not attempt
to free the irq if it was not requested.

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index d5e0479..8913180 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -157,6 +157,7 @@ struct mwl8k_ampdu_stream {
 struct mwl8k_priv {
 	struct ieee80211_hw *hw;
 	struct pci_dev *pdev;
+	int irq;
 
 	struct mwl8k_device_info *device_info;
 
@@ -4272,9 +4273,11 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 	rc = request_irq(priv->pdev->irq, mwl8k_interrupt,
 			 IRQF_SHARED, MWL8K_NAME, hw);
 	if (rc) {
+		priv->irq = -1;
 		wiphy_err(hw->wiphy, "failed to register IRQ handler\n");
 		return -EIO;
 	}
+	priv->irq = priv->pdev->irq;
 
 	/* Enable TX reclaim and RX tasklets.  */
 	tasklet_enable(&priv->poll_tx_task);
@@ -4311,6 +4314,7 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 	if (rc) {
 		iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 		free_irq(priv->pdev->irq, hw);
+		priv->irq = -1;
 		tasklet_disable(&priv->poll_tx_task);
 		tasklet_disable(&priv->poll_rx_task);
 	}
@@ -4329,7 +4333,10 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 
 	/* Disable interrupts */
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-	free_irq(priv->pdev->irq, hw);
+	if (priv->irq != -1) {
+		free_irq(priv->pdev->irq, hw);
+		priv->irq = -1;
+	}
 
 	/* Stop finalize join worker */
 	cancel_work_sync(&priv->finalize_join_worker);
-- 
1.6.0.3



