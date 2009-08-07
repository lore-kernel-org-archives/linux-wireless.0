Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbZHGWl4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/16] iwlwifi: tx/rx queue pointer information
Date: Fri,  7 Aug 2009 15:41:41 -0700
Message-Id: <1249684912-22936-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding debugfs function to show current TxFifo/RxFifo read/write
pointer, plus the current tx queue status (wake/stop) for both real and
virtual queue.
This is part of debug feature set to help debugging driver/uCode.

use tx_queue and rx_queue in
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug directory to show the
current read/write pointer for both TxFifo and RxFifo queue

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   69 ++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 4ac06ad..cad5e27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -98,6 +98,8 @@ struct iwl_debugfs {
 		struct dentry *file_rx_statistics;
 		struct dentry *file_tx_statistics;
 		struct dentry *file_traffic_log;
+		struct dentry *file_rx_queue;
+		struct dentry *file_tx_queue;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index a0e5063..d4109cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -887,9 +887,74 @@ static ssize_t iwl_dbgfs_traffic_log_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+	char *buf;
+	int pos = 0;
+	int cnt;
+	int ret;
+	const size_t bufsz = sizeof(char) * 60 * IWL_MAX_NUM_QUEUES;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
+		txq = &priv->txq[cnt];
+		q = &txq->q;
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"hwq %.2d: read=%u write=%u stop=%d"
+				" swq_id=%#.2x (ac %d/hwq %d)\n",
+				cnt, q->read_ptr, q->write_ptr,
+				!!test_bit(cnt, priv->queue_stopped),
+				txq->swq_id,
+				txq->swq_id & 0x80 ? txq->swq_id & 3 :
+				txq->swq_id,
+				txq->swq_id & 0x80 ? (txq->swq_id >> 2) &
+				0x1f : txq->swq_id);
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
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
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
+	pos += scnprintf(buf + pos, bufsz - pos, "closed_rb_num: %u\n",
+			 le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(rx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
+DEBUGFS_READ_FILE_OPS(rx_queue);
+DEBUGFS_READ_FILE_OPS(tx_queue);
 
 /*
  * Create the debugfs files and directories
@@ -934,6 +999,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(rx_statistics, debug);
 	DEBUGFS_ADD_FILE(tx_statistics, debug);
 	DEBUGFS_ADD_FILE(traffic_log, debug);
+	DEBUGFS_ADD_FILE(rx_queue, debug);
+	DEBUGFS_ADD_FILE(tx_queue, debug);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
@@ -976,6 +1043,8 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_rx_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_traffic_log);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_rx_queue);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_queue);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_debug);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
-- 
1.5.6.3

