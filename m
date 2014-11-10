Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59381 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752075AbaKJJKj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:10:39 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:12 +0200
Message-Id: <1415610621-27438-8-git-send-email-luca@coelho.fi> (sfid-20141110_101117_975583_B019F507)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 07/16] iwlwifi: mvm: disable PS during channel switch
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Disable PS when pre_channel_switch is called and add the
post_channel_switch operation to re-enable PS when the channel switch
is completed.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 9cf90af..221f823 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3039,7 +3039,7 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct ieee80211_vif *csa_vif;
-	struct iwl_mvm_vif *mvmvif;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
 	mutex_lock(&mvm->mutex);
@@ -3060,7 +3060,6 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 
 		rcu_assign_pointer(mvm->csa_vif, vif);
 
-		mvmvif = iwl_mvm_vif_from_mac80211(vif);
 		if (WARN_ONCE(mvmvif->csa_countdown,
 			      "Previous CSA countdown didn't complete")) {
 			ret = -EBUSY;
@@ -3072,7 +3071,11 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 		break;
 	}
 
-	ret = 0;
+	mvmvif->ps_disabled = true;
+
+	ret = iwl_mvm_power_update_ps(mvm);
+	if (ret)
+		goto out_unlock;
 
 out_unlock:
 	mutex_unlock(&mvm->mutex);
@@ -3080,6 +3083,24 @@ out_unlock:
 	return ret;
 }
 
+static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	int ret;
+
+	mutex_lock(&mvm->mutex);
+
+	mvmvif->ps_disabled = false;
+
+	ret = iwl_mvm_power_update_ps(mvm);
+
+	mutex_unlock(&mvm->mutex);
+
+	return ret;
+}
+
 static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, u32 queues, bool drop)
 {
@@ -3154,6 +3175,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.set_tim = iwl_mvm_set_tim,
 
 	.pre_channel_switch = iwl_mvm_pre_channel_switch,
+	.post_channel_switch = iwl_mvm_post_channel_switch,
 
 	CFG80211_TESTMODE_CMD(iwl_mvm_mac_testmode_cmd)
 
-- 
2.1.1

