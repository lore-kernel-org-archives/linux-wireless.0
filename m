Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab0HWOxg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/26] iwlwifi: add bt traffic load debugfs file
Date: Mon, 23 Aug 2010 07:57:16 -0700
Message-Id: <1282575437-23270-26-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add the debugfs file to show current bluetooth traffic load

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   45 ++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index aae9eb5..ef78790 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1555,6 +1555,48 @@ static ssize_t iwl_dbgfs_monitor_period_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_bt_traffic_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	char buf[200];
+	const size_t bufsz = sizeof(buf);
+	ssize_t ret;
+
+	pos += scnprintf(buf + pos, bufsz - pos, "BT in %s mode\n",
+		priv->bt_full_concurrent ? "full concurrency" : "3-wire");
+	pos += scnprintf(buf + pos, bufsz - pos, "BT status: %s, "
+			 "last traffic notif: %d\n",
+		priv->bt_status ? "On" : "Off", priv->notif_bt_traffic_load);
+	pos += scnprintf(buf + pos, bufsz - pos, "ch_announcement: %d, "
+			 "sco_active: %d, kill_ack_mask: %x, "
+			 "kill_cts_mask: %x\n",
+		priv->bt_ch_announce, priv->bt_sco_active,
+		priv->kill_ack_mask, priv->kill_cts_mask);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "bluetooth traffic load: ");
+	switch (priv->bt_traffic_load) {
+	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
+		pos += scnprintf(buf + pos, bufsz - pos, "Continuous\n");
+		break;
+	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
+		pos += scnprintf(buf + pos, bufsz - pos, "High\n");
+		break;
+	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
+		pos += scnprintf(buf + pos, bufsz - pos, "Low\n");
+		break;
+	case IWL_BT_COEX_TRAFFIC_LOAD_NONE:
+	default:
+		pos += scnprintf(buf + pos, bufsz - pos, "None\n");
+		break;
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	return ret;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1579,6 +1621,7 @@ DEBUGFS_READ_FILE_OPS(rxon_filter_flags);
 DEBUGFS_WRITE_FILE_OPS(txfifo_flush);
 DEBUGFS_READ_FILE_OPS(ucode_bt_stats);
 DEBUGFS_WRITE_FILE_OPS(monitor_period);
+DEBUGFS_READ_FILE_OPS(bt_traffic);
 
 /*
  * Create the debugfs files and directories
@@ -1651,6 +1694,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(monitor_period, dir_debug, S_IWUSR);
+	if (priv->cfg->advanced_bt_coexist)
+		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
 	if (priv->cfg->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
 				 &priv->disable_sens_cal);
-- 
1.7.0.4

