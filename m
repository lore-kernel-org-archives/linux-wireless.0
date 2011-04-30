Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62414 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686Ab1D3Qkr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/14] iwlagn: make rxon_assoc static function
Date: Sat, 30 Apr 2011 09:17:30 -0700
Message-Id: <1304180260-13875-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184055_300757_5C02F6F1)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move rxon_assoc to static function from ops

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   50 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   50 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 -
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 ---
 4 files changed, 49 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 861cc93..49dd03f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -37,54 +37,6 @@
 #include "iwl-io.h"
 #include "iwl-agn.h"
 
-int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
-			   struct iwl_rxon_context *ctx)
-{
-	int ret = 0;
-	struct iwl5000_rxon_assoc_cmd rxon_assoc;
-	const struct iwl_rxon_cmd *rxon1 = &ctx->staging;
-	const struct iwl_rxon_cmd *rxon2 = &ctx->active;
-
-	if ((rxon1->flags == rxon2->flags) &&
-	    (rxon1->filter_flags == rxon2->filter_flags) &&
-	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
-	    (rxon1->ofdm_ht_single_stream_basic_rates ==
-	     rxon2->ofdm_ht_single_stream_basic_rates) &&
-	    (rxon1->ofdm_ht_dual_stream_basic_rates ==
-	     rxon2->ofdm_ht_dual_stream_basic_rates) &&
-	    (rxon1->ofdm_ht_triple_stream_basic_rates ==
-	     rxon2->ofdm_ht_triple_stream_basic_rates) &&
-	    (rxon1->acquisition_data == rxon2->acquisition_data) &&
-	    (rxon1->rx_chain == rxon2->rx_chain) &&
-	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
-		IWL_DEBUG_INFO(priv, "Using current RXON_ASSOC.  Not resending.\n");
-		return 0;
-	}
-
-	rxon_assoc.flags = ctx->staging.flags;
-	rxon_assoc.filter_flags = ctx->staging.filter_flags;
-	rxon_assoc.ofdm_basic_rates = ctx->staging.ofdm_basic_rates;
-	rxon_assoc.cck_basic_rates = ctx->staging.cck_basic_rates;
-	rxon_assoc.reserved1 = 0;
-	rxon_assoc.reserved2 = 0;
-	rxon_assoc.reserved3 = 0;
-	rxon_assoc.ofdm_ht_single_stream_basic_rates =
-	    ctx->staging.ofdm_ht_single_stream_basic_rates;
-	rxon_assoc.ofdm_ht_dual_stream_basic_rates =
-	    ctx->staging.ofdm_ht_dual_stream_basic_rates;
-	rxon_assoc.rx_chain_select_flags = ctx->staging.rx_chain;
-	rxon_assoc.ofdm_ht_triple_stream_basic_rates =
-		 ctx->staging.ofdm_ht_triple_stream_basic_rates;
-	rxon_assoc.acquisition_data = ctx->staging.acquisition_data;
-
-	ret = iwl_send_cmd_pdu_async(priv, ctx->rxon_assoc_cmd,
-				     sizeof(rxon_assoc), &rxon_assoc, NULL);
-	if (ret)
-		return ret;
-
-	return ret;
-}
-
 int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 {
 	struct iwl_tx_ant_config_cmd tx_ant_cmd = {
@@ -364,7 +316,6 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 }
 
 struct iwl_hcmd_ops iwlagn_hcmd = {
-	.rxon_assoc = iwlagn_send_rxon_assoc,
 	.commit_rxon = iwlagn_commit_rxon,
 	.set_rxon_chain = iwlagn_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
@@ -373,7 +324,6 @@ struct iwl_hcmd_ops iwlagn_hcmd = {
 };
 
 struct iwl_hcmd_ops iwlagn_bt_hcmd = {
-	.rxon_assoc = iwlagn_send_rxon_assoc,
 	.commit_rxon = iwlagn_commit_rxon,
 	.set_rxon_chain = iwlagn_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 202ef64..aba5bc9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -121,6 +121,54 @@ static int iwlagn_update_beacon(struct iwl_priv *priv,
 	return iwlagn_send_beacon_cmd(priv);
 }
 
+static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
+			   struct iwl_rxon_context *ctx)
+{
+	int ret = 0;
+	struct iwl5000_rxon_assoc_cmd rxon_assoc;
+	const struct iwl_rxon_cmd *rxon1 = &ctx->staging;
+	const struct iwl_rxon_cmd *rxon2 = &ctx->active;
+
+	if ((rxon1->flags == rxon2->flags) &&
+	    (rxon1->filter_flags == rxon2->filter_flags) &&
+	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
+	    (rxon1->ofdm_ht_single_stream_basic_rates ==
+	     rxon2->ofdm_ht_single_stream_basic_rates) &&
+	    (rxon1->ofdm_ht_dual_stream_basic_rates ==
+	     rxon2->ofdm_ht_dual_stream_basic_rates) &&
+	    (rxon1->ofdm_ht_triple_stream_basic_rates ==
+	     rxon2->ofdm_ht_triple_stream_basic_rates) &&
+	    (rxon1->acquisition_data == rxon2->acquisition_data) &&
+	    (rxon1->rx_chain == rxon2->rx_chain) &&
+	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
+		IWL_DEBUG_INFO(priv, "Using current RXON_ASSOC.  Not resending.\n");
+		return 0;
+	}
+
+	rxon_assoc.flags = ctx->staging.flags;
+	rxon_assoc.filter_flags = ctx->staging.filter_flags;
+	rxon_assoc.ofdm_basic_rates = ctx->staging.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = ctx->staging.cck_basic_rates;
+	rxon_assoc.reserved1 = 0;
+	rxon_assoc.reserved2 = 0;
+	rxon_assoc.reserved3 = 0;
+	rxon_assoc.ofdm_ht_single_stream_basic_rates =
+	    ctx->staging.ofdm_ht_single_stream_basic_rates;
+	rxon_assoc.ofdm_ht_dual_stream_basic_rates =
+	    ctx->staging.ofdm_ht_dual_stream_basic_rates;
+	rxon_assoc.rx_chain_select_flags = ctx->staging.rx_chain;
+	rxon_assoc.ofdm_ht_triple_stream_basic_rates =
+		 ctx->staging.ofdm_ht_triple_stream_basic_rates;
+	rxon_assoc.acquisition_data = ctx->staging.acquisition_data;
+
+	ret = iwl_send_cmd_pdu_async(priv, ctx->rxon_assoc_cmd,
+				     sizeof(rxon_assoc), &rxon_assoc, NULL);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
 /**
  * iwlagn_commit_rxon - commit staging_rxon to hardware
  *
@@ -200,7 +248,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * and other flags for the current radio configuration.
 	 */
 	if (!iwl_full_rxon_required(priv, ctx)) {
-		ret = iwl_send_rxon_assoc(priv, ctx);
+		ret = iwlagn_send_rxon_assoc(priv, ctx);
 		if (ret) {
 			IWL_ERR(priv, "Error setting RXON_ASSOC (%d)\n", ret);
 			return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index c475ac4..7d8e16e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -256,8 +256,6 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 			       struct ieee80211_vif *vif, bool add);
 
 /* hcmd */
-int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
-			   struct iwl_rxon_context *ctx);
 int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant);
 int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6226e3d..4cdb85d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -90,7 +90,6 @@ struct iwl_cmd;
 #define IWL_CMD(x) case x: return #x
 
 struct iwl_hcmd_ops {
-	int (*rxon_assoc)(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 	int (*commit_rxon)(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 	void (*set_rxon_chain)(struct iwl_priv *priv,
 			       struct iwl_rxon_context *ctx);
@@ -645,11 +644,6 @@ void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 
 int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
-static inline int iwl_send_rxon_assoc(struct iwl_priv *priv,
-				      struct iwl_rxon_context *ctx)
-{
-	return priv->cfg->ops->hcmd->rxon_assoc(priv, ctx);
-}
 static inline int iwlcore_commit_rxon(struct iwl_priv *priv,
 				      struct iwl_rxon_context *ctx)
 {
-- 
1.7.0.4

