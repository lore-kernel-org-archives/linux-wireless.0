Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39463 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350AbaKXOgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:45 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so5851061wiw.13
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:44 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 67/75] iwlwifi: mvm: treat netdetect wake up separately
Date: Mon, 24 Nov 2014 16:34:43 +0200
Message-Id: <1416839691-28533-67-git-send-email-egrumbach@gmail.com> (sfid-20141124_153655_599197_001AB16B)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

When the device wakes up due to netdetect, we need to query different
things from the firmware than when it wakes up with a normal WoWLAN.
To make this easier, separate the netdetect wake up handling from the
rest.  For now, we don't send netdetect as a wake up reason, treating
it as a non-wireless wake up.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c  | 40 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h |  1 +
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index c72d2e9..176556e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1048,6 +1048,8 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 			mvm, wowlan, wowlan->nd_config ?: mvm->nd_config, vif);
 		if (ret)
 			goto out;
+
+		mvm->net_detect = true;
 	} else {
 		struct iwl_wowlan_config_cmd_v3 wowlan_config_cmd = {};
 
@@ -1067,6 +1069,8 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 					    vif, mvmvif, ap_sta);
 		if (ret)
 			goto out;
+
+		mvm->net_detect = false;
 	}
 
 	ret = iwl_mvm_power_update_device(mvm);
@@ -1621,6 +1625,32 @@ out_unlock:
 	return false;
 }
 
+static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
+					    struct ieee80211_vif *vif)
+{
+	struct cfg80211_wowlan_wakeup wakeup = {
+		.pattern_idx = -1,
+	};
+	struct cfg80211_wowlan_wakeup *wakeup_report = &wakeup;
+	struct iwl_wowlan_status *fw_status;
+	u32 reasons = 0;
+
+	fw_status = iwl_mvm_get_wakeup_status(mvm, vif);
+	if (!IS_ERR_OR_NULL(fw_status))
+		reasons = le32_to_cpu(fw_status->wakeup_reasons);
+
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_RFKILL_DEASSERTED)
+		wakeup.rfkill_release = true;
+
+	if (reasons == IWL_WOWLAN_WAKEUP_BY_NON_WIRELESS) {
+		/* TODO: read and check if it was netdetect */
+		wakeup_report = NULL;
+	}
+
+	mutex_unlock(&mvm->mutex);
+	ieee80211_report_wowlan_wakeup(vif, wakeup_report, GFP_KERNEL);
+}
+
 static void iwl_mvm_read_d3_sram(struct iwl_mvm *mvm)
 {
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -1678,11 +1708,15 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	/* query SRAM first in case we want event logging */
 	iwl_mvm_read_d3_sram(mvm);
 
-	keep = iwl_mvm_query_wakeup_reasons(mvm, vif);
+	if (mvm->net_detect) {
+		iwl_mvm_query_netdetect_reasons(mvm, vif);
+	} else {
+		keep = iwl_mvm_query_wakeup_reasons(mvm, vif);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (keep)
-		mvm->keep_vif = vif;
+		if (keep)
+			mvm->keep_vif = vif;
 #endif
+	}
 	/* has unlocked the mutex, so skip that */
 	goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 7c62f80..e6079f4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -685,6 +685,7 @@ struct iwl_mvm {
 	/* sched scan settings for net detect */
 	struct cfg80211_sched_scan_request *nd_config;
 	struct ieee80211_scan_ies nd_ies;
+	bool net_detect;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	u32 d3_wake_sysassert; /* must be u32 for debugfs_create_bool */
 	bool d3_test_active;
-- 
1.9.1

