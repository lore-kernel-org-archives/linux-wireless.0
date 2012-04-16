Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47896 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab2DPWBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/16] iwlwifi: expose static methods for MVM use
Date: Mon, 16 Apr 2012 14:57:08 -0700
Message-Id: <1334613430-30720-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000140_019355_EEE51BE8)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

To support hybrid state of MVM op_mode, most of the functioanallity
will be done using DVM functions.

When MVM will have independant live, the declarations will be removed
and the functions will be static back.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   19 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   32 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   81 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |  100 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |    2 +-
 5 files changed, 156 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 88a7f3a..5c7bddd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -177,8 +177,7 @@ static int iwlagn_disconn_pan(struct iwl_priv *priv,
 	return ret;
 }
 
-static void iwlagn_update_qos(struct iwl_priv *priv,
-			      struct iwl_rxon_context *ctx)
+void iwlagn_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	int ret;
 
@@ -205,8 +204,8 @@ static void iwlagn_update_qos(struct iwl_priv *priv,
 		IWL_DEBUG_QUIET_RFKILL(priv, "Failed to update QoS\n");
 }
 
-static int iwlagn_update_beacon(struct iwl_priv *priv,
-				struct ieee80211_vif *vif)
+int iwlagn_update_beacon(struct iwl_priv *priv,
+			 struct ieee80211_vif *vif)
 {
 	lockdep_assert_held(&priv->mutex);
 
@@ -879,8 +878,8 @@ static int iwl_check_rxon_cmd(struct iwl_priv *priv,
  * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
  * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
  */
-static int iwl_full_rxon_required(struct iwl_priv *priv,
-				  struct iwl_rxon_context *ctx)
+int iwl_full_rxon_required(struct iwl_priv *priv,
+			   struct iwl_rxon_context *ctx)
 {
 	const struct iwl_rxon_cmd *staging = &ctx->staging;
 	const struct iwl_rxon_cmd *active = &ctx->active;
@@ -1223,9 +1222,9 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	return ret;
 }
 
-static void iwlagn_check_needed_chains(struct iwl_priv *priv,
-				       struct iwl_rxon_context *ctx,
-				       struct ieee80211_bss_conf *bss_conf)
+void iwlagn_check_needed_chains(struct iwl_priv *priv,
+				struct iwl_rxon_context *ctx,
+				struct ieee80211_bss_conf *bss_conf)
 {
 	struct ieee80211_vif *vif = ctx->vif;
 	struct iwl_rxon_context *tmp;
@@ -1317,7 +1316,7 @@ static void iwlagn_check_needed_chains(struct iwl_priv *priv,
 	ht_conf->single_chain_sufficient = !need_multiple;
 }
 
-static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
+void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 {
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 	int ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6b1a039..bc585a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -597,7 +597,7 @@ static const u8 iwlagn_pan_queue_to_ac[] = {
 	IEEE80211_AC_VO,
 };
 
-static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
+void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 {
 	int i;
 
@@ -664,7 +664,7 @@ static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 }
 
-static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
+void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl_ct_kill_config cmd;
 	struct iwl_ct_kill_throttling_config adv_cmd;
@@ -745,7 +745,7 @@ static int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 	}
 }
 
-static void iwl_send_bt_config(struct iwl_priv *priv)
+void iwl_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl_bt_cmd bt_cmd = {
 		.lead_time = BT_LEAD_TIME_DEF,
@@ -1100,7 +1100,7 @@ static void iwlagn_disable_roc_work(struct work_struct *work)
  *
  *****************************************************************************/
 
-static void iwl_setup_deferred_work(struct iwl_priv *priv)
+void iwl_setup_deferred_work(struct iwl_priv *priv)
 {
 	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
 
@@ -1348,7 +1348,7 @@ static void iwl_free_geos(struct iwl_priv *priv)
 	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
 }
 
-static int iwl_init_drv(struct iwl_priv *priv)
+int iwl_init_drv(struct iwl_priv *priv)
 {
 	int ret;
 
@@ -1411,7 +1411,7 @@ err:
 	return ret;
 }
 
-static void iwl_uninit_drv(struct iwl_priv *priv)
+void iwl_uninit_drv(struct iwl_priv *priv)
 {
 	iwl_free_geos(priv);
 	iwl_free_channel_map(priv);
@@ -1424,7 +1424,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 #endif
 }
 
-static void iwl_set_hw_params(struct iwl_priv *priv)
+void iwl_set_hw_params(struct iwl_priv *priv)
 {
 	if (cfg(priv)->ht_params)
 		priv->hw_params.use_rts_for_aggregation =
@@ -1439,7 +1439,7 @@ static void iwl_set_hw_params(struct iwl_priv *priv)
 
 
 
-static void iwl_debug_config(struct iwl_priv *priv)
+void iwl_debug_config(struct iwl_priv *priv)
 {
 	dev_printk(KERN_INFO, trans(priv)->dev, "CONFIG_IWLWIFI_DEBUG "
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -1752,7 +1752,7 @@ out:
 	return op_mode;
 }
 
-static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
+void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
@@ -2217,7 +2217,7 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	}
 }
 
-static void iwl_nic_error(struct iwl_op_mode *op_mode)
+void iwl_nic_error(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
@@ -2230,7 +2230,7 @@ static void iwl_nic_error(struct iwl_op_mode *op_mode)
 	iwlagn_fw_error(priv, false);
 }
 
-static void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
+void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
@@ -2240,7 +2240,7 @@ static void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
 	}
 }
 
-static void iwl_nic_config(struct iwl_op_mode *op_mode)
+void iwl_nic_config(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
@@ -2255,7 +2255,7 @@ static void iwl_wimax_active(struct iwl_op_mode *op_mode)
 	IWL_ERR(priv, "RF is used by WiMAX\n");
 }
 
-static void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
+void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 	int ac = priv->queue_to_ac[queue];
@@ -2274,7 +2274,7 @@ static void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
 	ieee80211_stop_queue(priv->hw, ac);
 }
 
-static void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, int queue)
+void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 	int ac = priv->queue_to_ac[queue];
@@ -2314,7 +2314,7 @@ void iwlagn_lift_passive_no_rx(struct iwl_priv *priv)
 	priv->passive_no_rx = false;
 }
 
-static void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
+void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info;
 
@@ -2323,7 +2323,7 @@ static void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 
-static void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
+void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 4485a0c..a321b65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -495,4 +495,85 @@ do {									\
 } while (0)
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
+/* API method exported for mvm hybrid state */
+void iwl_setup_deferred_work(struct iwl_priv *priv);
+int iwl_send_wimax_coex(struct iwl_priv *priv);
+int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
+void iwl_debug_config(struct iwl_priv *priv);
+int iwl_alloc_traffic_mem(struct iwl_priv *priv);
+void iwl_set_hw_params(struct iwl_priv *priv);
+void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags);
+int iwl_init_drv(struct iwl_priv *priv);
+void iwl_uninit_drv(struct iwl_priv *priv);
+void iwl_send_bt_config(struct iwl_priv *priv);
+void iwl_rf_kill_ct_config(struct iwl_priv *priv);
+int iwl_setup_interface(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+void iwl_teardown_interface(struct iwl_priv *priv,
+			    struct ieee80211_vif *vif,
+			    bool mode_change);
+int iwl_full_rxon_required(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+void iwlagn_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+void iwlagn_check_needed_chains(struct iwl_priv *priv,
+				struct iwl_rxon_context *ctx,
+				struct ieee80211_bss_conf *bss_conf);
+void iwlagn_chain_noise_reset(struct iwl_priv *priv);
+int iwlagn_update_beacon(struct iwl_priv *priv,
+			 struct ieee80211_vif *vif);
+void iwl_tt_handler(struct iwl_priv *priv);
+void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode);
+void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue);
+void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state);
+void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb);
+void iwl_nic_error(struct iwl_op_mode *op_mode);
+void iwl_cmd_queue_full(struct iwl_op_mode *op_mode);
+void iwl_nic_config(struct iwl_op_mode *op_mode);
+int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
+		       struct ieee80211_sta *sta, bool set);
+void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
+			      enum ieee80211_rssi_event rssi_event);
+int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw);
+int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw);
+void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop);
+void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, int queue);
+void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
+			       struct ieee80211_channel_switch *ch_switch);
+int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta,
+			 enum ieee80211_sta_state old_state,
+			 enum ieee80211_sta_state new_state);
+int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    enum ieee80211_ampdu_mlme_action action,
+			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			    u8 buf_size);
+int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif,
+		       struct cfg80211_scan_request *req);
+void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   enum sta_notify_cmd cmd,
+			   struct ieee80211_sta *sta);
+void iwlagn_configure_filter(struct ieee80211_hw *hw,
+			     unsigned int changed_flags,
+			     unsigned int *total_flags,
+			     u64 multicast);
+int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif, u16 queue,
+		       const struct ieee80211_tx_queue_params *params);
+void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct cfg80211_gtk_rekey_data *data);
+void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_key_conf *keyconf,
+				struct ieee80211_sta *sta,
+				u32 iv32, u16 *phase1key);
+int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+		       struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta,
+		       struct ieee80211_key_conf *key);
+void iwlagn_mac_stop(struct ieee80211_hw *hw);
+void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
+int iwlagn_mac_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan);
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index d982493..3f82ff4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -333,7 +333,7 @@ static int iwlagn_mac_start(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static void iwlagn_mac_stop(struct ieee80211_hw *hw)
+void iwlagn_mac_stop(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -361,9 +361,9 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
-				      struct ieee80211_vif *vif,
-				      struct cfg80211_gtk_rekey_data *data)
+void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct cfg80211_gtk_rekey_data *data)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -389,8 +389,7 @@ static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 
 #ifdef CONFIG_PM_SLEEP
 
-static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
-			      struct cfg80211_wowlan *wowlan)
+int iwlagn_mac_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
@@ -499,7 +498,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 #endif
 
-static void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -510,21 +509,21 @@ static void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		dev_kfree_skb_any(skb);
 }
 
-static void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
-				       struct ieee80211_key_conf *keyconf,
-				       struct ieee80211_sta *sta,
-				       u32 iv32, u16 *phase1key)
+void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_key_conf *keyconf,
+				struct ieee80211_sta *sta,
+				u32 iv32, u16 *phase1key)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	iwl_update_tkip_key(priv, vif, keyconf, sta, iv32, phase1key);
 }
 
-static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-			      struct ieee80211_vif *vif,
-			      struct ieee80211_sta *sta,
-			      struct ieee80211_key_conf *key)
+int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+		       struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta,
+		       struct ieee80211_key_conf *key)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
@@ -624,11 +623,11 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
-static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif,
-				   enum ieee80211_ampdu_mlme_action action,
-				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				   u8 buf_size)
+int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    enum ieee80211_ampdu_mlme_action action,
+			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			    u8 buf_size)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret = -EINVAL;
@@ -750,11 +749,11 @@ static int iwlagn_mac_sta_remove(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_sta *sta,
-				enum ieee80211_sta_state old_state,
-				enum ieee80211_sta_state new_state)
+int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta,
+			 enum ieee80211_sta_state old_state,
+			 enum ieee80211_sta_state new_state)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
@@ -833,8 +832,8 @@ static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
-				struct ieee80211_channel_switch *ch_switch)
+void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
+			       struct ieee80211_channel_switch *ch_switch)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	const struct iwl_channel_info *ch_info;
@@ -929,10 +928,10 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 		ieee80211_chswitch_done(ctx->vif, is_success);
 }
 
-static void iwlagn_configure_filter(struct ieee80211_hw *hw,
-				    unsigned int changed_flags,
-				    unsigned int *total_flags,
-				    u64 multicast)
+void iwlagn_configure_filter(struct ieee80211_hw *hw,
+			     unsigned int changed_flags,
+			     unsigned int *total_flags,
+			     u64 multicast)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	__le32 filter_or = 0, filter_nand = 0;
@@ -979,7 +978,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
-static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
+void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -1106,7 +1105,7 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 	return err;
 }
 
-static int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
+int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -1123,8 +1122,8 @@ static int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
-			   enum ieee80211_rssi_event rssi_event)
+void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
+			      enum ieee80211_rssi_event rssi_event)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -1148,8 +1147,8 @@ static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
-			   struct ieee80211_sta *sta, bool set)
+int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
+		       struct ieee80211_sta *sta, bool set)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -1158,9 +1157,9 @@ static int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
-		    struct ieee80211_vif *vif, u16 queue,
-		    const struct ieee80211_tx_queue_params *params)
+int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif, u16 queue,
+		       const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
@@ -1202,7 +1201,7 @@ static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw)
+int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
@@ -1218,8 +1217,7 @@ static int iwl_set_mode(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	return iwlagn_commit_rxon(priv, ctx);
 }
 
-static int iwl_setup_interface(struct iwl_priv *priv,
-			       struct iwl_rxon_context *ctx)
+int iwl_setup_interface(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	struct ieee80211_vif *vif = ctx->vif;
 	int err;
@@ -1322,9 +1320,9 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	return err;
 }
 
-static void iwl_teardown_interface(struct iwl_priv *priv,
-				   struct ieee80211_vif *vif,
-				   bool mode_change)
+void iwl_teardown_interface(struct iwl_priv *priv,
+			    struct ieee80211_vif *vif,
+			    bool mode_change)
 {
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 
@@ -1465,9 +1463,9 @@ static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
 	return err;
 }
 
-static int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
-		    struct ieee80211_vif *vif,
-		    struct cfg80211_scan_request *req)
+int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif,
+		       struct cfg80211_scan_request *req)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret;
@@ -1522,7 +1520,7 @@ static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 	iwl_send_add_sta(priv, &cmd, CMD_ASYNC);
 }
 
-static void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
+void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
 			   struct ieee80211_vif *vif,
 			   enum sta_notify_cmd cmd,
 			   struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index e78f20e..5391719 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -178,7 +178,7 @@ int iwl_init_alive_start(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl_send_wimax_coex(struct iwl_priv *priv)
+int iwl_send_wimax_coex(struct iwl_priv *priv)
 {
 	struct iwl_wimax_coex_cmd coex_cmd;
 
-- 
1.7.0.4

