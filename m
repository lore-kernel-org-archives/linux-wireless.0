Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17301 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbZG0UuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 16:50:15 -0400
Subject: [PATCH v3 12/14] iwlwifi: debugFs to enable/disable HT40 support
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
In-Reply-To: <20090727184339.GA8823@tuxdriver.com>
References: <1248705439.23314.24.camel@wwguy-ubuntu>
	 <20090727184339.GA8823@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 13:50:15 -0700
Message-Id: <1248727815.1216.503.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add debugfs file to enable/disable HT40(40MHz) channel support.
By default, 40MHz is supported if AP can support the function.

By echo "1" to "disable_ht40" file, iwlwifi driver will disable the
40MHz support and only allow 20MHz channel.

Because the information exchange happen during association time,
so enable/disable ht40 channel only can be performed when it is not
associated with AP.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
v2: name change "fat_mode" -> "ht40"
v3: formatting fixes

John,

This patch applies cleanly after reverting the original. Sorry for the problems.

Reinette


 drivers/net/wireless/iwlwifi/iwl-core.c    |    4 ++
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   46 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    1 +
 4 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 85d6fef..b6528f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -646,6 +646,10 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 		if (!sta_ht_inf->ht_supported)
 			return 0;
 	}
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (priv->disable_ht40)
+		return 0;
+#endif
 	return iwl_is_channel_extension(priv, priv->band,
 			le16_to_cpu(priv->staging_rxon.channel),
 			iwl_ht_conf->extension_chan_offset);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 609a681..fbe1776 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -88,6 +88,7 @@ struct iwl_debugfs {
 #ifdef CONFIG_IWLWIFI_LEDS
 		struct dentry *file_led;
 #endif
+		struct dentry *file_disable_ht40;
 	} dbgfs_data_files;
 	struct dir_rf_files {
 		struct dentry *file_disable_sensitivity;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 748dc31..7707a26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -653,6 +653,49 @@ static ssize_t iwl_dbgfs_thermal_throttling_read(struct file *file,
 	return ret;
 }
 
+static ssize_t iwl_dbgfs_disable_ht40_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int ht40;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &ht40) != 1)
+		return -EFAULT;
+	if (!iwl_is_associated(priv))
+		priv->disable_ht40 = ht40 ? true : false;
+	else {
+		IWL_ERR(priv, "Sta associated with AP - "
+			"Change to 40MHz channel support is not allowed\n");
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t iwl_dbgfs_disable_ht40_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	char buf[100];
+	int pos = 0;
+	const size_t bufsz = sizeof(buf);
+	ssize_t ret;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"11n 40MHz Mode: %s\n",
+			priv->disable_ht40 ? "Disabled" : "Enabled");
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	return ret;
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(nvm);
@@ -667,6 +710,7 @@ DEBUGFS_READ_FILE_OPS(qos);
 DEBUGFS_READ_FILE_OPS(led);
 #endif
 DEBUGFS_READ_FILE_OPS(thermal_throttling);
+DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
 
 /*
  * Create the debugfs files and directories
@@ -708,6 +752,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(led, data);
 #endif
 	DEBUGFS_ADD_FILE(thermal_throttling, data);
+	DEBUGFS_ADD_FILE(disable_ht40, data);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
@@ -747,6 +792,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_led);
 #endif
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_thermal_throttling);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_disable_ht40);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index facbc3d..0ee3ad2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1164,6 +1164,7 @@ struct iwl_priv {
 	/* debugging info */
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
+	bool disable_ht40;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	/* debugfs */
 	struct iwl_debugfs *dbgfs;
-- 
1.5.6.3



