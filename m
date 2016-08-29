Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40952 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756370AbcH2V0f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 17:26:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 00:26:04 +0300
Message-Id: <1472505976-21108-4-git-send-email-luca@coelho.fi> (sfid-20160829_233018_039396_723DEB02)
In-Reply-To: <1472505976-21108-1-git-send-email-luca@coelho.fi>
References: <1472505827.27868.41.camel@coelho.fi>
 <1472505976-21108-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 04/16] iwlwifi: mvm: re-aggregate shared queue after unsharing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When a shared queue becomes unshared, aggregations should be
re-enabled if they've existed before. Make sure that they do
this, if required.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h   |  17 +++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c   | 162 +++++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h   |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c    |  38 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c |   8 +-
 5 files changed, 203 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 28ebc12..ee5a9ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -697,6 +697,10 @@ struct iwl_mvm_baid_data {
  *	it. In this state, when a new queue is needed to be allocated but no
  *	such free queue exists, an inactive queue might be freed and given to
  *	the new RA/TID.
+ * @IWL_MVM_QUEUE_RECONFIGURING: queue is being reconfigured
+ *	This is the state of a queue that has had traffic pass through it, but
+ *	needs to be reconfigured for some reason, e.g. the queue needs to
+ *	become unshared and aggregations re-enabled on.
  */
 enum iwl_mvm_queue_status {
 	IWL_MVM_QUEUE_FREE,
@@ -704,6 +708,7 @@ enum iwl_mvm_queue_status {
 	IWL_MVM_QUEUE_READY,
 	IWL_MVM_QUEUE_SHARED,
 	IWL_MVM_QUEUE_INACTIVE,
+	IWL_MVM_QUEUE_RECONFIGURING,
 };
 
 #define IWL_MVM_DQA_QUEUE_TIMEOUT	(5 * HZ)
@@ -1122,6 +1127,18 @@ static inline bool iwl_mvm_enter_d0i3_on_suspend(struct iwl_mvm *mvm)
 		(mvm->trans->runtime_pm_mode != IWL_PLAT_PM_MODE_D0I3);
 }
 
+static inline bool iwl_mvm_is_dqa_data_queue(struct iwl_mvm *mvm, u8 queue)
+{
+	return (queue >= IWL_MVM_DQA_MIN_DATA_QUEUE) &&
+	       (queue <= IWL_MVM_DQA_MAX_DATA_QUEUE);
+}
+
+static inline bool iwl_mvm_is_dqa_mgmt_queue(struct iwl_mvm *mvm, u8 queue)
+{
+	return (queue >= IWL_MVM_DQA_MIN_MGMT_QUEUE) &&
+	       (queue <= IWL_MVM_DQA_MAX_MGMT_QUEUE);
+}
+
 static inline bool iwl_mvm_is_lar_supported(struct iwl_mvm *mvm)
 {
 	bool nvm_lar = mvm->nvm_data->lar_enabled;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 5960eb4..e3257d0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -468,6 +468,11 @@ static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
 		    i != IWL_MVM_DQA_BSS_CLIENT_QUEUE)
 			continue;
 
+		/* Don't try and take queues being reconfigured */
+		if (mvm->queue_info[queue].status ==
+		    IWL_MVM_QUEUE_RECONFIGURING)
+			continue;
+
 		ac_to_queue[mvm->queue_info[i].mac80211_ac] = i;
 	}
 
@@ -501,27 +506,33 @@ static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
 		queue = ac_to_queue[IEEE80211_AC_VO];
 
 	/* Make sure queue found (or not) is legal */
-	if (!((queue >= IWL_MVM_DQA_MIN_MGMT_QUEUE &&
-	       queue <= IWL_MVM_DQA_MAX_MGMT_QUEUE) ||
-	      (queue >= IWL_MVM_DQA_MIN_DATA_QUEUE &&
-	       queue <= IWL_MVM_DQA_MAX_DATA_QUEUE) ||
-	      (queue == IWL_MVM_DQA_BSS_CLIENT_QUEUE))) {
+	if (!iwl_mvm_is_dqa_data_queue(mvm, queue) &&
+	    !iwl_mvm_is_dqa_mgmt_queue(mvm, queue) &&
+	    (queue != IWL_MVM_DQA_BSS_CLIENT_QUEUE)) {
 		IWL_ERR(mvm, "No DATA queues available to share\n");
 		queue = -ENOSPC;
 	}
 
+	/* Make sure the queue isn't in the middle of being reconfigured */
+	if (mvm->queue_info[queue].status == IWL_MVM_QUEUE_RECONFIGURING) {
+		IWL_ERR(mvm,
+			"TXQ %d is in the middle of re-config - try again\n",
+			queue);
+		queue = -1;
+	}
+
 	return queue;
 }
 
 /*
- * If a given queue has a higher AC than the TID stream that is being added to
- * it, the queue needs to be redirected to the lower AC. This function does that
+ * If a given queue has a higher AC than the TID stream that is being compared
+ * to, the queue needs to be redirected to the lower AC. This function does that
  * in such a case, otherwise - if no redirection required - it does nothing,
  * unless the %force param is true.
  */
-static int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
-				      int ac, int ssn, unsigned int wdg_timeout,
-				      bool force)
+int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
+			       int ac, int ssn, unsigned int wdg_timeout,
+			       bool force)
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
@@ -555,7 +566,7 @@ static int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 	shared_queue = (mvm->queue_info[queue].hw_queue_refcount > 1);
 	spin_unlock_bh(&mvm->queue_info_lock);
 
-	IWL_DEBUG_TX_QUEUES(mvm, "Redirecting shared TXQ #%d to FIFO #%d\n",
+	IWL_DEBUG_TX_QUEUES(mvm, "Redirecting TXQ #%d to FIFO #%d\n",
 			    queue, iwl_mvm_ac_to_tx_fifo[ac]);
 
 	/* Stop MAC queues and wait for this queue to empty */
@@ -827,6 +838,84 @@ out_err:
 	return ret;
 }
 
+static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
+{
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
+	s8 sta_id;
+	int tid = -1;
+	unsigned long tid_bitmap;
+	unsigned int wdg_timeout;
+	int ssn;
+	int ret = true;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	sta_id = mvm->queue_info[queue].ra_sta_id;
+	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	/* Find TID for queue, and make sure it is the only one on the queue */
+	tid = find_first_bit(&tid_bitmap, IWL_MAX_TID_COUNT + 1);
+	if (tid_bitmap != BIT(tid)) {
+		IWL_ERR(mvm, "Failed to unshare q %d, active tids=0x%lx\n",
+			queue, tid_bitmap);
+		return;
+	}
+
+	IWL_DEBUG_TX_QUEUES(mvm, "Unsharing TXQ %d, keeping tid %d\n", queue,
+			    tid);
+
+	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
+					lockdep_is_held(&mvm->mutex));
+
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(sta)))
+		return;
+
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	wdg_timeout = iwl_mvm_get_wd_timeout(mvm, mvmsta->vif, false, false);
+
+	ssn = IEEE80211_SEQ_TO_SN(mvmsta->tid_data[tid].seq_number);
+
+	ret = iwl_mvm_scd_queue_redirect(mvm, queue, tid,
+					 tid_to_mac80211_ac[tid], ssn,
+					 wdg_timeout, true);
+	if (ret) {
+		IWL_ERR(mvm, "Failed to redirect TXQ %d\n", queue);
+		return;
+	}
+
+	/* If aggs should be turned back on - do it */
+	if (mvmsta->tid_data[tid].state == IWL_AGG_ON) {
+		struct iwl_mvm_add_sta_cmd cmd;
+
+		mvmsta->tid_disable_agg &= ~BIT(tid);
+
+		cmd.mac_id_n_color = cpu_to_le32(mvmsta->mac_id_n_color);
+		cmd.sta_id = mvmsta->sta_id;
+		cmd.add_modify = STA_MODE_MODIFY;
+		cmd.modify_mask = STA_MODIFY_TID_DISABLE_TX;
+		cmd.tfd_queue_msk = cpu_to_le32(mvmsta->tfd_queue_msk);
+		cmd.tid_disable_tx = cpu_to_le16(mvmsta->tid_disable_agg);
+
+		ret = iwl_mvm_send_cmd_pdu(mvm, ADD_STA, CMD_ASYNC,
+					   iwl_mvm_add_sta_cmd_size(mvm), &cmd);
+		if (!ret) {
+			IWL_DEBUG_TX_QUEUES(mvm,
+					    "TXQ #%d is now aggregated again\n",
+					    queue);
+
+			/* Mark queue intenally as aggregating again */
+			iwl_trans_txq_set_shared_mode(mvm->trans, queue, false);
+		}
+	}
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
+	spin_unlock_bh(&mvm->queue_info_lock);
+}
+
 static inline u8 iwl_mvm_tid_to_ac_queue(int tid)
 {
 	if (tid == IWL_MAX_TID_COUNT)
@@ -894,13 +983,26 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 	struct ieee80211_sta *sta;
 	struct iwl_mvm_sta *mvmsta;
 	unsigned long deferred_tid_traffic;
-	int sta_id, tid;
+	int queue, sta_id, tid;
 
 	/* Check inactivity of queues */
 	iwl_mvm_inactivity_check(mvm);
 
 	mutex_lock(&mvm->mutex);
 
+	/* Reconfigure queues requiring reconfiguation */
+	for (queue = 0; queue < IWL_MAX_HW_QUEUES; queue++) {
+		bool reconfig;
+
+		spin_lock_bh(&mvm->queue_info_lock);
+		reconfig = (mvm->queue_info[queue].status ==
+			    IWL_MVM_QUEUE_RECONFIGURING);
+		spin_unlock_bh(&mvm->queue_info_lock);
+
+		if (reconfig)
+			iwl_mvm_unshare_queue(mvm, queue);
+	}
+
 	/* Go over all stations with deferred traffic */
 	for_each_set_bit(sta_id, mvm->sta_deferred_frames,
 			 IWL_MVM_STATION_COUNT) {
@@ -1956,7 +2058,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return -EIO;
 	}
 
-	spin_lock_bh(&mvm->queue_info_lock);
+	spin_lock(&mvm->queue_info_lock);
 
 	/*
 	 * Note the possible cases:
@@ -1967,14 +2069,20 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 *	non-DQA mode, since the TXQ hasn't yet been allocated
 	 */
 	txq_id = mvmsta->tid_data[tid].txq_id;
-	if (!iwl_mvm_is_dqa_supported(mvm) ||
+	if (iwl_mvm_is_dqa_supported(mvm) &&
+	    unlikely(mvm->queue_info[txq_id].status == IWL_MVM_QUEUE_SHARED)) {
+		ret = -ENXIO;
+		IWL_DEBUG_TX_QUEUES(mvm,
+				    "Can't start tid %d agg on shared queue!\n",
+				    tid);
+		goto release_locks;
+	} else if (!iwl_mvm_is_dqa_supported(mvm) ||
 	    mvm->queue_info[txq_id].status != IWL_MVM_QUEUE_READY) {
 		txq_id = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
 						 mvm->first_agg_queue,
 						 mvm->last_agg_queue);
 		if (txq_id < 0) {
 			ret = txq_id;
-			spin_unlock_bh(&mvm->queue_info_lock);
 			IWL_ERR(mvm, "Failed to allocate agg queue\n");
 			goto release_locks;
 		}
@@ -1982,7 +2090,8 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		/* TXQ hasn't yet been enabled, so mark it only as reserved */
 		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_RESERVED;
 	}
-	spin_unlock_bh(&mvm->queue_info_lock);
+
+	spin_unlock(&mvm->queue_info_lock);
 
 	IWL_DEBUG_TX_QUEUES(mvm,
 			    "AGG for tid %d will be on queue #%d\n",
@@ -2006,8 +2115,11 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	}
 
 	ret = 0;
+	goto out;
 
 release_locks:
+	spin_unlock(&mvm->queue_info_lock);
+out:
 	spin_unlock_bh(&mvmsta->lock);
 
 	return ret;
@@ -2023,6 +2135,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		iwl_mvm_get_wd_timeout(mvm, vif, sta->tdls, false);
 	int queue, ret;
 	bool alloc_queue = true;
+	enum iwl_mvm_queue_status queue_status;
 	u16 ssn;
 
 	struct iwl_trans_txq_scd_cfg cfg = {
@@ -2048,13 +2161,15 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	cfg.fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
 
+	spin_lock_bh(&mvm->queue_info_lock);
+	queue_status = mvm->queue_info[queue].status;
+	spin_unlock_bh(&mvm->queue_info_lock);
+
 	/* In DQA mode, the existing queue might need to be reconfigured */
 	if (iwl_mvm_is_dqa_supported(mvm)) {
-		spin_lock_bh(&mvm->queue_info_lock);
 		/* Maybe there is no need to even alloc a queue... */
 		if (mvm->queue_info[queue].status == IWL_MVM_QUEUE_READY)
 			alloc_queue = false;
-		spin_unlock_bh(&mvm->queue_info_lock);
 
 		/*
 		 * Only reconfig the SCD for the queue if the window size has
@@ -2089,9 +2204,12 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				   vif->hw_queue[tid_to_mac80211_ac[tid]], ssn,
 				   &cfg, wdg_timeout);
 
-	ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
-	if (ret)
-		return -EIO;
+	/* Send ADD_STA command to enable aggs only if the queue isn't shared */
+	if (queue_status != IWL_MVM_QUEUE_SHARED) {
+		ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
+		if (ret)
+			return -EIO;
+	}
 
 	/* No need to mark as reserved */
 	spin_lock_bh(&mvm->queue_info_lock);
@@ -2123,7 +2241,6 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	u16 txq_id;
 	int err;
 
-
 	/*
 	 * If mac80211 is cleaning its state, then say that we finished since
 	 * our state has been cleared anyway.
@@ -2152,6 +2269,7 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 */
 	if (mvm->queue_info[txq_id].status == IWL_MVM_QUEUE_RESERVED)
 		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_FREE;
+
 	spin_unlock_bh(&mvm->queue_info_lock);
 
 	switch (tid_data->state) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index bbc1cab..709542b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -554,4 +554,8 @@ void iwl_mvm_modify_all_sta_disable_tx(struct iwl_mvm *mvm,
 void iwl_mvm_csa_client_absent(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk);
 
+int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
+			       int ac, int ssn, unsigned int wdg_timeout,
+			       bool force);
+
 #endif /* __sta_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index c6585ab..8b91544 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -838,6 +838,22 @@ static void iwl_mvm_tx_add_stream(struct iwl_mvm *mvm,
 	}
 }
 
+/* Check if there are any timed-out TIDs on a given shared TXQ */
+static bool iwl_mvm_txq_should_update(struct iwl_mvm *mvm, int txq_id)
+{
+	unsigned long queue_tid_bitmap = mvm->queue_info[txq_id].tid_bitmap;
+	unsigned long now = jiffies;
+	int tid;
+
+	for_each_set_bit(tid, &queue_tid_bitmap, IWL_MAX_TID_COUNT + 1) {
+		if (time_before(mvm->queue_info[txq_id].last_frame_time[tid] +
+				IWL_MVM_DQA_QUEUE_TIMEOUT, now))
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Sets the fields in the Tx cmd that are crypto related
  */
@@ -940,7 +956,6 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 			iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
 			spin_unlock(&mvmsta->lock);
 			return 0;
-
 		}
 
 		/* If we are here - TXQ exists and needs to be re-activated */
@@ -953,8 +968,25 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 				    txq_id);
 	}
 
-	/* Keep track of the time of the last frame for this RA/TID */
-	mvm->queue_info[txq_id].last_frame_time[tid] = jiffies;
+	if (iwl_mvm_is_dqa_supported(mvm)) {
+		/* Keep track of the time of the last frame for this RA/TID */
+		mvm->queue_info[txq_id].last_frame_time[tid] = jiffies;
+
+		/*
+		 * If we have timed-out TIDs - schedule the worker that will
+		 * reconfig the queues and update them
+		 *
+		 * Note that the mvm->queue_info_lock isn't being taken here in
+		 * order to not serialize the TX flow. This isn't dangerous
+		 * because scheduling mvm->add_stream_wk can't ruin the state,
+		 * and if we DON'T schedule it due to some race condition then
+		 * next TX we get here we will.
+		 */
+		if (unlikely(mvm->queue_info[txq_id].status ==
+			     IWL_MVM_QUEUE_SHARED &&
+			     iwl_mvm_txq_should_update(mvm, txq_id)))
+			schedule_work(&mvm->add_stream_wk);
+	}
 
 	IWL_DEBUG_TX(mvm, "TX to [%d|%d] Q:%d - seq: 0x%x\n", mvmsta->sta_id,
 		     tid, txq_id, IEEE80211_SEQ_TO_SN(seq_number));
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 68f4e7f..dae64a6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1131,7 +1131,13 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 			BIT(mvmsta->vif->hw_queue[tid_to_mac80211_ac[tid]]);
 	}
 
-	/* TODO: if queue was shared - need to re-enable AGGs */
+	/* If the queue is marked as shared - "unshare" it */
+	if (mvm->queue_info[queue].hw_queue_refcount == 1 &&
+	    mvm->queue_info[queue].status == IWL_MVM_QUEUE_SHARED) {
+		mvm->queue_info[queue].status = IWL_MVM_QUEUE_RECONFIGURING;
+		IWL_DEBUG_TX_QUEUES(mvm, "Marking Q:%d for reconfig\n",
+				    queue);
+	}
 }
 
 void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
-- 
2.8.1
