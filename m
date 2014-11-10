Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59425 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752463AbaKJJXv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:23:51 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:16 +0200
Message-Id: <1415610621-27438-12-git-send-email-luca@coelho.fi> (sfid-20141110_102401_350471_5DDB4909)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 11/16] iwlwifi: mvm: finalize on post_switch instead of unassign
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
index 3fb2b49..de6a64d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2714,23 +2714,13 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
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
@@ -3101,10 +3091,27 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 
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
2.1.1

