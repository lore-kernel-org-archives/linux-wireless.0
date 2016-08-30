Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41170 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758123AbcH3Ljc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:39:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 14:38:52 +0300
Message-Id: <1472557142-14782-6-git-send-email-luca@coelho.fi> (sfid-20160830_133941_241294_A9F5AB4E)
In-Reply-To: <1472557142-14782-1-git-send-email-luca@coelho.fi>
References: <1472556999.27868.86.camel@coelho.fi>
 <1472557142-14782-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 06/16] iwlwifi: mvm: re-assign old queues after hw restart in dqa mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When working in DQA mode, if a queue is shared and a HW restart
occurs, there might be a possible race condition between
stations on the queues, and an existing queue might be left
with no queues.

To solve this, make sure in DQA mode to re-assign the same
queues as before the HW restart.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 72 +++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 730ba78..1ddcbea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -759,8 +759,9 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		spin_unlock_bh(&mvm->queue_info_lock);
 
 		/* Disable the queue */
-		iwl_mvm_invalidate_sta_queue(mvm, queue, disable_agg_tids,
-					     true);
+		if (disable_agg_tids)
+			iwl_mvm_invalidate_sta_queue(mvm, queue,
+						     disable_agg_tids, false);
 		iwl_trans_txq_disable(mvm->trans, queue, false);
 		ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd),
 					   &cmd);
@@ -776,6 +777,10 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 
 			return ret;
 		}
+
+		/* If TXQ is allocated to another STA, update removal in FW */
+		if (cmd.sta_id != mvmsta->sta_id)
+			iwl_mvm_invalidate_sta_queue(mvm, queue, 0, true);
 	}
 
 	IWL_DEBUG_TX_QUEUES(mvm,
@@ -1072,6 +1077,61 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 	return 0;
 }
 
+/*
+ * In DQA mode, after a HW restart the queues should be allocated as before, in
+ * order to avoid race conditions when there are shared queues. This function
+ * does the re-mapping and queue allocation.
+ *
+ * Note that re-enabling aggregations isn't done in this function.
+ */
+static void iwl_mvm_realloc_queues_after_restart(struct iwl_mvm *mvm,
+						 struct iwl_mvm_sta *mvm_sta)
+{
+	unsigned int wdg_timeout =
+			iwl_mvm_get_wd_timeout(mvm, mvm_sta->vif, false, false);
+	int i;
+	struct iwl_trans_txq_scd_cfg cfg = {
+		.sta_id = mvm_sta->sta_id,
+		.frame_limit = IWL_FRAME_LIMIT,
+	};
+
+	/* Make sure reserved queue is still marked as such (or allocated) */
+	mvm->queue_info[mvm_sta->reserved_queue].status =
+		IWL_MVM_QUEUE_RESERVED;
+
+	for (i = 0; i <= IWL_MAX_TID_COUNT; i++) {
+		struct iwl_mvm_tid_data *tid_data = &mvm_sta->tid_data[i];
+		int txq_id = tid_data->txq_id;
+		int ac;
+		u8 mac_queue;
+
+		if (txq_id == IEEE80211_INVAL_HW_QUEUE)
+			continue;
+
+		skb_queue_head_init(&tid_data->deferred_tx_frames);
+
+		ac = tid_to_mac80211_ac[i];
+		mac_queue = mvm_sta->vif->hw_queue[ac];
+
+		cfg.tid = i;
+		cfg.fifo = iwl_mvm_ac_to_tx_fifo[ac];
+		cfg.aggregate = (txq_id >= IWL_MVM_DQA_MIN_DATA_QUEUE ||
+				 txq_id == IWL_MVM_DQA_BSS_CLIENT_QUEUE);
+
+		IWL_DEBUG_TX_QUEUES(mvm,
+				    "Re-mapping sta %d tid %d to queue %d\n",
+				    mvm_sta->sta_id, i, txq_id);
+
+		iwl_mvm_enable_txq(mvm, txq_id, mac_queue,
+				   IEEE80211_SEQ_TO_SN(tid_data->seq_number),
+				   &cfg, wdg_timeout);
+
+		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_READY;
+	}
+
+	atomic_set(&mvm->pending_frames[mvm_sta->sta_id], 0);
+}
+
 int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		    struct ieee80211_vif *vif,
 		    struct ieee80211_sta *sta)
@@ -1094,6 +1154,13 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 
 	spin_lock_init(&mvm_sta->lock);
 
+	/* In DQA mode, if this is a HW restart, re-alloc existing queues */
+	if (iwl_mvm_is_dqa_supported(mvm) &&
+	    test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+		iwl_mvm_realloc_queues_after_restart(mvm, mvm_sta);
+		goto update_fw;
+	}
+
 	mvm_sta->sta_id = sta_id;
 	mvm_sta->mac_id_n_color = FW_CMD_ID_AND_COLOR(mvmvif->id,
 						      mvmvif->color);
@@ -1157,6 +1224,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 			goto err;
 	}
 
+update_fw:
 	ret = iwl_mvm_sta_send_to_fw(mvm, sta, false, 0);
 	if (ret)
 		goto err;
-- 
2.8.1
