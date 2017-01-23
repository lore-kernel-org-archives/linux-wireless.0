Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36278 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751757AbdAWWSj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:18:39 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Sara Sharon <sara.sharon@intel.com>
Date: Tue, 24 Jan 2017 00:03:49 +0200
Message-Id: <20170123220350.25305-25-luca@coelho.fi> (sfid-20170123_231842_532211_541D81FD)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 24/25] iwlwifi: mvm: use mvm_disable_queue instead of sharing logic
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When removing inactive queue - use the central disable queue
function. This is needed due to a000 changes to come, but is
a proper cleanup anyway.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h   |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c   | 22 ++++++++--------------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 10 ++++++----
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 4a9cb76b7611..a672aa71c656 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1657,8 +1657,8 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
  * Disable a TXQ.
  * Note that in non-DQA mode the %mac80211_queue and %tid params are ignored.
  */
-void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
-			 u8 tid, u8 flags);
+int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
+			u8 tid, u8 flags);
 int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id, u8 minq, u8 maxq);
 
 /* Return a bitmask with all the hw supported queues, except for the
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index cf8222a8b588..4ea9589e8823 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -755,28 +755,22 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	 * first
 	 */
 	if (using_inactive_queue) {
-		struct iwl_scd_txq_cfg_cmd cmd = {
-			.scd_queue = queue,
-			.action = SCD_CFG_DISABLE_QUEUE,
-		};
-		u8 txq_curr_ac;
-
-		disable_agg_tids = iwl_mvm_remove_sta_queue_marking(mvm, queue);
+		u8 txq_curr_ac, sta_id;
 
 		spin_lock_bh(&mvm->queue_info_lock);
 		txq_curr_ac = mvm->queue_info[queue].mac80211_ac;
-		cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
-		cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[txq_curr_ac];
-		cmd.tid = mvm->queue_info[queue].txq_tid;
+		sta_id = mvm->queue_info[queue].ra_sta_id;
 		spin_unlock_bh(&mvm->queue_info_lock);
 
+		disable_agg_tids = iwl_mvm_remove_sta_queue_marking(mvm, queue);
 		/* Disable the queue */
 		if (disable_agg_tids)
 			iwl_mvm_invalidate_sta_queue(mvm, queue,
 						     disable_agg_tids, false);
-		iwl_trans_txq_disable(mvm->trans, queue, false);
-		ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd),
-					   &cmd);
+
+		ret = iwl_mvm_disable_txq(mvm, queue,
+					  mvmsta->vif->hw_queue[txq_curr_ac],
+					  tid, 0);
 		if (ret) {
 			IWL_ERR(mvm,
 				"Failed to free inactive queue %d (ret=%d)\n",
@@ -791,7 +785,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		}
 
 		/* If TXQ is allocated to another STA, update removal in FW */
-		if (cmd.sta_id != mvmsta->sta_id)
+		if (sta_id != mvmsta->sta_id)
 			iwl_mvm_invalidate_sta_queue(mvm, queue, 0, true);
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index d04babd99b53..2beea3b98e52 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -706,8 +706,8 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	}
 }
 
-void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
-			 u8 tid, u8 flags)
+int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
+			u8 tid, u8 flags)
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
@@ -720,7 +720,7 @@ void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 
 	if (WARN_ON(mvm->queue_info[queue].hw_queue_refcount == 0)) {
 		spin_unlock_bh(&mvm->queue_info_lock);
-		return;
+		return 0;
 	}
 
 	mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
@@ -760,7 +760,7 @@ void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	/* If the queue is still enabled - nothing left to do in this func */
 	if (cmd.action == SCD_CFG_ENABLE_QUEUE) {
 		spin_unlock_bh(&mvm->queue_info_lock);
-		return;
+		return 0;
 	}
 
 	cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
@@ -791,6 +791,8 @@ void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	if (ret)
 		IWL_ERR(mvm, "Failed to disable queue %d (ret=%d)\n",
 			queue, ret);
+
+	return ret;
 }
 
 /**
-- 
2.11.0
