Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52708 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbYE2Iha (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:30 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 16/43] iwlwifi: move iwl_rxq_stop into iwl-rx.c
Date: Thu, 29 May 2008 16:35:01 +0800
Message-Id: <1212050128-17132-17-git-send-email-yi.zhu@intel.com> (sfid-20080529_110546_307809_E10CCEA4)
In-Reply-To: <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves iwl_rxq_stop into iwl-rx.c.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   25 -------------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 4 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index fe73191..2f254c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -384,31 +384,6 @@ void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 	control->tx_rate_idx = rate_index;
 }
 
-int iwl4965_hw_rxq_stop(struct iwl_priv *priv)
-{
-	int rc;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
-
-	/* stop Rx DMA */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	rc = iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
-				     (1 << 24), 1000);
-	if (rc < 0)
-		IWL_ERROR("Can't stop Rx DMA.\n");
-
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
-}
-
 /*
  * EEPROM handlers
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 3cefaaf..5291f1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -684,8 +684,8 @@ extern u8 iwl4965_sync_station(struct iwl_priv *priv, int sta_id,
  ****************************************************************************/
 extern void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv);
 extern void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv);
-extern int iwl4965_hw_rxq_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_set_hw_params(struct iwl_priv *priv);
+extern int iwl_rxq_stop(struct iwl_priv *priv);
 extern void iwl_txq_ctx_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index a2eb90d..ed63e5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -420,3 +420,29 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	return 0;
 }
 
+int iwl_rxq_stop(struct iwl_priv *priv)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	ret = iwl_grab_nic_access(priv);
+	if (unlikely(ret)) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return ret;
+	}
+
+	/* stop Rx DMA */
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	ret = iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
+				     (1 << 24), 1000);
+	if (ret < 0)
+		IWL_ERROR("Can't stop Rx DMA.\n");
+
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_rxq_stop);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2652f5f..985876b 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3405,7 +3405,7 @@ static void __iwl4965_down(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl_txq_ctx_stop(priv);
-	iwl4965_hw_rxq_stop(priv);
+	iwl_rxq_stop(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!iwl_grab_nic_access(priv)) {
-- 
1.5.3.6

