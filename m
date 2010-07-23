Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9523 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab0GWQN5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:13:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/10] iwlagn: add bluetooth stats to debugfs
Date: Fri, 23 Jul 2010 09:15:33 -0700
Message-Id: <1279901739-10541-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For WiFi/BT combo devices, add bluetooth statistics counter
read function to debugfs.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   87 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h |    7 ++
 drivers/net/wireless/iwlwifi/iwl-core.h        |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |   13 ++++
 8 files changed, 113 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index c281d07..8848333 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -222,6 +222,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
+		.bt_stats_read = iwl_ucode_bt_stats_read,
 	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 27a776f..d6531ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2285,6 +2285,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
+		.bt_stats_read = iwl_ucode_bt_stats_read,
 	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a7077cd..8093ce2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -398,6 +398,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
+		.bt_stats_read = iwl_ucode_bt_stats_read,
 	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a4e58d8..5827052 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -323,6 +323,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
+		.bt_stats_read = iwl_ucode_bt_stats_read,
 	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index 19d1e5e..f052c6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -924,3 +924,90 @@ ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	kfree(buf);
 	return ret;
 }
+
+ssize_t iwl_ucode_bt_stats_read(struct file *file,
+				char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	char *buf;
+	int bufsz = (sizeof(struct statistics_bt_activity) * 24) + 200;
+	ssize_t ret;
+	struct statistics_bt_activity *bt, *accum_bt;
+
+	if (!iwl_is_alive(priv))
+		return -EAGAIN;
+
+	/* make request to uCode to retrieve statistics information */
+	mutex_lock(&priv->mutex);
+	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
+	mutex_unlock(&priv->mutex);
+
+	if (ret) {
+		IWL_ERR(priv,
+			"Error sending statistics request: %zd\n", ret);
+		return -EAGAIN;
+	}
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * the statistic information display here is based on
+	 * the last statistics notification from uCode
+	 * might not reflect the current uCode activity
+	 */
+	bt = &priv->_agn.statistics_bt.general.activity;
+	accum_bt = &priv->_agn.accum_statistics_bt.general.activity;
+
+	pos += iwl_statistics_flag(priv, buf, bufsz);
+	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_BT:\n");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\t\t\tcurrent\t\t\taccumulative\n");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "hi_priority_tx_req_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(bt->hi_priority_tx_req_cnt),
+			 accum_bt->hi_priority_tx_req_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "hi_priority_tx_denied_cnt:\t%u\t\t\t%u\n",
+			 le32_to_cpu(bt->hi_priority_tx_denied_cnt),
+			 accum_bt->hi_priority_tx_denied_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "lo_priority_tx_req_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(bt->lo_priority_tx_req_cnt),
+			 accum_bt->lo_priority_tx_req_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "lo_priority_rx_denied_cnt:\t%u\t\t\t%u\n",
+			 le32_to_cpu(bt->lo_priority_tx_denied_cnt),
+			 accum_bt->lo_priority_tx_denied_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "hi_priority_rx_req_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(bt->hi_priority_rx_req_cnt),
+			 accum_bt->hi_priority_rx_req_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "hi_priority_rx_denied_cnt:\t%u\t\t\t%u\n",
+			 le32_to_cpu(bt->hi_priority_rx_denied_cnt),
+			 accum_bt->hi_priority_rx_denied_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "lo_priority_rx_req_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(bt->lo_priority_rx_req_cnt),
+			 accum_bt->lo_priority_rx_req_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "lo_priority_rx_denied_cnt:\t%u\t\t\t%u\n",
+			 le32_to_cpu(bt->lo_priority_rx_denied_cnt),
+			 accum_bt->lo_priority_rx_denied_cnt);
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "(rx)num_bt_kills:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(priv->_agn.statistics_bt.rx.
+				general.num_bt_kills),
+			 priv->_agn.accum_statistics_bt.rx.
+				general.num_bt_kills);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
index 59b1f25..bbdce59 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
@@ -37,6 +37,8 @@ ssize_t iwl_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos);
 ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 				     size_t count, loff_t *ppos);
+ssize_t iwl_ucode_bt_stats_read(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos);
 #else
 static ssize_t iwl_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
@@ -53,4 +55,9 @@ static ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user
 {
 	return 0;
 }
+static ssize_t iwl_ucode_bt_stats_read(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	return 0;
+}
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2954a52..b60cf45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -125,6 +125,8 @@ struct iwl_debugfs_ops {
 				 size_t count, loff_t *ppos);
 	ssize_t (*general_stats_read)(struct file *file, char __user *user_buf,
 				      size_t count, loff_t *ppos);
+	ssize_t (*bt_stats_read)(struct file *file, char __user *user_buf,
+				 size_t count, loff_t *ppos);
 };
 
 struct iwl_temp_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 7b25d14..e96a1bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1519,6 +1519,16 @@ static ssize_t iwl_dbgfs_txfifo_flush_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_ucode_bt_stats_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+
+	return priv->cfg->ops->lib->debugfs_ops.bt_stats_read(file,
+			user_buf, count, ppos);
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1541,6 +1551,7 @@ DEBUGFS_READ_WRITE_FILE_OPS(force_reset);
 DEBUGFS_READ_FILE_OPS(rxon_flags);
 DEBUGFS_READ_FILE_OPS(rxon_filter_flags);
 DEBUGFS_WRITE_FILE_OPS(txfifo_flush);
+DEBUGFS_READ_FILE_OPS(ucode_bt_stats);
 
 /*
  * Create the debugfs files and directories
@@ -1608,6 +1619,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 		DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
 	if (priv->cfg->ucode_tracing)
 		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
+	if (priv->cfg->bt_statistics)
+		DEBUGFS_ADD_FILE(ucode_bt_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	if (priv->cfg->sensitivity_calib_by_driver)
-- 
1.7.0.4

