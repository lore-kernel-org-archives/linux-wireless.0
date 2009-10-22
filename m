Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49172 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbZJVShK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:10 -0400
Date: Thu, 22 Oct 2009 20:19:45 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 05/28] mwl8k: use the mac80211-provided workqueue instead of creating our own
Message-ID: <20091022181945.GG1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   28 ++++++----------------------
 1 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 0b4fa14..77985e9 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -195,9 +195,6 @@ struct mwl8k_priv {
 
 	/* Tasklet to reclaim TX descriptors and buffers after tx */
 	struct tasklet_struct tx_reclaim_task;
-
-	/* Work thread to serialize configuration requests */
-	struct workqueue_struct *config_wq;
 };
 
 /* Per interface specific private data */
@@ -881,9 +878,11 @@ mwl8k_capture_bssid(struct mwl8k_priv *priv, struct ieee80211_hdr *wh)
 		!compare_ether_addr(wh->addr3, priv->capture_bssid);
 }
 
-static inline void mwl8k_save_beacon(struct mwl8k_priv *priv,
-							struct sk_buff *skb)
+static inline void mwl8k_save_beacon(struct ieee80211_hw *hw,
+				     struct sk_buff *skb)
 {
+	struct mwl8k_priv *priv = hw->priv;
+
 	priv->capture_beacon = false;
 	memset(priv->capture_bssid, 0, ETH_ALEN);
 
@@ -894,8 +893,7 @@ static inline void mwl8k_save_beacon(struct mwl8k_priv *priv,
 	 */
 	priv->beacon_skb = skb_copy(skb, GFP_ATOMIC);
 	if (priv->beacon_skb != NULL)
-		queue_work(priv->config_wq,
-				&priv->finalize_join_worker);
+		ieee80211_queue_work(hw, &priv->finalize_join_worker);
 }
 
 static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
@@ -940,7 +938,7 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		 * send a FINALIZE_JOIN command to the firmware.
 		 */
 		if (mwl8k_capture_bssid(priv, wh))
-			mwl8k_save_beacon(priv, skb);
+			mwl8k_save_beacon(hw, skb);
 
 		memset(&status, 0, sizeof(status));
 		status.mactime = 0;
@@ -2504,9 +2502,6 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 	/* Stop tx reclaim tasklet */
 	tasklet_disable(&priv->tx_reclaim_task);
 
-	/* Stop config thread */
-	flush_workqueue(priv->config_wq);
-
 	/* Return all skbs to mac80211 */
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
 		mwl8k_txq_reclaim(hw, i, 1);
@@ -2920,11 +2915,6 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 			mwl8k_tx_reclaim_handler, (unsigned long)hw);
 	tasklet_disable(&priv->tx_reclaim_task);
 
-	/* Config workthread */
-	priv->config_wq = create_singlethread_workqueue("mwl8k_config");
-	if (priv->config_wq == NULL)
-		goto err_iounmap;
-
 	/* Power management cookie */
 	priv->cookie = pci_alloc_consistent(priv->pdev, 4, &priv->cookie_dma);
 	if (priv->cookie == NULL)
@@ -3047,9 +3037,6 @@ err_iounmap:
 	if (priv->regs != NULL)
 		pci_iounmap(pdev, priv->regs);
 
-	if (priv->config_wq != NULL)
-		destroy_workqueue(priv->config_wq);
-
 	pci_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
 
@@ -3082,9 +3069,6 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 	/* Remove tx reclaim tasklet */
 	tasklet_kill(&priv->tx_reclaim_task);
 
-	/* Stop config thread */
-	destroy_workqueue(priv->config_wq);
-
 	/* Stop hardware */
 	mwl8k_hw_reset(priv);
 
-- 
1.5.6.4
