Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab1GHQUm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/21] iwlagn: remove iwlagn_hcmd_utils structure and call directly
Date: Fri,  8 Jul 2011 08:46:29 -0700
Message-Id: <1310139989-27661-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182048_663543_B637BE5D)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Not needed since the driver split.  Move single use routines to
calling location and keep static where possible.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    4 -
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    2 -
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    4 -
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h |    7 --
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |  104 +-------------------------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |   35 +++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   12 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-core.h      |   17 ----
 drivers/net/wireless/iwlwifi/iwl-rx.c        |   43 ++++++++++-
 drivers/net/wireless/iwlwifi/iwl-scan.c      |    5 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c       |   13 +++-
 14 files changed, 109 insertions(+), 151 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 7795855..2f56b34 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -188,7 +188,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 
 static const struct iwl_ops iwl1000_ops = {
 	.lib = &iwl1000_lib,
-	.utils = &iwlagn_hcmd_utils,
 };
 
 static struct iwl_base_params iwl1000_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 21b68b2..32ac865 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -210,22 +210,18 @@ static struct iwl_lib_ops iwl2030_lib = {
 
 static const struct iwl_ops iwl2000_ops = {
 	.lib = &iwl2000_lib,
-	.utils = &iwlagn_hcmd_utils,
 };
 
 static const struct iwl_ops iwl2030_ops = {
 	.lib = &iwl2030_lib,
-	.utils = &iwlagn_hcmd_utils,
 };
 
 static const struct iwl_ops iwl105_ops = {
 	.lib = &iwl2000_lib,
-	.utils = &iwlagn_hcmd_utils,
 };
 
 static const struct iwl_ops iwl135_ops = {
 	.lib = &iwl2030_lib,
-	.utils = &iwlagn_hcmd_utils,
 };
 
 static struct iwl_base_params iwl2000_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 30c2df6..5564893 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -362,12 +362,10 @@ static struct iwl_lib_ops iwl5150_lib = {
 
 static const struct iwl_ops iwl5000_ops = {
 	.lib = &iwl5000_lib,
-	.utils = &iwlagn_hcmd_utils,
 };
 
 static const struct iwl_ops iwl5150_ops = {
 	.lib = &iwl5150_lib,
-	.utils = &iwlagn_hcmd_utils,
 };
 
 static struct iwl_base_params iwl5000_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 57f3169..80f1ef6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -313,24 +313,20 @@ static struct iwl_nic_ops iwl6150_nic_ops = {
 
 static const struct iwl_ops iwl6000_ops = {
 	.lib = &iwl6000_lib,
-	.utils = &iwlagn_hcmd_utils,
 };
 
 static const struct iwl_ops iwl6050_ops = {
 	.lib = &iwl6000_lib,
-	.utils = &iwlagn_hcmd_utils,
 	.nic = &iwl6050_nic_ops,
 };
 
 static const struct iwl_ops iwl6150_ops = {
 	.lib = &iwl6000_lib,
-	.utils = &iwlagn_hcmd_utils,
 	.nic = &iwl6150_nic_ops,
 };
 
 static const struct iwl_ops iwl6030_ops = {
 	.lib = &iwl6030_lib,
-	.utils = &iwlagn_hcmd_utils,
 };
 
 static struct iwl_base_params iwl6000_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 710ada9..02c7c65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -67,6 +67,7 @@
 #include "iwl-core.h"
 #include "iwl-agn-calib.h"
 #include "iwl-trans.h"
+#include "iwl-agn.h"
 
 /*****************************************************************************
  * INIT calibrations framework
@@ -993,8 +994,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	IWL_DEBUG_CALIB(priv, "min_average_noise = %d, antenna %d\n",
 			min_average_noise, min_average_noise_antenna_i);
 
-	if (priv->cfg->ops->utils->gain_computation)
-		priv->cfg->ops->utils->gain_computation(priv, average_noise,
+	iwlagn_gain_computation(priv, average_noise,
 				min_average_noise_antenna_i, min_average_noise,
 				find_first_chain(priv->cfg->valid_rx_ant));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
index 4ef4dd9..a869fc9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
@@ -71,13 +71,6 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv);
 
 void iwl_init_sensitivity(struct iwl_priv *priv);
 void iwl_reset_run_time_calib(struct iwl_priv *priv);
-static inline void iwl_chain_noise_reset(struct iwl_priv *priv)
-{
-
-	if (!priv->disable_chain_noise_cal &&
-	    priv->cfg->ops->utils->chain_noise_reset)
-		priv->cfg->ops->utils->chain_noise_reset(priv);
-}
 
 int iwl_send_calib_results(struct iwl_priv *priv);
 int iwl_calib_set(struct iwl_calib_result *res, const u8 *buf, int len);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 4d7674c..f0f5f5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -57,17 +57,7 @@ int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 	}
 }
 
-static u16 iwlagn_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
-{
-	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
-	struct iwl_addsta_cmd *addsta = (struct iwl_addsta_cmd *)data;
-	memcpy(addsta, cmd, size);
-	/* resrved in 5000 */
-	addsta->rate_n_flags = cpu_to_le16(0);
-	return size;
-}
-
-static void iwlagn_gain_computation(struct iwl_priv *priv,
+void iwlagn_gain_computation(struct iwl_priv *priv,
 		u32 average_noise[NUM_RX_CHAINS],
 		u16 min_average_noise_antenna_i,
 		u32 min_average_noise,
@@ -126,89 +116,6 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 	}
 }
 
-static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
-{
-	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
-	int ret;
-
-	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&
-	    iwl_is_any_associated(priv)) {
-		struct iwl_calib_chain_noise_reset_cmd cmd;
-
-		/* clear data for chain noise calibration algorithm */
-		data->chain_noise_a = 0;
-		data->chain_noise_b = 0;
-		data->chain_noise_c = 0;
-		data->chain_signal_a = 0;
-		data->chain_signal_b = 0;
-		data->chain_signal_c = 0;
-		data->beacon_count = 0;
-
-		memset(&cmd, 0, sizeof(cmd));
-		iwl_set_calib_hdr(&cmd.hdr,
-			priv->_agn.phy_calib_chain_noise_reset_cmd);
-		ret = trans_send_cmd_pdu(priv,
-					REPLY_PHY_CALIBRATION_CMD,
-					CMD_SYNC, sizeof(cmd), &cmd);
-		if (ret)
-			IWL_ERR(priv,
-				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
-		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
-		IWL_DEBUG_CALIB(priv, "Run chain_noise_calibrate\n");
-	}
-}
-
-static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
-				     struct ieee80211_tx_info *info,
-				     __le16 fc, __le32 *tx_flags)
-{
-	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS ||
-	    info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT ||
-	    info->flags & IEEE80211_TX_CTL_AMPDU)
-		*tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
-}
-
-/* Calc max signal level (dBm) among 3 possible receivers */
-static int iwlagn_calc_rssi(struct iwl_priv *priv,
-			     struct iwl_rx_phy_res *rx_resp)
-{
-	/* data from PHY/DSP regarding signal strength, etc.,
-	 *   contents are always there, not configurable by host
-	 */
-	struct iwlagn_non_cfg_phy *ncphy =
-		(struct iwlagn_non_cfg_phy *)rx_resp->non_cfg_phy_buf;
-	u32 val, rssi_a, rssi_b, rssi_c, max_rssi;
-	u8 agc;
-
-	val  = le32_to_cpu(ncphy->non_cfg_phy[IWLAGN_RX_RES_AGC_IDX]);
-	agc = (val & IWLAGN_OFDM_AGC_MSK) >> IWLAGN_OFDM_AGC_BIT_POS;
-
-	/* Find max rssi among 3 possible receivers.
-	 * These values are measured by the digital signal processor (DSP).
-	 * They should stay fairly constant even as the signal strength varies,
-	 *   if the radio's automatic gain control (AGC) is working right.
-	 * AGC value (see below) will provide the "interesting" info.
-	 */
-	val = le32_to_cpu(ncphy->non_cfg_phy[IWLAGN_RX_RES_RSSI_AB_IDX]);
-	rssi_a = (val & IWLAGN_OFDM_RSSI_INBAND_A_BITMSK) >>
-		IWLAGN_OFDM_RSSI_A_BIT_POS;
-	rssi_b = (val & IWLAGN_OFDM_RSSI_INBAND_B_BITMSK) >>
-		IWLAGN_OFDM_RSSI_B_BIT_POS;
-	val = le32_to_cpu(ncphy->non_cfg_phy[IWLAGN_RX_RES_RSSI_C_IDX]);
-	rssi_c = (val & IWLAGN_OFDM_RSSI_INBAND_C_BITMSK) >>
-		IWLAGN_OFDM_RSSI_C_BIT_POS;
-
-	max_rssi = max_t(u32, rssi_a, rssi_b);
-	max_rssi = max_t(u32, max_rssi, rssi_c);
-
-	IWL_DEBUG_STATS(priv, "Rssi In A %d B %d C %d Max %d AGC dB %d\n",
-		rssi_a, rssi_b, rssi_c, max_rssi, agc);
-
-	/* dBm = max_rssi dB - agc dB - constant.
-	 * Higher AGC (higher radio gain) means lower signal. */
-	return max_rssi - agc - IWLAGN_RSSI_OFFSET;
-}
-
 int iwlagn_set_pan_params(struct iwl_priv *priv)
 {
 	struct iwl_wipan_params_cmd cmd;
@@ -301,12 +208,3 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 
 	return ret;
 }
-
-struct iwl_hcmd_utils_ops iwlagn_hcmd_utils = {
-	.build_addsta_hcmd = iwlagn_build_addsta_hcmd,
-	.gain_computation = iwlagn_gain_computation,
-	.chain_noise_reset = iwlagn_chain_noise_reset,
-	.tx_cmd_protection = iwlagn_tx_cmd_protection,
-	.calc_rssi = iwlagn_calc_rssi,
-	.request_scan = iwlagn_request_scan,
-};
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index fca376e..dc64f25 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -674,6 +674,38 @@ static void iwlagn_check_needed_chains(struct iwl_priv *priv,
 	ht_conf->single_chain_sufficient = !need_multiple;
 }
 
+static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
+{
+	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
+	int ret;
+
+	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&
+	    iwl_is_any_associated(priv)) {
+		struct iwl_calib_chain_noise_reset_cmd cmd;
+
+		/* clear data for chain noise calibration algorithm */
+		data->chain_noise_a = 0;
+		data->chain_noise_b = 0;
+		data->chain_noise_c = 0;
+		data->chain_signal_a = 0;
+		data->chain_signal_b = 0;
+		data->chain_signal_c = 0;
+		data->beacon_count = 0;
+
+		memset(&cmd, 0, sizeof(cmd));
+		iwl_set_calib_hdr(&cmd.hdr,
+			priv->_agn.phy_calib_chain_noise_reset_cmd);
+		ret = trans_send_cmd_pdu(priv,
+					REPLY_PHY_CALIBRATION_CMD,
+					CMD_SYNC, sizeof(cmd), &cmd);
+		if (ret)
+			IWL_ERR(priv,
+				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
+		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
+		IWL_DEBUG_CALIB(priv, "Run chain_noise_calibrate\n");
+	}
+}
+
 void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_bss_conf *bss_conf,
@@ -782,7 +814,8 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			iwl_power_update_mode(priv, false);
 
 		/* Enable RX differential gain and sensitivity calibrations */
-		iwl_chain_noise_reset(priv);
+		if (!priv->disable_chain_noise_cal)
+			iwlagn_chain_noise_reset(priv);
 		priv->start_calib = 1;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 0394d11..38a1136 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -339,6 +339,16 @@ void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask)
 	iwl_write_prph(priv, IWLAGN_SCD_TXFACT, mask);
 }
 
+static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
+				     struct ieee80211_tx_info *info,
+				     __le16 fc, __le32 *tx_flags)
+{
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS ||
+	    info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT ||
+	    info->flags & IEEE80211_TX_CTL_AMPDU)
+		*tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
+}
+
 /*
  * handle build REPLY_TX command notification.
  */
@@ -388,7 +398,7 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
-	priv->cfg->ops->utils->tx_cmd_protection(priv, info, fc, &tx_flags);
+	iwlagn_tx_cmd_protection(priv, info, fc, &tx_flags);
 
 	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
 	if (ieee80211_is_mgmt(fc)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 81a009b..5f58b44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -109,9 +109,6 @@ extern struct iwl_cfg iwl135_bg_cfg;
 extern struct iwl_cfg iwl135_bgn_cfg;
 
 extern struct iwl_mod_params iwlagn_mod_params;
-extern struct iwl_hcmd_ops iwlagn_hcmd;
-extern struct iwl_hcmd_ops iwlagn_bt_hcmd;
-extern struct iwl_hcmd_utils_ops iwlagn_hcmd_utils;
 
 extern struct ieee80211_ops iwlagn_hw_ops;
 
@@ -253,6 +250,12 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant);
 int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
 int iwlagn_set_pan_params(struct iwl_priv *priv);
+void iwlagn_gain_computation(struct iwl_priv *priv,
+                u32 average_noise[NUM_RX_CHAINS],
+                u16 min_average_noise_antenna_i,
+                u32 min_average_noise,
+                u8 default_chain);
+
 
 /* bt coex */
 void iwlagn_send_advance_bt_config(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2e3ea55..692c30c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -80,22 +80,6 @@ struct iwl_cmd;
 
 #define IWL_CMD(x) case x: return #x
 
-struct iwl_hcmd_utils_ops {
-	u16 (*build_addsta_hcmd)(const struct iwl_addsta_cmd *cmd, u8 *data);
-	void (*gain_computation)(struct iwl_priv *priv,
-			u32 *average_noise,
-			u16 min_average_noise_antennat_i,
-			u32 min_average_noise,
-			u8 default_chain);
-	void (*chain_noise_reset)(struct iwl_priv *priv);
-	void (*tx_cmd_protection)(struct iwl_priv *priv,
-				  struct ieee80211_tx_info *info,
-				  __le16 fc, __le32 *tx_flags);
-	int  (*calc_rssi)(struct iwl_priv *priv,
-			  struct iwl_rx_phy_res *rx_resp);
-	int (*request_scan)(struct iwl_priv *priv, struct ieee80211_vif *vif);
-};
-
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
@@ -126,7 +110,6 @@ struct iwl_nic_ops {
 
 struct iwl_ops {
 	const struct iwl_lib_ops *lib;
-	const struct iwl_hcmd_utils_ops *utils;
 	const struct iwl_nic_ops *nic;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 1690b49..f3f3efe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -902,6 +902,47 @@ static u32 iwl_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
 	return decrypt_out;
 }
 
+/* Calc max signal level (dBm) among 3 possible receivers */
+static int iwlagn_calc_rssi(struct iwl_priv *priv,
+			     struct iwl_rx_phy_res *rx_resp)
+{
+	/* data from PHY/DSP regarding signal strength, etc.,
+	 *   contents are always there, not configurable by host
+	 */
+	struct iwlagn_non_cfg_phy *ncphy =
+		(struct iwlagn_non_cfg_phy *)rx_resp->non_cfg_phy_buf;
+	u32 val, rssi_a, rssi_b, rssi_c, max_rssi;
+	u8 agc;
+
+	val  = le32_to_cpu(ncphy->non_cfg_phy[IWLAGN_RX_RES_AGC_IDX]);
+	agc = (val & IWLAGN_OFDM_AGC_MSK) >> IWLAGN_OFDM_AGC_BIT_POS;
+
+	/* Find max rssi among 3 possible receivers.
+	 * These values are measured by the digital signal processor (DSP).
+	 * They should stay fairly constant even as the signal strength varies,
+	 *   if the radio's automatic gain control (AGC) is working right.
+	 * AGC value (see below) will provide the "interesting" info.
+	 */
+	val = le32_to_cpu(ncphy->non_cfg_phy[IWLAGN_RX_RES_RSSI_AB_IDX]);
+	rssi_a = (val & IWLAGN_OFDM_RSSI_INBAND_A_BITMSK) >>
+		IWLAGN_OFDM_RSSI_A_BIT_POS;
+	rssi_b = (val & IWLAGN_OFDM_RSSI_INBAND_B_BITMSK) >>
+		IWLAGN_OFDM_RSSI_B_BIT_POS;
+	val = le32_to_cpu(ncphy->non_cfg_phy[IWLAGN_RX_RES_RSSI_C_IDX]);
+	rssi_c = (val & IWLAGN_OFDM_RSSI_INBAND_C_BITMSK) >>
+		IWLAGN_OFDM_RSSI_C_BIT_POS;
+
+	max_rssi = max_t(u32, rssi_a, rssi_b);
+	max_rssi = max_t(u32, max_rssi, rssi_c);
+
+	IWL_DEBUG_STATS(priv, "Rssi In A %d B %d C %d Max %d AGC dB %d\n",
+		rssi_a, rssi_b, rssi_c, max_rssi, agc);
+
+	/* dBm = max_rssi dB - agc dB - constant.
+	 * Higher AGC (higher radio gain) means lower signal. */
+	return max_rssi - agc - IWLAGN_RSSI_OFFSET;
+}
+
 /* Called for REPLY_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
 static void iwl_rx_reply_rx(struct iwl_priv *priv,
@@ -983,7 +1024,7 @@ static void iwl_rx_reply_rx(struct iwl_priv *priv,
 	priv->ucode_beacon_time = le32_to_cpu(phy_res->beacon_time_stamp);
 
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
-	rx_status.signal = priv->cfg->ops->utils->calc_rssi(priv, phy_res);
+	rx_status.signal = iwlagn_calc_rssi(priv, phy_res);
 
 	iwl_dbg_log_rx_data_frame(priv, len, header);
 	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, TSF %llu\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 077d023..f6ebe29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -350,9 +350,6 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 
 	lockdep_assert_held(&priv->mutex);
 
-	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
-		return -EOPNOTSUPP;
-
 	cancel_delayed_work(&priv->scan_check);
 
 	if (!iwl_is_ready_rf(priv)) {
@@ -381,7 +378,7 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 	priv->scan_start = jiffies;
 	priv->scan_band = band;
 
-	ret = priv->cfg->ops->utils->request_scan(priv, vif);
+	ret = iwlagn_request_scan(priv, vif);
 	if (ret) {
 		clear_bit(STATUS_SCANNING, &priv->status);
 		priv->scan_type = IWL_SCAN_NORMAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 78cf107..65386e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -36,6 +36,7 @@
 #include "iwl-core.h"
 #include "iwl-sta.h"
 #include "iwl-trans.h"
+#include "iwl-agn.h"
 
 /* priv->sta_lock must be held */
 static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
@@ -133,6 +134,16 @@ static void iwl_add_sta_callback(struct iwl_priv *priv,
 
 }
 
+static u16 iwlagn_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
+{
+	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
+	struct iwl_addsta_cmd *addsta = (struct iwl_addsta_cmd *)data;
+	memcpy(addsta, cmd, size);
+	/* resrved in 5000 */
+	addsta->rate_n_flags = cpu_to_le16(0);
+	return size;
+}
+
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags)
 {
@@ -156,7 +167,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		might_sleep();
 	}
 
-	cmd.len[0] = priv->cfg->ops->utils->build_addsta_hcmd(sta, data);
+	cmd.len[0] = iwlagn_build_addsta_hcmd(sta, data);
 	ret = trans_send_cmd(priv, &cmd);
 
 	if (ret || (flags & CMD_ASYNC))
-- 
1.7.0.4

