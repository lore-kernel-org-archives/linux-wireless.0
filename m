Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53438 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbcC3OGX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:23 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/43] iwlwifi: mvm: use bss client queue for bss station
Date: Wed, 30 Mar 2016 17:05:04 +0300
Message-Id: <1459346715-7954-32-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160711_068847_12BFE42F)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Use the reserved BSS Client queue when connecting to an AP
in DQA mode.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c    | 18 +++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 8217eb2..9652687 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -89,6 +89,8 @@ enum {
 /*
  * DQA queue numbers
  *
+ * @IWL_MVM_DQA_BSS_CLIENT_QUEUE: a queue reserved for BSS activity, to ensure
+ *	that we are never left without the possibility to connect to an AP.
  * @IWL_MVM_DQA_MIN_MGMT_QUEUE: first TXQ in pool for MGMT and non-QOS frames.
  *	Each MGMT queue is mapped to a single STA
  *	MGMT frames are frames that return true on ieee80211_is_mgmt()
@@ -100,6 +102,7 @@ enum {
  * @IWL_MVM_DQA_MAX_DATA_QUEUE: last TXQ in pool for DATA frames
  */
 enum iwl_mvm_dqa_txq {
+	IWL_MVM_DQA_BSS_CLIENT_QUEUE = 4,
 	IWL_MVM_DQA_MIN_MGMT_QUEUE = 5,
 	IWL_MVM_DQA_MAX_MGMT_QUEUE = 8,
 	IWL_MVM_DQA_MIN_DATA_QUEUE = 10,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 3f36a66..e157bd5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -336,7 +336,8 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	 * as aggregatable.
 	 * Mark all DATA queues as allowing to be aggregated at some point
 	 */
-	cfg.aggregate = (queue >= IWL_MVM_DQA_MIN_DATA_QUEUE);
+	cfg.aggregate = (queue >= IWL_MVM_DQA_MIN_DATA_QUEUE ||
+			 queue == IWL_MVM_DQA_BSS_CLIENT_QUEUE);
 
 	IWL_DEBUG_TX_QUEUES(mvm, "Allocating queue #%d to sta %d on tid %d\n",
 			    queue, mvmsta->sta_id, tid);
@@ -448,7 +449,8 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 }
 
 static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
-				      struct ieee80211_sta *sta)
+				      struct ieee80211_sta *sta,
+				      enum nl80211_iftype vif_type)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	int queue;
@@ -456,8 +458,13 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 	spin_lock_bh(&mvm->queue_info_lock);
 
 	/* Make sure we have free resources for this STA */
-	queue = iwl_mvm_find_free_queue(mvm, IWL_MVM_DQA_MIN_DATA_QUEUE,
-					IWL_MVM_DQA_MAX_DATA_QUEUE);
+	if (vif_type == NL80211_IFTYPE_STATION && !sta->tdls &&
+	    !mvm->queue_info[IWL_MVM_DQA_BSS_CLIENT_QUEUE].hw_queue_refcount &&
+	    !mvm->queue_info[IWL_MVM_DQA_BSS_CLIENT_QUEUE].setup_reserved)
+		queue = IWL_MVM_DQA_BSS_CLIENT_QUEUE;
+	else
+		queue = iwl_mvm_find_free_queue(mvm, IWL_MVM_DQA_MIN_DATA_QUEUE,
+						IWL_MVM_DQA_MAX_DATA_QUEUE);
 	if (queue < 0) {
 		spin_unlock_bh(&mvm->queue_info_lock);
 		IWL_ERR(mvm, "No available queues for new station\n");
@@ -551,7 +558,8 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	}
 
 	if (iwl_mvm_is_dqa_supported(mvm)) {
-		ret = iwl_mvm_reserve_sta_stream(mvm, sta);
+		ret = iwl_mvm_reserve_sta_stream(mvm, sta,
+						 ieee80211_vif_type_p2p(vif));
 		if (ret)
 			goto err;
 	}
-- 
2.5.0

