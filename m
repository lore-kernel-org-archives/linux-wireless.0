Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab1IVPCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 11:02:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlagn: sparse warning priv->temperature is signed
Date: Thu, 22 Sep 2011 07:15:37 -0700
Message-Id: <1316700937-22240-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110922_170214_271869_6B995DF9)
In-Reply-To: <1316700937-22240-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316700937-22240-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since priv->temperature is signed, we cannot use debugfs_create_u32
to refer to it.
Use a regular debugfs file instead.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index bf2a678..6d49dfb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -715,6 +715,20 @@ static ssize_t iwl_dbgfs_disable_ht40_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+static ssize_t iwl_dbgfs_temperature_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int pos = 0;
+	const size_t bufsz = sizeof(buf);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "%d\n", priv->temperature);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+
 static ssize_t iwl_dbgfs_sleep_level_override_write(struct file *file,
 						    const char __user *user_buf,
 						    size_t count, loff_t *ppos)
@@ -809,6 +823,7 @@ DEBUGFS_READ_WRITE_FILE_OPS(rx_handlers);
 DEBUGFS_READ_FILE_OPS(qos);
 DEBUGFS_READ_FILE_OPS(thermal_throttling);
 DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
+DEBUGFS_READ_FILE_OPS(temperature);
 DEBUGFS_READ_WRITE_FILE_OPS(sleep_level_override);
 DEBUGFS_READ_FILE_OPS(current_sleep_command);
 
@@ -2536,7 +2551,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(current_sleep_command, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(thermal_throttling, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_U32(temperature, dir_data, &priv->temperature, S_IRUSR);
+	DEBUGFS_ADD_FILE(temperature, dir_data, S_IRUSR);
 
 	DEBUGFS_ADD_FILE(rx_statistics, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_statistics, dir_debug, S_IRUSR);
-- 
1.7.0.4

