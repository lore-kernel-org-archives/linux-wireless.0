Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26702 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab1IFRPJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 13:15:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/10] iwlagn: move traffic_log back to upper layer
Date: Tue,  6 Sep 2011 09:31:20 -0700
Message-Id: <1315326685-22213-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110906_191521_982325_25FC650F)
In-Reply-To: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The traffic log debugfs handlers were mistakenly moved to the
transport layer because they print the pointers of the Tx / Rx
queues. The pointers of the queues can be fetched by another debugfs
handler.
So bring the traffic log back to the upper layer and remove the part
that reads the Tx / Rx queues' pointers.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   85 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.c   |  107 ----------------------------
 2 files changed, 85 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index e320cc1..d0c63cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -804,6 +804,89 @@ DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
 DEBUGFS_READ_WRITE_FILE_OPS(sleep_level_override);
 DEBUGFS_READ_FILE_OPS(current_sleep_command);
 
+static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	int pos = 0, ofs = 0;
+	int cnt = 0, entry;
+
+	char *buf;
+	int bufsz = ((IWL_TRAFFIC_ENTRIES * IWL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
+		(hw_params(priv).max_txq_num * 32 * 8) + 400;
+	const u8 *ptr;
+	ssize_t ret;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate buffer\n");
+		return -ENOMEM;
+	}
+	if (priv->tx_traffic &&
+		(iwl_get_debug_level(priv->shrd) & IWL_DL_TX)) {
+		ptr = priv->tx_traffic;
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"Tx Traffic idx: %u\n", priv->tx_traffic_idx);
+		for (cnt = 0, ofs = 0; cnt < IWL_TRAFFIC_ENTRIES; cnt++) {
+			for (entry = 0; entry < IWL_TRAFFIC_ENTRY_SIZE / 16;
+			     entry++,  ofs += 16) {
+				pos += scnprintf(buf + pos, bufsz - pos,
+						"0x%.4x ", ofs);
+				hex_dump_to_buffer(ptr + ofs, 16, 16, 2,
+						   buf + pos, bufsz - pos, 0);
+				pos += strlen(buf + pos);
+				if (bufsz - pos > 0)
+					buf[pos++] = '\n';
+			}
+		}
+	}
+
+	if (priv->rx_traffic &&
+		(iwl_get_debug_level(priv->shrd) & IWL_DL_RX)) {
+		ptr = priv->rx_traffic;
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"Rx Traffic idx: %u\n", priv->rx_traffic_idx);
+		for (cnt = 0, ofs = 0; cnt < IWL_TRAFFIC_ENTRIES; cnt++) {
+			for (entry = 0; entry < IWL_TRAFFIC_ENTRY_SIZE / 16;
+			     entry++,  ofs += 16) {
+				pos += scnprintf(buf + pos, bufsz - pos,
+						"0x%.4x ", ofs);
+				hex_dump_to_buffer(ptr + ofs, 16, 16, 2,
+						   buf + pos, bufsz - pos, 0);
+				pos += strlen(buf + pos);
+				if (bufsz - pos > 0)
+					buf[pos++] = '\n';
+			}
+		}
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_traffic_log_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int traffic_log;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &traffic_log) != 1)
+		return -EFAULT;
+	if (traffic_log == 0)
+		iwl_reset_traffic_log(priv);
+
+	return count;
+}
+
 static const char *fmt_value = "  %-30s %10u\n";
 static const char *fmt_hex   = "  %-30s       0x%02X\n";
 static const char *fmt_table = "  %-30s %10u  %10u  %10u  %10u\n";
@@ -2340,6 +2423,7 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
+DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
 DEBUGFS_READ_FILE_OPS(ucode_rx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_tx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_general_stats);
@@ -2400,6 +2484,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rx_statistics, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_statistics, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(traffic_log, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(power_save_status, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(clear_ucode_statistics, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(clear_traffic_statistics, dir_debug, S_IWUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 3948d31..28fbaa2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1561,111 +1561,6 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.llseek = generic_file_llseek,					\
 };
 
-static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	struct iwl_priv *priv = priv(trans);
-	int pos = 0, ofs = 0;
-	int cnt = 0, entry;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-	char *buf;
-	int bufsz = ((IWL_TRAFFIC_ENTRIES * IWL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
-		(hw_params(trans).max_txq_num * 32 * 8) + 400;
-	const u8 *ptr;
-	ssize_t ret;
-
-	if (!trans_pcie->txq) {
-		IWL_ERR(trans, "txq not ready\n");
-		return -EAGAIN;
-	}
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(trans, "Can not allocate buffer\n");
-		return -ENOMEM;
-	}
-	pos += scnprintf(buf + pos, bufsz - pos, "Tx Queue\n");
-	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
-		txq = &trans_pcie->txq[cnt];
-		q = &txq->q;
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"q[%d]: read_ptr: %u, write_ptr: %u\n",
-				cnt, q->read_ptr, q->write_ptr);
-	}
-	if (priv->tx_traffic &&
-		(iwl_get_debug_level(trans->shrd) & IWL_DL_TX)) {
-		ptr = priv->tx_traffic;
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"Tx Traffic idx: %u\n", priv->tx_traffic_idx);
-		for (cnt = 0, ofs = 0; cnt < IWL_TRAFFIC_ENTRIES; cnt++) {
-			for (entry = 0; entry < IWL_TRAFFIC_ENTRY_SIZE / 16;
-			     entry++,  ofs += 16) {
-				pos += scnprintf(buf + pos, bufsz - pos,
-						"0x%.4x ", ofs);
-				hex_dump_to_buffer(ptr + ofs, 16, 16, 2,
-						   buf + pos, bufsz - pos, 0);
-				pos += strlen(buf + pos);
-				if (bufsz - pos > 0)
-					buf[pos++] = '\n';
-			}
-		}
-	}
-
-	pos += scnprintf(buf + pos, bufsz - pos, "Rx Queue\n");
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"read: %u, write: %u\n",
-			 rxq->read, rxq->write);
-
-	if (priv->rx_traffic &&
-		(iwl_get_debug_level(trans->shrd) & IWL_DL_RX)) {
-		ptr = priv->rx_traffic;
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"Rx Traffic idx: %u\n", priv->rx_traffic_idx);
-		for (cnt = 0, ofs = 0; cnt < IWL_TRAFFIC_ENTRIES; cnt++) {
-			for (entry = 0; entry < IWL_TRAFFIC_ENTRY_SIZE / 16;
-			     entry++,  ofs += 16) {
-				pos += scnprintf(buf + pos, bufsz - pos,
-						"0x%.4x ", ofs);
-				hex_dump_to_buffer(ptr + ofs, 16, 16, 2,
-						   buf + pos, bufsz - pos, 0);
-				pos += strlen(buf + pos);
-				if (bufsz - pos > 0)
-					buf[pos++] = '\n';
-			}
-		}
-	}
-
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_traffic_log_write(struct file *file,
-					 const char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	char buf[8];
-	int buf_size;
-	int traffic_log;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &traffic_log) != 1)
-		return -EFAULT;
-	if (traffic_log == 0)
-		iwl_reset_traffic_log(priv(trans));
-
-	return count;
-}
-
 static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 						char __user *user_buf,
 						size_t count, loff_t *ppos)
@@ -2031,7 +1926,6 @@ static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
 	return ret;
 }
 
-DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
 DEBUGFS_READ_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(fh_reg);
@@ -2046,7 +1940,6 @@ DEBUGFS_WRITE_FILE_OPS(csr);
 static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 					struct dentry *dir)
 {
-	DEBUGFS_ADD_FILE(traffic_log, dir, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(log_event, dir, S_IWUSR | S_IRUSR);
-- 
1.7.0.4

