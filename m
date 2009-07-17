Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12884 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964884AbZGQQab (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:31 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/14] iwlwifi: add led debugfs function
Date: Fri, 17 Jul 2009 09:30:19 -0700
Message-Id: <1247848227-24031-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-5-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding debugfs file to show current led blinking rate
/sys/kernel/debug/ieee80211/phy0/iwlagn/data/led

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    3 ++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   36 ++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 1555676..e4a4dbd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -83,6 +83,9 @@ struct iwl_debugfs {
 		struct dentry *file_status;
 		struct dentry *file_interrupt;
 		struct dentry *file_qos;
+#ifdef CONFIG_IWLWIFI_LEDS
+		struct dentry *file_led;
+#endif
 	} dbgfs_data_files;
 	struct dir_rf_files {
 		struct dentry *file_disable_sensitivity;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 0b9e824..0ab3463 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -591,6 +591,33 @@ static ssize_t iwl_dbgfs_qos_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
+#ifdef CONFIG_IWLWIFI_LEDS
+static ssize_t iwl_dbgfs_led_read(struct file *file, char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	char buf[256];
+	const size_t bufsz = sizeof(buf);
+	ssize_t ret;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "allow blinking: %s\n",
+			 (priv->allow_blinking) ? "True" : "False");
+	if (priv->allow_blinking) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "Led blinking rate: %u\n",
+				 priv->last_blink_rate);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "Last blink time: %lu\n",
+				 priv->last_blink_time);
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	return ret;
+}
+#endif
+
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(nvm);
@@ -601,6 +628,9 @@ DEBUGFS_READ_FILE_OPS(channels);
 DEBUGFS_READ_FILE_OPS(status);
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(qos);
+#ifdef CONFIG_IWLWIFI_LEDS
+DEBUGFS_READ_FILE_OPS(led);
+#endif
 
 /*
  * Create the debugfs files and directories
@@ -638,6 +668,9 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(status, data);
 	DEBUGFS_ADD_FILE(interrupt, data);
 	DEBUGFS_ADD_FILE(qos, data);
+#ifdef CONFIG_IWLWIFI_LEDS
+	DEBUGFS_ADD_FILE(led, data);
+#endif
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
@@ -673,6 +706,9 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_status);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_interrupt);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_qos);
+#ifdef CONFIG_IWLWIFI_LEDS
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_led);
+#endif
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
-- 
1.5.6.3

