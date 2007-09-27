Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48006 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbXI0DfE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:35:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: add debugfs rate scale stats
Date: Thu, 27 Sep 2007 11:27:43 +0800
Message-Id: <11908636833477-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636823439-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
 <11908636692415-git-send-email-yi.zhu@intel.com>
 <119086367088-git-send-email-yi.zhu@intel.com>
 <11908636712746-git-send-email-yi.zhu@intel.com>
 <11908636732679-git-send-email-yi.zhu@intel.com>
 <11908636743625-git-send-email-yi.zhu@intel.com>
 <11908636753775-git-send-email-yi.zhu@intel.com>
 <11908636772860-git-send-email-yi.zhu@intel.com>
 <11908636781043-git-send-email-yi.zhu@intel.com>
 <1190863679136-git-send-email-yi.zhu@intel.com>
 <11908636801368-git-send-email-yi.zhu@intel.com>
 <11908636823439-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds rates scale statistics to debugfs:
$ cat /sys/kernel/debug/ieee80211/phy<X>/stations/<mac>/rate_stats_table

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   40 +++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index e5f8cce..287c757 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -124,6 +124,7 @@ struct iwl_rate_scale_priv {
 	struct iwl_scale_tbl_info lq_info[LQ_SIZE];
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *rs_sta_dbgfs_scale_table_file;
+	struct dentry *rs_sta_dbgfs_stats_table_file;
 	struct iwl_rate dbg_fixed;
 	struct iwl_priv *drv;
 #endif
@@ -2068,6 +2069,7 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 
 	return count;
 }
+
 static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
 {
@@ -2116,20 +2118,56 @@ static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.read = rs_sta_dbgfs_scale_table_read,
 	.open = open_file_generic,
 };
+static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
+			char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buff[1024];
+	int desc = 0;
+	int i, j;
+
+	struct iwl_rate_scale_priv *rs_priv = file->private_data;
+	for (i = 0; i < LQ_SIZE; i++) {
+		desc += sprintf(buff+desc, "%s type=%d SGI=%d FAT=%d DUP=%d\n"
+				"rate=0x%X\n",
+				rs_priv->active_tbl == i?"*":"x",
+				rs_priv->lq_info[i].lq_type,
+				rs_priv->lq_info[i].is_SGI,
+				rs_priv->lq_info[i].is_fat,
+				rs_priv->lq_info[i].is_dup,
+				rs_priv->lq_info[i].current_rate.rate_n_flags);
+		for (j = 0; j < IWL_RATE_COUNT; j++) {
+			desc += sprintf(buff+desc,
+					"counter=%d success=%d %%=%d\n",
+					rs_priv->lq_info[i].win[j].counter,
+					rs_priv->lq_info[i].win[j].success_counter,
+					rs_priv->lq_info[i].win[j].success_ratio);
+		}
+	}
+	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+}
+
+static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
+	.read = rs_sta_dbgfs_stats_table_read,
+	.open = open_file_generic,
+};
 
 static void rs_add_debugfs(void *priv, void *priv_sta,
 					struct dentry *dir)
 {
 	struct iwl_rate_scale_priv *rs_priv = priv_sta;
 	rs_priv->rs_sta_dbgfs_scale_table_file =
-		debugfs_create_file("rate_scale_table", 0444, dir,
+		debugfs_create_file("rate_scale_table", 0600, dir,
 				rs_priv, &rs_sta_dbgfs_scale_table_ops);
+	rs_priv->rs_sta_dbgfs_stats_table_file =
+		debugfs_create_file("rate_stats_table", 0600, dir,
+			rs_priv, &rs_sta_dbgfs_stats_table_ops);
 }
 
 static void rs_remove_debugfs(void *priv, void *priv_sta)
 {
 	struct iwl_rate_scale_priv *rs_priv = priv_sta;
 	debugfs_remove(rs_priv->rs_sta_dbgfs_scale_table_file);
+	debugfs_remove(rs_priv->rs_sta_dbgfs_stats_table_file);
 }
 #endif
 
-- 
1.5.1
