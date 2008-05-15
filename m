Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9394 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbYEOF4h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:37 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/26] iwlwifi: add debugfs to disable/enable run time calibration
Date: Thu, 15 May 2008 13:54:16 +0800
Message-Id: <1210830858-3410-25-git-send-email-yi.zhu@intel.com> (sfid-20080515_081614_898108_987504B8)
In-Reply-To: <1210830858-3410-24-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-5-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-7-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-8-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-9-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-10-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-11-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-12-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-13-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-14-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-15-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-16-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-17-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-18-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-19-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-20-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-21-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-22-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-23-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-24-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds functionality to debugfs to enable or disable chain
noise or sensitivity calibrations.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-calib.c   |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-calib.h   |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    9 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   20 +++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    6 +++++-
 5 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 1289d4c..beb9716 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -426,6 +426,9 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	struct iwl_sensitivity_data *data = NULL;
 	const struct iwl_sensitivity_ranges *ranges = priv->hw_params.sens;
 
+	if (priv->disable_sens_cal)
+		return;
+
 	IWL_DEBUG_CALIB("Start iwl_init_sensitivity\n");
 
 	/* Clear driver's sensitivity algo data */
@@ -486,6 +489,9 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv,
 	unsigned long flags;
 	struct statistics_general_data statis;
 
+	if (priv->disable_sens_cal)
+		return;
+
 	data = &(priv->sensitivity_data);
 
 	if (!iwl_is_associated(priv)) {
@@ -608,6 +614,9 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 	unsigned long flags;
 	struct statistics_rx_non_phy *rx_info = &(stat_resp->rx.general);
 
+	if (priv->disable_chain_noise_cal)
+		return;
+
 	data = &(priv->chain_noise_data);
 
 	/* Accumulate just the first 20 beacons after the first association,
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.h b/drivers/net/wireless/iwlwifi/iwl-calib.h
index 933b0b0..e690668 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.h
@@ -81,7 +81,9 @@ void iwl_init_sensitivity(struct iwl_priv *priv);
 
 static inline void iwl_chain_noise_reset(struct iwl_priv *priv)
 {
-	if (priv->cfg->ops->utils->chain_noise_reset)
+
+	if (!priv->disable_chain_noise_cal &&
+	    priv->cfg->ops->utils->chain_noise_reset)
 		priv->cfg->ops->utils->chain_noise_reset(priv);
 }
 #else
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 2f24594..c3f8e90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -45,13 +45,20 @@ struct iwl_debugfs {
 	const char *name;
 	struct dentry *dir_drv;
 	struct dentry *dir_data;
-	struct dir_data_files{
+	struct dentry *dir_rf;
+	struct dir_data_files {
 		struct dentry *file_sram;
 		struct dentry *file_eeprom;
 		struct dentry *file_stations;
 		struct dentry *file_rx_statistics;
 		struct dentry *file_tx_statistics;
 	} dbgfs_data_files;
+	struct dir_rf_files {
+#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
+		struct dentry *file_disable_sensitivity;
+		struct dentry *file_disable_chain_noise;
+#endif /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
+	} dbgfs_rf_files;
 	u32 sram_offset;
 	u32 sram_len;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ad25806..f7ec200 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -55,6 +55,13 @@
 		goto err;                                               \
 } while (0)
 
+#define DEBUGFS_ADD_BOOL(name, parent, ptr) do {                        \
+	dbgfs->dbgfs_##parent##_files.file_##name =                     \
+	debugfs_create_bool(#name, 0644, dbgfs->dir_##parent, ptr);     \
+	if (IS_ERR(dbgfs->dbgfs_##parent##_files.file_##name))          \
+		goto err;                                               \
+} while (0)
+
 #define DEBUGFS_REMOVE(name)  do {              \
 	debugfs_remove(name);                   \
 	name = NULL;                            \
@@ -344,12 +351,17 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	}
 
 	DEBUGFS_ADD_DIR(data, dbgfs->dir_drv);
+	DEBUGFS_ADD_DIR(rf, dbgfs->dir_drv);
 	DEBUGFS_ADD_FILE(eeprom, data);
 	DEBUGFS_ADD_FILE(sram, data);
 	DEBUGFS_ADD_FILE(stations, data);
 	DEBUGFS_ADD_FILE(rx_statistics, data);
 	DEBUGFS_ADD_FILE(tx_statistics, data);
-
+#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
+	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
+	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
+			 &priv->disable_chain_noise_cal);
+#endif  /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
 	return 0;
 
 err:
@@ -374,6 +386,11 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_sram);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_stations);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
+#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
+#endif /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
+	DEBUGFS_REMOVE(priv->dbgfs->dir_rf);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_drv);
 	kfree(priv->dbgfs);
 	priv->dbgfs = NULL;
@@ -381,3 +398,4 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 EXPORT_SYMBOL(iwl_dbgfs_unregister);
 
 
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b1ff0af..820542b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1212,9 +1212,13 @@ struct iwl_priv {
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
 	struct work_struct txpower_work;
+#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
+	u32 disable_sens_cal;
+	u32 disable_chain_noise_cal;
+#endif /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
 #ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 	struct work_struct sensitivity_work;
-#endif
+#endif /* CONFIG_IWL4965_RUN_TIME_CALIB */
 	struct timer_list statistics_periodic;
 }; /*iwl_priv */
 
-- 
1.5.3.6

