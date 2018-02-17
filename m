Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59294 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751077AbeBQIeI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 03:34:08 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 17 Feb 2018 10:33:52 +0200
Message-Id: <20180217083354.31160-8-luca@coelho.fi> (sfid-20180217_093419_915016_6DE17098)
In-Reply-To: <20180217083354.31160-1-luca@coelho.fi>
References: <20180217083354.31160-1-luca@coelho.fi>
Subject: [PATCH 7/9] iwlwifi: mvm: Direct multicast frames to the correct station
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Multicast frames for NL80211_IFTYPE_AP and NL80211_IFTYPE_ADHOC were
directed to the broadcast station, however, as the broadcast station
did not have keys configured, these frames were sent unencrypted.

Fix this by using the multicast station which is the station for which
encryption keys are configured.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 57ad6019ffad..af6dfceab6b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -648,7 +648,11 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 		if (info.control.vif->type == NL80211_IFTYPE_P2P_DEVICE ||
 		    info.control.vif->type == NL80211_IFTYPE_AP ||
 		    info.control.vif->type == NL80211_IFTYPE_ADHOC) {
-			sta_id = mvmvif->bcast_sta.sta_id;
+			if (info.control.vif->type == NL80211_IFTYPE_P2P_DEVICE)
+				sta_id = mvmvif->bcast_sta.sta_id;
+			else
+				sta_id = mvmvif->mcast_sta.sta_id;
+
 			queue = iwl_mvm_get_ctrl_vif_queue(mvm, &info,
 							   hdr->frame_control);
 			if (queue < 0)
-- 
2.15.1
