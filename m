Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54302 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954232AbdDYU1g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:27:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:37 +0300
Message-Id: <20170425202243.7844-20-luca@coelho.fi> (sfid-20170425_222814_608052_1B54F393)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 19/25] iwlwifi: mvm: remove references to queue_info in new TX path
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Most of the fields aren't needed in new TX path.
Enlarging the struct to 512 queues will consume a lot of memory.
Remove all references to the struct in the new TX path.
Move mac80211 queue mapping outside, since it will be needed per
queue for TVQM mode.
Add warning in paths that shouldn't be hit.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h   |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c   |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c   | 96 +++++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c    |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 58 +++++++++-------
 5 files changed, 96 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ab4864f2f4cb..204664b578df 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -788,9 +788,9 @@ struct iwl_mvm {
 		u64 on_time_scan;
 	} radio_stats, accu_radio_stats;
 
+	u8 hw_queue_to_mac80211[IWL_MAX_HW_QUEUES];
+
 	struct {
-		/* Map to HW queue */
-		u32 hw_queue_to_mac80211;
 		u8 hw_queue_refcount;
 		u8 ra_sta_id; /* The RA this queue is mapped to, if exists */
 		bool reserved; /* Is this the TXQ reserved for a STA */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 363930510a6e..9ffff6ed8133 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1044,7 +1044,7 @@ static void iwl_mvm_stop_sw_queue(struct iwl_op_mode *op_mode, int hw_queue)
 	unsigned long mq;
 
 	spin_lock_bh(&mvm->queue_info_lock);
-	mq = mvm->queue_info[hw_queue].hw_queue_to_mac80211;
+	mq = mvm->hw_queue_to_mac80211[hw_queue];
 	spin_unlock_bh(&mvm->queue_info_lock);
 
 	iwl_mvm_stop_mac_queues(mvm, mq);
@@ -1074,7 +1074,7 @@ static void iwl_mvm_wake_sw_queue(struct iwl_op_mode *op_mode, int hw_queue)
 	unsigned long mq;
 
 	spin_lock_bh(&mvm->queue_info_lock);
-	mq = mvm->queue_info[hw_queue].hw_queue_to_mac80211;
+	mq = mvm->hw_queue_to_mac80211[hw_queue];
 	spin_unlock_bh(&mvm->queue_info_lock);
 
 	iwl_mvm_start_mac_queues(mvm, mq);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 99fa6b17a4a0..3be7fc01b19f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -644,7 +644,7 @@ int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 	cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
 	cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[mvm->queue_info[queue].mac80211_ac];
 	cmd.tid = mvm->queue_info[queue].txq_tid;
-	mq = mvm->queue_info[queue].hw_queue_to_mac80211;
+	mq = mvm->hw_queue_to_mac80211[queue];
 	shared_queue = (mvm->queue_info[queue].hw_queue_refcount > 1);
 	spin_unlock_bh(&mvm->queue_info_lock);
 
@@ -732,10 +732,6 @@ static int iwl_mvm_sta_alloc_queue_tvqm(struct iwl_mvm *mvm,
 	mvmsta->tfd_queue_msk |= BIT(queue);
 	spin_unlock_bh(&mvmsta->lock);
 
-	spin_lock_bh(&mvm->queue_info_lock);
-	mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
-	spin_unlock_bh(&mvm->queue_info_lock);
-
 	return 0;
 }
 
@@ -1131,8 +1127,12 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 
 	mutex_lock(&mvm->mutex);
 
+	/* No queue reconfiguration in TVQM mode */
+	if (iwl_mvm_has_new_tx_api(mvm))
+		goto alloc_queues;
+
 	/* Reconfigure queues requiring reconfiguation */
-	for (queue = 0; queue < IWL_MAX_HW_QUEUES; queue++) {
+	for (queue = 0; queue < ARRAY_SIZE(mvm->queue_info); queue++) {
 		bool reconfig;
 		bool change_owner;
 
@@ -1160,6 +1160,7 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 			iwl_mvm_change_queue_owner(mvm, queue);
 	}
 
+alloc_queues:
 	/* Go over all stations with deferred traffic */
 	for_each_set_bit(sta_id, mvm->sta_deferred_frames,
 			 IWL_MVM_STATION_COUNT) {
@@ -1298,9 +1299,8 @@ static void iwl_mvm_realloc_queues_after_restart(struct iwl_mvm *mvm,
 
 			iwl_mvm_enable_txq(mvm, txq_id, mac_queue, seq, &cfg,
 					   wdg_timeout);
+			mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_READY;
 		}
-
-		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_READY;
 	}
 
 	atomic_set(&mvm->pending_frames[mvm_sta->sta_id], 0);
@@ -2492,10 +2492,18 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 *	one and mark it as reserved
 	 *  3. In DQA mode, but no traffic yet on this TID: same treatment as in
 	 *	non-DQA mode, since the TXQ hasn't yet been allocated
+	 * Don't support case 3 for new TX path as it is not expected to happen
+	 * and aggregation will be offloaded soon anyway
 	 */
 	txq_id = mvmsta->tid_data[tid].txq_id;
-	if (iwl_mvm_is_dqa_supported(mvm) &&
-	    unlikely(mvm->queue_info[txq_id].status == IWL_MVM_QUEUE_SHARED)) {
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		if (txq_id == IWL_MVM_INVALID_QUEUE) {
+			ret = -ENXIO;
+			goto release_locks;
+		}
+	} else if (iwl_mvm_is_dqa_supported(mvm) &&
+		   unlikely(mvm->queue_info[txq_id].status ==
+			    IWL_MVM_QUEUE_SHARED)) {
 		ret = -ENXIO;
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "Can't start tid %d agg on shared queue!\n",
@@ -2591,6 +2599,20 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	tid_data->amsdu_in_ampdu_allowed = amsdu;
 	spin_unlock_bh(&mvmsta->lock);
 
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		/*
+		 * If no queue iwl_mvm_sta_tx_agg_start() would have failed so
+		 * no need to check queue's status
+		 */
+		if (buf_size < mvmsta->max_agg_bufsize)
+			return -ENOTSUPP;
+
+		ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
+		if (ret)
+			return -EIO;
+		goto out;
+	}
+
 	cfg.fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
 
 	spin_lock_bh(&mvm->queue_info_lock);
@@ -2609,13 +2631,6 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		 */
 		if (!alloc_queue && buf_size < mvmsta->max_agg_bufsize) {
 			/*
-			 * On new TX API rs and BA manager are offloaded.
-			 * For now though, just don't support being reconfigured
-			 */
-			if (iwl_mvm_has_new_tx_api(mvm))
-				return -ENOTSUPP;
-
-			/*
 			 * If reconfiguring an existing queue, it first must be
 			 * drained
 			 */
@@ -2655,6 +2670,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
 	spin_unlock_bh(&mvm->queue_info_lock);
 
+out:
 	/*
 	 * Even though in theory the peer could have different
 	 * aggregation reorder buffer sizes for different sessions,
@@ -2672,6 +2688,27 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return iwl_mvm_send_lq_cmd(mvm, &mvmsta->lq_sta.lq, false);
 }
 
+static void iwl_mvm_unreserve_agg_queue(struct iwl_mvm *mvm,
+					struct iwl_mvm_sta *mvmsta,
+					u16 txq_id)
+{
+	if (iwl_mvm_has_new_tx_api(mvm))
+		return;
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	/*
+	 * The TXQ is marked as reserved only if no traffic came through yet
+	 * This means no traffic has been sent on this TID (agg'd or not), so
+	 * we no longer have use for the queue. Since it hasn't even been
+	 * allocated through iwl_mvm_enable_txq, so we can just mark it back as
+	 * free.
+	 */
+	if (mvm->queue_info[txq_id].status == IWL_MVM_QUEUE_RESERVED)
+		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_FREE;
+
+	spin_unlock_bh(&mvm->queue_info_lock);
+}
+
 int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, u16 tid)
 {
@@ -2698,18 +2735,7 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	mvmsta->agg_tids &= ~BIT(tid);
 
-	spin_lock_bh(&mvm->queue_info_lock);
-	/*
-	 * The TXQ is marked as reserved only if no traffic came through yet
-	 * This means no traffic has been sent on this TID (agg'd or not), so
-	 * we no longer have use for the queue. Since it hasn't even been
-	 * allocated through iwl_mvm_enable_txq, so we can just mark it back as
-	 * free.
-	 */
-	if (mvm->queue_info[txq_id].status == IWL_MVM_QUEUE_RESERVED)
-		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_FREE;
-
-	spin_unlock_bh(&mvm->queue_info_lock);
+	iwl_mvm_unreserve_agg_queue(mvm, mvmsta, txq_id);
 
 	switch (tid_data->state) {
 	case IWL_AGG_ON:
@@ -2789,17 +2815,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	mvmsta->agg_tids &= ~BIT(tid);
 	spin_unlock_bh(&mvmsta->lock);
 
-	spin_lock_bh(&mvm->queue_info_lock);
-	/*
-	 * The TXQ is marked as reserved only if no traffic came through yet
-	 * This means no traffic has been sent on this TID (agg'd or not), so
-	 * we no longer have use for the queue. Since it hasn't even been
-	 * allocated through iwl_mvm_enable_txq, so we can just mark it back as
-	 * free.
-	 */
-	if (mvm->queue_info[txq_id].status == IWL_MVM_QUEUE_RESERVED)
-		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_FREE;
-	spin_unlock_bh(&mvm->queue_info_lock);
+	iwl_mvm_unreserve_agg_queue(mvm, mvmsta, txq_id);
 
 	if (old_state >= IWL_AGG_ON) {
 		iwl_mvm_drain_sta(mvm, mvmsta, true);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 5e305d391ffe..bcaceb64a6e8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1006,6 +1006,9 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 			return 0;
 		}
 
+		/* queue should always be active in new TX path */
+		WARN_ON(iwl_mvm_has_new_tx_api(mvm));
+
 		/* If we are here - TXQ exists and needs to be re-activated */
 		spin_lock(&mvm->queue_info_lock);
 		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_READY;
@@ -1016,7 +1019,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 				    txq_id);
 	}
 
-	if (iwl_mvm_is_dqa_supported(mvm)) {
+	if (iwl_mvm_is_dqa_supported(mvm) && !iwl_mvm_has_new_tx_api(mvm)) {
 		/* Keep track of the time of the last frame for this RA/TID */
 		mvm->queue_info[txq_id].last_frame_time[tid] = jiffies;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 0e594899c615..8f4f176e204e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -671,7 +671,8 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 	if (mvm->queue_info[queue].hw_queue_refcount > 0)
 		enable_queue = false;
 
-	mvm->queue_info[queue].hw_queue_to_mac80211 |= BIT(mac80211_queue);
+	mvm->hw_queue_to_mac80211[queue] |= BIT(mac80211_queue);
+
 	mvm->queue_info[queue].hw_queue_refcount++;
 	mvm->queue_info[queue].tid_bitmap |= BIT(tid);
 	mvm->queue_info[queue].ra_sta_id = sta_id;
@@ -689,7 +690,7 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 	IWL_DEBUG_TX_QUEUES(mvm,
 			    "Enabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
 			    queue, mvm->queue_info[queue].hw_queue_refcount,
-			    mvm->queue_info[queue].hw_queue_to_mac80211);
+			    mvm->hw_queue_to_mac80211[queue]);
 
 	spin_unlock_bh(&mvm->queue_info_lock);
 
@@ -721,7 +722,10 @@ int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm, int mac80211_queue,
 	IWL_DEBUG_TX_QUEUES(mvm, "Enabling TXQ #%d for sta %d tid %d\n",
 			    queue, sta_id, tid);
 
-	iwl_mvm_update_txq_mapping(mvm, queue, mac80211_queue, sta_id, tid);
+	mvm->hw_queue_to_mac80211[queue] |= BIT(mac80211_queue);
+	IWL_DEBUG_TX_QUEUES(mvm,
+			    "Enabling TXQ #%d (mac80211 map:0x%x)\n",
+			    queue, mvm->hw_queue_to_mac80211[queue]);
 
 	return queue;
 }
@@ -765,6 +769,17 @@ int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 		.action = SCD_CFG_DISABLE_QUEUE,
 	};
 	bool remove_mac_queue = true;
+	int ret;
+
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		spin_lock_bh(&mvm->queue_info_lock);
+		mvm->hw_queue_to_mac80211[queue] &= ~BIT(mac80211_queue);
+		spin_unlock_bh(&mvm->queue_info_lock);
+
+		iwl_trans_txq_free(mvm->trans, queue);
+
+		return 0;
+	}
 
 	spin_lock_bh(&mvm->queue_info_lock);
 
@@ -792,7 +807,7 @@ int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	}
 
 	if (remove_mac_queue)
-		mvm->queue_info[queue].hw_queue_to_mac80211 &=
+		mvm->hw_queue_to_mac80211[queue] &=
 			~BIT(mac80211_queue);
 	mvm->queue_info[queue].hw_queue_refcount--;
 
@@ -805,7 +820,7 @@ int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			    "Disabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
 			    queue,
 			    mvm->queue_info[queue].hw_queue_refcount,
-			    mvm->queue_info[queue].hw_queue_to_mac80211);
+			    mvm->hw_queue_to_mac80211[queue]);
 
 	/* If the queue is still enabled - nothing left to do in this func */
 	if (cmd.action == SCD_CFG_ENABLE_QUEUE) {
@@ -819,39 +834,30 @@ int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	/* Make sure queue info is correct even though we overwrite it */
 	WARN(mvm->queue_info[queue].hw_queue_refcount ||
 	     mvm->queue_info[queue].tid_bitmap ||
-	     mvm->queue_info[queue].hw_queue_to_mac80211,
+	     mvm->hw_queue_to_mac80211[queue],
 	     "TXQ #%d info out-of-sync - refcount=%d, mac map=0x%x, tid=0x%x\n",
 	     queue, mvm->queue_info[queue].hw_queue_refcount,
-	     mvm->queue_info[queue].hw_queue_to_mac80211,
+	     mvm->hw_queue_to_mac80211[queue],
 	     mvm->queue_info[queue].tid_bitmap);
 
 	/* If we are here - the queue is freed and we can zero out these vals */
 	mvm->queue_info[queue].hw_queue_refcount = 0;
 	mvm->queue_info[queue].tid_bitmap = 0;
-	mvm->queue_info[queue].hw_queue_to_mac80211 = 0;
+	mvm->hw_queue_to_mac80211[queue] = 0;
 
 	/* Regardless if this is a reserved TXQ for a STA - mark it as false */
 	mvm->queue_info[queue].reserved = false;
 
 	spin_unlock_bh(&mvm->queue_info_lock);
 
-	if (iwl_mvm_has_new_tx_api(mvm)) {
-		iwl_trans_txq_free(mvm->trans, queue);
-	} else {
-		int ret;
-
-		iwl_trans_txq_disable(mvm->trans, queue, false);
-		ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
-					   sizeof(struct iwl_scd_txq_cfg_cmd),
-					   &cmd);
+	iwl_trans_txq_disable(mvm->trans, queue, false);
+	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
+				   sizeof(struct iwl_scd_txq_cfg_cmd), &cmd);
 
-		if (ret)
-			IWL_ERR(mvm, "Failed to disable queue %d (ret=%d)\n",
-				queue, ret);
-		return ret;
-	}
-
-	return 0;
+	if (ret)
+		IWL_ERR(mvm, "Failed to disable queue %d (ret=%d)\n",
+			queue, ret);
+	return ret;
 }
 
 /**
@@ -1204,7 +1210,7 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 		int mac_queue = mvmsta->vif->hw_queue[tid_to_mac80211_ac[tid]];
 
 		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
-		mvm->queue_info[queue].hw_queue_to_mac80211 &= ~BIT(mac_queue);
+		mvm->hw_queue_to_mac80211[queue] &= ~BIT(mac_queue);
 		mvm->queue_info[queue].hw_queue_refcount--;
 		mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
 		mvmsta->tid_data[tid].is_tid_active = false;
@@ -1224,7 +1230,7 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	 */
 	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
 	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
-		mvm->queue_info[queue].hw_queue_to_mac80211 |=
+		mvm->hw_queue_to_mac80211[queue] |=
 			BIT(mvmsta->vif->hw_queue[tid_to_mac80211_ac[tid]]);
 	}
 
-- 
2.11.0
