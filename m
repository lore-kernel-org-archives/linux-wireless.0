Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50190 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S944575AbcJSPSR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:18:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 13:07:47 +0300
Message-Id: <20161019100755.23874-3-luca@coelho.fi> (sfid-20161019_171822_685486_15BDD41C)
In-Reply-To: <20161019100755.23874-1-luca@coelho.fi>
References: <20161019100755.23874-1-luca@coelho.fi>
Subject: [PATCH 02/10] iwlwifi: mvm: fix reserved txq freeing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

If a TXQ's marking as a reserved queue is removed,
when removing the STA the driver might try to access
out of bounds memory. Make sure the reserved queue
is freed only if it is still reserved.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index a65030f..c9dcb70 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1494,12 +1494,15 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		ret = iwl_mvm_drain_sta(mvm, mvm_sta, false);
 
 		/* If DQA is supported - the queues can be disabled now */
-		if (iwl_mvm_is_dqa_supported(mvm)) {
+		if (iwl_mvm_is_dqa_supported(mvm))
+			iwl_mvm_disable_sta_queues(mvm, vif, mvm_sta);
+
+		/* If there is a TXQ still marked as reserved - free it */
+		if (iwl_mvm_is_dqa_supported(mvm) &&
+		    mvm_sta->reserved_queue != IEEE80211_INVAL_HW_QUEUE) {
 			u8 reserved_txq = mvm_sta->reserved_queue;
 			enum iwl_mvm_queue_status *status;
 
-			iwl_mvm_disable_sta_queues(mvm, vif, mvm_sta);
-
 			/*
 			 * If no traffic has gone through the reserved TXQ - it
 			 * is still marked as IWL_MVM_QUEUE_RESERVED, and
-- 
2.9.3
