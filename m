Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54166 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954158AbdDYUXJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:27 +0300
Message-Id: <20170425202243.7844-10-luca@coelho.fi> (sfid-20170425_222329_484392_C56AC2E6)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 09/25] iwlwifi: mvm: don't reserve queue in TVQM mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The reserved queue is never used, save the trouble.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c   | 6 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 7 ++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index e502a6e6bf90..b5b7214a811f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1188,6 +1188,10 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 	int queue;
 	bool using_inactive_queue = false, same_sta = false;
 
+	/* queue reserving is disabled on new TX path */
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return 0;
+
 	/*
 	 * Check for inactive queues, so we don't reach a situation where we
 	 * can't add a STA due to a shortage in queues that doesn't really exist
@@ -1387,7 +1391,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		mvm_sta->dup_data = dup_data;
 	}
 
-	if (iwl_mvm_is_dqa_supported(mvm)) {
+	if (iwl_mvm_is_dqa_supported(mvm) && !iwl_mvm_has_new_tx_api(mvm)) {
 		ret = iwl_mvm_reserve_sta_stream(mvm, sta,
 						 ieee80211_vif_type_p2p(vif));
 		if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 1dde05697c29..987edc98a203 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -592,15 +592,16 @@ int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id, u8 minq, u8 maxq)
 
 	lockdep_assert_held(&mvm->queue_info_lock);
 
+	/* This should not be hit with new TX path */
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return -ENOSPC;
+
 	/* Start by looking for a free queue */
 	for (i = minq; i <= maxq; i++)
 		if (mvm->queue_info[i].hw_queue_refcount == 0 &&
 		    mvm->queue_info[i].status == IWL_MVM_QUEUE_FREE)
 			return i;
 
-	if (iwl_mvm_has_new_tx_api(mvm))
-		return -ENOSPC;
-
 	/*
 	 * If no free queue found - settle for an inactive one to reconfigure
 	 * Make sure that the inactive queue either already belongs to this STA,
-- 
2.11.0
