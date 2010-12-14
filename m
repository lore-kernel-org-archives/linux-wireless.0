Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43486 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371Ab0LNARK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/14] iwlagn: remove old EEPROM TX power reading
Date: Mon, 13 Dec 2010 16:09:26 -0800
Message-Id: <1292285372-11373-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This removes the old TX power reading code, it isn't
necessary since the new code is able to read all the
various EEPROM layouts due to relying on information
contained in the EEPROM.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c       |    2 -
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   12 --
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |  264 +------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h       |    1 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |   53 -----
 5 files changed, 1 insertions(+), 331 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5100c10..94521d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -316,7 +316,6 @@ struct iwl_cfg iwl100_bgn_cfg = {
 	.ht_params = &iwl1000_ht_params,
 	.led_mode = IWL_LED_RF_STATE,
 	.rx_with_siso_diversity = true,
-	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl100_bg_cfg = {
@@ -331,7 +330,6 @@ struct iwl_cfg iwl100_bg_cfg = {
 	.base_params = &iwl1000_base_params,
 	.led_mode = IWL_LED_RF_STATE,
 	.rx_with_siso_diversity = true,
-	.use_new_eeprom_reading = true,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index db70a6b..8a78924 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -568,7 +568,6 @@ struct iwl_cfg iwl6005_2agn_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
-	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6005_2abg_cfg = {
@@ -584,7 +583,6 @@ struct iwl_cfg iwl6005_2abg_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
-	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6005_2bg_cfg = {
@@ -600,7 +598,6 @@ struct iwl_cfg iwl6005_2bg_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
-	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6030_2agn_cfg = {
@@ -621,7 +618,6 @@ struct iwl_cfg iwl6030_2agn_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6030_2abg_cfg = {
@@ -641,7 +637,6 @@ struct iwl_cfg iwl6030_2abg_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6030_2bgn_cfg = {
@@ -662,7 +657,6 @@ struct iwl_cfg iwl6030_2bgn_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6030_2bg_cfg = {
@@ -682,7 +676,6 @@ struct iwl_cfg iwl6030_2bg_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl1030_bgn_cfg = {
@@ -703,7 +696,6 @@ struct iwl_cfg iwl1030_bgn_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl1030_bg_cfg = {
@@ -723,7 +715,6 @@ struct iwl_cfg iwl1030_bg_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.use_new_eeprom_reading = true,
 };
 
 /*
@@ -806,7 +797,6 @@ struct iwl_cfg iwl6150_bgn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
-	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -856,7 +846,6 @@ struct iwl_cfg iwl130_bgn_cfg = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.rx_with_siso_diversity = true,
-	.use_new_eeprom_reading = true,
 };
 
 struct iwl_cfg iwl130_bg_cfg = {
@@ -876,7 +865,6 @@ struct iwl_cfg iwl130_bg_cfg = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.rx_with_siso_diversity = true,
-	.use_new_eeprom_reading = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index cf9194b..3ea006d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -75,109 +75,6 @@
 #include "iwl-agn.h"
 #include "iwl-io.h"
 
-/************************** EEPROM BANDS ****************************
- *
- * The iwl_eeprom_band definitions below provide the mapping from the
- * EEPROM contents to the specific channel number supported for each
- * band.
- *
- * For example, iwl_priv->eeprom.band_3_channels[4] from the band_3
- * definition below maps to physical channel 42 in the 5.2GHz spectrum.
- * The specific geography and calibration information for that channel
- * is contained in the eeprom map itself.
- *
- * During init, we copy the eeprom information and channel map
- * information into priv->channel_info_24/52 and priv->channel_map_24/52
- *
- * channel_map_24/52 provides the index in the channel_info array for a
- * given channel.  We have to have two separate maps as there is channel
- * overlap with the 2.4GHz and 5.2GHz spectrum as seen in band_1 and
- * band_2
- *
- * A value of 0xff stored in the channel_map indicates that the channel
- * is not supported by the hardware at all.
- *
- * A value of 0xfe in the channel_map indicates that the channel is not
- * valid for Tx with the current hardware.  This means that
- * while the system can tune and receive on a given channel, it may not
- * be able to associate or transmit any frames on that
- * channel.  There is no corresponding channel information for that
- * entry.
- *
- *********************************************************************/
-
-/**
- * struct iwl_txpwr_section: eeprom section information
- * @offset: indirect address into eeprom image
- * @count: number of "struct iwl_eeprom_enhanced_txpwr" in this section
- * @band: band type for the section
- * @is_common - true: common section, false: channel section
- * @is_cck - true: cck section, false: not cck section
- * @is_ht_40 - true: all channel in the section are HT40 channel,
- *	       false: legacy or HT 20 MHz
- *	       ignore if it is common section
- * @iwl_eeprom_section_channel: channel array in the section,
- *	       ignore if common section
- */
-struct iwl_txpwr_section {
-	u32 offset;
-	u8 count;
-	enum ieee80211_band band;
-	bool is_common;
-	bool is_cck;
-	bool is_ht40;
-	u8 iwl_eeprom_section_channel[EEPROM_MAX_TXPOWER_SECTION_ELEMENTS];
-};
-
-/**
- * section 1 - 3 are regulatory tx power apply to all channels based on
- *    modulation: CCK, OFDM
- *    Band: 2.4GHz, 5.2GHz
- * section 4 - 10 are regulatory tx power apply to specified channels
- *    For example:
- *	1L - Channel 1 Legacy
- *	1HT - Channel 1 HT
- *	(1,+1) - Channel 1 HT40 "_above_"
- *
- * Section 1: all CCK channels
- * Section 2: all 2.4 GHz OFDM (Legacy, HT and HT40) channels
- * Section 3: all 5.2 GHz OFDM (Legacy, HT and HT40) channels
- * Section 4: 2.4 GHz 20MHz channels: 1L, 1HT, 2L, 2HT, 10L, 10HT, 11L, 11HT
- * Section 5: 2.4 GHz 40MHz channels: (1,+1) (2,+1) (6,+1) (7,+1) (9,+1)
- * Section 6: 5.2 GHz 20MHz channels: 36L, 64L, 100L, 36HT, 64HT, 100HT
- * Section 7: 5.2 GHz 40MHz channels: (36,+1) (60,+1) (100,+1)
- * Section 8: 2.4 GHz channel: 13L, 13HT
- * Section 9: 2.4 GHz channel: 140L, 140HT
- * Section 10: 2.4 GHz 40MHz channels: (132,+1)  (44,+1)
- *
- */
-static const struct iwl_txpwr_section enhinfo[] = {
-	{ EEPROM_LB_CCK_20_COMMON, 1, IEEE80211_BAND_2GHZ, true, true, false },
-	{ EEPROM_LB_OFDM_COMMON, 3, IEEE80211_BAND_2GHZ, true, false, false },
-	{ EEPROM_HB_OFDM_COMMON, 3, IEEE80211_BAND_5GHZ, true, false, false },
-	{ EEPROM_LB_OFDM_20_BAND, 8, IEEE80211_BAND_2GHZ,
-		false, false, false,
-		{1, 1, 2, 2, 10, 10, 11, 11 } },
-	{ EEPROM_LB_OFDM_HT40_BAND, 5, IEEE80211_BAND_2GHZ,
-		false, false, true,
-		{ 1, 2, 6, 7, 9 } },
-	{ EEPROM_HB_OFDM_20_BAND, 6, IEEE80211_BAND_5GHZ,
-		false, false, false,
-		{ 36, 64, 100, 36, 64, 100 } },
-	{ EEPROM_HB_OFDM_HT40_BAND, 3, IEEE80211_BAND_5GHZ,
-		false, false, true,
-		{ 36, 60, 100 } },
-	{ EEPROM_LB_OFDM_20_CHANNEL_13, 2, IEEE80211_BAND_2GHZ,
-		false, false, false,
-		{ 13, 13 } },
-	{ EEPROM_HB_OFDM_20_CHANNEL_140, 2, IEEE80211_BAND_5GHZ,
-		false, false, false,
-		{ 140, 140 } },
-	{ EEPROM_HB_OFDM_HT40_BAND_1, 2, IEEE80211_BAND_5GHZ,
-		false, false, true,
-		{ 132, 44 } },
-};
-
 /******************************************************************************
  *
  * EEPROM related functions
@@ -344,157 +241,6 @@ static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
 	return (max_txpower_avg & 0x01) + (max_txpower_avg >> 1);
 }
 
-/**
- * iwl_update_common_txpower: update channel tx power
- *     update tx power per band based on EEPROM enhanced tx power info.
- */
-static s8 iwl_update_common_txpower(struct iwl_priv *priv,
-		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
-		int section, int element, s8 *max_txpower_in_half_dbm)
-{
-	struct iwl_channel_info *ch_info;
-	int ch;
-	bool is_ht40 = false;
-	s8 max_txpower_avg; /* (dBm) */
-
-	/* it is common section, contain all type (Legacy, HT and HT40)
-	 * based on the element in the section to determine
-	 * is it HT 40 or not
-	 */
-	if (element == EEPROM_TXPOWER_COMMON_HT40_INDEX)
-		is_ht40 = true;
-	max_txpower_avg =
-		iwl_get_max_txpower_avg(priv, enhanced_txpower,
-					element, max_txpower_in_half_dbm);
-
-	ch_info = priv->channel_info;
-
-	for (ch = 0; ch < priv->channel_count; ch++) {
-		/* find matching band and update tx power if needed */
-		if ((ch_info->band == enhinfo[section].band) &&
-		    (ch_info->max_power_avg < max_txpower_avg) &&
-		    (!is_ht40)) {
-			/* Update regulatory-based run-time data */
-			ch_info->max_power_avg = ch_info->curr_txpow =
-				max_txpower_avg;
-			ch_info->scan_power = max_txpower_avg;
-		}
-		if ((ch_info->band == enhinfo[section].band) && is_ht40 &&
-		    (ch_info->ht40_max_power_avg < max_txpower_avg)) {
-			/* Update regulatory-based run-time data */
-			ch_info->ht40_max_power_avg = max_txpower_avg;
-		}
-		ch_info++;
-	}
-	return max_txpower_avg;
-}
-
-/**
- * iwl_update_channel_txpower: update channel tx power
- *      update channel tx power based on EEPROM enhanced tx power info.
- */
-static s8 iwl_update_channel_txpower(struct iwl_priv *priv,
-		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
-		int section, int element, s8 *max_txpower_in_half_dbm)
-{
-	struct iwl_channel_info *ch_info;
-	int ch;
-	u8 channel;
-	s8 max_txpower_avg; /* (dBm) */
-
-	channel = enhinfo[section].iwl_eeprom_section_channel[element];
-	max_txpower_avg =
-		iwl_get_max_txpower_avg(priv, enhanced_txpower,
-					element, max_txpower_in_half_dbm);
-
-	ch_info = priv->channel_info;
-	for (ch = 0; ch < priv->channel_count; ch++) {
-		/* find matching channel and update tx power if needed */
-		if (ch_info->channel == channel) {
-			if ((ch_info->max_power_avg < max_txpower_avg) &&
-			    (!enhinfo[section].is_ht40)) {
-				/* Update regulatory-based run-time data */
-				ch_info->max_power_avg = max_txpower_avg;
-				ch_info->curr_txpow = max_txpower_avg;
-				ch_info->scan_power = max_txpower_avg;
-			}
-			if ((enhinfo[section].is_ht40) &&
-			    (ch_info->ht40_max_power_avg < max_txpower_avg)) {
-				/* Update regulatory-based run-time data */
-				ch_info->ht40_max_power_avg = max_txpower_avg;
-			}
-			break;
-		}
-		ch_info++;
-	}
-	return max_txpower_avg;
-}
-
-/**
- * iwlcore_eeprom_enhanced_txpower: process enhanced tx power info
- */
-static void iwlcore_eeprom_enhanced_txpower_old(struct iwl_priv *priv)
-{
-	int eeprom_section_count = 0;
-	int section, element;
-	struct iwl_eeprom_enhanced_txpwr *enhanced_txpower;
-	u32 offset;
-	s8 max_txpower_avg; /* (dBm) */
-	s8 max_txpower_in_half_dbm; /* (half-dBm) */
-
-	/* Loop through all the sections
-	 * adjust bands and channel's max tx power
-	 * Set the tx_power_user_lmt to the highest power
-	 * supported by any channels and chains
-	 */
-	for (section = 0; section < ARRAY_SIZE(enhinfo); section++) {
-		eeprom_section_count = enhinfo[section].count;
-		offset = enhinfo[section].offset;
-		enhanced_txpower = (struct iwl_eeprom_enhanced_txpwr *)
-				iwl_eeprom_query_addr(priv, offset);
-
-		/*
-		 * check for valid entry -
-		 * different version of EEPROM might contain different set
-		 * of enhanced tx power table
-		 * always check for valid entry before process
-		 * the information
-		 */
-		if (!(enhanced_txpower->flags || enhanced_txpower->channel) ||
-		    enhanced_txpower->delta_20_in_40)
-			continue;
-
-		for (element = 0; element < eeprom_section_count; element++) {
-			if (enhinfo[section].is_common)
-				max_txpower_avg =
-					iwl_update_common_txpower(priv,
-						enhanced_txpower, section,
-						element,
-						&max_txpower_in_half_dbm);
-			else
-				max_txpower_avg =
-					iwl_update_channel_txpower(priv,
-						enhanced_txpower, section,
-						element,
-						&max_txpower_in_half_dbm);
-
-			/* Update the tx_power_user_lmt to the highest power
-			 * supported by any channel */
-			if (max_txpower_avg > priv->tx_power_user_lmt)
-				priv->tx_power_user_lmt = max_txpower_avg;
-
-			/*
-			 * Update the tx_power_lmt_in_half_dbm to
-			 * the highest power supported by any channel
-			 */
-			if (max_txpower_in_half_dbm >
-			    priv->tx_power_lmt_in_half_dbm)
-				priv->tx_power_lmt_in_half_dbm =
-					max_txpower_in_half_dbm;
-		}
-	}
-}
-
 static void
 iwlcore_eeprom_enh_txp_read_element(struct iwl_priv *priv,
 				    struct iwl_eeprom_enhanced_txpwr *txp,
@@ -533,7 +279,7 @@ iwlcore_eeprom_enh_txp_read_element(struct iwl_priv *priv,
 #define EEPROM_TXP_ENTRY_LEN sizeof(struct iwl_eeprom_enhanced_txpwr)
 #define EEPROM_TXP_SZ_OFFS (0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT_SIZE)
 
-static void iwlcore_eeprom_enhanced_txpower_new(struct iwl_priv *priv)
+void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 {
 	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
 	int idx, entries;
@@ -569,11 +315,3 @@ static void iwlcore_eeprom_enhanced_txpower_new(struct iwl_priv *priv)
 		iwlcore_eeprom_enh_txp_read_element(priv, txp, max_txp_avg);
 	}
 }
-
-void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
-{
-	if (priv->cfg->use_new_eeprom_reading)
-		iwlcore_eeprom_enhanced_txpower_new(priv);
-	else
-		iwlcore_eeprom_enhanced_txpower_old(priv);
-}
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b877cbe..d0b86f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -414,7 +414,6 @@ struct iwl_cfg {
 	enum iwl_led_mode led_mode;
 	const bool adv_pm;
 	const bool rx_with_siso_diversity;
-	const bool use_new_eeprom_reading; /* temporary, remove later */
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 8994b5b..9e6f313 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -231,59 +231,6 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_6000_REG_BAND_24_HT40_CHANNELS  ((0x80)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 14  bytes */
 
-/* 6000 and up regulatory tx power - indirect access */
-/* max. elements per section */
-#define EEPROM_MAX_TXPOWER_SECTION_ELEMENTS	(8)
-#define EEPROM_TXPOWER_COMMON_HT40_INDEX	(2)
-
-/**
- * Partition the enhanced tx power portion of eeprom image into
- * 10 sections based on band, modulation, frequency and channel
- *
- * Section 1: all CCK channels
- * Section 2: all 2.4 GHz OFDM (Legacy, HT and HT40 ) channels
- * Section 3: all 5.2 GHz OFDM (Legacy, HT and HT40) channels
- * Section 4: 2.4 GHz 20MHz channels: 1, 2, 10, 11. Both Legacy and HT
- * Section 5: 2.4 GHz 40MHz channels: 1, 2, 6, 7, 9, (_above_)
- * Section 6: 5.2 GHz 20MHz channels: 36, 64, 100, both Legacy and HT
- * Section 7: 5.2 GHz 40MHz channels: 36, 60, 100 (_above_)
- * Section 8: 2.4 GHz channel 13, Both Legacy and HT
- * Section 9: 2.4 GHz channel 140, Both Legacy and HT
- * Section 10: 2.4 GHz 40MHz channels: 132, 44 (_above_)
- */
-/* 2.4 GHz band: CCK */
-#define EEPROM_LB_CCK_20_COMMON       ((0xA8)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 8 bytes */
-/* 2.4 GHz band: 20MHz-Legacy, 20MHz-HT, 40MHz-HT */
-#define EEPROM_LB_OFDM_COMMON       ((0xB0)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
-/* 5.2 GHz band: 20MHz-Legacy, 20MHz-HT, 40MHz-HT */
-#define EEPROM_HB_OFDM_COMMON       ((0xC8)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
-/* 2.4GHz band channels:
- *	1Legacy, 1HT, 2Legacy, 2HT, 10Legacy, 10HT, 11Legacy, 11HT */
-#define EEPROM_LB_OFDM_20_BAND       ((0xE0)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 64 bytes */
-/* 2.4 GHz band HT40 channels: (1,+1) (2,+1) (6,+1) (7,+1) (9,+1) */
-#define EEPROM_LB_OFDM_HT40_BAND       ((0x120)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 40 bytes */
-/* 5.2GHz band channels: 36Legacy, 36HT, 64Legacy, 64HT, 100Legacy, 100HT */
-#define EEPROM_HB_OFDM_20_BAND       ((0x148)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 48 bytes */
-/* 5.2 GHz band HT40 channels: (36,+1) (60,+1) (100,+1) */
-#define EEPROM_HB_OFDM_HT40_BAND       ((0x178)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
-/* 2.4 GHz band, channnel 13: Legacy, HT */
-#define EEPROM_LB_OFDM_20_CHANNEL_13       ((0x190)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 16 bytes */
-/* 5.2 GHz band, channnel 140: Legacy, HT */
-#define EEPROM_HB_OFDM_20_CHANNEL_140       ((0x1A0)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 16 bytes */
-/* 5.2 GHz band, HT40 channnels (132,+1) (44,+1) */
-#define EEPROM_HB_OFDM_HT40_BAND_1       ((0x1B0)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 16 bytes */
-
-
 /* 5050 Specific */
 #define EEPROM_5050_TX_POWER_VERSION    (4)
 #define EEPROM_5050_EEPROM_VERSION	(0x21E)
-- 
1.7.0.4

