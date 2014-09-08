Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:54565 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaIHQ4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 12:56:37 -0400
Received: by mail-we0-f181.google.com with SMTP id x48so15463641wes.12
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 09:56:36 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/12] iwlwiwi: mvm: use bss_conf->dtim_period instead of conf.ps_dtim_period
Date: Mon,  8 Sep 2014 19:56:13 +0300
Message-Id: <1410195377-10075-8-git-send-email-egrumbach@gmail.com> (sfid-20140908_185651_417332_D20C75A1)
In-Reply-To: <540DDF37.5030801@gmail.com>
References: <540DDF37.5030801@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The latter is meant for software implementation of power
save and is not per-virtual interface. Since our driver
supports multiple virtual interfaces, we need to use
vif->bss_conf.dtim_period.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 3 +--
 drivers/net/wireless/iwlwifi/mvm/power.c       | 5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 2e90ff7..87e517b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -74,8 +74,7 @@ static void iwl_dbgfs_update_pm(struct iwl_mvm *mvm,
 
 	switch (param) {
 	case MVM_DEBUGFS_PM_KEEP_ALIVE: {
-		struct ieee80211_hw *hw = mvm->hw;
-		int dtimper = hw->conf.ps_dtim_period ?: 1;
+		int dtimper = vif->bss_conf.dtim_period ?: 1;
 		int dtimper_msec = dtimper * vif->bss_conf.beacon_int;
 
 		IWL_DEBUG_POWER(mvm, "debugfs: set keep_alive= %d sec\n", val);
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 2b2d108..d9769a2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -281,7 +281,6 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
 				    struct iwl_mac_power_cmd *cmd)
 {
-	struct ieee80211_hw *hw = mvm->hw;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
 	int dtimper, dtimper_msec;
@@ -292,7 +291,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 
 	cmd->id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
 							    mvmvif->color));
-	dtimper = hw->conf.ps_dtim_period ?: 1;
+	dtimper = vif->bss_conf.dtim_period;
 
 	/*
 	 * Regardless of power management state the driver must set
@@ -885,7 +884,7 @@ int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
 	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
 	if (enable) {
 		/* configure skip over dtim up to 300 msec */
-		int dtimper = mvm->hw->conf.ps_dtim_period ?: 1;
+		int dtimper = vif->bss_conf.dtim_period ?: 1;
 		int dtimper_msec = dtimper * vif->bss_conf.beacon_int;
 
 		if (WARN_ON(!dtimper_msec))
-- 
1.9.1

