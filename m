Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:49434 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaBCU7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:51 -0500
Received: by mail-ea0-f169.google.com with SMTP id h10so4019717eak.14
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:50 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 59/62] iwlwifi: mvm: store latest power command for debugfs read
Date: Mon,  3 Feb 2014 22:58:05 +0200
Message-Id: <1391461088-8082-59-git-send-email-egrumbach@gmail.com> (sfid-20140203_223007_458467_FBF0DF03)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Instead of re-building the power command upon debugfs read,
store the latest command sent to the firmware.
This reduces the code complexity by reducing the number of
entries in the power code.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h   |    1 +
 drivers/net/wireless/iwlwifi/mvm/power.c |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 93e6c18..2d76e228 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -347,6 +347,7 @@ struct iwl_mvm_vif {
 	struct dentry *dbgfs_slink;
 	struct iwl_dbgfs_pm dbgfs_pm;
 	struct iwl_dbgfs_bf dbgfs_bf;
+	struct iwl_mac_power_cmd mac_pwr_cmd;
 #endif
 
 	enum ieee80211_smps_mode smps_requests[NUM_IWL_MVM_SMPS_REQ];
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 15c9c78..ac6d2c8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -431,6 +431,9 @@ static int _iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 
 	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
 	iwl_mvm_power_log(mvm, &cmd);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	memcpy(&iwl_mvm_vif_from_mac80211(vif)->mac_pwr_cmd, &cmd, sizeof(cmd));
+#endif
 
 	return iwl_mvm_send_cmd_pdu(mvm, MAC_PM_POWER_TABLE, CMD_SYNC,
 				    sizeof(cmd), &cmd);
@@ -475,6 +478,7 @@ static int iwl_mvm_power_mac_disable(struct iwl_mvm *mvm,
 	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_DISABLE_POWER_OFF &&
 	    mvmvif->dbgfs_pm.disable_power_off)
 		cmd.flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
+	memcpy(&mvmvif->mac_pwr_cmd, &cmd, sizeof(cmd));
 #endif
 	iwl_mvm_power_log(mvm, &cmd);
 
@@ -615,10 +619,13 @@ static int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif, char *buf,
 					int bufsz)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mac_power_cmd cmd = {};
 	int pos = 0;
 
-	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
+	mutex_lock(&mvm->mutex);
+	memcpy(&cmd, &mvmvif->mac_pwr_cmd, sizeof(cmd));
+	mutex_unlock(&mvm->mutex);
 
 	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD))
 		pos += scnprintf(buf+pos, bufsz-pos, "disable_power_off = %d\n",
@@ -807,6 +814,9 @@ int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
 		cmd.skip_dtim_periods = 300 / dtimper_msec;
 	}
 	iwl_mvm_power_log(mvm, &cmd);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	memcpy(&mvmvif->mac_pwr_cmd, &cmd, sizeof(cmd));
+#endif
 	ret = iwl_mvm_send_cmd_pdu(mvm, MAC_PM_POWER_TABLE, flags,
 				   sizeof(cmd), &cmd);
 	if (ret)
-- 
1.7.9.5

