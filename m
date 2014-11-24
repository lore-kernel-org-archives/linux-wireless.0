Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38032 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaKXOgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:33 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so9053861wiv.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:32 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 59/75] iwlwifi: mvm: finalize on post_switch instead of unassign
Date: Mon, 24 Nov 2014 16:34:35 +0200
Message-Id: <1416839691-28533-59-git-send-email-egrumbach@gmail.com> (sfid-20141124_153839_765150_994B49D0)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Now that mac80211 waits for the first beacon on the new channel before
calling post_channel_switch, the reconfiguration of the firmware
should be done in the post_channel_switch operation instead of when
assigning the vif to the new context.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 31 ++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 3ce5831..c85c0f1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2841,23 +2841,13 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 	}
 
 	/* Handle binding during CSA */
-	if ((vif->type == NL80211_IFTYPE_AP) ||
-	    (switching_chanctx && (vif->type == NL80211_IFTYPE_STATION))) {
+	if (vif->type == NL80211_IFTYPE_AP) {
 		iwl_mvm_update_quotas(mvm, NULL);
 		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 	}
 
 	if (switching_chanctx && vif->type == NL80211_IFTYPE_STATION) {
-		struct iwl_mvm_sta *mvmsta;
-
-		mvmsta = iwl_mvm_sta_from_staid_protected(mvm,
-							  mvmvif->ap_sta_id);
-
-		if (WARN_ON(!mvmsta))
-			goto out;
-
-		/* TODO: only re-enable after the first beacon */
-		iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, false);
+		iwl_mvm_update_quotas(mvm, NULL);
 	}
 
 	goto out;
@@ -3228,10 +3218,27 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		struct iwl_mvm_sta *mvmsta;
+
+		mvmsta = iwl_mvm_sta_from_staid_protected(mvm,
+							  mvmvif->ap_sta_id);
+
+		if (WARN_ON(!mvmsta)) {
+			ret = -EIO;
+			goto out_unlock;
+		}
+
+		iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, false);
+
+		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
+	}
+
 	mvmvif->ps_disabled = false;
 
 	ret = iwl_mvm_power_update_ps(mvm);
 
+out_unlock:
 	mutex_unlock(&mvm->mutex);
 
 	return ret;
-- 
1.9.1

