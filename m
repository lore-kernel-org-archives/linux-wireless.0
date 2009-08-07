Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1415 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZHGWly (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:54 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/16] iwlwifi: Traffic type and counter for debugFs
Date: Fri,  7 Aug 2009 15:41:40 -0700
Message-Id: <1249684912-22936-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Break down the traffic type and counter for both Tx and Rx.
Enhance the tx_statistics and rx_statistics debugfs function and move
to /sys/kernel/debug/ieee80211/phy0/iwlagn/debug directory to help
better debugging both driver and uCode related problems.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |  158 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |  129 ++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   48 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-led.c      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   10 +--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   11 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 11 files changed, 324 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index bfd509f..ae7f163 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -577,6 +577,8 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 	if (ieee80211_is_data(hdr->frame_control))
 		priv->rxtxpackets += len;
 #endif
+	iwl_update_stats(priv, false, hdr->frame_control, len);
+
 	memcpy(IEEE80211_SKB_RXCB(rxb->skb), stats, sizeof(*stats));
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb);
 	rxb->skb = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1ae2ce3..202bc39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -3051,6 +3051,164 @@ void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
 	}
 }
 EXPORT_SYMBOL(iwl_dbg_log_rx_data_frame);
+
+const char *get_mgmt_string(int cmd)
+{
+	switch (cmd) {
+		IWL_CMD(MANAGEMENT_ASSOC_REQ);
+		IWL_CMD(MANAGEMENT_ASSOC_RESP);
+		IWL_CMD(MANAGEMENT_REASSOC_REQ);
+		IWL_CMD(MANAGEMENT_REASSOC_RESP);
+		IWL_CMD(MANAGEMENT_PROBE_REQ);
+		IWL_CMD(MANAGEMENT_PROBE_RESP);
+		IWL_CMD(MANAGEMENT_BEACON);
+		IWL_CMD(MANAGEMENT_ATIM);
+		IWL_CMD(MANAGEMENT_DISASSOC);
+		IWL_CMD(MANAGEMENT_AUTH);
+		IWL_CMD(MANAGEMENT_DEAUTH);
+		IWL_CMD(MANAGEMENT_ACTION);
+	default:
+		return "UNKNOWN";
+
+	}
+}
+
+const char *get_ctrl_string(int cmd)
+{
+	switch (cmd) {
+		IWL_CMD(CONTROL_BACK_REQ);
+		IWL_CMD(CONTROL_BACK);
+		IWL_CMD(CONTROL_PSPOLL);
+		IWL_CMD(CONTROL_RTS);
+		IWL_CMD(CONTROL_CTS);
+		IWL_CMD(CONTROL_ACK);
+		IWL_CMD(CONTROL_CFEND);
+		IWL_CMD(CONTROL_CFENDACK);
+	default:
+		return "UNKNOWN";
+
+	}
+}
+
+void iwl_clear_tx_stats(struct iwl_priv *priv)
+{
+	memset(&priv->tx_stats, 0, sizeof(struct traffic_stats));
+
+}
+
+void iwl_clear_rx_stats(struct iwl_priv *priv)
+{
+	memset(&priv->rx_stats, 0, sizeof(struct traffic_stats));
+}
+
+/*
+ * if CONFIG_IWLWIFI_DEBUGFS defined, iwl_update_stats function will
+ * record all the MGMT, CTRL and DATA pkt for both TX and Rx pass.
+ * Use debugFs to display the rx/rx_statistics
+ * if CONFIG_IWLWIFI_DEBUGFS not being defined, then no MGMT and CTRL
+ * information will be recorded, but DATA pkt still will be recorded
+ * for the reason of iwl_led.c need to control the led blinking based on
+ * number of tx and rx data.
+ *
+ */
+void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
+{
+	struct traffic_stats	*stats;
+
+	if (is_tx)
+		stats = &priv->tx_stats;
+	else
+		stats = &priv->rx_stats;
+
+	if (ieee80211_is_mgmt(fc)) {
+		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
+		case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
+			stats->mgmt[MANAGEMENT_ASSOC_REQ]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP):
+			stats->mgmt[MANAGEMENT_ASSOC_RESP]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
+			stats->mgmt[MANAGEMENT_REASSOC_REQ]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_REASSOC_RESP):
+			stats->mgmt[MANAGEMENT_REASSOC_RESP]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_PROBE_REQ):
+			stats->mgmt[MANAGEMENT_PROBE_REQ]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
+			stats->mgmt[MANAGEMENT_PROBE_RESP]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_BEACON):
+			stats->mgmt[MANAGEMENT_BEACON]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_ATIM):
+			stats->mgmt[MANAGEMENT_ATIM]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
+			stats->mgmt[MANAGEMENT_DISASSOC]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_AUTH):
+			stats->mgmt[MANAGEMENT_AUTH]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
+			stats->mgmt[MANAGEMENT_DEAUTH]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_ACTION):
+			stats->mgmt[MANAGEMENT_ACTION]++;
+			break;
+		}
+	} else if (ieee80211_is_ctl(fc)) {
+		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
+		case cpu_to_le16(IEEE80211_STYPE_BACK_REQ):
+			stats->ctrl[CONTROL_BACK_REQ]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_BACK):
+			stats->ctrl[CONTROL_BACK]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_PSPOLL):
+			stats->ctrl[CONTROL_PSPOLL]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_RTS):
+			stats->ctrl[CONTROL_RTS]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_CTS):
+			stats->ctrl[CONTROL_CTS]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_ACK):
+			stats->ctrl[CONTROL_ACK]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_CFEND):
+			stats->ctrl[CONTROL_CFEND]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_CFENDACK):
+			stats->ctrl[CONTROL_CFENDACK]++;
+			break;
+		}
+	} else {
+		/* data */
+		stats->data_cnt++;
+		stats->data_bytes += len;
+	}
+}
+EXPORT_SYMBOL(iwl_update_stats);
+
+#else
+void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
+{
+	struct traffic_stats	*stats;
+
+	if (is_tx)
+		stats = &priv->tx_stats;
+	else
+		stats = &priv->rx_stats;
+
+	if (ieee80211_is_data(fc)) {
+		/* data */
+		stats->data_bytes += len;
+	}
+}
 #endif
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 40a9167..fc096b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -83,6 +83,8 @@ struct iwl_cmd;
 #define IWL_SKU_A       0x2
 #define IWL_SKU_N       0x8
 
+#define IWL_CMD(x) case x: return #x
+
 struct iwl_hcmd_ops {
 	int (*rxon_assoc)(struct iwl_priv *priv);
 	int (*commit_rxon)(struct iwl_priv *priv);
@@ -308,7 +310,10 @@ void iwl_dbg_log_tx_data_frame(struct iwl_priv *priv,
 				u16 length, struct ieee80211_hdr *header);
 void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
 				u16 length, struct ieee80211_hdr *header);
-
+const char *get_mgmt_string(int cmd);
+const char *get_ctrl_string(int cmd);
+void iwl_clear_tx_stats(struct iwl_priv *priv);
+void iwl_clear_rx_stats(struct iwl_priv *priv);
 #else
 static inline int iwl_alloc_traffic_mem(struct iwl_priv *priv)
 {
@@ -329,6 +334,8 @@ static inline void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
 {
 }
 #endif
+void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc,
+		      u16 len);
 /*****************************************************
  * RX handlers.
  * **************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 335ff5c..4ac06ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -78,8 +78,6 @@ struct iwl_debugfs {
 		struct dentry *file_sram;
 		struct dentry *file_nvm;
 		struct dentry *file_stations;
-		struct dentry *file_rx_statistics;
-		struct dentry *file_tx_statistics;
 		struct dentry *file_log_event;
 		struct dentry *file_channels;
 		struct dentry *file_status;
@@ -97,6 +95,8 @@ struct iwl_debugfs {
 		struct dentry *file_disable_tx_power;
 	} dbgfs_rf_files;
 	struct dir_debug_files {
+		struct dentry *file_rx_statistics;
+		struct dentry *file_tx_statistics;
 		struct dentry *file_traffic_log;
 	} dbgfs_debug_files;
 	u32 sram_offset;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 031538c..a0e5063 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -126,18 +126,58 @@ static ssize_t iwl_dbgfs_tx_statistics_read(struct file *file,
 						size_t count, loff_t *ppos) {
 
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
-	char buf[256];
+	char *buf;
 	int pos = 0;
-	const size_t bufsz = sizeof(buf);
 
-	pos += scnprintf(buf + pos, bufsz - pos, "mgmt: %u\n",
-						priv->tx_stats[0].cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "ctrl: %u\n",
-						priv->tx_stats[1].cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "data: %u\n",
-						priv->tx_stats[2].cnt);
+	int cnt;
+	ssize_t ret;
+	const size_t bufsz = 100 + sizeof(char) * 24 * (MANAGEMENT_MAX + CONTROL_MAX);
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	pos += scnprintf(buf + pos, bufsz - pos, "Management:\n");
+	for (cnt = 0; cnt < MANAGEMENT_MAX; cnt++) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "\t%s\t\t: %u\n",
+				 get_mgmt_string(cnt),
+				 priv->tx_stats.mgmt[cnt]);
+	}
+	pos += scnprintf(buf + pos, bufsz - pos, "Control\n");
+	for (cnt = 0; cnt < CONTROL_MAX; cnt++) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "\t%s\t\t: %u\n",
+				 get_ctrl_string(cnt),
+				 priv->tx_stats.ctrl[cnt]);
+	}
+	pos += scnprintf(buf + pos, bufsz - pos, "Data:\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "\tcnt: %u\n",
+			 priv->tx_stats.data_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "\tbytes: %llu\n",
+			 priv->tx_stats.data_bytes);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_tx_statistics_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	u32 clear_flag;
+	char buf[8];
+	int buf_size;
 
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%x", &clear_flag) != 1)
+		return -EFAULT;
+	if (clear_flag == 1)
+		iwl_clear_tx_stats(priv);
+
+	return count;
 }
 
 static ssize_t iwl_dbgfs_rx_statistics_read(struct file *file,
@@ -145,18 +185,59 @@ static ssize_t iwl_dbgfs_rx_statistics_read(struct file *file,
 						size_t count, loff_t *ppos) {
 
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
-	char buf[256];
+	char *buf;
 	int pos = 0;
-	const size_t bufsz = sizeof(buf);
+	int cnt;
+	ssize_t ret;
+	const size_t bufsz = 100 +
+		sizeof(char) * 24 * (MANAGEMENT_MAX + CONTROL_MAX);
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
-	pos += scnprintf(buf + pos, bufsz - pos, "mgmt: %u\n",
-						priv->rx_stats[0].cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "ctrl: %u\n",
-						priv->rx_stats[1].cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "data: %u\n",
-						priv->rx_stats[2].cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "Management:\n");
+	for (cnt = 0; cnt < MANAGEMENT_MAX; cnt++) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "\t%s\t\t: %u\n",
+				 get_mgmt_string(cnt),
+				 priv->rx_stats.mgmt[cnt]);
+	}
+	pos += scnprintf(buf + pos, bufsz - pos, "Control:\n");
+	for (cnt = 0; cnt < CONTROL_MAX; cnt++) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "\t%s\t\t: %u\n",
+				 get_ctrl_string(cnt),
+				 priv->rx_stats.ctrl[cnt]);
+	}
+	pos += scnprintf(buf + pos, bufsz - pos, "Data:\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "\tcnt: %u\n",
+			 priv->rx_stats.data_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "\tbytes: %llu\n",
+			 priv->rx_stats.data_bytes);
 
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_rx_statistics_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	u32 clear_flag;
+	char buf[8];
+	int buf_size;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%x", &clear_flag) != 1)
+		return -EFAULT;
+	if (clear_flag == 1)
+		iwl_clear_rx_stats(priv);
+	return count;
 }
 
 #define BYTE1_MASK 0x000000ff;
@@ -700,8 +781,6 @@ DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(nvm);
 DEBUGFS_READ_FILE_OPS(stations);
-DEBUGFS_READ_FILE_OPS(rx_statistics);
-DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_FILE_OPS(channels);
 DEBUGFS_READ_FILE_OPS(status);
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
@@ -808,6 +887,8 @@ static ssize_t iwl_dbgfs_traffic_log_write(struct file *file,
 	return count;
 }
 
+DEBUGFS_READ_WRITE_FILE_OPS(rx_statistics);
+DEBUGFS_READ_WRITE_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
 
 /*
@@ -841,8 +922,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(sram, data);
 	DEBUGFS_ADD_FILE(log_event, data);
 	DEBUGFS_ADD_FILE(stations, data);
-	DEBUGFS_ADD_FILE(rx_statistics, data);
-	DEBUGFS_ADD_FILE(tx_statistics, data);
 	DEBUGFS_ADD_FILE(channels, data);
 	DEBUGFS_ADD_FILE(status, data);
 	DEBUGFS_ADD_FILE(interrupt, data);
@@ -852,6 +931,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 #endif
 	DEBUGFS_ADD_FILE(thermal_throttling, data);
 	DEBUGFS_ADD_FILE(disable_ht40, data);
+	DEBUGFS_ADD_FILE(rx_statistics, debug);
+	DEBUGFS_ADD_FILE(tx_statistics, debug);
 	DEBUGFS_ADD_FILE(traffic_log, debug);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
@@ -879,8 +960,6 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 		return;
 
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_nvm);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_rx_statistics);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_tx_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_sram);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_log_event);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_stations);
@@ -894,6 +973,8 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_thermal_throttling);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_disable_ht40);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_rx_statistics);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_traffic_log);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_debug);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 899b75f..dcf9d57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -919,6 +919,48 @@ struct isr_statistics {
 	u32 unhandled;
 };
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+/* management statistics */
+enum iwl_mgmt_stats {
+	MANAGEMENT_ASSOC_REQ = 0,
+	MANAGEMENT_ASSOC_RESP,
+	MANAGEMENT_REASSOC_REQ,
+	MANAGEMENT_REASSOC_RESP,
+	MANAGEMENT_PROBE_REQ,
+	MANAGEMENT_PROBE_RESP,
+	MANAGEMENT_BEACON,
+	MANAGEMENT_ATIM,
+	MANAGEMENT_DISASSOC,
+	MANAGEMENT_AUTH,
+	MANAGEMENT_DEAUTH,
+	MANAGEMENT_ACTION,
+	MANAGEMENT_MAX,
+};
+/* control statistics */
+enum iwl_ctrl_stats {
+	CONTROL_BACK_REQ =  0,
+	CONTROL_BACK,
+	CONTROL_PSPOLL,
+	CONTROL_RTS,
+	CONTROL_CTS,
+	CONTROL_ACK,
+	CONTROL_CFEND,
+	CONTROL_CFENDACK,
+	CONTROL_MAX,
+};
+
+struct traffic_stats {
+	u32 mgmt[MANAGEMENT_MAX];
+	u32 ctrl[CONTROL_MAX];
+	u32 data_cnt;
+	u64 data_bytes;
+};
+#else
+struct traffic_stats {
+	u64 data_bytes;
+};
+#endif
+
 #define IWL_MAX_NUM_QUEUES	20 /* FIXME: do dynamic allocation */
 
 struct iwl_priv {
@@ -1064,10 +1106,8 @@ struct iwl_priv {
 	int last_rx_noise;	/* From beacon statistics */
 
 	/* counts mgmt, ctl, and data packets */
-	struct traffic_stats {
-		u32 cnt;
-		u64 bytes;
-	} tx_stats[3], rx_stats[3];
+	struct traffic_stats tx_stats;
+	struct traffic_stats rx_stats;
 
 	/* counts interrupts */
 	struct isr_statistics isr_stats;
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index b82ad15..532c8d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -36,8 +36,6 @@
 #include "iwl-core.h"
 
 
-#define IWL_CMD(x) case x: return #x
-
 const char *get_cmd_string(u8 cmd)
 {
 	switch (cmd) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 3d61cb4..f420c99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -272,7 +272,8 @@ static int iwl_get_blink_rate(struct iwl_priv *priv)
 	/* count both tx and rx traffic to be able to
 	 * handle traffic in either direction
 	 */
-	u64 current_tpt = priv->tx_stats[2].bytes + priv->rx_stats[2].bytes;
+	u64 current_tpt = priv->tx_stats.data_bytes +
+			  priv->rx_stats.data_bytes;
 	s64 tpt = current_tpt - priv->led_tpt;
 
 	if (tpt < 0) /* wraparound */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 5586003..43b2fce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -745,14 +745,6 @@ static void iwl_dbg_report_frame(struct iwl_priv *priv,
 }
 #endif
 
-static void iwl_update_rx_stats(struct iwl_priv *priv, u16 fc, u16 len)
-{
-	/* 0 - mgmt, 1 - cnt, 2 - data */
-	int idx = (fc & IEEE80211_FCTL_FTYPE) >> 2;
-	priv->rx_stats[idx].cnt++;
-	priv->rx_stats[idx].bytes += len;
-}
-
 /*
  * returns non-zero if packet should be dropped
  */
@@ -930,7 +922,7 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
 		return;
 
-	iwl_update_rx_stats(priv, le16_to_cpu(hdr->frame_control), len);
+	iwl_update_stats(priv, false, hdr->frame_control, len);
 	memcpy(IEEE80211_SKB_RXCB(rxb->skb), stats, sizeof(*stats));
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb);
 	priv->alloc_rxb_skb--;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index c85e54c..9b76bd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -668,14 +668,6 @@ static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 	}
 }
 
-static void iwl_update_tx_stats(struct iwl_priv *priv, u16 fc, u16 len)
-{
-	/* 0 - mgmt, 1 - cnt, 2 - data */
-	int idx = (fc & IEEE80211_FCTL_FTYPE) >> 2;
-	priv->tx_stats[idx].cnt++;
-	priv->tx_stats[idx].bytes += len;
-}
-
 /*
  * start REPLY_TX command process
  */
@@ -813,8 +805,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* set is_hcca to 0; it probably will never be implemented */
 	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0);
 
-	iwl_update_tx_stats(priv, le16_to_cpu(fc), len);
-
+	iwl_update_stats(priv, true, fc, len);
 	/*
 	 * Use the first empty entry in this queue's command buffer array
 	 * to contain the Tx command and MAC header concatenated together
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4f5a3d0..e5fa672 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -599,6 +599,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	tx->len = cpu_to_le16(len);
 
 	iwl_dbg_log_tx_data_frame(priv, len, hdr);
+	iwl_update_stats(priv, true, fc, len);
 	tx->tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
 	tx->tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
 
-- 
1.5.6.3

