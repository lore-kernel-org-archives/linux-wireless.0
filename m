Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36236 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753140AbdF2Sak (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:30:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:17 +0300
Message-Id: <20170629183027.15408-6-luca@coelho.fi> (sfid-20170629_203050_026194_47CC8348)
In-Reply-To: <20170629183027.15408-1-luca@coelho.fi>
References: <20170629183027.15408-1-luca@coelho.fi>
Subject: [PATCH 05/15] iwlwifi: mvm: map cab_queue to real one earlier
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There may be a difference between the mac80211 vif->cab_queue and
mvmvif->cab_queue, particularly with TVQM. Make the code map this
earlier, instead of first returning the mac80211 one again from
iwl_mvm_get_ctrl_vif_queue().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 419d0351e0ef..12a35af66918 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -551,9 +551,13 @@ static void iwl_mvm_skb_prepare_status(struct sk_buff *skb,
 static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 				      struct ieee80211_tx_info *info, __le16 fc)
 {
+	struct iwl_mvm_vif *mvmvif;
+
 	if (!iwl_mvm_is_dqa_supported(mvm))
 		return info->hw_queue;
 
+	mvmvif = iwl_mvm_vif_from_mac80211(info->control.vif);
+
 	switch (info->control.vif->type) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
@@ -569,7 +573,7 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 		    ieee80211_is_deauth(fc) || ieee80211_is_assoc_resp(fc))
 			return mvm->probe_queue;
 		if (info->hw_queue == info->control.vif->cab_queue)
-			return info->hw_queue;
+			return mvmvif->cab_queue;
 
 		WARN_ONCE(info->control.vif->type != NL80211_IFTYPE_ADHOC,
 			  "fc=0x%02x", le16_to_cpu(fc));
@@ -578,7 +582,7 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 		if (ieee80211_is_mgmt(fc))
 			return mvm->p2p_dev_queue;
 		if (info->hw_queue == info->control.vif->cab_queue)
-			return info->hw_queue;
+			return mvmvif->cab_queue;
 
 		WARN_ON_ONCE(1);
 		return mvm->p2p_dev_queue;
@@ -645,9 +649,6 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 							   hdr->frame_control);
 			if (queue < 0)
 				return -1;
-
-			if (queue == info.control.vif->cab_queue)
-				queue = mvmvif->cab_queue;
 		} else if (info.control.vif->type == NL80211_IFTYPE_STATION &&
 			   is_multicast_ether_addr(hdr->addr1)) {
 			u8 ap_sta_id = ACCESS_ONCE(mvmvif->ap_sta_id);
-- 
2.11.0
