Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58961 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbXKZOVv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 09:21:51 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 12/15] iwlwifi: 802.11n comply HT self configuration flow with mac80211 framework
Date: Mon, 26 Nov 2007 16:14:39 +0200
Message-Id: <11960864921410-git-send-email-ron.rindjunsky@intel.com> (sfid-20071126_143532_197230_6CD4BEC9)
In-Reply-To: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch conforms HW configuration changes according to new mac80211's
HT framework

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   40 +++---
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    6 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  186 +++++++--------------------
 3 files changed, 66 insertions(+), 166 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1cf50f6..ea130b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -87,8 +87,8 @@ static int is_fat_channel(__le32 rxon_flags)
 static u8 is_single_stream(struct iwl4965_priv *priv)
 {
 #ifdef CONFIG_IWL4965_HT
-	if (!priv->is_ht_enabled || !priv->current_assoc_ht.is_ht ||
-	    (priv->active_rate_ht[1] == 0) ||
+	if (!priv->current_ht_config.is_ht ||
+	    (priv->current_ht_config.supp_mcs_set[1] == 0) ||
 	    (priv->ps_mode == IWL_MIMO_PS_STATIC))
 		return 1;
 #else
@@ -4369,27 +4369,27 @@ static u8 iwl4965_is_channel_extension(struct iwl4965_priv *priv, int phymode,
 }
 
 static u8 iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
-				const struct sta_ht_info *ht_info)
+				struct ieee80211_ht_info *sta_ht_inf)
 {
+	struct iwl_ht_info *iwl_ht_conf = &priv->current_ht_config;
 
-	if (priv->channel_width != IWL_CHANNEL_WIDTH_40MHZ)
+	if ((!iwl_ht_conf->is_ht) ||
+	   (iwl_ht_conf->supported_chan_width != IWL_CHANNEL_WIDTH_40MHZ) ||
+	   (iwl_ht_conf->extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_AUTO))
 		return 0;
 
-	if (ht_info->supported_chan_width != IWL_CHANNEL_WIDTH_40MHZ)
-		return 0;
-
-	if (ht_info->extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_AUTO)
-		return 0;
+	if (sta_ht_inf) {
+		if ((!sta_ht_inf->ht_supported) ||
+		   (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
+			return 0;
+	}
 
-	/* no fat tx allowed on 2.4GHZ */
-	if (priv->phymode != MODE_IEEE80211A)
-		return 0;
 	return (iwl4965_is_channel_extension(priv, priv->phymode,
-					 ht_info->control_channel,
-					 ht_info->extension_chan_offset));
+					 iwl_ht_conf->control_channel,
+					 iwl_ht_conf->extension_chan_offset));
 }
 
-void iwl4965_set_rxon_ht(struct iwl4965_priv *priv, struct sta_ht_info *ht_info)
+void iwl4965_set_rxon_ht(struct iwl4965_priv *priv, struct iwl_ht_info *ht_info)
 {
 	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
 	u32 val;
@@ -4397,7 +4397,7 @@ void iwl4965_set_rxon_ht(struct iwl4965_priv *priv, struct sta_ht_info *ht_info)
 	if (!ht_info->is_ht)
 		return;
 
-	if (iwl4965_is_fat_tx_allowed(priv, ht_info))
+	if (iwl4965_is_fat_tx_allowed(priv, NULL))
 		rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED_MSK;
 	else
 		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED_MSK |
@@ -4427,20 +4427,18 @@ void iwl4965_set_rxon_ht(struct iwl4965_priv *priv, struct sta_ht_info *ht_info)
 		break;
 	}
 
-	val = ht_info->operating_mode;
+	val = ht_info->ht_protection;
 
 	rxon->flags |= cpu_to_le32(val << RXON_FLG_HT_OPERATING_MODE_POS);
 
-	priv->active_rate_ht[0] = ht_info->supp_rates[0];
-	priv->active_rate_ht[1] = ht_info->supp_rates[1];
 	iwl4965_set_rxon_chain(priv);
 
 	IWL_DEBUG_ASSOC("supported HT rate 0x%X %X "
 			"rxon flags 0x%X operation mode :0x%X "
 			"extension channel offset 0x%x "
 			"control chan %d\n",
-			priv->active_rate_ht[0], priv->active_rate_ht[1],
-			le32_to_cpu(rxon->flags), ht_info->operating_mode,
+			ht_info->supp_mcs_set[0], ht_info->supp_mcs_set[1],
+			le32_to_cpu(rxon->flags), ht_info->ht_protection,
 			ht_info->extension_chan_offset,
 			ht_info->control_channel);
 	return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 7cb5cbb..0200bdb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -729,7 +729,6 @@ extern int iwl4965_hw_channel_switch(struct iwl4965_priv *priv, u16 channel);
 extern int iwl4965_tx_queue_reclaim(struct iwl4965_priv *priv, int txq_id, int index);
 
 struct iwl4965_priv;
-struct sta_ht_info;
 
 /*
  * Forward declare iwl-4965.c functions for iwl-base.c
@@ -742,9 +741,6 @@ extern int iwl4965_tx_queue_update_wr_ptr(struct iwl4965_priv *priv,
 					  u16 byte_cnt);
 extern void iwl4965_add_station(struct iwl4965_priv *priv, const u8 *addr,
 				int is_ap);
-extern void iwl4965_set_rxon_ht(struct iwl4965_priv *priv,
-				struct sta_ht_info *ht_info);
-
 extern void iwl4965_set_rxon_chain(struct iwl4965_priv *priv);
 extern int iwl4965_tx_cmd(struct iwl4965_priv *priv, struct iwl4965_cmd *out_cmd,
 			  u8 sta_id, dma_addr_t txcmd_phys,
@@ -766,6 +762,8 @@ extern void iwl4965_rf_kill_ct_config(struct iwl4965_priv *priv);
 #ifdef CONFIG_IWL4965_HT
 extern void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
 					int mode);
+extern void iwl4965_set_rxon_ht(struct iwl4965_priv *priv,
+				struct iwl_ht_info *ht_info);
 #ifdef CONFIG_IWL4965_HT_AGG
 extern int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da,
 				   u16 tid, u16 *start_seq_num);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 6488703..5caeac4 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2056,7 +2056,7 @@ static void iwl4965_activate_qos(struct iwl4965_priv *priv, u8 force)
 			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
 
 #ifdef CONFIG_IWL4965_HT
-	if (priv->is_ht_enabled && priv->current_assoc_ht.is_ht)
+	if (priv->current_ht_config.is_ht)
 		priv->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
 #endif /* CONFIG_IWL4965_HT */
 
@@ -7125,13 +7125,8 @@ static void iwl4965_bg_post_associate(struct work_struct *data)
 	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
 #ifdef CONFIG_IWL4965_HT
-	if (priv->is_ht_enabled && priv->current_assoc_ht.is_ht)
-		iwl4965_set_rxon_ht(priv, &priv->current_assoc_ht);
-	else {
-		priv->active_rate_ht[0] = 0;
-		priv->active_rate_ht[1] = 0;
-		priv->current_channel_width = IWL_CHANNEL_WIDTH_20MHZ;
-	}
+	if (priv->current_ht_config.is_ht)
+		iwl4965_set_rxon_ht(priv, &priv->current_ht_config);
 #endif /* CONFIG_IWL4965_HT*/
 	iwl4965_set_rxon_chain(priv);
 	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
@@ -7893,7 +7888,7 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	priv->lq_mngr.lq_ready = 0;
 #ifdef CONFIG_IWL4965_HT
 	spin_lock_irqsave(&priv->lock, flags);
-	memset(&priv->current_assoc_ht, 0, sizeof(struct sta_ht_info));
+	memset(&priv->current_ht_config, 0, sizeof(struct iwl_ht_info));
 	spin_unlock_irqrestore(&priv->lock, flags);
 #ifdef CONFIG_IWL4965_HT_AGG
 /*	if (priv->lq_mngr.agg_ctrl.granted_ba)
@@ -8013,132 +8008,61 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 }
 
 #ifdef CONFIG_IWL4965_HT
-union ht_cap_info {
-	struct {
-		u16 advanced_coding_cap		:1;
-		u16 supported_chan_width_set	:1;
-		u16 mimo_power_save_mode	:2;
-		u16 green_field			:1;
-		u16 short_GI20			:1;
-		u16 short_GI40			:1;
-		u16 tx_stbc			:1;
-		u16 rx_stbc			:1;
-		u16 beam_forming		:1;
-		u16 delayed_ba			:1;
-		u16 maximal_amsdu_size		:1;
-		u16 cck_mode_at_40MHz		:1;
-		u16 psmp_support		:1;
-		u16 stbc_ctrl_frame_support	:1;
-		u16 sig_txop_protection_support	:1;
-	};
-	u16 val;
-} __attribute__ ((packed));
-
-union ht_param_info{
-	struct {
-		u8 max_rx_ampdu_factor	:2;
-		u8 mpdu_density		:3;
-		u8 reserved		:3;
-	};
-	u8 val;
-} __attribute__ ((packed));
-
-union ht_exra_param_info {
-	struct {
-		u8 ext_chan_offset		:2;
-		u8 tx_chan_width		:1;
-		u8 rifs_mode			:1;
-		u8 controlled_access_only	:1;
-		u8 service_interval_granularity	:3;
-	};
-	u8 val;
-} __attribute__ ((packed));
-
-union ht_operation_mode{
-	struct {
-		u16 op_mode	:2;
-		u16 non_GF	:1;
-		u16 reserved	:13;
-	};
-	u16 val;
-} __attribute__ ((packed));
 
-
-static int sta_ht_info_init(struct ieee80211_ht_capability *ht_cap,
-			    struct ieee80211_ht_additional_info *ht_extra,
-			    struct sta_ht_info *ht_info_ap,
-			    struct sta_ht_info *ht_info)
+static void iwl4965_ht_info_fill(struct ieee80211_conf *conf,
+				 struct iwl4965_priv *priv)
 {
-	union ht_cap_info cap;
-	union ht_operation_mode op_mode;
-	union ht_param_info param_info;
-	union ht_exra_param_info extra_param_info;
+	struct iwl_ht_info *iwl_conf = &priv->current_ht_config;
+	struct ieee80211_ht_info *ht_conf = &conf->ht_conf;
+	struct ieee80211_ht_bss_info *ht_bss_conf = &conf->ht_bss_conf;
 
 	IWL_DEBUG_MAC80211("enter: \n");
 
-	if (!ht_info) {
-		IWL_DEBUG_MAC80211("leave: ht_info is NULL\n");
-		return -1;
+	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE)) {
+		iwl_conf->is_ht = 0;
+		return;
 	}
 
-	if (ht_cap) {
-		cap.val = (u16) le16_to_cpu(ht_cap->capabilities_info);
-		param_info.val = ht_cap->mac_ht_params_info;
-		ht_info->is_ht = 1;
-		if (cap.short_GI20)
-			ht_info->sgf |= 0x1;
-		if (cap.short_GI40)
-			ht_info->sgf |= 0x2;
-		ht_info->is_green_field = cap.green_field;
-		ht_info->max_amsdu_size = cap.maximal_amsdu_size;
-		ht_info->supported_chan_width = cap.supported_chan_width_set;
-		ht_info->tx_mimo_ps_mode = cap.mimo_power_save_mode;
-		memcpy(ht_info->supp_rates, ht_cap->supported_mcs_set, 16);
-
-		ht_info->ampdu_factor = param_info.max_rx_ampdu_factor;
-		ht_info->mpdu_density = param_info.mpdu_density;
-
-		IWL_DEBUG_MAC80211("SISO mask 0x%X MIMO mask 0x%X \n",
-				    ht_cap->supported_mcs_set[0],
-				    ht_cap->supported_mcs_set[1]);
-
-		if (ht_info_ap) {
-			ht_info->control_channel = ht_info_ap->control_channel;
-			ht_info->extension_chan_offset =
-				ht_info_ap->extension_chan_offset;
-			ht_info->tx_chan_width = ht_info_ap->tx_chan_width;
-			ht_info->operating_mode = ht_info_ap->operating_mode;
-		}
-
-		if (ht_extra) {
-			extra_param_info.val = ht_extra->ht_param;
-			ht_info->control_channel = ht_extra->control_chan;
-			ht_info->extension_chan_offset =
-			    extra_param_info.ext_chan_offset;
-			ht_info->tx_chan_width = extra_param_info.tx_chan_width;
-			op_mode.val = (u16)
-			    le16_to_cpu(ht_extra->operation_mode);
-			ht_info->operating_mode = op_mode.op_mode;
-			IWL_DEBUG_MAC80211("control channel %d\n",
-					    ht_extra->control_chan);
-		}
-	} else
-		ht_info->is_ht = 0;
-
+	iwl_conf->is_ht = 1;
+	priv->ps_mode = (u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
+
+	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
+		iwl_conf->sgf |= 0x1;
+	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_40)
+		iwl_conf->sgf |= 0x2;
+
+	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
+	iwl_conf->max_amsdu_size =
+		!!(ht_conf->cap & IEEE80211_HT_CAP_MAX_AMSDU);
+	iwl_conf->supported_chan_width =
+		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH);
+	iwl_conf->tx_mimo_ps_mode =
+		(u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
+	memcpy(iwl_conf->supp_mcs_set, ht_conf->supp_mcs_set, 16);
+
+	iwl_conf->control_channel = ht_bss_conf->primary_channel;
+	iwl_conf->extension_chan_offset =
+		ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_SEC_OFFSET;
+	iwl_conf->tx_chan_width =
+		!!(ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_WIDTH);
+	iwl_conf->ht_protection =
+		ht_bss_conf->bss_op_mode & IEEE80211_HT_IE_HT_PROTECTION;
+	iwl_conf->non_GF_STA_present =
+		!!(ht_bss_conf->bss_op_mode & IEEE80211_HT_IE_NON_GF_STA_PRSNT);
+
+	IWL_DEBUG_MAC80211("control channel %d\n",
+		iwl_conf->control_channel);
 	IWL_DEBUG_MAC80211("leave\n");
-	return 0;
 }
 
 static int iwl4965_mac_conf_ht(struct ieee80211_hw *hw,
-			   struct ieee80211_ht_capability *ht_cap,
-			   struct ieee80211_ht_additional_info *ht_extra)
+			       struct ieee80211_conf *conf)
 {
 	struct iwl4965_priv *priv = hw->priv;
-	int rs;
 
 	IWL_DEBUG_MAC80211("enter: \n");
 
-	rs = sta_ht_info_init(ht_cap, ht_extra, NULL, &priv->current_assoc_ht);
+	iwl4965_ht_info_fill(conf, priv);
 	iwl4965_set_rxon_chain(priv);
 
 	if (priv && priv->assoc_id &&
@@ -8153,10 +8077,8 @@ static int iwl4965_mac_conf_ht(struct ieee80211_hw *hw,
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
-	IWL_DEBUG_MAC80211("leave: control channel %d\n",
-			ht_extra->control_chan);
-	return rs;
-
+	IWL_DEBUG_MAC80211("leave:\n");
+	return 0;
 }
 
 static void iwl4965_set_ht_capab(struct ieee80211_hw *hw,
@@ -8181,23 +8103,6 @@ static void iwl4965_set_ht_capab(struct ieee80211_hw *hw,
 					IEEE80211_HT_CAP_AMPDU_DENSITY);
 }
 
-static void iwl4965_mac_get_ht_capab(struct ieee80211_hw *hw,
-				 struct ieee80211_ht_capability *ht_cap)
-{
-	u8 use_wide_channel = 1;
-	struct iwl4965_priv *priv = hw->priv;
-
-	IWL_DEBUG_MAC80211("enter: \n");
-	if (priv->channel_width != IWL_CHANNEL_WIDTH_40MHZ)
-		use_wide_channel = 0;
-
-	/* no fat tx allowed on 2.4GHZ */
-	if (priv->phymode != MODE_IEEE80211A)
-		use_wide_channel = 0;
-
-	iwl4965_set_ht_capab(hw, ht_cap, use_wide_channel);
-	IWL_DEBUG_MAC80211("leave: \n");
-}
 #endif /*CONFIG_IWL4965_HT*/
 
 /*****************************************************************************
@@ -8914,7 +8819,6 @@ static struct ieee80211_ops iwl4965_hw_ops = {
 	.erp_ie_changed = iwl4965_mac_erp_ie_changed,
 #ifdef CONFIG_IWL4965_HT
 	.conf_ht = iwl4965_mac_conf_ht,
-	.get_ht_capab = iwl4965_mac_get_ht_capab,
 #ifdef CONFIG_IWL4965_HT_AGG
 	.ht_tx_agg_start = iwl4965_mac_ht_tx_agg_start,
 	.ht_tx_agg_stop = iwl4965_mac_ht_tx_agg_stop,
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
