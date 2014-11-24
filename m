Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39703 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaKXOgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:35 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so5865653wiv.6
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:34 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 60/75] iwlwifi: mvm: add a channel_switch op to bypass mac80211 timer
Date: Mon, 24 Nov 2014 16:34:36 +0200
Message-Id: <1416839691-28533-60-git-send-email-egrumbach@gmail.com> (sfid-20141124_153809_414663_050266FA)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
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
index c85c0f1..7acdfa7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3143,6 +3143,20 @@ static int iwl_mvm_mac_testmode_cmd(struct ieee80211_hw *hw,
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
@@ -3336,6 +3350,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 
 	.set_tim = iwl_mvm_set_tim,
 
+	.channel_switch = iwl_mvm_channel_switch,
 	.pre_channel_switch = iwl_mvm_pre_channel_switch,
 	.post_channel_switch = iwl_mvm_post_channel_switch,
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 1a537be..ff631cc 100644
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
1.9.1

