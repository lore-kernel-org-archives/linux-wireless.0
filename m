Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbYEECYJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH 05/25] iwlwifi: debugfs EEPROM dump
Date: Mon,  5 May 2008 10:22:32 +0800
Message-Id: <1209954172-3092-6-git-send-email-yi.zhu@intel.com> (sfid-20080505_042355_807599_744C46D1)
In-Reply-To: <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds EEPROM dump in debugfs.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   42 ++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index c60724c..7e68d24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -57,6 +57,7 @@ struct iwl_debugfs {
 	struct dentry *dir_data;
 	struct dir_data_files{
 		struct dentry *file_sram;
+		struct dentry *file_eeprom;
 		struct dentry *file_stations;
 		struct dentry *file_rx_statistics;
 		struct dentry *file_tx_statistics;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index e28c31d..b310f70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -271,8 +271,48 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
+static ssize_t iwl_dbgfs_eeprom_read(struct file *file,
+				       char __user *user_buf,
+				       size_t count,
+				       loff_t *ppos)
+{
+	ssize_t ret;
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0, ofs = 0, buf_size = 0;
+	const u8 *ptr;
+	char *buf;
+	size_t eeprom_len = priv->cfg->eeprom_size;
+	buf_size = 4 * eeprom_len + 256;
+
+	if (eeprom_len % 16) {
+		IWL_ERROR("EEPROM size is not multiple of 16.\n");
+		return -ENODATA;
+	}
+
+	/* 4 characters for byte 0xYY */
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERROR("Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	ptr = priv->eeprom;
+	for (ofs = 0 ; ofs < eeprom_len ; ofs += 16) {
+		pos += scnprintf(buf + pos, buf_size - pos, "0x%.4x ", ofs);
+		hex_dump_to_buffer(ptr + ofs, 16 , 16, 2, buf + pos,
+				   buf_size - pos, 0);
+		pos += strlen(buf);
+		if (buf_size - pos > 0)
+			buf[pos++] = '\n';
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
 
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
+DEBUGFS_READ_FILE_OPS(eeprom);
 DEBUGFS_READ_FILE_OPS(stations);
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
@@ -298,6 +338,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	}
 
 	DEBUGFS_ADD_DIR(data, dbgfs->dir_drv);
+	DEBUGFS_ADD_FILE(eeprom, data);
 	DEBUGFS_ADD_FILE(sram, data);
 	DEBUGFS_ADD_FILE(stations, data);
 	DEBUGFS_ADD_FILE(rx_statistics, data);
@@ -321,6 +362,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	if (!(priv->dbgfs))
 		return;
 
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_eeprom);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_rx_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_tx_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_sram);
-- 
1.5.3.6

