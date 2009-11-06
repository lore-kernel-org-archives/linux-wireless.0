Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760134AbZKFWxF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:05 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 20/20] iwlwifi: MAC_ACCESS_REQ cleanup
Date: Fri,  6 Nov 2009 14:53:03 -0800
Message-Id: <1257547983-12590-21-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Add txq_id info to "Tx queue requesting wakeup" debug message

Add "Rx queue requesting wakeup" debug message

Move clear of CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ to be after nearby
iwl_write_prph(), since iwl_write_prph() sets it and clears it.  Almost
removed it entirely, but just making sure in case someone removes the
iwl_write_prph()!  Also remove unneeded priv->lock usage; this is now
handled by priv->reg_lock within iwl_clear_bit().

Join a couple of lines that had unneeded line returns.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   12 +++++-------
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    2 ++
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    3 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 ++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4ba4282..29f7510 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1935,19 +1935,17 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	/* device going down, Stop using ICT table */
 	iwl_disable_ict(priv);
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_clear_bit(priv, CSR_GP_CNTRL,
-			 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl_txq_ctx_stop(priv);
 	iwl_rxq_stop(priv);
 
-	iwl_write_prph(priv, APMG_CLK_DIS_REG,
-				APMG_CLK_VAL_DMA_CLK_RQT);
-
+	/* Power-down device's busmaster DMA clocks */
+	iwl_write_prph(priv, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 	udelay(5);
 
+	/* Make sure (redundant) we've released our request to stay awake */
+	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+
 	/* Stop the device, and put it in low power state */
 	priv->cfg->ops->lib->apm_ops.stop(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index d2dc7cc..61b3b0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -140,6 +140,8 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
+			IWL_DEBUG_INFO(priv, "Rx queue requesting wakeup, GP1 = 0x%x\n",
+				      reg);
 			iwl_set_bit(priv, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			goto exit_unlock;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index d2b606e..6199bf6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -97,7 +97,8 @@ int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			IWL_DEBUG_INFO(priv, "Requesting wakeup, GP1 = 0x%x\n", reg);
+			IWL_DEBUG_INFO(priv, "Tx queue %d requesting wakeup, GP1 = 0x%x\n",
+				      txq_id, reg);
 			iwl_set_bit(priv, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6285e51..5d26330 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2601,9 +2601,8 @@ static void __iwl3945_down(struct iwl_priv *priv)
 	iwl3945_hw_txq_ctx_stop(priv);
 	iwl3945_hw_rxq_stop(priv);
 
-	iwl_write_prph(priv, APMG_CLK_DIS_REG,
-				APMG_CLK_VAL_DMA_CLK_RQT);
-
+	/* Power-down device's busmaster DMA clocks */
+	iwl_write_prph(priv, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 	udelay(5);
 
 	/* Stop the device, and put it in low power state */
-- 
1.5.6.3

