Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:59670 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbaKXOgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:19 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so12311255wgg.22
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:18 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 49/75] iwlwifi: mvm: use new pre_channel_switch op instead of channel_switch_beacon
Date: Mon, 24 Nov 2014 16:34:25 +0200
Message-Id: <1416839691-28533-49-git-send-email-egrumbach@gmail.com> (sfid-20141124_153852_707274_4220B9A5)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
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
index 3841fcf..1f53f81 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3100,27 +3100,34 @@ static int iwl_mvm_mac_testmode_cmd(struct ieee80211_hw *hw,
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
@@ -3215,7 +3222,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 
 	.set_tim = iwl_mvm_set_tim,
 
-	.channel_switch_beacon = iwl_mvm_channel_switch_beacon,
+	.pre_channel_switch = iwl_mvm_pre_channel_switch,
 
 	.tdls_channel_switch = iwl_mvm_tdls_channel_switch,
 	.tdls_cancel_channel_switch = iwl_mvm_tdls_cancel_channel_switch,
-- 
1.9.1

