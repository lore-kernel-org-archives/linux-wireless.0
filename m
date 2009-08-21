Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50995 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639AbZHUUe2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:28 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/14] iwlwifi: show current tx power
Date: Fri, 21 Aug 2009 13:34:19 -0700
Message-Id: <1250886867-4112-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

debugFs file show current tx power for all the transmit chains

Adding "tx_power" file in /sys/kernal/debug/ieee80211/phy0/iwlagn/debug
to display current tx power for all the active chains in 1/2 dB step.

Show tx power information "Not available" if uCode can not provide the
information or interface is down.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   54 ++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 723f38a..cbc6290 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -107,6 +107,7 @@ struct iwl_debugfs {
 		struct dentry *file_ucode_general_stats;
 		struct dentry *file_sensitivity;
 		struct dentry *file_chain_noise;
+		struct dentry *file_tx_power;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index f68fb47..fb84485 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1563,6 +1563,57 @@ static ssize_t iwl_dbgfs_chain_noise_read(struct file *file,
 	return ret;
 }
 
+static ssize_t iwl_dbgfs_tx_power_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	char buf[128];
+	int pos = 0;
+	ssize_t ret;
+	const size_t bufsz = sizeof(buf);
+	struct statistics_tx *tx;
+
+	if (!iwl_is_alive(priv))
+		pos += scnprintf(buf + pos, bufsz - pos, "N/A\n");
+	else {
+		/* make request to uCode to retrieve statistics information */
+		mutex_lock(&priv->mutex);
+		ret = iwl_send_statistics_request(priv, 0);
+		mutex_unlock(&priv->mutex);
+
+		if (ret) {
+			IWL_ERR(priv, "Error sending statistics request: %zd\n",
+				ret);
+			return -EAGAIN;
+		}
+		tx = &priv->statistics.tx;
+		if (tx->tx_power.ant_a ||
+		    tx->tx_power.ant_b ||
+		    tx->tx_power.ant_c) {
+			pos += scnprintf(buf + pos, bufsz - pos,
+				"tx power: (1/2 dB step)\n");
+			if ((priv->cfg->valid_tx_ant & ANT_A) &&
+			    tx->tx_power.ant_a)
+				pos += scnprintf(buf + pos, bufsz - pos,
+						"\tantenna A: 0x%X\n",
+						tx->tx_power.ant_a);
+			if ((priv->cfg->valid_tx_ant & ANT_B) &&
+			    tx->tx_power.ant_b)
+				pos += scnprintf(buf + pos, bufsz - pos,
+						"\tantenna B: 0x%X\n",
+						tx->tx_power.ant_b);
+			if ((priv->cfg->valid_tx_ant & ANT_C) &&
+			    tx->tx_power.ant_c)
+				pos += scnprintf(buf + pos, bufsz - pos,
+						"\tantenna C: 0x%X\n",
+						tx->tx_power.ant_c);
+		} else
+			pos += scnprintf(buf + pos, bufsz - pos, "N/A\n");
+	}
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(rx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1573,6 +1624,7 @@ DEBUGFS_READ_FILE_OPS(ucode_tx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_general_stats);
 DEBUGFS_READ_FILE_OPS(sensitivity);
 DEBUGFS_READ_FILE_OPS(chain_noise);
+DEBUGFS_READ_FILE_OPS(tx_power);
 
 /*
  * Create the debugfs files and directories
@@ -1621,6 +1673,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(traffic_log, debug);
 	DEBUGFS_ADD_FILE(rx_queue, debug);
 	DEBUGFS_ADD_FILE(tx_queue, debug);
+	DEBUGFS_ADD_FILE(tx_power, debug);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_ADD_FILE(ucode_rx_stats, debug);
 		DEBUGFS_ADD_FILE(ucode_tx_stats, debug);
@@ -1674,6 +1727,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_traffic_log);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_rx_queue);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_queue);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_power);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_ucode_rx_stats);
-- 
1.5.6.3

