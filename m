Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54352 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751323AbdIOMrO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 08:47:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 15 Sep 2017 15:46:55 +0300
Message-Id: <20170915124704.9032-2-luca@coelho.fi> (sfid-20170915_144721_702691_F3DE59BE)
In-Reply-To: <20170915124704.9032-1-luca@coelho.fi>
References: <20170915124704.9032-1-luca@coelho.fi>
Subject: [PATCH 01/10] iwlwifi: mvm: add dbgfs entry for fw info
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Add a dbgfs entry for an easy way during runtime to
check what FW file was loaded, and get some general
FW-related data.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 32 ++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index e97904c2c4d4..2ff594f11259 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -660,6 +660,36 @@ iwl_dbgfs_bt_force_ant_write(struct iwl_mvm *mvm, char *buf,
 	return ret ?: count;
 }
 
+static ssize_t iwl_dbgfs_fw_ver_read(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	char *buff, *pos, *endpos;
+	static const size_t bufsz = 1024;
+	int ret;
+
+	buff = kmalloc(bufsz, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
+	pos = buff;
+	endpos = pos + bufsz;
+
+	pos += scnprintf(pos, endpos - pos, "FW prefix: %s\n",
+			 mvm->trans->cfg->fw_name_pre);
+	pos += scnprintf(pos, endpos - pos, "FW: %s\n",
+			 mvm->fwrt.fw->human_readable);
+	pos += scnprintf(pos, endpos - pos, "Device: %s\n",
+			 mvm->fwrt.trans->cfg->name);
+	pos += scnprintf(pos, endpos - pos, "Bus: %s\n",
+			 mvm->fwrt.dev->bus->name);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buff, pos - buff);
+	kfree(buff);
+
+	return ret;
+}
+
 #define PRINT_STATS_LE32(_struct, _memb)				\
 			 pos += scnprintf(buf + pos, bufsz - pos,	\
 					  fmt_table, #_memb,		\
@@ -1662,6 +1692,7 @@ MVM_DEBUGFS_READ_FILE_OPS(bt_cmd);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(disable_power_off, 64);
 MVM_DEBUGFS_READ_FILE_OPS(fw_rx_stats);
 MVM_DEBUGFS_READ_FILE_OPS(drv_rx_stats);
+MVM_DEBUGFS_READ_FILE_OPS(fw_ver);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_restart, 10);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi, 10);
 MVM_DEBUGFS_WRITE_FILE_OPS(bt_tx_prio, 10);
@@ -1843,6 +1874,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(bt_cmd, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(disable_power_off, mvm->debugfs_dir,
 			     S_IRUSR | S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(fw_ver, mvm->debugfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_rx_stats, mvm->debugfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(drv_rx_stats, mvm->debugfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_restart, mvm->debugfs_dir, S_IWUSR);
-- 
2.14.1
