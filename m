Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbbHDU7M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:12 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/37] iwlwifi: mvm: Use the AP station for non_sta transmit
Date: Tue,  4 Aug 2015 23:43:15 +0300
Message-Id: <1438721007-23283-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230716_358635_E192A479)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

In iwl_mvm_tx_skb_non_sta(), in case of managed interface,
use the AP station for multicast frames instead of the auxiliary
station as otherwise the frames can be sent to an absent P2P GO as
the FW does not block transmissions for the auxiliary station
since it is not associated with the station MAC context.

Note that this is not possible for unicast frames, as a TDLS
discovery response is sent without a station entry, and in this
case the P2P GO NoA should not block transmission to the peer.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index abde484..fa3eaf9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -366,18 +366,29 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 		IEEE80211_SKB_CB(skb)->hw_queue = mvm->aux_queue;
 
 	/*
-	 * If the interface on which frame is sent is the P2P_DEVICE
+	 * If the interface on which the frame is sent is the P2P_DEVICE
 	 * or an AP/GO interface use the broadcast station associated
-	 * with it; otherwise use the AUX station.
+	 * with it; otherwise if the interface is a managed interface
+	 * use the AP station associated with it for multicast traffic
+	 * (this is not possible for unicast packets as a TLDS discovery
+	 * response are sent without a station entry); otherwise use the
+	 * AUX station.
 	 */
-	if (info->control.vif &&
-	    (info->control.vif->type == NL80211_IFTYPE_P2P_DEVICE ||
-	     info->control.vif->type == NL80211_IFTYPE_AP)) {
+	sta_id = mvm->aux_sta.sta_id;
+	if (info->control.vif) {
 		struct iwl_mvm_vif *mvmvif =
 			iwl_mvm_vif_from_mac80211(info->control.vif);
-		sta_id = mvmvif->bcast_sta.sta_id;
-	} else {
-		sta_id = mvm->aux_sta.sta_id;
+
+		if (info->control.vif->type == NL80211_IFTYPE_P2P_DEVICE ||
+		    info->control.vif->type == NL80211_IFTYPE_AP)
+			sta_id = mvmvif->bcast_sta.sta_id;
+		else if (info->control.vif->type == NL80211_IFTYPE_STATION &&
+			 is_multicast_ether_addr(hdr->addr1)) {
+			u8 ap_sta_id = ACCESS_ONCE(mvmvif->ap_sta_id);
+
+			if (ap_sta_id != IWL_MVM_STATION_COUNT)
+				sta_id = ap_sta_id;
+		}
 	}
 
 	IWL_DEBUG_TX(mvm, "station Id %d, queue=%d\n", sta_id, info->hw_queue);
-- 
2.1.4

