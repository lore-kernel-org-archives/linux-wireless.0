Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42418 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752592AbdHESrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 14:47:52 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 21:47:42 +0300
Message-Id: <20170805184743.23650-3-luca@coelho.fi> (sfid-20170805_205041_015611_4E44DCD1)
In-Reply-To: <20170805184743.23650-1-luca@coelho.fi>
References: <20170805184743.23650-1-luca@coelho.fi>
Subject: [PATCH 2/3] iwlwifi: mvm: start mac queues when deferred tx frames are purged
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Under DQA, when tx is deferred because a queue needs to be allocated,
the mac queue for that TID is stopped until the new stream is added.
If at this point the station that this stream belongs to is removed,
all the deferred tx frames are purged, but the mac queue is not
restarted. As a result, all following tx on this queue will not be
transmitted.

Fix this by starting the relevant mac queues when the deferred tx
frames are purged.

Fixes: 24afba7690e4 ("iwlwifi: mvm: support bss dynamic alloc/dealloc of queues")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index c7b1e58e3384..ce901be5fba8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2597,8 +2597,18 @@ static void iwl_mvm_purge_deferred_tx_frames(struct iwl_mvm *mvm,
 	spin_lock_bh(&mvm_sta->lock);
 	for (i = 0; i <= IWL_MAX_TID_COUNT; i++) {
 		tid_data = &mvm_sta->tid_data[i];
-		while ((skb = __skb_dequeue(&tid_data->deferred_tx_frames)))
+
+		while ((skb = __skb_dequeue(&tid_data->deferred_tx_frames))) {
+			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+			/*
+			 * The first deferred frame should've stopped the MAC
+			 * queues, so we should never get a second deferred
+			 * frame for the RA/TID.
+			 */
+			iwl_mvm_start_mac_queues(mvm, info->hw_queue);
 			ieee80211_free_txskb(mvm->hw, skb);
+		}
 	}
 	spin_unlock_bh(&mvm_sta->lock);
 }
-- 
2.13.2
