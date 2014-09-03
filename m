Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37926 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaICT4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:50 -0400
Received: by mail-wg0-f46.google.com with SMTP id x13so9014477wgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:49 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/36] iwlwifi: mvm: re-enable ps when monitor interfaces are removed
Date: Wed,  3 Sep 2014 22:56:02 +0300
Message-Id: <1409774184-24665-14-git-send-email-egrumbach@gmail.com> (sfid-20140903_215655_668181_170D1AA5)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If a monitor interface is added and then removed, we don't reset the
mvm->ps_disabled flag, so we never re-enable power saving.  Fix that
and rearrange the code a bit.

Additionally, fix a small indentation mistake in the
iwl_mvm_power_set_pm() function declaration.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  1 +
 drivers/net/wireless/iwlwifi/mvm/power.c    | 30 +++++++++++++++--------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index de4ae94..531540c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -776,6 +776,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	iwl_trans_stop_device(mvm->trans);
 
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
+	mvm->ps_disabled = false;
 
 	/* just in case one was running */
 	ieee80211_remain_on_channel_expired(mvm->hw);
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 8cbe7ea..754f2b3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -566,9 +566,8 @@ static void iwl_mvm_power_iterator(void *_data, u8 *mac,
 	}
 }
 
-static void
-iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
-				    struct iwl_power_vifs *vifs)
+static void iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
+				 struct iwl_power_vifs *vifs)
 {
 	struct iwl_mvm_vif *bss_mvmvif = NULL;
 	struct iwl_mvm_vif *p2p_mvmvif = NULL;
@@ -830,7 +829,7 @@ int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
 	struct iwl_power_vifs vifs = {
 		.mvm = mvm,
 	};
-	bool ba_enable;
+	bool ba_enable, disable_ps;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -838,16 +837,19 @@ int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
 	iwl_mvm_power_set_pm(mvm, &vifs);
 
 	/* disable PS if CAM */
-	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM) {
-		mvm->ps_disabled = true;
-	} else {
-	/* don't update device power state unless we add / remove monitor */
-		if (vifs.monitor_vif) {
-			if (vifs.monitor_active)
-				mvm->ps_disabled = true;
-			ret = iwl_mvm_power_update_device(mvm);
-			if (ret)
-				return ret;
+	disable_ps = (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM);
+	/* ...or if there is an active monitor vif */
+	disable_ps |= (vifs.monitor_vif && vifs.monitor_active);
+
+	/* update device power state if it has changed */
+	if (mvm->ps_disabled != disable_ps) {
+		bool old_ps_disabled = mvm->ps_disabled;
+
+		mvm->ps_disabled = disable_ps;
+		ret = iwl_mvm_power_update_device(mvm);
+		if (ret) {
+			mvm->ps_disabled = old_ps_disabled;
+			return ret;
 		}
 	}
 
-- 
1.9.1

