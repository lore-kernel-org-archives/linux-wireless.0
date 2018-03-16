Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35236 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751459AbeCPLvu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 07:51:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Mar 2018 13:51:35 +0200
Message-Id: <20180316115136.1234-5-luca@coelho.fi> (sfid-20180316_125200_625592_9A4C8E00)
In-Reply-To: <20180316115136.1234-1-luca@coelho.fi>
References: <20180316115136.1234-1-luca@coelho.fi>
Subject: [PATCH 4/5] iwlwifi: mvm: fix array out of bounds reference
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

When starting aggregation, the code checks the status of the queue
allocated to the aggregation tid, which might not yet be allocated
and thus the queue index may be invalid.
Fix this by reserving a new queue in case the queue id is invalid.

While at it, clean up some unreachable code (a condition that is
already handled earlier) and remove all the non-DQA comments since
non-DQA mode is no longer supported.

Fixes: cf961e16620f ("iwlwifi: mvm: support dqa-mode agg on non-shared queue")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 38 ++++++++--------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index fc13f6291c06..80067eb9ea05 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2479,28 +2479,12 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	/*
 	 * Note the possible cases:
-	 *  1. In DQA mode with an enabled TXQ - TXQ needs to become agg'ed
-	 *  2. Non-DQA mode: the TXQ hasn't yet been enabled, so find a free
-	 *	one and mark it as reserved
-	 *  3. In DQA mode, but no traffic yet on this TID: same treatment as in
-	 *	non-DQA mode, since the TXQ hasn't yet been allocated
-	 * Don't support case 3 for new TX path as it is not expected to happen
-	 * and aggregation will be offloaded soon anyway
+	 *  1. An enabled TXQ - TXQ needs to become agg'ed
+	 *  2. The TXQ hasn't yet been enabled, so find a free one and mark
+	 *	it as reserved
 	 */
 	txq_id = mvmsta->tid_data[tid].txq_id;
-	if (iwl_mvm_has_new_tx_api(mvm)) {
-		if (txq_id == IWL_MVM_INVALID_QUEUE) {
-			ret = -ENXIO;
-			goto release_locks;
-		}
-	} else if (unlikely(mvm->queue_info[txq_id].status ==
-			    IWL_MVM_QUEUE_SHARED)) {
-		ret = -ENXIO;
-		IWL_DEBUG_TX_QUEUES(mvm,
-				    "Can't start tid %d agg on shared queue!\n",
-				    tid);
-		goto release_locks;
-	} else if (mvm->queue_info[txq_id].status != IWL_MVM_QUEUE_READY) {
+	if (txq_id == IWL_MVM_INVALID_QUEUE) {
 		txq_id = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
 						 IWL_MVM_DQA_MIN_DATA_QUEUE,
 						 IWL_MVM_DQA_MAX_DATA_QUEUE);
@@ -2509,16 +2493,16 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			IWL_ERR(mvm, "Failed to allocate agg queue\n");
 			goto release_locks;
 		}
-		/*
-		 * TXQ shouldn't be in inactive mode for non-DQA, so getting
-		 * an inactive queue from iwl_mvm_find_free_queue() is
-		 * certainly a bug
-		 */
-		WARN_ON(mvm->queue_info[txq_id].status ==
-			IWL_MVM_QUEUE_INACTIVE);
 
 		/* TXQ hasn't yet been enabled, so mark it only as reserved */
 		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_RESERVED;
+	} else if (unlikely(mvm->queue_info[txq_id].status ==
+			    IWL_MVM_QUEUE_SHARED)) {
+		ret = -ENXIO;
+		IWL_DEBUG_TX_QUEUES(mvm,
+				    "Can't start tid %d agg on shared queue!\n",
+				    tid);
+		goto release_locks;
 	}
 
 	spin_unlock(&mvm->queue_info_lock);
-- 
2.16.2
