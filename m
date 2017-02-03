Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37896 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753442AbdBCOif (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:38:35 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:55 +0200
Message-Id: <20170203143812.7525-9-luca@coelho.fi> (sfid-20170203_153838_943907_588CB61C)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 08/25] iwlwifi: mvm: always free inactive queue when moving ownership
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

If iwl_mvm_find_free_queue() doesn't find a free queue, it will
return an inactive one.
However, not all the call paths free this queue before reassigning
it, which is a bug.
Check it in other paths and act accordingly.

Fixes: 9794c64f302d ("iwlwifi: mvm: support dqa queue inactivation upon timeout")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 101 ++++++++++++++++++---------
 1 file changed, 69 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 40e7fc5f1f1f..962920861ccf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -457,6 +457,52 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 	return disable_agg_tids;
 }
 
+static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
+				       bool same_sta)
+{
+	struct iwl_mvm_sta *mvmsta;
+	u8 txq_curr_ac, sta_id, tid;
+	unsigned long disable_agg_tids = 0;
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	txq_curr_ac = mvm->queue_info[queue].mac80211_ac;
+	sta_id = mvm->queue_info[queue].ra_sta_id;
+	tid = mvm->queue_info[queue].txq_tid;
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, sta_id);
+
+	disable_agg_tids = iwl_mvm_remove_sta_queue_marking(mvm, queue);
+	/* Disable the queue */
+	if (disable_agg_tids)
+		iwl_mvm_invalidate_sta_queue(mvm, queue,
+					     disable_agg_tids, false);
+
+	ret = iwl_mvm_disable_txq(mvm, queue,
+				  mvmsta->vif->hw_queue[txq_curr_ac],
+				  tid, 0);
+	if (ret) {
+		/* Re-mark the inactive queue as inactive */
+		spin_lock_bh(&mvm->queue_info_lock);
+		mvm->queue_info[queue].status = IWL_MVM_QUEUE_INACTIVE;
+		spin_unlock_bh(&mvm->queue_info_lock);
+		IWL_ERR(mvm,
+			"Failed to free inactive queue %d (ret=%d)\n",
+			queue, ret);
+
+		return ret;
+	}
+
+	/* If TXQ is allocated to another STA, update removal in FW */
+	if (!same_sta)
+		iwl_mvm_invalidate_sta_queue(mvm, queue, 0, true);
+
+	return 0;
+}
+
 static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
 				    unsigned long tfd_queue_mask, u8 ac)
 {
@@ -645,7 +691,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		iwl_mvm_get_wd_timeout(mvm, mvmsta->vif, false, false);
 	u8 mac_queue = mvmsta->vif->hw_queue[ac];
 	int queue = -1;
-	bool using_inactive_queue = false;
+	bool using_inactive_queue = false, same_sta = false;
 	unsigned long disable_agg_tids = 0;
 	enum iwl_mvm_agg_state queue_state;
 	bool shared_queue = false;
@@ -702,6 +748,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	    mvm->queue_info[queue].status == IWL_MVM_QUEUE_INACTIVE) {
 		mvm->queue_info[queue].status = IWL_MVM_QUEUE_RESERVED;
 		using_inactive_queue = true;
+		same_sta = mvm->queue_info[queue].ra_sta_id == mvmsta->sta_id;
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "Re-assigning TXQ %d: sta_id=%d, tid=%d\n",
 				    queue, mvmsta->sta_id, tid);
@@ -748,38 +795,9 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	 * first
 	 */
 	if (using_inactive_queue) {
-		u8 txq_curr_ac, sta_id;
-
-		spin_lock_bh(&mvm->queue_info_lock);
-		txq_curr_ac = mvm->queue_info[queue].mac80211_ac;
-		sta_id = mvm->queue_info[queue].ra_sta_id;
-		spin_unlock_bh(&mvm->queue_info_lock);
-
-		disable_agg_tids = iwl_mvm_remove_sta_queue_marking(mvm, queue);
-		/* Disable the queue */
-		if (disable_agg_tids)
-			iwl_mvm_invalidate_sta_queue(mvm, queue,
-						     disable_agg_tids, false);
-
-		ret = iwl_mvm_disable_txq(mvm, queue,
-					  mvmsta->vif->hw_queue[txq_curr_ac],
-					  tid, 0);
-		if (ret) {
-			IWL_ERR(mvm,
-				"Failed to free inactive queue %d (ret=%d)\n",
-				queue, ret);
-
-			/* Re-mark the inactive queue as inactive */
-			spin_lock_bh(&mvm->queue_info_lock);
-			mvm->queue_info[queue].status = IWL_MVM_QUEUE_INACTIVE;
-			spin_unlock_bh(&mvm->queue_info_lock);
-
+		ret = iwl_mvm_free_inactive_queue(mvm, queue, same_sta);
+		if (ret)
 			return ret;
-		}
-
-		/* If TXQ is allocated to another STA, update removal in FW */
-		if (sta_id != mvmsta->sta_id)
-			iwl_mvm_invalidate_sta_queue(mvm, queue, 0, true);
 	}
 
 	IWL_DEBUG_TX_QUEUES(mvm,
@@ -1095,6 +1113,7 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	int queue;
+	bool using_inactive_queue = false, same_sta = false;
 
 	/*
 	 * Check for inactive queues, so we don't reach a situation where we
@@ -1118,6 +1137,14 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 		spin_unlock_bh(&mvm->queue_info_lock);
 		IWL_ERR(mvm, "No available queues for new station\n");
 		return -ENOSPC;
+	} else if (mvm->queue_info[queue].status == IWL_MVM_QUEUE_INACTIVE) {
+		/*
+		 * If this queue is already allocated but inactive we'll need to
+		 * first free this queue before enabling it again, we'll mark
+		 * it as reserved to make sure no new traffic arrives on it
+		 */
+		using_inactive_queue = true;
+		same_sta = mvm->queue_info[queue].ra_sta_id == mvmsta->sta_id;
 	}
 	mvm->queue_info[queue].status = IWL_MVM_QUEUE_RESERVED;
 
@@ -1125,6 +1152,9 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 
 	mvmsta->reserved_queue = queue;
 
+	if (using_inactive_queue)
+		iwl_mvm_free_inactive_queue(mvm, queue, same_sta);
+
 	IWL_DEBUG_TX_QUEUES(mvm, "Reserving data queue #%d for sta_id %d\n",
 			    queue, mvmsta->sta_id);
 
@@ -2231,6 +2261,13 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			IWL_ERR(mvm, "Failed to allocate agg queue\n");
 			goto release_locks;
 		}
+		/*
+		 * TXQ shouldn't be in inactive mode for non-DQA, so getting
+		 * an inactive queue from iwl_mvm_find_free_queue() is
+		 * certainly a bug
+		 */
+		WARN_ON(mvm->queue_info[txq_id].status ==
+			IWL_MVM_QUEUE_INACTIVE);
 
 		/* TXQ hasn't yet been enabled, so mark it only as reserved */
 		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_RESERVED;
-- 
2.11.0
