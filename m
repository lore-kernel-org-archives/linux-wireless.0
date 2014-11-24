Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63986 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbaKXOg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:28 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so9194638wib.5
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:27 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 55/75] iwlwifi: mvm: disable PS during channel switch
Date: Mon, 24 Nov 2014 16:34:31 +0200
Message-Id: <1416839691-28533-55-git-send-email-egrumbach@gmail.com> (sfid-20141124_153637_588833_04FA8593)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
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
index 6098eaf..b536590 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3166,7 +3166,7 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct ieee80211_vif *csa_vif;
-	struct iwl_mvm_vif *mvmvif;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
 	mutex_lock(&mvm->mutex);
@@ -3187,7 +3187,6 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 
 		rcu_assign_pointer(mvm->csa_vif, vif);
 
-		mvmvif = iwl_mvm_vif_from_mac80211(vif);
 		if (WARN_ONCE(mvmvif->csa_countdown,
 			      "Previous CSA countdown didn't complete")) {
 			ret = -EBUSY;
@@ -3199,7 +3198,11 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
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
@@ -3207,6 +3210,24 @@ out_unlock:
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
@@ -3300,6 +3321,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.set_tim = iwl_mvm_set_tim,
 
 	.pre_channel_switch = iwl_mvm_pre_channel_switch,
+	.post_channel_switch = iwl_mvm_post_channel_switch,
 
 	.tdls_channel_switch = iwl_mvm_tdls_channel_switch,
 	.tdls_cancel_channel_switch = iwl_mvm_tdls_cancel_channel_switch,
-- 
1.9.1

