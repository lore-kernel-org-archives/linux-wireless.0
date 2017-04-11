Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50584 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754737AbdDKMiG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:38:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:26 +0300
Message-Id: <20170411123742.12214-10-luca@coelho.fi> (sfid-20170411_143813_939547_992B988F)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 09/25] iwlwifi: mvm: cleanup pending frames in DQA mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When a station is asleep, the fw will set it as "asleep".
All queues that are used only by one station will be stopped by
the fw.

In pre-DQA mode this was relevant for aggregation queues. However,
in DQA mode a queue is owned by one station only, so all queues
will be stopped.
As a result, we don't expect to get filtered frames back to
mac80211 and don't have to maintain the entire pending_frames
state logic, the same way as we do in aggregations.

The correct behavior is to align DQA behavior with the aggregation
queue behaviour pre-DQA:
- Don't count pending frames.
- Let mac80211 know we have frames in these queues so that it can
properly handle trigger frames.

When a trigger frame is received, mac80211 tells the driver to send
frames from the queues using release_buffered_frames.
The driver will tell the fw to let frames out even if the station
is asleep. This is done by iwl_mvm_sta_modify_sleep_tx_count.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  8 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 11 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 41 ++++++++++-------------
 4 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d37b1695c64e..265d9eb8f0b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2319,7 +2319,7 @@ iwl_mvm_mac_release_buffered_frames(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
-	/* Called when we need to transmit (a) frame(s) from agg queue */
+	/* Called when we need to transmit (a) frame(s) from agg or dqa queue */
 
 	iwl_mvm_sta_modify_sleep_tx_count(mvm, sta, reason, num_frames,
 					  tids, more_data, true);
@@ -2338,10 +2338,14 @@ static void __iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
 	for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++) {
 		struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
 
-		if (tid_data->state != IWL_AGG_ON &&
+		if (!iwl_mvm_is_dqa_supported(mvm) &&
+		    tid_data->state != IWL_AGG_ON &&
 		    tid_data->state != IWL_EMPTYING_HW_QUEUE_DELBA)
 			continue;
 
+		if (tid_data->txq_id == IEEE80211_INVAL_HW_QUEUE)
+			continue;
+
 		__set_bit(tid_data->txq_id, &txqs);
 
 		if (iwl_mvm_tid_queued(tid_data) == 0)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index bd1dcc863d8f..b51a2853cc80 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -3135,7 +3135,7 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 				       struct ieee80211_sta *sta,
 				       enum ieee80211_frame_release_type reason,
 				       u16 cnt, u16 tids, bool more_data,
-				       bool agg)
+				       bool single_sta_queue)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_add_sta_cmd cmd = {
@@ -3155,14 +3155,14 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 	for_each_set_bit(tid, &_tids, IWL_MAX_TID_COUNT)
 		cmd.awake_acs |= BIT(tid_to_ucode_ac[tid]);
 
-	/* If we're releasing frames from aggregation queues then check if the
-	 * all queues combined that we're releasing frames from have
+	/* If we're releasing frames from aggregation or dqa queues then check
+	 * if all the queues that we're releasing frames from, combined, have:
 	 *  - more frames than the service period, in which case more_data
 	 *    needs to be set
 	 *  - fewer than 'cnt' frames, in which case we need to adjust the
 	 *    firmware command (but do that unconditionally)
 	 */
-	if (agg) {
+	if (single_sta_queue) {
 		int remaining = cnt;
 		int sleep_tx_count;
 
@@ -3172,7 +3172,8 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 			u16 n_queued;
 
 			tid_data = &mvmsta->tid_data[tid];
-			if (WARN(tid_data->state != IWL_AGG_ON &&
+			if (WARN(!iwl_mvm_is_dqa_supported(mvm) &&
+				 tid_data->state != IWL_AGG_ON &&
 				 tid_data->state != IWL_EMPTYING_HW_QUEUE_DELBA,
 				 "TID %d state is %d\n",
 				 tid, tid_data->state)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 4be34f902278..1927ce607798 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -547,7 +547,7 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 				       struct ieee80211_sta *sta,
 				       enum ieee80211_frame_release_type reason,
 				       u16 cnt, u16 tids, bool more_data,
-				       bool agg);
+				       bool single_sta_queue);
 int iwl_mvm_drain_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 		      bool drain);
 void iwl_mvm_sta_modify_disable_tx(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index dd2b4a300819..3f37075f4cde 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -628,8 +629,10 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	 * values.
 	 * Note that we don't need to make sure it isn't agg'd, since we're
 	 * TXing non-sta
+	 * For DQA mode - we shouldn't increase it though
 	 */
-	atomic_inc(&mvm->pending_frames[sta_id]);
+	if (!iwl_mvm_is_dqa_supported(mvm))
+		atomic_inc(&mvm->pending_frames[sta_id]);
 
 	return 0;
 }
@@ -1005,11 +1008,8 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	spin_unlock(&mvmsta->lock);
 
-	/* Increase pending frames count if this isn't AMPDU */
-	if ((iwl_mvm_is_dqa_supported(mvm) &&
-	     mvmsta->tid_data[tx_cmd->tid_tspec].state != IWL_AGG_ON &&
-	     mvmsta->tid_data[tx_cmd->tid_tspec].state != IWL_AGG_STARTING) ||
-	    (!iwl_mvm_is_dqa_supported(mvm) && !is_ampdu))
+	/* Increase pending frames count if this isn't AMPDU or DQA queue */
+	if (!iwl_mvm_is_dqa_supported(mvm) && !is_ampdu)
 		atomic_inc(&mvm->pending_frames[mvmsta->sta_id]);
 
 	return 0;
@@ -1079,12 +1079,13 @@ static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvmsta->lock);
 
 	if ((tid_data->state == IWL_AGG_ON ||
-	     tid_data->state == IWL_EMPTYING_HW_QUEUE_DELBA) &&
+	     tid_data->state == IWL_EMPTYING_HW_QUEUE_DELBA ||
+	     iwl_mvm_is_dqa_supported(mvm)) &&
 	    iwl_mvm_tid_queued(tid_data) == 0) {
 		/*
-		 * Now that this aggregation queue is empty tell mac80211 so it
-		 * knows we no longer have frames buffered for the station on
-		 * this TID (for the TIM bitmap calculation.)
+		 * Now that this aggregation or DQA queue is empty tell
+		 * mac80211 so it knows we no longer have frames buffered for
+		 * the station on this TID (for the TIM bitmap calculation.)
 		 */
 		ieee80211_sta_set_buffered(sta, tid, false);
 	}
@@ -1257,7 +1258,6 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	u8 skb_freed = 0;
 	u16 next_reclaimed, seq_ctl;
 	bool is_ndp = false;
-	bool txq_agg = false; /* Is this TXQ aggregated */
 
 	__skb_queue_head_init(&skbs);
 
@@ -1283,6 +1283,10 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			info->flags |= IEEE80211_TX_STAT_ACK;
 			break;
 		case TX_STATUS_FAIL_DEST_PS:
+			/* In DQA, the FW should have stopped the queue and not
+			 * return this status
+			 */
+			WARN_ON(iwl_mvm_is_dqa_supported(mvm));
 			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 			break;
 		default:
@@ -1387,15 +1391,6 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			bool send_eosp_ndp = false;
 
 			spin_lock_bh(&mvmsta->lock);
-			if (iwl_mvm_is_dqa_supported(mvm)) {
-				enum iwl_mvm_agg_state state;
-
-				state = mvmsta->tid_data[tid].state;
-				txq_agg = (state == IWL_AGG_ON ||
-					state == IWL_EMPTYING_HW_QUEUE_DELBA);
-			} else {
-				txq_agg = txq_id >= mvm->first_agg_queue;
-			}
 
 			if (!is_ndp) {
 				tid_data->next_reclaimed = next_reclaimed;
@@ -1452,11 +1447,11 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	 * If the txq is not an AMPDU queue, there is no chance we freed
 	 * several skbs. Check that out...
 	 */
-	if (txq_agg)
+	if (iwl_mvm_is_dqa_supported(mvm) || txq_id >= mvm->first_agg_queue)
 		goto out;
 
 	/* We can't free more than one frame at once on a shared queue */
-	WARN_ON(!iwl_mvm_is_dqa_supported(mvm) && (skb_freed > 1));
+	WARN_ON(skb_freed > 1);
 
 	/* If we have still frames for this STA nothing to do here */
 	if (!atomic_sub_and_test(skb_freed, &mvm->pending_frames[sta_id]))
-- 
2.11.0
