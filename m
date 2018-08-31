Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45752 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbeHaOFa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:05:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Ido Yariv <idox.yariv@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:10 +0300
Message-Id: <20180831095614.14099-13-luca@coelho.fi> (sfid-20180831_115850_076108_567A16CA)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 12/16] iwlwifi: mvm: enable sending HE_AIR_SNIFFER command via debugfs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

In order to receive TB (Trigger Based) PPDU in monitor mode,
the Driver must send the HE_AIR_SNIFFER_CONFIG_CMD host command.
Enable that via debugfs.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/datapath.h  |  5 ++
 .../net/wireless/intel/iwlwifi/fw/api/mac.h   | 14 +++++
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 53 +++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
index 59b3c6e8f37b..eff3249af48a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
@@ -99,6 +99,11 @@ enum iwl_data_path_subcmd_ids {
 	 */
 	TLC_MNG_CONFIG_CMD = 0xF,
 
+	/**
+	 * @HE_AIR_SNIFFER_CONFIG_CMD: &struct iwl_he_monitor_cmd
+	 */
+	HE_AIR_SNIFFER_CONFIG_CMD = 0x13,
+
 	/**
 	 * @TLC_MNG_UPDATE_NOTIF: &struct iwl_tlc_update_notif
 	 */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
index 55594c93b014..1dd23f846fb9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
@@ -578,4 +578,18 @@ struct iwl_he_sta_context_cmd {
 	struct iwl_he_backoff_conf trig_based_txf[AC_NUM];
 } __packed; /* STA_CONTEXT_DOT11AX_API_S */
 
+/**
+ * struct iwl_he_monitor_cmd - configure air sniffer for HE
+ * @bssid: the BSSID to sniff for
+ * @reserved1: reserved for dword alignment
+ * @aid: the AID to track on for HE MU
+ * @reserved2: reserved for future use
+ */
+struct iwl_he_monitor_cmd {
+	u8 bssid[6];
+	__le16 reserved1;
+	__le16 aid;
+	u8 reserved2[6];
+} __packed; /* HE_AIR_SNIFFER_CONFIG_CMD_API_S_VER_1 */
+
 #endif /* __iwl_fw_api_mac_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 202158d03d36..725b97ecb447 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1727,6 +1727,57 @@ iwl_dbgfs_send_echo_cmd_write(struct iwl_mvm *mvm, char *buf,
 	return ret ?: count;
 }
 
+static ssize_t
+iwl_dbgfs_set_aid_read(struct file *file, char __user *user_buf,
+		       size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static ssize_t
+iwl_dbgfs_set_aid_write(struct file *file, const char __user *user_buf,
+			size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	struct iwl_he_monitor_cmd he_mon_cmd = {};
+	u8 tmp_buf[32];
+	u32 aid;
+	int ret;
+
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
+	if (count > sizeof(tmp_buf))
+		return -EINVAL;
+
+	if (copy_from_user(tmp_buf, user_buf, count))
+		return -EIO;
+
+	ret = sscanf(tmp_buf, "%x %2hhx:%2hhx:%2hhx:%2hhx:%2hhx:%2hhx", &aid,
+		     &he_mon_cmd.bssid[0], &he_mon_cmd.bssid[1],
+		     &he_mon_cmd.bssid[2], &he_mon_cmd.bssid[3],
+		     &he_mon_cmd.bssid[4], &he_mon_cmd.bssid[5]);
+	if (ret != 7)
+		return -EINVAL;
+
+	he_mon_cmd.aid = cpu_to_le16(aid);
+
+	mutex_lock(&mvm->mutex);
+	ret = iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(HE_AIR_SNIFFER_CONFIG_CMD,
+						   DATA_PATH_GROUP, 0), 0,
+				   sizeof(he_mon_cmd), &he_mon_cmd);
+	mutex_unlock(&mvm->mutex);
+
+	return ret ?: count;
+}
+
+static const struct file_operations iwl_dbgfs_set_aid_ops = {
+	.read = iwl_dbgfs_set_aid_read,
+	.write = iwl_dbgfs_set_aid_write,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 static ssize_t
 iwl_dbgfs_uapsd_noagg_bssids_read(struct file *file, char __user *user_buf,
 				  size_t count, loff_t *ppos)
@@ -2046,6 +2097,8 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 		goto err;
 
 	debugfs_create_file("mem", 0600, dbgfs_dir, mvm, &iwl_dbgfs_mem_ops);
+	debugfs_create_file("set_aid", 0200, dbgfs_dir, mvm,
+			    &iwl_dbgfs_set_aid_ops);
 
 	/*
 	 * Create a symlink with mac80211. It will be removed when mac80211
-- 
2.18.0
