Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33438 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1427595AbeCBMbX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 07:31:23 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Mar 2018 14:31:11 +0200
Message-Id: <20180302123112.27416-4-luca@coelho.fi> (sfid-20180302_133133_381361_637C2747)
In-Reply-To: <20180302123112.27416-1-luca@coelho.fi>
References: <20180302123112.27416-1-luca@coelho.fi>
Subject: [PATCH 3/4] iwlwifi: mvm: fix error checking for multi/broadcast sta
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The earlier patch called the station add functions but didn't
assign their return value to the ret variable, so that the
checks for it were meaningless. Fix that.

Found by smatch:

.../mac80211.c:2560 iwl_mvm_start_ap_ibss() warn: we tested 'ret' before and it was 'false'
.../mac80211.c:2563 iwl_mvm_start_ap_ibss() warn: we tested 'ret' before and it was 'false'

Fixes: 3a89411cd31c ("iwlwifi: mvm: fix assert 0x2B00 on older FWs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ebf511150f4d..d09afb4acaeb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2132,10 +2132,10 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 		 * Send the bcast station. At this stage the TBTT and DTIM time
 		 * events are added and applied to the scheduler
 		 */
-		iwl_mvm_send_add_bcast_sta(mvm, vif);
+		ret = iwl_mvm_send_add_bcast_sta(mvm, vif);
 		if (ret)
 			goto out_unbind;
-		iwl_mvm_add_mcast_sta(mvm, vif);
+		ret = iwl_mvm_add_mcast_sta(mvm, vif);
 		if (ret) {
 			iwl_mvm_send_rm_bcast_sta(mvm, vif);
 			goto out_unbind;
-- 
2.16.1
