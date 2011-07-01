Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14050 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab1GAPxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:04 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/11] iwlagn: remove hcmd ops
Date: Fri,  1 Jul 2011 08:20:04 -0700
Message-Id: <1309533605-25774-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175329_862789_259063BC)
In-Reply-To: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All "agn" devices use the same hcmd functions, no need to call indirectly.
remove hcmd_ops

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c     |    4 ----
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 ----
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   16 +---------------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   11 ++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   19 +++++++------------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   23 ++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    9 ---------
 11 files changed, 23 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index e57fad9..8c5a829 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -197,7 +197,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 
 static const struct iwl_ops iwl1000_ops = {
 	.lib = &iwl1000_lib,
-	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 76a3e42..75d63e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -198,25 +198,21 @@ static struct iwl_lib_ops iwl2000_lib = {
 
 static const struct iwl_ops iwl2000_ops = {
 	.lib = &iwl2000_lib,
-	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 };
 
 static const struct iwl_ops iwl2030_ops = {
 	.lib = &iwl2000_lib,
-	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 };
 
 static const struct iwl_ops iwl105_ops = {
 	.lib = &iwl2000_lib,
-	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 };
 
 static const struct iwl_ops iwl135_ops = {
 	.lib = &iwl2000_lib,
-	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 269dfdb..5ebf5d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -379,13 +379,11 @@ static struct iwl_lib_ops iwl5150_lib = {
 
 static const struct iwl_ops iwl5000_ops = {
 	.lib = &iwl5000_lib,
-	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 };
 
 static const struct iwl_ops iwl5150_ops = {
 	.lib = &iwl5150_lib,
-	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f1c1db7..94ad57c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -328,27 +328,23 @@ static struct iwl_nic_ops iwl6150_nic_ops = {
 
 static const struct iwl_ops iwl6000_ops = {
 	.lib = &iwl6000_lib,
-	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 };
 
 static const struct iwl_ops iwl6050_ops = {
 	.lib = &iwl6000_lib,
-	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.nic = &iwl6050_nic_ops,
 };
 
 static const struct iwl_ops iwl6150_ops = {
 	.lib = &iwl6000_lib,
-	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.nic = &iwl6150_nic_ops,
 };
 
 static const struct iwl_ops iwl6030_ops = {
 	.lib = &iwl6030_lib,
-	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index ba7ed91..ce7d4b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -205,7 +205,7 @@ static int iwlagn_calc_rssi(struct iwl_priv *priv,
 	return max_rssi - agc - IWLAGN_RSSI_OFFSET;
 }
 
-static int iwlagn_set_pan_params(struct iwl_priv *priv)
+int iwlagn_set_pan_params(struct iwl_priv *priv)
 {
 	struct iwl_wipan_params_cmd cmd;
 	struct iwl_rxon_context *ctx_bss, *ctx_pan;
@@ -297,20 +297,6 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 	return ret;
 }
 
-struct iwl_hcmd_ops iwlagn_hcmd = {
-	.set_rxon_chain = iwlagn_set_rxon_chain,
-	.set_tx_ant = iwlagn_send_tx_ant_config,
-	.send_bt_config = iwl_send_bt_config,
-	.set_pan_params = iwlagn_set_pan_params,
-};
-
-struct iwl_hcmd_ops iwlagn_bt_hcmd = {
-	.set_rxon_chain = iwlagn_set_rxon_chain,
-	.set_tx_ant = iwlagn_send_tx_ant_config,
-	.send_bt_config = iwlagn_send_advance_bt_config,
-	.set_pan_params = iwlagn_set_pan_params,
-};
-
 struct iwl_hcmd_utils_ops iwlagn_hcmd_utils = {
 	.build_addsta_hcmd = iwlagn_build_addsta_hcmd,
 	.gain_computation = iwlagn_gain_computation,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index ea83aa5..90d366e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1366,17 +1366,14 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	/* set scan bit here for PAN params */
 	set_bit(STATUS_SCAN_HW, &priv->status);
 
-	if (priv->cfg->ops->hcmd->set_pan_params) {
-		ret = priv->cfg->ops->hcmd->set_pan_params(priv);
-		if (ret)
-			return ret;
-	}
+	ret = iwlagn_set_pan_params(priv);
+	if (ret)
+		return ret;
 
 	ret = iwl_send_cmd_sync(priv, &cmd);
 	if (ret) {
 		clear_bit(STATUS_SCAN_HW, &priv->status);
-		if (priv->cfg->ops->hcmd->set_pan_params)
-			priv->cfg->ops->hcmd->set_pan_params(priv);
+		iwlagn_set_pan_params(priv);
 	}
 
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 8fa43d4..c6bb73a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -436,11 +436,9 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (ret)
 		return ret;
 
-	if (priv->cfg->ops->hcmd->set_pan_params) {
-		ret = priv->cfg->ops->hcmd->set_pan_params(priv);
-		if (ret)
-			return ret;
-	}
+	ret = iwlagn_set_pan_params(priv);
+	if (ret)
+		return ret;
 
 	if (new_assoc)
 		return iwlagn_rxon_connect(priv, ctx);
@@ -483,9 +481,8 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 		 * set up the SM PS mode to OFF if an HT channel is
 		 * configured.
 		 */
-		if (priv->cfg->ops->hcmd->set_rxon_chain)
-			for_each_context(priv, ctx)
-				priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+		for_each_context(priv, ctx)
+			iwlagn_set_rxon_chain(priv, ctx);
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
@@ -741,8 +738,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 		iwl_set_rxon_ht(priv, &priv->current_ht_config);
 	}
 
-	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+	iwlagn_set_rxon_chain(priv, ctx);
 
 	if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
 		ctx->staging.flags |= RXON_FLG_TGG_PROTECT_MSK;
@@ -821,6 +817,5 @@ void iwlagn_post_scan(struct iwl_priv *priv)
 		if (memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
 			iwlagn_commit_rxon(priv, ctx);
 
-	if (priv->cfg->ops->hcmd->set_pan_params)
-		priv->cfg->ops->hcmd->set_pan_params(priv);
+	iwlagn_set_pan_params(priv);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ffb0b19..7e6c463 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -90,12 +90,10 @@ void iwl_update_chain_flags(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx;
 
-	if (priv->cfg->ops->hcmd->set_rxon_chain) {
-		for_each_context(priv, ctx) {
-			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
-			if (ctx->active.rx_chain != ctx->staging.rx_chain)
-				iwlagn_commit_rxon(priv, ctx);
-		}
+	for_each_context(priv, ctx) {
+		iwlagn_set_rxon_chain(priv, ctx);
+		if (ctx->active.rx_chain != ctx->staging.rx_chain)
+			iwlagn_commit_rxon(priv, ctx);
 	}
 }
 
@@ -287,8 +285,7 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 	 * to avoid 3-wire collisions
 	 */
 	for_each_context(priv, ctx) {
-		if (priv->cfg->ops->hcmd->set_rxon_chain)
-			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+		iwlagn_set_rxon_chain(priv, ctx);
 		iwlagn_commit_rxon(priv, ctx);
 	}
 
@@ -2045,8 +2042,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	priv->active_rate = IWL_RATES_MASK;
 
 	/* Configure Tx antenna selection based on H/W config */
-	if (priv->cfg->ops->hcmd->set_tx_ant)
-		priv->cfg->ops->hcmd->set_tx_ant(priv, priv->cfg->valid_tx_ant);
+	iwlagn_send_tx_ant_config(priv, priv->cfg->valid_tx_ant);
 
 	if (iwl_is_associated_ctx(ctx)) {
 		struct iwl_rxon_cmd *active_rxon =
@@ -2060,8 +2056,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 		for_each_context(priv, tmp)
 			iwl_connection_init_rx_config(priv, tmp);
 
-		if (priv->cfg->ops->hcmd->set_rxon_chain)
-			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+		iwlagn_set_rxon_chain(priv, ctx);
 	}
 
 	iwl_reset_run_time_calib(priv);
@@ -3286,9 +3281,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->rx_statistics_jiffies = jiffies;
 
 	/* Choose which receivers/antennas to use */
-	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv,
-					&priv->contexts[IWL_RXON_CTX_BSS]);
+	iwlagn_set_rxon_chain(priv, &priv->contexts[IWL_RXON_CTX_BSS]);
 
 	iwl_init_scan_params(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5d0c911..4351151 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -256,6 +256,7 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 /* hcmd */
 int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant);
 int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
+int iwlagn_set_pan_params(struct iwl_priv *priv);
 
 /* bt coex */
 void iwlagn_send_advance_bt_config(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b63a7d6..f91e306 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -585,8 +585,7 @@ static void _iwl_set_rxon_ht(struct iwl_priv *priv,
 		rxon->flags |= RXON_FLG_CHANNEL_MODE_LEGACY;
 	}
 
-	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+	iwlagn_set_rxon_chain(priv, ctx);
 
 	IWL_DEBUG_ASSOC(priv, "rxon flags 0x%X operation mode :0x%X "
 			"extension channel offset 0x%x\n",
@@ -1216,8 +1215,7 @@ static int iwl_set_mode(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	iwl_connection_init_rx_config(priv, ctx);
 
-	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+	iwlagn_set_rxon_chain(priv, ctx);
 
 	return iwlagn_commit_rxon(priv, ctx);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 91e7279..6c21de9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -80,14 +80,6 @@ struct iwl_cmd;
 
 #define IWL_CMD(x) case x: return #x
 
-struct iwl_hcmd_ops {
-	void (*set_rxon_chain)(struct iwl_priv *priv,
-			       struct iwl_rxon_context *ctx);
-	int (*set_tx_ant)(struct iwl_priv *priv, u8 valid_tx_ant);
-	void (*send_bt_config)(struct iwl_priv *priv);
-	int (*set_pan_params)(struct iwl_priv *priv);
-};
-
 struct iwl_hcmd_utils_ops {
 	u16 (*build_addsta_hcmd)(const struct iwl_addsta_cmd *cmd, u8 *data);
 	void (*gain_computation)(struct iwl_priv *priv,
@@ -146,7 +138,6 @@ struct iwl_nic_ops {
 
 struct iwl_ops {
 	const struct iwl_lib_ops *lib;
-	const struct iwl_hcmd_ops *hcmd;
 	const struct iwl_hcmd_utils_ops *utils;
 	const struct iwl_nic_ops *nic;
 };
-- 
1.7.0.4

