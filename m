Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45719 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753072AbbIUU7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 16:59:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:43 +0300
Message-Id: <1442869141-31637-3-git-send-email-luca@coelho.fi> (sfid-20150921_231005_253989_D0DFA45C)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 03/21] iwlwifi: mvm: add debugfs hook to send ECHO_CMD to the firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

ECHO_CMD is a simple command that can be sent to the
firmware just to check that it is alive.
This command is useful for debug purpose, provide a debugfs
hook to send it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 15 +++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h  |  1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c     |  1 +
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 08d2ae3..3b8481f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1361,11 +1361,25 @@ out:
 	return count;
 }
 
+static ssize_t
+iwl_dbgfs_send_echo_cmd_write(struct iwl_mvm *mvm, char *buf,
+			      size_t count, loff_t *ppos)
+{
+	int ret;
+
+	mutex_lock(&mvm->mutex);
+	ret = iwl_mvm_send_cmd_pdu(mvm, ECHO_CMD, 0, 0, NULL);
+	mutex_unlock(&mvm->mutex);
+
+	return ret ?: count;
+}
+
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(prph_reg, 64);
 
 /* Device wide debugfs entries */
 MVM_DEBUGFS_WRITE_FILE_OPS(tx_flush, 16);
 MVM_DEBUGFS_WRITE_FILE_OPS(sta_drain, 8);
+MVM_DEBUGFS_WRITE_FILE_OPS(send_echo_cmd, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(sram, 64);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(set_nic_temperature, 64);
 MVM_DEBUGFS_READ_FILE_OPS(nic_temp);
@@ -1425,6 +1439,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_conf, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_collect, mvm->debugfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(send_echo_cmd, mvm->debugfs_dir, S_IWUSR);
 	if (!debugfs_create_bool("enable_scan_iteration_notif",
 				 S_IRUSR | S_IWUSR,
 				 mvm->debugfs_dir,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 4af7513a..cd293d2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -100,6 +100,7 @@ enum iwl_mvm_tx_fifo {
 enum {
 	MVM_ALIVE = 0x1,
 	REPLY_ERROR = 0x2,
+	ECHO_CMD = 0x3,
 
 	INIT_COMPLETE_NOTIF = 0x4,
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a37de3f..0092286 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -271,6 +271,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 static const char *const iwl_mvm_cmd_strings[REPLY_MAX + 1] = {
 	CMD(MVM_ALIVE),
 	CMD(REPLY_ERROR),
+	CMD(ECHO_CMD),
 	CMD(INIT_COMPLETE_NOTIF),
 	CMD(PHY_CONTEXT_CMD),
 	CMD(MGMT_MCAST_KEY),
-- 
2.5.1

