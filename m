Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24343 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbZHGWly (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:54 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/16] iwlwifi: new debugging feature for dumping data traffic
Date: Fri,  7 Aug 2009 15:41:39 -0700
Message-Id: <1249684912-22936-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

The traffic buffer will only beallocated and used if either bit 23
(IWL_DX_TX) or bit 24 (IWL_DL_RX) of "debug" is set;
example: "debug=0x800000" - log tx data traffic
         "debug=0x1000000" - log rx data traffic
         "debug=0x1800000" - log both tx and rx traffic

The traffic log will store the beginning portion (64 bytes)  of the
latest 256 of tx and rx packets in the round-robbin buffer for
debugging,
user can examine the log through debugfs file.

How to display the current logged tx/rx traffic and txfifo and rxfifo
read/write point:
"cat traffic_log" in /sys/kernel/debug/ieee80211/phy0/iwlagn/debug
directory

By echo "0" to traffic_log file will empty the traffic log buffer and
reset both tx and rx taffic log index to 0.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   11 +++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |  100 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |   28 +++++++
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    4 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |  102 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 ++
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   13 +++-
 10 files changed, 262 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 9e33507..bfd509f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -679,6 +679,7 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 
 	/* Set "1" to report good data frames in groups of 100 */
 	iwl3945_dbg_report_frame(priv, pkt, header, 1);
+	iwl_dbg_log_rx_data_frame(priv, le16_to_cpu(rx_hdr->len), header);
 
 	if (network_packet) {
 		priv->last_beacon_time = le32_to_cpu(rx_end->beacon_timestamp);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 24c1ae6..c9a1aac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2476,9 +2476,12 @@ static ssize_t store_debug_level(struct device *d,
 	ret = strict_strtoul(buf, 0, &val);
 	if (ret)
 		IWL_ERR(priv, "%s is not in hex or decimal form.\n", buf);
-	else
+	else {
 		priv->debug_level = val;
-
+		if (iwl_alloc_traffic_mem(priv))
+			IWL_ERR(priv,
+				"Not enough memory to generate traffic log\n");
+	}
 	return strnlen(buf, count);
 }
 
@@ -2819,6 +2822,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 #ifdef CONFIG_IWLWIFI_DEBUG
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
+	if (iwl_alloc_traffic_mem(priv))
+		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
 
 	/**************************
 	 * 2. Initializing PCI bus
@@ -3003,6 +3008,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_disable_device(pdev);
  out_ieee80211_free_hw:
 	ieee80211_free_hw(priv->hw);
+	iwl_free_traffic_mem(priv);
  out:
 	return err;
 }
@@ -3061,6 +3067,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	 * until now... */
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
+	iwl_free_traffic_mem(priv);
 
 	free_irq(priv->pci_dev->irq, priv);
 	pci_disable_msi(priv->pci_dev);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5315d34..1ae2ce3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2953,6 +2953,106 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(iwl_mac_reset_tsf);
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+
+#define IWL_TRAFFIC_DUMP_SIZE	(IWL_TRAFFIC_ENTRY_SIZE * IWL_TRAFFIC_ENTRIES)
+
+void iwl_reset_traffic_log(struct iwl_priv *priv)
+{
+	priv->tx_traffic_idx = 0;
+	priv->rx_traffic_idx = 0;
+	if (priv->tx_traffic)
+		memset(priv->tx_traffic, 0, IWL_TRAFFIC_DUMP_SIZE);
+	if (priv->rx_traffic)
+		memset(priv->rx_traffic, 0, IWL_TRAFFIC_DUMP_SIZE);
+}
+
+int iwl_alloc_traffic_mem(struct iwl_priv *priv)
+{
+	u32 traffic_size = IWL_TRAFFIC_DUMP_SIZE;
+
+	if (iwl_debug_level & IWL_DL_TX) {
+		if (!priv->tx_traffic) {
+			priv->tx_traffic =
+				kzalloc(traffic_size, GFP_KERNEL);
+			if (!priv->tx_traffic)
+				return -ENOMEM;
+		}
+	}
+	if (iwl_debug_level & IWL_DL_RX) {
+		if (!priv->rx_traffic) {
+			priv->rx_traffic =
+				kzalloc(traffic_size, GFP_KERNEL);
+			if (!priv->rx_traffic)
+				return -ENOMEM;
+		}
+	}
+	iwl_reset_traffic_log(priv);
+	return 0;
+}
+EXPORT_SYMBOL(iwl_alloc_traffic_mem);
+
+void iwl_free_traffic_mem(struct iwl_priv *priv)
+{
+	kfree(priv->tx_traffic);
+	priv->tx_traffic = NULL;
+
+	kfree(priv->rx_traffic);
+	priv->rx_traffic = NULL;
+}
+EXPORT_SYMBOL(iwl_free_traffic_mem);
+
+void iwl_dbg_log_tx_data_frame(struct iwl_priv *priv,
+		      u16 length, struct ieee80211_hdr *header)
+{
+	__le16 fc;
+	u16 len;
+
+	if (likely(!(iwl_debug_level & IWL_DL_TX)))
+		return;
+
+	if (!priv->tx_traffic)
+		return;
+
+	fc = header->frame_control;
+	if (ieee80211_is_data(fc)) {
+		len = (length > IWL_TRAFFIC_ENTRY_SIZE)
+		       ? IWL_TRAFFIC_ENTRY_SIZE : length;
+		memcpy((priv->tx_traffic +
+		       (priv->tx_traffic_idx * IWL_TRAFFIC_ENTRY_SIZE)),
+		       header, len);
+		priv->tx_traffic_idx =
+			(priv->tx_traffic_idx + 1) % IWL_TRAFFIC_ENTRIES;
+	}
+}
+EXPORT_SYMBOL(iwl_dbg_log_tx_data_frame);
+
+void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
+		      u16 length, struct ieee80211_hdr *header)
+{
+	__le16 fc;
+	u16 len;
+
+	if (likely(!(iwl_debug_level & IWL_DL_RX)))
+		return;
+
+	if (!priv->rx_traffic)
+		return;
+
+	fc = header->frame_control;
+	if (ieee80211_is_data(fc)) {
+		len = (length > IWL_TRAFFIC_ENTRY_SIZE)
+		       ? IWL_TRAFFIC_ENTRY_SIZE : length;
+		memcpy((priv->rx_traffic +
+		       (priv->rx_traffic_idx * IWL_TRAFFIC_ENTRY_SIZE)),
+		       header, len);
+		priv->rx_traffic_idx =
+			(priv->rx_traffic_idx + 1) % IWL_TRAFFIC_ENTRIES;
+	}
+}
+EXPORT_SYMBOL(iwl_dbg_log_rx_data_frame);
+#endif
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index dd66148..40a9167 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -300,7 +300,35 @@ void iwl_config_ap(struct iwl_priv *priv);
 int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
 			 struct ieee80211_tx_queue_stats *stats);
 void iwl_mac_reset_tsf(struct ieee80211_hw *hw);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+int iwl_alloc_traffic_mem(struct iwl_priv *priv);
+void iwl_free_traffic_mem(struct iwl_priv *priv);
+void iwl_reset_traffic_log(struct iwl_priv *priv);
+void iwl_dbg_log_tx_data_frame(struct iwl_priv *priv,
+				u16 length, struct ieee80211_hdr *header);
+void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
+				u16 length, struct ieee80211_hdr *header);
 
+#else
+static inline int iwl_alloc_traffic_mem(struct iwl_priv *priv)
+{
+	return 0;
+}
+static inline void iwl_free_traffic_mem(struct iwl_priv *priv)
+{
+}
+static inline void iwl_reset_traffic_log(struct iwl_priv *priv)
+{
+}
+static inline void iwl_dbg_log_tx_data_frame(struct iwl_priv *priv,
+		      u16 length, struct ieee80211_hdr *header)
+{
+}
+static inline void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
+		      u16 length, struct ieee80211_hdr *header)
+{
+}
+#endif
 /*****************************************************
  * RX handlers.
  * **************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 09af046..335ff5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -72,6 +72,7 @@ struct iwl_debugfs {
 	const char *name;
 	struct dentry *dir_drv;
 	struct dentry *dir_data;
+	struct dentry *dir_debug;
 	struct dentry *dir_rf;
 	struct dir_data_files {
 		struct dentry *file_sram;
@@ -95,6 +96,9 @@ struct iwl_debugfs {
 		struct dentry *file_disable_chain_noise;
 		struct dentry *file_disable_tx_power;
 	} dbgfs_rf_files;
+	struct dir_debug_files {
+		struct dentry *file_traffic_log;
+	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 6748a3f..031538c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -712,6 +712,104 @@ DEBUGFS_READ_FILE_OPS(led);
 DEBUGFS_READ_FILE_OPS(thermal_throttling);
 DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
 
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
+		(IWL_MAX_NUM_QUEUES * 32 * 8) + 400;
+	const u8 *ptr;
+	ssize_t ret;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate buffer\n");
+		return -ENOMEM;
+	}
+	pos += scnprintf(buf + pos, bufsz - pos, "Tx Queue\n");
+	for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
+		txq = &priv->txq[cnt];
+		q = &txq->q;
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"q[%d]: read_ptr: %u, write_ptr: %u\n",
+				cnt, q->read_ptr, q->write_ptr);
+	}
+	if (priv->tx_traffic && (iwl_debug_level & IWL_DL_TX)) {
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
+				pos += strlen(buf);
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
+	if (priv->rx_traffic && (iwl_debug_level & IWL_DL_RX)) {
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
+				pos += strlen(buf);
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
+DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
+
 /*
  * Create the debugfs files and directories
  *
@@ -738,6 +836,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 
 	DEBUGFS_ADD_DIR(data, dbgfs->dir_drv);
 	DEBUGFS_ADD_DIR(rf, dbgfs->dir_drv);
+	DEBUGFS_ADD_DIR(debug, dbgfs->dir_drv);
 	DEBUGFS_ADD_FILE(nvm, data);
 	DEBUGFS_ADD_FILE(sram, data);
 	DEBUGFS_ADD_FILE(log_event, data);
@@ -753,6 +852,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 #endif
 	DEBUGFS_ADD_FILE(thermal_throttling, data);
 	DEBUGFS_ADD_FILE(disable_ht40, data);
+	DEBUGFS_ADD_FILE(traffic_log, debug);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
@@ -794,6 +894,8 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_thermal_throttling);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_disable_ht40);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_traffic_log);
+	DEBUGFS_REMOVE(priv->dbgfs->dir_debug);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
 	if (((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965) ||
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 624656a..899b75f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -877,6 +877,8 @@ struct iwl_chain_noise_data {
 #define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
 #define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
 
+#define IWL_TRAFFIC_ENTRIES	(256)
+#define IWL_TRAFFIC_ENTRY_SIZE  (64)
 
 enum {
 	MEASUREMENT_READY = (1 << 0),
@@ -1182,6 +1184,10 @@ struct iwl_priv {
 	bool disable_ht40;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	/* debugfs */
+	u16 tx_traffic_idx;
+	u16 rx_traffic_idx;
+	u8 *tx_traffic;
+	u8 *rx_traffic;
 	struct iwl_debugfs *dbgfs;
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 #endif /* CONFIG_IWLWIFI_DEBUG */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 9e63f9d..5586003 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1063,6 +1063,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	if (unlikely(iwl_get_debug_level(priv) & IWL_DL_RX))
 		iwl_dbg_report_frame(priv, rx_start, len, header, 1);
 #endif
+	iwl_dbg_log_rx_data_frame(priv, len, header);
 	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, noise %d, qual %d, TSF %llu\n",
 		rx_status.signal, rx_status.noise, rx_status.qual,
 		(unsigned long long)rx_status.mactime);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 0cac06c..c85e54c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -808,6 +808,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* TODO need this for burst mode later on */
 	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id);
+	iwl_dbg_log_tx_data_frame(priv, len, hdr);
 
 	/* set is_hcca to 0; it probably will never be implemented */
 	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0babce2..4f5a3d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -598,7 +598,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	len = (u16)skb->len;
 	tx->len = cpu_to_le16(len);
 
-
+	iwl_dbg_log_tx_data_frame(priv, len, hdr);
 	tx->tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
 	tx->tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
 
@@ -3332,9 +3332,12 @@ static ssize_t store_debug_level(struct device *d,
 	ret = strict_strtoul(buf, 0, &val);
 	if (ret)
 		IWL_INFO(priv, "%s is not in hex or decimal form.\n", buf);
-	else
+	else {
 		priv->debug_level = val;
-
+		if (iwl_alloc_traffic_mem(priv))
+			IWL_ERR(priv,
+				"Not enough memory to generate traffic log\n");
+	}
 	return strnlen(buf, count);
 }
 
@@ -3976,6 +3979,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 #ifdef CONFIG_IWLWIFI_DEBUG
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
+	if (iwl_alloc_traffic_mem(priv))
+		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
 
 	/***************************
 	 * 2. Initializing PCI bus
@@ -4138,6 +4143,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	pci_disable_device(pdev);
  out_ieee80211_free_hw:
 	ieee80211_free_hw(priv->hw);
+	iwl_free_traffic_mem(priv);
  out:
 	return err;
 }
@@ -4193,6 +4199,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	 * until now... */
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
+	iwl_free_traffic_mem(priv);
 
 	free_irq(pdev->irq, priv);
 	pci_disable_msi(pdev);
-- 
1.5.6.3

