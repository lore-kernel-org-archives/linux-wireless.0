Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3HPLHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 08/20] iwlwifi: mvm: remove rate_scale_data debugfs entry
Date: Fri, 16 Aug 2013 13:06:58 +0200
Message-Id: <1376651230-1060-8-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130733_714166_B637D231)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

This isn't very informative and can be deduced from rate_scale_table.
Remove as a preparation for dropping iwl_rs_rate_info.ieee.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 30 ------------------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |  1 -
 2 files changed, 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index d680c89..199f0cf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -3009,32 +3009,6 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.llseek = default_llseek,
 };
 
-static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
-			char __user *user_buf, size_t count, loff_t *ppos)
-{
-	struct iwl_lq_sta *lq_sta = file->private_data;
-	struct iwl_scale_tbl_info *tbl = &lq_sta->lq_info[lq_sta->active_tbl];
-	char buff[120];
-	int desc = 0;
-
-	if (is_Ht(tbl->lq_type))
-		desc += sprintf(buff+desc,
-				"Bit Rate= %d Mb/s\n",
-				tbl->expected_tpt[lq_sta->last_txrate_idx]);
-	else
-		desc += sprintf(buff+desc,
-				"Bit Rate= %d Mb/s\n",
-				iwl_rates[lq_sta->last_txrate_idx].ieee >> 1);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
-}
-
-static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
-	.read = rs_sta_dbgfs_rate_scale_data_read,
-	.open = simple_open,
-	.llseek = default_llseek,
-};
-
 static void rs_add_debugfs(void *mvm, void *mvm_sta, struct dentry *dir)
 {
 	struct iwl_lq_sta *lq_sta = mvm_sta;
@@ -3044,9 +3018,6 @@ static void rs_add_debugfs(void *mvm, void *mvm_sta, struct dentry *dir)
 	lq_sta->rs_sta_dbgfs_stats_table_file =
 		debugfs_create_file("rate_stats_table", S_IRUSR, dir,
 				    lq_sta, &rs_sta_dbgfs_stats_table_ops);
-	lq_sta->rs_sta_dbgfs_rate_scale_data_file =
-		debugfs_create_file("rate_scale_data", S_IRUSR, dir,
-				    lq_sta, &rs_sta_dbgfs_rate_scale_data_ops);
 	lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file =
 		debugfs_create_u8("tx_agg_tid_enable", S_IRUSR | S_IWUSR, dir,
 				  &lq_sta->tx_agg_tid_en);
@@ -3057,7 +3028,6 @@ static void rs_remove_debugfs(void *mvm, void *mvm_sta)
 	struct iwl_lq_sta *lq_sta = mvm_sta;
 	debugfs_remove(lq_sta->rs_sta_dbgfs_scale_table_file);
 	debugfs_remove(lq_sta->rs_sta_dbgfs_stats_table_file);
-	debugfs_remove(lq_sta->rs_sta_dbgfs_rate_scale_data_file);
 	debugfs_remove(lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file);
 }
 #endif
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 4a99a4d..917a48f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -330,7 +330,6 @@ struct iwl_lq_sta {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *rs_sta_dbgfs_scale_table_file;
 	struct dentry *rs_sta_dbgfs_stats_table_file;
-	struct dentry *rs_sta_dbgfs_rate_scale_data_file;
 	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
 	u32 dbg_fixed_rate;
 #endif
-- 
1.8.4.rc2

