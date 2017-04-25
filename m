Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54286 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1949326AbdDYUYi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:24:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:29 +0300
Message-Id: <20170425202243.7844-12-luca@coelho.fi> (sfid-20170425_222524_092883_F1AFF359)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 11/25] iwlwifi: mvm: map cab_queue to different txq_id
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

cab_queue can now get bigger than u8, since in TVQM we will support
512 queues..
Support it by maintaining internal mapping between the actual number
and mac80211 queue (IWL_MVM_DQA_GCAST_QUEUE).
For pre-a000 the internal queue will be the same as the mac80211
queue.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 2 ++
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 9e69b9d2012c..2476af904f5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -467,6 +467,11 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 			queue = IWL_MVM_DQA_GCAST_QUEUE;
 		}
 
+		/*
+		 * For TVQM this will be overwritten later with the FW assigned
+		 * queue value (when queue is enabled).
+		 */
+		mvmvif->cab_queue = queue;
 		vif->cab_queue = queue;
 	} else {
 		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 1bb4249fc6f4..1dbe37f8b08c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -380,6 +380,8 @@ struct iwl_mvm_vif {
 	bool associated;
 	u8 ap_assoc_sta_count;
 
+	u16 cab_queue;
+
 	bool uploaded;
 	bool ap_ibss_active;
 	bool pm_enabled;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index b5b7214a811f..2d5d1fc10013 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2128,7 +2128,7 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 						    msta->sta_id,
 						    IWL_MAX_TID_COUNT,
 						    timeout);
-		vif->cab_queue = queue;
+		mvmvif->cab_queue = queue;
 	} else {
 		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0,
 				   &cfg, timeout);
@@ -2151,7 +2151,7 @@ int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (!iwl_mvm_is_dqa_supported(mvm))
 		return 0;
 
-	iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
+	iwl_mvm_disable_txq(mvm, mvmvif->cab_queue, vif->cab_queue,
 			    IWL_MAX_TID_COUNT, 0);
 
 	ret = iwl_mvm_rm_sta_common(mvm, mvmvif->mcast_sta.sta_id);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 8f737f6cdd80..06bd7cc562ff 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -630,6 +630,8 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 			if (queue < 0)
 				return -1;
 
+			if (queue == info.control.vif->cab_queue)
+				queue = mvmvif->cab_queue;
 		} else if (info.control.vif->type == NL80211_IFTYPE_STATION &&
 			   is_multicast_ether_addr(hdr->addr1)) {
 			u8 ap_sta_id = ACCESS_ONCE(mvmvif->ap_sta_id);
-- 
2.11.0
