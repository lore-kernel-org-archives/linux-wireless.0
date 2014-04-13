Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:54814 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbaDMTVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:06 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so7251865wgh.34
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:05 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/47] iwlwifi: remove IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD flag
Date: Sun, 13 Apr 2014 22:19:53 +0300
Message-Id: <1397416802-32403-38-git-send-email-egrumbach@gmail.com> (sfid-20140413_213515_856007_4F2B0558)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this flag set.

Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h          |  3 ---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 10 ----------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c     |  5 ++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  2 --
 drivers/net/wireless/iwlwifi/mvm/power.c       | 13 -------------
 5 files changed, 2 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 77f02e1..265d6f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -83,8 +83,6 @@
  *	from the probe request template.
  * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL: new NS offload (small version)
  * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE: new NS offload (large version)
- * @IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD: support device wide power command
- *	containing CAM (Continuous Active Mode) indication.
  * @IWL_UCODE_TLV_FLAGS_P2P_PM: P2P client supports PM as a stand alone MAC
  * @IWL_UCODE_TLV_FLAGS_P2P_BSS_PS_DCM: support power save on BSS station and
  *	P2P client interfaces simultaneously if they are in different bindings.
@@ -105,7 +103,6 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID	= BIT(12),
 	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL	= BIT(15),
 	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE	= BIT(16),
-	IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD	= BIT(20),
 	IWL_UCODE_TLV_FLAGS_P2P_PM		= BIT(21),
 	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM	= BIT(22),
 	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_SCM	= BIT(23),
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index d372ca6..6047cfd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -103,10 +103,6 @@ static void iwl_dbgfs_update_pm(struct iwl_mvm *mvm,
 		IWL_DEBUG_POWER(mvm, "tx_data_timeout=%d\n", val);
 		dbgfs_pm->tx_data_timeout = val;
 		break;
-	case MVM_DEBUGFS_PM_DISABLE_POWER_OFF:
-		IWL_DEBUG_POWER(mvm, "disable_power_off=%d\n", val);
-		dbgfs_pm->disable_power_off = val;
-		break;
 	case MVM_DEBUGFS_PM_LPRX_ENA:
 		IWL_DEBUG_POWER(mvm, "lprx %s\n", val ? "enabled" : "disabled");
 		dbgfs_pm->lprx_ena = val;
@@ -154,12 +150,6 @@ static ssize_t iwl_dbgfs_pm_params_write(struct ieee80211_vif *vif, char *buf,
 		if (sscanf(buf + 16, "%d", &val) != 1)
 			return -EINVAL;
 		param = MVM_DEBUGFS_PM_TX_DATA_TIMEOUT;
-	} else if (!strncmp("disable_power_off=", buf, 18) &&
-		   !(mvm->fw->ucode_capa.flags &
-		     IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD)) {
-		if (sscanf(buf + 18, "%d", &val) != 1)
-			return -EINVAL;
-		param = MVM_DEBUGFS_PM_DISABLE_POWER_OFF;
 	} else if (!strncmp("lprx=", buf, 5)) {
 		if (sscanf(buf + 5, "%d", &val) != 1)
 			return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index d727572..db368cd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1135,9 +1135,8 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(fw_error_dump, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_notif, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_cmd, dbgfs_dir, S_IRUSR);
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD)
-		MVM_DEBUGFS_ADD_FILE(disable_power_off, mvm->debugfs_dir,
-				     S_IRUSR | S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(disable_power_off, mvm->debugfs_dir,
+			     S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_rx_stats, mvm->debugfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(drv_rx_stats, mvm->debugfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_restart, mvm->debugfs_dir, S_IWUSR);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index a0fb7b1..afca542 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -164,7 +164,6 @@ enum iwl_dbgfs_pm_mask {
 	MVM_DEBUGFS_PM_SKIP_DTIM_PERIODS = BIT(2),
 	MVM_DEBUGFS_PM_RX_DATA_TIMEOUT = BIT(3),
 	MVM_DEBUGFS_PM_TX_DATA_TIMEOUT = BIT(4),
-	MVM_DEBUGFS_PM_DISABLE_POWER_OFF = BIT(5),
 	MVM_DEBUGFS_PM_LPRX_ENA = BIT(6),
 	MVM_DEBUGFS_PM_LPRX_RSSI_THRESHOLD = BIT(7),
 	MVM_DEBUGFS_PM_SNOOZE_ENABLE = BIT(8),
@@ -177,7 +176,6 @@ struct iwl_dbgfs_pm {
 	u32 tx_data_timeout;
 	bool skip_over_dtim;
 	u8 skip_dtim_periods;
-	bool disable_power_off;
 	bool lprx_ena;
 	u32 lprx_rssi_threshold;
 	bool snooze_ena;
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index dba760f..2e6f477 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -303,11 +303,6 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_DISABLE_POWER_OFF &&
-	    mvmvif->dbgfs_pm.disable_power_off)
-		cmd->flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
-#endif
 	if (!vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif) ||
 	    !mvmvif->pm_enabled)
 		return;
@@ -437,9 +432,6 @@ int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
 		.flags = cpu_to_le16(DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK),
 	};
 
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD))
-		return 0;
-
 	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM)
 		mvm->ps_disabled = true;
 
@@ -696,11 +688,6 @@ int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
 	memcpy(&cmd, &mvmvif->mac_pwr_cmd, sizeof(cmd));
 	mutex_unlock(&mvm->mutex);
 
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD))
-		pos += scnprintf(buf+pos, bufsz-pos, "disable_power_off = %d\n",
-				 (cmd.flags &
-				 cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK)) ?
-				 0 : 1);
 	pos += scnprintf(buf+pos, bufsz-pos, "power_scheme = %d\n",
 			 iwlmvm_mod_params.power_scheme);
 	pos += scnprintf(buf+pos, bufsz-pos, "flags = 0x%x\n",
-- 
1.8.3.2

