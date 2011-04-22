Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23017 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab1DVRzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:55:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/10] iwlagn: refactor down path
Date: Fri, 22 Apr 2011 10:33:11 -0700
Message-Id: <1303493598-10979-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The iwl_down path really consists of multiple things,
refactor out the hardware resetting (including, of
course, related software state like irqs).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   30 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   34 +---------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |   11 +++++++++
 3 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e741128..5c7eeac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2293,3 +2293,33 @@ void iwlagn_remove_notification(struct iwl_priv *priv,
 	list_del(&wait_entry->list);
 	spin_unlock_bh(&priv->_agn.notif_wait_lock);
 }
+
+void iwlagn_stop_device(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	/* stop and reset the on-board processor */
+	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+
+	/* tell the device to stop sending interrupts */
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_disable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+	iwl_synchronize_irq(priv);
+
+	/* device going down, Stop using ICT table */
+	iwl_disable_ict(priv);
+
+	iwlagn_txq_ctx_stop(priv);
+	iwlagn_rxq_stop(priv);
+
+	/* Power-down device's busmaster DMA clocks */
+	iwl_write_prph(priv, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
+	udelay(5);
+
+	/* Make sure (redundant) we've released our request to stay awake */
+	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+
+	/* Stop the device, and put it in low power state */
+	iwl_apm_stop(priv);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2845f63..f3d9055 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -846,14 +846,6 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		iwlagn_rx_queue_restock(priv);
 }
 
-/* call this function to flush any scheduled tasklet */
-static inline void iwl_synchronize_irq(struct iwl_priv *priv)
-{
-	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(priv->pci_dev->irq);
-	tasklet_kill(&priv->irq_tasklet);
-}
-
 /* tasklet for iwlagn interrupt */
 static void iwl_irq_tasklet(struct iwl_priv *priv)
 {
@@ -2338,7 +2330,6 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv);
 
 static void __iwl_down(struct iwl_priv *priv)
 {
-	unsigned long flags;
 	int exit_pending;
 
 	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
@@ -2370,15 +2361,6 @@ static void __iwl_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		clear_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	/* stop and reset the on-board processor */
-	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
-
-	/* tell the device to stop sending interrupts */
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_disable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-	iwl_synchronize_irq(priv);
-
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
@@ -2392,21 +2374,7 @@ static void __iwl_down(struct iwl_priv *priv)
 		       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
 				STATUS_EXIT_PENDING;
 
-	/* device going down, Stop using ICT table */
-	iwl_disable_ict(priv);
-
-	iwlagn_txq_ctx_stop(priv);
-	iwlagn_rxq_stop(priv);
-
-	/* Power-down device's busmaster DMA clocks */
-	iwl_write_prph(priv, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
-	udelay(5);
-
-	/* Make sure (redundant) we've released our request to stay awake */
-	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-
-	/* Stop the device, and put it in low power state */
-	iwl_apm_stop(priv);
+	iwlagn_stop_device(priv);
 
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 078a23e..1211f45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -120,6 +120,17 @@ int iwl_alloc_isr_ict(struct iwl_priv *priv);
 void iwl_free_isr_ict(struct iwl_priv *priv);
 irqreturn_t iwl_isr_ict(int irq, void *data);
 
+/* call this function to flush any scheduled tasklet */
+static inline void iwl_synchronize_irq(struct iwl_priv *priv)
+{
+	/* wait to make sure we flush pending tasklet*/
+	synchronize_irq(priv->pci_dev->irq);
+	tasklet_kill(&priv->irq_tasklet);
+}
+
+
+void iwlagn_stop_device(struct iwl_priv *priv);
+
 /* tx queue */
 void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
 		     int txq_id, u32 index);
-- 
1.7.0.4

