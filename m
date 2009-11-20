Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21734 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbZKTUFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/19] iwlwifi: set read/write permission for debugfs files
Date: Fri, 20 Nov 2009 12:04:58 -0800
Message-Id: <1258747510-21233-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Set the correct Read/Write file permission for iwlwifi debugfs files
based on the functionality of the files

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   58 ++++++++++++++--------------
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 2f09e3b..fe511cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2964,16 +2964,16 @@ static void rs_add_debugfs(void *priv, void *priv_sta,
 {
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	lq_sta->rs_sta_dbgfs_scale_table_file =
-		debugfs_create_file("rate_scale_table", 0600, dir,
+		debugfs_create_file("rate_scale_table", S_IRUSR | S_IWUSR, dir,
 				lq_sta, &rs_sta_dbgfs_scale_table_ops);
 	lq_sta->rs_sta_dbgfs_stats_table_file =
-		debugfs_create_file("rate_stats_table", 0600, dir,
+		debugfs_create_file("rate_stats_table", S_IRUSR, dir,
 			lq_sta, &rs_sta_dbgfs_stats_table_ops);
 	lq_sta->rs_sta_dbgfs_rate_scale_data_file =
-		debugfs_create_file("rate_scale_data", 0600, dir,
+		debugfs_create_file("rate_scale_data", S_IRUSR, dir,
 			lq_sta, &rs_sta_dbgfs_rate_scale_data_ops);
 	lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file =
-		debugfs_create_u8("tx_agg_tid_enable", 0600, dir,
+		debugfs_create_u8("tx_agg_tid_enable", S_IRUSR | S_IWUSR, dir,
 		&lq_sta->tx_agg_tid_en);
 
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index b8f9edc..e6194c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -47,9 +47,9 @@
 		goto err; 						\
 } while (0)
 
-#define DEBUGFS_ADD_FILE(name, parent) do {                             \
+#define DEBUGFS_ADD_FILE(name, parent, mode) do {                       \
 	dbgfs->dbgfs_##parent##_files.file_##name =                     \
-	debugfs_create_file(#name, S_IWUSR | S_IRUSR,                   \
+	debugfs_create_file(#name, mode,                                \
 				dbgfs->dir_##parent, priv,              \
 				&iwl_dbgfs_##name##_ops);               \
 	if (!(dbgfs->dbgfs_##parent##_files.file_##name))               \
@@ -1868,34 +1868,34 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_DIR(data, dbgfs->dir_drv);
 	DEBUGFS_ADD_DIR(rf, dbgfs->dir_drv);
 	DEBUGFS_ADD_DIR(debug, dbgfs->dir_drv);
-	DEBUGFS_ADD_FILE(nvm, data);
-	DEBUGFS_ADD_FILE(sram, data);
-	DEBUGFS_ADD_FILE(log_event, data);
-	DEBUGFS_ADD_FILE(stations, data);
-	DEBUGFS_ADD_FILE(channels, data);
-	DEBUGFS_ADD_FILE(status, data);
-	DEBUGFS_ADD_FILE(interrupt, data);
-	DEBUGFS_ADD_FILE(qos, data);
-	DEBUGFS_ADD_FILE(led, data);
-	DEBUGFS_ADD_FILE(sleep_level_override, data);
-	DEBUGFS_ADD_FILE(current_sleep_command, data);
-	DEBUGFS_ADD_FILE(thermal_throttling, data);
-	DEBUGFS_ADD_FILE(disable_ht40, data);
-	DEBUGFS_ADD_FILE(rx_statistics, debug);
-	DEBUGFS_ADD_FILE(tx_statistics, debug);
-	DEBUGFS_ADD_FILE(traffic_log, debug);
-	DEBUGFS_ADD_FILE(rx_queue, debug);
-	DEBUGFS_ADD_FILE(tx_queue, debug);
-	DEBUGFS_ADD_FILE(tx_power, debug);
-	DEBUGFS_ADD_FILE(power_save_status, debug);
-	DEBUGFS_ADD_FILE(clear_ucode_statistics, debug);
-	DEBUGFS_ADD_FILE(clear_traffic_statistics, debug);
+	DEBUGFS_ADD_FILE(nvm, data, S_IRUSR);
+	DEBUGFS_ADD_FILE(sram, data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(log_event, data, S_IWUSR);
+	DEBUGFS_ADD_FILE(stations, data, S_IRUSR);
+	DEBUGFS_ADD_FILE(channels, data, S_IRUSR);
+	DEBUGFS_ADD_FILE(status, data, S_IRUSR);
+	DEBUGFS_ADD_FILE(interrupt, data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(qos, data, S_IRUSR);
+	DEBUGFS_ADD_FILE(led, data, S_IRUSR);
+	DEBUGFS_ADD_FILE(sleep_level_override, data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(current_sleep_command, data, S_IRUSR);
+	DEBUGFS_ADD_FILE(thermal_throttling, data, S_IRUSR);
+	DEBUGFS_ADD_FILE(disable_ht40, data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(rx_statistics, debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(tx_statistics, debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(traffic_log, debug, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(rx_queue, debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(tx_queue, debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(tx_power, debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(power_save_status, debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(clear_ucode_statistics, debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(clear_traffic_statistics, debug, S_IWUSR);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
-		DEBUGFS_ADD_FILE(ucode_rx_stats, debug);
-		DEBUGFS_ADD_FILE(ucode_tx_stats, debug);
-		DEBUGFS_ADD_FILE(ucode_general_stats, debug);
-		DEBUGFS_ADD_FILE(sensitivity, debug);
-		DEBUGFS_ADD_FILE(chain_noise, debug);
+		DEBUGFS_ADD_FILE(ucode_rx_stats, debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(ucode_tx_stats, debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(ucode_general_stats, debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(sensitivity, debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(chain_noise, debug, S_IRUSR);
 	}
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
-- 
1.5.6.3

