Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45757 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZHRDyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:54:16 -0400
Date: Tue, 18 Aug 2009 05:54:17 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 20/29] mwl8k: get rid of mwl8k_stop() workqueue use
Message-ID: <20090818035417.GY18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   28 +---------------------------
 1 files changed, 1 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 69e6879..6b16542 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2551,41 +2551,15 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 	return rc;
 }
 
-struct mwl8k_stop_worker {
-	struct mwl8k_work_struct header;
-};
-
-static int mwl8k_stop_wt(struct work_struct *wt)
-{
-	struct mwl8k_stop_worker *worker = (struct mwl8k_stop_worker *)wt;
-	struct ieee80211_hw *hw = worker->header.hw;
-
-	return mwl8k_cmd_802_11_radio_disable(hw);
-}
-
 static void mwl8k_stop(struct ieee80211_hw *hw)
 {
-	int rc;
-	struct mwl8k_stop_worker *worker;
 	struct mwl8k_priv *priv = hw->priv;
 	int i;
 
-	if (priv->vif != NULL)
-		return;
+	mwl8k_cmd_802_11_radio_disable(hw);
 
 	ieee80211_stop_queues(hw);
 
-	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
-	if (worker == NULL)
-		return;
-
-	worker->header.sleep = 1;
-
-	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_stop_wt);
-	kfree(worker);
-	if (rc == -ETIMEDOUT)
-		printk(KERN_ERR "%s() timed out\n", __func__);
-
 	/* Disable interrupts */
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 	free_irq(priv->pdev->irq, hw);
-- 
1.5.6.4
