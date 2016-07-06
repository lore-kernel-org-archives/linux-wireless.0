Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33224 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753257AbcGFKl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:41:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:04 +0300
Message-Id: <1467801651-1816-9-git-send-email-luca@coelho.fi> (sfid-20160706_124135_311810_5BBCF9DA)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 09/56] iwlwifi: mvm: support dqa queue sharing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Support DQA queue sharing when no free queue exists for
allocation to a STA that already exists. This means that
a single queue will serve more than a single TID (although
the RA will be the same for all TIDs served).

We try to choose the lowest AC possible, to ensure the
shared queues have the lowest possible combined AC
requirements. The queue to share is chosen only from the
same RA's DATA queues as follows (in descending priority):
 1. An AC_BE queue
 2. Same AC queue
 3. Highest AC queue that is lower than new AC
 4. Any existing AC (there always is at least 1 DATA queue)

If any aggregations existed for any of the TIDs of the
shared queue - they are stopped (the FW is notified), but
no delBA is sent.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  11 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   6 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 173 +++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  18 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   9 ++
 7 files changed, 199 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index a45be1d..57cc67f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -583,6 +583,7 @@ struct iwl_trans_txq_scd_cfg {
  *	configured. May sleep.
  * @txq_disable: de-configure a Tx queue to send AMPDUs
  *	Must be atomic
+ * @txq_set_shared_mode: change Tx queue shared/unshared marking
  * @wait_tx_queue_empty: wait until tx queues are empty. May sleep.
  * @freeze_txq_timer: prevents the timer of the queue from firing until the
  *	queue is set to awake. Must be atomic.
@@ -646,6 +647,9 @@ struct iwl_trans_ops {
 	void (*txq_disable)(struct iwl_trans *trans, int queue,
 			    bool configure_scd);
 
+	void (*txq_set_shared_mode)(struct iwl_trans *trans, u32 txq_id,
+				    bool shared);
+
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans, u32 txq_bm);
 	void (*freeze_txq_timer)(struct iwl_trans *trans, unsigned long txqs,
 				 bool freeze);
@@ -1061,6 +1065,13 @@ iwl_trans_txq_enable_cfg(struct iwl_trans *trans, int queue, u16 ssn,
 	trans->ops->txq_enable(trans, queue, ssn, cfg, queue_wdg_timeout);
 }
 
+static inline void iwl_trans_txq_set_shared_mode(struct iwl_trans *trans,
+						 int queue, bool shared_mode)
+{
+	if (trans->ops->txq_set_shared_mode)
+		trans->ops->txq_set_shared_mode(trans, queue, shared_mode);
+}
+
 static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
 					int fifo, int sta_id, int tid,
 					int frame_limit, u16 ssn,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 3775e26..6092af2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -687,6 +687,10 @@ struct iwl_mvm_baid_data {
  *	This is the state of a queue that has been fully configured (including
  *	SCD pointers, etc), has a specific RA/TID assigned to it, and can be
  *	used to send traffic.
+ * @IWL_MVM_QUEUE_SHARED: queue is shared, or in a process of becoming shared
+ *	This is a state in which a single queue serves more than one TID, all of
+ *	which are not aggregated. Note that the queue is only associated to one
+ *	RA.
  * @IWL_MVM_QUEUE_INACTIVE: queue is allocated but no traffic on it
  *	This is a state of a queue that has had traffic on it, but during the
  *	last %IWL_MVM_DQA_QUEUE_TIMEOUT time period there has been no traffic on
@@ -698,6 +702,7 @@ enum iwl_mvm_queue_status {
 	IWL_MVM_QUEUE_FREE,
 	IWL_MVM_QUEUE_RESERVED,
 	IWL_MVM_QUEUE_READY,
+	IWL_MVM_QUEUE_SHARED,
 	IWL_MVM_QUEUE_INACTIVE,
 };
 
@@ -760,6 +765,7 @@ struct iwl_mvm {
 		u8 hw_queue_refcount;
 		u8 ra_sta_id; /* The RA this queue is mapped to, if exists */
 		bool reserved; /* Is this the TXQ reserved for a STA */
+		u8 mac80211_ac; /* The mac80211 AC this queue is mapped to */
 		u16 tid_bitmap; /* Bitmap of the TIDs mapped to this queue */
 		/* Timestamp for inactivation per TID of this queue */
 		unsigned long last_frame_time[IWL_MAX_TID_COUNT + 1];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 84384a43..14c06cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -361,6 +361,40 @@ static int iwl_mvm_invalidate_sta_queue(struct iwl_mvm *mvm, int queue,
 	return ret;
 }
 
+static int iwl_mvm_get_queue_agg_tids(struct iwl_mvm *mvm, int queue)
+{
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
+	unsigned long tid_bitmap;
+	unsigned long agg_tids = 0;
+	s8 sta_id;
+	int tid;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	sta_id = mvm->queue_info[queue].ra_sta_id;
+	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
+					lockdep_is_held(&mvm->mutex));
+
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(sta)))
+		return -EINVAL;
+
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+	spin_lock_bh(&mvmsta->lock);
+	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
+		if (mvmsta->tid_data[tid].state == IWL_AGG_ON)
+			agg_tids |= BIT(tid);
+	}
+	spin_unlock_bh(&mvmsta->lock);
+
+	return agg_tids;
+}
+
 /*
  * Remove a queue from a station's resources.
  * Note that this only marks as free. It DOESN'T delete a BA agreement, and
@@ -394,28 +428,91 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 	spin_lock_bh(&mvmsta->lock);
+	/* Unmap MAC queues and TIDs from this queue */
 	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
-		mvmsta->tid_data[tid].txq_id = IEEE80211_INVAL_HW_QUEUE;
-
 		if (mvmsta->tid_data[tid].state == IWL_AGG_ON)
 			disable_agg_tids |= BIT(tid);
+		mvmsta->tid_data[tid].txq_id = IEEE80211_INVAL_HW_QUEUE;
 	}
-	mvmsta->tfd_queue_msk &= ~BIT(queue); /* Don't use this queue anymore */
 
+	mvmsta->tfd_queue_msk &= ~BIT(queue); /* Don't use this queue anymore */
 	spin_unlock_bh(&mvmsta->lock);
 
 	rcu_read_unlock();
 
-	spin_lock(&mvm->queue_info_lock);
+	spin_lock_bh(&mvm->queue_info_lock);
 	/* Unmap MAC queues and TIDs from this queue */
 	mvm->queue_info[queue].hw_queue_to_mac80211 = 0;
 	mvm->queue_info[queue].hw_queue_refcount = 0;
 	mvm->queue_info[queue].tid_bitmap = 0;
-	spin_unlock(&mvm->queue_info_lock);
+	spin_unlock_bh(&mvm->queue_info_lock);
 
 	return disable_agg_tids;
 }
 
+static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
+				    unsigned long tfd_queue_mask, u8 ac)
+{
+	int queue = 0;
+	u8 ac_to_queue[IEEE80211_NUM_ACS];
+	int i;
+
+	lockdep_assert_held(&mvm->queue_info_lock);
+
+	memset(&ac_to_queue, IEEE80211_INVAL_HW_QUEUE, sizeof(ac_to_queue));
+
+	/* See what ACs the existing queues for this STA have */
+	for_each_set_bit(i, &tfd_queue_mask, IWL_MVM_DQA_MAX_DATA_QUEUE) {
+		/* Only DATA queues can be shared */
+		if (i < IWL_MVM_DQA_MIN_DATA_QUEUE &&
+		    i != IWL_MVM_DQA_BSS_CLIENT_QUEUE)
+			continue;
+
+		ac_to_queue[mvm->queue_info[i].mac80211_ac] = i;
+	}
+
+	/*
+	 * The queue to share is chosen only from DATA queues as follows (in
+	 * descending priority):
+	 * 1. An AC_BE queue
+	 * 2. Same AC queue
+	 * 3. Highest AC queue that is lower than new AC
+	 * 4. Any existing AC (there always is at least 1 DATA queue)
+	 */
+
+	/* Priority 1: An AC_BE queue */
+	if (ac_to_queue[IEEE80211_AC_BE] != IEEE80211_INVAL_HW_QUEUE)
+		queue = ac_to_queue[IEEE80211_AC_BE];
+	/* Priority 2: Same AC queue */
+	else if (ac_to_queue[ac] != IEEE80211_INVAL_HW_QUEUE)
+		queue = ac_to_queue[ac];
+	/* Priority 3a: If new AC is VO and VI exists - use VI */
+	else if (ac == IEEE80211_AC_VO &&
+		 ac_to_queue[IEEE80211_AC_VI] != IEEE80211_INVAL_HW_QUEUE)
+		queue = ac_to_queue[IEEE80211_AC_VI];
+	/* Priority 3b: No BE so only AC less than the new one is BK */
+	else if (ac_to_queue[IEEE80211_AC_BK] != IEEE80211_INVAL_HW_QUEUE)
+		queue = ac_to_queue[IEEE80211_AC_BK];
+	/* Priority 4a: No BE nor BK - use VI if exists */
+	else if (ac_to_queue[IEEE80211_AC_VI] != IEEE80211_INVAL_HW_QUEUE)
+		queue = ac_to_queue[IEEE80211_AC_VI];
+	/* Priority 4b: No BE, BK nor VI - use VO if exists */
+	else if (ac_to_queue[IEEE80211_AC_VO] != IEEE80211_INVAL_HW_QUEUE)
+		queue = ac_to_queue[IEEE80211_AC_VO];
+
+	/* Make sure queue found (or not) is legal */
+	if (!((queue >= IWL_MVM_DQA_MIN_MGMT_QUEUE &&
+	       queue <= IWL_MVM_DQA_MAX_MGMT_QUEUE) ||
+	      (queue >= IWL_MVM_DQA_MIN_DATA_QUEUE &&
+	       queue <= IWL_MVM_DQA_MAX_DATA_QUEUE) ||
+	      (queue == IWL_MVM_DQA_BSS_CLIENT_QUEUE))) {
+		IWL_ERR(mvm, "No DATA queues available to share\n");
+		queue = -ENOSPC;
+	}
+
+	return queue;
+}
+
 static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 				   struct ieee80211_sta *sta, u8 ac, int tid,
 				   struct ieee80211_hdr *hdr)
@@ -434,11 +531,17 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	bool using_inactive_queue = false;
 	unsigned long disable_agg_tids = 0;
 	enum iwl_mvm_agg_state queue_state;
+	bool shared_queue = false;
 	int ssn;
+	unsigned long tfd_queue_mask;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
+	spin_lock_bh(&mvmsta->lock);
+	tfd_queue_mask = mvmsta->tfd_queue_msk;
+	spin_unlock_bh(&mvmsta->lock);
+
 	spin_lock_bh(&mvm->queue_info_lock);
 
 	/*
@@ -487,20 +590,32 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 				    queue, mvmsta->sta_id, tid);
 	}
 
+	/* No free queue - we'll have to share */
+	if (queue <= 0) {
+		queue = iwl_mvm_get_shared_queue(mvm, tfd_queue_mask, ac);
+		if (queue > 0) {
+			shared_queue = true;
+			mvm->queue_info[queue].status = IWL_MVM_QUEUE_SHARED;
+		}
+	}
+
 	/*
 	 * Mark TXQ as ready, even though it hasn't been fully configured yet,
 	 * to make sure no one else takes it.
 	 * This will allow avoiding re-acquiring the lock at the end of the
 	 * configuration. On error we'll mark it back as free.
 	 */
-	if (queue >= 0)
+	if ((queue > 0) && !shared_queue)
 		mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
 
 	spin_unlock_bh(&mvm->queue_info_lock);
 
-	/* TODO: support shared queues for same RA */
-	if (queue < 0)
+	/* This shouldn't happen - out of queues */
+	if (WARN_ON(queue <= 0)) {
+		IWL_ERR(mvm, "No available queues for tid %d on sta_id %d\n",
+			tid, cfg.sta_id);
 		return -ENOSPC;
+	}
 
 	/*
 	 * Actual en/disablement of aggregations is through the ADD_STA HCMD,
@@ -543,8 +658,27 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		}
 	}
 
-	IWL_DEBUG_TX_QUEUES(mvm, "Allocating queue #%d to sta %d on tid %d\n",
-			    queue, mvmsta->sta_id, tid);
+	IWL_DEBUG_TX_QUEUES(mvm,
+			    "Allocating %squeue #%d to sta %d on tid %d\n",
+			    shared_queue ? "shared " : "", queue,
+			    mvmsta->sta_id, tid);
+
+	if (shared_queue) {
+		/* Disable any open aggs on this queue */
+		disable_agg_tids = iwl_mvm_get_queue_agg_tids(mvm, queue);
+
+		if (disable_agg_tids) {
+			IWL_DEBUG_TX_QUEUES(mvm, "Disabling aggs on queue %d\n",
+					    queue);
+			iwl_mvm_invalidate_sta_queue(mvm, queue,
+						     disable_agg_tids, false);
+		}
+
+		/* Mark queue as shared in transport */
+		iwl_trans_txq_set_shared_mode(mvm->trans, queue, true);
+
+		/* TODO: a redirection may be required - DQA phase 2 */
+	}
 
 	ssn = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 	iwl_mvm_enable_txq(mvm, queue, mac_queue, ssn, &cfg,
@@ -560,15 +694,20 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		mvmsta->reserved_queue = IEEE80211_INVAL_HW_QUEUE;
 	spin_unlock_bh(&mvmsta->lock);
 
-	ret = iwl_mvm_sta_send_to_fw(mvm, sta, true, STA_MODIFY_QUEUES);
-	if (ret)
-		goto out_err;
+	if (!shared_queue) {
+		ret = iwl_mvm_sta_send_to_fw(mvm, sta, true, STA_MODIFY_QUEUES);
+		if (ret)
+			goto out_err;
 
-	/* If we need to re-enable aggregations... */
-	if (queue_state == IWL_AGG_ON)
-		ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
+		/* If we need to re-enable aggregations... */
+		if (queue_state == IWL_AGG_ON) {
+			ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
+			if (ret)
+				goto out_err;
+		}
+	}
 
-	return ret;
+	return 0;
 
 out_err:
 	iwl_mvm_disable_txq(mvm, queue, mac_queue, tid, 0);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index a0cb5ca..2fc51e7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -655,15 +655,22 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	}
 
 	/* Update mappings and refcounts */
+	if (mvm->queue_info[queue].hw_queue_refcount > 0)
+		enable_queue = false;
+
 	mvm->queue_info[queue].hw_queue_to_mac80211 |= BIT(mac80211_queue);
 	mvm->queue_info[queue].hw_queue_refcount++;
-	if (mvm->queue_info[queue].hw_queue_refcount > 1)
-		enable_queue = false;
-	else
-		mvm->queue_info[queue].ra_sta_id = cfg->sta_id;
 	mvm->queue_info[queue].tid_bitmap |= BIT(cfg->tid);
 	mvm->queue_info[queue].ra_sta_id = cfg->sta_id;
 
+	if (enable_queue) {
+		if (cfg->tid != IWL_MAX_TID_COUNT)
+			mvm->queue_info[queue].mac80211_ac =
+				tid_to_mac80211_ac[cfg->tid];
+		else
+			mvm->queue_info[queue].mac80211_ac = IEEE80211_AC_VO;
+	}
+
 	IWL_DEBUG_TX_QUEUES(mvm,
 			    "Enabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
 			    queue, mvm->queue_info[queue].hw_queue_refcount,
@@ -1154,7 +1161,8 @@ void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 		queue_tid_bitmap = mvm->queue_info[i].tid_bitmap;
 
 		/* If TXQ isn't in active use anyway - nothing to do here... */
-		if (mvm->queue_info[i].status != IWL_MVM_QUEUE_READY) {
+		if (mvm->queue_info[i].status != IWL_MVM_QUEUE_READY &&
+		    mvm->queue_info[i].status != IWL_MVM_QUEUE_SHARED) {
 			spin_unlock_bh(&mvm->queue_info_lock);
 			continue;
 		}
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 482836e..8bfa915 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -471,6 +471,8 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int queue, u16 ssn,
 			       unsigned int wdg_timeout);
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue,
 				bool configure_scd);
+void iwl_trans_pcie_txq_set_shared_mode(struct iwl_trans *trans, u32 txq_id,
+					bool shared_mode);
 int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		      struct iwl_device_cmd *dev_cmd, int txq_id);
 void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 33fd217..3badebb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2745,6 +2745,8 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.txq_disable = iwl_trans_pcie_txq_disable,
 	.txq_enable = iwl_trans_pcie_txq_enable,
 
+	.txq_set_shared_mode = iwl_trans_pcie_txq_set_shared_mode,
+
 	.wait_tx_queue_empty = iwl_trans_pcie_wait_txq_empty,
 	.freeze_txq_timer = iwl_trans_pcie_freeze_txq_timer,
 	.block_txq_ptrs = iwl_trans_pcie_block_txq_ptrs,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index d6beac9..8901d49 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1354,6 +1354,15 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 	txq->active = true;
 }
 
+void iwl_trans_pcie_txq_set_shared_mode(struct iwl_trans *trans, u32 txq_id,
+					bool shared_mode)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+
+	txq->ampdu = !shared_mode;
+}
+
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
 				bool configure_scd)
 {
-- 
2.8.1

