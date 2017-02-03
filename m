Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37904 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753429AbdBCOil (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:38:41 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:56 +0200
Message-Id: <20170203143812.7525-10-luca@coelho.fi> (sfid-20170203_153850_208827_68331465)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 09/25] iwlwifi: mvm: reduce usage of IEEE80211_SKB_CB()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's already a variable with the result in scope, use that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ea5d5b0d85b3..e2f82c10b019 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -543,9 +543,9 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	 * queue. STATION (HS2.0) uses the auxiliary context of the FW,
 	 * and hence needs to be sent on the aux queue
 	 */
-	if (IEEE80211_SKB_CB(skb)->hw_queue == IWL_MVM_OFFCHANNEL_QUEUE &&
+	if (skb_info->hw_queue == IWL_MVM_OFFCHANNEL_QUEUE &&
 	    skb_info->control.vif->type == NL80211_IFTYPE_STATION)
-		IEEE80211_SKB_CB(skb)->hw_queue = mvm->aux_queue;
+		skb_info->hw_queue = mvm->aux_queue;
 
 	memcpy(&info, skb->cb, sizeof(info));
 
-- 
2.11.0
