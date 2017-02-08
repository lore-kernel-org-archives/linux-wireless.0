Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39174 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932093AbdBHL2d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:28:33 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 13:23:11 +0200
Message-Id: <20170208112322.29413-7-luca@coelho.fi> (sfid-20170208_122839_816798_FB5ADB16)
In-Reply-To: <20170208112322.29413-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
Subject: [PATCH 06/17] iwlwifi: mvm: fix references to first_agg_queue in DQA mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In DQA mode, first_agg_queue is initialized to
IWL_MVM_DQA_MIN_DATA_QUEUE. This causes two bugs in the tx response
flow:

1. When TX fails, we set IEEE80211_TX_STAT_AMPDU_NO_BACK regardless
   if we actually have aggregation open on the queue. This causes
   mac80211 to send a BAR frame even though there is no aggregation
   open.
   Fix that by simply checking the AMPDU flag that is set on by
   mac80211 for AMPDU packets.

2. When reclaiming frames in aggregation mode, we reclaim based on
   scheduler ssn and not the SN.
   The reason is that scheduler ssn may be ahead of SN due to a hole
   in the BA window that was filled.
   However, if we have aggregations open on IWL_MVM_DQA_BSS_CLIENT_QUEUE
   the reclaim flow will still go to the code of non-aggregation
   instead of the aggregation code since IWL_MVM_DQA_BSS_CLIENT_QUEUE
   is smaller than IWL_MVM_DQA_MIN_DATA_QUEUE, although it is a valid
   aggregation queue.
   Fix that by always using the aggregation reclaim code by default in
   DQA mode (currently it is implicitly used by default for all queues
   except the reserved BSS queue).

Fixes: cf961e16620f ("iwlwifi: mvm: support dqa-mode agg on non-shared queue")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 4ba639eda7a3..1d147599cca9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1274,8 +1274,6 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 
 		memset(&info->status, 0, sizeof(info->status));
 
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-
 		/* inform mac80211 about what happened with the frame */
 		switch (status & TX_STATUS_MSK) {
 		case TX_STATUS_SUCCESS:
@@ -1298,10 +1296,11 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			(void *)(uintptr_t)le32_to_cpu(tx_resp->initial_rate);
 
 		/* Single frame failure in an AMPDU queue => send BAR */
-		if (txq_id >= mvm->first_agg_queue &&
+		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
 		    !(info->flags & IEEE80211_TX_STAT_ACK) &&
 		    !(info->flags & IEEE80211_TX_STAT_TX_FILTERED))
 			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
+		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 
 		/* W/A FW bug: seq_ctl is wrong when the status isn't success */
 		if (status != TX_STATUS_SUCCESS) {
@@ -1336,7 +1335,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		ieee80211_tx_status(mvm->hw, skb);
 	}
 
-	if (txq_id >= mvm->first_agg_queue) {
+	if (iwl_mvm_is_dqa_supported(mvm) || txq_id >= mvm->first_agg_queue) {
 		/* If this is an aggregation queue, we use the ssn since:
 		 * ssn = wifi seq_num % 256.
 		 * The seq_ctl is the sequence control of the packet to which
-- 
2.11.0
