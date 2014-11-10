Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59421 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752146AbaKJJXs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:23:48 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:17 +0200
Message-Id: <1415610621-27438-13-git-send-email-luca@coelho.fi> (sfid-20141110_102400_075552_1E18D7C3)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 12/16] iwlwifi: mvm: add a channel_switch op to bypass mac80211 timer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We need to call ieee80211_chswitch_done() ourselves just when the
absence TE started, so we perform the actual context switch early
enough.  To do so, add a dummy channel_switch op, which will cause
mac80211 to skip the countdown timer and allow us to call
ieee80211_chswitch_done() to complete the operation.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   | 15 +++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/time-event.c |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index de6a64d..55ab81e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3016,6 +3016,20 @@ static int iwl_mvm_mac_testmode_cmd(struct ieee80211_hw *hw,
 }
 #endif
 
+static void iwl_mvm_channel_switch(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_channel_switch *chsw)
+{
+	/* By implementing this operation, we prevent mac80211 from
+	 * starting its own channel switch timer, so that we can call
+	 * ieee80211_chswitch_done() ourselves at the right time
+	 * (which is when the absence time event starts).
+	 */
+
+	IWL_DEBUG_MAC80211(IWL_MAC80211_GET_MVM(hw),
+			   "dummy channel switch op\n");
+}
+
 static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      struct ieee80211_channel_switch *chsw)
@@ -3190,6 +3204,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 
 	.set_tim = iwl_mvm_set_tim,
 
+	.channel_switch = iwl_mvm_channel_switch,
 	.pre_channel_switch = iwl_mvm_pre_channel_switch,
 	.post_channel_switch = iwl_mvm_post_channel_switch,
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index aa05a71..2feff15 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -207,6 +207,7 @@ iwl_mvm_te_handle_notify_csa(struct iwl_mvm *mvm,
 		break;
 	case NL80211_IFTYPE_STATION:
 		iwl_mvm_csa_client_absent(mvm, te_data->vif);
+		ieee80211_chswitch_done(te_data->vif, true);
 		break;
 	default:
 		/* should never happen */
-- 
2.1.1

