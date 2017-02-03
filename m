Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38024 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753168AbdBCOkc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:40:32 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:05 +0200
Message-Id: <20170203143812.7525-19-luca@coelho.fi> (sfid-20170203_154046_428639_1BFC0160)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 18/25] iwlwifi: mvm: fix pending frame counter calculation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In DQA mode the check whether to decrement the pending frames
counter relies on the tid status and not on the txq id.
This may result in an inconsistent state of the pending frames
counter in case frame is queued on a non aggregation queue but
with this TID, and will be followed by a failure to remove the
station and later on SYSASSERT 0x3421 when trying to remove the
MAC.
Such frames are for example bar and qos NDPs.
Fix it by aligning the condition of incrementing the counter
with the condition of decrementing it - rely on TID state for
DQA mode.
Also, avoid internal error like this affecting station removal
for DQA mode - since we can know for sure it is an internal
error.

Fixes: cf961e16620f ("iwlwifi: mvm: support dqa-mode agg on non-shared queue")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 33 ++++++++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c  |  5 ++++-
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 40fb64ead469..1bad933b3ad4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1501,6 +1501,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	u8 sta_id = mvm_sta->sta_id;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1509,7 +1510,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		kfree(mvm_sta->dup_data);
 
 	if ((vif->type == NL80211_IFTYPE_STATION &&
-	     mvmvif->ap_sta_id == mvm_sta->sta_id) ||
+	     mvmvif->ap_sta_id == sta_id) ||
 	    iwl_mvm_is_dqa_supported(mvm)){
 		ret = iwl_mvm_drain_sta(mvm, mvm_sta, true);
 		if (ret)
@@ -1525,8 +1526,17 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		ret = iwl_mvm_drain_sta(mvm, mvm_sta, false);
 
 		/* If DQA is supported - the queues can be disabled now */
-		if (iwl_mvm_is_dqa_supported(mvm))
+		if (iwl_mvm_is_dqa_supported(mvm)) {
 			iwl_mvm_disable_sta_queues(mvm, vif, mvm_sta);
+			/*
+			 * If pending_frames is set at this point - it must be
+			 * driver internal logic error, since queues are empty
+			 * and removed successuly.
+			 * warn on it but set it to 0 anyway to avoid station
+			 * not being removed later in the function
+			 */
+			WARN_ON(atomic_xchg(&mvm->pending_frames[sta_id], 0));
+		}
 
 		/* If there is a TXQ still marked as reserved - free it */
 		if (iwl_mvm_is_dqa_supported(mvm) &&
@@ -1544,7 +1554,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 			if (WARN((*status != IWL_MVM_QUEUE_RESERVED) &&
 				 (*status != IWL_MVM_QUEUE_FREE),
 				 "sta_id %d reserved txq %d status %d",
-				 mvm_sta->sta_id, reserved_txq, *status)) {
+				 sta_id, reserved_txq, *status)) {
 				spin_unlock_bh(&mvm->queue_info_lock);
 				return -EINVAL;
 			}
@@ -1554,7 +1564,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		}
 
 		if (vif->type == NL80211_IFTYPE_STATION &&
-		    mvmvif->ap_sta_id == mvm_sta->sta_id) {
+		    mvmvif->ap_sta_id == sta_id) {
 			/* if associated - we can't remove the AP STA now */
 			if (vif->bss_conf.assoc)
 				return ret;
@@ -1563,7 +1573,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 			mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
 
 			/* clear d0i3_ap_sta_id if no longer relevant */
-			if (mvm->d0i3_ap_sta_id == mvm_sta->sta_id)
+			if (mvm->d0i3_ap_sta_id == sta_id)
 				mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
 		}
 	}
@@ -1572,7 +1582,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 	 * This shouldn't happen - the TDLS channel switch should be canceled
 	 * before the STA is removed.
 	 */
-	if (WARN_ON_ONCE(mvm->tdls_cs.peer.sta_id == mvm_sta->sta_id)) {
+	if (WARN_ON_ONCE(mvm->tdls_cs.peer.sta_id == sta_id)) {
 		mvm->tdls_cs.peer.sta_id = IWL_MVM_STATION_COUNT;
 		cancel_delayed_work(&mvm->tdls_cs.dwork);
 	}
@@ -1582,21 +1592,20 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 	 * calls the drain worker.
 	 */
 	spin_lock_bh(&mvm_sta->lock);
+
 	/*
 	 * There are frames pending on the AC queues for this station.
 	 * We need to wait until all the frames are drained...
 	 */
-	if (atomic_read(&mvm->pending_frames[mvm_sta->sta_id])) {
-		rcu_assign_pointer(mvm->fw_id_to_mac_id[mvm_sta->sta_id],
+	if (atomic_read(&mvm->pending_frames[sta_id])) {
+		rcu_assign_pointer(mvm->fw_id_to_mac_id[sta_id],
 				   ERR_PTR(-EBUSY));
 		spin_unlock_bh(&mvm_sta->lock);
 
 		/* disable TDLS sta queues on drain complete */
 		if (sta->tdls) {
-			mvm->tfd_drained[mvm_sta->sta_id] =
-							mvm_sta->tfd_queue_msk;
-			IWL_DEBUG_TDLS(mvm, "Draining TDLS sta %d\n",
-				       mvm_sta->sta_id);
+			mvm->tfd_drained[sta_id] = mvm_sta->tfd_queue_msk;
+			IWL_DEBUG_TDLS(mvm, "Draining TDLS sta %d\n", sta_id);
 		}
 
 		ret = iwl_mvm_drain_sta(mvm, mvm_sta, true);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 8daf4fbe4534..f82b765650d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1015,7 +1015,10 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	spin_unlock(&mvmsta->lock);
 
 	/* Increase pending frames count if this isn't AMPDU */
-	if (!is_ampdu)
+	if ((iwl_mvm_is_dqa_supported(mvm) &&
+	     mvmsta->tid_data[tx_cmd->tid_tspec].state != IWL_AGG_ON &&
+	     mvmsta->tid_data[tx_cmd->tid_tspec].state != IWL_AGG_STARTING) ||
+	    (!iwl_mvm_is_dqa_supported(mvm) && !is_ampdu))
 		atomic_inc(&mvm->pending_frames[mvmsta->sta_id]);
 
 	return 0;
-- 
2.11.0
