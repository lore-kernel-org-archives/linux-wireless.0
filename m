Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36022 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750726AbdAWL4u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 06:56:50 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 23 Jan 2017 13:56:22 +0200
Message-Id: <20170123115622.23587-3-luca@coelho.fi> (sfid-20170123_125653_037628_7B3A9E7D)
In-Reply-To: <20170123115622.23587-1-luca@coelho.fi>
References: <20170123115622.23587-1-luca@coelho.fi>
Subject: [PATCH 2/2] iwlwifi: mvm: avoid crash on restart w/o reserved queues
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the firmware restarts in a situation in which any station
has no queue reserved anymore because that queue was used, the
code will crash trying to access the queue_info array at the
offset 255, which is far too big. Fix this by checking that a
queue is actually reserved before writing its status.

Fixes: 8d98ae6eb0d5 ("iwlwifi: mvm: re-assign old queues after hw restart in dqa mode")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 636c8b03e318..09e9e2e3ed04 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1164,9 +1164,10 @@ static void iwl_mvm_realloc_queues_after_restart(struct iwl_mvm *mvm,
 		.frame_limit = IWL_FRAME_LIMIT,
 	};
 
-	/* Make sure reserved queue is still marked as such (or allocated) */
-	mvm->queue_info[mvm_sta->reserved_queue].status =
-		IWL_MVM_QUEUE_RESERVED;
+	/* Make sure reserved queue is still marked as such (if allocated) */
+	if (mvm_sta->reserved_queue != IEEE80211_INVAL_HW_QUEUE)
+		mvm->queue_info[mvm_sta->reserved_queue].status =
+			IWL_MVM_QUEUE_RESERVED;
 
 	for (i = 0; i <= IWL_MAX_TID_COUNT; i++) {
 		struct iwl_mvm_tid_data *tid_data = &mvm_sta->tid_data[i];
-- 
2.11.0
