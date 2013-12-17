Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:39106 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3LQUpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:01 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so3130347eak.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:00 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/36] iwlwifi: mvm: add per-vif power debugfs hooks
Date: Tue, 17 Dec 2013 22:44:14 +0200
Message-Id: <1387313079-28123-11-git-send-email-egrumbach@gmail.com> (sfid-20131217_214511_710899_627F3E7F)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

This allows to tweak the power parameters per vif.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |  353 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/power.c       |    7 +
 2 files changed, 360 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 67f6a20..747adff 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -63,6 +63,150 @@
 #include "mvm.h"
 #include "debugfs.h"
 
+static void iwl_dbgfs_update_pm(struct iwl_mvm *mvm,
+				 struct ieee80211_vif *vif,
+				 enum iwl_dbgfs_pm_mask param, int val)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_dbgfs_pm *dbgfs_pm = &mvmvif->dbgfs_pm;
+
+	dbgfs_pm->mask |= param;
+
+	switch (param) {
+	case MVM_DEBUGFS_PM_KEEP_ALIVE: {
+		struct ieee80211_hw *hw = mvm->hw;
+		int dtimper = hw->conf.ps_dtim_period ?: 1;
+		int dtimper_msec = dtimper * vif->bss_conf.beacon_int;
+
+		IWL_DEBUG_POWER(mvm, "debugfs: set keep_alive= %d sec\n", val);
+		if (val * MSEC_PER_SEC < 3 * dtimper_msec)
+			IWL_WARN(mvm,
+				 "debugfs: keep alive period (%ld msec) is less than minimum required (%d msec)\n",
+				 val * MSEC_PER_SEC, 3 * dtimper_msec);
+		dbgfs_pm->keep_alive_seconds = val;
+		break;
+	}
+	case MVM_DEBUGFS_PM_SKIP_OVER_DTIM:
+		IWL_DEBUG_POWER(mvm, "skip_over_dtim %s\n",
+				val ? "enabled" : "disabled");
+		dbgfs_pm->skip_over_dtim = val;
+		break;
+	case MVM_DEBUGFS_PM_SKIP_DTIM_PERIODS:
+		IWL_DEBUG_POWER(mvm, "skip_dtim_periods=%d\n", val);
+		dbgfs_pm->skip_dtim_periods = val;
+		break;
+	case MVM_DEBUGFS_PM_RX_DATA_TIMEOUT:
+		IWL_DEBUG_POWER(mvm, "rx_data_timeout=%d\n", val);
+		dbgfs_pm->rx_data_timeout = val;
+		break;
+	case MVM_DEBUGFS_PM_TX_DATA_TIMEOUT:
+		IWL_DEBUG_POWER(mvm, "tx_data_timeout=%d\n", val);
+		dbgfs_pm->tx_data_timeout = val;
+		break;
+	case MVM_DEBUGFS_PM_DISABLE_POWER_OFF:
+		IWL_DEBUG_POWER(mvm, "disable_power_off=%d\n", val);
+		dbgfs_pm->disable_power_off = val;
+		break;
+	case MVM_DEBUGFS_PM_LPRX_ENA:
+		IWL_DEBUG_POWER(mvm, "lprx %s\n", val ? "enabled" : "disabled");
+		dbgfs_pm->lprx_ena = val;
+		break;
+	case MVM_DEBUGFS_PM_LPRX_RSSI_THRESHOLD:
+		IWL_DEBUG_POWER(mvm, "lprx_rssi_threshold=%d\n", val);
+		dbgfs_pm->lprx_rssi_threshold = val;
+		break;
+	case MVM_DEBUGFS_PM_SNOOZE_ENABLE:
+		IWL_DEBUG_POWER(mvm, "snooze_enable=%d\n", val);
+		dbgfs_pm->snooze_ena = val;
+		break;
+	case MVM_DEBUGFS_PM_UAPSD_MISBEHAVING:
+		IWL_DEBUG_POWER(mvm, "uapsd_misbehaving_enable=%d\n", val);
+		dbgfs_pm->uapsd_misbehaving = val;
+		break;
+	}
+}
+
+static ssize_t iwl_dbgfs_pm_params_write(struct ieee80211_vif *vif, char *buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	enum iwl_dbgfs_pm_mask param;
+	int val, ret;
+
+	if (!strncmp("keep_alive=", buf, 11)) {
+		if (sscanf(buf + 11, "%d", &val) != 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_KEEP_ALIVE;
+	} else if (!strncmp("skip_over_dtim=", buf, 15)) {
+		if (sscanf(buf + 15, "%d", &val) != 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_SKIP_OVER_DTIM;
+	} else if (!strncmp("skip_dtim_periods=", buf, 18)) {
+		if (sscanf(buf + 18, "%d", &val) != 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_SKIP_DTIM_PERIODS;
+	} else if (!strncmp("rx_data_timeout=", buf, 16)) {
+		if (sscanf(buf + 16, "%d", &val) != 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_RX_DATA_TIMEOUT;
+	} else if (!strncmp("tx_data_timeout=", buf, 16)) {
+		if (sscanf(buf + 16, "%d", &val) != 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_TX_DATA_TIMEOUT;
+	} else if (!strncmp("disable_power_off=", buf, 18) &&
+		   !(mvm->fw->ucode_capa.flags &
+		     IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD)) {
+		if (sscanf(buf + 18, "%d", &val) != 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_DISABLE_POWER_OFF;
+	} else if (!strncmp("lprx=", buf, 5)) {
+		if (sscanf(buf + 5, "%d", &val) != 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_LPRX_ENA;
+	} else if (!strncmp("lprx_rssi_threshold=", buf, 20)) {
+		if (sscanf(buf + 20, "%d", &val) != 1)
+			return -EINVAL;
+		if (val > POWER_LPRX_RSSI_THRESHOLD_MAX || val <
+		    POWER_LPRX_RSSI_THRESHOLD_MIN)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_LPRX_RSSI_THRESHOLD;
+	} else if (!strncmp("snooze_enable=", buf, 14)) {
+		if (sscanf(buf + 14, "%d", &val) != 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_SNOOZE_ENABLE;
+	} else if (!strncmp("uapsd_misbehaving=", buf, 18)) {
+		if (sscanf(buf + 18, "%d", &val) != 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_UAPSD_MISBEHAVING;
+	} else {
+		return -EINVAL;
+	}
+
+	mutex_lock(&mvm->mutex);
+	iwl_dbgfs_update_pm(mvm, vif, param, val);
+	ret = iwl_mvm_power_update_mode(mvm, vif);
+	mutex_unlock(&mvm->mutex);
+
+	return ret ?: count;
+}
+
+static ssize_t iwl_dbgfs_pm_params_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ieee80211_vif *vif = file->private_data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	char buf[512];
+	int bufsz = sizeof(buf);
+	int pos;
+
+	pos = iwl_mvm_power_dbgfs_read(mvm, vif, buf, bufsz);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 					 char __user *user_buf,
 					 size_t count, loff_t *ppos)
@@ -122,6 +266,201 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+static void iwl_dbgfs_update_bf(struct ieee80211_vif *vif,
+				enum iwl_dbgfs_bf_mask param, int value)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_dbgfs_bf *dbgfs_bf = &mvmvif->dbgfs_bf;
+
+	dbgfs_bf->mask |= param;
+
+	switch (param) {
+	case MVM_DEBUGFS_BF_ENERGY_DELTA:
+		dbgfs_bf->bf_energy_delta = value;
+		break;
+	case MVM_DEBUGFS_BF_ROAMING_ENERGY_DELTA:
+		dbgfs_bf->bf_roaming_energy_delta = value;
+		break;
+	case MVM_DEBUGFS_BF_ROAMING_STATE:
+		dbgfs_bf->bf_roaming_state = value;
+		break;
+	case MVM_DEBUGFS_BF_TEMP_THRESHOLD:
+		dbgfs_bf->bf_temp_threshold = value;
+		break;
+	case MVM_DEBUGFS_BF_TEMP_FAST_FILTER:
+		dbgfs_bf->bf_temp_fast_filter = value;
+		break;
+	case MVM_DEBUGFS_BF_TEMP_SLOW_FILTER:
+		dbgfs_bf->bf_temp_slow_filter = value;
+		break;
+	case MVM_DEBUGFS_BF_ENABLE_BEACON_FILTER:
+		dbgfs_bf->bf_enable_beacon_filter = value;
+		break;
+	case MVM_DEBUGFS_BF_DEBUG_FLAG:
+		dbgfs_bf->bf_debug_flag = value;
+		break;
+	case MVM_DEBUGFS_BF_ESCAPE_TIMER:
+		dbgfs_bf->bf_escape_timer = value;
+		break;
+	case MVM_DEBUGFS_BA_ENABLE_BEACON_ABORT:
+		dbgfs_bf->ba_enable_beacon_abort = value;
+		break;
+	case MVM_DEBUGFS_BA_ESCAPE_TIMER:
+		dbgfs_bf->ba_escape_timer = value;
+		break;
+	}
+}
+
+static ssize_t iwl_dbgfs_bf_params_write(struct ieee80211_vif *vif, char *buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	enum iwl_dbgfs_bf_mask param;
+	int value, ret = 0;
+
+	if (!strncmp("bf_energy_delta=", buf, 16)) {
+		if (sscanf(buf+16, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < IWL_BF_ENERGY_DELTA_MIN ||
+		    value > IWL_BF_ENERGY_DELTA_MAX)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BF_ENERGY_DELTA;
+	} else if (!strncmp("bf_roaming_energy_delta=", buf, 24)) {
+		if (sscanf(buf+24, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < IWL_BF_ROAMING_ENERGY_DELTA_MIN ||
+		    value > IWL_BF_ROAMING_ENERGY_DELTA_MAX)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BF_ROAMING_ENERGY_DELTA;
+	} else if (!strncmp("bf_roaming_state=", buf, 17)) {
+		if (sscanf(buf+17, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < IWL_BF_ROAMING_STATE_MIN ||
+		    value > IWL_BF_ROAMING_STATE_MAX)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BF_ROAMING_STATE;
+	} else if (!strncmp("bf_temp_threshold=", buf, 18)) {
+		if (sscanf(buf+18, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < IWL_BF_TEMP_THRESHOLD_MIN ||
+		    value > IWL_BF_TEMP_THRESHOLD_MAX)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BF_TEMP_THRESHOLD;
+	} else if (!strncmp("bf_temp_fast_filter=", buf, 20)) {
+		if (sscanf(buf+20, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < IWL_BF_TEMP_FAST_FILTER_MIN ||
+		    value > IWL_BF_TEMP_FAST_FILTER_MAX)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BF_TEMP_FAST_FILTER;
+	} else if (!strncmp("bf_temp_slow_filter=", buf, 20)) {
+		if (sscanf(buf+20, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < IWL_BF_TEMP_SLOW_FILTER_MIN ||
+		    value > IWL_BF_TEMP_SLOW_FILTER_MAX)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BF_TEMP_SLOW_FILTER;
+	} else if (!strncmp("bf_enable_beacon_filter=", buf, 24)) {
+		if (sscanf(buf+24, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < 0 || value > 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BF_ENABLE_BEACON_FILTER;
+	} else if (!strncmp("bf_debug_flag=", buf, 14)) {
+		if (sscanf(buf+14, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < 0 || value > 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BF_DEBUG_FLAG;
+	} else if (!strncmp("bf_escape_timer=", buf, 16)) {
+		if (sscanf(buf+16, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < IWL_BF_ESCAPE_TIMER_MIN ||
+		    value > IWL_BF_ESCAPE_TIMER_MAX)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BF_ESCAPE_TIMER;
+	} else if (!strncmp("ba_escape_timer=", buf, 16)) {
+		if (sscanf(buf+16, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < IWL_BA_ESCAPE_TIMER_MIN ||
+		    value > IWL_BA_ESCAPE_TIMER_MAX)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BA_ESCAPE_TIMER;
+	} else if (!strncmp("ba_enable_beacon_abort=", buf, 23)) {
+		if (sscanf(buf+23, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < 0 || value > 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BA_ENABLE_BEACON_ABORT;
+	} else {
+		return -EINVAL;
+	}
+
+	mutex_lock(&mvm->mutex);
+	iwl_dbgfs_update_bf(vif, param, value);
+	if (param == MVM_DEBUGFS_BF_ENABLE_BEACON_FILTER && !value)
+		ret = iwl_mvm_disable_beacon_filter(mvm, vif);
+	else
+		ret = iwl_mvm_enable_beacon_filter(mvm, vif);
+	mutex_unlock(&mvm->mutex);
+
+	return ret ?: count;
+}
+
+static ssize_t iwl_dbgfs_bf_params_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ieee80211_vif *vif = file->private_data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	char buf[256];
+	int pos = 0;
+	const size_t bufsz = sizeof(buf);
+	struct iwl_beacon_filter_cmd cmd = {
+		IWL_BF_CMD_CONFIG_DEFAULTS,
+		.bf_enable_beacon_filter =
+			cpu_to_le32(IWL_BF_ENABLE_BEACON_FILTER_DEFAULT),
+		.ba_enable_beacon_abort =
+			cpu_to_le32(IWL_BA_ENABLE_BEACON_ABORT_DEFAULT),
+	};
+
+	iwl_mvm_beacon_filter_debugfs_parameters(vif, &cmd);
+	if (mvmvif->bf_data.bf_enabled)
+		cmd.bf_enable_beacon_filter = cpu_to_le32(1);
+	else
+		cmd.bf_enable_beacon_filter = 0;
+
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_energy_delta = %d\n",
+			 le32_to_cpu(cmd.bf_energy_delta));
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_roaming_energy_delta = %d\n",
+			 le32_to_cpu(cmd.bf_roaming_energy_delta));
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_roaming_state = %d\n",
+			 le32_to_cpu(cmd.bf_roaming_state));
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_temp_threshold = %d\n",
+			 le32_to_cpu(cmd.bf_temp_threshold));
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_temp_fast_filter = %d\n",
+			 le32_to_cpu(cmd.bf_temp_fast_filter));
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_temp_slow_filter = %d\n",
+			 le32_to_cpu(cmd.bf_temp_slow_filter));
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_enable_beacon_filter = %d\n",
+			 le32_to_cpu(cmd.bf_enable_beacon_filter));
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_debug_flag = %d\n",
+			 le32_to_cpu(cmd.bf_debug_flag));
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_escape_timer = %d\n",
+			 le32_to_cpu(cmd.bf_escape_timer));
+	pos += scnprintf(buf+pos, bufsz-pos, "ba_escape_timer = %d\n",
+			 le32_to_cpu(cmd.ba_escape_timer));
+	pos += scnprintf(buf+pos, bufsz-pos, "ba_enable_beacon_abort = %d\n",
+			 le32_to_cpu(cmd.ba_enable_beacon_abort));
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+#define MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz) \
+	_MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct ieee80211_vif)
+#define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
+	_MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct ieee80211_vif)
 #define MVM_DEBUGFS_ADD_FILE_VIF(name, parent, mode) do {		\
 		if (!debugfs_create_file(#name, mode, parent, vif,	\
 					 &iwl_dbgfs_##name##_ops))	\
@@ -129,6 +468,8 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 	} while (0)
 
 MVM_DEBUGFS_READ_FILE_OPS(mac_params);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(pm_params, 32);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(bf_params, 256);
 
 void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
@@ -152,9 +493,21 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		return;
 	}
 
+	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
+	    ((vif->type == NL80211_IFTYPE_STATION && !vif->p2p) ||
+	     (vif->type == NL80211_IFTYPE_STATION && vif->p2p &&
+	      mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PS)))
+		MVM_DEBUGFS_ADD_FILE_VIF(pm_params, mvmvif->dbgfs_dir, S_IWUSR |
+					 S_IRUSR);
+
 	MVM_DEBUGFS_ADD_FILE_VIF(mac_params, mvmvif->dbgfs_dir,
 				 S_IRUSR);
 
+	if (vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
+	    mvmvif == mvm->bf_allowed_vif)
+		MVM_DEBUGFS_ADD_FILE_VIF(bf_params, mvmvif->dbgfs_dir,
+					 S_IRUSR | S_IWUSR);
+
 	/*
 	 * Create symlink for convenience pointing to interface specific
 	 * debugfs entries for the driver. For example, under
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 0ef4674..d173ea2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -406,6 +406,13 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 			cmd->flags &=
 				cpu_to_le16(~POWER_FLAGS_SNOOZE_ENA_MSK);
 	}
+	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_UAPSD_MISBEHAVING) {
+		u16 flag = POWER_FLAGS_UAPSD_MISBEHAVING_ENA_MSK;
+		if (mvmvif->dbgfs_pm.uapsd_misbehaving)
+			cmd->flags |= cpu_to_le16(flag);
+		else
+			cmd->flags &= cpu_to_le16(flag);
+	}
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 }
 
-- 
1.7.9.5

