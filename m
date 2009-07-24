Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23615 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbZGXSNQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/14] iwlwifi: Thermal Throttling debugfs function
Date: Fri, 24 Jul 2009 11:13:04 -0700
Message-Id: <1248459194-10239-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add debugfs function to display current thermal throttling status for
both Legacy and Advance Thermal Throttling Management

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   38 ++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 9faf0c2..609a681 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -84,6 +84,7 @@ struct iwl_debugfs {
 		struct dentry *file_status;
 		struct dentry *file_interrupt;
 		struct dentry *file_qos;
+		struct dentry *file_thermal_throttling;
 #ifdef CONFIG_IWLWIFI_LEDS
 		struct dentry *file_led;
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 0ab3463..748dc31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -618,6 +618,41 @@ static ssize_t iwl_dbgfs_led_read(struct file *file, char __user *user_buf,
 }
 #endif
 
+static ssize_t iwl_dbgfs_thermal_throttling_read(struct file *file,
+				char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_restriction *restriction;
+	char buf[100];
+	int pos = 0;
+	const size_t bufsz = sizeof(buf);
+	ssize_t ret;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"Thermal Throttling Mode: %s\n",
+			(priv->power_data.adv_tt)
+			? "Advance" : "Legacy");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"Thermal Throttling State: %d\n",
+			tt->state);
+	if (priv->power_data.adv_tt) {
+		restriction = tt->restriction + tt->state;
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"Tx mode: %d\n",
+				restriction->tx_stream);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"Rx mode: %d\n",
+				restriction->rx_stream);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"HT mode: %d\n",
+				restriction->is_ht);
+	}
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	return ret;
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(nvm);
@@ -631,6 +666,7 @@ DEBUGFS_READ_FILE_OPS(qos);
 #ifdef CONFIG_IWLWIFI_LEDS
 DEBUGFS_READ_FILE_OPS(led);
 #endif
+DEBUGFS_READ_FILE_OPS(thermal_throttling);
 
 /*
  * Create the debugfs files and directories
@@ -671,6 +707,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 #ifdef CONFIG_IWLWIFI_LEDS
 	DEBUGFS_ADD_FILE(led, data);
 #endif
+	DEBUGFS_ADD_FILE(thermal_throttling, data);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
@@ -709,6 +746,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #ifdef CONFIG_IWLWIFI_LEDS
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_led);
 #endif
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_thermal_throttling);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
-- 
1.5.6.3

