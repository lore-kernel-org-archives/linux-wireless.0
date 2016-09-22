Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45506 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751580AbcIVUwq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 16:52:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 22 Sep 2016 23:52:10 +0300
Message-Id: <20160922205210.1778-11-luca@coelho.fi> (sfid-20160922_225301_721356_D1340DB3)
In-Reply-To: <20160922205210.1778-1-luca@coelho.fi>
References: <20160922205210.1778-1-luca@coelho.fi>
Subject: [PATCH 10/10] iwlwifi: mvm: initialise ADD_STA before sending it to the firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we unshare a queue, the ADD_STA was not properly
initialised.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 258a234..fc77188 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -933,7 +933,7 @@ static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
 
 	/* If aggs should be turned back on - do it */
 	if (mvmsta->tid_data[tid].state == IWL_AGG_ON) {
-		struct iwl_mvm_add_sta_cmd cmd;
+		struct iwl_mvm_add_sta_cmd cmd = {0};
 
 		mvmsta->tid_disable_agg &= ~BIT(tid);
 
-- 
2.9.3
