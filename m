Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761988AbZLJWhY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 17:37:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/7] iwlwifi: use new mac80211 SMPS
Date: Thu, 10 Dec 2009 14:37:27 -0800
Message-Id: <1260484647-5114-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
References: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Instead of hard-coding the SM PS mode per hardware,
this makes iwlwifi support the new mac80211 API for
controlling the SM PS mode.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
This depends on the corresponding mac80211 patches:
cfg80211: add SM PS hooks
mac80211: enable spatial multiplexing powersave

 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 --
 drivers/net/wireless/iwlwifi/iwl-6000.c |    3 --
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    5 +++
 drivers/net/wireless/iwlwifi/iwl-core.c |   53 +++++++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 8 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index d461d36..410fe45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -174,7 +174,6 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
-	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 386513b..34778cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2239,7 +2239,6 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.broken_powersave = true,
 	.led_compensation = 61,
 	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
-	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 5a277cd..3236315 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1600,7 +1600,6 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 struct iwl_cfg iwl5100_bgn_cfg = {
@@ -1669,7 +1668,6 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -1693,7 +1691,6 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -1717,7 +1714,6 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 7e8880a..1450ab8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -307,7 +307,6 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
-	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -396,7 +395,6 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
-	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DYNAMIC,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -456,7 +454,6 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
-	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 906b516..4479357 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2583,6 +2583,10 @@ static int iwl_setup_mac(struct iwl_priv *priv)
 		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
 			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
+	if (priv->cfg->sku & IWL_SKU_N)
+		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
+			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
+
 	hw->sta_data_size = sizeof(struct iwl_station_priv);
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
@@ -3321,6 +3325,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->band = IEEE80211_BAND_2GHZ;
 
 	priv->iw_mode = NL80211_IFTYPE_STATION;
+	priv->current_ht_config.smps = IEEE80211_SMPS_STATIC;
 
 	/* Choose which receivers/antennas to use */
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 47ece91..b5d7c6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -450,8 +450,6 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 	if (priv->cfg->ht_greenfield_support)
 		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
-	ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
-			     (priv->cfg->sm_ps_mode << 2));
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
 	if (priv->hw_params.ht40_channel & BIT(band)) {
 		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
@@ -636,7 +634,7 @@ EXPORT_SYMBOL(iwlcore_rts_tx_cmd_flag);
 
 static bool is_single_rx_stream(struct iwl_priv *priv)
 {
-	return !priv->current_ht_config.is_ht ||
+	return priv->current_ht_config.smps == IEEE80211_SMPS_STATIC ||
 	       priv->current_ht_config.single_chain_sufficient;
 }
 
@@ -1003,28 +1001,18 @@ static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
  */
 static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 {
-	int idle_cnt = active_cnt;
-	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
-
-	/* # Rx chains when idling and maybe trying to save power */
-	switch (priv->cfg->sm_ps_mode) {
-	case WLAN_HT_CAP_SM_PS_STATIC:
-		idle_cnt = (is_cam) ? active_cnt : IWL_NUM_IDLE_CHAINS_SINGLE;
-		break;
-	case WLAN_HT_CAP_SM_PS_DYNAMIC:
-		idle_cnt = (is_cam) ? IWL_NUM_IDLE_CHAINS_DUAL :
-			IWL_NUM_IDLE_CHAINS_SINGLE;
-		break;
-	case WLAN_HT_CAP_SM_PS_DISABLED:
-		break;
-	case WLAN_HT_CAP_SM_PS_INVALID:
+	/* # Rx chains when idling, depending on SMPS mode */
+	switch (priv->current_ht_config.smps) {
+	case IEEE80211_SMPS_STATIC:
+	case IEEE80211_SMPS_DYNAMIC:
+		return IWL_NUM_IDLE_CHAINS_SINGLE;
+	case IEEE80211_SMPS_OFF:
+		return active_cnt;
 	default:
-		IWL_ERR(priv, "invalid sm_ps mode %u\n",
-			priv->cfg->sm_ps_mode);
-		WARN_ON(1);
-		break;
+		WARN(1, "invalid SMPS mode %d",
+		     priv->current_ht_config.smps);
+		return active_cnt;
 	}
-	return idle_cnt;
 }
 
 /* up to 4 chains */
@@ -2686,6 +2674,21 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
 	}
 
+	if (changed & (IEEE80211_CONF_CHANGE_SMPS |
+		       IEEE80211_CONF_CHANGE_CHANNEL)) {
+		/* mac80211 uses static for non-HT which is what we want */
+		priv->current_ht_config.smps = conf->smps_mode;
+
+		/*
+		 * Recalculate chain counts.
+		 *
+		 * If monitor mode is enabled then mac80211 will
+		 * set up the SM PS mode to OFF if an HT channel is
+		 * configured.
+		 */
+		if (priv->cfg->ops->hcmd->set_rxon_chain)
+			priv->cfg->ops->hcmd->set_rxon_chain(priv);
+	}
 
 	/* during scanning mac80211 will delay channel setting until
 	 * scan finish with changed = 0
@@ -2782,10 +2785,6 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		iwl_set_tx_power(priv, conf->power_level, false);
 	}
 
-	/* call to ensure that 4965 rx_chain is set properly in monitor mode */
-	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv);
-
 	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		goto out;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d5c8b06..6cde65b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -231,7 +231,6 @@ struct iwl_mod_params {
  * @chain_noise_num_beacons: number of beacons used to compute chain noise
  * @adv_thermal_throttle: support advance thermal throttle
  * @support_ct_kill_exit: support ct kill exit condition
- * @sm_ps_mode: spatial multiplexing power save mode
  * @support_wimax_coexist: support wimax/wifi co-exist
  *
  * We enable the driver to be backward compatible wrt API version. The
@@ -288,7 +287,6 @@ struct iwl_cfg {
 	const bool supports_idle;
 	bool adv_thermal_throttle;
 	bool support_ct_kill_exit;
-	u8 sm_ps_mode;
 	const bool support_wimax_coexist;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 3c5b27c..3873593 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -512,6 +512,7 @@ struct iwl_ht_config {
 	bool is_ht;
 	bool is_40mhz;
 	bool single_chain_sufficient;
+	enum ieee80211_smps_mode smps; /* current smps mode */
 	/* BSS related data */
 	u8 extension_chan_offset;
 	u8 ht_protection;
-- 
1.5.6.3

