Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49775 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbZGIRdn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:33:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/6] iwlwifi: move show_qos to debugfs
Date: Thu,  9 Jul 2009 10:33:36 -0700
Message-Id: <1247160821-14989-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247160821-14989-1-git-send-email-reinette.chatre@intel.com>
References: <1247160821-14989-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This move the show_qos file from sysfs to debugfs because the "one
value per file" sysfs rule.

The file is located in
/sys/kernel/debug/ieee80211/phy0/iwlagn/data

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   21 ---------------------
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   25 +++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1d4e9ca..13279b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2629,26 +2629,6 @@ static ssize_t show_power_level(struct device *d,
 static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
 		   store_power_level);
 
-static ssize_t show_qos(struct device *d,
-				struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	char *p = buf;
-	int   q;
-
-	for (q = 0; q < AC_NUM; q++) {
-		p += sprintf(p, "\tcw_min\tcw_max\taifsn\ttxop\n");
-		p += sprintf(p, "AC[%d]\t%u\t%u\t%u\t%u\n", q,
-			     priv->qos_data.def_qos_parm.ac[q].cw_min,
-			     priv->qos_data.def_qos_parm.ac[q].cw_max,
-			     priv->qos_data.def_qos_parm.ac[q].aifsn,
-			     priv->qos_data.def_qos_parm.ac[q].edca_txop);
-	}
-
-	return p - buf + 1;
-}
-
-static DEVICE_ATTR(qos, S_IRUGO, show_qos, NULL);
 
 static ssize_t show_statistics(struct device *d,
 			       struct device_attribute *attr, char *buf)
@@ -2749,7 +2729,6 @@ static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_debug_level.attr,
 #endif
 	&dev_attr_version.attr,
-	&dev_attr_qos.attr,
 	NULL
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 65bbce0..1555676 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -82,6 +82,7 @@ struct iwl_debugfs {
 		struct dentry *file_channels;
 		struct dentry *file_status;
 		struct dentry *file_interrupt;
+		struct dentry *file_qos;
 	} dbgfs_data_files;
 	struct dir_rf_files {
 		struct dentry *file_disable_sensitivity;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index f32ac74..e38ec81 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -566,6 +566,28 @@ static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_qos_read(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0, i;
+	char buf[256];
+	const size_t bufsz = sizeof(buf);
+	ssize_t ret;
+
+	for (i = 0; i < AC_NUM; i++) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+			"\tcw_min\tcw_max\taifsn\ttxop\n");
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"AC[%d]\t%u\t%u\t%u\t%u\n", i,
+				priv->qos_data.def_qos_parm.ac[i].cw_min,
+				priv->qos_data.def_qos_parm.ac[i].cw_max,
+				priv->qos_data.def_qos_parm.ac[i].aifsn,
+				priv->qos_data.def_qos_parm.ac[i].edca_txop);
+	}
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	return ret;
+}
 
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_WRITE_FILE_OPS(log_event);
@@ -576,6 +598,7 @@ DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_FILE_OPS(channels);
 DEBUGFS_READ_FILE_OPS(status);
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
+DEBUGFS_READ_FILE_OPS(qos);
 
 /*
  * Create the debugfs files and directories
@@ -612,6 +635,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(channels, data);
 	DEBUGFS_ADD_FILE(status, data);
 	DEBUGFS_ADD_FILE(interrupt, data);
+	DEBUGFS_ADD_FILE(qos, data);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
@@ -646,6 +670,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_channels);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_status);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_interrupt);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_qos);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
-- 
1.5.6.3

