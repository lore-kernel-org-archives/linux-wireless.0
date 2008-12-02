Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYLBUNO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/11] iwl3945: add debugfs support
Date: Tue,  2 Dec 2008 12:14:02 -0800
Message-Id: <1228248847-10424-7-git-send-email-reinette.chatre@intel.com> (sfid-20081202_211324_974607_0EC0FFED)
In-Reply-To: <1228248847-10424-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-5-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abbas, Mohamed <mohamed.abbas@intel.com>

Add debugfs support to 3945 driver to display rs info.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   62 ++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index e0ea2fe..e5f4b71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -63,6 +63,9 @@ struct iwl3945_rs_sta {
 	u8 ibss_sta_added;
 	struct timer_list rate_scale_flush;
 	struct iwl3945_rate_scale_data win[IWL_RATE_COUNT];
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct dentry *rs_sta_dbgfs_stats_table_file;
+#endif
 
 	/* used to be in sta_info */
 	int last_txrate_idx;
@@ -773,6 +776,60 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	IWL_DEBUG_RATE("leave: %d\n", index);
 }
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+static int iwl3945_open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t iwl3945_sta_dbgfs_stats_table_read(struct file *file,
+						  char __user *user_buf,
+						  size_t count, loff_t *ppos)
+{
+	char buff[1024];
+	int desc = 0;
+	int j;
+	struct iwl3945_rs_sta *lq_sta = file->private_data;
+
+	desc += sprintf(buff + desc, "tx packets=%d last rate index=%d\n"
+			"rate=0x%X flush time %d\n",
+			lq_sta->tx_packets,
+			lq_sta->last_txrate_idx,
+			lq_sta->start_rate, jiffies_to_msecs(lq_sta->flush_time));
+	for (j = 0; j < IWL_RATE_COUNT; j++) {
+		desc += sprintf(buff+desc,
+				"counter=%d success=%d %%=%d\n",
+				lq_sta->win[j].counter,
+				lq_sta->win[j].success_counter,
+				lq_sta->win[j].success_ratio);
+	}
+	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+}
+
+static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
+	.read = iwl3945_sta_dbgfs_stats_table_read,
+	.open = iwl3945_open_file_generic,
+};
+
+static void iwl3945_add_debugfs(void *priv, void *priv_sta,
+				struct dentry *dir)
+{
+	struct iwl3945_rs_sta *lq_sta = priv_sta;
+
+	lq_sta->rs_sta_dbgfs_stats_table_file =
+		debugfs_create_file("rate_stats_table", 0600, dir,
+		lq_sta, &rs_sta_dbgfs_stats_table_ops);
+
+}
+
+static void iwl3945_remove_debugfs(void *priv, void *priv_sta)
+{
+	struct iwl3945_rs_sta *lq_sta = priv_sta;
+	debugfs_remove(lq_sta->rs_sta_dbgfs_stats_table_file);
+}
+#endif
+
 static struct rate_control_ops rs_ops = {
 	.module = NULL,
 	.name = RS_NAME,
@@ -783,6 +840,11 @@ static struct rate_control_ops rs_ops = {
 	.free = rs_free,
 	.alloc_sta = rs_alloc_sta,
 	.free_sta = rs_free_sta,
+#ifdef CONFIG_MAC80211_DEBUGFS
+	.add_sta_debugfs = iwl3945_add_debugfs,
+	.remove_sta_debugfs = iwl3945_remove_debugfs,
+#endif
+
 };
 
 void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
-- 
1.5.4.3

