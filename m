Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36316 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753357AbdF2Sbl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:31:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:24 +0300
Message-Id: <20170629183027.15408-13-luca@coelho.fi> (sfid-20170629_203205_030845_BEDE266E)
In-Reply-To: <20170629183027.15408-1-luca@coelho.fi>
References: <20170629183027.15408-1-luca@coelho.fi>
Subject: [PATCH 12/15] iwlwifi: mvm: quietly accept non-sta disassoc frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a station that's not associated sends a data frame (e.g. an NDP)
hostapd will respond with a disassoc frame, telling it that it's not
associated. The station might also not be authenticated, in which case
there will not be a station entry for it, and as a result we need to
accept such frames without a station.

Fixes: 3ee0f0e23e4f ("iwlwifi: mvm: fix DQA AP mode station assumption")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 73967790f7e4..60360ed73f26 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -568,9 +568,12 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 		 * station that we don't have, or similarly an association
 		 * response (with non-success status) for a station we can't
 		 * accept.
+		 * Also, disassociate frames might happen, particular with
+		 * reason 7 ("Class 3 frame received from nonassociated STA").
 		 */
 		if (ieee80211_is_probe_resp(fc) || ieee80211_is_auth(fc) ||
-		    ieee80211_is_deauth(fc) || ieee80211_is_assoc_resp(fc))
+		    ieee80211_is_deauth(fc) || ieee80211_is_assoc_resp(fc) ||
+		    ieee80211_is_disassoc(fc))
 			return mvm->probe_queue;
 		if (info->hw_queue == info->control.vif->cab_queue)
 			return mvmvif->cab_queue;
-- 
2.11.0
