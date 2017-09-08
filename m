Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49508 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752245AbdIHJNR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:13:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Sep 2017 12:12:51 +0300
Message-Id: <20170908091256.25279-6-luca@coelho.fi> (sfid-20170908_111321_048663_B2083061)
In-Reply-To: <20170908091256.25279-1-luca@coelho.fi>
References: <20170908091256.25279-1-luca@coelho.fi>
Subject: [PATCH 05/10] iwlwifi: mvm: wake the correct mac80211 queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

iwl_mvm_start_mac_queues() takes a bitmap of the queues to wake.
When deferred tx is purged, set the bit of the hw_queue so
the correct queue will be waken up.

Fixes: 7e39a00d5931 ("iwlwifi: mvm: start mac queues when deferred tx frames are purged")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 64b0be73ea72..3a6ce4222ff5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2563,7 +2563,7 @@ static void iwl_mvm_purge_deferred_tx_frames(struct iwl_mvm *mvm,
 			 * queues, so we should never get a second deferred
 			 * frame for the RA/TID.
 			 */
-			iwl_mvm_start_mac_queues(mvm, info->hw_queue);
+			iwl_mvm_start_mac_queues(mvm, BIT(info->hw_queue));
 			ieee80211_free_txskb(mvm->hw, skb);
 		}
 	}
-- 
2.14.1
