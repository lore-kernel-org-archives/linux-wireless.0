Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39176 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932096AbdBHL2e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:28:34 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 13:23:13 +0200
Message-Id: <20170208112322.29413-9-luca@coelho.fi> (sfid-20170208_122859_931718_3242750A)
In-Reply-To: <20170208112322.29413-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
Subject: [PATCH 08/17] iwlwifi: mvm: use the PROBE_RESP_QUEUE to send deauth to unknown station
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we send a deauth to a station we don't know about, we
need to use the PROBE_RESP queue. This can happen when we
send a deauth to a station that is not associated to us.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 1d147599cca9..dd2b4a300819 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -506,15 +506,17 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 	switch (info->control.vif->type) {
 	case NL80211_IFTYPE_AP:
 		/*
-		 * handle legacy hostapd as well, where station may be added
-		 * only after assoc.
+		 * Handle legacy hostapd as well, where station may be added
+		 * only after assoc. Take care of the case where we send a
+		 * deauth to a station that we don't have.
 		 */
-		if (ieee80211_is_probe_resp(fc) || ieee80211_is_auth(fc))
+		if (ieee80211_is_probe_resp(fc) || ieee80211_is_auth(fc) ||
+		    ieee80211_is_deauth(fc))
 			return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
 		if (info->hw_queue == info->control.vif->cab_queue)
 			return info->hw_queue;
 
-		WARN_ON_ONCE(1);
+		WARN_ONCE(1, "fc=0x%02x", le16_to_cpu(fc));
 		return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		if (ieee80211_is_mgmt(fc))
-- 
2.11.0
