Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35220 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751153AbeCPLvs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 07:51:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Mar 2018 13:51:33 +0200
Message-Id: <20180316115136.1234-3-luca@coelho.fi> (sfid-20180316_125155_493302_07B39F61)
In-Reply-To: <20180316115136.1234-1-luca@coelho.fi>
References: <20180316115136.1234-1-luca@coelho.fi>
Subject: [PATCH 2/5] iwlwifi: mvm: clear tx queue id when unreserving aggregation queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

When a queue is reserved for aggregation, the queue id is assigned
to the tid_data. This is fine since iwl_mvm_sta_tx_agg_oper()
takes care of allocating the queue before actual tx starts.
When the reservation is cancelled (e.g. when the AP declined the
aggregation request) the tid_data is not cleared. As a result,
following tx for this tid was trying to use an unallocated queue.

Fix this by setting the txq_id for the tid to invalid when unreserving
the queue.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 5be4bae5b70d..0b3a780aee12 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2696,8 +2696,10 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 static void iwl_mvm_unreserve_agg_queue(struct iwl_mvm *mvm,
 					struct iwl_mvm_sta *mvmsta,
-					u16 txq_id)
+					struct iwl_mvm_tid_data *tid_data)
 {
+	u16 txq_id = tid_data->txq_id;
+
 	if (iwl_mvm_has_new_tx_api(mvm))
 		return;
 
@@ -2709,8 +2711,10 @@ static void iwl_mvm_unreserve_agg_queue(struct iwl_mvm *mvm,
 	 * allocated through iwl_mvm_enable_txq, so we can just mark it back as
 	 * free.
 	 */
-	if (mvm->queue_info[txq_id].status == IWL_MVM_QUEUE_RESERVED)
+	if (mvm->queue_info[txq_id].status == IWL_MVM_QUEUE_RESERVED) {
 		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_FREE;
+		tid_data->txq_id = IWL_MVM_INVALID_QUEUE;
+	}
 
 	spin_unlock_bh(&mvm->queue_info_lock);
 }
@@ -2741,7 +2745,7 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	mvmsta->agg_tids &= ~BIT(tid);
 
-	iwl_mvm_unreserve_agg_queue(mvm, mvmsta, txq_id);
+	iwl_mvm_unreserve_agg_queue(mvm, mvmsta, tid_data);
 
 	switch (tid_data->state) {
 	case IWL_AGG_ON:
@@ -2808,7 +2812,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	mvmsta->agg_tids &= ~BIT(tid);
 	spin_unlock_bh(&mvmsta->lock);
 
-	iwl_mvm_unreserve_agg_queue(mvm, mvmsta, txq_id);
+	iwl_mvm_unreserve_agg_queue(mvm, mvmsta, tid_data);
 
 	if (old_state >= IWL_AGG_ON) {
 		iwl_mvm_drain_sta(mvm, mvmsta, true);
-- 
2.16.2
