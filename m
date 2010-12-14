Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43486 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758098Ab0LNARJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:09 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/14] iwlagn: implement layout-agnostic EEPROM reading
Date: Mon, 13 Dec 2010 16:09:25 -0800
Message-Id: <1292285372-11373-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current EEPROM reading code has some layout
assumptions that now turned out to be false with
some newer versions of the EEPROM. Luckily, we
can avoid all such assumptions by using data in
the EEPROM itself, so implement using that.

However, for risk mitigation purposes, keep the
old reading code for current hardware for now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c       |    2 +
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   12 ++++
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   85 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |    6 ++
 drivers/net/wireless/iwlwifi/iwl-core.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |   15 +++++
 6 files changed, 120 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 94521d4..5100c10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -316,6 +316,7 @@ struct iwl_cfg iwl100_bgn_cfg = {
 	.ht_params = &iwl1000_ht_params,
 	.led_mode = IWL_LED_RF_STATE,
 	.rx_with_siso_diversity = true,
+	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl100_bg_cfg = {
@@ -330,6 +331,7 @@ struct iwl_cfg iwl100_bg_cfg = {
 	.base_params = &iwl1000_base_params,
 	.led_mode = IWL_LED_RF_STATE,
 	.rx_with_siso_diversity = true,
+	.use_new_eeprom_reading = true,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 8a78924..db70a6b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -568,6 +568,7 @@ struct iwl_cfg iwl6005_2agn_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6005_2abg_cfg = {
@@ -583,6 +584,7 @@ struct iwl_cfg iwl6005_2abg_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6005_2bg_cfg = {
@@ -598,6 +600,7 @@ struct iwl_cfg iwl6005_2bg_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6030_2agn_cfg = {
@@ -618,6 +621,7 @@ struct iwl_cfg iwl6030_2agn_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6030_2abg_cfg = {
@@ -637,6 +641,7 @@ struct iwl_cfg iwl6030_2abg_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6030_2bgn_cfg = {
@@ -657,6 +662,7 @@ struct iwl_cfg iwl6030_2bgn_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6030_2bg_cfg = {
@@ -676,6 +682,7 @@ struct iwl_cfg iwl6030_2bg_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl1030_bgn_cfg = {
@@ -696,6 +703,7 @@ struct iwl_cfg iwl1030_bgn_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl1030_bg_cfg = {
@@ -715,6 +723,7 @@ struct iwl_cfg iwl1030_bg_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.use_new_eeprom_reading = true,
 };
 
 /*
@@ -797,6 +806,7 @@ struct iwl_cfg iwl6150_bgn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -846,6 +856,7 @@ struct iwl_cfg iwl130_bgn_cfg = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.rx_with_siso_diversity = true,
+	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl130_bg_cfg = {
@@ -865,6 +876,7 @@ struct iwl_cfg iwl130_bg_cfg = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.rx_with_siso_diversity = true,
+	.use_new_eeprom_reading = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 7c1be8c..cf9194b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -433,7 +433,7 @@ static s8 iwl_update_channel_txpower(struct iwl_priv *priv,
 /**
  * iwlcore_eeprom_enhanced_txpower: process enhanced tx power info
  */
-void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
+static void iwlcore_eeprom_enhanced_txpower_old(struct iwl_priv *priv)
 {
 	int eeprom_section_count = 0;
 	int section, element;
@@ -494,3 +494,86 @@ void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 		}
 	}
 }
+
+static void
+iwlcore_eeprom_enh_txp_read_element(struct iwl_priv *priv,
+				    struct iwl_eeprom_enhanced_txpwr *txp,
+				    s8 max_txpower_avg)
+{
+	int ch_idx;
+	bool is_ht40 = txp->flags & IWL_EEPROM_ENH_TXP_FL_40MHZ;
+	enum ieee80211_band band;
+
+	band = txp->flags & IWL_EEPROM_ENH_TXP_FL_BAND_52G ?
+		IEEE80211_BAND_5GHZ : IEEE80211_BAND_2GHZ;
+
+	for (ch_idx = 0; ch_idx < priv->channel_count; ch_idx++) {
+		struct iwl_channel_info *ch_info = &priv->channel_info[ch_idx];
+
+		/* update matching channel or from common data only */
+		if (txp->channel != 0 && ch_info->channel != txp->channel)
+			continue;
+
+		/* update matching band only */
+		if (band != ch_info->band)
+			continue;
+
+		if (ch_info->max_power_avg < max_txpower_avg && !is_ht40) {
+			ch_info->max_power_avg = max_txpower_avg;
+			ch_info->curr_txpow = max_txpower_avg;
+			ch_info->scan_power = max_txpower_avg;
+		}
+
+		if (is_ht40 && ch_info->ht40_max_power_avg < max_txpower_avg)
+			ch_info->ht40_max_power_avg = max_txpower_avg;
+	}
+}
+
+#define EEPROM_TXP_OFFS	(0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT)
+#define EEPROM_TXP_ENTRY_LEN sizeof(struct iwl_eeprom_enhanced_txpwr)
+#define EEPROM_TXP_SZ_OFFS (0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT_SIZE)
+
+static void iwlcore_eeprom_enhanced_txpower_new(struct iwl_priv *priv)
+{
+	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
+	int idx, entries;
+	__le16 *txp_len;
+	s8 max_txp_avg, max_txp_avg_halfdbm;
+
+	BUILD_BUG_ON(sizeof(struct iwl_eeprom_enhanced_txpwr) != 8);
+
+	/* the length is in 16-bit words, but we want entries */
+	txp_len = (__le16 *) iwlagn_eeprom_query_addr(priv, EEPROM_TXP_SZ_OFFS);
+	entries = le16_to_cpup(txp_len) * 2 / EEPROM_TXP_ENTRY_LEN;
+
+	txp_array = (void *) iwlagn_eeprom_query_addr(priv, EEPROM_TXP_OFFS);
+	for (idx = 0; idx < entries; idx++) {
+		txp = &txp_array[idx];
+
+		/* skip invalid entries */
+		if (!(txp->flags & IWL_EEPROM_ENH_TXP_FL_VALID))
+			continue;
+
+		max_txp_avg = iwl_get_max_txpower_avg(priv, txp_array, idx,
+						      &max_txp_avg_halfdbm);
+
+		/*
+		 * Update the user limit values values to the highest
+		 * power supported by any channel
+		 */
+		if (max_txp_avg > priv->tx_power_user_lmt)
+			priv->tx_power_user_lmt = max_txp_avg;
+		if (max_txp_avg_halfdbm > priv->tx_power_lmt_in_half_dbm)
+			priv->tx_power_lmt_in_half_dbm = max_txp_avg_halfdbm;
+
+		iwlcore_eeprom_enh_txp_read_element(priv, txp, max_txp_avg);
+	}
+}
+
+void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
+{
+	if (priv->cfg->use_new_eeprom_reading)
+		iwlcore_eeprom_enhanced_txpower_new(priv);
+	else
+		iwlcore_eeprom_enhanced_txpower_old(priv);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index d941910..7c8010f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -568,6 +568,12 @@ static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
 	case INDIRECT_REGULATORY:
 		offset = iwl_eeprom_query16(priv, EEPROM_LINK_REGULATORY);
 		break;
+	case INDIRECT_TXP_LIMIT:
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_TXP_LIMIT);
+		break;
+	case INDIRECT_TXP_LIMIT_SIZE:
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_TXP_LIMIT_SIZE);
+		break;
 	case INDIRECT_CALIBRATION:
 		offset = iwl_eeprom_query16(priv, EEPROM_LINK_CALIBRATION);
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d0b86f5..b877cbe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -414,6 +414,7 @@ struct iwl_cfg {
 	enum iwl_led_mode led_mode;
 	const bool adv_pm;
 	const bool rx_with_siso_diversity;
+	const bool use_new_eeprom_reading; /* temporary, remove later */
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index c8566a4..8994b5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -129,6 +129,17 @@ struct iwl_eeprom_channel {
 	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
 } __packed;
 
+enum iwl_eeprom_enhanced_txpwr_flags {
+	IWL_EEPROM_ENH_TXP_FL_VALID		= BIT(0),
+	IWL_EEPROM_ENH_TXP_FL_BAND_52G		= BIT(1),
+	IWL_EEPROM_ENH_TXP_FL_OFDM		= BIT(2),
+	IWL_EEPROM_ENH_TXP_FL_40MHZ		= BIT(3),
+	IWL_EEPROM_ENH_TXP_FL_HT_AP		= BIT(4),
+	IWL_EEPROM_ENH_TXP_FL_RES1		= BIT(5),
+	IWL_EEPROM_ENH_TXP_FL_RES2		= BIT(6),
+	IWL_EEPROM_ENH_TXP_FL_COMMON_TYPE	= BIT(7),
+};
+
 /**
  * iwl_eeprom_enhanced_txpwr structure
  *    This structure presents the enhanced regulatory tx power limit layout
@@ -197,6 +208,8 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_LINK_CALIBRATION      (2*0x67)
 #define EEPROM_LINK_PROCESS_ADJST    (2*0x68)
 #define EEPROM_LINK_OTHERS           (2*0x69)
+#define EEPROM_LINK_TXP_LIMIT        (2*0x6a)
+#define EEPROM_LINK_TXP_LIMIT_SIZE   (2*0x6b)
 
 /* agn regulatory - indirect access */
 #define EEPROM_REG_BAND_1_CHANNELS       ((0x08)\
@@ -400,6 +413,8 @@ struct iwl_eeprom_calib_info {
 #define INDIRECT_CALIBRATION        0x00040000
 #define INDIRECT_PROCESS_ADJST      0x00050000
 #define INDIRECT_OTHERS             0x00060000
+#define INDIRECT_TXP_LIMIT          0x00070000
+#define INDIRECT_TXP_LIMIT_SIZE     0x00080000
 #define INDIRECT_ADDRESS            0x00100000
 
 /* General */
-- 
1.7.0.4

