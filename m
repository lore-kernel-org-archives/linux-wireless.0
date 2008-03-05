Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656AbYCECKN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:13 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 02/11] iwlwifi: refactor init geos function
Date: Tue,  4 Mar 2008 18:09:23 -0800
Message-Id: <1204682972-26004-3-git-send-email-reinette.chatre@intel.com> (sfid-20080305_021030_180583_DC741EE8)
In-Reply-To: <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch refactors init geos function. It also fixes few minor bugs.
IWL_MAX_RATE -> IWL_RATE_COUNT (IWL_MAX_RATE included also MCS setting)
There are 9 and 13 rates for 4965 in 2.4 and 5.2 respectively  (rate 60)

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |   40 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   40 +++++++-------
 drivers/net/wireless/iwlwifi/iwl3945-base.c      |   58 ++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl4965-base.c      |   64 +++++++++++++---------
 5 files changed, 115 insertions(+), 91 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 20fbb32..8b7ef9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -666,26 +666,26 @@ struct iwl3945_rx_frame_hdr {
 	u8 payload[0];
 } __attribute__ ((packed));
 
-#define	RX_RES_STATUS_NO_CRC32_ERROR	__constant_cpu_to_le32(1 << 0)
-#define	RX_RES_STATUS_NO_RXE_OVERFLOW	__constant_cpu_to_le32(1 << 1)
-
-#define	RX_RES_PHY_FLAGS_BAND_24_MSK	__constant_cpu_to_le16(1 << 0)
-#define	RX_RES_PHY_FLAGS_MOD_CCK_MSK		__constant_cpu_to_le16(1 << 1)
-#define	RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	__constant_cpu_to_le16(1 << 2)
-#define	RX_RES_PHY_FLAGS_NARROW_BAND_MSK	__constant_cpu_to_le16(1 << 3)
-#define	RX_RES_PHY_FLAGS_ANTENNA_MSK		__constant_cpu_to_le16(0xf0)
-
-#define	RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_WEP	(0x1 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_CCMP	(0x2 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_TKIP	(0x3 << 8)
-
-#define	RX_RES_STATUS_DECRYPT_TYPE_MSK	(0x3 << 11)
-#define	RX_RES_STATUS_NOT_DECRYPT	(0x0 << 11)
-#define	RX_RES_STATUS_DECRYPT_OK	(0x3 << 11)
-#define	RX_RES_STATUS_BAD_ICV_MIC	(0x1 << 11)
-#define	RX_RES_STATUS_BAD_KEY_TTAK	(0x2 << 11)
+#define RX_RES_STATUS_NO_CRC32_ERROR	__constant_cpu_to_le32(1 << 0)
+#define RX_RES_STATUS_NO_RXE_OVERFLOW	__constant_cpu_to_le32(1 << 1)
+
+#define RX_RES_PHY_FLAGS_BAND_24_MSK	__constant_cpu_to_le16(1 << 0)
+#define RX_RES_PHY_FLAGS_MOD_CCK_MSK		__constant_cpu_to_le16(1 << 1)
+#define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	__constant_cpu_to_le16(1 << 2)
+#define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	__constant_cpu_to_le16(1 << 3)
+#define RX_RES_PHY_FLAGS_ANTENNA_MSK		__constant_cpu_to_le16(0xf0)
+
+#define RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
+#define RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
+#define RX_RES_STATUS_SEC_TYPE_WEP	(0x1 << 8)
+#define RX_RES_STATUS_SEC_TYPE_CCMP	(0x2 << 8)
+#define RX_RES_STATUS_SEC_TYPE_TKIP	(0x3 << 8)
+
+#define RX_RES_STATUS_DECRYPT_TYPE_MSK	(0x3 << 11)
+#define RX_RES_STATUS_NOT_DECRYPT	(0x0 << 11)
+#define RX_RES_STATUS_DECRYPT_OK	(0x3 << 11)
+#define RX_RES_STATUS_BAD_ICV_MIC	(0x1 << 11)
+#define RX_RES_STATUS_BAD_KEY_TTAK	(0x2 << 11)
 
 struct iwl3945_rx_frame_end {
 	__le32 status;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
index d5e9220..3c61f08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
@@ -36,8 +36,8 @@ struct iwl3945_rate_info {
 	u8 next_rs;		/* next rate used in rs algo */
 	u8 prev_rs_tgg;		/* previous rate used in TGG rs algo */
 	u8 next_rs_tgg;		/* next rate used in TGG rs algo */
-        u8 table_rs_index;	/* index in rate scale table cmd */
-        u8 prev_table_rs;	/* prev in rate table cmd */
+	u8 table_rs_index;	/* index in rate scale table cmd */
+	u8 prev_table_rs;	/* prev in rate table cmd */
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index b21ffea..327eabc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -875,26 +875,26 @@ struct iwl4965_rx_frame_hdr {
 	u8 payload[0];
 } __attribute__ ((packed));
 
-#define	RX_RES_STATUS_NO_CRC32_ERROR	__constant_cpu_to_le32(1 << 0)
-#define	RX_RES_STATUS_NO_RXE_OVERFLOW	__constant_cpu_to_le32(1 << 1)
-
-#define	RX_RES_PHY_FLAGS_BAND_24_MSK	__constant_cpu_to_le16(1 << 0)
-#define	RX_RES_PHY_FLAGS_MOD_CCK_MSK		__constant_cpu_to_le16(1 << 1)
-#define	RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	__constant_cpu_to_le16(1 << 2)
-#define	RX_RES_PHY_FLAGS_NARROW_BAND_MSK	__constant_cpu_to_le16(1 << 3)
-#define	RX_RES_PHY_FLAGS_ANTENNA_MSK		__constant_cpu_to_le16(0xf0)
-
-#define	RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_WEP	(0x1 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_CCMP	(0x2 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_TKIP	(0x3 << 8)
-
-#define	RX_RES_STATUS_DECRYPT_TYPE_MSK	(0x3 << 11)
-#define	RX_RES_STATUS_NOT_DECRYPT	(0x0 << 11)
-#define	RX_RES_STATUS_DECRYPT_OK	(0x3 << 11)
-#define	RX_RES_STATUS_BAD_ICV_MIC	(0x1 << 11)
-#define	RX_RES_STATUS_BAD_KEY_TTAK	(0x2 << 11)
+#define RX_RES_STATUS_NO_CRC32_ERROR	__constant_cpu_to_le32(1 << 0)
+#define RX_RES_STATUS_NO_RXE_OVERFLOW	__constant_cpu_to_le32(1 << 1)
+
+#define RX_RES_PHY_FLAGS_BAND_24_MSK	__constant_cpu_to_le16(1 << 0)
+#define RX_RES_PHY_FLAGS_MOD_CCK_MSK		__constant_cpu_to_le16(1 << 1)
+#define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	__constant_cpu_to_le16(1 << 2)
+#define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	__constant_cpu_to_le16(1 << 3)
+#define RX_RES_PHY_FLAGS_ANTENNA_MSK		__constant_cpu_to_le16(0xf0)
+
+#define RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
+#define RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
+#define RX_RES_STATUS_SEC_TYPE_WEP	(0x1 << 8)
+#define RX_RES_STATUS_SEC_TYPE_CCMP	(0x2 << 8)
+#define RX_RES_STATUS_SEC_TYPE_TKIP	(0x3 << 8)
+
+#define RX_RES_STATUS_DECRYPT_TYPE_MSK	(0x3 << 11)
+#define RX_RES_STATUS_NOT_DECRYPT	(0x0 << 11)
+#define RX_RES_STATUS_DECRYPT_OK	(0x3 << 11)
+#define RX_RES_STATUS_BAD_ICV_MIC	(0x1 << 11)
+#define RX_RES_STATUS_BAD_KEY_TTAK	(0x2 << 11)
 
 struct iwl4965_rx_frame_end {
 	__le32 status;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 139a4a2..0cafbd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5118,11 +5118,12 @@ static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
 			ch_info->min_power = 0;
 
-			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x"
+			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s%s(0x%02x"
 				       " %ddBm): Ad-Hoc %ssupported\n",
 				       ch_info->channel,
 				       is_channel_a_band(ch_info) ?
 				       "5.2" : "2.4",
+				       CHECK_AND_PRINT(VALID),
 				       CHECK_AND_PRINT(IBSS),
 				       CHECK_AND_PRINT(ACTIVE),
 				       CHECK_AND_PRINT(RADAR),
@@ -5332,7 +5333,7 @@ static void iwl3945_init_hw_rates(struct iwl3945_priv *priv,
 static int iwl3945_init_geos(struct iwl3945_priv *priv)
 {
 	struct iwl3945_channel_info *ch;
-	struct ieee80211_supported_band *band;
+	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *channels;
 	struct ieee80211_channel *geo_ch;
 	struct ieee80211_rate *rates;
@@ -5350,7 +5351,7 @@ static int iwl3945_init_geos(struct iwl3945_priv *priv)
 	if (!channels)
 		return -ENOMEM;
 
-	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_MAX_RATES + 1)),
+	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_RATE_COUNT + 1)),
 			GFP_KERNEL);
 	if (!rates) {
 		kfree(channels);
@@ -5358,38 +5359,38 @@ static int iwl3945_init_geos(struct iwl3945_priv *priv)
 	}
 
 	/* 5.2GHz channels start after the 2.4GHz channels */
-	band = &priv->bands[IEEE80211_BAND_5GHZ];
-	band->channels = &channels[ARRAY_SIZE(iwl3945_eeprom_band_1)];
-	band->bitrates = &rates[4];
-	band->n_bitrates = 8;	/* just OFDM */
-
-	band = &priv->bands[IEEE80211_BAND_2GHZ];
-	band->channels = channels;
-	band->bitrates = rates;
-	band->n_bitrates = 12;	/* OFDM & CCK */
+	sband = &priv->bands[IEEE80211_BAND_5GHZ];
+	sband->channels = &channels[ARRAY_SIZE(iwl3945_eeprom_band_1)];
+	/* just OFDM */
+	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
+	sband->n_bitrates = IWL_RATE_COUNT - IWL_FIRST_OFDM_RATE;
+
+	sband = &priv->bands[IEEE80211_BAND_2GHZ];
+	sband->channels = channels;
+	/* OFDM & CCK */
+	sband->bitrates = rates;
+	sband->n_bitrates = IWL_RATE_COUNT;
 
 	priv->ieee_channels = channels;
 	priv->ieee_rates = rates;
 
 	iwl3945_init_hw_rates(priv, rates);
 
-	for (i = 0, geo_ch = channels; i < priv->channel_count; i++) {
+	for (i = 0;  i < priv->channel_count; i++) {
 		ch = &priv->channel_info[i];
 
-		if (!is_channel_valid(ch)) {
-			IWL_DEBUG_INFO("Channel %d [%sGHz] is restricted -- "
-				    "skipping.\n",
-				    ch->channel, is_channel_a_band(ch) ?
-				    "5.2" : "2.4");
+		/* FIXME: might be removed if scan is OK*/
+		if (!is_channel_valid(ch))
 			continue;
-		}
 
 		if (is_channel_a_band(ch))
-			geo_ch = &priv->bands[IEEE80211_BAND_5GHZ].channels[priv->bands[IEEE80211_BAND_5GHZ].n_channels++];
+			sband =  &priv->bands[IEEE80211_BAND_5GHZ];
 		else
-			geo_ch = &priv->bands[IEEE80211_BAND_2GHZ].channels[priv->bands[IEEE80211_BAND_2GHZ].n_channels++];
+			sband =  &priv->bands[IEEE80211_BAND_2GHZ];
 
-		geo_ch->center_freq = ieee80211chan2mhz(ch->channel);
+		geo_ch = &sband->channels[sband->n_channels++];
+
+		geo_ch->center_freq = ieee80211_channel_to_frequency(ch->channel);
 		geo_ch->max_power = ch->max_power_avg;
 		geo_ch->max_antenna_gain = 0xff;
 		geo_ch->hw_value = ch->channel;
@@ -5407,8 +5408,19 @@ static int iwl3945_init_geos(struct iwl3945_priv *priv)
 			if (ch->max_power_avg > priv->max_channel_txpower_limit)
 				priv->max_channel_txpower_limit =
 				    ch->max_power_avg;
-		} else
+		} else {
 			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
+		}
+
+		/* Save flags for reg domain usage */
+		geo_ch->orig_flags = geo_ch->flags;
+
+		IWL_DEBUG_INFO("Channel %d Freq=%d[%sGHz] %s flag=0%X\n",
+				ch->channel, geo_ch->center_freq,
+				is_channel_a_band(ch) ?  "5.2" : "2.4",
+				geo_ch->flags & IEEE80211_CHAN_DISABLED ?
+				"restricted" : "valid",
+				 geo_ch->flags);
 	}
 
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) && priv->is_abg) {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 99a9f82..46a43ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5501,11 +5501,12 @@ static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
 			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
 			ch_info->min_power = 0;
 
-			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x"
+			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s%s(0x%02x"
 				       " %ddBm): Ad-Hoc %ssupported\n",
 				       ch_info->channel,
 				       is_channel_a_band(ch_info) ?
 				       "5.2" : "2.4",
+				       CHECK_AND_PRINT(VALID),
 				       CHECK_AND_PRINT(IBSS),
 				       CHECK_AND_PRINT(ACTIVE),
 				       CHECK_AND_PRINT(RADAR),
@@ -5748,7 +5749,7 @@ static void iwl4965_init_hw_rates(struct iwl4965_priv *priv,
 static int iwl4965_init_geos(struct iwl4965_priv *priv)
 {
 	struct iwl4965_channel_info *ch;
-	struct ieee80211_supported_band *band;
+	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *channels;
 	struct ieee80211_channel *geo_ch;
 	struct ieee80211_rate *rates;
@@ -5766,7 +5767,7 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 	if (!channels)
 		return -ENOMEM;
 
-	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_MAX_RATES + 1)),
+	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_RATE_COUNT + 1)),
 			GFP_KERNEL);
 	if (!rates) {
 		kfree(channels);
@@ -5774,42 +5775,42 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 	}
 
 	/* 5.2GHz channels start after the 2.4GHz channels */
-	band = &priv->bands[IEEE80211_BAND_5GHZ];
-	band->channels = &channels[ARRAY_SIZE(iwl4965_eeprom_band_1)];
-	band->bitrates = &rates[4];
-	band->n_bitrates = 8;	/* just OFDM */
+	sband = &priv->bands[IEEE80211_BAND_5GHZ];
+	sband->channels = &channels[ARRAY_SIZE(iwl4965_eeprom_band_1)];
+	/* just OFDM */
+	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
+	sband->n_bitrates = IWL_RATE_COUNT - IWL_FIRST_OFDM_RATE;
 
-	iwl4965_init_ht_hw_capab(&band->ht_info, IEEE80211_BAND_5GHZ);
+	iwl4965_init_ht_hw_capab(&sband->ht_info, IEEE80211_BAND_5GHZ);
 
-	band = &priv->bands[IEEE80211_BAND_2GHZ];
-	band->channels = channels;
-	band->bitrates = rates;
-	band->n_bitrates = 12;	/* OFDM & CCK */
+	sband = &priv->bands[IEEE80211_BAND_2GHZ];
+	sband->channels = channels;
+	/* OFDM & CCK */
+	sband->bitrates = rates;
+	sband->n_bitrates = IWL_RATE_COUNT;
 
-	iwl4965_init_ht_hw_capab(&band->ht_info, IEEE80211_BAND_2GHZ);
+	iwl4965_init_ht_hw_capab(&sband->ht_info, IEEE80211_BAND_2GHZ);
 
 	priv->ieee_channels = channels;
 	priv->ieee_rates = rates;
 
 	iwl4965_init_hw_rates(priv, rates);
 
-	for (i = 0, geo_ch = channels; i < priv->channel_count; i++) {
+	for (i = 0;  i < priv->channel_count; i++) {
 		ch = &priv->channel_info[i];
 
-		if (!is_channel_valid(ch)) {
-			IWL_DEBUG_INFO("Channel %d [%sGHz] is restricted -- "
-				    "skipping.\n",
-				    ch->channel, is_channel_a_band(ch) ?
-				    "5.2" : "2.4");
+		/* FIXME: might be removed if scan is OK */
+		if (!is_channel_valid(ch))
 			continue;
-		}
 
-		if (is_channel_a_band(ch)) {
-			geo_ch = &priv->bands[IEEE80211_BAND_5GHZ].channels[priv->bands[IEEE80211_BAND_5GHZ].n_channels++];
-		} else
-			geo_ch = &priv->bands[IEEE80211_BAND_2GHZ].channels[priv->bands[IEEE80211_BAND_2GHZ].n_channels++];
+		if (is_channel_a_band(ch))
+			sband =  &priv->bands[IEEE80211_BAND_5GHZ];
+		else
+			sband =  &priv->bands[IEEE80211_BAND_2GHZ];
 
-		geo_ch->center_freq = ieee80211chan2mhz(ch->channel);
+		geo_ch = &sband->channels[sband->n_channels++];
+
+		geo_ch->center_freq = ieee80211_channel_to_frequency(ch->channel);
 		geo_ch->max_power = ch->max_power_avg;
 		geo_ch->max_antenna_gain = 0xff;
 		geo_ch->hw_value = ch->channel;
@@ -5827,8 +5828,19 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 			if (ch->max_power_avg > priv->max_channel_txpower_limit)
 				priv->max_channel_txpower_limit =
 				    ch->max_power_avg;
-		} else
+		} else {
 			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
+		}
+
+		/* Save flags for reg domain usage */
+		geo_ch->orig_flags = geo_ch->flags;
+
+		IWL_DEBUG_INFO("Channel %d Freq=%d[%sGHz] %s flag=0%X\n",
+				ch->channel, geo_ch->center_freq,
+				is_channel_a_band(ch) ?  "5.2" : "2.4",
+				geo_ch->flags & IEEE80211_CHAN_DISABLED ?
+				"restricted" : "valid",
+				 geo_ch->flags);
 	}
 
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) && priv->is_abg) {
-- 
1.5.3.4

