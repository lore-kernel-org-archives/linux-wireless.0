Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49208 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab0EJW2a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:30 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 37/47] iwlwifi: "tx power per chain" are part of ucode_tx_stats
Date: Mon, 10 May 2010 15:28:08 -0700
Message-Id: <1273530498-11876-38-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Move "tx power per chain" into ucode_tx_stats, it is debugging
information provided by uCode as part of statistics notification.

The "tx power per chain" parameters are optional parameters which only
supported by 6000 series device today; those are reserved fields for all
the other devices.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   16 +++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h    |    5 +++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |   42 ------------------------
 3 files changed, 21 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index f249b70..48c023b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -709,6 +709,22 @@ ssize_t iwl_ucode_tx_stats_read(struct file *file,
 			 delta_tx->agg.rx_ba_rsp_cnt,
 			 max_tx->agg.rx_ba_rsp_cnt);
 
+	if (tx->tx_power.ant_a || tx->tx_power.ant_b || tx->tx_power.ant_c) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+			"tx power: (1/2 dB step)\n");
+		if ((priv->cfg->valid_tx_ant & ANT_A) && tx->tx_power.ant_a)
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"\tantenna A: 0x%X\n",
+					tx->tx_power.ant_a);
+		if ((priv->cfg->valid_tx_ant & ANT_B) && tx->tx_power.ant_b)
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"\tantenna B: 0x%X\n",
+					tx->tx_power.ant_b);
+		if ((priv->cfg->valid_tx_ant & ANT_C) && tx->tx_power.ant_c)
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"\tantenna C: 0x%X\n",
+					tx->tx_power.ant_c);
+	}
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 449d41f..9aab020 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3127,6 +3127,11 @@ struct statistics_tx {
 	__le32 cts_timeout_collision;
 	__le32 ack_or_ba_timeout_collision;
 	struct statistics_tx_non_phy_agg agg;
+	/*
+	 * "tx_power" are optional parameters provided by uCode,
+	 * 6000 series is the only device provide the information,
+	 * Those are reserved fields for all the other devices
+	 */
 	struct statistics_tx_power tx_power;
 	__le32 reserved1;
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 06905bb..4d6de2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1214,46 +1214,6 @@ static ssize_t iwl_dbgfs_chain_noise_read(struct file *file,
 	return ret;
 }
 
-static ssize_t iwl_dbgfs_chain_tx_power_read(struct file *file,
-					char __user *user_buf,
-					size_t count, loff_t *ppos) {
-
-	struct iwl_priv *priv = file->private_data;
-	char buf[128];
-	int pos = 0;
-	const size_t bufsz = sizeof(buf);
-	struct statistics_tx *tx;
-
-	if (!iwl_is_alive(priv))
-		return -EAGAIN;
-	else {
-		tx = &priv->statistics.tx;
-		if (tx->tx_power.ant_a ||
-		    tx->tx_power.ant_b ||
-		    tx->tx_power.ant_c) {
-			pos += scnprintf(buf + pos, bufsz - pos,
-				"tx power: (1/2 dB step)\n");
-			if ((priv->cfg->valid_tx_ant & ANT_A) &&
-			    tx->tx_power.ant_a)
-				pos += scnprintf(buf + pos, bufsz - pos,
-						"\tantenna A: 0x%X\n",
-						tx->tx_power.ant_a);
-			if ((priv->cfg->valid_tx_ant & ANT_B) &&
-			    tx->tx_power.ant_b)
-				pos += scnprintf(buf + pos, bufsz - pos,
-						"\tantenna B: 0x%X\n",
-						tx->tx_power.ant_b);
-			if ((priv->cfg->valid_tx_ant & ANT_C) &&
-			    tx->tx_power.ant_c)
-				pos += scnprintf(buf + pos, bufsz - pos,
-						"\tantenna C: 0x%X\n",
-						tx->tx_power.ant_c);
-		} else
-			pos += scnprintf(buf + pos, bufsz - pos, "N/A\n");
-	}
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
-
 static ssize_t iwl_dbgfs_power_save_status_read(struct file *file,
 						    char __user *user_buf,
 						    size_t count, loff_t *ppos)
@@ -1565,7 +1525,6 @@ DEBUGFS_READ_FILE_OPS(ucode_tx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_general_stats);
 DEBUGFS_READ_FILE_OPS(sensitivity);
 DEBUGFS_READ_FILE_OPS(chain_noise);
-DEBUGFS_READ_FILE_OPS(chain_tx_power);
 DEBUGFS_READ_FILE_OPS(power_save_status);
 DEBUGFS_WRITE_FILE_OPS(clear_ucode_statistics);
 DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
@@ -1624,7 +1583,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(traffic_log, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rx_queue, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(chain_tx_power, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(power_save_status, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(clear_ucode_statistics, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(clear_traffic_statistics, dir_debug, S_IWUSR);
-- 
1.6.3.3

