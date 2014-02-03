Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:34512 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaBCU7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:34 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so3911196eek.13
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:32 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 46/62] iwlwifi: mvm: get status on D0i3 exit
Date: Mon,  3 Feb 2014 22:57:52 +0200
Message-Id: <1391461088-8082-46-git-send-email-egrumbach@gmail.com> (sfid-20140203_220006_745803_AEC22B8A)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Schedule work to query the wakeup reasons, and
disconnect in some cases (e.g. beacon loss).

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    5 ++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    4 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c      |   79 +++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/sta.c      |    4 ++
 4 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 827510e..59b5b7a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -547,6 +547,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 		iwl_mvm_cleanup_iterator, mvm);
 
 	mvm->p2p_device_vif = NULL;
+	mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
 
 	iwl_mvm_reset_phy_ctxts(mvm);
 	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
@@ -602,6 +603,7 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
+	flush_work(&mvm->d0i3_exit_work);
 	flush_work(&mvm->async_handlers_wk);
 
 	mutex_lock(&mvm->mutex);
@@ -1216,6 +1218,9 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 			ret = iwl_mvm_rm_sta_id(mvm, vif, mvmvif->ap_sta_id);
 			if (ret)
 				IWL_ERR(mvm, "failed to remove AP station\n");
+
+			if (mvm->d0i3_ap_sta_id == mvmvif->ap_sta_id)
+				mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
 			mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
 			/* remove quota for this interface */
 			ret = iwl_mvm_update_quotas(mvm, NULL);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index fe3896c..f396607 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -577,6 +577,10 @@ struct iwl_mvm {
 #endif
 #endif
 
+	/* d0i3 */
+	u8 d0i3_ap_sta_id;
+	struct work_struct d0i3_exit_work;
+
 	/* BT-Coex */
 	u8 bt_kill_msk;
 	struct iwl_bt_coex_profile_notif last_bt_notif;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 12b81ca..4b7fa7a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -326,6 +326,7 @@ static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
 
 /* this forward declaration can avoid to export the function */
 static void iwl_mvm_async_handlers_wk(struct work_struct *wk);
+static void iwl_mvm_d0i3_exit_work(struct work_struct *wk);
 
 static u32 calc_min_backoff(struct iwl_trans *trans, const struct iwl_cfg *cfg)
 {
@@ -404,6 +405,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_WORK(&mvm->async_handlers_wk, iwl_mvm_async_handlers_wk);
 	INIT_WORK(&mvm->roc_done_wk, iwl_mvm_roc_done_wk);
 	INIT_WORK(&mvm->sta_drained_wk, iwl_mvm_sta_drained_wk);
+	INIT_WORK(&mvm->d0i3_exit_work, iwl_mvm_d0i3_exit_work);
 
 	SET_IEEE80211_DEV(mvm->hw, mvm->trans->dev);
 
@@ -819,10 +821,18 @@ static void iwl_mvm_cmd_queue_full(struct iwl_op_mode *op_mode)
 	iwl_mvm_nic_restart(mvm);
 }
 
+struct iwl_d0i3_iter_data {
+	struct iwl_mvm *mvm;
+	u8 ap_sta_id;
+	u8 vif_count;
+};
+
 static void iwl_mvm_enter_d0i3_iterator(void *_data, u8 *mac,
 					struct ieee80211_vif *vif)
 {
-	struct iwl_mvm *mvm = _data;
+	struct iwl_d0i3_iter_data *data = _data;
+	struct iwl_mvm *mvm = data->mvm;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE;
 
 	IWL_DEBUG_RPM(mvm, "entering D0i3 - vif %pM\n", vif->addr);
@@ -838,6 +848,8 @@ static void iwl_mvm_enter_d0i3_iterator(void *_data, u8 *mac,
 	 * reconfigure them (we might want to use different
 	 * params later on, though).
 	 */
+	data->ap_sta_id = mvmvif->ap_sta_id;
+	data->vif_count++;
 }
 
 static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
@@ -845,6 +857,9 @@ static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE;
 	int ret;
+	struct iwl_d0i3_iter_data d0i3_iter_data = {
+		.mvm = mvm,
+	};
 	struct iwl_wowlan_config_cmd wowlan_config_cmd = {
 		.wakeup_filter = cpu_to_le32(IWL_WOWLAN_WAKEUP_RX_FRAME |
 					     IWL_WOWLAN_WAKEUP_BEACON_MISS |
@@ -860,7 +875,13 @@ static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 						   IEEE80211_IFACE_ITER_NORMAL,
 						   iwl_mvm_enter_d0i3_iterator,
-						   mvm);
+						   &d0i3_iter_data);
+	if (d0i3_iter_data.vif_count == 1) {
+		mvm->d0i3_ap_sta_id = d0i3_iter_data.ap_sta_id;
+	} else {
+		WARN_ON_ONCE(d0i3_iter_data.vif_count > 1);
+		mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
+	}
 
 	ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, flags,
 				   sizeof(wowlan_config_cmd),
@@ -887,6 +908,54 @@ static void iwl_mvm_exit_d0i3_iterator(void *_data, u8 *mac,
 	iwl_mvm_update_d0i3_power_mode(mvm, vif, false, flags);
 }
 
+static void iwl_mvm_d0i3_disconnect_iter(void *data, u8 *mac,
+					 struct ieee80211_vif *vif)
+{
+	struct iwl_mvm *mvm = data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (vif->type == NL80211_IFTYPE_STATION && vif->bss_conf.assoc &&
+	    mvm->d0i3_ap_sta_id == mvmvif->ap_sta_id)
+		ieee80211_connection_loss(vif);
+}
+
+static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
+{
+	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm, d0i3_exit_work);
+	struct iwl_host_cmd get_status_cmd = {
+		.id = WOWLAN_GET_STATUSES,
+		.flags = CMD_SYNC | CMD_HIGH_PRIO | CMD_WANT_SKB,
+	};
+	struct iwl_wowlan_status_v6 *status;
+	int ret;
+	u32 disconnection_reasons, wakeup_reasons;
+
+	mutex_lock(&mvm->mutex);
+	ret = iwl_mvm_send_cmd(mvm, &get_status_cmd);
+	if (ret)
+		goto out;
+
+	if (!get_status_cmd.resp_pkt)
+		goto out;
+
+	status = (void *)get_status_cmd.resp_pkt->data;
+	wakeup_reasons = le32_to_cpu(status->wakeup_reasons);
+
+	IWL_DEBUG_RPM(mvm, "wakeup reasons: 0x%x\n", wakeup_reasons);
+
+	disconnection_reasons =
+		IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_MISSED_BEACON |
+		IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_DEAUTH;
+	if (wakeup_reasons & disconnection_reasons)
+		ieee80211_iterate_active_interfaces(
+			mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+			iwl_mvm_d0i3_disconnect_iter, mvm);
+
+	iwl_free_resp(&get_status_cmd);
+out:
+	mutex_unlock(&mvm->mutex);
+}
+
 static int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
@@ -898,13 +967,15 @@ static int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
 
 	ret = iwl_mvm_send_cmd_pdu(mvm, D0I3_END_CMD, flags, 0, NULL);
 	if (ret)
-		return ret;
+		goto out;
 
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 						   IEEE80211_IFACE_ITER_NORMAL,
 						   iwl_mvm_exit_d0i3_iterator,
 						   mvm);
-	return 0;
+out:
+	schedule_work(&mvm->d0i3_exit_work);
+	return ret;
 }
 
 static const struct iwl_op_mode_ops iwl_mvm_ops = {
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index af94f75..fb416c5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -522,6 +522,10 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 
 		/* unassoc - go ahead - remove the AP STA now */
 		mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
+
+		/* clear d0i3_ap_sta_id if no longer relevant */
+		if (mvm->d0i3_ap_sta_id == mvm_sta->sta_id)
+			mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
 	}
 
 	/*
-- 
1.7.9.5

