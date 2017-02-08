Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39400 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750971AbdBHP5F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 10:57:05 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        "Goodstein, Mordechay" <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 17:51:47 +0200
Message-Id: <20170208155149.1704-7-luca@coelho.fi> (sfid-20170208_165800_937720_B29620DF)
In-Reply-To: <20170208155149.1704-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
 <20170208155149.1704-1-luca@coelho.fi>
Subject: [PATCH 15/17] iwlwifi: mvm: avoid race condition in ADD_STA.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Goodstein, Mordechay" <mordechay.goodstein@intel.com>

The race happens when we send ADD_STA(auth->assoc) -> LQ_CMD
between the commands the FW sometimes loses the medium for AUX, and
sends a ndp to the AP and the flow becomes, ADD_STA -> send ndp -> LQ_CMD
the problem is that there's no rates yet defined for sending the ndp and
FW generates an assert.

The fix: change the order of the commands to LQ_CMD -> ADD_STA

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 7253b92792bf..d37b1695c64e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2627,11 +2627,10 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 			mvmvif->ap_assoc_sta_count++;
 			iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 		}
+
+		iwl_mvm_rs_rate_init(mvm, sta, mvmvif->phy_ctxt->channel->band,
+				     true);
 		ret = iwl_mvm_update_sta(mvm, vif, sta);
-		if (ret == 0)
-			iwl_mvm_rs_rate_init(mvm, sta,
-					     mvmvif->phy_ctxt->channel->band,
-					     true);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTHORIZED) {
 
-- 
2.11.0
