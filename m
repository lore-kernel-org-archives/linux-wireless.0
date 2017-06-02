Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60868 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751147AbdFBL1T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:27:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:39 +0300
Message-Id: <20170602112553.2466-12-luca@coelho.fi> (sfid-20170602_132723_854788_BAB5FF98)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 11/25] iwlwifi: mvm: wait for the flushed queue only
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The function flushed only agg queue and no more traffic
is queued on it.
However, it waits for all queues to empty, which is not
necessary and may take more time.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index bf105c6572ba..9f74d4ff6b73 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2850,8 +2850,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		iwl_mvm_drain_sta(mvm, mvmsta, true);
 		if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), 0))
 			IWL_ERR(mvm, "Couldn't flush the AGG queue\n");
-		iwl_trans_wait_tx_queues_empty(mvm->trans,
-					       mvmsta->tfd_queue_msk);
+		iwl_trans_wait_tx_queues_empty(mvm->trans, BIT(txq_id));
 		iwl_mvm_drain_sta(mvm, mvmsta, false);
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
-- 
2.11.0
