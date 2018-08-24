Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43870 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726572AbeHXOEa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:09 +0300
Message-Id: <20180824103018.15011-8-luca@coelho.fi> (sfid-20180824_123036_456165_E4FA2884)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 07/16] iwlwifi: mvm: send BCAST management frames to the right station
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Probe responses were sent to the multicast station while
they should be routed to the broadcast station.
This has no negative effect since the frame was still
routed to the right queue, but it looked very fishy
to send a frame to a (queue, station) tuple where
'queue' is not mapped to 'station'.

Fixes: 7c305de2b954 ("iwlwifi: mvm: Direct multicast frames to the correct station")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index c99b79d686d0..ffc0ad1eef15 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -730,7 +730,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 		if (info.control.vif->type == NL80211_IFTYPE_P2P_DEVICE ||
 		    info.control.vif->type == NL80211_IFTYPE_AP ||
 		    info.control.vif->type == NL80211_IFTYPE_ADHOC) {
-			if (info.control.vif->type == NL80211_IFTYPE_P2P_DEVICE)
+			if (!ieee80211_is_data(hdr->frame_control))
 				sta_id = mvmvif->bcast_sta.sta_id;
 			else
 				sta_id = mvmvif->mcast_sta.sta_id;
-- 
2.18.0
