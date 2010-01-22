Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab0AVWXL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:11 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/17] iwlwifi: clean up debugfs code
Date: Fri, 22 Jan 2010 14:22:54 -0800
Message-Id: <1264198978-5915-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

The debugfs code can be made a whole lot more
efficient by using debugfs_remove_recursive(),
the large chunk of variables can completely go
away and by moving two variables we no longer
need to allocate an extra chunk of memory.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h   |   64 +-------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |  239 ++++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    3 +-
 3 files changed, 91 insertions(+), 215 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index aff1dc0..1c7b53d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -67,63 +67,6 @@ do {                                            			\
 			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
 } while (0)
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-struct iwl_debugfs {
-	const char *name;
-	struct dentry *dir_drv;
-	struct dentry *dir_data;
-	struct dentry *dir_debug;
-	struct dentry *dir_rf;
-	struct dir_data_files {
-		struct dentry *file_sram;
-		struct dentry *file_nvm;
-		struct dentry *file_stations;
-		struct dentry *file_log_event;
-		struct dentry *file_channels;
-		struct dentry *file_status;
-		struct dentry *file_interrupt;
-		struct dentry *file_qos;
-		struct dentry *file_thermal_throttling;
-		struct dentry *file_led;
-		struct dentry *file_disable_ht40;
-		struct dentry *file_sleep_level_override;
-		struct dentry *file_current_sleep_command;
-	} dbgfs_data_files;
-	struct dir_rf_files {
-		struct dentry *file_disable_sensitivity;
-		struct dentry *file_disable_chain_noise;
-		struct dentry *file_disable_tx_power;
-	} dbgfs_rf_files;
-	struct dir_debug_files {
-		struct dentry *file_rx_statistics;
-		struct dentry *file_tx_statistics;
-		struct dentry *file_traffic_log;
-		struct dentry *file_rx_queue;
-		struct dentry *file_tx_queue;
-		struct dentry *file_ucode_rx_stats;
-		struct dentry *file_ucode_tx_stats;
-		struct dentry *file_ucode_general_stats;
-		struct dentry *file_sensitivity;
-		struct dentry *file_chain_noise;
-		struct dentry *file_tx_power;
-		struct dentry *file_power_save_status;
-		struct dentry *file_clear_ucode_statistics;
-		struct dentry *file_clear_traffic_statistics;
-		struct dentry *file_csr;
-		struct dentry *file_ucode_tracing;
-		struct dentry *file_fh_reg;
-		struct dentry *file_missed_beacon;
-		struct dentry *file_internal_scan;
-		struct dentry *file_plcp_delta;
-	} dbgfs_debug_files;
-	u32 sram_offset;
-	u32 sram_len;
-};
-
-int iwl_dbgfs_register(struct iwl_priv *priv, const char *name);
-void iwl_dbgfs_unregister(struct iwl_priv *priv);
-#endif
-
 #else
 #define IWL_DEBUG(__priv, level, fmt, args...)
 #define IWL_DEBUG_LIMIT(__priv, level, fmt, args...)
@@ -132,9 +75,10 @@ static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
 {}
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
-
-
-#ifndef CONFIG_IWLWIFI_DEBUGFS
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+int iwl_dbgfs_register(struct iwl_priv *priv, const char *name);
+void iwl_dbgfs_unregister(struct iwl_priv *priv);
+#else
 static inline int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 {
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 3f9c039..5c8377b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -41,43 +41,28 @@
 #include "iwl-calib.h"
 
 /* create and remove of files */
-#define DEBUGFS_ADD_DIR(name, parent) do {                              \
-	dbgfs->dir_##name = debugfs_create_dir(#name, parent);          \
-	if (!(dbgfs->dir_##name))                                       \
-		goto err; 						\
+#define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
+	if (!debugfs_create_file(#name, mode, parent, priv,		\
+				 &iwl_dbgfs_##name##_ops))		\
+		goto err;						\
 } while (0)
 
-#define DEBUGFS_ADD_FILE(name, parent, mode) do {                       \
-	dbgfs->dbgfs_##parent##_files.file_##name =                     \
-	debugfs_create_file(#name, mode,                                \
-				dbgfs->dir_##parent, priv,              \
-				&iwl_dbgfs_##name##_ops);               \
-	if (!(dbgfs->dbgfs_##parent##_files.file_##name))               \
-		goto err;                                               \
+#define DEBUGFS_ADD_BOOL(name, parent, ptr) do {			\
+	struct dentry *__tmp;						\
+	__tmp = debugfs_create_bool(#name, S_IWUSR | S_IRUSR,		\
+				    parent, ptr);			\
+	if (IS_ERR(__tmp) || !__tmp)					\
+		goto err;						\
 } while (0)
 
-#define DEBUGFS_ADD_BOOL(name, parent, ptr) do {                        \
-	dbgfs->dbgfs_##parent##_files.file_##name =                     \
-	debugfs_create_bool(#name, S_IWUSR | S_IRUSR,                   \
-			    dbgfs->dir_##parent, ptr);                  \
-	if (IS_ERR(dbgfs->dbgfs_##parent##_files.file_##name)		\
-			|| !dbgfs->dbgfs_##parent##_files.file_##name)	\
-		goto err;                                               \
+#define DEBUGFS_ADD_X32(name, parent, ptr) do {				\
+	struct dentry *__tmp;						\
+	__tmp = debugfs_create_x32(#name, S_IWUSR | S_IRUSR,		\
+				   parent, ptr);			\
+	if (IS_ERR(__tmp) || !__tmp)					\
+		goto err;						\
 } while (0)
 
-#define DEBUGFS_ADD_X32(name, parent, ptr) do {                        \
-	dbgfs->dbgfs_##parent##_files.file_##name =                     \
-	debugfs_create_x32(#name, S_IRUSR, dbgfs->dir_##parent, ptr);   \
-	if (IS_ERR(dbgfs->dbgfs_##parent##_files.file_##name)		\
-			|| !dbgfs->dbgfs_##parent##_files.file_##name)	\
-		goto err;                                               \
-} while (0)
-
-#define DEBUGFS_REMOVE(name)  do {              \
-	debugfs_remove(name);                   \
-	name = NULL;                            \
-} while (0);
-
 /* file operation */
 #define DEBUGFS_READ_FUNC(name)                                         \
 static ssize_t iwl_dbgfs_##name##_read(struct file *file,               \
@@ -236,24 +221,24 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	size_t bufsz;
 
 	/* default is to dump the entire data segment */
-	if (!priv->dbgfs->sram_offset && !priv->dbgfs->sram_len) {
-		priv->dbgfs->sram_offset = 0x800000;
+	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
+		priv->dbgfs_sram_offset = 0x800000;
 		if (priv->ucode_type == UCODE_INIT)
-			priv->dbgfs->sram_len = priv->ucode_init_data.len;
+			priv->dbgfs_sram_len = priv->ucode_init_data.len;
 		else
-			priv->dbgfs->sram_len = priv->ucode_data.len;
+			priv->dbgfs_sram_len = priv->ucode_data.len;
 	}
-	bufsz =  30 + priv->dbgfs->sram_len * sizeof(char) * 10;
+	bufsz =  30 + priv->dbgfs_sram_len * sizeof(char) * 10;
 	buf = kmalloc(bufsz, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 	pos += scnprintf(buf + pos, bufsz - pos, "sram_len: 0x%x\n",
-			priv->dbgfs->sram_len);
+			priv->dbgfs_sram_len);
 	pos += scnprintf(buf + pos, bufsz - pos, "sram_offset: 0x%x\n",
-			priv->dbgfs->sram_offset);
-	for (i = priv->dbgfs->sram_len; i > 0; i -= 4) {
-		val = iwl_read_targ_mem(priv, priv->dbgfs->sram_offset + \
-					priv->dbgfs->sram_len - i);
+			priv->dbgfs_sram_offset);
+	for (i = priv->dbgfs_sram_len; i > 0; i -= 4) {
+		val = iwl_read_targ_mem(priv, priv->dbgfs_sram_offset + \
+					priv->dbgfs_sram_len - i);
 		if (i < 4) {
 			switch (i) {
 			case 1:
@@ -293,11 +278,11 @@ static ssize_t iwl_dbgfs_sram_write(struct file *file,
 		return -EFAULT;
 
 	if (sscanf(buf, "%x,%x", &offset, &len) == 2) {
-		priv->dbgfs->sram_offset = offset;
-		priv->dbgfs->sram_len = len;
+		priv->dbgfs_sram_offset = offset;
+		priv->dbgfs_sram_len = len;
 	} else {
-		priv->dbgfs->sram_offset = 0;
-		priv->dbgfs->sram_len = 0;
+		priv->dbgfs_sram_offset = 0;
+		priv->dbgfs_sram_len = 0;
 	}
 
 	return count;
@@ -2263,75 +2248,73 @@ DEBUGFS_READ_WRITE_FILE_OPS(plcp_delta);
  */
 int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 {
-	struct iwl_debugfs *dbgfs;
 	struct dentry *phyd = priv->hw->wiphy->debugfsdir;
-	int ret = 0;
+	struct dentry *dir_drv, *dir_data, *dir_rf, *dir_debug;
 
-	dbgfs = kzalloc(sizeof(struct iwl_debugfs), GFP_KERNEL);
-	if (!dbgfs) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	dir_drv = debugfs_create_dir(name, phyd);
+	if (!dir_drv)
+		return -ENOMEM;
 
-	priv->dbgfs = dbgfs;
-	dbgfs->name = name;
-	dbgfs->dir_drv = debugfs_create_dir(name, phyd);
-	if (!dbgfs->dir_drv || IS_ERR(dbgfs->dir_drv)) {
-		ret = -ENOENT;
+	priv->debugfs_dir = dir_drv;
+
+	dir_data = debugfs_create_dir("data", dir_drv);
+	if (!dir_data)
+		goto err;
+	dir_rf = debugfs_create_dir("rf", dir_drv);
+	if (!dir_rf)
+		goto err;
+	dir_debug = debugfs_create_dir("debug", dir_drv);
+	if (!dir_debug)
 		goto err;
-	}
 
-	DEBUGFS_ADD_DIR(data, dbgfs->dir_drv);
-	DEBUGFS_ADD_DIR(rf, dbgfs->dir_drv);
-	DEBUGFS_ADD_DIR(debug, dbgfs->dir_drv);
-	DEBUGFS_ADD_FILE(nvm, data, S_IRUSR);
-	DEBUGFS_ADD_FILE(sram, data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(log_event, data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(stations, data, S_IRUSR);
-	DEBUGFS_ADD_FILE(channels, data, S_IRUSR);
-	DEBUGFS_ADD_FILE(status, data, S_IRUSR);
-	DEBUGFS_ADD_FILE(interrupt, data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(qos, data, S_IRUSR);
-	DEBUGFS_ADD_FILE(led, data, S_IRUSR);
-	DEBUGFS_ADD_FILE(sleep_level_override, data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(current_sleep_command, data, S_IRUSR);
-	DEBUGFS_ADD_FILE(thermal_throttling, data, S_IRUSR);
-	DEBUGFS_ADD_FILE(disable_ht40, data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(rx_statistics, debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(tx_statistics, debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(traffic_log, debug, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(rx_queue, debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(tx_queue, debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(tx_power, debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(power_save_status, debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(clear_ucode_statistics, debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(clear_traffic_statistics, debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(csr, debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(fh_reg, debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(missed_beacon, debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(internal_scan, debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(plcp_delta, debug, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(nvm, dir_data, S_IRUSR);
+	DEBUGFS_ADD_FILE(sram, dir_data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(log_event, dir_data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(stations, dir_data, S_IRUSR);
+	DEBUGFS_ADD_FILE(channels, dir_data, S_IRUSR);
+	DEBUGFS_ADD_FILE(status, dir_data, S_IRUSR);
+	DEBUGFS_ADD_FILE(interrupt, dir_data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(qos, dir_data, S_IRUSR);
+	DEBUGFS_ADD_FILE(led, dir_data, S_IRUSR);
+	DEBUGFS_ADD_FILE(sleep_level_override, dir_data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(current_sleep_command, dir_data, S_IRUSR);
+	DEBUGFS_ADD_FILE(thermal_throttling, dir_data, S_IRUSR);
+	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(rx_statistics, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(tx_statistics, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(traffic_log, dir_debug, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(rx_queue, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(tx_queue, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(tx_power, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(power_save_status, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(clear_ucode_statistics, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(clear_traffic_statistics, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(csr, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(fh_reg, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(internal_scan, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(plcp_delta, dir_debug, S_IWUSR | S_IRUSR);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
-		DEBUGFS_ADD_FILE(ucode_rx_stats, debug, S_IRUSR);
-		DEBUGFS_ADD_FILE(ucode_tx_stats, debug, S_IRUSR);
-		DEBUGFS_ADD_FILE(ucode_general_stats, debug, S_IRUSR);
-		DEBUGFS_ADD_FILE(sensitivity, debug, S_IRUSR);
-		DEBUGFS_ADD_FILE(chain_noise, debug, S_IRUSR);
-		DEBUGFS_ADD_FILE(ucode_tracing, debug, S_IWUSR | S_IRUSR);
+		DEBUGFS_ADD_FILE(ucode_rx_stats, dir_debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
 	}
-	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
-	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
+	DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf, &priv->disable_sens_cal);
+	DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
 			 &priv->disable_chain_noise_cal);
 	if (((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965) ||
 	    ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_3945))
-		DEBUGFS_ADD_BOOL(disable_tx_power, rf,
+		DEBUGFS_ADD_BOOL(disable_tx_power, dir_rf,
 				&priv->disable_tx_power_cal);
 	return 0;
 
 err:
-	IWL_ERR(priv, "Can't open the debugfs directory\n");
+	IWL_ERR(priv, "Can't create the debugfs directory\n");
 	iwl_dbgfs_unregister(priv);
-	return ret;
+	return -ENOMEM;
 }
 EXPORT_SYMBOL(iwl_dbgfs_register);
 
@@ -2341,63 +2324,11 @@ EXPORT_SYMBOL(iwl_dbgfs_register);
  */
 void iwl_dbgfs_unregister(struct iwl_priv *priv)
 {
-	if (!priv->dbgfs)
+	if (!priv->debugfs_dir)
 		return;
 
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_sleep_level_override);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_current_sleep_command);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_nvm);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_sram);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_log_event);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_stations);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_channels);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_status);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_interrupt);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_qos);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_led);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_thermal_throttling);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_disable_ht40);
-	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_rx_statistics);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_statistics);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_traffic_log);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_rx_queue);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_queue);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_power);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_power_save_status);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
-			file_clear_ucode_statistics);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
-			file_clear_traffic_statistics);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_csr);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_fh_reg);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_missed_beacon);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_internal_scan);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_plcp_delta);
-	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
-		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
-			file_ucode_rx_stats);
-		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
-			file_ucode_tx_stats);
-		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
-			file_ucode_general_stats);
-		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
-			file_sensitivity);
-		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
-			file_chain_noise);
-		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
-			file_ucode_tracing);
-	}
-	DEBUGFS_REMOVE(priv->dbgfs->dir_debug);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
-	if (((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965) ||
-	    ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_3945))
-		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_tx_power);
-	DEBUGFS_REMOVE(priv->dbgfs->dir_rf);
-	DEBUGFS_REMOVE(priv->dbgfs->dir_drv);
-	kfree(priv->dbgfs);
-	priv->dbgfs = NULL;
+	debugfs_remove_recursive(priv->debugfs_dir);
+	priv->debugfs_dir = NULL;
 }
 EXPORT_SYMBOL(iwl_dbgfs_unregister);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a1f3ecb..d9f325b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1309,7 +1309,8 @@ struct iwl_priv {
 	u16 rx_traffic_idx;
 	u8 *tx_traffic;
 	u8 *rx_traffic;
-	struct iwl_debugfs *dbgfs;
+	struct dentry *debugfs_dir;
+	u32 dbgfs_sram_offset, dbgfs_sram_len;
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
-- 
1.6.3.3

