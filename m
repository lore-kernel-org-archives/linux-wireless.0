Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54848 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752020AbcIOSMb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:12:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:20 +0300
Message-Id: <20160915181131.32213-14-luca@coelho.fi> (sfid-20160915_203149_033030_A3DC11D4)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 14/25] iwlwifi: mvm: free reserved queue on STA removal
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When a STA is removed in DQA mode, if no traffic went through
its reserved queue, the txq continues to be marked as
reserved and no STA can use it.

Make sure that in such a case the reserved queue is marked
as free when the STA is removed.

Fixes: commit 24afba7690e4 ("iwlwifi: mvm: support bss dynamic alloc/dealloc of queues")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index a92e12e..11c7e15 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1496,9 +1496,31 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		ret = iwl_mvm_drain_sta(mvm, mvm_sta, false);
 
 		/* If DQA is supported - the queues can be disabled now */
-		if (iwl_mvm_is_dqa_supported(mvm))
+		if (iwl_mvm_is_dqa_supported(mvm)) {
+			u8 reserved_txq = mvm_sta->reserved_queue;
+			enum iwl_mvm_queue_status *status;
+
 			iwl_mvm_disable_sta_queues(mvm, vif, mvm_sta);
 
+			/*
+			 * If no traffic has gone through the reserved TXQ - it
+			 * is still marked as IWL_MVM_QUEUE_RESERVED, and
+			 * should be manually marked as free again
+			 */
+			spin_lock_bh(&mvm->queue_info_lock);
+			status = &mvm->queue_info[reserved_txq].status;
+			if (WARN((*status != IWL_MVM_QUEUE_RESERVED) &&
+				 (*status != IWL_MVM_QUEUE_FREE),
+				 "sta_id %d reserved txq %d status %d",
+				 mvm_sta->sta_id, reserved_txq, *status)) {
+				spin_unlock_bh(&mvm->queue_info_lock);
+				return -EINVAL;
+			}
+
+			*status = IWL_MVM_QUEUE_FREE;
+			spin_unlock_bh(&mvm->queue_info_lock);
+		}
+
 		if (vif->type == NL80211_IFTYPE_STATION &&
 		    mvmvif->ap_sta_id == mvm_sta->sta_id) {
 			/* if associated - we can't remove the AP STA now */
-- 
2.9.3
