Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118Ab3GZI35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 11/30] iwlwifi: dvm: remove P2P support
Date: Fri, 26 Jul 2013 10:28:28 +0200
Message-Id: <1374827327-3464-12-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103017_336023_E2DC51F3)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We're not planning to support P2P on older devices, so
remove the Kconfig option and associated code for it.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |  17 ---
 drivers/net/wireless/iwlwifi/dvm/agn.h      |   6 -
 drivers/net/wireless/iwlwifi/dvm/dev.h      |   7 --
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 172 +---------------------------
 drivers/net/wireless/iwlwifi/dvm/main.c     |  62 ----------
 drivers/net/wireless/iwlwifi/dvm/rxon.c     |   6 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c     | 105 +----------------
 drivers/net/wireless/iwlwifi/dvm/tx.c       |  19 ---
 8 files changed, 3 insertions(+), 391 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index cbaa5c2..e5c133e 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -127,20 +127,3 @@ config IWLWIFI_DEVICE_TRACING
 	  If unsure, say Y so we can help you better when problems
 	  occur.
 endmenu
-
-config IWLWIFI_P2P
-	def_bool y
-	bool "iwlwifi experimental P2P support"
-	depends on IWLWIFI
-	help
-	  This option enables experimental P2P support for some devices
-	  based on microcode support. Since P2P support is still under
-	  development, this option may even enable it for some devices
-	  now that turn out to not support it in the future due to
-	  microcode restrictions.
-
-	  To determine if your microcode supports the experimental P2P
-	  offered by this option, check if the driver advertises AP
-	  support when it is loaded.
-
-	  Say Y only if you want to experiment with P2P.
diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index 1835511..f2a86ff 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -106,7 +106,6 @@ extern const struct iwl_dvm_cfg iwl_dvm_6030_cfg;
 #define STATUS_CHANNEL_SWITCH_PENDING 11
 #define STATUS_SCAN_COMPLETE	12
 #define STATUS_POWER_PMI	13
-#define STATUS_SCAN_ROC_EXPIRED 14
 
 struct iwl_ucode_capabilities;
 
@@ -250,7 +249,6 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
 
 /* scan */
 void iwlagn_post_scan(struct iwl_priv *priv);
-void iwlagn_disable_roc(struct iwl_priv *priv);
 int iwl_force_rf_reset(struct iwl_priv *priv, bool external);
 void iwl_init_scan_params(struct iwl_priv *priv);
 int iwl_scan_cancel(struct iwl_priv *priv);
@@ -265,10 +263,6 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 				   enum iwl_scan_type scan_type,
 				   enum ieee80211_band band);
 
-void iwl_scan_roc_expired(struct iwl_priv *priv);
-void iwl_scan_offchannel_skb(struct iwl_priv *priv);
-void iwl_scan_offchannel_skb_status(struct iwl_priv *priv);
-
 /* For faster active scanning, scan will move to the next channel if fewer than
  * PLCP_QUIET_THRESH packets are heard on this channel within
  * ACTIVE_QUIET_TIME after sending probe request.  This shortens the dwell
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 60a4e0d..a79fdd1 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -540,7 +540,6 @@ struct iwl_rxon_context {
 enum iwl_scan_type {
 	IWL_SCAN_NORMAL,
 	IWL_SCAN_RADIO_RESET,
-	IWL_SCAN_ROC,
 };
 
 /**
@@ -825,12 +824,6 @@ struct iwl_priv {
 	struct reply_tx_error_statistics reply_tx_stats;
 	struct reply_agg_tx_error_statistics reply_agg_tx_stats;
 
-	/* remain-on-channel offload support */
-	struct ieee80211_channel *hw_roc_channel;
-	struct delayed_work hw_roc_disable_work;
-	int hw_roc_duration;
-	bool hw_roc_setup, hw_roc_start_notified;
-
 	/* bt coex */
 	u8 bt_enable_flag;
 	u8 bt_status;
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 822f1a0..f0a2c95 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -76,29 +76,6 @@ static const struct ieee80211_iface_limit iwlagn_2sta_limits[] = {
 	},
 };
 
-static const struct ieee80211_iface_limit iwlagn_p2p_sta_go_limits[] = {
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_STATION),
-	},
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_P2P_GO) |
-			 BIT(NL80211_IFTYPE_AP),
-	},
-};
-
-static const struct ieee80211_iface_limit iwlagn_p2p_2sta_limits[] = {
-	{
-		.max = 2,
-		.types = BIT(NL80211_IFTYPE_STATION),
-	},
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_P2P_CLIENT),
-	},
-};
-
 static const struct ieee80211_iface_combination
 iwlagn_iface_combinations_dualmode[] = {
 	{ .num_different_channels = 1,
@@ -114,21 +91,6 @@ iwlagn_iface_combinations_dualmode[] = {
 	},
 };
 
-static const struct ieee80211_iface_combination
-iwlagn_iface_combinations_p2p[] = {
-	{ .num_different_channels = 1,
-	  .max_interfaces = 2,
-	  .beacon_int_infra_match = true,
-	  .limits = iwlagn_p2p_sta_go_limits,
-	  .n_limits = ARRAY_SIZE(iwlagn_p2p_sta_go_limits),
-	},
-	{ .num_different_channels = 1,
-	  .max_interfaces = 2,
-	  .limits = iwlagn_p2p_2sta_limits,
-	  .n_limits = ARRAY_SIZE(iwlagn_p2p_2sta_limits),
-	},
-};
-
 /*
  * Not a mac80211 entry point function, but it fits in with all the
  * other mac80211 functions grouped here.
@@ -186,19 +148,13 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 
-	if (hw->wiphy->interface_modes & BIT(NL80211_IFTYPE_P2P_CLIENT)) {
-		hw->wiphy->iface_combinations = iwlagn_iface_combinations_p2p;
-		hw->wiphy->n_iface_combinations =
-			ARRAY_SIZE(iwlagn_iface_combinations_p2p);
-	} else if (hw->wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
+	if (hw->wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
 		hw->wiphy->iface_combinations =
 			iwlagn_iface_combinations_dualmode;
 		hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(iwlagn_iface_combinations_dualmode);
 	}
 
-	hw->wiphy->max_remain_on_channel_duration = 500;
-
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
@@ -1156,126 +1112,6 @@ done:
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
-				     struct ieee80211_vif *vif,
-				     struct ieee80211_channel *channel,
-				     int duration,
-				     enum ieee80211_roc_type type)
-{
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
-	int err = 0;
-
-	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
-		return -EOPNOTSUPP;
-
-	if (!(ctx->interface_modes & BIT(NL80211_IFTYPE_P2P_CLIENT)))
-		return -EOPNOTSUPP;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->mutex);
-
-	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
-		/* mac80211 should not scan while ROC or ROC while scanning */
-		if (WARN_ON_ONCE(priv->scan_type != IWL_SCAN_RADIO_RESET)) {
-			err = -EBUSY;
-			goto out;
-		}
-
-		iwl_scan_cancel_timeout(priv, 100);
-
-		if (test_bit(STATUS_SCAN_HW, &priv->status)) {
-			err = -EBUSY;
-			goto out;
-		}
-	}
-
-	priv->hw_roc_channel = channel;
-	/* convert from ms to TU */
-	priv->hw_roc_duration = DIV_ROUND_UP(1000 * duration, 1024);
-	priv->hw_roc_start_notified = false;
-	cancel_delayed_work(&priv->hw_roc_disable_work);
-
-	if (!ctx->is_active) {
-		static const struct iwl_qos_info default_qos_data = {
-			.def_qos_parm = {
-				.ac[0] = {
-					.cw_min = cpu_to_le16(3),
-					.cw_max = cpu_to_le16(7),
-					.aifsn = 2,
-					.edca_txop = cpu_to_le16(1504),
-				},
-				.ac[1] = {
-					.cw_min = cpu_to_le16(7),
-					.cw_max = cpu_to_le16(15),
-					.aifsn = 2,
-					.edca_txop = cpu_to_le16(3008),
-				},
-				.ac[2] = {
-					.cw_min = cpu_to_le16(15),
-					.cw_max = cpu_to_le16(1023),
-					.aifsn = 3,
-				},
-				.ac[3] = {
-					.cw_min = cpu_to_le16(15),
-					.cw_max = cpu_to_le16(1023),
-					.aifsn = 7,
-				},
-			},
-		};
-
-		ctx->is_active = true;
-		ctx->qos_data = default_qos_data;
-		ctx->staging.dev_type = RXON_DEV_TYPE_P2P;
-		memcpy(ctx->staging.node_addr,
-		       priv->contexts[IWL_RXON_CTX_BSS].staging.node_addr,
-		       ETH_ALEN);
-		memcpy(ctx->staging.bssid_addr,
-		       priv->contexts[IWL_RXON_CTX_BSS].staging.node_addr,
-		       ETH_ALEN);
-		err = iwlagn_commit_rxon(priv, ctx);
-		if (err)
-			goto out;
-		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK |
-					     RXON_FILTER_PROMISC_MSK |
-					     RXON_FILTER_CTL2HOST_MSK;
-
-		err = iwlagn_commit_rxon(priv, ctx);
-		if (err) {
-			iwlagn_disable_roc(priv);
-			goto out;
-		}
-		priv->hw_roc_setup = true;
-	}
-
-	err = iwl_scan_initiate(priv, ctx->vif, IWL_SCAN_ROC, channel->band);
-	if (err)
-		iwlagn_disable_roc(priv);
-
- out:
-	mutex_unlock(&priv->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return err;
-}
-
-static int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
-{
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-
-	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
-		return -EOPNOTSUPP;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->mutex);
-	iwl_scan_cancel_timeout(priv, priv->hw_roc_duration);
-	iwlagn_disable_roc(priv);
-	mutex_unlock(&priv->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return 0;
-}
-
 static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     enum ieee80211_rssi_event rssi_event)
@@ -1431,12 +1267,8 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
 			   viftype, vif->addr);
 
-	cancel_delayed_work_sync(&priv->hw_roc_disable_work);
-
 	mutex_lock(&priv->mutex);
 
-	iwlagn_disable_roc(priv);
-
 	if (!iwl_is_ready_rf(priv)) {
 		IWL_WARN(priv, "Try to add interface when device not ready\n");
 		err = -EINVAL;
@@ -1763,8 +1595,6 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.channel_switch = iwlagn_mac_channel_switch,
 	.flush = iwlagn_mac_flush,
 	.tx_last_beacon = iwlagn_mac_tx_last_beacon,
-	.remain_on_channel = iwlagn_mac_remain_on_channel,
-	.cancel_remain_on_channel = iwlagn_mac_cancel_remain_on_channel,
 	.rssi_callback = iwlagn_mac_rssi_callback,
 	.set_tim = iwlagn_mac_set_tim,
 };
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 3952ddf..f78a3d3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -587,11 +587,6 @@ static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	priv->contexts[IWL_RXON_CTX_PAN].interface_modes =
 		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP);
 
-	if (ucode_flags & IWL_UCODE_TLV_FLAGS_P2P)
-		priv->contexts[IWL_RXON_CTX_PAN].interface_modes |=
-			BIT(NL80211_IFTYPE_P2P_CLIENT) |
-			BIT(NL80211_IFTYPE_P2P_GO);
-
 	priv->contexts[IWL_RXON_CTX_PAN].ap_devtype = RXON_DEV_TYPE_CP;
 	priv->contexts[IWL_RXON_CTX_PAN].station_devtype = RXON_DEV_TYPE_2STA;
 	priv->contexts[IWL_RXON_CTX_PAN].unused_devtype = RXON_DEV_TYPE_P2P;
@@ -854,14 +849,6 @@ void iwl_down(struct iwl_priv *priv)
 
 	iwl_scan_cancel_timeout(priv, 200);
 
-	/*
-	 * If active, scanning won't cancel it, so say it expired.
-	 * No race since we hold the mutex here and a new one
-	 * can't come in at this time.
-	 */
-	if (priv->ucode_loaded && priv->cur_ucode != IWL_UCODE_INIT)
-		ieee80211_remain_on_channel_expired(priv->hw);
-
 	exit_pending =
 		test_and_set_bit(STATUS_EXIT_PENDING, &priv->status);
 
@@ -1002,41 +989,6 @@ static void iwl_bg_restart(struct work_struct *data)
 	}
 }
 
-
-
-
-void iwlagn_disable_roc(struct iwl_priv *priv)
-{
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
-
-	lockdep_assert_held(&priv->mutex);
-
-	if (!priv->hw_roc_setup)
-		return;
-
-	ctx->staging.dev_type = RXON_DEV_TYPE_P2P;
-	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-
-	priv->hw_roc_channel = NULL;
-
-	memset(ctx->staging.node_addr, 0, ETH_ALEN);
-
-	iwlagn_commit_rxon(priv, ctx);
-
-	ctx->is_active = false;
-	priv->hw_roc_setup = false;
-}
-
-static void iwlagn_disable_roc_work(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv,
-					     hw_roc_disable_work.work);
-
-	mutex_lock(&priv->mutex);
-	iwlagn_disable_roc(priv);
-	mutex_unlock(&priv->mutex);
-}
-
 /*****************************************************************************
  *
  * driver setup and teardown
@@ -1053,8 +1005,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->tx_flush, iwl_bg_tx_flush);
 	INIT_WORK(&priv->bt_full_concurrency, iwl_bg_bt_full_concurrency);
 	INIT_WORK(&priv->bt_runtime_config, iwl_bg_bt_runtime_config);
-	INIT_DELAYED_WORK(&priv->hw_roc_disable_work,
-			  iwlagn_disable_roc_work);
 
 	iwl_setup_scan_deferred_work(priv);
 
@@ -1082,7 +1032,6 @@ void iwl_cancel_deferred_work(struct iwl_priv *priv)
 
 	cancel_work_sync(&priv->bt_full_concurrency);
 	cancel_work_sync(&priv->bt_runtime_config);
-	cancel_delayed_work_sync(&priv->hw_roc_disable_work);
 
 	del_timer_sync(&priv->statistics_periodic);
 	del_timer_sync(&priv->ucode_trace);
@@ -1169,12 +1118,6 @@ static void iwl_option_config(struct iwl_priv *priv)
 #else
 	IWL_INFO(priv, "CONFIG_IWLWIFI_DEVICE_TRACING disabled\n");
 #endif
-
-#ifdef CONFIG_IWLWIFI_P2P
-	IWL_INFO(priv, "CONFIG_IWLWIFI_P2P enabled\n");
-#else
-	IWL_INFO(priv, "CONFIG_IWLWIFI_P2P disabled\n");
-#endif
 }
 
 static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
@@ -1315,10 +1258,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 
 	ucode_flags = fw->ucode_capa.flags;
 
-#ifndef CONFIG_IWLWIFI_P2P
-	ucode_flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
-#endif
-
 	if (ucode_flags & IWL_UCODE_TLV_FLAGS_PAN) {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
 		trans_cfg.cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
@@ -1413,7 +1352,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		 * if not PAN, then don't support P2P -- might be a uCode
 		 * packaging bug or due to the eeprom check above
 		 */
-		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 		trans_cfg.cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index cd1ad001..d7ce2f12 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -564,11 +564,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	cmd.slots[0].type = 0; /* BSS */
 	cmd.slots[1].type = 1; /* PAN */
 
-	if (priv->hw_roc_setup) {
-		/* both contexts must be used for this to happen */
-		slot1 = IWL_MIN_SLOT_TIME;
-		slot0 = 3000;
-	} else if (ctx_bss->vif && ctx_pan->vif) {
+	if (ctx_bss->vif && ctx_pan->vif) {
 		int bcnint = ctx_pan->beacon_int;
 		int dtim = ctx_pan->vif->bss_conf.dtim_period ?: 1;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index 8c686a5..35e0ee8 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -100,9 +100,6 @@ static void iwl_complete_scan(struct iwl_priv *priv, bool aborted)
 		ieee80211_scan_completed(priv->hw, aborted);
 	}
 
-	if (priv->scan_type == IWL_SCAN_ROC)
-		iwl_scan_roc_expired(priv);
-
 	priv->scan_type = IWL_SCAN_NORMAL;
 	priv->scan_vif = NULL;
 	priv->scan_request = NULL;
@@ -130,9 +127,6 @@ static void iwl_process_scan_complete(struct iwl_priv *priv)
 		goto out_settings;
 	}
 
-	if (priv->scan_type == IWL_SCAN_ROC)
-		iwl_scan_roc_expired(priv);
-
 	if (priv->scan_type != IWL_SCAN_NORMAL && !aborted) {
 		int err;
 
@@ -284,12 +278,6 @@ static int iwl_rx_scan_start_notif(struct iwl_priv *priv,
 		       le32_to_cpu(notif->tsf_low),
 		       notif->status, notif->beacon_timer);
 
-	if (priv->scan_type == IWL_SCAN_ROC &&
-	    !priv->hw_roc_start_notified) {
-		ieee80211_ready_on_channel(priv->hw);
-		priv->hw_roc_start_notified = true;
-	}
-
 	return 0;
 }
 
@@ -697,8 +685,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
 
-	if (priv->scan_type != IWL_SCAN_ROC &&
-	    iwl_is_any_associated(priv)) {
+	if (iwl_is_any_associated(priv)) {
 		u16 interval = 0;
 		u32 extra;
 		u32 suspend_time = 100;
@@ -706,9 +693,6 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
 		switch (priv->scan_type) {
-		case IWL_SCAN_ROC:
-			WARN_ON(1);
-			break;
 		case IWL_SCAN_RADIO_RESET:
 			interval = 0;
 			break;
@@ -728,11 +712,6 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		scan->suspend_time = cpu_to_le32(scan_suspend_time);
 		IWL_DEBUG_SCAN(priv, "suspend_time 0x%X beacon interval %d\n",
 			       scan_suspend_time, interval);
-	} else if (priv->scan_type == IWL_SCAN_ROC) {
-		scan->suspend_time = 0;
-		scan->max_out_time = 0;
-		scan->quiet_time = 0;
-		scan->quiet_plcp_th = 0;
 	}
 
 	switch (priv->scan_type) {
@@ -774,9 +753,6 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		} else
 			IWL_DEBUG_SCAN(priv, "Start passive scan.\n");
 		break;
-	case IWL_SCAN_ROC:
-		IWL_DEBUG_SCAN(priv, "Start ROC scan.\n");
-		break;
 	}
 
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
@@ -898,7 +874,6 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 					scan_cmd_size - sizeof(*scan));
 		break;
 	case IWL_SCAN_RADIO_RESET:
-	case IWL_SCAN_ROC:
 		/* use bcast addr, will not be transmitted but must be valid */
 		cmd_len = iwl_fill_probe_req(
 					(struct ieee80211_mgmt *)scan->data,
@@ -926,46 +901,6 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 				is_active, n_probes,
 				(void *)&scan->data[cmd_len]);
 		break;
-	case IWL_SCAN_ROC: {
-		struct iwl_scan_channel *scan_ch;
-		int n_chan, i;
-		u16 dwell;
-
-		dwell = iwl_limit_dwell(priv, priv->hw_roc_duration);
-		n_chan = DIV_ROUND_UP(priv->hw_roc_duration, dwell);
-
-		scan->channel_count = n_chan;
-
-		scan_ch = (void *)&scan->data[cmd_len];
-
-		for (i = 0; i < n_chan; i++) {
-			scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
-			scan_ch->channel =
-				cpu_to_le16(priv->hw_roc_channel->hw_value);
-
-			if (i == n_chan - 1)
-				dwell = priv->hw_roc_duration - i * dwell;
-
-			scan_ch->active_dwell =
-			scan_ch->passive_dwell = cpu_to_le16(dwell);
-
-			/* Set txpower levels to defaults */
-			scan_ch->dsp_atten = 110;
-
-			/* NOTE: if we were doing 6Mb OFDM for scans we'd use
-			 * power level:
-			 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
-			 */
-			if (priv->hw_roc_channel->band == IEEE80211_BAND_5GHZ)
-				scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
-			else
-				scan_ch->tx_gain = ((1 << 5) | (5 << 3));
-
-			scan_ch++;
-		}
-		}
-
-		break;
 	}
 
 	if (scan->channel_count == 0) {
@@ -1035,7 +970,6 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 
 	IWL_DEBUG_SCAN(priv, "Starting %sscan...\n",
 			scan_type == IWL_SCAN_NORMAL ? "" :
-			scan_type == IWL_SCAN_ROC ? "remain-on-channel " :
 			"internal short ");
 
 	set_bit(STATUS_SCANNING, &priv->status);
@@ -1149,40 +1083,3 @@ void iwl_cancel_scan_deferred_work(struct iwl_priv *priv)
 		mutex_unlock(&priv->mutex);
 	}
 }
-
-void iwl_scan_roc_expired(struct iwl_priv *priv)
-{
-	/*
-	 * The status bit should be set here, to prevent a race
-	 * where the atomic_read returns 1, but before the execution continues
-	 * iwl_scan_offchannel_skb_status() checks if the status bit is set
-	 */
-	set_bit(STATUS_SCAN_ROC_EXPIRED, &priv->status);
-
-	if (atomic_read(&priv->num_aux_in_flight) == 0) {
-		ieee80211_remain_on_channel_expired(priv->hw);
-		priv->hw_roc_channel = NULL;
-		schedule_delayed_work(&priv->hw_roc_disable_work,
-				      10 * HZ);
-
-		clear_bit(STATUS_SCAN_ROC_EXPIRED, &priv->status);
-	} else {
-		IWL_DEBUG_SCAN(priv, "ROC done with %d frames in aux\n",
-			       atomic_read(&priv->num_aux_in_flight));
-	}
-}
-
-void iwl_scan_offchannel_skb(struct iwl_priv *priv)
-{
-	WARN_ON(!priv->hw_roc_start_notified);
-	atomic_inc(&priv->num_aux_in_flight);
-}
-
-void iwl_scan_offchannel_skb_status(struct iwl_priv *priv)
-{
-	if (atomic_dec_return(&priv->num_aux_in_flight) == 0 &&
-	    test_bit(STATUS_SCAN_ROC_EXPIRED, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "0 aux frames. Calling ROC expired\n");
-		iwl_scan_roc_expired(priv);
-	}
-}
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 5ee983f..3db0bbb 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -478,9 +478,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 	if (sta_priv && sta_priv->client && !is_agg)
 		atomic_inc(&sta_priv->pending_frames);
 
-	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
-		iwl_scan_offchannel_skb(priv);
-
 	return 0;
 
 drop_unlock_sta:
@@ -1158,7 +1155,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 	struct sk_buff *skb;
 	struct iwl_rxon_context *ctx;
 	bool is_agg = (txq_id >= IWLAGN_FIRST_AMPDU_QUEUE);
-	bool is_offchannel_skb;
 
 	tid = (tx_resp->ra_tid & IWLAGN_TX_RES_TID_MSK) >>
 		IWLAGN_TX_RES_TID_POS;
@@ -1178,8 +1174,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 
 	__skb_queue_head_init(&skbs);
 
-	is_offchannel_skb = false;
-
 	if (tx_resp->frame_count == 1) {
 		u16 next_reclaimed = le16_to_cpu(tx_resp->seq_ctl);
 		next_reclaimed = IEEE80211_SEQ_TO_SN(next_reclaimed + 0x10);
@@ -1256,8 +1250,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			if (!is_agg)
 				iwlagn_non_agg_tx_status(priv, ctx, hdr->addr1);
 
-			is_offchannel_skb =
-				(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN);
 			freed++;
 		}
 
@@ -1271,14 +1263,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 		if (!is_agg && freed != 1)
 			IWL_ERR(priv, "Q: %d, freed %d\n", txq_id, freed);
 
-		/*
-		 * An offchannel frame can be send only on the AUX queue, where
-		 * there is no aggregation (and reordering) so it only is single
-		 * skb is expected to be processed.
-		 */
-		if (is_offchannel_skb && freed != 1)
-			IWL_ERR(priv, "OFFCHANNEL SKB freed %d\n", freed);
-
 		IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x)\n", txq_id,
 				   iwl_get_tx_fail_reason(status), status);
 
@@ -1298,9 +1282,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 		ieee80211_tx_status_ni(priv->hw, skb);
 	}
 
-	if (is_offchannel_skb)
-		iwl_scan_offchannel_skb_status(priv);
-
 	return 0;
 }
 
-- 
1.8.0

