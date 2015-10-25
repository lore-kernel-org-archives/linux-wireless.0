Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbJYMBa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/16] iwlwifi: mvm: use wowlan RX/TX timeouts in D0i3
Date: Sun, 25 Oct 2015 14:01:05 +0200
Message-Id: <1445774476-24792-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130133_616604_786DB007)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In "hostless" mode (D3 or D0i3) the same parameters were intended
to be used, but the code doesn't do that properly. Fix it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 723b537..7c354fe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -348,7 +348,8 @@ static void iwl_mvm_power_config_skip_dtim(struct iwl_mvm *mvm,
 
 static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
-				    struct iwl_mac_power_cmd *cmd)
+				    struct iwl_mac_power_cmd *cmd,
+				    bool host_awake)
 {
 	int dtimper, bi;
 	int keep_alive;
@@ -389,10 +390,9 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 		cmd->lprx_rssi_threshold = POWER_LPRX_RSSI_THRESHOLD;
 	}
 
-	iwl_mvm_power_config_skip_dtim(mvm, vif, cmd,
-				       mvm->cur_ucode != IWL_UCODE_WOWLAN);
+	iwl_mvm_power_config_skip_dtim(mvm, vif, cmd, host_awake);
 
-	if (mvm->cur_ucode != IWL_UCODE_WOWLAN) {
+	if (host_awake) {
 		cmd->rx_data_timeout =
 			cpu_to_le32(IWL_MVM_DEFAULT_PS_RX_DATA_TIMEOUT);
 		cmd->tx_data_timeout =
@@ -458,7 +458,8 @@ static int iwl_mvm_power_send_cmd(struct iwl_mvm *mvm,
 {
 	struct iwl_mac_power_cmd cmd = {};
 
-	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
+	iwl_mvm_power_build_cmd(mvm, vif, &cmd,
+				mvm->cur_ucode != IWL_UCODE_WOWLAN);
 	iwl_mvm_power_log(mvm, &cmd);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	memcpy(&iwl_mvm_vif_from_mac80211(vif)->mac_pwr_cmd, &cmd, sizeof(cmd));
@@ -994,11 +995,7 @@ int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
 	if (!vif->bss_conf.assoc)
 		return 0;
 
-	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
-
-	/* when enabling D0i3, override the skip-over-dtim configuration */
-	if (enable)
-		iwl_mvm_power_config_skip_dtim(mvm, vif, &cmd, false);
+	iwl_mvm_power_build_cmd(mvm, vif, &cmd, !enable);
 
 	iwl_mvm_power_log(mvm, &cmd);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
2.1.4

