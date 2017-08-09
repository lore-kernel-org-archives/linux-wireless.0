Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43182 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750820AbdHIF7C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 01:59:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  9 Aug 2017 08:58:53 +0300
Message-Id: <20170809055853.8560-1-luca@coelho.fi> (sfid-20170809_075905_952802_7A1B62A0)
In-Reply-To: <78tivleks.fsf@kamboji.qca.qualcomm.com>
References: <78tivleks.fsf@kamboji.qca.qualcomm.com>
Subject: [PATCH v2 2/3] iwlwifi: mvm: start mac queues when deferred tx frames are purged
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

In AP mode, if a station is removed just as it is adding a new stream,
the queue in question will remain stopped and no more TX will happen
in this queue, leading to connection failures and other problems.

This is because under DQA, when tx is deferred because a queue needs
to be allocated, the mac queue for that TID is stopped until the new
stream is added.  If at this point the station that this stream
belongs to is removed, all the deferred tx frames are purged, but the
mac queue is not restarted. As a result, all following tx on this
queue will not be transmitted.

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
