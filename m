Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41783 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbYEECYV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:21 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 14/25] iwlwifi: move iwl4965_set_rxon_ht into iwlcore
Date: Mon,  5 May 2008 10:22:41 +0800
Message-Id: <1209954172-3092-15-git-send-email-yi.zhu@intel.com> (sfid-20080505_044418_110757_09380912)
In-Reply-To: <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves iwl4965_set_rxon_ht to iwlcore under name
iwl_set_rxon_ht. It also moves collateral changes
iwl_is_channel_extension and iwl_is_fat_tx_allowed.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   99 +-------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |  105 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 -
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 +-
 5 files changed, 111 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ff2ee82..3453e99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3716,103 +3716,6 @@ void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 
 #ifdef CONFIG_IWL4965_HT
 
-static u8 iwl4965_is_channel_extension(struct iwl_priv *priv,
-				       enum ieee80211_band band,
-				       u16 channel, u8 extension_chan_offset)
-{
-	const struct iwl_channel_info *ch_info;
-
-	ch_info = iwl_get_channel_info(priv, band, channel);
-	if (!is_channel_valid(ch_info))
-		return 0;
-
-	if (extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_NONE)
-		return 0;
-
-	if ((ch_info->fat_extension_channel == extension_chan_offset) ||
-	    (ch_info->fat_extension_channel == HT_IE_EXT_CHANNEL_MAX))
-		return 1;
-
-	return 0;
-}
-
-static u8 iwl4965_is_fat_tx_allowed(struct iwl_priv *priv,
-				struct ieee80211_ht_info *sta_ht_inf)
-{
-	struct iwl_ht_info *iwl_ht_conf = &priv->current_ht_config;
-
-	if ((!iwl_ht_conf->is_ht) ||
-	   (iwl_ht_conf->supported_chan_width != IWL_CHANNEL_WIDTH_40MHZ) ||
-	   (iwl_ht_conf->extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_NONE))
-		return 0;
-
-	if (sta_ht_inf) {
-		if ((!sta_ht_inf->ht_supported) ||
-		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
-			return 0;
-	}
-
-	return (iwl4965_is_channel_extension(priv, priv->band,
-					 iwl_ht_conf->control_channel,
-					 iwl_ht_conf->extension_chan_offset));
-}
-
-void iwl4965_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
-{
-	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
-	u32 val;
-
-	if (!ht_info->is_ht)
-		return;
-
-	/* Set up channel bandwidth:  20 MHz only, or 20/40 mixed if fat ok */
-	if (iwl4965_is_fat_tx_allowed(priv, NULL))
-		rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED_MSK;
-	else
-		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED_MSK |
-				 RXON_FLG_CHANNEL_MODE_PURE_40_MSK);
-
-	if (le16_to_cpu(rxon->channel) != ht_info->control_channel) {
-		IWL_ERROR("control diff than current %d %d\n",
-				le16_to_cpu(rxon->channel),
-				ht_info->control_channel);
-		WARN_ON(1);
-		return;
-	}
-
-	/* Note: control channel is opposite of extension channel */
-	switch (ht_info->extension_chan_offset) {
-	case IWL_EXT_CHANNEL_OFFSET_ABOVE:
-		rxon->flags &= ~(RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
-		break;
-	case IWL_EXT_CHANNEL_OFFSET_BELOW:
-		rxon->flags |= RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
-		break;
-	case IWL_EXT_CHANNEL_OFFSET_NONE:
-	default:
-		rxon->flags &= ~RXON_FLG_CHANNEL_MODE_MIXED_MSK;
-		break;
-	}
-
-	val = ht_info->ht_protection;
-
-	rxon->flags |= cpu_to_le32(val << RXON_FLG_HT_OPERATING_MODE_POS);
-
-	iwl_set_rxon_chain(priv);
-
-	IWL_DEBUG_ASSOC("supported HT rate 0x%X 0x%X 0x%X "
-			"rxon flags 0x%X operation mode :0x%X "
-			"extension channel offset 0x%x "
-			"control chan %d\n",
-			ht_info->supp_mcs_set[0],
-			ht_info->supp_mcs_set[1],
-			ht_info->supp_mcs_set[2],
-			le32_to_cpu(rxon->flags), ht_info->ht_protection,
-			ht_info->extension_chan_offset,
-			ht_info->control_channel);
-	return;
-}
-
 void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index,
 				struct ieee80211_ht_info *sta_ht_inf)
 {
@@ -3848,7 +3751,7 @@ void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index,
 	sta_flags |= cpu_to_le32(
 	      (u32)sta_ht_inf->ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
 
-	if (iwl4965_is_fat_tx_allowed(priv, sta_ht_inf))
+	if (iwl_is_fat_tx_allowed(priv, sta_ht_inf))
 		sta_flags |= STA_FLG_FAT_EN_MSK;
 	else
 		sta_flags &= ~STA_FLG_FAT_EN_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c4b5c1a..4bf140f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -259,6 +259,12 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 	if (priv->hw_params.tx_chains_num >= 3)
 		ht_info->supp_mcs_set[2] = 0xFF;
 }
+#else
+static inline void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
+					    struct ieee80211_ht_info *ht_info,
+					    enum ieee80211_band band)
+{
+}
 #endif /* CONFIG_IWL4965_HT */
 
 static void iwlcore_init_hw_rates(struct iwl_priv *priv,
@@ -428,6 +434,105 @@ static u8 is_single_rx_stream(struct iwl_priv *priv)
 		(priv->current_ht_config.supp_mcs_set[2] == 0)) ||
 	       priv->ps_mode == IWL_MIMO_PS_STATIC;
 }
+static u8 iwl_is_channel_extension(struct iwl_priv *priv,
+				   enum ieee80211_band band,
+				   u16 channel, u8 extension_chan_offset)
+{
+	const struct iwl_channel_info *ch_info;
+
+	ch_info = iwl_get_channel_info(priv, band, channel);
+	if (!is_channel_valid(ch_info))
+		return 0;
+
+	if (extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_NONE)
+		return 0;
+
+	if ((ch_info->fat_extension_channel == extension_chan_offset) ||
+	    (ch_info->fat_extension_channel == HT_IE_EXT_CHANNEL_MAX))
+		return 1;
+
+	return 0;
+}
+
+u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
+			     struct ieee80211_ht_info *sta_ht_inf)
+{
+	struct iwl_ht_info *iwl_ht_conf = &priv->current_ht_config;
+
+	if ((!iwl_ht_conf->is_ht) ||
+	   (iwl_ht_conf->supported_chan_width != IWL_CHANNEL_WIDTH_40MHZ) ||
+	   (iwl_ht_conf->extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_NONE))
+		return 0;
+
+	if (sta_ht_inf) {
+		if ((!sta_ht_inf->ht_supported) ||
+		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
+			return 0;
+	}
+
+	return iwl_is_channel_extension(priv, priv->band,
+					 iwl_ht_conf->control_channel,
+					 iwl_ht_conf->extension_chan_offset);
+}
+EXPORT_SYMBOL(iwl_is_fat_tx_allowed);
+
+void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
+{
+	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
+	u32 val;
+
+	if (!ht_info->is_ht)
+		return;
+
+	/* Set up channel bandwidth:  20 MHz only, or 20/40 mixed if fat ok */
+	if (iwl_is_fat_tx_allowed(priv, NULL))
+		rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED_MSK;
+	else
+		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED_MSK |
+				 RXON_FLG_CHANNEL_MODE_PURE_40_MSK);
+
+	if (le16_to_cpu(rxon->channel) != ht_info->control_channel) {
+		IWL_DEBUG_ASSOC("control diff than current %d %d\n",
+				le16_to_cpu(rxon->channel),
+				ht_info->control_channel);
+		rxon->channel = cpu_to_le16(ht_info->control_channel);
+		return;
+	}
+
+	/* Note: control channel is opposite of extension channel */
+	switch (ht_info->extension_chan_offset) {
+	case IWL_EXT_CHANNEL_OFFSET_ABOVE:
+		rxon->flags &= ~(RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
+		break;
+	case IWL_EXT_CHANNEL_OFFSET_BELOW:
+		rxon->flags |= RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
+		break;
+	case IWL_EXT_CHANNEL_OFFSET_NONE:
+	default:
+		rxon->flags &= ~RXON_FLG_CHANNEL_MODE_MIXED_MSK;
+		break;
+	}
+
+	val = ht_info->ht_protection;
+
+	rxon->flags |= cpu_to_le32(val << RXON_FLG_HT_OPERATING_MODE_POS);
+
+	iwl_set_rxon_chain(priv);
+
+	IWL_DEBUG_ASSOC("supported HT rate 0x%X 0x%X 0x%X "
+			"rxon flags 0x%X operation mode :0x%X "
+			"extension channel offset 0x%x "
+			"control chan %d\n",
+			ht_info->supp_mcs_set[0],
+			ht_info->supp_mcs_set[1],
+			ht_info->supp_mcs_set[2],
+			le32_to_cpu(rxon->flags), ht_info->ht_protection,
+			ht_info->extension_chan_offset,
+			ht_info->control_channel);
+	return;
+}
+EXPORT_SYMBOL(iwl_set_rxon_ht);
+
 #else
 static inline u8 is_single_rx_stream(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index df27ee6..1241806 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -173,6 +173,9 @@ int iwl_set_rxon_channel(struct iwl_priv *priv,
 				u16 channel);
 void iwlcore_free_geos(struct iwl_priv *priv);
 int iwl_setup(struct iwl_priv *priv);
+void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info);
+u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
+			 struct ieee80211_ht_info *sta_ht_inf);
 
 /*****************************************************
 * RX
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0a37ff4..23cae4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -454,7 +454,6 @@ union iwl4965_ht_rate_supp {
 	};
 };
 
-#ifdef CONFIG_IWL4965_HT
 #define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
 #define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
 #define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_2USEC
@@ -477,7 +476,6 @@ struct iwl_ht_info {
 	u8 ht_protection;
 	u8 non_GF_STA_present;
 };
-#endif				/*CONFIG_IWL4965_HT */
 
 union iwl4965_qos_capabity {
 	struct {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 8100384..349c8e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2783,9 +2783,9 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		     tx_resp->failure_frame);
 
 	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
+#ifdef CONFIG_IWL4965_HT
 	if (index != -1) {
 		int freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
-#ifdef CONFIG_IWL4965_HT
 		if (tid != MAX_TID_COUNT)
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 		if (iwl4965_queue_space(&txq->q) > txq->q.low_mark &&
@@ -2794,9 +2794,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			ieee80211_wake_queue(priv->hw, txq_id);
 		if (tid != MAX_TID_COUNT)
 			iwl4965_check_empty_hw_queue(priv, sta_id, tid, txq_id);
-#endif
 	}
-#ifdef CONFIG_IWL4965_HT
 	}
 #endif /* CONFIG_IWL4965_HT */
 
@@ -5125,7 +5123,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 
 #ifdef CONFIG_IWL4965_HT
 	if (priv->current_ht_config.is_ht)
-		iwl4965_set_rxon_ht(priv, &priv->current_ht_config);
+		iwl_set_rxon_ht(priv, &priv->current_ht_config);
 #endif /* CONFIG_IWL4965_HT*/
 	iwl_set_rxon_chain(priv);
 	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
-- 
1.5.3.6

