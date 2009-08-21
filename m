Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12007 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932646AbZHUUe3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/14] iwlwifi: read enhanced tx power info from EEPROM image
Date: Fri, 21 Aug 2009 13:34:23 -0700
Message-Id: <1250886867-4112-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For 6000 series and up, additional enhanced regulatory tx power
limitation information is added to EEPROM image.

In order to setup the tx power limitation per channel correctly. Read
the enhanced tx power information from EEPROM image and update
accordingly.

The information is provided per SISO (a,b,c) chain based, it also has
information for both MIMO2 and MIMO3. For tx power regulatory
limitation, take the highest number from all the chains and update.
Also update tx_power_user_lmt to the highest power supported by any
channels and chains

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |  252 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |   80 +++++++++-
 3 files changed, 332 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 33ef736..82b9c93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -126,6 +126,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
 		.calib_version	= iwl5000_eeprom_calib_version,
 		.query_addr = iwl5000_eeprom_query_addr,
+		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
 	.post_associate = iwl_post_associate,
 	.isr = iwl_isr_ict,
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 01b95e8..3d2b93a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -135,6 +135,78 @@ static const u8 iwl_eeprom_band_7[] = {       /* 5.2 ht40 channel */
 	36, 44, 52, 60, 100, 108, 116, 124, 132, 149, 157
 };
 
+/**
+ * struct iwl_txpwr_section: eeprom section information
+ * @offset: indirect address into eeprom image
+ * @count: number of "struct iwl_eeprom_enhanced_txpwr" in this section
+ * @band: band type for the section
+ * @is_common - true: common section, false: channel section
+ * @is_cck - true: cck section, false: not cck section
+ * @is_ht_40 - true: all channel in the section are HT40 channel,
+ * 	       false: legacy or HT 20 MHz
+ *	       ignore if it is common section
+ * @iwl_eeprom_section_channel: channel array in the section,
+ *	       ignore if common section
+ */
+struct iwl_txpwr_section {
+	u32 offset;
+	u8 count;
+	enum ieee80211_band band;
+	bool is_common;
+	bool is_cck;
+	bool is_ht40;
+	u8 iwl_eeprom_section_channel[EEPROM_MAX_TXPOWER_SECTION_ELEMENTS];
+};
+
+/**
+ * section 1 - 3 are regulatory tx power apply to all channels based on
+ *    modulation: CCK, OFDM
+ *    Band: 2.4GHz, 5.2GHz
+ * section 4 - 10 are regulatory tx power apply to specified channels
+ *    For example:
+ *	1L - Channel 1 Legacy
+ *	1HT - Channel 1 HT
+ *	(1,+1) - Channel 1 HT40 "_above_"
+ *
+ * Section 1: all CCK channels
+ * Section 2: all 2.4 GHz OFDM (Legacy, HT and HT40) channels
+ * Section 3: all 5.2 GHz OFDM (Legacy, HT and HT40) channels
+ * Section 4: 2.4 GHz 20MHz channels: 1L, 1HT, 2L, 2HT, 10L, 10HT, 11L, 11HT
+ * Section 5: 2.4 GHz 40MHz channels: (1,+1) (2,+1) (6,+1) (7,+1) (9,+1)
+ * Section 6: 5.2 GHz 20MHz channels: 36L, 64L, 100L, 36HT, 64HT, 100HT
+ * Section 7: 5.2 GHz 40MHz channels: (36,+1) (60,+1) (100,+1)
+ * Section 8: 2.4 GHz channel: 13L, 13HT
+ * Section 9: 2.4 GHz channel: 140L, 140HT
+ * Section 10: 2.4 GHz 40MHz channels: (132,+1)  (44,+1)
+ *
+ */
+static const struct iwl_txpwr_section enhinfo[] = {
+	{ EEPROM_LB_CCK_20_COMMON, 1, IEEE80211_BAND_2GHZ, true, true, false },
+	{ EEPROM_LB_OFDM_COMMON, 3, IEEE80211_BAND_2GHZ, true, false, false },
+	{ EEPROM_HB_OFDM_COMMON, 3, IEEE80211_BAND_5GHZ, true, false, false },
+	{ EEPROM_LB_OFDM_20_BAND, 8, IEEE80211_BAND_2GHZ,
+		false, false, false,
+		{1, 1, 2, 2, 10, 10, 11, 11 } },
+	{ EEPROM_LB_OFDM_HT40_BAND, 5, IEEE80211_BAND_2GHZ,
+		false, false, true,
+		{ 1, 2, 6, 7, 9 } },
+	{ EEPROM_HB_OFDM_20_BAND, 6, IEEE80211_BAND_5GHZ,
+		false, false, false,
+		{ 36, 64, 100, 36, 64, 100 } },
+	{ EEPROM_HB_OFDM_HT40_BAND, 3, IEEE80211_BAND_5GHZ,
+		false, false, true,
+		{ 36, 60, 100 } },
+	{ EEPROM_LB_OFDM_20_CHANNEL_13, 2, IEEE80211_BAND_2GHZ,
+		false, false, false,
+		{ 13, 13 } },
+	{ EEPROM_HB_OFDM_20_CHANNEL_140, 2, IEEE80211_BAND_5GHZ,
+		false, false, false,
+		{ 140, 140 } },
+	{ EEPROM_HB_OFDM_HT40_BAND_1, 2, IEEE80211_BAND_5GHZ,
+		false, false, true,
+		{ 132, 44 } },
+};
+
 /******************************************************************************
  *
  * EEPROM related functions
@@ -643,6 +715,178 @@ static int iwl_mod_ht40_chan_info(struct iwl_priv *priv,
 	return 0;
 }
 
+/**
+ * iwl_get_max_txpower_avg - get the highest tx power from all chains.
+ *     find the highest tx power from all chains for the channel
+ */
+static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
+		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower, int element)
+{
+	s8 max_txpower_avg = 0; /* (dBm) */
+
+	IWL_DEBUG_INFO(priv, "%d - "
+			"chain_a: %d dB chain_b: %d dB "
+			"chain_c: %d dB mimo2: %d dB mimo3: %d dB\n",
+			element,
+			enhanced_txpower[element].chain_a_max >> 1,
+			enhanced_txpower[element].chain_b_max >> 1,
+			enhanced_txpower[element].chain_c_max >> 1,
+			enhanced_txpower[element].mimo2_max >> 1,
+			enhanced_txpower[element].mimo3_max >> 1);
+	/* Take the highest tx power from any valid chains */
+	if ((priv->cfg->valid_tx_ant & ANT_A) &&
+	    (enhanced_txpower[element].chain_a_max > max_txpower_avg))
+		max_txpower_avg = enhanced_txpower[element].chain_a_max;
+	if ((priv->cfg->valid_tx_ant & ANT_B) &&
+	    (enhanced_txpower[element].chain_b_max > max_txpower_avg))
+		max_txpower_avg = enhanced_txpower[element].chain_b_max;
+	if ((priv->cfg->valid_tx_ant & ANT_C) &&
+	    (enhanced_txpower[element].chain_c_max > max_txpower_avg))
+		max_txpower_avg = enhanced_txpower[element].chain_c_max;
+	if (((priv->cfg->valid_tx_ant == ANT_AB) |
+	    (priv->cfg->valid_tx_ant == ANT_BC) |
+	    (priv->cfg->valid_tx_ant == ANT_AC)) &&
+	    (enhanced_txpower[element].mimo2_max > max_txpower_avg))
+		max_txpower_avg =  enhanced_txpower[element].mimo2_max;
+	if ((priv->cfg->valid_tx_ant == ANT_ABC) &&
+	    (enhanced_txpower[element].mimo3_max > max_txpower_avg))
+		max_txpower_avg = enhanced_txpower[element].mimo3_max;
+
+	/* max. tx power in EEPROM is in 1/2 dBm format
+	 * convert from 1/2 dBm to dBm
+	 */
+	return max_txpower_avg >> 1;
+}
+
+/**
+ * iwl_update_common_txpower: update channel tx power
+ *     update tx power per band based on EEPROM enhanced tx power info.
+ */
+static s8 iwl_update_common_txpower(struct iwl_priv *priv,
+		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
+		int section, int element)
+{
+	struct iwl_channel_info *ch_info;
+	int ch;
+	bool is_ht40 = false;
+	s8 max_txpower_avg; /* (dBm) */
+
+	/* it is common section, contain all type (Legacy, HT and HT40)
+	 * based on the element in the section to determine
+	 * is it HT 40 or not
+	 */
+	if (element == EEPROM_TXPOWER_COMMON_HT40_INDEX)
+		is_ht40 = true;
+	max_txpower_avg =
+		iwl_get_max_txpower_avg(priv, enhanced_txpower, element);
+	ch_info = priv->channel_info;
+
+	for (ch = 0; ch < priv->channel_count; ch++) {
+		/* find matching band and update tx power if needed */
+		if ((ch_info->band == enhinfo[section].band) &&
+		    (ch_info->max_power_avg < max_txpower_avg) && (!is_ht40)) {
+			/* Update regulatory-based run-time data */
+			ch_info->max_power_avg = ch_info->curr_txpow =
+			    max_txpower_avg;
+			ch_info->scan_power = max_txpower_avg;
+		}
+		if ((ch_info->band == enhinfo[section].band) && is_ht40 &&
+		    ch_info->ht40_max_power_avg &&
+		    (ch_info->ht40_max_power_avg < max_txpower_avg)) {
+			/* Update regulatory-based run-time data */
+			ch_info->ht40_max_power_avg = max_txpower_avg;
+			ch_info->ht40_curr_txpow = max_txpower_avg;
+			ch_info->ht40_scan_power = max_txpower_avg;
+		}
+		ch_info++;
+	}
+	return max_txpower_avg;
+}
+
+/**
+ * iwl_update_channel_txpower: update channel tx power
+ *      update channel tx power based on EEPROM enhanced tx power info.
+ */
+static s8 iwl_update_channel_txpower(struct iwl_priv *priv,
+		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
+		int section, int element)
+{
+	struct iwl_channel_info *ch_info;
+	int ch;
+	u8 channel;
+	s8 max_txpower_avg; /* (dBm) */
+
+	channel = enhinfo[section].iwl_eeprom_section_channel[element];
+	max_txpower_avg =
+		iwl_get_max_txpower_avg(priv, enhanced_txpower, element);
+
+	ch_info = priv->channel_info;
+	for (ch = 0; ch < priv->channel_count; ch++) {
+		/* find matching channel and update tx power if needed */
+		if (ch_info->channel == channel) {
+			if ((ch_info->max_power_avg < max_txpower_avg) &&
+			    (!enhinfo[section].is_ht40)) {
+				/* Update regulatory-based run-time data */
+				ch_info->max_power_avg = max_txpower_avg;
+				ch_info->curr_txpow = max_txpower_avg;
+				ch_info->scan_power = max_txpower_avg;
+			}
+			if ((enhinfo[section].is_ht40) &&
+			    (ch_info->ht40_max_power_avg) &&
+			    (ch_info->ht40_max_power_avg < max_txpower_avg)) {
+				/* Update regulatory-based run-time data */
+				ch_info->ht40_max_power_avg = max_txpower_avg;
+				ch_info->ht40_curr_txpow = max_txpower_avg;
+				ch_info->ht40_scan_power = max_txpower_avg;
+			}
+			break;
+		}
+		ch_info++;
+	}
+	return max_txpower_avg;
+}
+
+/**
+ * iwlcore_eeprom_enhanced_txpower: process enhanced tx power info
+ */
+void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
+{
+	int eeprom_section_count = 0;
+	int section, element;
+	struct iwl_eeprom_enhanced_txpwr *enhanced_txpower;
+	u32 offset;
+	s8 max_txpower_avg; /* (dBm) */
+
+	/* Loop through all the sections
+	 * adjust bands and channel's max tx power
+	 * Set the tx_power_user_lmt to the highest power
+	 * supported by any channels and chains
+	 */
+	for (section = 0; section < ARRAY_SIZE(enhinfo); section++) {
+		eeprom_section_count = enhinfo[section].count;
+		offset = enhinfo[section].offset;
+		enhanced_txpower = (struct iwl_eeprom_enhanced_txpwr *)
+				iwl_eeprom_query_addr(priv, offset);
+
+		for (element = 0; element < eeprom_section_count; element++) {
+			if (enhinfo[section].is_common)
+				max_txpower_avg =
+					iwl_update_common_txpower(priv,
+					enhanced_txpower, section, element);
+			else
+				max_txpower_avg =
+					iwl_update_channel_txpower(priv,
+					enhanced_txpower, section, element);
+
+			/* Update the tx_power_user_lmt to the highest power
+			 * supported by any channel */
+			if (max_txpower_avg > priv->tx_power_user_lmt)
+				priv->tx_power_user_lmt = max_txpower_avg;
+		}
+	}
+}
+EXPORT_SYMBOL(iwlcore_eeprom_enhanced_txpower);
+
 #define CHECK_AND_PRINT_I(x) ((eeprom_ch_info[ch].flags & EEPROM_CHANNEL_##x) \
 			    ? # x " " : "")
 
@@ -790,6 +1034,14 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 		}
 	}
 
+	/* for newer device (6000 series and up)
+	 * EEPROM contain enhanced tx power information
+	 * driver need to process addition information
+	 * to determine the max channel tx power limits
+	 */
+	if (priv->cfg->ops->lib->eeprom_ops.update_enhanced_txpower)
+		priv->cfg->ops->lib->eeprom_ops.update_enhanced_txpower(priv);
+
 	return 0;
 }
 EXPORT_SYMBOL(iwl_init_channel_map);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index ca7920a..6b68db7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -118,6 +118,30 @@ struct iwl_eeprom_channel {
 	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
 } __attribute__ ((packed));
 
+/**
+ * iwl_eeprom_enhanced_txpwr structure
+ *    This structure presents the enhanced regulatory tx power limit layout
+ *    in eeprom image
+ *    Enhanced regulatory tx power portion of eeprom image can be broken down
+ *    into individual structures; each one is 8 bytes in size and contain the
+ *    following information
+ * @chain_a_max_pwr: chain a max power in 1/2 dBm
+ * @chain_b_max_pwr: chain b max power in 1/2 dBm
+ * @chain_c_max_pwr: chain c max power in 1/2 dBm
+ * @mimo2_max_pwr: mimo2 max power in 1/2 dBm
+ * @mimo3_max_pwr: mimo3 max power in 1/2 dBm
+ *
+ */
+struct iwl_eeprom_enhanced_txpwr {
+	u16 reserved;
+	s8 chain_a_max;
+	s8 chain_b_max;
+	s8 chain_c_max;
+	s8 reserved1;
+	s8 mimo2_max;
+	s8 mimo3_max;
+} __attribute__ ((packed));
+
 /* 3945 Specific */
 #define EEPROM_3945_EEPROM_VERSION	(0x2f)
 
@@ -175,6 +199,59 @@ struct iwl_eeprom_channel {
 #define EEPROM_5000_REG_BAND_52_HT40_CHANNELS  ((0x92)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 22  bytes */
 
+/* 6000 and up regulatory tx power - indirect access */
+/* max. elements per section */
+#define EEPROM_MAX_TXPOWER_SECTION_ELEMENTS	(8)
+#define EEPROM_TXPOWER_COMMON_HT40_INDEX	(2)
+
+/**
+ * Partition the enhanced tx power portion of eeprom image into
+ * 10 sections based on band, modulation, frequency and channel
+ *
+ * Section 1: all CCK channels
+ * Section 2: all 2.4 GHz OFDM (Legacy, HT and HT40 ) channels
+ * Section 3: all 5.2 GHz OFDM (Legacy, HT and HT40) channels
+ * Section 4: 2.4 GHz 20MHz channels: 1, 2, 10, 11. Both Legacy and HT
+ * Section 5: 2.4 GHz 40MHz channels: 1, 2, 6, 7, 9, (_above_)
+ * Section 6: 5.2 GHz 20MHz channels: 36, 64, 100, both Legacy and HT
+ * Section 7: 5.2 GHz 40MHz channels: 36, 60, 100 (_above_)
+ * Section 8: 2.4 GHz channel 13, Both Legacy and HT
+ * Section 9: 2.4 GHz channel 140, Both Legacy and HT
+ * Section 10: 2.4 GHz 40MHz channels: 132, 44 (_above_)
+ */
+/* 2.4 GHz band: CCK */
+#define EEPROM_LB_CCK_20_COMMON       ((0xAA)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 8 bytes */
+/* 2.4 GHz band: 20MHz-Legacy, 20MHz-HT, 40MHz-HT */
+#define EEPROM_LB_OFDM_COMMON       ((0xB2)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
+/* 5.2 GHz band: 20MHz-Legacy, 20MHz-HT, 40MHz-HT */
+#define EEPROM_HB_OFDM_COMMON       ((0xCA)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
+/* 2.4GHz band channels:
+ *	1Legacy, 1HT, 2Legacy, 2HT, 10Legacy, 10HT, 11Legacy, 11HT */
+#define EEPROM_LB_OFDM_20_BAND       ((0xE2)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 64 bytes */
+/* 2.4 GHz band HT40 channels: (1,+1) (2,+1) (6,+1) (7,+1) (9,+1) */
+#define EEPROM_LB_OFDM_HT40_BAND       ((0x122)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 40 bytes */
+/* 5.2GHz band channels: 36Legacy, 36HT, 64Legacy, 64HT, 100Legacy, 100HT */
+#define EEPROM_HB_OFDM_20_BAND       ((0x14A)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 48 bytes */
+/* 5.2 GHz band HT40 channels: (36,+1) (60,+1) (100,+1) */
+#define EEPROM_HB_OFDM_HT40_BAND       ((0x17A)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
+/* 2.4 GHz band, channnel 13: Legacy, HT */
+#define EEPROM_LB_OFDM_20_CHANNEL_13       ((0x192)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 16 bytes */
+/* 5.2 GHz band, channnel 140: Legacy, HT */
+#define EEPROM_HB_OFDM_20_CHANNEL_140       ((0x1A2)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 16 bytes */
+/* 5.2 GHz band, HT40 channnels (132,+1) (44,+1) */
+#define EEPROM_HB_OFDM_HT40_BAND_1       ((0x1B2)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 16 bytes */
+
+
 /* 5050 Specific */
 #define EEPROM_5050_TX_POWER_VERSION    (4)
 #define EEPROM_5050_EEPROM_VERSION	(0x21E)
@@ -389,6 +466,7 @@ struct iwl_eeprom_ops {
 	void (*release_semaphore) (struct iwl_priv *priv);
 	u16 (*calib_version) (struct iwl_priv *priv);
 	const u8* (*query_addr) (const struct iwl_priv *priv, size_t offset);
+	void (*update_enhanced_txpower) (struct iwl_priv *priv);
 };
 
 
@@ -403,7 +481,7 @@ int iwlcore_eeprom_verify_signature(struct iwl_priv *priv);
 int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv);
 void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv);
 const u8 *iwlcore_eeprom_query_addr(const struct iwl_priv *priv, size_t offset);
-
+void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv);
 int iwl_init_channel_map(struct iwl_priv *priv);
 void iwl_free_channel_map(struct iwl_priv *priv);
 const struct iwl_channel_info *iwl_get_channel_info(
-- 
1.5.6.3

