Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48546 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752137AbdLBQ3G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:06 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:46 +0200
Message-Id: <20171202162858.4167-4-luca@coelho.fi> (sfid-20171202_172911_397184_59F9F3FF)
In-Reply-To: <20171202162858.4167-1-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
Subject: [PATCH 03/15] iwlwifi: mvm: remove set but unused variable in iwl_mvm_roc_done_wk
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the removal of non-DQA code, we don't need the queues
variable any more. Remove it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index d3b8cb1e20b6..4de2ef809ccd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -101,7 +101,6 @@ void iwl_mvm_te_clear_data(struct iwl_mvm *mvm,
 void iwl_mvm_roc_done_wk(struct work_struct *wk)
 {
 	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm, roc_done_wk);
-	u32 queues = 0;
 
 	/*
 	 * Clear the ROC_RUNNING /ROC_AUX_RUNNING status bit.
@@ -110,14 +109,10 @@ void iwl_mvm_roc_done_wk(struct work_struct *wk)
 	 * in the case that the time event actually completed in the firmware
 	 * (which is handled in iwl_mvm_te_handle_notif).
 	 */
-	if (test_and_clear_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status)) {
-		queues |= BIT(IWL_MVM_OFFCHANNEL_QUEUE);
+	if (test_and_clear_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status))
 		iwl_mvm_unref(mvm, IWL_MVM_REF_ROC);
-	}
-	if (test_and_clear_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status)) {
-		queues |= BIT(mvm->aux_queue);
+	if (test_and_clear_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status))
 		iwl_mvm_unref(mvm, IWL_MVM_REF_ROC_AUX);
-	}
 
 	synchronize_net();
 
-- 
2.15.0
