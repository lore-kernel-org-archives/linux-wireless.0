Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36762 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab0HIRxg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Aug 2010 13:53:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] iwlagn: fix rts cts protection
Date: Mon,  9 Aug 2010 10:57:02 -0700
Message-Id: <1281376622-6835-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1281376622-6835-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1281376622-6835-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently the driver will try to protect all frames,
which leads to a lot of odd things like sending an
RTS with a zeroed RA before multicast frames, which
is clearly bogus.

In order to fix all of this, we need to take a step
back and see what we need to achieve:
 * we need RTS/CTS protection if requested by
   the AP for the BSS, mac80211 tells us this
 * in that case, CTS-to-self should only be
   enabled when mac80211 tells us
 * additionally, as a hardware workaround, on
   some devices we have to protect aggregated
   frames with RTS

To achieve the first two items, set up the RXON
accordingly and set the protection required flag
in the transmit command when mac80211 requests
protection for the frame.

To achieve the last item, set the rate-control
RTS-requested flag for all stations that we have
aggregation sessions with, and set the protection
required flag when sending aggregated frames (on
those devices where this is required).

Since otherwise bugs can occur, do not allow the
user to override the RTS-for-aggregation setting
from sysfs any more.

Finally, also clean up the way all these flags get
set in the driver and move everything into the
device-specific functions.

Cc: stable@kernel.org [2.6.35]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   18 +-----
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   16 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   19 +++++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   20 +------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   85 +++++++--------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   29 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   14 +++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +-
 11 files changed, 87 insertions(+), 133 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 14e3298..3bf5a30 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -265,7 +265,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.shadow_ram_support = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 2d78967..8ccfcd0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -769,22 +769,6 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 		rts_retry_limit = data_retry_limit;
 	tx_cmd->rts_retry_limit = rts_retry_limit;
 
-	if (ieee80211_is_mgmt(fc)) {
-		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
-		case cpu_to_le16(IEEE80211_STYPE_AUTH):
-		case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
-		case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
-		case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
-			if (tx_flags & TX_CMD_FLG_RTS_MSK) {
-				tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-				tx_flags |= TX_CMD_FLG_CTS_MSK;
-			}
-			break;
-		default:
-			break;
-		}
-	}
-
 	tx_cmd->rate = rate;
 	tx_cmd->tx_flags = tx_flags;
 
@@ -2717,7 +2701,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 	.get_hcmd_size = iwl3945_get_hcmd_size,
 	.build_addsta_hcmd = iwl3945_build_addsta_hcmd,
-	.rts_tx_cmd_flag = iwlcore_rts_tx_cmd_flag,
+	.tx_cmd_protection = iwlcore_tx_cmd_protection,
 	.request_scan = iwl3945_request_scan,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 07f3e2b..f0a47f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2223,7 +2223,7 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.build_addsta_hcmd = iwl4965_build_addsta_hcmd,
 	.chain_noise_reset = iwl4965_chain_noise_reset,
 	.gain_computation = iwl4965_gain_computation,
-	.rts_tx_cmd_flag = iwlcore_rts_tx_cmd_flag,
+	.tx_cmd_protection = iwlcore_tx_cmd_protection,
 	.calc_rssi = iwl4965_calc_rssi,
 	.request_scan = iwlagn_request_scan,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ac0054f..efd9e6b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -516,7 +516,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
@@ -547,7 +547,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
@@ -607,7 +607,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
@@ -638,7 +638,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
@@ -669,7 +669,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9e55bac..9e390f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -386,7 +386,7 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
@@ -494,7 +494,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
@@ -568,7 +568,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
@@ -642,7 +642,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
@@ -719,7 +719,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
@@ -826,7 +826,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
@@ -864,7 +864,7 @@ struct iwl_cfg iwl6050g2_bgn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
@@ -938,7 +938,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 4c0ea12..8493976 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -211,10 +211,21 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 	}
 }
 
-static void iwlagn_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
-			__le32 *tx_flags)
+static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
+				     struct ieee80211_tx_info *info,
+				     __le16 fc, __le32 *tx_flags)
 {
-	*tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS ||
+	    info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
+		*tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
+		return;
+	}
+
+	if (priv->cfg->use_rts_for_aggregation &&
+	    info->flags & IEEE80211_TX_CTL_AMPDU) {
+		*tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
+		return;
+	}
 }
 
 /* Calc max signal level (dBm) among 3 possible receivers */
@@ -271,7 +282,7 @@ struct iwl_hcmd_utils_ops iwlagn_hcmd_utils = {
 	.build_addsta_hcmd = iwlagn_build_addsta_hcmd,
 	.gain_computation = iwlagn_gain_computation,
 	.chain_noise_reset = iwlagn_chain_noise_reset,
-	.rts_tx_cmd_flag = iwlagn_rts_tx_cmd_flag,
+	.tx_cmd_protection = iwlagn_tx_cmd_protection,
 	.calc_rssi = iwlagn_calc_rssi,
 	.request_scan = iwlagn_request_scan,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index ecb953f..a502ebf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -379,10 +379,7 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
-	priv->cfg->ops->utils->rts_tx_cmd_flag(info, &tx_flags);
-
-	if ((tx_flags & TX_CMD_FLG_RTS_MSK) || (tx_flags & TX_CMD_FLG_CTS_MSK))
-		tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
+	priv->cfg->ops->utils->tx_cmd_protection(priv, info, fc, &tx_flags);
 
 	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
 	if (ieee80211_is_mgmt(fc)) {
@@ -456,21 +453,6 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
 		rate_flags |= RATE_MCS_CCK_MSK;
 
-	/* Set up RTS and CTS flags for certain packets */
-	switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
-	case cpu_to_le16(IEEE80211_STYPE_AUTH):
-	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
-	case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
-	case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
-		if (tx_cmd->tx_flags & TX_CMD_FLG_RTS_MSK) {
-			tx_cmd->tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-			tx_cmd->tx_flags |= TX_CMD_FLG_CTS_MSK;
-		}
-		break;
-	default:
-		break;
-	}
-
 	/* Set up antennas */
 	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
 					      priv->hw_params.valid_tx_ant);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5947259..aacc89b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -202,13 +202,6 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 
 	priv->start_calib = 0;
 	if (new_assoc) {
-		/*
-		 * allow CTS-to-self if possible for new association.
-		 * this is relevant only for 5000 series and up,
-		 * but will not damage 4965
-		 */
-		priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
-
 		/* Apply the new configuration
 		 * RXON assoc doesn't clear the station table in uCode,
 		 */
@@ -1620,45 +1613,9 @@ static ssize_t store_tx_power(struct device *d,
 
 static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, show_tx_power, store_tx_power);
 
-static ssize_t show_rts_ht_protection(struct device *d,
-			     struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-
-	return sprintf(buf, "%s\n",
-		priv->cfg->use_rts_for_ht ? "RTS/CTS" : "CTS-to-self");
-}
-
-static ssize_t store_rts_ht_protection(struct device *d,
-			      struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	unsigned long val;
-	int ret;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret)
-		IWL_INFO(priv, "Input is not in decimal form.\n");
-	else {
-		if (!iwl_is_associated(priv))
-			priv->cfg->use_rts_for_ht = val ? true : false;
-		else
-			IWL_ERR(priv, "Sta associated with AP - "
-				"Change protection mechanism is not allowed\n");
-		ret = count;
-	}
-	return ret;
-}
-
-static DEVICE_ATTR(rts_ht_protection, S_IWUSR | S_IRUGO,
-			show_rts_ht_protection, store_rts_ht_protection);
-
-
 static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
-	&dev_attr_rts_ht_protection.attr,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	&dev_attr_debug_level.attr,
 #endif
@@ -3507,25 +3464,6 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
-/*
- * switch to RTS/CTS for TX
- */
-static void iwl_enable_rts_cts(struct iwl_priv *priv)
-{
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	priv->staging_rxon.flags &= ~RXON_FLG_SELF_CTS_EN;
-	if (!test_bit(STATUS_SCANNING, &priv->status)) {
-		IWL_DEBUG_INFO(priv, "use RTS/CTS protection\n");
-		iwlcore_commit_rxon(priv);
-	} else {
-		/* scanning, defer the request until scan completed */
-		IWL_DEBUG_INFO(priv, "defer setting RTS/CTS protection\n");
-	}
-}
-
 static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				enum ieee80211_ampdu_mlme_action action,
@@ -3572,14 +3510,33 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 		}
 		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 			ret = 0;
+		if (priv->cfg->use_rts_for_aggregation) {
+			struct iwl_station_priv *sta_priv =
+				(void *) sta->drv_priv;
+			/*
+			 * switch off RTS/CTS if it was previously enabled
+			 */
+
+			sta_priv->lq_sta.lq.general_params.flags &=
+				~LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK;
+			iwl_send_lq_cmd(priv, &sta_priv->lq_sta.lq,
+				CMD_ASYNC, false);
+		}
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		if (priv->cfg->use_rts_for_ht) {
+		if (priv->cfg->use_rts_for_aggregation) {
+			struct iwl_station_priv *sta_priv =
+				(void *) sta->drv_priv;
+
 			/*
 			 * switch to RTS/CTS if it is the prefer protection
 			 * method for HT traffic
 			 */
-			iwl_enable_rts_cts(priv);
+
+			sta_priv->lq_sta.lq.general_params.flags |=
+				LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK;
+			iwl_send_lq_cmd(priv, &sta_priv->lq_sta.lq,
+				CMD_ASYNC, false);
 		}
 		ret = 0;
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9c27bd4..346e0ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -397,21 +397,38 @@ void iwlcore_free_geos(struct iwl_priv *priv)
 EXPORT_SYMBOL(iwlcore_free_geos);
 
 /*
- *  iwlcore_rts_tx_cmd_flag: Set rts/cts. 3945 and 4965 only share this
+ *  iwlcore_tx_cmd_protection: Set rts/cts. 3945 and 4965 only share this
  *  function.
  */
-void iwlcore_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
-				__le32 *tx_flags)
+void iwlcore_tx_cmd_protection(struct iwl_priv *priv,
+			       struct ieee80211_tx_info *info,
+			       __le16 fc, __le32 *tx_flags)
 {
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 		*tx_flags |= TX_CMD_FLG_RTS_MSK;
 		*tx_flags &= ~TX_CMD_FLG_CTS_MSK;
+		*tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
+
+		if (!ieee80211_is_mgmt(fc))
+			return;
+
+		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
+		case cpu_to_le16(IEEE80211_STYPE_AUTH):
+		case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
+		case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
+		case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
+			*tx_flags &= ~TX_CMD_FLG_RTS_MSK;
+			*tx_flags |= TX_CMD_FLG_CTS_MSK;
+			break;
+		}
 	} else if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
 		*tx_flags &= ~TX_CMD_FLG_RTS_MSK;
 		*tx_flags |= TX_CMD_FLG_CTS_MSK;
+		*tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
 	}
 }
-EXPORT_SYMBOL(iwlcore_rts_tx_cmd_flag);
+EXPORT_SYMBOL(iwlcore_tx_cmd_protection);
+
 
 static bool is_single_rx_stream(struct iwl_priv *priv)
 {
@@ -1803,6 +1820,10 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
+		if (bss_conf->use_cts_prot)
+			priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
+		else
+			priv->staging_rxon.flags &= ~RXON_FLG_SELF_CTS_EN;
 	}
 
 	if (changes & BSS_CHANGED_BASIC_RATES) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ffa76e0..1b05f37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -104,8 +104,9 @@ struct iwl_hcmd_utils_ops {
 			u32 min_average_noise,
 			u8 default_chain);
 	void (*chain_noise_reset)(struct iwl_priv *priv);
-	void (*rts_tx_cmd_flag)(struct ieee80211_tx_info *info,
-			__le32 *tx_flags);
+	void (*tx_cmd_protection)(struct iwl_priv *priv,
+				  struct ieee80211_tx_info *info,
+				  __le16 fc, __le32 *tx_flags);
 	int  (*calc_rssi)(struct iwl_priv *priv,
 			  struct iwl_rx_phy_res *rx_resp);
 	void (*request_scan)(struct iwl_priv *priv, struct ieee80211_vif *vif);
@@ -258,7 +259,7 @@ struct iwl_mod_params {
  * @led_compensation: compensate on the led on/off time per HW according
  *	to the deviation to achieve the desired led frequency.
  *	The detail algorithm is described in iwl-led.c
- * @use_rts_for_ht: use rts/cts protection for HT traffic
+ * @use_rts_for_aggregation: use rts/cts protection for HT traffic
  * @chain_noise_num_beacons: number of beacons used to compute chain noise
  * @adv_thermal_throttle: support advance thermal throttle
  * @support_ct_kill_exit: support ct kill exit condition
@@ -332,7 +333,7 @@ struct iwl_cfg {
 	const bool ht_greenfield_support;
 	u16 led_compensation;
 	const bool broken_powersave;
-	bool use_rts_for_ht;
+	bool use_rts_for_aggregation;
 	int chain_noise_num_beacons;
 	const bool supports_idle;
 	bool adv_thermal_throttle;
@@ -406,8 +407,9 @@ void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif);
 void iwl_mac_reset_tsf(struct ieee80211_hw *hw);
 int iwl_alloc_txq_mem(struct iwl_priv *priv);
 void iwl_free_txq_mem(struct iwl_priv *priv);
-void iwlcore_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
-				__le32 *tx_flags);
+void iwlcore_tx_cmd_protection(struct iwl_priv *priv,
+			       struct ieee80211_tx_info *info,
+			       __le16 fc, __le32 *tx_flags);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_free_traffic_mem(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4fcd561..fc692ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -435,10 +435,7 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
-	priv->cfg->ops->utils->rts_tx_cmd_flag(info, &tx_flags);
-
-	if ((tx_flags & TX_CMD_FLG_RTS_MSK) || (tx_flags & TX_CMD_FLG_CTS_MSK))
-		tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
+	priv->cfg->ops->utils->tx_cmd_protection(priv, info, fc, &tx_flags);
 
 	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
 	if (ieee80211_is_mgmt(fc)) {
-- 
1.7.0.4

