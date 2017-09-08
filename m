Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49448 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752122AbdIHJNN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:13:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Sep 2017 12:12:49 +0300
Message-Id: <20170908091256.25279-4-luca@coelho.fi> (sfid-20170908_111317_138039_89718C06)
In-Reply-To: <20170908091256.25279-1-luca@coelho.fi>
References: <20170908091256.25279-1-luca@coelho.fi>
Subject: [PATCH 03/10] iwlwifi: mvm: send all non-bufferable frames on the probe queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

AP interfaces now send all non-bufferable frames using the broadcast
station. Thus allow them to use the probe queue and don't warn about
it.

Fixes: eb045e6e0389 ("iwlwifi: mvm: Avoid deferring non bufferable frames")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 172b5e63d3fb..6f2e2af23219 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -564,8 +564,8 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
 		/*
-		 * Handle legacy hostapd as well, where station will be added
-		 * only just before sending the association response.
+		 * Non-bufferable frames use the broadcast station, thus they
+		 * use the probe queue.
 		 * Also take care of the case where we send a deauth to a
 		 * station that we don't have, or similarly an association
 		 * response (with non-success status) for a station we can't
@@ -573,9 +573,9 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 		 * Also, disassociate frames might happen, particular with
 		 * reason 7 ("Class 3 frame received from nonassociated STA").
 		 */
-		if (ieee80211_is_probe_resp(fc) || ieee80211_is_auth(fc) ||
-		    ieee80211_is_deauth(fc) || ieee80211_is_assoc_resp(fc) ||
-		    ieee80211_is_disassoc(fc))
+		if (ieee80211_is_mgmt(fc) &&
+		    (!ieee80211_is_bufferable_mmpdu(fc) ||
+		     ieee80211_is_deauth(fc) || ieee80211_is_disassoc(fc)))
 			return mvm->probe_queue;
 		if (info->hw_queue == info->control.vif->cab_queue)
 			return mvmvif->cab_queue;
-- 
2.14.1
