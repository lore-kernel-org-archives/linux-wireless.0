Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59362 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752315AbaKJJKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:10:35 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:06 +0200
Message-Id: <1415610621-27438-2-git-send-email-luca@coelho.fi> (sfid-20141110_101130_721831_6D67FB35)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 01/16] iwlwifi: mvm: use new pre_channel_switch op instead of channel_switch_beacon
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

A new callback has been added to prepare the device for a channel
switch.  Use the new callback instead of the old channel_switch_beacon
operation.

This makes it possible to remove the channel_switch_beacon operation
from mac80211.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e16c29d..e45b9b9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2973,27 +2973,34 @@ static int iwl_mvm_mac_testmode_cmd(struct ieee80211_hw *hw,
 }
 #endif
 
-static void iwl_mvm_channel_switch_beacon(struct ieee80211_hw *hw,
-					  struct ieee80211_vif *vif,
-					  struct cfg80211_chan_def *chandef)
+static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_channel_switch *chsw)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct ieee80211_vif *csa_vif;
+	int ret;
 
 	mutex_lock(&mvm->mutex);
 
 	csa_vif = rcu_dereference_protected(mvm->csa_vif,
 					    lockdep_is_held(&mvm->mutex));
 	if (WARN(csa_vif && csa_vif->csa_active,
-		 "Another CSA is already in progress"))
+		 "Another CSA is already in progress")) {
+		ret = -EBUSY;
 		goto out_unlock;
+	}
 
 	IWL_DEBUG_MAC80211(mvm, "CSA started to freq %d\n",
-			   chandef->center_freq1);
+			   chsw->chandef.center_freq1);
 	rcu_assign_pointer(mvm->csa_vif, vif);
 
+	ret = 0;
+
 out_unlock:
 	mutex_unlock(&mvm->mutex);
+
+	return ret;
 }
 
 static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
@@ -3069,7 +3076,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 
 	.set_tim = iwl_mvm_set_tim,
 
-	.channel_switch_beacon = iwl_mvm_channel_switch_beacon,
+	.pre_channel_switch = iwl_mvm_pre_channel_switch,
 
 	CFG80211_TESTMODE_CMD(iwl_mvm_mac_testmode_cmd)
 
-- 
2.1.1

