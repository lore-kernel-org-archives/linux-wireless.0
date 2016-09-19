Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55854 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932580AbcISHan (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:30:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:10 +0300
Message-Id: <20160919073028.22065-7-luca@coelho.fi> (sfid-20160919_093051_688732_0BEB539F)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 07/25] iwlwifi: mvm: fix DQA AP mode station assumption
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

There was recently a Full AP mode feature added where hostap adds
the station at auth stage, and not assoc.
However, when running with legacy hostapd, we get the auth response
before station was added, and tx_skb_non_sta fails to allocate
a queue, resulting in a complete failure of association.
Take care of this situation as well.
Add a warning when no valid queue is returned at all and make mvm
drop the packet instead of passing it on.
Refactor the function a bit while at it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 35 +++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 1051777..e0c9065 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -490,16 +490,34 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 				      struct ieee80211_tx_info *info, __le16 fc)
 {
-	if (iwl_mvm_is_dqa_supported(mvm)) {
-		if (info->control.vif->type == NL80211_IFTYPE_AP &&
-		    ieee80211_is_probe_resp(fc))
+	if (!iwl_mvm_is_dqa_supported(mvm))
+		return info->hw_queue;
+
+	switch (info->control.vif->type) {
+	case NL80211_IFTYPE_AP:
+		/*
+		 * handle legacy hostapd as well, where station may be added
+		 * only after assoc.
+		 */
+		if (ieee80211_is_probe_resp(fc) || ieee80211_is_auth(fc))
 			return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
-		else if (ieee80211_is_mgmt(fc) &&
-			 info->control.vif->type == NL80211_IFTYPE_P2P_DEVICE)
+		if (info->hw_queue == info->control.vif->cab_queue)
+			return info->hw_queue;
+
+		WARN_ON_ONCE(1);
+		return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		if (ieee80211_is_mgmt(fc))
 			return IWL_MVM_DQA_P2P_DEVICE_QUEUE;
-	}
+		if (info->hw_queue == info->control.vif->cab_queue)
+			return info->hw_queue;
 
-	return info->hw_queue;
+		WARN_ON_ONCE(1);
+		return IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+	default:
+		WARN_ONCE(1, "Not a ctrl vif, no available queue\n");
+		return -1;
+	}
 }
 
 int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
@@ -560,6 +578,9 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 			sta_id = mvmvif->bcast_sta.sta_id;
 			queue = iwl_mvm_get_ctrl_vif_queue(mvm, &info,
 							   hdr->frame_control);
+			if (queue < 0)
+				return -1;
+
 		} else if (info.control.vif->type == NL80211_IFTYPE_STATION &&
 			   is_multicast_ether_addr(hdr->addr1)) {
 			u8 ap_sta_id = ACCESS_ONCE(mvmvif->ap_sta_id);
-- 
2.9.3
