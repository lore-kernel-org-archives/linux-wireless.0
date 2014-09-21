Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34894 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaIUTWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:34 -0400
Received: by mail-wi0-f179.google.com with SMTP id d1so1852376wiv.0
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:33 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/17] iwlwifi: mvm: add debugfs entry to read the current temperature
Date: Sun, 21 Sep 2014 22:22:07 +0300
Message-Id: <1411327338-23099-6-git-send-email-egrumbach@gmail.com> (sfid-20140921_212242_093156_0778F8B9)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

When read, this new debugfs entry requests the current temperature
from the firmware and outputs it.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 25 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |  1 +
 drivers/net/wireless/iwlwifi/mvm/tt.c      |  2 +-
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 95eb9a5..50527a9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -326,6 +326,29 @@ out:
 	return count;
 }
 
+static ssize_t iwl_dbgfs_nic_temp_read(struct file *file,
+				       char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	char buf[16];
+	int pos, temp;
+
+	if (!mvm->ucode_loaded)
+		return -EIO;
+
+	mutex_lock(&mvm->mutex);
+	temp = iwl_mvm_get_temp(mvm);
+	mutex_unlock(&mvm->mutex);
+
+	if (temp < 0)
+		return temp;
+
+	pos = scnprintf(buf , sizeof(buf), "%d\n", temp);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
@@ -1378,6 +1401,7 @@ MVM_DEBUGFS_WRITE_FILE_OPS(tx_flush, 16);
 MVM_DEBUGFS_WRITE_FILE_OPS(sta_drain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(sram, 64);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(set_nic_temperature, 64);
+MVM_DEBUGFS_READ_FILE_OPS(nic_temp);
 MVM_DEBUGFS_READ_FILE_OPS(stations);
 MVM_DEBUGFS_READ_FILE_OPS(bt_notif);
 MVM_DEBUGFS_READ_FILE_OPS(bt_cmd);
@@ -1420,6 +1444,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(sram, mvm->debugfs_dir, S_IWUSR | S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(set_nic_temperature, mvm->debugfs_dir,
 			     S_IWUSR | S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE(nic_temp, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(stations, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_error_dump, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_notif, dbgfs_dir, S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 8eacebb..c913d5e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1188,6 +1188,7 @@ void iwl_mvm_tt_handler(struct iwl_mvm *mvm);
 void iwl_mvm_tt_initialize(struct iwl_mvm *mvm, u32 min_backoff);
 void iwl_mvm_tt_exit(struct iwl_mvm *mvm);
 void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state);
+int iwl_mvm_get_temp(struct iwl_mvm *mvm);
 
 /* smart fifo */
 int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index c750ca7..acca44a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -135,7 +135,7 @@ static int iwl_mvm_get_temp_cmd(struct iwl_mvm *mvm)
 				    sizeof(cmd), &cmd);
 }
 
-static int iwl_mvm_get_temp(struct iwl_mvm *mvm)
+int iwl_mvm_get_temp(struct iwl_mvm *mvm)
 {
 	struct iwl_notification_wait wait_temp_notif;
 	static const u8 temp_notif[] = { DTS_MEASUREMENT_NOTIFICATION };
-- 
1.9.1

