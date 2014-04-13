Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59940 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbaDMTUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:47 -0400
Received: by mail-wi0-f171.google.com with SMTP id q5so3133960wiv.10
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:46 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/47] iwlwifi: mvm: add per rate tx stats
Date: Sun, 13 Apr 2014 22:19:39 +0300
Message-Id: <1397416802-32403-24-git-send-email-egrumbach@gmail.com> (sfid-20140413_213517_863636_C7FD8F0F)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Collect accumulated stats of tx attempts and successes
per rate and column for debugging purposes.
These stats can be read via debugfs file drv_tx_stats
and can also be reset by writing to this file.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 105 ++++++++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/rs.h |  10 ++++
 2 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 50fd460..7a332cb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -641,7 +641,8 @@ static int _rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
 	return 0;
 }
 
-static int rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
+static int rs_collect_tx_data(struct iwl_lq_sta *lq_sta,
+			      struct iwl_scale_tbl_info *tbl,
 			      int scale_index, int attempts, int successes,
 			      u8 reduced_txp)
 {
@@ -651,6 +652,11 @@ static int rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
 	if (scale_index < 0 || scale_index >= IWL_RATE_COUNT)
 		return -EINVAL;
 
+	if (tbl->column != RS_COLUMN_INVALID) {
+		lq_sta->tx_stats[tbl->column][scale_index].total += attempts;
+		lq_sta->tx_stats[tbl->column][scale_index].success += successes;
+	}
+
 	/* Select window for current tx bit rate */
 	window = &(tbl->win[scale_index]);
 
@@ -1119,7 +1125,7 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 	if (info->flags & IEEE80211_TX_STAT_AMPDU) {
 		ucode_rate = le32_to_cpu(table->rs_table[0]);
 		rs_rate_from_ucode_rate(ucode_rate, info->band, &rate);
-		rs_collect_tx_data(curr_tbl, rate.index,
+		rs_collect_tx_data(lq_sta, curr_tbl, rate.index,
 				   info->status.ampdu_len,
 				   info->status.ampdu_ack_len,
 				   reduced_txp);
@@ -1155,7 +1161,7 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 			else
 				continue;
 
-			rs_collect_tx_data(tmp_tbl, rate.index, 1,
+			rs_collect_tx_data(lq_sta, tmp_tbl, rate.index, 1,
 					   i < retries ? 0 : legacy_success,
 					   reduced_txp);
 		}
@@ -2928,7 +2934,6 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 	size_t buf_size;
 	u32 parsed_rate;
 
-
 	mvm = lq_sta->drv;
 	memset(buf, 0, sizeof(buf));
 	buf_size = min(count, sizeof(buf) -  1);
@@ -3074,6 +3079,94 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t rs_sta_dbgfs_drv_tx_stats_read(struct file *file,
+					      char __user *user_buf,
+					      size_t count, loff_t *ppos)
+{
+	static const char * const column_name[] = {
+		[RS_COLUMN_LEGACY_ANT_A] = "LEGACY_ANT_A",
+		[RS_COLUMN_LEGACY_ANT_B] = "LEGACY_ANT_B",
+		[RS_COLUMN_SISO_ANT_A] = "SISO_ANT_A",
+		[RS_COLUMN_SISO_ANT_B] = "SISO_ANT_B",
+		[RS_COLUMN_SISO_ANT_A_SGI] = "SISO_ANT_A_SGI",
+		[RS_COLUMN_SISO_ANT_B_SGI] = "SISO_ANT_B_SGI",
+		[RS_COLUMN_MIMO2] = "MIMO2",
+		[RS_COLUMN_MIMO2_SGI] = "MIMO2_SGI",
+	};
+
+	static const char * const rate_name[] = {
+		[IWL_RATE_1M_INDEX] = "1M",
+		[IWL_RATE_2M_INDEX] = "2M",
+		[IWL_RATE_5M_INDEX] = "5.5M",
+		[IWL_RATE_11M_INDEX] = "11M",
+		[IWL_RATE_6M_INDEX] = "6M|MCS0",
+		[IWL_RATE_9M_INDEX] = "9M",
+		[IWL_RATE_12M_INDEX] = "12M|MCS1",
+		[IWL_RATE_18M_INDEX] = "18M|MCS2",
+		[IWL_RATE_24M_INDEX] = "24M|MCS3",
+		[IWL_RATE_36M_INDEX] = "36M|MCS4",
+		[IWL_RATE_48M_INDEX] = "48M|MCS5",
+		[IWL_RATE_54M_INDEX] = "54M|MCS6",
+		[IWL_RATE_MCS_7_INDEX] = "MCS7",
+		[IWL_RATE_MCS_8_INDEX] = "MCS8",
+		[IWL_RATE_MCS_9_INDEX] = "MCS9",
+	};
+
+	char *buff, *pos, *endpos;
+	int col, rate;
+	ssize_t ret;
+	struct iwl_lq_sta *lq_sta = file->private_data;
+	struct rs_rate_stats *stats;
+	static const size_t bufsz = 1024;
+
+	buff = kmalloc(bufsz, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
+	pos = buff;
+	endpos = pos + bufsz;
+
+	pos += scnprintf(pos, endpos - pos, "COLUMN,");
+	for (rate = 0; rate < IWL_RATE_COUNT; rate++)
+		pos += scnprintf(pos, endpos - pos, "%s,", rate_name[rate]);
+	pos += scnprintf(pos, endpos - pos, "\n");
+
+	for (col = 0; col < RS_COLUMN_COUNT; col++) {
+		pos += scnprintf(pos, endpos - pos,
+				 "%s,", column_name[col]);
+
+		for (rate = 0; rate < IWL_RATE_COUNT; rate++) {
+			stats = &(lq_sta->tx_stats[col][rate]);
+			pos += scnprintf(pos, endpos - pos,
+					 "%llu/%llu,",
+					 stats->success,
+					 stats->total);
+		}
+		pos += scnprintf(pos, endpos - pos, "\n");
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buff, pos - buff);
+	kfree(buff);
+	return ret;
+}
+
+static ssize_t rs_sta_dbgfs_drv_tx_stats_write(struct file *file,
+					       const char __user *user_buf,
+					       size_t count, loff_t *ppos)
+{
+	struct iwl_lq_sta *lq_sta = file->private_data;
+	memset(lq_sta->tx_stats, 0, sizeof(lq_sta->tx_stats));
+
+	return count;
+}
+
+static const struct file_operations rs_sta_dbgfs_drv_tx_stats_ops = {
+	.read = rs_sta_dbgfs_drv_tx_stats_read,
+	.write = rs_sta_dbgfs_drv_tx_stats_write,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 static void rs_add_debugfs(void *mvm, void *mvm_sta, struct dentry *dir)
 {
 	struct iwl_lq_sta *lq_sta = mvm_sta;
@@ -3083,6 +3176,9 @@ static void rs_add_debugfs(void *mvm, void *mvm_sta, struct dentry *dir)
 	lq_sta->rs_sta_dbgfs_stats_table_file =
 		debugfs_create_file("rate_stats_table", S_IRUSR, dir,
 				    lq_sta, &rs_sta_dbgfs_stats_table_ops);
+	lq_sta->rs_sta_dbgfs_drv_tx_stats_file =
+		debugfs_create_file("drv_tx_stats", S_IRUSR | S_IWUSR, dir,
+				    lq_sta, &rs_sta_dbgfs_drv_tx_stats_ops);
 	lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file =
 		debugfs_create_u8("tx_agg_tid_enable", S_IRUSR | S_IWUSR, dir,
 				  &lq_sta->tx_agg_tid_en);
@@ -3096,6 +3192,7 @@ static void rs_remove_debugfs(void *mvm, void *mvm_sta)
 	struct iwl_lq_sta *lq_sta = mvm_sta;
 	debugfs_remove(lq_sta->rs_sta_dbgfs_scale_table_file);
 	debugfs_remove(lq_sta->rs_sta_dbgfs_stats_table_file);
+	debugfs_remove(lq_sta->rs_sta_dbgfs_drv_tx_stats_file);
 	debugfs_remove(lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file);
 	debugfs_remove(lq_sta->rs_sta_dbgfs_reduced_txp_file);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index fcc056d..958c99d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -272,9 +272,16 @@ enum rs_column {
 	RS_COLUMN_MIMO2_SGI,
 
 	RS_COLUMN_LAST = RS_COLUMN_MIMO2_SGI,
+	RS_COLUMN_COUNT = RS_COLUMN_LAST + 1,
 	RS_COLUMN_INVALID,
 };
 
+/* Packet stats per rate */
+struct rs_rate_stats {
+	u64 success;
+	u64 total;
+};
+
 /**
  * struct iwl_scale_tbl_info -- tx params and success history for all rates
  *
@@ -322,6 +329,8 @@ struct iwl_lq_sta {
 	bool is_vht;
 	enum ieee80211_band band;
 
+	struct rs_rate_stats tx_stats[RS_COLUMN_COUNT][IWL_RATE_COUNT];
+
 	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
 	u16 active_legacy_rate;
 	u16 active_siso_rate;
@@ -335,6 +344,7 @@ struct iwl_lq_sta {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *rs_sta_dbgfs_scale_table_file;
 	struct dentry *rs_sta_dbgfs_stats_table_file;
+	struct dentry *rs_sta_dbgfs_drv_tx_stats_file;
 	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
 	struct dentry *rs_sta_dbgfs_reduced_txp_file;
 	u32 dbg_fixed_rate;
-- 
1.8.3.2

