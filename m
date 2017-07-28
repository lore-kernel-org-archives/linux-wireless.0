Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40996 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752276AbdG1O0X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:26:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:37 +0300
Message-Id: <20170728142337.19183-25-luca@coelho.fi> (sfid-20170728_162626_893319_E69841CD)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 24/24] iwlwifi: mvm: don't retake the pointer to skb's CB
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We already have a such a pointer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index aad75f1cea31..ef02919c2d6e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -805,7 +805,7 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 		goto drop;
 	}
 
-	if (IEEE80211_SKB_CB(skb)->hw_queue == IWL_MVM_OFFCHANNEL_QUEUE &&
+	if (info->hw_queue == IWL_MVM_OFFCHANNEL_QUEUE &&
 	    !test_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status) &&
 	    !test_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status))
 		goto drop;
-- 
2.13.2
