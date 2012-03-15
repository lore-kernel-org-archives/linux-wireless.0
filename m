Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21182 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161458Ab2COU2I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/26] iwlwifi: move iwl_init_geos to iwl-agn.c
Date: Thu, 15 Mar 2012 13:26:58 -0700
Message-Id: <1331843226-29860-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212842_298105_8C1FA900)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

This is used only in one file, move it there
and make it static.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |  183 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |  183 -------------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    7 -
 3 files changed, 183 insertions(+), 190 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3476130..b8fcb4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1134,6 +1134,189 @@ static void iwl_init_hw_rates(struct ieee80211_rate *rates)
 	}
 }
 
+#define MAX_BIT_RATE_40_MHZ 150 /* Mbps */
+#define MAX_BIT_RATE_20_MHZ 72 /* Mbps */
+static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
+			      struct ieee80211_sta_ht_cap *ht_info,
+			      enum ieee80211_band band)
+{
+	u16 max_bit_rate = 0;
+	u8 rx_chains_num = hw_params(priv).rx_chains_num;
+	u8 tx_chains_num = hw_params(priv).tx_chains_num;
+
+	ht_info->cap = 0;
+	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
+
+	ht_info->ht_supported = true;
+
+	if (cfg(priv)->ht_params &&
+	    cfg(priv)->ht_params->ht_greenfield_support)
+		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
+	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
+	max_bit_rate = MAX_BIT_RATE_20_MHZ;
+	if (hw_params(priv).ht40_channel & BIT(band)) {
+		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
+		ht_info->mcs.rx_mask[4] = 0x01;
+		max_bit_rate = MAX_BIT_RATE_40_MHZ;
+	}
+
+	if (iwlagn_mod_params.amsdu_size_8K)
+		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
+
+	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
+	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
+
+	ht_info->mcs.rx_mask[0] = 0xFF;
+	if (rx_chains_num >= 2)
+		ht_info->mcs.rx_mask[1] = 0xFF;
+	if (rx_chains_num >= 3)
+		ht_info->mcs.rx_mask[2] = 0xFF;
+
+	/* Highest supported Rx data rate */
+	max_bit_rate *= rx_chains_num;
+	WARN_ON(max_bit_rate & ~IEEE80211_HT_MCS_RX_HIGHEST_MASK);
+	ht_info->mcs.rx_highest = cpu_to_le16(max_bit_rate);
+
+	/* Tx MCS capabilities */
+	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+	if (tx_chains_num != rx_chains_num) {
+		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
+		ht_info->mcs.tx_params |= ((tx_chains_num - 1) <<
+				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
+	}
+}
+
+/**
+ * iwl_init_geos - Initialize mac80211's geo/channel info based from eeprom
+ */
+static int iwl_init_geos(struct iwl_priv *priv)
+{
+	struct iwl_channel_info *ch;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *channels;
+	struct ieee80211_channel *geo_ch;
+	struct ieee80211_rate *rates;
+	int i = 0;
+	s8 max_tx_power = IWLAGN_TX_POWER_TARGET_POWER_MIN;
+
+	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
+	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
+		IWL_DEBUG_INFO(priv, "Geography modes already initialized.\n");
+		set_bit(STATUS_GEO_CONFIGURED, &priv->status);
+		return 0;
+	}
+
+	channels = kcalloc(priv->channel_count,
+			   sizeof(struct ieee80211_channel), GFP_KERNEL);
+	if (!channels)
+		return -ENOMEM;
+
+	rates = kcalloc(IWL_RATE_COUNT_LEGACY, sizeof(struct ieee80211_rate),
+			GFP_KERNEL);
+	if (!rates) {
+		kfree(channels);
+		return -ENOMEM;
+	}
+
+	/* 5.2GHz channels start after the 2.4GHz channels */
+	sband = &priv->bands[IEEE80211_BAND_5GHZ];
+	sband->channels = &channels[ARRAY_SIZE(iwl_eeprom_band_1)];
+	/* just OFDM */
+	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
+	sband->n_bitrates = IWL_RATE_COUNT_LEGACY - IWL_FIRST_OFDM_RATE;
+
+	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
+		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
+					 IEEE80211_BAND_5GHZ);
+
+	sband = &priv->bands[IEEE80211_BAND_2GHZ];
+	sband->channels = channels;
+	/* OFDM & CCK */
+	sband->bitrates = rates;
+	sband->n_bitrates = IWL_RATE_COUNT_LEGACY;
+
+	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
+		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
+					 IEEE80211_BAND_2GHZ);
+
+	priv->ieee_channels = channels;
+	priv->ieee_rates = rates;
+
+	for (i = 0;  i < priv->channel_count; i++) {
+		ch = &priv->channel_info[i];
+
+		/* FIXME: might be removed if scan is OK */
+		if (!is_channel_valid(ch))
+			continue;
+
+		sband =  &priv->bands[ch->band];
+
+		geo_ch = &sband->channels[sband->n_channels++];
+
+		geo_ch->center_freq =
+			ieee80211_channel_to_frequency(ch->channel, ch->band);
+		geo_ch->max_power = ch->max_power_avg;
+		geo_ch->max_antenna_gain = 0xff;
+		geo_ch->hw_value = ch->channel;
+
+		if (is_channel_valid(ch)) {
+			if (!(ch->flags & EEPROM_CHANNEL_IBSS))
+				geo_ch->flags |= IEEE80211_CHAN_NO_IBSS;
+
+			if (!(ch->flags & EEPROM_CHANNEL_ACTIVE))
+				geo_ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+
+			if (ch->flags & EEPROM_CHANNEL_RADAR)
+				geo_ch->flags |= IEEE80211_CHAN_RADAR;
+
+			geo_ch->flags |= ch->ht40_extension_channel;
+
+			if (ch->max_power_avg > max_tx_power)
+				max_tx_power = ch->max_power_avg;
+		} else {
+			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
+		}
+
+		IWL_DEBUG_INFO(priv, "Channel %d Freq=%d[%sGHz] %s flag=0x%X\n",
+				ch->channel, geo_ch->center_freq,
+				is_channel_a_band(ch) ?  "5.2" : "2.4",
+				geo_ch->flags & IEEE80211_CHAN_DISABLED ?
+				"restricted" : "valid",
+				 geo_ch->flags);
+	}
+
+	priv->tx_power_device_lmt = max_tx_power;
+	priv->tx_power_user_lmt = max_tx_power;
+	priv->tx_power_next = max_tx_power;
+
+	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
+	     hw_params(priv).sku & EEPROM_SKU_CAP_BAND_52GHZ) {
+		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
+			"Please send your %s to maintainer.\n",
+			trans(priv)->hw_id_str);
+		hw_params(priv).sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
+	}
+
+	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
+		   priv->bands[IEEE80211_BAND_2GHZ].n_channels,
+		   priv->bands[IEEE80211_BAND_5GHZ].n_channels);
+
+	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
+
+	return 0;
+}
+
+/*
+ * iwl_free_geos - undo allocations in iwl_init_geos
+ */
+static void iwl_free_geos(struct iwl_priv *priv)
+{
+	kfree(priv->ieee_channels);
+	kfree(priv->ieee_rates);
+	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
+}
+
 static int iwl_init_drv(struct iwl_priv *priv)
 {
 	int ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0a9bc98..06bcf27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -44,189 +44,6 @@
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-#define MAX_BIT_RATE_40_MHZ 150 /* Mbps */
-#define MAX_BIT_RATE_20_MHZ 72 /* Mbps */
-static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
-			      struct ieee80211_sta_ht_cap *ht_info,
-			      enum ieee80211_band band)
-{
-	u16 max_bit_rate = 0;
-	u8 rx_chains_num = hw_params(priv).rx_chains_num;
-	u8 tx_chains_num = hw_params(priv).tx_chains_num;
-
-	ht_info->cap = 0;
-	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-
-	ht_info->ht_supported = true;
-
-	if (cfg(priv)->ht_params &&
-	    cfg(priv)->ht_params->ht_greenfield_support)
-		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
-	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
-	max_bit_rate = MAX_BIT_RATE_20_MHZ;
-	if (hw_params(priv).ht40_channel & BIT(band)) {
-		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-		ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
-		ht_info->mcs.rx_mask[4] = 0x01;
-		max_bit_rate = MAX_BIT_RATE_40_MHZ;
-	}
-
-	if (iwlagn_mod_params.amsdu_size_8K)
-		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
-
-	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
-	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
-
-	ht_info->mcs.rx_mask[0] = 0xFF;
-	if (rx_chains_num >= 2)
-		ht_info->mcs.rx_mask[1] = 0xFF;
-	if (rx_chains_num >= 3)
-		ht_info->mcs.rx_mask[2] = 0xFF;
-
-	/* Highest supported Rx data rate */
-	max_bit_rate *= rx_chains_num;
-	WARN_ON(max_bit_rate & ~IEEE80211_HT_MCS_RX_HIGHEST_MASK);
-	ht_info->mcs.rx_highest = cpu_to_le16(max_bit_rate);
-
-	/* Tx MCS capabilities */
-	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
-	if (tx_chains_num != rx_chains_num) {
-		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
-		ht_info->mcs.tx_params |= ((tx_chains_num - 1) <<
-				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
-	}
-}
-
-/**
- * iwl_init_geos - Initialize mac80211's geo/channel info based from eeprom
- */
-int iwl_init_geos(struct iwl_priv *priv)
-{
-	struct iwl_channel_info *ch;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *channels;
-	struct ieee80211_channel *geo_ch;
-	struct ieee80211_rate *rates;
-	int i = 0;
-	s8 max_tx_power = IWLAGN_TX_POWER_TARGET_POWER_MIN;
-
-	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
-	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
-		IWL_DEBUG_INFO(priv, "Geography modes already initialized.\n");
-		set_bit(STATUS_GEO_CONFIGURED, &priv->status);
-		return 0;
-	}
-
-	channels = kcalloc(priv->channel_count,
-			   sizeof(struct ieee80211_channel), GFP_KERNEL);
-	if (!channels)
-		return -ENOMEM;
-
-	rates = kcalloc(IWL_RATE_COUNT_LEGACY, sizeof(struct ieee80211_rate),
-			GFP_KERNEL);
-	if (!rates) {
-		kfree(channels);
-		return -ENOMEM;
-	}
-
-	/* 5.2GHz channels start after the 2.4GHz channels */
-	sband = &priv->bands[IEEE80211_BAND_5GHZ];
-	sband->channels = &channels[ARRAY_SIZE(iwl_eeprom_band_1)];
-	/* just OFDM */
-	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
-	sband->n_bitrates = IWL_RATE_COUNT_LEGACY - IWL_FIRST_OFDM_RATE;
-
-	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
-		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
-					 IEEE80211_BAND_5GHZ);
-
-	sband = &priv->bands[IEEE80211_BAND_2GHZ];
-	sband->channels = channels;
-	/* OFDM & CCK */
-	sband->bitrates = rates;
-	sband->n_bitrates = IWL_RATE_COUNT_LEGACY;
-
-	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
-		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
-					 IEEE80211_BAND_2GHZ);
-
-	priv->ieee_channels = channels;
-	priv->ieee_rates = rates;
-
-	for (i = 0;  i < priv->channel_count; i++) {
-		ch = &priv->channel_info[i];
-
-		/* FIXME: might be removed if scan is OK */
-		if (!is_channel_valid(ch))
-			continue;
-
-		sband =  &priv->bands[ch->band];
-
-		geo_ch = &sband->channels[sband->n_channels++];
-
-		geo_ch->center_freq =
-			ieee80211_channel_to_frequency(ch->channel, ch->band);
-		geo_ch->max_power = ch->max_power_avg;
-		geo_ch->max_antenna_gain = 0xff;
-		geo_ch->hw_value = ch->channel;
-
-		if (is_channel_valid(ch)) {
-			if (!(ch->flags & EEPROM_CHANNEL_IBSS))
-				geo_ch->flags |= IEEE80211_CHAN_NO_IBSS;
-
-			if (!(ch->flags & EEPROM_CHANNEL_ACTIVE))
-				geo_ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
-
-			if (ch->flags & EEPROM_CHANNEL_RADAR)
-				geo_ch->flags |= IEEE80211_CHAN_RADAR;
-
-			geo_ch->flags |= ch->ht40_extension_channel;
-
-			if (ch->max_power_avg > max_tx_power)
-				max_tx_power = ch->max_power_avg;
-		} else {
-			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
-		}
-
-		IWL_DEBUG_INFO(priv, "Channel %d Freq=%d[%sGHz] %s flag=0x%X\n",
-				ch->channel, geo_ch->center_freq,
-				is_channel_a_band(ch) ?  "5.2" : "2.4",
-				geo_ch->flags & IEEE80211_CHAN_DISABLED ?
-				"restricted" : "valid",
-				 geo_ch->flags);
-	}
-
-	priv->tx_power_device_lmt = max_tx_power;
-	priv->tx_power_user_lmt = max_tx_power;
-	priv->tx_power_next = max_tx_power;
-
-	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
-	     hw_params(priv).sku & EEPROM_SKU_CAP_BAND_52GHZ) {
-		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
-			"Please send your %s to maintainer.\n",
-			trans(priv)->hw_id_str);
-		hw_params(priv).sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
-	}
-
-	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
-		   priv->bands[IEEE80211_BAND_2GHZ].n_channels,
-		   priv->bands[IEEE80211_BAND_5GHZ].n_channels);
-
-	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
-
-	return 0;
-}
-
-/*
- * iwl_free_geos - undo allocations in iwl_init_geos
- */
-void iwl_free_geos(struct iwl_priv *priv)
-{
-	kfree(priv->ieee_channels);
-	kfree(priv->ieee_rates);
-	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
-}
-
 static bool iwl_is_channel_extension(struct iwl_priv *priv,
 				     enum ieee80211_band band,
 				     u16 channel, u8 extension_chan_offset)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 635eb68..8a7d6fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -204,13 +204,6 @@ u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval);
 __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 			   u32 addon, u32 beacon_interval);
 
-
-/*****************************************************
-*  GEOS
-******************************************************/
-int iwl_init_geos(struct iwl_priv *priv);
-void iwl_free_geos(struct iwl_priv *priv);
-
 extern void iwl_send_bt_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv,
 				       u8 flags, bool clear);
-- 
1.7.0.4

