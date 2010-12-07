Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab0LGRoF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 12:44:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/3] iwlagn: implement layout-agnostic EEPROM reading
Date: Tue,  7 Dec 2010 09:37:07 -0800
Message-Id: <1291743428-19642-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1291743428-19642-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1291743428-19642-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current EEPROM reading code has some layout
assumptions that now turned out to be false with
some newer versions of the EEPROM. Luckily, we
can avoid all such assumptions by using data in
the EEPROM itself, so implement using that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |  264 ++++++-------------------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |    6 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |   15 ++
 3 files changed, 79 insertions(+), 206 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 9651060..e777740 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -106,78 +106,6 @@
  *
  *********************************************************************/
 
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
@@ -303,153 +231,77 @@ static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
 	return (max_txpower_avg & 0x01) + (max_txpower_avg >> 1);
 }
 
-/**
- * iwl_update_common_txpower: update channel tx power
- *     update tx power per band based on EEPROM enhanced tx power info.
- */
-static s8 iwl_update_common_txpower(struct iwl_priv *priv,
-		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
-		int section, int element, s8 *max_txpower_in_half_dbm)
+static void
+iwlcore_eeprom_enh_txp_read_element(struct iwl_priv *priv,
+				    struct iwl_eeprom_enhanced_txpwr *txp,
+				    s8 max_txpower_avg)
 {
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
 			ch_info->scan_power = max_txpower_avg;
 		}
-		if ((ch_info->band == enhinfo[section].band) && is_ht40 &&
-		    (ch_info->ht40_max_power_avg < max_txpower_avg)) {
-			/* Update regulatory-based run-time data */
+
+		if (is_ht40 && ch_info->ht40_max_power_avg < max_txpower_avg)
 			ch_info->ht40_max_power_avg = max_txpower_avg;
-		}
-		ch_info++;
 	}
-	return max_txpower_avg;
 }
 
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
+#define EEPROM_TXP_OFFS	(0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT)
+#define EEPROM_TXP_ENTRY_LEN sizeof(struct iwl_eeprom_enhanced_txpwr)
+#define EEPROM_TXP_SZ_OFFS (0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT_SIZE)
 
-/**
- * iwlcore_eeprom_enhanced_txpower: process enhanced tx power info
- */
 void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 {
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
+	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
+	int idx, entries;
+	__le16 *txp_len;
+	s8 max_txp_avg, max_txp_avg_halfdbm;
+
+	BUILD_BUG_ON(sizeof(struct iwl_eeprom_enhanced_txpwr) != 8);
+
+	/* the length is in 16-bit words, but we want entries */
+	txp_len = (__le16 *) iwlagn_eeprom_query_addr(priv, EEPROM_TXP_SZ_OFFS);
+	entries = cpu_to_le16p(txp_len) * 2 / EEPROM_TXP_ENTRY_LEN;
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
 
 		/*
-		 * check for valid entry -
-		 * different version of EEPROM might contain different set
-		 * of enhanced tx power table
-		 * always check for valid entry before process
-		 * the information
+		 * Update the user limit values values to the highest
+		 * power supported by any channel
 		 */
-		if (!(enhanced_txpower->flags || enhanced_txpower->channel) ||
-		    enhanced_txpower->delta_20_in_40)
-			continue;
+		if (max_txp_avg > priv->tx_power_user_lmt)
+			priv->tx_power_user_lmt = max_txp_avg;
+		if (max_txp_avg_halfdbm > priv->tx_power_lmt_in_half_dbm)
+			priv->tx_power_lmt_in_half_dbm = max_txp_avg_halfdbm;
 
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
+		iwlcore_eeprom_enh_txp_read_element(priv, txp, max_txp_avg);
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index b555edd..554afb7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -569,6 +569,12 @@ static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 310e345..e3a279d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -120,6 +120,17 @@ struct iwl_eeprom_channel {
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
@@ -188,6 +199,8 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_LINK_CALIBRATION      (2*0x67)
 #define EEPROM_LINK_PROCESS_ADJST    (2*0x68)
 #define EEPROM_LINK_OTHERS           (2*0x69)
+#define EEPROM_LINK_TXP_LIMIT        (2*0x6a)
+#define EEPROM_LINK_TXP_LIMIT_SIZE   (2*0x6b)
 
 /* agn regulatory - indirect access */
 #define EEPROM_REG_BAND_1_CHANNELS       ((0x08)\
@@ -391,6 +404,8 @@ struct iwl_eeprom_calib_info {
 #define INDIRECT_CALIBRATION        0x00040000
 #define INDIRECT_PROCESS_ADJST      0x00050000
 #define INDIRECT_OTHERS             0x00060000
+#define INDIRECT_TXP_LIMIT          0x00070000
+#define INDIRECT_TXP_LIMIT_SIZE     0x00080000
 #define INDIRECT_ADDRESS            0x00100000
 
 /* General */
-- 
1.7.0.4

