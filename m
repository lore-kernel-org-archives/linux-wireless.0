Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54710 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751150AbcIOSLm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:11:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:08 +0300
Message-Id: <20160915181131.32213-2-luca@coelho.fi> (sfid-20160915_201147_278486_5A552E16)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 02/25] iwlwifi: mvm: don't free queue after delba in dqa
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In DQA mode, a delBA might free the queue although it
shouldn't. Fix that.

Fixes: cf941e174ee2 ("iwlwifi: mvm: support dqa-mode agg on non-shared queue")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 8b91544..6271470 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1100,9 +1100,13 @@ static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "Can continue DELBA flow ssn = next_recl = %d\n",
 				    tid_data->next_reclaimed);
-		iwl_mvm_disable_txq(mvm, tid_data->txq_id,
-				    vif->hw_queue[tid_to_mac80211_ac[tid]], tid,
-				    CMD_ASYNC);
+		if (!iwl_mvm_is_dqa_supported(mvm)) {
+			u8 mac80211_ac = tid_to_mac80211_ac[tid];
+
+			iwl_mvm_disable_txq(mvm, tid_data->txq_id,
+					    vif->hw_queue[mac80211_ac], tid,
+					    CMD_ASYNC);
+		}
 		tid_data->state = IWL_AGG_OFF;
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
-- 
2.9.3
