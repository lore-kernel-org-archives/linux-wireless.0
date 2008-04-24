Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbYDXAPR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 13/16] iwlwifi: unify init driver flow
Date: Wed, 23 Apr 2008 17:15:05 -0700
Message-Id: <1208996108-15326-14-git-send-email-reinette.chatre@intel.com> (sfid-20080424_023546_187883_DE30902D)
In-Reply-To: <1208996108-15326-13-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-6-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-7-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-8-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-9-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-10-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-11-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-12-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-13-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch does the following:
1 - moving init_drv from handler to regular function call
2 - move the init driver flow from iwl4965 to iwlcore, thus unify it to all
iwl family as a single flow
3 - move some general purpose functions from iwl4965 to iwlcore

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  245 +----------------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c     |  412 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    9 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  175 +-----------
 5 files changed, 421 insertions(+), 421 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2b21edb..93f4cdb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -55,44 +55,6 @@ static struct iwl_mod_params iwl4965_mod_params = {
 
 static void iwl4965_hw_card_show_info(struct iwl_priv *priv);
 
-#define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
-	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
-				    IWL_RATE_SISO_##s##M_PLCP, \
-				    IWL_RATE_MIMO2_##s##M_PLCP,\
-				    IWL_RATE_MIMO3_##s##M_PLCP,\
-				    IWL_RATE_##r##M_IEEE,      \
-				    IWL_RATE_##ip##M_INDEX,    \
-				    IWL_RATE_##in##M_INDEX,    \
-				    IWL_RATE_##rp##M_INDEX,    \
-				    IWL_RATE_##rn##M_INDEX,    \
-				    IWL_RATE_##pp##M_INDEX,    \
-				    IWL_RATE_##np##M_INDEX }
-
-/*
- * Parameter order:
- *   rate, ht rate, prev rate, next rate, prev tgg rate, next tgg rate
- *
- * If there isn't a valid next or previous rate then INV is used which
- * maps to IWL_RATE_INVALID
- *
- */
-const struct iwl4965_rate_info iwl4965_rates[IWL_RATE_COUNT] = {
-	IWL_DECLARE_RATE_INFO(1, INV, INV, 2, INV, 2, INV, 2),    /*  1mbps */
-	IWL_DECLARE_RATE_INFO(2, INV, 1, 5, 1, 5, 1, 5),          /*  2mbps */
-	IWL_DECLARE_RATE_INFO(5, INV, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
-	IWL_DECLARE_RATE_INFO(11, INV, 9, 12, 9, 12, 5, 18),      /* 11mbps */
-	IWL_DECLARE_RATE_INFO(6, 6, 5, 9, 5, 11, 5, 11),        /*  6mbps */
-	IWL_DECLARE_RATE_INFO(9, 6, 6, 11, 6, 11, 5, 11),       /*  9mbps */
-	IWL_DECLARE_RATE_INFO(12, 12, 11, 18, 11, 18, 11, 18),   /* 12mbps */
-	IWL_DECLARE_RATE_INFO(18, 18, 12, 24, 12, 24, 11, 24),   /* 18mbps */
-	IWL_DECLARE_RATE_INFO(24, 24, 18, 36, 18, 36, 18, 36),   /* 24mbps */
-	IWL_DECLARE_RATE_INFO(36, 36, 24, 48, 24, 48, 24, 48),   /* 36mbps */
-	IWL_DECLARE_RATE_INFO(48, 48, 36, 54, 36, 54, 36, 54),   /* 48mbps */
-	IWL_DECLARE_RATE_INFO(54, 54, 48, INV, 48, INV, 48, INV),/* 54mbps */
-	IWL_DECLARE_RATE_INFO(60, 60, 48, INV, 48, INV, 48, INV),/* 60mbps */
-	/* FIXME:RS:          ^^    should be INV (legacy) */
-};
-
 #ifdef CONFIG_IWL4965_HT
 
 static const u16 default_tid_to_tx_fifo[] = {
@@ -262,108 +224,12 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl4965_init_drv(struct iwl_priv *priv)
-{
-	int ret;
-	int i;
-
-	priv->retry_rate = 1;
-	priv->ibss_beacon = NULL;
-
-	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->power_data.lock);
-	spin_lock_init(&priv->sta_lock);
-	spin_lock_init(&priv->hcmd_lock);
-	spin_lock_init(&priv->lq_mngr.lock);
-
-	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++)
-		INIT_LIST_HEAD(&priv->ibss_mac_hash[i]);
-
-	INIT_LIST_HEAD(&priv->free_frames);
-
-	mutex_init(&priv->mutex);
-
-	/* Clear the driver's (not device's) station table */
-	iwlcore_clear_stations_table(priv);
-
-	priv->data_retry_limit = -1;
-	priv->ieee_channels = NULL;
-	priv->ieee_rates = NULL;
-	priv->band = IEEE80211_BAND_2GHZ;
-
-	priv->iw_mode = IEEE80211_IF_TYPE_STA;
-
-	priv->use_ant_b_for_management_frame = 1; /* start with ant B */
-	priv->ps_mode = IWL_MIMO_PS_NONE;
-
-	/* Choose which receivers/antennas to use */
-	iwl4965_set_rxon_chain(priv);
-
-	iwlcore_reset_qos(priv);
-
-	priv->qos_data.qos_active = 0;
-	priv->qos_data.qos_cap.val = 0;
-
-	iwlcore_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
-
-	priv->rates_mask = IWL_RATES_MASK;
-	/* If power management is turned on, default to AC mode */
-	priv->power_mode = IWL_POWER_AC;
-	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
-
-	ret = iwl_init_channel_map(priv);
-	if (ret) {
-		IWL_ERROR("initializing regulatory failed: %d\n", ret);
-		goto err;
-	}
-
-	ret = iwl4965_init_geos(priv);
-	if (ret) {
-		IWL_ERROR("initializing geos failed: %d\n", ret);
-		goto err_free_channel_map;
-	}
-
-	ret = ieee80211_register_hw(priv->hw);
-	if (ret) {
-		IWL_ERROR("Failed to register network device (error %d)\n",
-				ret);
-		goto err_free_geos;
-	}
-
-	priv->hw->conf.beacon_int = 100;
-	priv->mac80211_registered = 1;
-
-	return 0;
-
-err_free_geos:
-	iwl4965_free_geos(priv);
-err_free_channel_map:
-	iwl_free_channel_map(priv);
-err:
-	return ret;
-}
-
 static int is_fat_channel(__le32 rxon_flags)
 {
 	return (rxon_flags & RXON_FLG_CHANNEL_MODE_PURE_40_MSK) ||
 		(rxon_flags & RXON_FLG_CHANNEL_MODE_MIXED_MSK);
 }
 
-#ifdef CONFIG_IWL4965_HT
-static u8 is_single_rx_stream(struct iwl_priv *priv)
-{
-	return !priv->current_ht_config.is_ht ||
-	       ((priv->current_ht_config.supp_mcs_set[1] == 0) &&
-		(priv->current_ht_config.supp_mcs_set[2] == 0)) ||
-	       priv->ps_mode == IWL_MIMO_PS_STATIC;
-}
-#else
-static inline u8 is_single_rx_stream(struct iwl_priv *priv)
-{
-	return 1;
-}
-#endif	/*CONFIG_IWL4965_HT */
-
 int iwl4965_hwrate_to_plcp_idx(u32 rate_n_flags)
 {
 	int idx = 0;
@@ -422,41 +288,6 @@ void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 			&priv->bands[IEEE80211_BAND_2GHZ].bitrates[rate_index];
 }
 
-/*
- * Determine how many receiver/antenna chains to use.
- * More provides better reception via diversity.  Fewer saves power.
- * MIMO (dual stream) requires at least 2, but works better with 3.
- * This does not determine *which* chains to use, just how many.
- */
-static int iwl4965_get_rx_chain_counter(struct iwl_priv *priv,
-					u8 *idle_state, u8 *rx_state)
-{
-	u8 is_single = is_single_rx_stream(priv);
-	u8 is_cam = test_bit(STATUS_POWER_PMI, &priv->status) ? 0 : 1;
-
-	/* # of Rx chains to use when expecting MIMO. */
-	if (is_single || (!is_cam && (priv->ps_mode == IWL_MIMO_PS_STATIC)))
-		*rx_state = 2;
-	else
-		*rx_state = 3;
-
-	/* # Rx chains when idling and maybe trying to save power */
-	switch (priv->ps_mode) {
-	case IWL_MIMO_PS_STATIC:
-	case IWL_MIMO_PS_DYNAMIC:
-		*idle_state = (is_cam) ? 2 : 1;
-		break;
-	case IWL_MIMO_PS_NONE:
-		*idle_state = (is_cam) ? *rx_state : 1;
-		break;
-	default:
-		*idle_state = 1;
-		break;
-	}
-
-	return 0;
-}
-
 int iwl4965_hw_rxq_stop(struct iwl_priv *priv)
 {
 	int rc;
@@ -2527,44 +2358,6 @@ static void iwl4965_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 }
 
 /**
- * iwl4965_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
- *
- * Selects how many and which Rx receivers/antennas/chains to use.
- * This should not be used for scan command ... it puts data in wrong place.
- */
-void iwl4965_set_rxon_chain(struct iwl_priv *priv)
-{
-	u8 is_single = is_single_rx_stream(priv);
-	u8 idle_state, rx_state;
-
-	priv->staging_rxon.rx_chain = 0;
-	rx_state = idle_state = 3;
-
-	/* Tell uCode which antennas are actually connected.
-	 * Before first association, we assume all antennas are connected.
-	 * Just after first association, iwl_chain_noise_calibration()
-	 *    checks which antennas actually *are* connected. */
-	priv->staging_rxon.rx_chain |=
-		    cpu_to_le16(priv->hw_params.valid_rx_ant <<
-						 RXON_RX_CHAIN_VALID_POS);
-
-	/* How many receivers should we use? */
-	iwl4965_get_rx_chain_counter(priv, &idle_state, &rx_state);
-	priv->staging_rxon.rx_chain |=
-		cpu_to_le16(rx_state << RXON_RX_CHAIN_MIMO_CNT_POS);
-	priv->staging_rxon.rx_chain |=
-		cpu_to_le16(idle_state << RXON_RX_CHAIN_CNT_POS);
-
-	if (!is_single && (rx_state >= 2) &&
-	    !test_bit(STATUS_POWER_PMI, &priv->status))
-		priv->staging_rxon.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
-	else
-		priv->staging_rxon.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
-
-	IWL_DEBUG_ASSOC("rx chain %X\n", priv->staging_rxon.rx_chain);
-}
-
-/**
  * sign_extend - Sign extend a value using specified bit as sign-bit
  *
  * Example: sign_extend(9, 3) would return -7 as bit3 of 1001b is 1
@@ -3127,41 +2920,6 @@ static int iwl4965_calc_rssi(struct iwl4965_rx_phy_res *rx_resp)
 	return (max_rssi - agc - IWL_RSSI_OFFSET);
 }
 
-#ifdef CONFIG_IWL4965_HT
-
-void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
-			      struct ieee80211_ht_info *ht_info,
-			      enum ieee80211_band band)
-{
-	ht_info->cap = 0;
-	memset(ht_info->supp_mcs_set, 0, 16);
-
-	ht_info->ht_supported = 1;
-
-	if (priv->hw_params.fat_channel & BIT(band)) {
-		ht_info->cap |= (u16)IEEE80211_HT_CAP_SUP_WIDTH;
-		ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_40;
-		ht_info->supp_mcs_set[4] = 0x01;
-	}
-	ht_info->cap |= (u16)IEEE80211_HT_CAP_GRN_FLD;
-	ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_20;
-	ht_info->cap |= (u16)(IEEE80211_HT_CAP_MIMO_PS &
-			     (IWL_MIMO_PS_NONE << 2));
-
-	if (priv->cfg->mod_params->amsdu_size_8K)
-		ht_info->cap |= (u16)IEEE80211_HT_CAP_MAX_AMSDU;
-
-	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
-	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
-
-	ht_info->supp_mcs_set[0] = 0xFF;
-	if (priv->hw_params.tx_chains_num >= 2)
-		ht_info->supp_mcs_set[1] = 0xFF;
-	if (priv->hw_params.tx_chains_num >= 3)
-		ht_info->supp_mcs_set[2] = 0xFF;
-}
-#endif /* CONFIG_IWL4965_HT */
-
 static void iwl4965_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 {
 	unsigned long flags;
@@ -4039,7 +3797,7 @@ void iwl4965_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 
 	rxon->flags |= cpu_to_le32(val << RXON_FLG_HT_OPERATING_MODE_POS);
 
-	iwl4965_set_rxon_chain(priv);
+	iwl_set_rxon_chain(priv);
 
 	IWL_DEBUG_ASSOC("supported HT rate 0x%X 0x%X 0x%X "
 			"rxon flags 0x%X operation mode :0x%X "
@@ -4356,7 +4114,6 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 };
 
 static struct iwl_lib_ops iwl4965_lib = {
-	.init_drv = iwl4965_init_drv,
 	.set_hw_params = iwl4965_hw_set_hw_params,
 	.alloc_shared_mem = iwl4965_alloc_shared_mem,
 	.free_shared_mem = iwl4965_free_shared_mem,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index e357263..3b73064 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -748,7 +748,6 @@ extern int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
 					  u16 byte_cnt);
 extern void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr,
 				int is_ap);
-extern void iwl4965_set_rxon_chain(struct iwl_priv *priv);
 extern int iwl4965_alive_notify(struct iwl_priv *priv);
 extern void iwl4965_update_rate_scaling(struct iwl_priv *priv, u8 mode);
 extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 68de1a4..ca32fb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -51,6 +51,45 @@ u32 iwl_debug_level;
 EXPORT_SYMBOL(iwl_debug_level);
 #endif
 
+#define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
+	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
+				    IWL_RATE_SISO_##s##M_PLCP, \
+				    IWL_RATE_MIMO2_##s##M_PLCP,\
+				    IWL_RATE_MIMO3_##s##M_PLCP,\
+				    IWL_RATE_##r##M_IEEE,      \
+				    IWL_RATE_##ip##M_INDEX,    \
+				    IWL_RATE_##in##M_INDEX,    \
+				    IWL_RATE_##rp##M_INDEX,    \
+				    IWL_RATE_##rn##M_INDEX,    \
+				    IWL_RATE_##pp##M_INDEX,    \
+				    IWL_RATE_##np##M_INDEX }
+
+/*
+ * Parameter order:
+ *   rate, ht rate, prev rate, next rate, prev tgg rate, next tgg rate
+ *
+ * If there isn't a valid next or previous rate then INV is used which
+ * maps to IWL_RATE_INVALID
+ *
+ */
+const struct iwl4965_rate_info iwl4965_rates[IWL_RATE_COUNT] = {
+	IWL_DECLARE_RATE_INFO(1, INV, INV, 2, INV, 2, INV, 2),    /*  1mbps */
+	IWL_DECLARE_RATE_INFO(2, INV, 1, 5, 1, 5, 1, 5),          /*  2mbps */
+	IWL_DECLARE_RATE_INFO(5, INV, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
+	IWL_DECLARE_RATE_INFO(11, INV, 9, 12, 9, 12, 5, 18),      /* 11mbps */
+	IWL_DECLARE_RATE_INFO(6, 6, 5, 9, 5, 11, 5, 11),        /*  6mbps */
+	IWL_DECLARE_RATE_INFO(9, 6, 6, 11, 6, 11, 5, 11),       /*  9mbps */
+	IWL_DECLARE_RATE_INFO(12, 12, 11, 18, 11, 18, 11, 18),   /* 12mbps */
+	IWL_DECLARE_RATE_INFO(18, 18, 12, 24, 12, 24, 11, 24),   /* 18mbps */
+	IWL_DECLARE_RATE_INFO(24, 24, 18, 36, 18, 36, 18, 36),   /* 24mbps */
+	IWL_DECLARE_RATE_INFO(36, 36, 24, 48, 24, 48, 24, 48),   /* 36mbps */
+	IWL_DECLARE_RATE_INFO(48, 48, 36, 54, 36, 54, 36, 54),   /* 48mbps */
+	IWL_DECLARE_RATE_INFO(54, 54, 48, INV, 48, INV, 48, INV),/* 54mbps */
+	IWL_DECLARE_RATE_INFO(60, 60, 48, INV, 48, INV, 48, INV),/* 60mbps */
+	/* FIXME:RS:          ^^    should be INV (legacy) */
+};
+EXPORT_SYMBOL(iwl4965_rates);
+
 /* This function both allocates and initializes hw and priv. */
 struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 		struct ieee80211_ops *hw_ops)
@@ -100,7 +139,7 @@ void iwlcore_clear_stations_table(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwlcore_clear_stations_table);
 
-void iwlcore_reset_qos(struct iwl_priv *priv)
+void iwl_reset_qos(struct iwl_priv *priv)
 {
 	u16 cw_min = 15;
 	u16 cw_max = 1023;
@@ -186,7 +225,289 @@ void iwlcore_reset_qos(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
-EXPORT_SYMBOL(iwlcore_reset_qos);
+EXPORT_SYMBOL(iwl_reset_qos);
+
+#ifdef CONFIG_IWL4965_HT
+static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
+			      struct ieee80211_ht_info *ht_info,
+			      enum ieee80211_band band)
+{
+	ht_info->cap = 0;
+	memset(ht_info->supp_mcs_set, 0, 16);
+
+	ht_info->ht_supported = 1;
+
+	if (priv->hw_params.fat_channel & BIT(band)) {
+		ht_info->cap |= (u16)IEEE80211_HT_CAP_SUP_WIDTH;
+		ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_40;
+		ht_info->supp_mcs_set[4] = 0x01;
+	}
+	ht_info->cap |= (u16)IEEE80211_HT_CAP_GRN_FLD;
+	ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_20;
+	ht_info->cap |= (u16)(IEEE80211_HT_CAP_MIMO_PS &
+			     (IWL_MIMO_PS_NONE << 2));
+
+	if (priv->cfg->mod_params->amsdu_size_8K)
+		ht_info->cap |= (u16)IEEE80211_HT_CAP_MAX_AMSDU;
+
+	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
+	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
+
+	ht_info->supp_mcs_set[0] = 0xFF;
+	if (priv->hw_params.tx_chains_num >= 2)
+		ht_info->supp_mcs_set[1] = 0xFF;
+	if (priv->hw_params.tx_chains_num >= 3)
+		ht_info->supp_mcs_set[2] = 0xFF;
+}
+#endif /* CONFIG_IWL4965_HT */
+
+static void iwlcore_init_hw_rates(struct iwl_priv *priv,
+			      struct ieee80211_rate *rates)
+{
+	int i;
+
+	for (i = 0; i < IWL_RATE_COUNT; i++) {
+		rates[i].bitrate = iwl4965_rates[i].ieee * 5;
+		rates[i].hw_value = i; /* Rate scaling will work on indexes */
+		rates[i].hw_value_short = i;
+		rates[i].flags = 0;
+		if ((i > IWL_LAST_OFDM_RATE) || (i < IWL_FIRST_OFDM_RATE)) {
+			/*
+			 * If CCK != 1M then set short preamble rate flag.
+			 */
+			rates[i].flags |=
+				(iwl4965_rates[i].plcp == IWL_RATE_1M_PLCP) ?
+					0 : IEEE80211_RATE_SHORT_PREAMBLE;
+		}
+	}
+}
+
+/**
+ * iwlcore_init_geos - Initialize mac80211's geo/channel info based from eeprom
+ */
+static int iwlcore_init_geos(struct iwl_priv *priv)
+{
+	struct iwl_channel_info *ch;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *channels;
+	struct ieee80211_channel *geo_ch;
+	struct ieee80211_rate *rates;
+	int i = 0;
+
+	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
+	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
+		IWL_DEBUG_INFO("Geography modes already initialized.\n");
+		set_bit(STATUS_GEO_CONFIGURED, &priv->status);
+		return 0;
+	}
+
+	channels = kzalloc(sizeof(struct ieee80211_channel) *
+			   priv->channel_count, GFP_KERNEL);
+	if (!channels)
+		return -ENOMEM;
+
+	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_RATE_COUNT + 1)),
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
+	sband->n_bitrates = IWL_RATE_COUNT - IWL_FIRST_OFDM_RATE;
+
+	iwlcore_init_ht_hw_capab(priv, &sband->ht_info, IEEE80211_BAND_5GHZ);
+
+	sband = &priv->bands[IEEE80211_BAND_2GHZ];
+	sband->channels = channels;
+	/* OFDM & CCK */
+	sband->bitrates = rates;
+	sband->n_bitrates = IWL_RATE_COUNT;
+
+	iwlcore_init_ht_hw_capab(priv, &sband->ht_info, IEEE80211_BAND_2GHZ);
+
+	priv->ieee_channels = channels;
+	priv->ieee_rates = rates;
+
+	iwlcore_init_hw_rates(priv, rates);
+
+	for (i = 0;  i < priv->channel_count; i++) {
+		ch = &priv->channel_info[i];
+
+		/* FIXME: might be removed if scan is OK */
+		if (!is_channel_valid(ch))
+			continue;
+
+		if (is_channel_a_band(ch))
+			sband =  &priv->bands[IEEE80211_BAND_5GHZ];
+		else
+			sband =  &priv->bands[IEEE80211_BAND_2GHZ];
+
+		geo_ch = &sband->channels[sband->n_channels++];
+
+		geo_ch->center_freq =
+				ieee80211_channel_to_frequency(ch->channel);
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
+			if (ch->max_power_avg > priv->max_channel_txpower_limit)
+				priv->max_channel_txpower_limit =
+				    ch->max_power_avg;
+		} else {
+			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
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
+	}
+
+	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
+	     priv->cfg->sku & IWL_SKU_A) {
+		printk(KERN_INFO DRV_NAME
+		       ": Incorrectly detected BG card as ABG.  Please send "
+		       "your PCI ID 0x%04X:0x%04X to maintainer.\n",
+		       priv->pci_dev->device, priv->pci_dev->subsystem_device);
+		priv->cfg->sku &= ~IWL_SKU_A;
+	}
+
+	printk(KERN_INFO DRV_NAME
+	       ": Tunable channels: %d 802.11bg, %d 802.11a channels\n",
+	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
+	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);
+
+	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
+		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+			&priv->bands[IEEE80211_BAND_2GHZ];
+	if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
+		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+			&priv->bands[IEEE80211_BAND_5GHZ];
+
+	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
+
+	return 0;
+}
+
+/*
+ * iwlcore_free_geos - undo allocations in iwlcore_init_geos
+ */
+void iwlcore_free_geos(struct iwl_priv *priv)
+{
+	kfree(priv->ieee_channels);
+	kfree(priv->ieee_rates);
+	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
+}
+EXPORT_SYMBOL(iwlcore_free_geos);
+
+#ifdef CONFIG_IWL4965_HT
+static u8 is_single_rx_stream(struct iwl_priv *priv)
+{
+	return !priv->current_ht_config.is_ht ||
+	       ((priv->current_ht_config.supp_mcs_set[1] == 0) &&
+		(priv->current_ht_config.supp_mcs_set[2] == 0)) ||
+	       priv->ps_mode == IWL_MIMO_PS_STATIC;
+}
+#else
+static inline u8 is_single_rx_stream(struct iwl_priv *priv)
+{
+	return 1;
+}
+#endif	/*CONFIG_IWL4965_HT */
+
+/*
+ * Determine how many receiver/antenna chains to use.
+ * More provides better reception via diversity.  Fewer saves power.
+ * MIMO (dual stream) requires at least 2, but works better with 3.
+ * This does not determine *which* chains to use, just how many.
+ */
+static int iwlcore_get_rx_chain_counter(struct iwl_priv *priv,
+					u8 *idle_state, u8 *rx_state)
+{
+	u8 is_single = is_single_rx_stream(priv);
+	u8 is_cam = test_bit(STATUS_POWER_PMI, &priv->status) ? 0 : 1;
+
+	/* # of Rx chains to use when expecting MIMO. */
+	if (is_single || (!is_cam && (priv->ps_mode == IWL_MIMO_PS_STATIC)))
+		*rx_state = 2;
+	else
+		*rx_state = 3;
+
+	/* # Rx chains when idling and maybe trying to save power */
+	switch (priv->ps_mode) {
+	case IWL_MIMO_PS_STATIC:
+	case IWL_MIMO_PS_DYNAMIC:
+		*idle_state = (is_cam) ? 2 : 1;
+		break;
+	case IWL_MIMO_PS_NONE:
+		*idle_state = (is_cam) ? *rx_state : 1;
+		break;
+	default:
+		*idle_state = 1;
+		break;
+	}
+
+	return 0;
+}
+
+/**
+ * iwl_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
+ *
+ * Selects how many and which Rx receivers/antennas/chains to use.
+ * This should not be used for scan command ... it puts data in wrong place.
+ */
+void iwl_set_rxon_chain(struct iwl_priv *priv)
+{
+	u8 is_single = is_single_rx_stream(priv);
+	u8 idle_state, rx_state;
+
+	priv->staging_rxon.rx_chain = 0;
+	rx_state = idle_state = 3;
+
+	/* Tell uCode which antennas are actually connected.
+	 * Before first association, we assume all antennas are connected.
+	 * Just after first association, iwl_chain_noise_calibration()
+	 *    checks which antennas actually *are* connected. */
+	priv->staging_rxon.rx_chain |=
+		    cpu_to_le16(priv->hw_params.valid_rx_ant <<
+						 RXON_RX_CHAIN_VALID_POS);
+
+	/* How many receivers should we use? */
+	iwlcore_get_rx_chain_counter(priv, &idle_state, &rx_state);
+	priv->staging_rxon.rx_chain |=
+		cpu_to_le16(rx_state << RXON_RX_CHAIN_MIMO_CNT_POS);
+	priv->staging_rxon.rx_chain |=
+		cpu_to_le16(idle_state << RXON_RX_CHAIN_CNT_POS);
+
+	if (!is_single && (rx_state >= 2) &&
+	    !test_bit(STATUS_POWER_PMI, &priv->status))
+		priv->staging_rxon.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
+	else
+		priv->staging_rxon.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
+
+	IWL_DEBUG_ASSOC("rx chain %X\n", priv->staging_rxon.rx_chain);
+}
+EXPORT_SYMBOL(iwl_set_rxon_chain);
 
 /**
  * iwlcore_set_rxon_channel - Set the phymode and channel values in staging RXON
@@ -198,7 +519,7 @@ EXPORT_SYMBOL(iwlcore_reset_qos);
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
  * in the staging RXON flag structure based on the phymode
  */
-int iwlcore_set_rxon_channel(struct iwl_priv *priv,
+int iwl_set_rxon_channel(struct iwl_priv *priv,
 				enum ieee80211_band band,
 				u16 channel)
 {
@@ -224,7 +545,7 @@ int iwlcore_set_rxon_channel(struct iwl_priv *priv,
 
 	return 0;
 }
-EXPORT_SYMBOL(iwlcore_set_rxon_channel);
+EXPORT_SYMBOL(iwl_set_rxon_channel);
 
 static void iwlcore_init_hw(struct iwl_priv *priv)
 {
@@ -251,11 +572,92 @@ static void iwlcore_init_hw(struct iwl_priv *priv)
 #endif /* CONFIG_IWL4965_HT */
 }
 
+static int iwlcore_init_drv(struct iwl_priv *priv)
+{
+	int ret;
+	int i;
+
+	priv->retry_rate = 1;
+	priv->ibss_beacon = NULL;
+
+	spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->power_data.lock);
+	spin_lock_init(&priv->sta_lock);
+	spin_lock_init(&priv->hcmd_lock);
+	spin_lock_init(&priv->lq_mngr.lock);
+
+	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++)
+		INIT_LIST_HEAD(&priv->ibss_mac_hash[i]);
+
+	INIT_LIST_HEAD(&priv->free_frames);
+
+	mutex_init(&priv->mutex);
+
+	/* Clear the driver's (not device's) station table */
+	iwlcore_clear_stations_table(priv);
+
+	priv->data_retry_limit = -1;
+	priv->ieee_channels = NULL;
+	priv->ieee_rates = NULL;
+	priv->band = IEEE80211_BAND_2GHZ;
+
+	priv->iw_mode = IEEE80211_IF_TYPE_STA;
+
+	priv->use_ant_b_for_management_frame = 1; /* start with ant B */
+	priv->ps_mode = IWL_MIMO_PS_NONE;
+
+	/* Choose which receivers/antennas to use */
+	iwl_set_rxon_chain(priv);
+
+	iwl_reset_qos(priv);
+
+	priv->qos_data.qos_active = 0;
+	priv->qos_data.qos_cap.val = 0;
+
+	iwl_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
+
+	priv->rates_mask = IWL_RATES_MASK;
+	/* If power management is turned on, default to AC mode */
+	priv->power_mode = IWL_POWER_AC;
+	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
+
+	ret = iwl_init_channel_map(priv);
+	if (ret) {
+		IWL_ERROR("initializing regulatory failed: %d\n", ret);
+		goto err;
+	}
+
+	ret = iwlcore_init_geos(priv);
+	if (ret) {
+		IWL_ERROR("initializing geos failed: %d\n", ret);
+		goto err_free_channel_map;
+	}
+
+	ret = ieee80211_register_hw(priv->hw);
+	if (ret) {
+		IWL_ERROR("Failed to register network device (error %d)\n",
+				ret);
+		goto err_free_geos;
+	}
+
+	priv->hw->conf.beacon_int = 100;
+	priv->mac80211_registered = 1;
+
+	return 0;
+
+err_free_geos:
+	iwlcore_free_geos(priv);
+err_free_channel_map:
+	iwl_free_channel_map(priv);
+err:
+	return ret;
+}
+
 int iwl_setup(struct iwl_priv *priv)
 {
 	int ret = 0;
 	iwlcore_init_hw(priv);
-	ret = priv->cfg->ops->lib->init_drv(priv);
+	ret = iwlcore_init_drv(priv);
 	return ret;
 }
 EXPORT_SYMBOL(iwl_setup);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e94aea3..e18940d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -97,8 +97,6 @@ struct iwl_hcmd_utils_ops {
 };
 
 struct iwl_lib_ops {
-	/* iwlwifi driver (priv) init */
-	int (*init_drv)(struct iwl_priv *priv);
 	/* set hw dependant perameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
 	/* ucode shared memory */
@@ -164,11 +162,12 @@ struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 void iwl_hw_detect(struct iwl_priv *priv);
 
 void iwlcore_clear_stations_table(struct iwl_priv *priv);
-void iwlcore_reset_qos(struct iwl_priv *priv);
-int iwlcore_set_rxon_channel(struct iwl_priv *priv,
+void iwl_reset_qos(struct iwl_priv *priv);
+void iwl_set_rxon_chain(struct iwl_priv *priv);
+int iwl_set_rxon_channel(struct iwl_priv *priv,
 				enum ieee80211_band band,
 				u16 channel);
-
+void iwlcore_free_geos(struct iwl_priv *priv);
 int iwl_setup(struct iwl_priv *priv);
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9b137d8..730d57c 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -882,7 +882,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 void iwl4965_update_chain_flags(struct iwl_priv *priv)
 {
 
-	iwl4965_set_rxon_chain(priv);
+	iwl_set_rxon_chain(priv);
 	iwl4965_commit_rxon(priv);
 }
 
@@ -1735,7 +1735,7 @@ static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
 	memcpy(priv->staging_rxon.wlap_bssid_addr, priv->mac_addr, ETH_ALEN);
 	priv->staging_rxon.ofdm_ht_single_stream_basic_rates = 0xff;
 	priv->staging_rxon.ofdm_ht_dual_stream_basic_rates = 0xff;
-	iwl4965_set_rxon_chain(priv);
+	iwl_set_rxon_chain(priv);
 }
 
 static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
@@ -4496,163 +4496,6 @@ static int iwl4965_get_channels_for_scan(struct iwl_priv *priv,
 	return added;
 }
 
-static void iwl4965_init_hw_rates(struct iwl_priv *priv,
-			      struct ieee80211_rate *rates)
-{
-	int i;
-
-	for (i = 0; i < IWL_RATE_COUNT; i++) {
-		rates[i].bitrate = iwl4965_rates[i].ieee * 5;
-		rates[i].hw_value = i; /* Rate scaling will work on indexes */
-		rates[i].hw_value_short = i;
-		rates[i].flags = 0;
-		if ((i > IWL_LAST_OFDM_RATE) || (i < IWL_FIRST_OFDM_RATE)) {
-			/*
-			 * If CCK != 1M then set short preamble rate flag.
-			 */
-			rates[i].flags |=
-				(iwl4965_rates[i].plcp == IWL_RATE_1M_PLCP) ?
-					0 : IEEE80211_RATE_SHORT_PREAMBLE;
-		}
-	}
-}
-
-/**
- * iwl4965_init_geos - Initialize mac80211's geo/channel info based from eeprom
- */
-int iwl4965_init_geos(struct iwl_priv *priv)
-{
-	struct iwl_channel_info *ch;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *channels;
-	struct ieee80211_channel *geo_ch;
-	struct ieee80211_rate *rates;
-	int i = 0;
-
-	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
-	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
-		IWL_DEBUG_INFO("Geography modes already initialized.\n");
-		set_bit(STATUS_GEO_CONFIGURED, &priv->status);
-		return 0;
-	}
-
-	channels = kzalloc(sizeof(struct ieee80211_channel) *
-			   priv->channel_count, GFP_KERNEL);
-	if (!channels)
-		return -ENOMEM;
-
-	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_RATE_COUNT + 1)),
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
-	sband->n_bitrates = IWL_RATE_COUNT - IWL_FIRST_OFDM_RATE;
-
-	iwl4965_init_ht_hw_capab(priv, &sband->ht_info, IEEE80211_BAND_5GHZ);
-
-	sband = &priv->bands[IEEE80211_BAND_2GHZ];
-	sband->channels = channels;
-	/* OFDM & CCK */
-	sband->bitrates = rates;
-	sband->n_bitrates = IWL_RATE_COUNT;
-
-	iwl4965_init_ht_hw_capab(priv, &sband->ht_info, IEEE80211_BAND_2GHZ);
-
-	priv->ieee_channels = channels;
-	priv->ieee_rates = rates;
-
-	iwl4965_init_hw_rates(priv, rates);
-
-	for (i = 0;  i < priv->channel_count; i++) {
-		ch = &priv->channel_info[i];
-
-		/* FIXME: might be removed if scan is OK */
-		if (!is_channel_valid(ch))
-			continue;
-
-		if (is_channel_a_band(ch))
-			sband =  &priv->bands[IEEE80211_BAND_5GHZ];
-		else
-			sband =  &priv->bands[IEEE80211_BAND_2GHZ];
-
-		geo_ch = &sband->channels[sband->n_channels++];
-
-		geo_ch->center_freq = ieee80211_channel_to_frequency(ch->channel);
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
-			if (ch->max_power_avg > priv->max_channel_txpower_limit)
-				priv->max_channel_txpower_limit =
-				    ch->max_power_avg;
-		} else {
-			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
-		}
-
-		/* Save flags for reg domain usage */
-		geo_ch->orig_flags = geo_ch->flags;
-
-		IWL_DEBUG_INFO("Channel %d Freq=%d[%sGHz] %s flag=0%X\n",
-				ch->channel, geo_ch->center_freq,
-				is_channel_a_band(ch) ?  "5.2" : "2.4",
-				geo_ch->flags & IEEE80211_CHAN_DISABLED ?
-				"restricted" : "valid",
-				 geo_ch->flags);
-	}
-
-	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
-	     priv->cfg->sku & IWL_SKU_A) {
-		printk(KERN_INFO DRV_NAME
-		       ": Incorrectly detected BG card as ABG.  Please send "
-		       "your PCI ID 0x%04X:0x%04X to maintainer.\n",
-		       priv->pci_dev->device, priv->pci_dev->subsystem_device);
-		priv->cfg->sku &= ~IWL_SKU_A;
-	}
-
-	printk(KERN_INFO DRV_NAME
-	       ": Tunable channels: %d 802.11bg, %d 802.11a channels\n",
-	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
-	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);
-
-	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
-		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&priv->bands[IEEE80211_BAND_2GHZ];
-	if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
-		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&priv->bands[IEEE80211_BAND_5GHZ];
-
-	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
-
-	return 0;
-}
-
-/*
- * iwl4965_free_geos - undo allocations in iwl4965_init_geos
- */
-void iwl4965_free_geos(struct iwl_priv *priv)
-{
-	kfree(priv->ieee_channels);
-	kfree(priv->ieee_rates);
-	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
-}
-
 /******************************************************************************
  *
  * uCode download functions
@@ -5807,7 +5650,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	if (priv->current_ht_config.is_ht)
 		iwl4965_set_rxon_ht(priv, &priv->current_ht_config);
 #endif /* CONFIG_IWL4965_HT*/
-	iwl4965_set_rxon_chain(priv);
+	iwl_set_rxon_chain(priv);
 	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
 
 	IWL_DEBUG_ASSOC("assoc id %d beacon interval %d\n",
@@ -6153,7 +5996,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		priv->staging_rxon.flags = 0;
 #endif /* CONFIG_IWL4965_HT */
 
-	iwlcore_set_rxon_channel(priv, conf->channel->band,
+	iwl_set_rxon_channel(priv, conf->channel->band,
 		ieee80211_frequency_to_channel(conf->channel->center_freq));
 
 	iwl4965_set_flags_for_phymode(priv, conf->channel->band);
@@ -6225,7 +6068,7 @@ static void iwl4965_config_ap(struct iwl_priv *priv)
 			IWL_WARNING("REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
 
-		iwl4965_set_rxon_chain(priv);
+		iwl_set_rxon_chain(priv);
 
 		/* FIXME: what should be the assoc_id for AP? */
 		priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
@@ -6438,7 +6281,7 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 	if (changes & BSS_CHANGED_HT) {
 		IWL_DEBUG_MAC80211("HT %d\n", bss_conf->assoc_ht);
 		iwl4965_ht_conf(priv, bss_conf);
-		iwl4965_set_rxon_chain(priv);
+		iwl_set_rxon_chain(priv);
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
@@ -6762,7 +6605,7 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	spin_unlock_irqrestore(&priv->lock, flags);
 #endif /* CONFIG_IWL4965_HT */
 
-	iwlcore_reset_qos(priv);
+	iwl_reset_qos(priv);
 
 	cancel_delayed_work(&priv->post_associate);
 
@@ -6849,7 +6692,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 	IWL_DEBUG_MAC80211("leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	iwlcore_reset_qos(priv);
+	iwl_reset_qos(priv);
 
 	queue_work(priv->workqueue, &priv->post_associate.work);
 
@@ -7637,7 +7480,7 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 	pci_set_drvdata(pdev, NULL);
 
 	iwl_free_channel_map(priv);
-	iwl4965_free_geos(priv);
+	iwlcore_free_geos(priv);
 
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
-- 
1.5.3.4

