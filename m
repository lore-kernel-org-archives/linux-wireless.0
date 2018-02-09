Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:58226 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751037AbeBINMn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 08:12:43 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  9 Feb 2018 15:12:31 +0200
Message-Id: <20180209131234.8504-3-luca@coelho.fi> (sfid-20180209_141256_732451_D3920F14)
In-Reply-To: <20180209131234.8504-1-luca@coelho.fi>
References: <20180209131234.8504-1-luca@coelho.fi>
Subject: [PATCH 2/5] iwlwifi: mvm: fix IBSS for devices that support station type API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In IBSS, the mac80211 sets the cab_queue to be invalid.

However, the multicast station uses it, so we need to override it.

A previous patch did it, but it was nested inside the if's and was
applied only for legacy FWs that don't support the new station type
API, instead of being applied for all paths.

In addition, add a missing NL80211_IFTYPE_ADHOC to the initialization
of the queues in iwl_mvm_mac_ctxt_init()

Fixes: ee48b72211f8 ("iwlwifi: mvm: support ibss in dqa mode")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 24 +++++++++++------------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 2f22e14e00fe..8ba16fc24e3a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -438,7 +438,8 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	}
 
 	/* Allocate the CAB queue for softAP and GO interfaces */
-	if (vif->type == NL80211_IFTYPE_AP) {
+	if (vif->type == NL80211_IFTYPE_AP ||
+	    vif->type == NL80211_IFTYPE_ADHOC) {
 		/*
 		 * For TVQM this will be overwritten later with the FW assigned
 		 * queue value (when queue is enabled).
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 6b2674e02606..dbd2ba2bb714 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2052,6 +2052,17 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		    vif->type != NL80211_IFTYPE_ADHOC))
 		return -ENOTSUPP;
 
+	/*
+	 * In IBSS, ieee80211_check_queues() sets the cab_queue to be
+	 * invalid, so make sure we use the queue we want.
+	 * Note that this is done here as we want to avoid making DQA
+	 * changes in mac80211 layer.
+	 */
+	if (vif->type == NL80211_IFTYPE_ADHOC) {
+		vif->cab_queue = IWL_MVM_DQA_GCAST_QUEUE;
+		mvmvif->cab_queue = vif->cab_queue;
+	}
+
 	/*
 	 * While in previous FWs we had to exclude cab queue from TFD queue
 	 * mask, now it is needed as any other queue.
@@ -2083,20 +2094,9 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 						    timeout);
 		mvmvif->cab_queue = queue;
 	} else if (!fw_has_api(&mvm->fw->ucode_capa,
-			       IWL_UCODE_TLV_API_STA_TYPE)) {
-		/*
-		 * In IBSS, ieee80211_check_queues() sets the cab_queue to be
-		 * invalid, so make sure we use the queue we want.
-		 * Note that this is done here as we want to avoid making DQA
-		 * changes in mac80211 layer.
-		 */
-		if (vif->type == NL80211_IFTYPE_ADHOC) {
-			vif->cab_queue = IWL_MVM_DQA_GCAST_QUEUE;
-			mvmvif->cab_queue = vif->cab_queue;
-		}
+			       IWL_UCODE_TLV_API_STA_TYPE))
 		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0,
 				   &cfg, timeout);
-	}
 
 	return 0;
 }
-- 
2.15.1
