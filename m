Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:33091 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3KXUGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:06:53 -0500
Received: by mail-we0-f182.google.com with SMTP id q59so3114472wes.27
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:06:52 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/29] iwlwifi: mvm: Add debugfs entry to generate NMI to NIC
Date: Sun, 24 Nov 2013 22:06:19 +0200
Message-Id: <1385323606-3603-2-git-send-email-egrumbach@gmail.com> (sfid-20131124_210656_536062_B7DA5FA3)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Writting to fw_nmi entry will set DEVICE_SET_NMI_REG (0x00a01c30)
generating NMI that halts NIC CPU.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h    |    3 +++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |   14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index a70c7b9..f6412da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -102,6 +102,9 @@
 /* Device system time */
 #define DEVICE_SYSTEM_TIME_REG 0xA0206C
 
+/* Device NMI register */
+#define DEVICE_SET_NMI_REG 0x00a01c30
+
 /*****************************************************************************
  *                        7000/3000 series SHR DTS addresses                 *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 9864d71..4b31d06 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -63,6 +63,7 @@
 #include "mvm.h"
 #include "sta.h"
 #include "iwl-io.h"
+#include "iwl-prph.h"
 
 struct iwl_dbgfs_mvm_ctx {
 	struct iwl_mvm *mvm;
@@ -800,6 +801,17 @@ static ssize_t iwl_dbgfs_fw_restart_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_fw_nmi_write(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+
+	iwl_write_prph(mvm->trans, DEVICE_SET_NMI_REG, 1);
+
+	return count;
+}
+
 static ssize_t
 iwl_dbgfs_scan_ant_rxchain_read(struct file *file,
 				char __user *user_buf,
@@ -1164,6 +1176,7 @@ MVM_DEBUGFS_READ_FILE_OPS(bt_cmd);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(disable_power_off);
 MVM_DEBUGFS_READ_FILE_OPS(fw_rx_stats);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_restart);
+MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain);
 
 #ifdef CONFIG_PM_SLEEP
@@ -1192,6 +1205,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 				     S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_rx_stats, mvm->debugfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_restart, mvm->debugfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(fw_nmi, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(scan_ant_rxchain, mvm->debugfs_dir,
 			     S_IWUSR | S_IRUSR);
 #ifdef CONFIG_PM_SLEEP
-- 
1.7.9.5

