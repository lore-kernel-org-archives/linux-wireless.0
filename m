Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbXI0De4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:34:56 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: add read rate scale table debugfs function
Date: Thu, 27 Sep 2007 11:27:38 +0800
Message-Id: <11908636772860-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636753775-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
 <11908636692415-git-send-email-yi.zhu@intel.com>
 <119086367088-git-send-email-yi.zhu@intel.com>
 <11908636712746-git-send-email-yi.zhu@intel.com>
 <11908636732679-git-send-email-yi.zhu@intel.com>
 <11908636743625-git-send-email-yi.zhu@intel.com>
 <11908636753775-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds read rate scale table debugfs function for 4965
rate scaling module.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   67 +++++++++++++++++++++++++---
 1 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index e849ab5..e3a0cca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -121,6 +121,9 @@ struct iwl_rate_scale_priv {
 	u16 active_rate_basic;
 	struct iwl_link_quality_cmd lq;
 	struct iwl_scale_tbl_info lq_info[LQ_SIZE];
+#ifdef CONFIG_MAC80211_DEBUGFS
+       struct dentry *rs_sta_dbgfs_scale_table_file;
+#endif
 };
 
 static void rs_rate_scale_perform(struct iwl_priv *priv,
@@ -2000,19 +2003,71 @@ static void rs_free_sta(void *priv, void *priv_sta)
 
 
 #ifdef CONFIG_MAC80211_DEBUGFS
+static int open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
+			char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buff[1024];
+	int desc = 0;
+	int i = 0;
+
+	struct iwl_rate_scale_priv *rs_priv = file->private_data;
+
+	desc += sprintf(buff+desc, "sta_id %d\n", rs_priv->lq.sta_id);
+	desc += sprintf(buff+desc, "failed=%d success=%d rate=%X\n",
+			rs_priv->total_failed, rs_priv->total_success,
+			rs_priv->active_rate);
+	desc += sprintf(buff+desc, "general:"
+		"flags=0x%X mimo-d=%d s-ant0x%x d-ant=0x%x\n",
+		rs_priv->lq.general_params.flags,
+		rs_priv->lq.general_params.mimo_delimiter,
+		rs_priv->lq.general_params.single_stream_ant_msk,
+		rs_priv->lq.general_params.dual_stream_ant_msk);
+
+	desc += sprintf(buff+desc, "agg:"
+			"time_limit=%d dist_start_th=%d frame_cnt_limit=%d\n",
+			le16_to_cpu(rs_priv->lq.agg_params.agg_time_limit),
+			rs_priv->lq.agg_params.agg_dis_start_th,
+			rs_priv->lq.agg_params.agg_frame_cnt_limit);
+
+	desc += sprintf(buff+desc,
+			"Start idx [0]=0x%x [1]=0x%x [2]=0x%x [3]=0x%x\n",
+			rs_priv->lq.general_params.start_rate_index[0],
+			rs_priv->lq.general_params.start_rate_index[1],
+			rs_priv->lq.general_params.start_rate_index[2],
+			rs_priv->lq.general_params.start_rate_index[3]);
+
+
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
+		desc += sprintf(buff+desc, " rate[%d] 0x%X\n",
+			i, le32_to_cpu(rs_priv->lq.rs_table[i].rate_n_flags));
+
+	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+}
+
+static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
+	.read = rs_sta_dbgfs_scale_table_read,
+	.open = open_file_generic,
+};
+
 static void rs_add_debugfs(void *priv, void *priv_sta,
 					struct dentry *dir)
 {
-	/* struct iwl_rate_scale_priv *rs_priv = priv_sta; */
-	IWL_DEBUG_RATE("%s enter\n", __FUNCTION__);
-	IWL_DEBUG_RATE("%s leave\n", __FUNCTION__);
+	struct iwl_rate_scale_priv *rs_priv = priv_sta;
+	rs_priv->rs_sta_dbgfs_scale_table_file =
+		debugfs_create_file("rate_scale_table", 0444, dir,
+				rs_priv, &rs_sta_dbgfs_scale_table_ops);
 }
 
 static void rs_remove_debugfs(void *priv, void *priv_sta)
 {
-	/* struct iwl_rate_scale_priv *rs_priv = priv_sta; */
-	IWL_DEBUG_RATE("%s enter\n", __FUNCTION__);
-	IWL_DEBUG_RATE("%s leave\n", __FUNCTION__);
+	struct iwl_rate_scale_priv *rs_priv = priv_sta;
+	debugfs_remove(rs_priv->rs_sta_dbgfs_scale_table_file);
 }
 #endif
 
-- 
1.5.1
