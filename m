Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20126 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060AbZEHUiZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/11] iwlagn: show current rate scale data in debugfs
Date: Fri,  8 May 2009 13:44:43 -0700
Message-Id: <1241815486-13510-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241815486-13510-8-git-send-email-reinette.chatre@intel.com>
References: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-3-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-4-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-5-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-6-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-7-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add "rate_scale_data" debugfs file to show current bit rate (HT and Legacy),
plus additional information (rssi, noise, tsf, beacon time stamp).

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   42 +++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 3fa06af..4c88e87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -161,6 +161,7 @@ struct iwl_lq_sta {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *rs_sta_dbgfs_scale_table_file;
 	struct dentry *rs_sta_dbgfs_stats_table_file;
+	struct dentry *rs_sta_dbgfs_rate_scale_data_file;
 	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
 	u32 dbg_fixed_rate;
 #endif
@@ -2984,6 +2985,43 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.open = open_file_generic,
 };
 
+static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
+			char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buff[120];
+	int desc = 0;
+	ssize_t ret;
+
+	struct iwl_lq_sta *lq_sta = file->private_data;
+	struct iwl_priv *priv;
+	struct iwl_scale_tbl_info *tbl = &lq_sta->lq_info[lq_sta->active_tbl];
+
+	priv = lq_sta->drv;
+
+	if (is_Ht(tbl->lq_type))
+		desc += sprintf(buff+desc,
+				"Bit Rate= %d Mb/s\n",
+				tbl->expected_tpt[lq_sta->last_txrate_idx]);
+	else
+		desc += sprintf(buff+desc,
+				"Bit Rate= %d Mb/s\n",
+				iwl_rates[lq_sta->last_txrate_idx].ieee >> 1);
+	desc += sprintf(buff+desc,
+			"Signal Level= %d dBm\tNoise Level= %d dBm\n",
+			priv->last_rx_rssi, priv->last_rx_noise);
+	desc += sprintf(buff+desc,
+			"Tsf= 0x%llx\tBeacon time= 0x%08X\n",
+			priv->last_tsf, priv->last_beacon_time);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	return ret;
+}
+
+static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
+	.read = rs_sta_dbgfs_rate_scale_data_read,
+	.open = open_file_generic,
+};
+
 static void rs_add_debugfs(void *priv, void *priv_sta,
 					struct dentry *dir)
 {
@@ -2994,6 +3032,9 @@ static void rs_add_debugfs(void *priv, void *priv_sta,
 	lq_sta->rs_sta_dbgfs_stats_table_file =
 		debugfs_create_file("rate_stats_table", 0600, dir,
 			lq_sta, &rs_sta_dbgfs_stats_table_ops);
+	lq_sta->rs_sta_dbgfs_rate_scale_data_file =
+		debugfs_create_file("rate_scale_data", 0600, dir,
+			lq_sta, &rs_sta_dbgfs_rate_scale_data_ops);
 	lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file =
 		debugfs_create_u8("tx_agg_tid_enable", 0600, dir,
 		&lq_sta->tx_agg_tid_en);
@@ -3005,6 +3046,7 @@ static void rs_remove_debugfs(void *priv, void *priv_sta)
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	debugfs_remove(lq_sta->rs_sta_dbgfs_scale_table_file);
 	debugfs_remove(lq_sta->rs_sta_dbgfs_stats_table_file);
+	debugfs_remove(lq_sta->rs_sta_dbgfs_rate_scale_data_file);
 	debugfs_remove(lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file);
 }
 #endif
-- 
1.5.6.3

