Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52449 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaCROqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:33 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so5479502eei.14
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:32 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/35] iwlwifi: mvm: reconfigure qos seq on D0i3 exit
Date: Tue, 18 Mar 2014 16:45:29 +0200
Message-Id: <1395153939-23897-25-git-send-email-egrumbach@gmail.com> (sfid-20140318_154659_709989_FE1D706B)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

In order to restore the qos seq number on d0i3 exit,
we need to read it from the wowlan status.

However, in order to make sure we use correct seq num
for tx frames, we need to defer any outgoing frames,
and re-enqueue them only after the seq num is configured
correctly.

Sync new Tx aggregations with D0i3 so that the correct
seq num is used for them. Wait synchronously for D0i3
exit before starting a new Tx agg.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  69 +++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   9 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c      | 132 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/sta.c      |  10 ++-
 4 files changed, 219 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 66760e0..48a8e67 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -424,6 +424,47 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	return ret;
 }
 
+static bool iwl_mvm_defer_tx(struct iwl_mvm *mvm,
+			     struct ieee80211_sta *sta,
+			     struct sk_buff *skb)
+{
+	struct iwl_mvm_sta *mvmsta;
+	bool defer = false;
+
+	/*
+	 * double check the IN_D0I3 flag both before and after
+	 * taking the spinlock, in order to prevent taking
+	 * the spinlock when not needed.
+	 */
+	if (likely(!test_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status)))
+		return false;
+
+	spin_lock(&mvm->d0i3_tx_lock);
+	/*
+	 * testing the flag again ensures the skb dequeue
+	 * loop (on d0i3 exit) hasn't run yet.
+	 */
+	if (!test_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status))
+		goto out;
+
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	if (mvmsta->sta_id == IWL_MVM_STATION_COUNT ||
+	    mvmsta->sta_id != mvm->d0i3_ap_sta_id)
+		goto out;
+
+	__skb_queue_tail(&mvm->d0i3_tx, skb);
+	ieee80211_stop_queues(mvm->hw);
+
+	/* trigger wakeup */
+	iwl_mvm_ref(mvm, IWL_MVM_REF_TX);
+	iwl_mvm_unref(mvm, IWL_MVM_REF_TX);
+
+	defer = true;
+out:
+	spin_unlock(&mvm->d0i3_tx_lock);
+	return defer;
+}
+
 static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 			   struct ieee80211_tx_control *control,
 			   struct sk_buff *skb)
@@ -451,6 +492,8 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 		sta = NULL;
 
 	if (sta) {
+		if (iwl_mvm_defer_tx(mvm, sta, skb))
+			return;
 		if (iwl_mvm_tx_skb(mvm, skb, sta))
 			goto drop;
 		return;
@@ -471,6 +514,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
+	bool tx_agg_ref = false;
 
 	IWL_DEBUG_HT(mvm, "A-MPDU action on addr %pM tid %d: action %d\n",
 		     sta->addr, tid, action);
@@ -478,6 +522,23 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 	if (!(mvm->nvm_data->sku_cap_11n_enable))
 		return -EACCES;
 
+	/* return from D0i3 before starting a new Tx aggregation */
+	if (action == IEEE80211_AMPDU_TX_START) {
+		iwl_mvm_ref(mvm, IWL_MVM_REF_TX_AGG);
+		tx_agg_ref = true;
+
+		/*
+		 * wait synchronously until D0i3 exit to get the correct
+		 * sequence number for the tid
+		 */
+		if (!wait_event_timeout(mvm->d0i3_exit_waitq,
+			  !test_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status), HZ)) {
+			WARN_ON_ONCE(1);
+			iwl_mvm_unref(mvm, IWL_MVM_REF_TX_AGG);
+			return -EIO;
+		}
+	}
+
 	mutex_lock(&mvm->mutex);
 
 	switch (action) {
@@ -515,6 +576,13 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 	}
 	mutex_unlock(&mvm->mutex);
 
+	/*
+	 * If the tid is marked as started, we won't use it for offloaded
+	 * traffic on the next D0i3 entry. It's safe to unref.
+	 */
+	if (tx_agg_ref)
+		iwl_mvm_unref(mvm, IWL_MVM_REF_TX_AGG);
+
 	return ret;
 }
 
@@ -592,6 +660,7 @@ static void iwl_mvm_mac_restart_complete(struct ieee80211_hw *hw)
 	mutex_lock(&mvm->mutex);
 
 	clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
+	iwl_mvm_d0i3_enable_tx(mvm, NULL);
 	ret = iwl_mvm_update_quotas(mvm, NULL);
 	if (ret)
 		IWL_ERR(mvm, "Failed to update quotas after restart (%d)\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 095bc26..d4f3c95 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -230,6 +230,8 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_P2P_CLIENT,
 	IWL_MVM_REF_AP_IBSS,
 	IWL_MVM_REF_USER,
+	IWL_MVM_REF_TX,
+	IWL_MVM_REF_TX_AGG,
 
 	IWL_MVM_REF_COUNT,
 };
@@ -593,7 +595,12 @@ struct iwl_mvm {
 
 	/* d0i3 */
 	u8 d0i3_ap_sta_id;
+	bool d0i3_offloading;
 	struct work_struct d0i3_exit_work;
+	struct sk_buff_head d0i3_tx;
+	/* sync d0i3_tx queue and IWL_MVM_STATUS_IN_D0I3 status flag */
+	spinlock_t d0i3_tx_lock;
+	wait_queue_head_t d0i3_exit_waitq;
 
 	/* BT-Coex */
 	u8 bt_kill_msk;
@@ -634,6 +641,7 @@ enum iwl_mvm_status {
 	IWL_MVM_STATUS_HW_CTKILL,
 	IWL_MVM_STATUS_ROC_RUNNING,
 	IWL_MVM_STATUS_IN_HW_RESTART,
+	IWL_MVM_STATUS_IN_D0I3,
 };
 
 static inline bool iwl_mvm_is_radio_killed(struct iwl_mvm *mvm)
@@ -903,6 +911,7 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 /* D0i3 */
 void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
+void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq);
 
 /* BT Coex */
 int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 87c32e8..a3e21f1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -410,6 +410,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_WORK(&mvm->sta_drained_wk, iwl_mvm_sta_drained_wk);
 	INIT_WORK(&mvm->d0i3_exit_work, iwl_mvm_d0i3_exit_work);
 
+	spin_lock_init(&mvm->d0i3_tx_lock);
+	skb_queue_head_init(&mvm->d0i3_tx);
+	init_waitqueue_head(&mvm->d0i3_exit_waitq);
+
 	SET_IEEE80211_DEV(mvm->hw, mvm->trans->dev);
 
 	/*
@@ -823,8 +827,62 @@ struct iwl_d0i3_iter_data {
 	struct iwl_mvm *mvm;
 	u8 ap_sta_id;
 	u8 vif_count;
+	u8 offloading_tid;
+	bool disable_offloading;
 };
 
+static bool iwl_mvm_disallow_offloading(struct iwl_mvm *mvm,
+					struct ieee80211_vif *vif,
+					struct iwl_d0i3_iter_data *iter_data)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct ieee80211_sta *ap_sta;
+	struct iwl_mvm_sta *mvmsta;
+	u32 available_tids = 0;
+	u8 tid;
+
+	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION ||
+		    mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT))
+		return false;
+
+	ap_sta = rcu_dereference(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id]);
+	if (IS_ERR_OR_NULL(ap_sta))
+		return false;
+
+	mvmsta = iwl_mvm_sta_from_mac80211(ap_sta);
+	spin_lock_bh(&mvmsta->lock);
+	for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++) {
+		struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
+
+		/*
+		 * in case of pending tx packets, don't use this tid
+		 * for offloading in order to prevent reuse of the same
+		 * qos seq counters.
+		 */
+		if (iwl_mvm_tid_queued(tid_data))
+			continue;
+
+		if (tid_data->state != IWL_AGG_OFF)
+			continue;
+
+		available_tids |= BIT(tid);
+	}
+	spin_unlock_bh(&mvmsta->lock);
+
+	/*
+	 * disallow protocol offloading if we have no available tid
+	 * (with no pending frames and no active aggregation,
+	 * as we don't handle "holes" properly - the scheduler needs the
+	 * frame's seq number and TFD index to match)
+	 */
+	if (!available_tids)
+		return true;
+
+	/* for simplicity, just use the first available tid */
+	iter_data->offloading_tid = ffs(available_tids) - 1;
+	return false;
+}
+
 static void iwl_mvm_enter_d0i3_iterator(void *_data, u8 *mac,
 					struct ieee80211_vif *vif)
 {
@@ -838,6 +896,14 @@ static void iwl_mvm_enter_d0i3_iterator(void *_data, u8 *mac,
 	    !vif->bss_conf.assoc)
 		return;
 
+	/*
+	 * in case of pending tx packets or active aggregations,
+	 * avoid offloading features in order to prevent reuse of
+	 * the same qos seq counters.
+	 */
+	if (iwl_mvm_disallow_offloading(mvm, vif, data))
+		data->disable_offloading = true;
+
 	iwl_mvm_update_d0i3_power_mode(mvm, vif, true, flags);
 
 	/*
@@ -868,6 +934,7 @@ static void iwl_mvm_set_wowlan_data(struct iwl_mvm *mvm,
 
 	mvm_ap_sta = iwl_mvm_sta_from_mac80211(ap_sta);
 	cmd->common.is_11n_connection = ap_sta->ht_cap.ht_supported;
+	cmd->offloading_tid = iter_data->offloading_tid;
 
 	/*
 	 * The d0i3 uCode takes care of the nonqos counters,
@@ -900,15 +967,21 @@ static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 
 	IWL_DEBUG_RPM(mvm, "MVM entering D0i3\n");
 
+	/* make sure we have no running tx while configuring the qos */
+	set_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status);
+	synchronize_net();
+
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 						   IEEE80211_IFACE_ITER_NORMAL,
 						   iwl_mvm_enter_d0i3_iterator,
 						   &d0i3_iter_data);
 	if (d0i3_iter_data.vif_count == 1) {
 		mvm->d0i3_ap_sta_id = d0i3_iter_data.ap_sta_id;
+		mvm->d0i3_offloading = !d0i3_iter_data.disable_offloading;
 	} else {
 		WARN_ON_ONCE(d0i3_iter_data.vif_count > 1);
 		mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
+		mvm->d0i3_offloading = false;
 	}
 
 	iwl_mvm_set_wowlan_data(mvm, &wowlan_config_cmd, &d0i3_iter_data);
@@ -948,6 +1021,62 @@ static void iwl_mvm_d0i3_disconnect_iter(void *data, u8 *mac,
 		ieee80211_connection_loss(vif);
 }
 
+void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq)
+{
+	struct ieee80211_sta *sta = NULL;
+	struct iwl_mvm_sta *mvm_ap_sta;
+	int i;
+	bool wake_queues = false;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	spin_lock_bh(&mvm->d0i3_tx_lock);
+
+	if (mvm->d0i3_ap_sta_id == IWL_MVM_STATION_COUNT)
+		goto out;
+
+	IWL_DEBUG_RPM(mvm, "re-enqueue packets\n");
+
+	/* get the sta in order to update seq numbers and re-enqueue skbs */
+	sta = rcu_dereference_protected(
+			mvm->fw_id_to_mac_id[mvm->d0i3_ap_sta_id],
+			lockdep_is_held(&mvm->mutex));
+
+	if (IS_ERR_OR_NULL(sta)) {
+		sta = NULL;
+		goto out;
+	}
+
+	if (mvm->d0i3_offloading && qos_seq) {
+		/* update qos seq numbers if offloading was enabled */
+		mvm_ap_sta = (struct iwl_mvm_sta *)sta->drv_priv;
+		for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
+			u16 seq = le16_to_cpu(qos_seq[i]);
+			/* firmware stores last-used one, we store next one */
+			seq += 0x10;
+			mvm_ap_sta->tid_data[i].seq_number = seq;
+		}
+	}
+out:
+	/* re-enqueue (or drop) all packets */
+	while (!skb_queue_empty(&mvm->d0i3_tx)) {
+		struct sk_buff *skb = __skb_dequeue(&mvm->d0i3_tx);
+
+		if (!sta || iwl_mvm_tx_skb(mvm, skb, sta))
+			ieee80211_free_txskb(mvm->hw, skb);
+
+		/* if the skb_queue is not empty, we need to wake queues */
+		wake_queues = true;
+	}
+	clear_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status);
+	wake_up(&mvm->d0i3_exit_waitq);
+	mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
+	if (wake_queues)
+		ieee80211_wake_queues(mvm->hw);
+
+	spin_unlock_bh(&mvm->d0i3_tx_lock);
+}
+
 static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 {
 	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm, d0i3_exit_work);
@@ -958,6 +1087,7 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 	struct iwl_wowlan_status_v6 *status;
 	int ret;
 	u32 disconnection_reasons, wakeup_reasons;
+	__le16 *qos_seq = NULL;
 
 	mutex_lock(&mvm->mutex);
 	ret = iwl_mvm_send_cmd(mvm, &get_status_cmd);
@@ -969,6 +1099,7 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 
 	status = (void *)get_status_cmd.resp_pkt->data;
 	wakeup_reasons = le32_to_cpu(status->wakeup_reasons);
+	qos_seq = status->qos_seq_ctr;
 
 	IWL_DEBUG_RPM(mvm, "wakeup reasons: 0x%x\n", wakeup_reasons);
 
@@ -982,6 +1113,7 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 
 	iwl_free_resp(&get_status_cmd);
 out:
+	iwl_mvm_d0i3_enable_tx(mvm, qos_seq);
 	mutex_unlock(&mvm->mutex);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 6739353..f339ef8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -902,10 +902,18 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return -EIO;
 	}
 
+	spin_lock_bh(&mvmsta->lock);
+
+	/* possible race condition - we entered D0i3 while starting agg */
+	if (test_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status)) {
+		spin_unlock_bh(&mvmsta->lock);
+		IWL_ERR(mvm, "Entered D0i3 while starting Tx agg\n");
+		return -EIO;
+	}
+
 	/* the new tx queue is still connected to the same mac80211 queue */
 	mvm->queue_to_mac80211[txq_id] = vif->hw_queue[tid_to_mac80211_ac[tid]];
 
-	spin_lock_bh(&mvmsta->lock);
 	tid_data = &mvmsta->tid_data[tid];
 	tid_data->ssn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
 	tid_data->txq_id = txq_id;
-- 
1.8.3.2

