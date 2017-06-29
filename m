Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36206 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752506AbdF2Sag (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:30:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:13 +0300
Message-Id: <20170629183027.15408-2-luca@coelho.fi> (sfid-20170629_203042_652356_3F9D5C6A)
In-Reply-To: <20170629183027.15408-1-luca@coelho.fi>
References: <20170629183027.15408-1-luca@coelho.fi>
Subject: [PATCH 01/15] iwlwifi: mvm: quietly accept non-sta assoc response frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When hostapd adds a station, it does so before sending the association
response frame, so that it can indicate the correct status code in the
response.

However, when this then fails, or the association response already is
a reject for some other reason, then there's no station entry and thus
no per-station management queue to send the response on and it must be
sent on the probe response queue. The code should therefore not warn.

In theory, we could check and warn if the status code is success, but
that seems excessive, so just relax the check to allow any association
response frames.

Fixes: 3ee0f0e23e4f ("iwlwifi: mvm: fix DQA AP mode station assumption")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 627befb0d8d1..214829e5a860 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -554,12 +554,15 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
 		/*
-		 * Handle legacy hostapd as well, where station may be added
-		 * only after assoc. Take care of the case where we send a
-		 * deauth to a station that we don't have.
+		 * Handle legacy hostapd as well, where station will be added
+		 * only just before sending the association response.
+		 * Also take care of the case where we send a deauth to a
+		 * station that we don't have, or similarly an association
+		 * response (with non-success status) for a station we can't
+		 * accept.
 		 */
 		if (ieee80211_is_probe_resp(fc) || ieee80211_is_auth(fc) ||
-		    ieee80211_is_deauth(fc))
+		    ieee80211_is_deauth(fc) || ieee80211_is_assoc_resp(fc))
 			return mvm->probe_queue;
 		if (info->hw_queue == info->control.vif->cab_queue)
 			return info->hw_queue;
-- 
2.11.0
