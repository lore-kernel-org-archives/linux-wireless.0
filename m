Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47640 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S936363AbdCXPhd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 11:37:33 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Mar 2017 17:37:14 +0200
Message-Id: <20170324153714.8880-4-luca@coelho.fi> (sfid-20170324_163806_540959_50E627AE)
In-Reply-To: <20170324153714.8880-1-luca@coelho.fi>
References: <20170324153714.8880-1-luca@coelho.fi>
Subject: [PATCH 3/3] iwlwifi: mvm: support ibss in dqa mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Allow working IBSS also when working in DQA mode.
This is done by setting it to treat the queues the
same as a BSS AP treats the queues.

Fixes: 7948b87308a4 ("iwlwifi: mvm: enable dynamic queue allocation mode")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 9 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 7 +++++--
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 99132ea16ede..c5734e1a02d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -216,7 +216,8 @@ u32 iwl_mvm_mac_get_queues_mask(struct ieee80211_vif *vif)
 			qmask |= BIT(vif->hw_queue[ac]);
 	}
 
-	if (vif->type == NL80211_IFTYPE_AP)
+	if (vif->type == NL80211_IFTYPE_AP ||
+	    vif->type == NL80211_IFTYPE_ADHOC)
 		qmask |= BIT(vif->cab_queue);
 
 	return qmask;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index b51a2853cc80..9d28db7f56aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1806,7 +1806,8 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 			iwl_mvm_get_wd_timeout(mvm, vif, false, false);
 		int queue;
 
-		if (vif->type == NL80211_IFTYPE_AP)
+		if (vif->type == NL80211_IFTYPE_AP ||
+		    vif->type == NL80211_IFTYPE_ADHOC)
 			queue = IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
 		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
 			queue = IWL_MVM_DQA_P2P_DEVICE_QUEUE;
@@ -1837,7 +1838,8 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	 * enabled-cab_queue to the mask)
 	 */
 	if (iwl_mvm_is_dqa_supported(mvm) &&
-	    vif->type == NL80211_IFTYPE_AP) {
+	    (vif->type == NL80211_IFTYPE_AP ||
+	     vif->type == NL80211_IFTYPE_ADHOC)) {
 		struct iwl_trans_txq_scd_cfg cfg = {
 			.fifo = IWL_MVM_TX_FIFO_MCAST,
 			.sta_id = mvmvif->bcast_sta.sta_id,
@@ -1862,7 +1864,8 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (vif->type == NL80211_IFTYPE_AP)
+	if (vif->type == NL80211_IFTYPE_AP ||
+	    vif->type == NL80211_IFTYPE_ADHOC)
 		iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
 				    IWL_MAX_TID_COUNT, 0);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 3f37075f4cde..1ba0a6f55503 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -506,6 +506,7 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 
 	switch (info->control.vif->type) {
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
 		/*
 		 * Handle legacy hostapd as well, where station may be added
 		 * only after assoc. Take care of the case where we send a
@@ -517,7 +518,8 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 		if (info->hw_queue == info->control.vif->cab_queue)
 			return info->hw_queue;
 
-		WARN_ONCE(1, "fc=0x%02x", le16_to_cpu(fc));
+		WARN_ONCE(info->control.vif->type != NL80211_IFTYPE_ADHOC,
+			  "fc=0x%02x", le16_to_cpu(fc));
 		return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		if (ieee80211_is_mgmt(fc))
@@ -584,7 +586,8 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 			iwl_mvm_vif_from_mac80211(info.control.vif);
 
 		if (info.control.vif->type == NL80211_IFTYPE_P2P_DEVICE ||
-		    info.control.vif->type == NL80211_IFTYPE_AP) {
+		    info.control.vif->type == NL80211_IFTYPE_AP ||
+		    info.control.vif->type == NL80211_IFTYPE_ADHOC) {
 			sta_id = mvmvif->bcast_sta.sta_id;
 			queue = iwl_mvm_get_ctrl_vif_queue(mvm, &info,
 							   hdr->frame_control);
-- 
2.11.0
