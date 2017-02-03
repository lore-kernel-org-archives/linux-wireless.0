Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37848 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752721AbdBCOi2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:38:28 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Beni Lev <beni.lev@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:51 +0200
Message-Id: <20170203143812.7525-5-luca@coelho.fi> (sfid-20170203_153833_060647_B6DB0EFC)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 04/25] iwlwifi: mvm: Use aux queue for offchannel frames in dqa
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Since offchannel activity doesn't always require a BSS, e.g. ANQP
sessions, offchannel frames should not use the BSS queue, because it
might not be initialized.
Use the auxilary queue instead

Fixes: e3118ad74d7e ("iwlwifi: mvm: support tdls in dqa mode")
Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 2b2db38eee3e..ea5d5b0d85b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -570,9 +570,10 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	 * (this is not possible for unicast packets as a TLDS discovery
 	 * response are sent without a station entry); otherwise use the
 	 * AUX station.
-	 * In DQA mode, if vif is of type STATION and frames are not multicast,
-	 * they should be sent from the BSS queue. For example, TDLS setup
-	 * frames should be sent on this queue, as they go through the AP.
+	 * In DQA mode, if vif is of type STATION and frames are not multicast
+	 * or offchannel, they should be sent from the BSS queue.
+	 * For example, TDLS setup frames should be sent on this queue,
+	 * as they go through the AP.
 	 */
 	sta_id = mvm->aux_sta.sta_id;
 	if (info.control.vif) {
@@ -594,7 +595,8 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 			if (ap_sta_id != IWL_MVM_STATION_COUNT)
 				sta_id = ap_sta_id;
 		} else if (iwl_mvm_is_dqa_supported(mvm) &&
-			   info.control.vif->type == NL80211_IFTYPE_STATION) {
+			   info.control.vif->type == NL80211_IFTYPE_STATION &&
+			   queue != mvm->aux_queue) {
 			queue = IWL_MVM_DQA_BSS_CLIENT_QUEUE;
 		}
 	}
-- 
2.11.0
