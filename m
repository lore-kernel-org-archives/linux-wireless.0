Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60568 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751142AbdFBJfa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:35:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 12:35:08 +0300
Message-Id: <20170602093516.16369-3-luca@coelho.fi> (sfid-20170602_113539_028873_075EF418)
In-Reply-To: <20170602093516.16369-1-luca@coelho.fi>
References: <20170602093516.16369-1-luca@coelho.fi>
Subject: [PATCH 02/10] iwlwifi: mvm: Fix command queue number on d0i3 flow
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

During d0i3 flow we flush all the queue except from the command queue.
Currently, in this flow the command queue is hard coded to 9.
In DQA the command queue number has changed from 9 to 0.
Fix that.

Fixes: 097129c9e625 ("iwlwifi: mvm: move cmd queue to be #0 in dqa mode")
Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 4e74a6b90e70..ed20c0c5abc8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1730,8 +1730,11 @@ int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id, u8 minq, u8 maxq);
  */
 static inline u32 iwl_mvm_flushable_queues(struct iwl_mvm *mvm)
 {
+	u32 cmd_queue = iwl_mvm_is_dqa_supported(mvm) ? IWL_MVM_DQA_CMD_QUEUE :
+		IWL_MVM_CMD_QUEUE;
+
 	return ((BIT(mvm->cfg->base_params->num_of_queues) - 1) &
-		~BIT(IWL_MVM_CMD_QUEUE));
+		~BIT(cmd_queue));
 }
 
 static inline
-- 
2.11.0
