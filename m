Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36010 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537AbaJ2LvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:04 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so1100445wgh.39
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:02 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/25] iwlwifi: mvm: split wowlan handling out of the main suspend function
Date: Wed, 29 Oct 2014 13:50:25 +0200
Message-Id: <1414583446-11032-4-git-send-email-egrumbach@gmail.com> (sfid-20141029_125110_618171_3A305315)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Take the WoWLAN handling code out of the main suspend function,
dividing it into three parts: get_config (which is used before the
firmware is switched), switch_to_d3 (which handles the rebooting of
the hardware with the D3 firmware) and config (which configures the D3
firmware for WoWLAN operation).  This is necessary to prepare for the
net-detect implementation, which will use only the switch_to_d3 part
of this flow.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 266 +++++++++++++++++++---------------
 1 file changed, 151 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 5b26922..b8e8a97 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -783,6 +783,35 @@ void iwl_mvm_set_last_nonqos_seq(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		IWL_ERR(mvm, "failed to set non-QoS seqno\n");
 }
 
+static int iwl_mvm_switch_to_d3(struct iwl_mvm *mvm)
+{
+	iwl_mvm_cancel_scan(mvm);
+
+	iwl_trans_stop_device(mvm->trans);
+
+	/*
+	 * Set the HW restart bit -- this is mostly true as we're
+	 * going to load new firmware and reprogram that, though
+	 * the reprogramming is going to be manual to avoid adding
+	 * all the MACs that aren't support.
+	 * We don't have to clear up everything though because the
+	 * reprogramming is manual. When we resume, we'll actually
+	 * go through a proper restart sequence again to switch
+	 * back to the runtime firmware image.
+	 */
+	set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
+
+	/* We reprogram keys and shouldn't allocate new key indices */
+	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
+
+	mvm->ptk_ivlen = 0;
+	mvm->ptk_icvlen = 0;
+	mvm->ptk_ivlen = 0;
+	mvm->ptk_icvlen = 0;
+
+	return iwl_mvm_load_d3_fw(mvm);
+}
+
 static int
 iwl_mvm_send_wowlan_config_cmd(struct iwl_mvm *mvm,
 			       const struct iwl_wowlan_config_cmd_v3 *cmd)
@@ -797,116 +826,52 @@ iwl_mvm_send_wowlan_config_cmd(struct iwl_mvm *mvm,
 				    cmd_len, cmd);
 }
 
-static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
-			     struct cfg80211_wowlan *wowlan,
-			     bool test)
+static int
+iwl_mvm_get_wowlan_config(struct iwl_mvm *mvm,
+			  struct cfg80211_wowlan *wowlan,
+			  struct iwl_wowlan_config_cmd_v3 *wowlan_config_cmd,
+			  struct ieee80211_vif *vif, struct iwl_mvm_vif *mvmvif,
+			  struct ieee80211_sta *ap_sta)
 {
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	struct iwl_d3_iter_data suspend_iter_data = {
-		.mvm = mvm,
-	};
-	struct ieee80211_vif *vif;
-	struct iwl_mvm_vif *mvmvif;
-	struct ieee80211_sta *ap_sta;
-	struct iwl_mvm_sta *mvm_ap_sta;
-	struct iwl_wowlan_config_cmd_v3 wowlan_config_cmd = {};
-	struct iwl_wowlan_kek_kck_material_cmd kek_kck_cmd = {};
-	struct iwl_wowlan_tkip_params_cmd tkip_cmd = {};
-	struct iwl_d3_manager_config d3_cfg_cmd_data = {
-		/*
-		 * Program the minimum sleep time to 10 seconds, as many
-		 * platforms have issues processing a wakeup signal while
-		 * still being in the process of suspending.
-		 */
-		.min_sleep_time = cpu_to_le32(10 * 1000 * 1000),
-	};
-	struct iwl_host_cmd d3_cfg_cmd = {
-		.id = D3_CONFIG_CMD,
-		.flags = CMD_WANT_SKB,
-		.data[0] = &d3_cfg_cmd_data,
-		.len[0] = sizeof(d3_cfg_cmd_data),
-	};
-	struct wowlan_key_data key_data = {
-		.use_rsc_tsc = false,
-		.tkip = &tkip_cmd,
-		.use_tkip = false,
-	};
 	int ret;
-	int len __maybe_unused;
-
-	if (!wowlan) {
-		/*
-		 * mac80211 shouldn't get here, but for D3 test
-		 * it doesn't warrant a warning
-		 */
-		WARN_ON(!test);
-		return -EINVAL;
-	}
-
-	key_data.rsc_tsc = kzalloc(sizeof(*key_data.rsc_tsc), GFP_KERNEL);
-	if (!key_data.rsc_tsc)
-		return -ENOMEM;
-
-	mutex_lock(&mvm->mutex);
-
-	/* see if there's only a single BSS vif and it's associated */
-	ieee80211_iterate_active_interfaces_atomic(
-		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-		iwl_mvm_d3_iface_iterator, &suspend_iter_data);
+	struct iwl_mvm_sta *mvm_ap_sta = (struct iwl_mvm_sta *)ap_sta->drv_priv;
 
-	if (suspend_iter_data.error || !suspend_iter_data.vif) {
-		ret = 1;
-		goto out_noreset;
-	}
-
-	vif = suspend_iter_data.vif;
-	mvmvif = iwl_mvm_vif_from_mac80211(vif);
-
-	ap_sta = rcu_dereference_protected(
-			mvm->fw_id_to_mac_id[mvmvif->ap_sta_id],
-			lockdep_is_held(&mvm->mutex));
-	if (IS_ERR_OR_NULL(ap_sta)) {
-		ret = -EINVAL;
-		goto out_noreset;
-	}
+	/* TODO: wowlan_config_cmd->common.wowlan_ba_teardown_tids */
 
-	mvm_ap_sta = (struct iwl_mvm_sta *)ap_sta->drv_priv;
-
-	/* TODO: wowlan_config_cmd.common.wowlan_ba_teardown_tids */
-
-	wowlan_config_cmd.common.is_11n_connection =
+	wowlan_config_cmd->common.is_11n_connection =
 					ap_sta->ht_cap.ht_supported;
 
 	/* Query the last used seqno and set it */
 	ret = iwl_mvm_get_last_nonqos_seq(mvm, vif);
 	if (ret < 0)
-		goto out_noreset;
-	wowlan_config_cmd.common.non_qos_seq = cpu_to_le16(ret);
+		return ret;
+
+	wowlan_config_cmd->common.non_qos_seq = cpu_to_le16(ret);
 
-	iwl_mvm_set_wowlan_qos_seq(mvm_ap_sta, &wowlan_config_cmd.common);
+	iwl_mvm_set_wowlan_qos_seq(mvm_ap_sta, &wowlan_config_cmd->common);
 
 	if (wowlan->disconnect)
-		wowlan_config_cmd.common.wakeup_filter |=
+		wowlan_config_cmd->common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_BEACON_MISS |
 				    IWL_WOWLAN_WAKEUP_LINK_CHANGE);
 	if (wowlan->magic_pkt)
-		wowlan_config_cmd.common.wakeup_filter |=
+		wowlan_config_cmd->common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_MAGIC_PACKET);
 	if (wowlan->gtk_rekey_failure)
-		wowlan_config_cmd.common.wakeup_filter |=
+		wowlan_config_cmd->common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_GTK_REKEY_FAIL);
 	if (wowlan->eap_identity_req)
-		wowlan_config_cmd.common.wakeup_filter |=
+		wowlan_config_cmd->common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_EAP_IDENT_REQ);
 	if (wowlan->four_way_handshake)
-		wowlan_config_cmd.common.wakeup_filter |=
+		wowlan_config_cmd->common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_4WAY_HANDSHAKE);
 	if (wowlan->n_patterns)
-		wowlan_config_cmd.common.wakeup_filter |=
+		wowlan_config_cmd->common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_PATTERN_MATCH);
 
 	if (wowlan->rfkill_release)
-		wowlan_config_cmd.common.wakeup_filter |=
+		wowlan_config_cmd->common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_RF_KILL_DEASSERT);
 
 	if (wowlan->tcp) {
@@ -914,44 +879,39 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 		 * Set the "link change" (really "link lost") flag as well
 		 * since that implies losing the TCP connection.
 		 */
-		wowlan_config_cmd.common.wakeup_filter |=
+		wowlan_config_cmd->common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_REMOTE_LINK_LOSS |
 				    IWL_WOWLAN_WAKEUP_REMOTE_SIGNATURE_TABLE |
 				    IWL_WOWLAN_WAKEUP_REMOTE_WAKEUP_PACKET |
 				    IWL_WOWLAN_WAKEUP_LINK_CHANGE);
 	}
 
-	iwl_mvm_cancel_scan(mvm);
-
-	iwl_trans_stop_device(mvm->trans);
-
-	/*
-	 * Set the HW restart bit -- this is mostly true as we're
-	 * going to load new firmware and reprogram that, though
-	 * the reprogramming is going to be manual to avoid adding
-	 * all the MACs that aren't support.
-	 * We don't have to clear up everything though because the
-	 * reprogramming is manual. When we resume, we'll actually
-	 * go through a proper restart sequence again to switch
-	 * back to the runtime firmware image.
-	 */
-	set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
-
-	/* We reprogram keys and shouldn't allocate new key indices */
-	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
-
-	mvm->ptk_ivlen = 0;
-	mvm->ptk_icvlen = 0;
-	mvm->ptk_ivlen = 0;
-	mvm->ptk_icvlen = 0;
+	return 0;
+}
 
-	ret = iwl_mvm_load_d3_fw(mvm);
-	if (ret)
-		goto out;
+static int
+iwl_mvm_wowlan_config(struct iwl_mvm *mvm,
+		      struct cfg80211_wowlan *wowlan,
+		      struct iwl_wowlan_config_cmd_v3 *wowlan_config_cmd,
+		      struct ieee80211_vif *vif, struct iwl_mvm_vif *mvmvif,
+		      struct ieee80211_sta *ap_sta)
+{
+	struct iwl_wowlan_kek_kck_material_cmd kek_kck_cmd = {};
+	struct iwl_wowlan_tkip_params_cmd tkip_cmd = {};
+	struct wowlan_key_data key_data = {
+		.use_rsc_tsc = false,
+		.tkip = &tkip_cmd,
+		.use_tkip = false,
+	};
+	int ret;
 
 	ret = iwl_mvm_d3_reprogram(mvm, vif, ap_sta);
 	if (ret)
-		goto out;
+		return ret;
+
+	key_data.rsc_tsc = kzalloc(sizeof(*key_data.rsc_tsc), GFP_KERNEL);
+	if (!key_data.rsc_tsc)
+		return -ENOMEM;
 
 	if (!iwlwifi_mod_params.sw_crypto) {
 		/*
@@ -1010,7 +970,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 		}
 	}
 
-	ret = iwl_mvm_send_wowlan_config_cmd(mvm, &wowlan_config_cmd);
+	ret = iwl_mvm_send_wowlan_config_cmd(mvm, wowlan_config_cmd);
 	if (ret)
 		goto out;
 
@@ -1023,6 +983,84 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 		goto out;
 
 	ret = iwl_mvm_send_remote_wake_cfg(mvm, vif, wowlan->tcp);
+
+out:
+	kfree(key_data.rsc_tsc);
+	return ret;
+}
+
+static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
+			     struct cfg80211_wowlan *wowlan,
+			     bool test)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_d3_iter_data suspend_iter_data = {
+		.mvm = mvm,
+	};
+	struct ieee80211_vif *vif = NULL;
+	struct iwl_mvm_vif *mvmvif = NULL;
+	struct ieee80211_sta *ap_sta = NULL;
+	struct iwl_wowlan_config_cmd_v3 wowlan_config_cmd = {};
+	struct iwl_d3_manager_config d3_cfg_cmd_data = {
+		/*
+		 * Program the minimum sleep time to 10 seconds, as many
+		 * platforms have issues processing a wakeup signal while
+		 * still being in the process of suspending.
+		 */
+		.min_sleep_time = cpu_to_le32(10 * 1000 * 1000),
+	};
+	struct iwl_host_cmd d3_cfg_cmd = {
+		.id = D3_CONFIG_CMD,
+		.flags = CMD_WANT_SKB,
+		.data[0] = &d3_cfg_cmd_data,
+		.len[0] = sizeof(d3_cfg_cmd_data),
+	};
+	int ret;
+	int len __maybe_unused;
+
+	if (!wowlan) {
+		/*
+		 * mac80211 shouldn't get here, but for D3 test
+		 * it doesn't warrant a warning
+		 */
+		WARN_ON(!test);
+		return -EINVAL;
+	}
+
+	mutex_lock(&mvm->mutex);
+
+	/* see if there's only a single BSS vif and it's associated */
+	ieee80211_iterate_active_interfaces_atomic(
+		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+		iwl_mvm_d3_iface_iterator, &suspend_iter_data);
+
+	if (suspend_iter_data.error || !suspend_iter_data.vif) {
+		ret = 1;
+		goto out_noreset;
+	}
+
+	vif = suspend_iter_data.vif;
+	mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	ap_sta = rcu_dereference_protected(
+		mvm->fw_id_to_mac_id[mvmvif->ap_sta_id],
+		lockdep_is_held(&mvm->mutex));
+	if (IS_ERR_OR_NULL(ap_sta)) {
+		ret = -EINVAL;
+		goto out_noreset;
+	}
+
+	ret = iwl_mvm_get_wowlan_config(mvm, wowlan, &wowlan_config_cmd, vif,
+					mvmvif, ap_sta);
+	if (ret)
+		goto out_noreset;
+
+	ret = iwl_mvm_switch_to_d3(mvm);
+	if (ret)
+		goto out;
+
+	ret = iwl_mvm_wowlan_config(mvm, wowlan, &wowlan_config_cmd,
+				    vif, mvmvif, ap_sta);
 	if (ret)
 		goto out;
 
@@ -1060,8 +1098,6 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	if (ret < 0)
 		ieee80211_restart_hw(mvm->hw);
  out_noreset:
-	kfree(key_data.rsc_tsc);
-
 	mutex_unlock(&mvm->mutex);
 
 	return ret;
-- 
1.9.1

