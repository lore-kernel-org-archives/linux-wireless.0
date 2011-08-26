Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7217 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab1HZGxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/60] iwlagn: transport handler can register debugfs entries
Date: Thu, 25 Aug 2011 23:10:50 -0700
Message-Id: <1314339092-20797-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085510_347787_4E943491)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Add a handler in iwl_trans_ops to allow it to add entries under debugfs dir
given by the upper level.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |  181 +--------------------
 drivers/net/wireless/iwlwifi/iwl-trans.c   |  243 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h   |   12 ++
 3 files changed, 258 insertions(+), 178 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 0aa8456..d322321 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -882,178 +882,6 @@ DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
 DEBUGFS_READ_WRITE_FILE_OPS(sleep_level_override);
 DEBUGFS_READ_FILE_OPS(current_sleep_command);
 
-static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	int pos = 0, ofs = 0;
-	int cnt = 0, entry;
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	struct iwl_rx_queue *rxq = &priv->rxq;
-	char *buf;
-	int bufsz = ((IWL_TRAFFIC_ENTRIES * IWL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
-		(priv->cfg->base_params->num_of_queues * 32 * 8) + 400;
-	const u8 *ptr;
-	ssize_t ret;
-
-	if (!priv->txq) {
-		IWL_ERR(priv, "txq not ready\n");
-		return -EAGAIN;
-	}
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate buffer\n");
-		return -ENOMEM;
-	}
-	pos += scnprintf(buf + pos, bufsz - pos, "Tx Queue\n");
-	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
-		txq = &priv->txq[cnt];
-		q = &txq->q;
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"q[%d]: read_ptr: %u, write_ptr: %u\n",
-				cnt, q->read_ptr, q->write_ptr);
-	}
-	if (priv->tx_traffic &&
-		(iwl_get_debug_level(priv->shrd) & IWL_DL_TX)) {
-		ptr = priv->tx_traffic;
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"Tx Traffic idx: %u\n",	priv->tx_traffic_idx);
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
-		(iwl_get_debug_level(priv->shrd) & IWL_DL_RX)) {
-		ptr = priv->rx_traffic;
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"Rx Traffic idx: %u\n",	priv->rx_traffic_idx);
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
-	struct iwl_priv *priv = file->private_data;
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
-		iwl_reset_traffic_log(priv);
-
-	return count;
-}
-
-static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
-						char __user *user_buf,
-						size_t count, loff_t *ppos) {
-
-	struct iwl_priv *priv = file->private_data;
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	char *buf;
-	int pos = 0;
-	int cnt;
-	int ret;
-	const size_t bufsz = sizeof(char) * 64 *
-				priv->cfg->base_params->num_of_queues;
-
-	if (!priv->txq) {
-		IWL_ERR(priv, "txq not ready\n");
-		return -EAGAIN;
-	}
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
-		txq = &priv->txq[cnt];
-		q = &txq->q;
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"hwq %.2d: read=%u write=%u stop=%d"
-				" swq_id=%#.2x (ac %d/hwq %d)\n",
-				cnt, q->read_ptr, q->write_ptr,
-				!!test_bit(cnt, priv->queue_stopped),
-				txq->swq_id, txq->swq_id & 3,
-				(txq->swq_id >> 2) & 0x1f);
-		if (cnt >= 4)
-			continue;
-		/* for the ACs, display the stop count too */
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"        stop-count: %d\n",
-				atomic_read(&priv->queue_stop_count[cnt]));
-	}
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
-						char __user *user_buf,
-						size_t count, loff_t *ppos) {
-
-	struct iwl_priv *priv = file->private_data;
-	struct iwl_rx_queue *rxq = &priv->rxq;
-	char buf[256];
-	int pos = 0;
-	const size_t bufsz = sizeof(buf);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "read: %u\n",
-						rxq->read);
-	pos += scnprintf(buf + pos, bufsz - pos, "write: %u\n",
-						rxq->write);
-	pos += scnprintf(buf + pos, bufsz - pos, "free_count: %u\n",
-						rxq->free_count);
-	if (rxq->rb_stts) {
-		pos += scnprintf(buf + pos, bufsz - pos, "closed_rb_num: %u\n",
-			 le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF);
-	} else {
-		pos += scnprintf(buf + pos, bufsz - pos,
-					"closed_rb_num: Not Allocated\n");
-	}
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
-
 static const char *fmt_value = "  %-30s %10u\n";
 static const char *fmt_hex   = "  %-30s       0x%02X\n";
 static const char *fmt_table = "  %-30s %10u  %10u  %10u  %10u\n";
@@ -2630,9 +2458,6 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
-DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
-DEBUGFS_READ_FILE_OPS(rx_queue);
-DEBUGFS_READ_FILE_OPS(tx_queue);
 DEBUGFS_READ_FILE_OPS(ucode_rx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_tx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_general_stats);
@@ -2696,9 +2521,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rx_statistics, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_statistics, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(traffic_log, dir_debug, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(rx_queue, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(tx_queue, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(power_save_status, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(clear_ucode_statistics, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(clear_traffic_statistics, dir_debug, S_IWUSR);
@@ -2727,6 +2549,9 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 			 &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
 			 &priv->disable_chain_noise_cal);
+
+	if (iwl_trans_dbgfs_register(trans(priv), dir_debug))
+		goto err;
 	return 0;
 
 err:
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 739087f..eeeb130 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -61,6 +61,7 @@
  *
  *****************************************************************************/
 #include <linux/interrupt.h>
+#include <linux/debugfs.h>
 
 #include "iwl-dev.h"
 #include "iwl-trans.h"
@@ -1169,6 +1170,246 @@ static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
 	return iwl_trans;
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+/* create and remove of files */
+#define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
+	if (!debugfs_create_file(#name, mode, parent, priv,		\
+				 &iwl_dbgfs_##name##_ops))		\
+		return -ENOMEM;						\
+} while (0)
+
+/* file operation */
+#define DEBUGFS_READ_FUNC(name)                                         \
+static ssize_t iwl_dbgfs_##name##_read(struct file *file,               \
+					char __user *user_buf,          \
+					size_t count, loff_t *ppos);
+
+#define DEBUGFS_WRITE_FUNC(name)                                        \
+static ssize_t iwl_dbgfs_##name##_write(struct file *file,              \
+					const char __user *user_buf,    \
+					size_t count, loff_t *ppos);
+
+
+static int iwl_dbgfs_open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+#define DEBUGFS_READ_FILE_OPS(name)					\
+	DEBUGFS_READ_FUNC(name);					\
+static const struct file_operations iwl_dbgfs_##name##_ops = {		\
+	.read = iwl_dbgfs_##name##_read,				\
+	.open = iwl_dbgfs_open_file_generic,				\
+	.llseek = generic_file_llseek,					\
+};
+
+#define DEBUGFS_READ_WRITE_FILE_OPS(name)				\
+	DEBUGFS_READ_FUNC(name);					\
+	DEBUGFS_WRITE_FUNC(name);					\
+static const struct file_operations iwl_dbgfs_##name##_ops = {		\
+	.write = iwl_dbgfs_##name##_write,				\
+	.read = iwl_dbgfs_##name##_read,				\
+	.open = iwl_dbgfs_open_file_generic,				\
+	.llseek = generic_file_llseek,					\
+};
+
+static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	int pos = 0, ofs = 0;
+	int cnt = 0, entry;
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	char *buf;
+	int bufsz = ((IWL_TRAFFIC_ENTRIES * IWL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
+		(priv->cfg->base_params->num_of_queues * 32 * 8) + 400;
+	const u8 *ptr;
+	ssize_t ret;
+
+	if (!priv->txq) {
+		IWL_ERR(priv, "txq not ready\n");
+		return -EAGAIN;
+	}
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate buffer\n");
+		return -ENOMEM;
+	}
+	pos += scnprintf(buf + pos, bufsz - pos, "Tx Queue\n");
+	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
+		txq = &priv->txq[cnt];
+		q = &txq->q;
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"q[%d]: read_ptr: %u, write_ptr: %u\n",
+				cnt, q->read_ptr, q->write_ptr);
+	}
+	if (priv->tx_traffic &&
+		(iwl_get_debug_level(priv->shrd) & IWL_DL_TX)) {
+		ptr = priv->tx_traffic;
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"Tx Traffic idx: %u\n",	priv->tx_traffic_idx);
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
+	pos += scnprintf(buf + pos, bufsz - pos, "Rx Queue\n");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"read: %u, write: %u\n",
+			 rxq->read, rxq->write);
+
+	if (priv->rx_traffic &&
+		(iwl_get_debug_level(priv->shrd) & IWL_DL_RX)) {
+		ptr = priv->rx_traffic;
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"Rx Traffic idx: %u\n",	priv->rx_traffic_idx);
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
+static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = file->private_data;
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+	char *buf;
+	int pos = 0;
+	int cnt;
+	int ret;
+	const size_t bufsz = sizeof(char) * 64 *
+				priv->cfg->base_params->num_of_queues;
+
+	if (!priv->txq) {
+		IWL_ERR(priv, "txq not ready\n");
+		return -EAGAIN;
+	}
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
+		txq = &priv->txq[cnt];
+		q = &txq->q;
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"hwq %.2d: read=%u write=%u stop=%d"
+				" swq_id=%#.2x (ac %d/hwq %d)\n",
+				cnt, q->read_ptr, q->write_ptr,
+				!!test_bit(cnt, priv->queue_stopped),
+				txq->swq_id, txq->swq_id & 3,
+				(txq->swq_id >> 2) & 0x1f);
+		if (cnt >= 4)
+			continue;
+		/* for the ACs, display the stop count too */
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"        stop-count: %d\n",
+				atomic_read(&priv->queue_stop_count[cnt]));
+	}
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos) {
+	struct iwl_priv *priv = file->private_data;
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	char buf[256];
+	int pos = 0;
+	const size_t bufsz = sizeof(buf);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "read: %u\n",
+						rxq->read);
+	pos += scnprintf(buf + pos, bufsz - pos, "write: %u\n",
+						rxq->write);
+	pos += scnprintf(buf + pos, bufsz - pos, "free_count: %u\n",
+						rxq->free_count);
+	if (rxq->rb_stts) {
+		pos += scnprintf(buf + pos, bufsz - pos, "closed_rb_num: %u\n",
+			 le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF);
+	} else {
+		pos += scnprintf(buf + pos, bufsz - pos,
+					"closed_rb_num: Not Allocated\n");
+	}
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
+DEBUGFS_READ_FILE_OPS(rx_queue);
+DEBUGFS_READ_FILE_OPS(tx_queue);
+
+/*
+ * Create the debugfs files and directories
+ *
+ */
+static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
+					struct dentry *dir)
+{
+	struct iwl_priv *priv = priv(trans);
+
+	DEBUGFS_ADD_FILE(traffic_log, dir, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
+	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
+	return 0;
+}
+#else
+static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
+					struct dentry *dir)
+{ return 0; }
+
+#endif /*CONFIG_IWLWIFI_DEBUGFS */
+
 const struct iwl_trans_ops trans_ops_pcie = {
 	.alloc = iwl_trans_pcie_alloc,
 	.request_irq = iwl_trans_pcie_request_irq,
@@ -1194,5 +1435,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 
 	.sync_irq = iwl_trans_pcie_sync_irq,
 	.free = iwl_trans_pcie_free,
+
+	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 4a0c786..a9b3157 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -63,6 +63,8 @@
 #ifndef __iwl_trans_h__
 #define __iwl_trans_h__
 
+#include <linux/debugfs.h>
+
  /*This file includes the declaration that are exported from the transport
  * layer */
 
@@ -98,6 +100,8 @@ struct iwl_shared;
  *            layer shall not pass any Rx.
  * @free: release all the ressource for the transport layer itself such as
  *        irq, tasklet etc...
+ * @dbgfs_register: add the dbgfs files under this directory. Files will be
+ *	automatically deleted.
  */
 struct iwl_trans_ops {
 
@@ -128,6 +132,8 @@ struct iwl_trans_ops {
 
 	void (*sync_irq)(struct iwl_priv *priv);
 	void (*free)(struct iwl_priv *priv);
+
+	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
 };
 
 /**
@@ -232,6 +238,12 @@ static inline void iwl_trans_free(struct iwl_trans *trans)
 	trans->ops->free(priv(trans));
 }
 
+static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
+					    struct dentry *dir)
+{
+	return trans->ops->dbgfs_register(trans, dir);
+}
+
 /*****************************************************
 * Transport layers implementations
 ******************************************************/
-- 
1.7.0.4

