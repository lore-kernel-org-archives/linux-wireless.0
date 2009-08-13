Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11292 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393AbZHMUbR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/13] iwlwifi: use station HT capabilities and BSS operating mode for Green-field
Date: Thu, 13 Aug 2009 13:30:59 -0700
Message-Id: <1250195462-15811-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
References: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

Green-field mode should be configured in the HT station table.  This patch uses
both the per-station GF support flag as well as the current BSS HT operation
mode (non-GF stations present flag).

Added the "ht_greenfield_support" field to struct iwl_cfg to replace the
device-specific check in rs_use_green().  That check has been moved to
iwlcore_init_ht_hw_capab().

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c   |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-4965.c   |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   26 +++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-core.c   |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-core.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 -
 9 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 9bb6a28..a95caa0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -158,5 +158,6 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.need_pll_cfg = true,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
+	.ht_greenfield_support = true,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index ba5ef83..b5a4d2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2889,7 +2889,8 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.ops = &iwl3945_ops,
 	.mod_params = &iwl3945_mod_params,
-	.use_isr_legacy = true
+	.use_isr_legacy = true,
+	.ht_greenfield_support = false,
 };
 
 static struct iwl_cfg iwl3945_abg_cfg = {
@@ -2902,7 +2903,8 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.ops = &iwl3945_ops,
 	.mod_params = &iwl3945_mod_params,
-	.use_isr_legacy = true
+	.use_isr_legacy = true,
+	.ht_greenfield_support = false,
 };
 
 struct pci_device_id iwl3945_hw_card_ids[] = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e427a89..6a13bfb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2344,7 +2344,8 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.eeprom_calib_ver = EEPROM_4965_TX_POWER_VERSION,
 	.ops = &iwl4965_ops,
 	.mod_params = &iwl4965_mod_params,
-	.use_isr_legacy = true
+	.use_isr_legacy = true,
+	.ht_greenfield_support = false,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 755c184..e1e862e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1652,6 +1652,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = true,
+	.ht_greenfield_support = true,
 };
 
 struct iwl_cfg iwl5100_bg_cfg = {
@@ -1668,6 +1669,7 @@ struct iwl_cfg iwl5100_bg_cfg = {
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = true,
+	.ht_greenfield_support = true,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -1684,6 +1686,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = true,
+	.ht_greenfield_support = true,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -1700,6 +1703,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = true,
+	.ht_greenfield_support = true,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -1716,6 +1720,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = true,
+	.ht_greenfield_support = true,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -1732,6 +1737,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = true,
+	.ht_greenfield_support = true,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 0b731fd..383177d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -171,6 +171,7 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.pa_type = IWL_PA_HYBRID,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
 };
 
 /*
@@ -193,6 +194,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.pa_type = IWL_PA_INTERNAL,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -212,6 +214,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -231,6 +234,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -250,6 +254,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 3b1bbc3..fee110d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -657,19 +657,15 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
 	return 1;
 }
 
-/* in 4965 we don't use greenfield at all */
-static inline u8 rs_use_green(struct iwl_priv *priv,
-			      struct ieee80211_conf *conf)
+/**
+ * Green-field mode is valid if the station supports it and
+ * there are no non-GF stations present in the BSS.
+ */
+static inline u8 rs_use_green(struct ieee80211_sta *sta,
+			      struct iwl_ht_info *ht_conf)
 {
-	u8 is_green;
-
-	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
-		is_green = 0;
-	else
-		is_green = (conf_is_ht(conf) &&
-			   priv->current_ht_config.is_green_field &&
-			   !priv->current_ht_config.non_GF_STA_present);
-	return is_green;
+	return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
+		!(ht_conf->non_GF_STA_present);
 }
 
 /**
@@ -2072,7 +2068,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	if (is_legacy(tbl->lq_type))
 		lq_sta->is_green = 0;
 	else
-		lq_sta->is_green = rs_use_green(priv, conf);
+		lq_sta->is_green = rs_use_green(sta, &priv->current_ht_config);
 	is_green = lq_sta->is_green;
 
 	/* current tx rate */
@@ -2430,7 +2426,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	int rate_idx;
 	int i;
 	u32 rate;
-	u8 use_green = rs_use_green(priv, conf);
+	u8 use_green = rs_use_green(sta, &priv->current_ht_config);
 	u8 active_tbl = 0;
 	u8 valid_tx_ant;
 
@@ -2627,7 +2623,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	lq_sta->is_dup = 0;
 	lq_sta->max_rate_idx = -1;
 	lq_sta->missed_rate_counter = IWL_MISSED_RATE_MAX;
-	lq_sta->is_green = rs_use_green(priv, conf);
+	lq_sta->is_green = rs_use_green(sta, &priv->current_ht_config);
 	lq_sta->active_legacy_rate = priv->active_rate & ~(0x1000);
 	lq_sta->active_rate_basic = priv->active_rate_basic;
 	lq_sta->band = priv->band;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b845cf3..62aa87b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -394,7 +394,8 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 
 	ht_info->ht_supported = true;
 
-	ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
+	if (priv->cfg->ht_greenfield_support)
+		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
 	ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
 			     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
@@ -2391,8 +2392,6 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	}
 	ht_conf = &sta->ht_cap;
 
-	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
-
 	iwl_conf->sm_ps = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
 
 	memcpy(&iwl_conf->mcs, &ht_conf->mcs, 16);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5096834..4ca025a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -251,6 +251,7 @@ struct iwl_cfg {
 	enum iwl_pa_type pa_type;
 	const u16 max_ll_items;
 	const bool shadow_ram_support;
+	const bool ht_greenfield_support;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e6a1c6f..0178734 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -507,7 +507,6 @@ struct iwl_ht_info {
 	u8 is_ht;
 	u8 supported_chan_width;
 	u8 sm_ps;
-	u8 is_green_field;
 	struct ieee80211_mcs_info mcs;
 	/* BSS related data */
 	u8 extension_chan_offset;
-- 
1.5.6.3

