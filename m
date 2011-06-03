Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:23158 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab1FCPWw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 11:22:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/5] iwlagn: call commit_rxon function directly
Date: Fri,  3 Jun 2011 07:54:16 -0700
Message-Id: <1307112856-20231-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110603_172259_581101_BBB580EB)
In-Reply-To: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to go though multiple levels of indirect call to send RXON command.
Call it directly

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    7 +------
 4 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 938230d..87fd05a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -310,7 +310,6 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 }
 
 struct iwl_hcmd_ops iwlagn_hcmd = {
-	.commit_rxon = iwlagn_commit_rxon,
 	.set_rxon_chain = iwlagn_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
 	.send_bt_config = iwl_send_bt_config,
@@ -318,7 +317,6 @@ struct iwl_hcmd_ops iwlagn_hcmd = {
 };
 
 struct iwl_hcmd_ops iwlagn_bt_hcmd = {
-	.commit_rxon = iwlagn_commit_rxon,
 	.set_rxon_chain = iwlagn_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
 	.send_bt_config = iwlagn_send_advance_bt_config,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6ad3376..96c7288 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -97,7 +97,7 @@ void iwl_update_chain_flags(struct iwl_priv *priv)
 		for_each_context(priv, ctx) {
 			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 			if (ctx->active.rx_chain != ctx->staging.rx_chain)
-				iwlcore_commit_rxon(priv, ctx);
+				iwlagn_commit_rxon(priv, ctx);
 		}
 	}
 }
@@ -274,7 +274,7 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 	for_each_context(priv, ctx) {
 		if (priv->cfg->ops->hcmd->set_rxon_chain)
 			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
-		iwlcore_commit_rxon(priv, ctx);
+		iwlagn_commit_rxon(priv, ctx);
 	}
 
 	priv->cfg->ops->hcmd->send_bt_config(priv);
@@ -2056,7 +2056,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	set_bit(STATUS_READY, &priv->status);
 
 	/* Configure the adapter for unassociated operation */
-	ret = iwlcore_commit_rxon(priv, ctx);
+	ret = iwlagn_commit_rxon(priv, ctx);
 	if (ret)
 		return ret;
 
@@ -3101,7 +3101,7 @@ static void iwlagn_disable_roc(struct iwl_priv *priv)
 
 	priv->_agn.hw_roc_channel = NULL;
 
-	iwlcore_commit_rxon(priv, ctx);
+	iwlagn_commit_rxon(priv, ctx);
 
 	ctx->is_active = false;
 }
@@ -3144,7 +3144,7 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 	priv->_agn.hw_roc_channel = channel;
 	priv->_agn.hw_roc_chantype = channel_type;
 	priv->_agn.hw_roc_duration = DIV_ROUND_UP(duration * 1000, 1024);
-	iwlcore_commit_rxon(priv, &priv->contexts[IWL_RXON_CTX_PAN]);
+	iwlagn_commit_rxon(priv, &priv->contexts[IWL_RXON_CTX_PAN]);
 	queue_delayed_work(priv->workqueue, &priv->_agn.hw_roc_work,
 			   msecs_to_jiffies(duration + 20));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 52e9413..de18916 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1279,7 +1279,7 @@ static int iwl_set_mode(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 
-	return iwlcore_commit_rxon(priv, ctx);
+	return iwlagn_commit_rxon(priv, ctx);
 }
 
 static int iwl_setup_interface(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4ca0336..b38477c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -90,7 +90,6 @@ struct iwl_cmd;
 #define IWL_CMD(x) case x: return #x
 
 struct iwl_hcmd_ops {
-	int (*commit_rxon)(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 	void (*set_rxon_chain)(struct iwl_priv *priv,
 			       struct iwl_rxon_context *ctx);
 	int (*set_tx_ant)(struct iwl_priv *priv, u8 valid_tx_ant);
@@ -611,11 +610,7 @@ void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 
 int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
-static inline int iwlcore_commit_rxon(struct iwl_priv *priv,
-				      struct iwl_rxon_context *ctx)
-{
-	return priv->cfg->ops->hcmd->commit_rxon(priv, ctx);
-}
+
 static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 			struct iwl_priv *priv, enum ieee80211_band band)
 {
-- 
1.7.0.4

