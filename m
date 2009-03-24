Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22940 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762637AbZCXQ5u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 12:57:50 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: show current driver status in user readable format
Date: Tue, 24 Mar 2009 10:02:54 -0700
Message-Id: <1237914174-569-1-git-send-email-reinette.chatre@intel.com> (sfid-20090324_175801_071106_F2143A29)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

change the display of current driver status bit to user readable format
for better and easier debugging

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   54 +++++++++++++++++++++++++++-
 1 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 36cfecc..64eb585 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -425,6 +425,56 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
+static ssize_t iwl_dbgfs_status_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	char buf[512];
+	int pos = 0;
+	const size_t bufsz = sizeof(buf);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_HCMD_ACTIVE:\t %d\n",
+		test_bit(STATUS_HCMD_ACTIVE, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_HCMD_SYNC_ACTIVE: %d\n",
+		test_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_INT_ENABLED:\t %d\n",
+		test_bit(STATUS_INT_ENABLED, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_RF_KILL_HW:\t %d\n",
+		test_bit(STATUS_RF_KILL_HW, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_RF_KILL_SW:\t %d\n",
+		test_bit(STATUS_RF_KILL_SW, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_INIT:\t\t %d\n",
+		test_bit(STATUS_INIT, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_ALIVE:\t\t %d\n",
+		test_bit(STATUS_ALIVE, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_READY:\t\t %d\n",
+		test_bit(STATUS_READY, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_TEMPERATURE:\t %d\n",
+		test_bit(STATUS_TEMPERATURE, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_GEO_CONFIGURED:\t %d\n",
+		test_bit(STATUS_GEO_CONFIGURED, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_EXIT_PENDING:\t %d\n",
+		test_bit(STATUS_EXIT_PENDING, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_IN_SUSPEND:\t %d\n",
+		test_bit(STATUS_IN_SUSPEND, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_STATISTICS:\t %d\n",
+		test_bit(STATUS_STATISTICS, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCANNING:\t %d\n",
+		test_bit(STATUS_SCANNING, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCAN_ABORTING:\t %d\n",
+		test_bit(STATUS_SCAN_ABORTING, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCAN_HW:\t\t %d\n",
+		test_bit(STATUS_SCAN_HW, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_POWER_PMI:\t %d\n",
+		test_bit(STATUS_POWER_PMI, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_FW_ERROR:\t %d\n",
+		test_bit(STATUS_FW_ERROR, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_MODE_PENDING:\t %d\n",
+		test_bit(STATUS_MODE_PENDING, &priv->status));
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(eeprom);
@@ -432,6 +482,7 @@ DEBUGFS_READ_FILE_OPS(stations);
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_FILE_OPS(channels);
+DEBUGFS_READ_FILE_OPS(status);
 
 /*
  * Create the debugfs files and directories
@@ -466,7 +517,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(rx_statistics, data);
 	DEBUGFS_ADD_FILE(tx_statistics, data);
 	DEBUGFS_ADD_FILE(channels, data);
-	DEBUGFS_ADD_X32(status, data, (u32 *)&priv->status);
+	DEBUGFS_ADD_FILE(status, data);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
@@ -496,6 +547,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_log_event);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_stations);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_channels);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_status);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
-- 
1.5.6.3

