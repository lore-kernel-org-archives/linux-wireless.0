Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41036 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752115AbdG1O0p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:26:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:26 +0300
Message-Id: <20170728142337.19183-14-luca@coelho.fi> (sfid-20170728_162700_056885_09228ABA)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 13/24] iwlwifi: mvm: fix uninitialized var while waiting for queues to empty
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sharon Dvir <sharon.dvir@intel.com>

While waiting for queues to empty,
If txq_id == IWL_MVM_INVALID_QUEUE for all txq_ids,
ret is used uninitialized.
Found by Klocwork.

Fixes: d6d517b7730c ("iwlwifi: add wait for tx queue empty")
Signed-off-by: Sharon Dvir <sharon.dvir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 4adc8fecfaef..b196acd18252 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1619,10 +1619,11 @@ static void iwl_mvm_disable_sta_queues(struct iwl_mvm *mvm,
 int iwl_mvm_wait_sta_queues_empty(struct iwl_mvm *mvm,
 				  struct iwl_mvm_sta *mvm_sta)
 {
-	int i, ret;
+	int i;
 
 	for (i = 0; i < ARRAY_SIZE(mvm_sta->tid_data); i++) {
 		u16 txq_id;
+		int ret;
 
 		spin_lock_bh(&mvm_sta->lock);
 		txq_id = mvm_sta->tid_data[i].txq_id;
@@ -1633,10 +1634,10 @@ int iwl_mvm_wait_sta_queues_empty(struct iwl_mvm *mvm,
 
 		ret = iwl_trans_wait_txq_empty(mvm->trans, txq_id);
 		if (ret)
-			break;
+			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
-- 
2.13.2
