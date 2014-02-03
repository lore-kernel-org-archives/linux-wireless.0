Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:39084 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBCU6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:42 -0500
Received: by mail-ea0-f171.google.com with SMTP id f15so3945682eak.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:41 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/62] iwlwifi: mvm: disable powersave in low-latency
Date: Mon,  3 Feb 2014 22:57:23 +0200
Message-Id: <1391461088-8082-17-git-send-email-egrumbach@gmail.com> (sfid-20140203_220008_720712_D8E592C3)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

While an interface is in low-latency mode, for now powersave
should be disabled for it, so take low-latency into account
in the powersave code and force powersave recalculation when
low-latency mode changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c |    3 ++-
 drivers/net/wireless/iwlwifi/mvm/utils.c |    6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index d9eab3b..436c7e0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -312,7 +312,8 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	    mvmvif->dbgfs_pm.disable_power_off)
 		cmd->flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
 #endif
-	if (!vif->bss_conf.ps || mvmvif->pm_prevented)
+	if (!vif->bss_conf.ps || mvmvif->pm_prevented ||
+	    iwl_mvm_vif_low_latency(mvmvif))
 		return;
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index e2cc876..790da1b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -541,10 +541,14 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			       bool value)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	int res;
 
 	lockdep_assert_held(&mvm->mutex);
 
 	mvmvif->low_latency = value;
 
-	return iwl_mvm_update_quotas(mvm, NULL);
+	res = iwl_mvm_update_quotas(mvm, NULL);
+	if (res)
+		return res;
+	return iwl_mvm_power_update_mode(mvm, vif);
 }
-- 
1.7.9.5

