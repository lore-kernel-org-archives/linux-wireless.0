Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40762 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752227AbcEJU36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:29:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:33 +0300
Message-Id: <1462910797-20303-37-git-send-email-luca@coelho.fi> (sfid-20160510_223001_075138_2C528081)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 37/41] iwlwifi: mvm: support dqa-mode agg on non-shared queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In non-shared queues, DQA requires re-configuring existing
queues to become aggregated rather than allocating a new
one. It also requires "un-aggregating" an existing queue
when aggregations are turned off.

Support this requirement for non-shared queues.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  33 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 148 ++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |  15 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    |  37 +++++-
 6 files changed, 207 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index cd71017..e5f267b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -452,7 +452,10 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (mvm->trans->max_skb_frags)
 		hw->netdev_features = NETIF_F_HIGHDMA | NETIF_F_SG;
 
-	hw->queues = mvm->first_agg_queue;
+	if (!iwl_mvm_is_dqa_supported(mvm))
+		hw->queues = mvm->first_agg_queue;
+	else
+		hw->queues = IEEE80211_MAX_QUEUES;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
 	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_FEC |
 				    IEEE80211_RADIOTAP_MCS_HAVE_STBC;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 820f8d6..ffbd41d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -671,6 +671,28 @@ struct iwl_mvm_baid_data {
 	struct iwl_mvm_reorder_buffer reorder_buf[];
 };
 
+/*
+ * enum iwl_mvm_queue_status - queue status
+ * @IWL_MVM_QUEUE_FREE: the queue is not allocated nor reserved
+ *	Basically, this means that this queue can be used for any purpose
+ * @IWL_MVM_QUEUE_RESERVED: queue is reserved but not yet in use
+ *	This is the state of a queue that has been dedicated for some RATID
+ *	(agg'd or not), but that hasn't yet gone through the actual enablement
+ *	of iwl_mvm_enable_txq(), and therefore no traffic can go through it yet.
+ *	Note that in this state there is no requirement to already know what TID
+ *	should be used with this queue, it is just marked as a queue that will
+ *	be used, and shouldn't be allocated to anyone else.
+ * @IWL_MVM_QUEUE_READY: queue is ready to be used
+ *	This is the state of a queue that has been fully configured (including
+ *	SCD pointers, etc), has a specific RA/TID assigned to it, and can be
+ *	used to send traffic.
+ */
+enum iwl_mvm_queue_status {
+	IWL_MVM_QUEUE_FREE,
+	IWL_MVM_QUEUE_RESERVED,
+	IWL_MVM_QUEUE_READY,
+};
+
 struct iwl_mvm {
 	/* for logger access */
 	struct device *dev;
@@ -726,13 +748,8 @@ struct iwl_mvm {
 		u32 hw_queue_to_mac80211;
 		u8 hw_queue_refcount;
 		u8 ra_sta_id; /* The RA this queue is mapped to, if exists */
-		/*
-		 * This is to mark that queue is reserved for a STA but not yet
-		 * allocated. This is needed to make sure we have at least one
-		 * available queue to use when adding a new STA
-		 */
-		bool setup_reserved;
 		u16 tid_bitmap; /* Bitmap of the TIDs mapped to this queue */
+		enum iwl_mvm_queue_status status;
 	} queue_info[IWL_MAX_HW_QUEUES];
 	spinlock_t queue_info_lock; /* For syncing queue mgmt operations */
 	struct work_struct add_stream_wk; /* To add streams to queues */
@@ -1631,6 +1648,10 @@ static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 void iwl_mvm_start_mac_queues(struct iwl_mvm *mvm, unsigned long mq);
 void iwl_mvm_stop_mac_queues(struct iwl_mvm *mvm, unsigned long mq);
 
+/* Re-configure the SCD for a queue that has already been configured */
+int iwl_mvm_reconfig_scd(struct iwl_mvm *mvm, int queue, int fifo, int sta_id,
+			 int tid, int frame_limit, u16 ssn);
+
 /* Thermal management and CT-kill */
 void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
 void iwl_mvm_tt_temp_changed(struct iwl_mvm *mvm, u32 temp);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 6f91c5b..a68054f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -554,8 +554,13 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mvm->restart_fw = iwlwifi_mod_params.restart_fw ? -1 : 0;
 
 	mvm->aux_queue = 15;
-	mvm->first_agg_queue = 16;
-	mvm->last_agg_queue = mvm->cfg->base_params->num_of_queues - 1;
+	if (!iwl_mvm_is_dqa_supported(mvm)) {
+		mvm->first_agg_queue = 16;
+		mvm->last_agg_queue = mvm->cfg->base_params->num_of_queues - 1;
+	} else {
+		mvm->first_agg_queue = IWL_MVM_DQA_MIN_DATA_QUEUE;
+		mvm->last_agg_queue = IWL_MVM_DQA_MAX_DATA_QUEUE;
+	}
 	if (mvm->cfg->base_params->num_of_queues == 16) {
 		mvm->aux_queue = 11;
 		mvm->first_agg_queue = 12;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 855684a..fea4d3437 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -326,6 +326,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	u8 mac_queue = mvmsta->vif->hw_queue[ac];
 	int queue = -1;
 	int ssn;
+	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -354,8 +355,15 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	if (queue < 0)
 		queue = iwl_mvm_find_free_queue(mvm, IWL_MVM_DQA_MIN_DATA_QUEUE,
 						IWL_MVM_DQA_MAX_DATA_QUEUE);
+
+	/*
+	 * Mark TXQ as ready, even though it hasn't been fully configured yet,
+	 * to make sure no one else takes it.
+	 * This will allow avoiding re-acquiring the lock at the end of the
+	 * configuration. On error we'll mark it back as free.
+	 */
 	if (queue >= 0)
-		mvm->queue_info[queue].setup_reserved = false;
+		mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
 
 	spin_unlock_bh(&mvm->queue_info_lock);
 
@@ -387,7 +395,16 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		mvmsta->reserved_queue = IEEE80211_INVAL_HW_QUEUE;
 	spin_unlock_bh(&mvmsta->lock);
 
-	return iwl_mvm_sta_send_to_fw(mvm, sta, true, STA_MODIFY_QUEUES);
+	ret = iwl_mvm_sta_send_to_fw(mvm, sta, true, STA_MODIFY_QUEUES);
+	if (ret)
+		goto out_err;
+
+	return 0;
+
+out_err:
+	iwl_mvm_disable_txq(mvm, queue, mac_queue, tid, 0);
+
+	return ret;
 }
 
 static inline u8 iwl_mvm_tid_to_ac_queue(int tid)
@@ -493,7 +510,8 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 	/* Make sure we have free resources for this STA */
 	if (vif_type == NL80211_IFTYPE_STATION && !sta->tdls &&
 	    !mvm->queue_info[IWL_MVM_DQA_BSS_CLIENT_QUEUE].hw_queue_refcount &&
-	    !mvm->queue_info[IWL_MVM_DQA_BSS_CLIENT_QUEUE].setup_reserved)
+	    (mvm->queue_info[IWL_MVM_DQA_BSS_CLIENT_QUEUE].status ==
+	     IWL_MVM_QUEUE_FREE))
 		queue = IWL_MVM_DQA_BSS_CLIENT_QUEUE;
 	else
 		queue = iwl_mvm_find_free_queue(mvm, IWL_MVM_DQA_MIN_DATA_QUEUE,
@@ -503,7 +521,7 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 		IWL_ERR(mvm, "No available queues for new station\n");
 		return -ENOSPC;
 	}
-	mvm->queue_info[queue].setup_reserved = true;
+	mvm->queue_info[queue].status = IWL_MVM_QUEUE_RESERVED;
 
 	spin_unlock_bh(&mvm->queue_info_lock);
 
@@ -1398,7 +1416,9 @@ static int iwl_mvm_sta_tx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		mvm_sta->tfd_queue_msk |= BIT(queue);
 		mvm_sta->tid_disable_agg &= ~BIT(tid);
 	} else {
-		mvm_sta->tfd_queue_msk &= ~BIT(queue);
+		/* In DQA-mode the queue isn't removed on agg termination */
+		if (!iwl_mvm_is_dqa_supported(mvm))
+			mvm_sta->tfd_queue_msk &= ~BIT(queue);
 		mvm_sta->tid_disable_agg |= BIT(tid);
 	}
 
@@ -1481,17 +1501,35 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	spin_lock_bh(&mvm->queue_info_lock);
 
-	txq_id = iwl_mvm_find_free_queue(mvm, mvm->first_agg_queue,
-					 mvm->last_agg_queue);
-	if (txq_id < 0) {
-		ret = txq_id;
-		spin_unlock_bh(&mvm->queue_info_lock);
-		IWL_ERR(mvm, "Failed to allocate agg queue\n");
-		goto release_locks;
+	/*
+	 * Note the possible cases:
+	 *  1. In DQA mode with an enabled TXQ - TXQ needs to become agg'ed
+	 *  2. Non-DQA mode: the TXQ hasn't yet been enabled, so find a free
+	 *	one and mark it as reserved
+	 *  3. In DQA mode, but no traffic yet on this TID: same treatment as in
+	 *	non-DQA mode, since the TXQ hasn't yet been allocated
+	 */
+	txq_id = mvmsta->tid_data[tid].txq_id;
+	if (!iwl_mvm_is_dqa_supported(mvm) ||
+	    mvm->queue_info[txq_id].status != IWL_MVM_QUEUE_READY) {
+		txq_id = iwl_mvm_find_free_queue(mvm, mvm->first_agg_queue,
+						 mvm->last_agg_queue);
+		if (txq_id < 0) {
+			ret = txq_id;
+			spin_unlock_bh(&mvm->queue_info_lock);
+			IWL_ERR(mvm, "Failed to allocate agg queue\n");
+			goto release_locks;
+		}
+
+		/* TXQ hasn't yet been enabled, so mark it only as reserved */
+		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_RESERVED;
 	}
-	mvm->queue_info[txq_id].setup_reserved = true;
 	spin_unlock_bh(&mvm->queue_info_lock);
 
+	IWL_DEBUG_TX_QUEUES(mvm,
+			    "AGG for tid %d will be on queue #%d\n",
+			    tid, txq_id);
+
 	tid_data = &mvmsta->tid_data[tid];
 	tid_data->ssn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
 	tid_data->txq_id = txq_id;
@@ -1526,6 +1564,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	unsigned int wdg_timeout =
 		iwl_mvm_get_wd_timeout(mvm, vif, sta->tdls, false);
 	int queue, ret;
+	bool alloc_queue = true;
 	u16 ssn;
 
 	struct iwl_trans_txq_scd_cfg cfg = {
@@ -1551,8 +1590,46 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	cfg.fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
 
-	iwl_mvm_enable_txq(mvm, queue, vif->hw_queue[tid_to_mac80211_ac[tid]],
-			   ssn, &cfg, wdg_timeout);
+	/* In DQA mode, the existing queue might need to be reconfigured */
+	if (iwl_mvm_is_dqa_supported(mvm)) {
+		spin_lock_bh(&mvm->queue_info_lock);
+		/* Maybe there is no need to even alloc a queue... */
+		if (mvm->queue_info[queue].status == IWL_MVM_QUEUE_READY)
+			alloc_queue = false;
+		spin_unlock_bh(&mvm->queue_info_lock);
+
+		/*
+		 * Only reconfig the SCD for the queue if the window size has
+		 * changed from current (become smaller)
+		 */
+		if (!alloc_queue && buf_size < mvmsta->max_agg_bufsize) {
+			/*
+			 * If reconfiguring an existing queue, it first must be
+			 * drained
+			 */
+			ret = iwl_trans_wait_tx_queue_empty(mvm->trans,
+							    BIT(queue));
+			if (ret) {
+				IWL_ERR(mvm,
+					"Error draining queue before reconfig\n");
+				return ret;
+			}
+
+			ret = iwl_mvm_reconfig_scd(mvm, queue, cfg.fifo,
+						   mvmsta->sta_id, tid,
+						   buf_size, ssn);
+			if (ret) {
+				IWL_ERR(mvm,
+					"Error reconfiguring TXQ #%d\n", queue);
+				return ret;
+			}
+		}
+	}
+
+	if (alloc_queue)
+		iwl_mvm_enable_txq(mvm, queue,
+				   vif->hw_queue[tid_to_mac80211_ac[tid]], ssn,
+				   &cfg, wdg_timeout);
 
 	ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
 	if (ret)
@@ -1560,7 +1637,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	/* No need to mark as reserved */
 	spin_lock_bh(&mvm->queue_info_lock);
-	mvm->queue_info[queue].setup_reserved = false;
+	mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
 	spin_unlock_bh(&mvm->queue_info_lock);
 
 	/*
@@ -1607,9 +1684,16 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	mvmsta->agg_tids &= ~BIT(tid);
 
-	/* No need to mark as reserved anymore */
 	spin_lock_bh(&mvm->queue_info_lock);
-	mvm->queue_info[txq_id].setup_reserved = false;
+	/*
+	 * The TXQ is marked as reserved only if no traffic came through yet
+	 * This means no traffic has been sent on this TID (agg'd or not), so
+	 * we no longer have use for the queue. Since it hasn't even been
+	 * allocated through iwl_mvm_enable_txq, so we can just mark it back as
+	 * free.
+	 */
+	if (mvm->queue_info[txq_id].status == IWL_MVM_QUEUE_RESERVED)
+		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_FREE;
 	spin_unlock_bh(&mvm->queue_info_lock);
 
 	switch (tid_data->state) {
@@ -1635,9 +1719,11 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
 
-		iwl_mvm_disable_txq(mvm, txq_id,
-				    vif->hw_queue[tid_to_mac80211_ac[tid]], tid,
-				    0);
+		if (!iwl_mvm_is_dqa_supported(mvm)) {
+			int mac_queue = vif->hw_queue[tid_to_mac80211_ac[tid]];
+
+			iwl_mvm_disable_txq(mvm, txq_id, mac_queue, tid, 0);
+		}
 		return 0;
 	case IWL_AGG_STARTING:
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -1688,9 +1774,16 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	mvmsta->agg_tids &= ~BIT(tid);
 	spin_unlock_bh(&mvmsta->lock);
 
-	/* No need to mark as reserved */
 	spin_lock_bh(&mvm->queue_info_lock);
-	mvm->queue_info[txq_id].setup_reserved = false;
+	/*
+	 * The TXQ is marked as reserved only if no traffic came through yet
+	 * This means no traffic has been sent on this TID (agg'd or not), so
+	 * we no longer have use for the queue. Since it hasn't even been
+	 * allocated through iwl_mvm_enable_txq, so we can just mark it back as
+	 * free.
+	 */
+	if (mvm->queue_info[txq_id].status == IWL_MVM_QUEUE_RESERVED)
+		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_FREE;
 	spin_unlock_bh(&mvm->queue_info_lock);
 
 	if (old_state >= IWL_AGG_ON) {
@@ -1703,9 +1796,12 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
 
-		iwl_mvm_disable_txq(mvm, tid_data->txq_id,
-				    vif->hw_queue[tid_to_mac80211_ac[tid]], tid,
-				    0);
+		if (!iwl_mvm_is_dqa_supported(mvm)) {
+			int mac_queue = vif->hw_queue[tid_to_mac80211_ac[tid]];
+
+			iwl_mvm_disable_txq(mvm, tid_data->txq_id, mac_queue,
+					    tid, 0);
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ff615b9..779bafc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -933,7 +933,8 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	spin_unlock(&mvmsta->lock);
 
-	if (txq_id < mvm->first_agg_queue)
+	/* Increase pending frames count if this isn't AMPDU */
+	if (!is_ampdu)
 		atomic_inc(&mvm->pending_frames[mvmsta->sta_id]);
 
 	return 0;
@@ -1181,6 +1182,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	u8 skb_freed = 0;
 	u16 next_reclaimed, seq_ctl;
 	bool is_ndp = false;
+	bool txq_agg = false; /* Is this TXQ aggregated */
 
 	__skb_queue_head_init(&skbs);
 
@@ -1311,6 +1313,8 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			bool send_eosp_ndp = false;
 
 			spin_lock_bh(&mvmsta->lock);
+			txq_agg = (mvmsta->tid_data[tid].state == IWL_AGG_ON);
+
 			if (!is_ndp) {
 				tid_data->next_reclaimed = next_reclaimed;
 				IWL_DEBUG_TX_REPLY(mvm,
@@ -1366,11 +1370,11 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	 * If the txq is not an AMPDU queue, there is no chance we freed
 	 * several skbs. Check that out...
 	 */
-	if (txq_id >= mvm->first_agg_queue)
+	if (txq_agg)
 		goto out;
 
 	/* We can't free more than one frame at once on a shared queue */
-	WARN_ON(skb_freed > 1);
+	WARN_ON(!iwl_mvm_is_dqa_supported(mvm) && (skb_freed > 1));
 
 	/* If we have still frames for this STA nothing to do here */
 	if (!atomic_sub_and_test(skb_freed, &mvm->pending_frames[sta_id]))
@@ -1465,8 +1469,11 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 	int tid = IWL_MVM_TX_RES_GET_TID(tx_resp->ra_tid);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	struct iwl_mvm_sta *mvmsta;
+	int queue = SEQ_TO_QUEUE(sequence);
 
-	if (WARN_ON_ONCE(SEQ_TO_QUEUE(sequence) < mvm->first_agg_queue))
+	if (WARN_ON_ONCE(queue < mvm->first_agg_queue &&
+			 (!iwl_mvm_is_dqa_supported(mvm) ||
+			  (queue != IWL_MVM_DQA_BSS_CLIENT_QUEUE))))
 		return;
 
 	if (WARN_ON_ONCE(tid == IWL_TID_NON_QOS))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index eb41d3b..161b99e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -587,12 +587,45 @@ int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 minq, u8 maxq)
 
 	for (i = minq; i <= maxq; i++)
 		if (mvm->queue_info[i].hw_queue_refcount == 0 &&
-		    !mvm->queue_info[i].setup_reserved)
+		    mvm->queue_info[i].status == IWL_MVM_QUEUE_FREE)
 			return i;
 
 	return -ENOSPC;
 }
 
+int iwl_mvm_reconfig_scd(struct iwl_mvm *mvm, int queue, int fifo, int sta_id,
+			 int tid, int frame_limit, u16 ssn)
+{
+	struct iwl_scd_txq_cfg_cmd cmd = {
+		.scd_queue = queue,
+		.enable = 1,
+		.window = frame_limit,
+		.sta_id = sta_id,
+		.ssn = cpu_to_le16(ssn),
+		.tx_fifo = fifo,
+		.aggregate = (queue >= IWL_MVM_DQA_MIN_DATA_QUEUE ||
+			      queue == IWL_MVM_DQA_BSS_CLIENT_QUEUE),
+		.tid = tid,
+	};
+	int ret;
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	if (WARN(mvm->queue_info[queue].hw_queue_refcount == 0,
+		 "Trying to reconfig unallocated queue %d\n", queue)) {
+		spin_unlock_bh(&mvm->queue_info_lock);
+		return -ENXIO;
+	}
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	IWL_DEBUG_TX_QUEUES(mvm, "Reconfig SCD for TXQ #%d\n", queue);
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd), &cmd);
+	WARN_ONCE(ret, "Failed to re-configure queue %d on FIFO %d, ret=%d\n",
+		  queue, fifo, ret);
+
+	return ret;
+}
+
 void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			u16 ssn, const struct iwl_trans_txq_scd_cfg *cfg,
 			unsigned int wdg_timeout)
@@ -688,6 +721,8 @@ void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	mvm->queue_info[queue].hw_queue_refcount--;
 
 	cmd.enable = mvm->queue_info[queue].hw_queue_refcount ? 1 : 0;
+	if (!cmd.enable)
+		mvm->queue_info[queue].status = IWL_MVM_QUEUE_FREE;
 
 	IWL_DEBUG_TX_QUEUES(mvm,
 			    "Disabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
-- 
2.8.1

