Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36539 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbZKTUFG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/19] iwlwifi: set sm_ps_mode as part of cfg parameters
Date: Fri, 20 Nov 2009 12:04:55 -0800
Message-Id: <1258747510-21233-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Setting "Spatial multiplexing Power Save" as part of
per device configuration parameter.

Report to uCode based on priv->conf setting, so driver can
have more control of how different devices should operate
in power save mode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 +++
 drivers/net/wireless/iwlwifi/iwl-6000.c |    4 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    4 ---
 drivers/net/wireless/iwlwifi/iwl-core.c |   45 +++++++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 8 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 105283b..325b244 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -173,6 +173,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
+	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a5f7916..61ecd90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2239,6 +2239,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.broken_powersave = true,
 	.led_compensation = 61,
 	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
+	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 30b1d66..bbde208 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1598,6 +1598,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 struct iwl_cfg iwl5100_bg_cfg = {
@@ -1667,6 +1668,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -1690,6 +1692,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -1713,6 +1716,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 4ab9897..74e5710 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -306,6 +306,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
+	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -394,7 +395,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
-	.support_sm_ps = true,
+	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DYNAMIC,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -454,6 +455,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
+	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9dda463..8a39e0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3136,10 +3136,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->band = IEEE80211_BAND_2GHZ;
 
 	priv->iw_mode = NL80211_IFTYPE_STATION;
-	if (priv->cfg->support_sm_ps)
-		priv->current_ht_config.sm_ps = WLAN_HT_CAP_SM_PS_DYNAMIC;
-	else
-		priv->current_ht_config.sm_ps = WLAN_HT_CAP_SM_PS_DISABLED;
 
 	/* Choose which receivers/antennas to use */
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index de16485..2d6d590 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -450,13 +450,8 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 	if (priv->cfg->ht_greenfield_support)
 		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
-	if (priv->cfg->support_sm_ps)
-		ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
-				     (WLAN_HT_CAP_SM_PS_DYNAMIC << 2));
-	else
-		ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
-				     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
-
+	ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
+			     (priv->cfg->sm_ps_mode << 2));
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
 	if (priv->hw_params.ht40_channel & BIT(band)) {
 		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
@@ -1011,25 +1006,23 @@ static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 	int idle_cnt = active_cnt;
 	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
 
-	if (priv->cfg->support_sm_ps) {
-		/* # Rx chains when idling and maybe trying to save power */
-		switch (priv->current_ht_config.sm_ps) {
-		case WLAN_HT_CAP_SM_PS_STATIC:
-		case WLAN_HT_CAP_SM_PS_DYNAMIC:
-			idle_cnt = (is_cam) ? IWL_NUM_IDLE_CHAINS_DUAL :
-				IWL_NUM_IDLE_CHAINS_SINGLE;
-			break;
-		case WLAN_HT_CAP_SM_PS_DISABLED:
-			idle_cnt = (is_cam) ? active_cnt :
-				IWL_NUM_IDLE_CHAINS_SINGLE;
-			break;
-		case WLAN_HT_CAP_SM_PS_INVALID:
-		default:
-			IWL_ERR(priv, "invalid sm_ps mode %d\n",
-				priv->current_ht_config.sm_ps);
-			WARN_ON(1);
-			break;
-		}
+	/* # Rx chains when idling and maybe trying to save power */
+	switch (priv->cfg->sm_ps_mode) {
+	case WLAN_HT_CAP_SM_PS_STATIC:
+		idle_cnt = (is_cam) ? active_cnt : IWL_NUM_IDLE_CHAINS_SINGLE;
+		break;
+	case WLAN_HT_CAP_SM_PS_DYNAMIC:
+		idle_cnt = (is_cam) ? IWL_NUM_IDLE_CHAINS_DUAL :
+			IWL_NUM_IDLE_CHAINS_SINGLE;
+		break;
+	case WLAN_HT_CAP_SM_PS_DISABLED:
+		break;
+	case WLAN_HT_CAP_SM_PS_INVALID:
+	default:
+		IWL_ERR(priv, "invalid sm_ps mode %u\n",
+			priv->cfg->sm_ps_mode);
+		WARN_ON(1);
+		break;
 	}
 	return idle_cnt;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f38e4cc..d75471c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -228,7 +228,7 @@ struct iwl_mod_params {
  * @chain_noise_num_beacons: number of beacons used to compute chain noise
  * @adv_thermal_throttle: support advance thermal throttle
  * @support_ct_kill_exit: support ct kill exit condition
- * @support_sm_ps: support spatial multiplexing power save
+ * @sm_ps_mode: spatial multiplexing power save mode
  * @support_wimax_coexist: support wimax/wifi co-exist
  *
  * We enable the driver to be backward compatible wrt API version. The
@@ -285,7 +285,7 @@ struct iwl_cfg {
 	const bool supports_idle;
 	bool adv_thermal_throttle;
 	bool support_ct_kill_exit;
-	bool support_sm_ps;
+	u8 sm_ps_mode;
 	const bool support_wimax_coexist;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f1601cf..1c1ed4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -511,7 +511,6 @@ struct iwl_ht_config {
 	bool is_ht;
 	bool is_40mhz;
 	bool single_chain_sufficient;
-	u8 sm_ps;
 	/* BSS related data */
 	u8 extension_chan_offset;
 	u8 ht_protection;
-- 
1.5.6.3

