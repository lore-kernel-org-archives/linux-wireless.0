Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab2FFNWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:22:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/29] iwlwifi: make a lot of functions static
Date: Wed,  6 Jun 2012 15:21:44 +0200
Message-Id: <1338988930-11561-3-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152236_074984_883F5F7C)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A lot of functions were temporarily made non-static
for experimental work, make them static again now.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   21 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   32 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   81 --------------------
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |  106 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |    2 +-
 5 files changed, 82 insertions(+), 160 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 0a3aa7c..7fc8c25 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -175,7 +175,8 @@ static int iwlagn_disconn_pan(struct iwl_priv *priv,
 	return ret;
 }
 
-void iwlagn_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
+static void iwlagn_update_qos(struct iwl_priv *priv,
+			      struct iwl_rxon_context *ctx)
 {
 	int ret;
 
@@ -202,8 +203,8 @@ void iwlagn_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		IWL_DEBUG_QUIET_RFKILL(priv, "Failed to update QoS\n");
 }
 
-int iwlagn_update_beacon(struct iwl_priv *priv,
-			 struct ieee80211_vif *vif)
+static int iwlagn_update_beacon(struct iwl_priv *priv,
+				struct ieee80211_vif *vif)
 {
 	lockdep_assert_held(&priv->mutex);
 
@@ -215,7 +216,7 @@ int iwlagn_update_beacon(struct iwl_priv *priv,
 }
 
 static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
-			   struct iwl_rxon_context *ctx)
+				  struct iwl_rxon_context *ctx)
 {
 	int ret = 0;
 	struct iwl_rxon_assoc_cmd rxon_assoc;
@@ -863,8 +864,8 @@ static int iwl_check_rxon_cmd(struct iwl_priv *priv,
  * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
  * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
  */
-int iwl_full_rxon_required(struct iwl_priv *priv,
-			   struct iwl_rxon_context *ctx)
+static int iwl_full_rxon_required(struct iwl_priv *priv,
+				  struct iwl_rxon_context *ctx)
 {
 	const struct iwl_rxon_cmd *staging = &ctx->staging;
 	const struct iwl_rxon_cmd *active = &ctx->active;
@@ -1294,9 +1295,9 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	return ret;
 }
 
-void iwlagn_check_needed_chains(struct iwl_priv *priv,
-				struct iwl_rxon_context *ctx,
-				struct ieee80211_bss_conf *bss_conf)
+static void iwlagn_check_needed_chains(struct iwl_priv *priv,
+				       struct iwl_rxon_context *ctx,
+				       struct ieee80211_bss_conf *bss_conf)
 {
 	struct ieee80211_vif *vif = ctx->vif;
 	struct iwl_rxon_context *tmp;
@@ -1388,7 +1389,7 @@ void iwlagn_check_needed_chains(struct iwl_priv *priv,
 	ht_conf->single_chain_sufficient = !need_multiple;
 }
 
-void iwlagn_chain_noise_reset(struct iwl_priv *priv)
+static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 {
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 	int ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index cd95a240..fa00717 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -577,7 +577,7 @@ static const u8 iwlagn_pan_ac_to_queue[] = {
 	7, 6, 5, 4,
 };
 
-void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
+static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 {
 	int i;
 
@@ -644,7 +644,7 @@ void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 }
 
-void iwl_rf_kill_ct_config(struct iwl_priv *priv)
+static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl_ct_kill_config cmd;
 	struct iwl_ct_kill_throttling_config adv_cmd;
@@ -725,7 +725,7 @@ static int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 	}
 }
 
-void iwl_send_bt_config(struct iwl_priv *priv)
+static void iwl_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl_bt_cmd bt_cmd = {
 		.lead_time = BT_LEAD_TIME_DEF,
@@ -1080,7 +1080,7 @@ static void iwlagn_disable_roc_work(struct work_struct *work)
  *
  *****************************************************************************/
 
-void iwl_setup_deferred_work(struct iwl_priv *priv)
+static void iwl_setup_deferred_work(struct iwl_priv *priv)
 {
 	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
 
@@ -1331,7 +1331,7 @@ static void iwl_free_geos(struct iwl_priv *priv)
 	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
 }
 
-int iwl_init_drv(struct iwl_priv *priv)
+static int iwl_init_drv(struct iwl_priv *priv)
 {
 	int ret;
 
@@ -1394,7 +1394,7 @@ err:
 	return ret;
 }
 
-void iwl_uninit_drv(struct iwl_priv *priv)
+static void iwl_uninit_drv(struct iwl_priv *priv)
 {
 	iwl_free_geos(priv);
 	iwl_free_channel_map(priv);
@@ -1407,7 +1407,7 @@ void iwl_uninit_drv(struct iwl_priv *priv)
 #endif
 }
 
-void iwl_set_hw_params(struct iwl_priv *priv)
+static void iwl_set_hw_params(struct iwl_priv *priv)
 {
 	if (priv->cfg->ht_params)
 		priv->hw_params.use_rts_for_aggregation =
@@ -1423,7 +1423,7 @@ void iwl_set_hw_params(struct iwl_priv *priv)
 
 
 /* show what optional capabilities we have */
-void iwl_option_config(struct iwl_priv *priv)
+static void iwl_option_config(struct iwl_priv *priv)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	IWL_INFO(priv, "CONFIG_IWLWIFI_DEBUG enabled\n");
@@ -1722,7 +1722,7 @@ out:
 	return op_mode;
 }
 
-void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
+static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
@@ -2187,7 +2187,7 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	}
 }
 
-void iwl_nic_error(struct iwl_op_mode *op_mode)
+static void iwl_nic_error(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
@@ -2200,7 +2200,7 @@ void iwl_nic_error(struct iwl_op_mode *op_mode)
 	iwlagn_fw_error(priv, false);
 }
 
-void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
+static void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
@@ -2210,7 +2210,7 @@ void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
 	}
 }
 
-void iwl_nic_config(struct iwl_op_mode *op_mode)
+static void iwl_nic_config(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
@@ -2225,7 +2225,7 @@ static void iwl_wimax_active(struct iwl_op_mode *op_mode)
 	IWL_ERR(priv, "RF is used by WiMAX\n");
 }
 
-void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
+static void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 	int mq = priv->queue_to_mac80211[queue];
@@ -2244,7 +2244,7 @@ void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
 	ieee80211_stop_queue(priv->hw, mq);
 }
 
-void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, int queue)
+static void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 	int mq = priv->queue_to_mac80211[queue];
@@ -2284,7 +2284,7 @@ void iwlagn_lift_passive_no_rx(struct iwl_priv *priv)
 	priv->passive_no_rx = false;
 }
 
-void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
+static void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info;
 
@@ -2293,7 +2293,7 @@ void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 
-void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
+static void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5c1693f..3f3607f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -523,85 +523,4 @@ static inline const char *iwl_dvm_get_cmd_string(u8 cmd)
 		return s;
 	return "UNKNOWN";
 }
-
-/* API method exported for mvm hybrid state */
-void iwl_setup_deferred_work(struct iwl_priv *priv);
-int iwl_send_wimax_coex(struct iwl_priv *priv);
-int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
-void iwl_option_config(struct iwl_priv *priv);
-void iwl_set_hw_params(struct iwl_priv *priv);
-void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags);
-int iwl_init_drv(struct iwl_priv *priv);
-void iwl_uninit_drv(struct iwl_priv *priv);
-void iwl_send_bt_config(struct iwl_priv *priv);
-void iwl_rf_kill_ct_config(struct iwl_priv *priv);
-int iwl_setup_interface(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
-void iwl_teardown_interface(struct iwl_priv *priv,
-			    struct ieee80211_vif *vif,
-			    bool mode_change);
-int iwl_full_rxon_required(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
-void iwlagn_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
-void iwlagn_check_needed_chains(struct iwl_priv *priv,
-				struct iwl_rxon_context *ctx,
-				struct ieee80211_bss_conf *bss_conf);
-void iwlagn_chain_noise_reset(struct iwl_priv *priv);
-int iwlagn_update_beacon(struct iwl_priv *priv,
-			 struct ieee80211_vif *vif);
-void iwl_tt_handler(struct iwl_priv *priv);
-void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode);
-void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue);
-void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state);
-void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb);
-void iwl_nic_error(struct iwl_op_mode *op_mode);
-void iwl_cmd_queue_full(struct iwl_op_mode *op_mode);
-void iwl_nic_config(struct iwl_op_mode *op_mode);
-int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
-		       struct ieee80211_sta *sta, bool set);
-void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
-			      enum ieee80211_rssi_event rssi_event);
-int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw);
-int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw);
-void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop);
-void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, int queue);
-void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
-			       struct ieee80211_channel_switch *ch_switch);
-int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
-			 struct ieee80211_vif *vif,
-			 struct ieee80211_sta *sta,
-			 enum ieee80211_sta_state old_state,
-			 enum ieee80211_sta_state new_state);
-int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
-			    struct ieee80211_vif *vif,
-			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			    u8 buf_size);
-int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
-		       struct ieee80211_vif *vif,
-		       struct cfg80211_scan_request *req);
-void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
-			   struct ieee80211_vif *vif,
-			   enum sta_notify_cmd cmd,
-			   struct ieee80211_sta *sta);
-void iwlagn_configure_filter(struct ieee80211_hw *hw,
-			     unsigned int changed_flags,
-			     unsigned int *total_flags,
-			     u64 multicast);
-int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
-		       struct ieee80211_vif *vif, u16 queue,
-		       const struct ieee80211_tx_queue_params *params);
-void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       struct cfg80211_gtk_rekey_data *data);
-void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_key_conf *keyconf,
-				struct ieee80211_sta *sta,
-				u32 iv32, u16 *phase1key);
-int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		       struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta,
-		       struct ieee80211_key_conf *key);
-void iwlagn_mac_stop(struct ieee80211_hw *hw);
-void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
-int iwlagn_mac_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan);
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index ff66200..d0b64cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -338,7 +338,7 @@ static int iwlagn_mac_start(struct ieee80211_hw *hw)
 	return 0;
 }
 
-void iwlagn_mac_stop(struct ieee80211_hw *hw)
+static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -366,9 +366,9 @@ void iwlagn_mac_stop(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       struct cfg80211_gtk_rekey_data *data)
+static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct cfg80211_gtk_rekey_data *data)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -394,7 +394,8 @@ void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 
 #ifdef CONFIG_PM_SLEEP
 
-int iwlagn_mac_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
+static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
+			      struct cfg80211_wowlan *wowlan)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
@@ -505,7 +506,7 @@ static void iwlagn_mac_set_wakeup(struct ieee80211_hw *hw, bool enabled)
 }
 #endif
 
-void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -516,21 +517,21 @@ void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		dev_kfree_skb_any(skb);
 }
 
-void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_key_conf *keyconf,
-				struct ieee80211_sta *sta,
-				u32 iv32, u16 *phase1key)
+static void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_key_conf *keyconf,
+				       struct ieee80211_sta *sta,
+				       u32 iv32, u16 *phase1key)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	iwl_update_tkip_key(priv, vif, keyconf, sta, iv32, phase1key);
 }
 
-int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		       struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta,
-		       struct ieee80211_key_conf *key)
+static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct ieee80211_key_conf *key)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
@@ -630,11 +631,11 @@ int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
-int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
-			    struct ieee80211_vif *vif,
-			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			    u8 buf_size)
+static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   enum ieee80211_ampdu_mlme_action action,
+				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+				   u8 buf_size)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret = -EINVAL;
@@ -756,11 +757,11 @@ static int iwlagn_mac_sta_remove(struct ieee80211_hw *hw,
 	return ret;
 }
 
-int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
-			 struct ieee80211_vif *vif,
-			 struct ieee80211_sta *sta,
-			 enum ieee80211_sta_state old_state,
-			 enum ieee80211_sta_state new_state)
+static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				enum ieee80211_sta_state old_state,
+				enum ieee80211_sta_state new_state)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
@@ -839,8 +840,8 @@ int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 	return ret;
 }
 
-void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
-			       struct ieee80211_channel_switch *ch_switch)
+static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
+				      struct ieee80211_channel_switch *ch_switch)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	const struct iwl_channel_info *ch_info;
@@ -934,10 +935,10 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 		ieee80211_chswitch_done(ctx->vif, is_success);
 }
 
-void iwlagn_configure_filter(struct ieee80211_hw *hw,
-			     unsigned int changed_flags,
-			     unsigned int *total_flags,
-			     u64 multicast)
+static void iwlagn_configure_filter(struct ieee80211_hw *hw,
+				    unsigned int changed_flags,
+				    unsigned int *total_flags,
+				    u64 multicast)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	__le32 filter_or = 0, filter_nand = 0;
@@ -984,7 +985,7 @@ void iwlagn_configure_filter(struct ieee80211_hw *hw,
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
-void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
+static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -1111,7 +1112,7 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 	return err;
 }
 
-int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
+static int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -1128,8 +1129,8 @@ int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	return 0;
 }
 
-void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
-			      enum ieee80211_rssi_event rssi_event)
+static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
+				     enum ieee80211_rssi_event rssi_event)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -1153,8 +1154,8 @@ void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
-		       struct ieee80211_sta *sta, bool set)
+static int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
+			      struct ieee80211_sta *sta, bool set)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -1163,9 +1164,9 @@ int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
 	return 0;
 }
 
-int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
-		       struct ieee80211_vif *vif, u16 queue,
-		       const struct ieee80211_tx_queue_params *params)
+static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, u16 queue,
+			      const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
@@ -1207,7 +1208,7 @@ int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 	return 0;
 }
 
-int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw)
+static int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -1223,7 +1224,8 @@ static int iwl_set_mode(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	return iwlagn_commit_rxon(priv, ctx);
 }
 
-int iwl_setup_interface(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
+static int iwl_setup_interface(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx)
 {
 	struct ieee80211_vif *vif = ctx->vif;
 	int err, ac;
@@ -1343,9 +1345,9 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	return err;
 }
 
-void iwl_teardown_interface(struct iwl_priv *priv,
-			    struct ieee80211_vif *vif,
-			    bool mode_change)
+static void iwl_teardown_interface(struct iwl_priv *priv,
+				   struct ieee80211_vif *vif,
+				   bool mode_change)
 {
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 
@@ -1486,9 +1488,9 @@ static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
 	return err;
 }
 
-int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
-		       struct ieee80211_vif *vif,
-		       struct cfg80211_scan_request *req)
+static int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct cfg80211_scan_request *req)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret;
@@ -1543,10 +1545,10 @@ static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 	iwl_send_add_sta(priv, &cmd, CMD_ASYNC);
 }
 
-void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
-			   struct ieee80211_vif *vif,
-			   enum sta_notify_cmd cmd,
-			   struct ieee80211_sta *sta)
+static void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  enum sta_notify_cmd cmd,
+				  struct ieee80211_sta *sta)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index bc40dc6..d14e633 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -177,7 +177,7 @@ int iwl_init_alive_start(struct iwl_priv *priv)
 	return 0;
 }
 
-int iwl_send_wimax_coex(struct iwl_priv *priv)
+static int iwl_send_wimax_coex(struct iwl_priv *priv)
 {
 	struct iwl_wimax_coex_cmd coex_cmd;
 
-- 
1.7.10

