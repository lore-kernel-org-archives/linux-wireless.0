Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3029 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab0IQVXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 17:23:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/10] iwlagn: keep track of failure tx status
Date: Fri, 17 Sep 2010 14:24:27 -0700
Message-Id: <1284758674-25297-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Tx command response sent to host by uCode after completed
the transmission attempt. The status parameter indicates
whether the transmission was successful, or else why if failed.

Here we keep the counters to help understand the different failure
cases.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    2 +
 drivers/net/wireless/iwlwifi/iwl-6000.c        |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   97 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h |    7 ++
 drivers/net/wireless/iwlwifi/iwl-core.h        |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |   14 ++++
 8 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 674fb93..56ef4ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -223,6 +223,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
 		.bt_stats_read = iwl_ucode_bt_stats_read,
+		.reply_tx_error = iwl_reply_tx_error_read,
 	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1d6a46d..943a9c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2289,6 +2289,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
 		.bt_stats_read = iwl_ucode_bt_stats_read,
+		.reply_tx_error = iwl_reply_tx_error_read,
 	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b9399fb..21b4b23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -404,6 +404,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
 		.bt_stats_read = iwl_ucode_bt_stats_read,
+		.reply_tx_error = iwl_reply_tx_error_read,
 	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
@@ -475,6 +476,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
 		.bt_stats_read = iwl_ucode_bt_stats_read,
+		.reply_tx_error = iwl_reply_tx_error_read,
 	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 2fdba08..9f43f27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -329,6 +329,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
 		.bt_stats_read = iwl_ucode_bt_stats_read,
+		.reply_tx_error = iwl_reply_tx_error_read,
 	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
@@ -404,6 +405,7 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
 		.bt_stats_read = iwl_ucode_bt_stats_read,
+		.reply_tx_error = iwl_reply_tx_error_read,
 	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index d706b8a..de68dde 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -1011,3 +1011,100 @@ ssize_t iwl_ucode_bt_stats_read(struct file *file,
 	kfree(buf);
 	return ret;
 }
+
+ssize_t iwl_reply_tx_error_read(struct file *file,
+				char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	char *buf;
+	int bufsz = (sizeof(struct reply_tx_error_statistics) * 24) + 200;
+	ssize_t ret;
+
+	if (!iwl_is_alive(priv))
+		return -EAGAIN;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_TX_Error:\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_POSTPONE_DELAY),
+			 priv->_agn.reply_tx_stats.pp_delay);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_POSTPONE_FEW_BYTES),
+			 priv->_agn.reply_tx_stats.pp_few_bytes);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_POSTPONE_BT_PRIO),
+			 priv->_agn.reply_tx_stats.pp_bt_prio);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_POSTPONE_QUIET_PERIOD),
+			 priv->_agn.reply_tx_stats.pp_quiet_period);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_POSTPONE_CALC_TTAK),
+			 priv->_agn.reply_tx_stats.pp_calc_ttak);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
+			 iwl_get_tx_fail_reason(
+				TX_STATUS_FAIL_INTERNAL_CROSSED_RETRY),
+			 priv->_agn.reply_tx_stats.int_crossed_retry);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_SHORT_LIMIT),
+			 priv->_agn.reply_tx_stats.short_limit);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_LONG_LIMIT),
+			 priv->_agn.reply_tx_stats.long_limit);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_FIFO_UNDERRUN),
+			 priv->_agn.reply_tx_stats.fifo_underrun);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_DRAIN_FLOW),
+			 priv->_agn.reply_tx_stats.drain_flow);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_RFKILL_FLUSH),
+			 priv->_agn.reply_tx_stats.rfkill_flush);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_LIFE_EXPIRE),
+			 priv->_agn.reply_tx_stats.life_expire);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_DEST_PS),
+			 priv->_agn.reply_tx_stats.dest_ps);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_HOST_ABORTED),
+			 priv->_agn.reply_tx_stats.host_abort);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_BT_RETRY),
+			 priv->_agn.reply_tx_stats.pp_delay);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_STA_INVALID),
+			 priv->_agn.reply_tx_stats.sta_invalid);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_FRAG_DROPPED),
+			 priv->_agn.reply_tx_stats.frag_drop);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_TID_DISABLE),
+			 priv->_agn.reply_tx_stats.tid_disable);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_FIFO_FLUSHED),
+			 priv->_agn.reply_tx_stats.fifo_flush);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
+			 iwl_get_tx_fail_reason(
+				TX_STATUS_FAIL_INSUFFICIENT_CF_POLL),
+			 priv->_agn.reply_tx_stats.insuff_cf_poll);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_FW_DROP),
+			 priv->_agn.reply_tx_stats.fail_hw_drop);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t%u\n",
+			 iwl_get_tx_fail_reason(
+				TX_STATUS_FAIL_STA_COLOR_MISMATCH_DROP),
+			 priv->_agn.reply_tx_stats.sta_color_mismatch);
+	pos += scnprintf(buf + pos, bufsz - pos, "UNKNOWN:\t\t\t%u\n",
+			 priv->_agn.reply_tx_stats.unknown);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
index bbdce59..f2573b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
@@ -39,6 +39,8 @@ ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 				     size_t count, loff_t *ppos);
 ssize_t iwl_ucode_bt_stats_read(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos);
+ssize_t iwl_reply_tx_error_read(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos);
 #else
 static ssize_t iwl_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
@@ -60,4 +62,9 @@ static ssize_t iwl_ucode_bt_stats_read(struct file *file, char __user *user_buf,
 {
 	return 0;
 }
+static ssize_t iwl_reply_tx_error_read(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	return 0;
+}
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f1d40c6..f0302bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -130,6 +130,8 @@ struct iwl_debugfs_ops {
 				      size_t count, loff_t *ppos);
 	ssize_t (*bt_stats_read)(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos);
+	ssize_t (*reply_tx_error)(struct file *file, char __user *user_buf,
+				 size_t count, loff_t *ppos);
 };
 
 struct iwl_temp_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index e0b31a2..265ad01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1642,6 +1642,18 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_reply_tx_error_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+
+	if (priv->cfg->ops->lib->debugfs_ops.reply_tx_error)
+		return priv->cfg->ops->lib->debugfs_ops.reply_tx_error(
+			file, user_buf, count, ppos);
+	else
+		return -ENODATA;
+}
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1668,6 +1680,7 @@ DEBUGFS_READ_FILE_OPS(ucode_bt_stats);
 DEBUGFS_WRITE_FILE_OPS(monitor_period);
 DEBUGFS_READ_FILE_OPS(bt_traffic);
 DEBUGFS_READ_WRITE_FILE_OPS(protection_mode);
+DEBUGFS_READ_FILE_OPS(reply_tx_error);
 
 /*
  * Create the debugfs files and directories
@@ -1738,6 +1751,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
 	if (priv->cfg->bt_statistics)
 		DEBUGFS_ADD_FILE(ucode_bt_stats, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(reply_tx_error, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(monitor_period, dir_debug, S_IWUSR);
-- 
1.7.0.4

