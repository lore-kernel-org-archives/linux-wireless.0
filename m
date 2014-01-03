Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:60087 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaACLIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 06:08:53 -0500
Subject: [PATCH 3/3] ath10k: add debugfs file to control firmware dbglog
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 03 Jan 2014 12:59:31 +0200
Message-ID: <20140103105931.13474.73974.stgit@potku.adurom.net> (sfid-20140103_120901_195338_F36E29C4)
In-Reply-To: <20140103105718.13474.70922.stgit@potku.adurom.net>
References: <20140103105718.13474.70922.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware dbglogs can be now enabled through fw_dbglog file. To enable all
possible log messages run:

echo 0xffffffff > /sys/kernel/debug/ieee80211/phy0/ath10k/fw_dbglog

And to put back firmare defaults use 0x0:

echo 0x0 > /sys/kernel/debug/ieee80211/phy0/ath10k/fw_dbglog

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |    2 +
 drivers/net/wireless/ath/ath10k/debug.c |   66 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c   |   37 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h   |   49 +++++++++++++++++++++++
 4 files changed, 154 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 035cbf6..a577067 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -272,6 +272,8 @@ struct ath10k_debug {
 	struct delayed_work htt_stats_dwork;
 	struct ath10k_dfs_stats dfs_stats;
 	struct ath_dfs_pool_stats dfs_pool_stats;
+
+	u32 fw_dbglog_mask;
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 6bdfad3..6debd28 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -614,6 +614,61 @@ static const struct file_operations fops_htt_stats_mask = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_read_fw_dbglog(struct file *file,
+					    char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	unsigned int len;
+	char buf[32];
+
+	len = scnprintf(buf, sizeof(buf), "0x%08x\n",
+			ar->debug.fw_dbglog_mask);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath10k_write_fw_dbglog(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	unsigned long mask;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 0, &mask);
+	if (ret)
+		return ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ar->debug.fw_dbglog_mask = mask;
+
+	if (ar->state == ATH10K_STATE_ON) {
+		ret = ath10k_wmi_dbglog_cfg(ar, ar->debug.fw_dbglog_mask);
+		if (ret) {
+			ath10k_warn("dbglog cfg failed from debugfs: %d\n",
+				    ret);
+			goto exit;
+		}
+	}
+
+	ret = count;
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+
+	return ret;
+}
+
+static const struct file_operations fops_fw_dbglog = {
+	.read = ath10k_read_fw_dbglog,
+	.write = ath10k_write_fw_dbglog,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath10k_debug_start(struct ath10k *ar)
 {
 	int ret;
@@ -625,6 +680,14 @@ int ath10k_debug_start(struct ath10k *ar)
 		/* continue normally anyway, this isn't serious */
 		ath10k_warn("failed to start htt stats workqueue: %d\n", ret);
 
+	if (ar->debug.fw_dbglog_mask) {
+		ret = ath10k_wmi_dbglog_cfg(ar, ar->debug.fw_dbglog_mask);
+		if (ret)
+			/* not serious */
+			ath10k_warn("failed to enable dbglog during start: %d",
+				    ret);
+	}
+
 	return 0;
 }
 
@@ -747,6 +810,9 @@ int ath10k_debug_create(struct ath10k *ar)
 	debugfs_create_file("htt_stats_mask", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_htt_stats_mask);
 
+	debugfs_create_file("fw_dbglog", S_IRUSR, ar->debug.debugfs_phy,
+			    ar, &fops_fw_dbglog);
+
 	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED)) {
 		debugfs_create_file("dfs_simulate_radar", S_IWUSR,
 				    ar->debug.debugfs_phy, ar,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 4e043bb..712a606 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3502,3 +3502,40 @@ int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 		   type, delay_ms);
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->force_fw_hang_cmdid);
 }
+
+int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable)
+{
+	struct wmi_dbglog_cfg_cmd *cmd;
+	struct sk_buff *skb;
+	u32 cfg;
+
+	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_dbglog_cfg_cmd *)skb->data;
+
+	if (module_enable) {
+		cfg = SM(ATH10K_DBGLOG_LEVEL_VERBOSE,
+			 ATH10K_DBGLOG_CFG_LOG_LVL);
+	} else {
+		/* set back defaults, all modules with WARN level */
+		cfg = SM(ATH10K_DBGLOG_LEVEL_WARN,
+			 ATH10K_DBGLOG_CFG_LOG_LVL);
+		module_enable = ~0;
+	}
+
+	cmd->module_enable = __cpu_to_le32(module_enable);
+	cmd->module_valid = __cpu_to_le32(~0);
+	cmd->config_enable = __cpu_to_le32(cfg);
+	cmd->config_valid = __cpu_to_le32(ATH10K_DBGLOG_CFG_LOG_LVL_MASK);
+
+	ath10k_dbg(ATH10K_DBG_WMI,
+		   "wmi dbglog cfg modules %08x %08x config %08x %08x\n",
+		   __le32_to_cpu(cmd->module_enable),
+		   __le32_to_cpu(cmd->module_valid),
+		   __le32_to_cpu(cmd->config_enable),
+		   __le32_to_cpu(cmd->config_valid));
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->dbglog_cfg_cmdid);
+}
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 0087d69..4aa1489 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4090,6 +4090,54 @@ struct wmi_force_fw_hang_cmd {
 	__le32 delay_ms;
 } __packed;
 
+enum ath10k_dbglog_level {
+	ATH10K_DBGLOG_LEVEL_VERBOSE = 0,
+	ATH10K_DBGLOG_LEVEL_INFO = 1,
+	ATH10K_DBGLOG_LEVEL_WARN = 2,
+	ATH10K_DBGLOG_LEVEL_ERR = 3,
+};
+
+/* VAP ids to enable dbglog */
+#define ATH10K_DBGLOG_CFG_VAP_LOG_LSB		0
+#define ATH10K_DBGLOG_CFG_VAP_LOG_MASK		0x0000ffff
+
+/* to enable dbglog in the firmware */
+#define ATH10K_DBGLOG_CFG_REPORTING_ENABLE_LSB	16
+#define ATH10K_DBGLOG_CFG_REPORTING_ENABLE_MASK	0x00010000
+
+/* timestamp resolution */
+#define ATH10K_DBGLOG_CFG_RESOLUTION_LSB	17
+#define ATH10K_DBGLOG_CFG_RESOLUTION_MASK	0x000E0000
+
+/* number of queued messages before sending them to the host */
+#define ATH10K_DBGLOG_CFG_REPORT_SIZE_LSB	20
+#define ATH10K_DBGLOG_CFG_REPORT_SIZE_MASK	0x0ff00000
+
+/*
+ * Log levels to enable. This defines the minimum level to enable, this is
+ * not a bitmask. See enum ath10k_dbglog_level for the values.
+ */
+#define ATH10K_DBGLOG_CFG_LOG_LVL_LSB		28
+#define ATH10K_DBGLOG_CFG_LOG_LVL_MASK		0x70000000
+
+/*
+ * Note: this is a cleaned up version of a struct firmware uses. For
+ * example, config_valid was hidden inside an array.
+ */
+struct wmi_dbglog_cfg_cmd {
+	/* bitmask to hold mod id config*/
+	__le32 module_enable;
+
+	/* see ATH10K_DBGLOG_CFG_ */
+	__le32 config_enable;
+
+	/* mask of module id bits to be changed */
+	__le32 module_valid;
+
+	/* mask of config bits to be changed, see ATH10K_DBGLOG_CFG_ */
+	__le32 config_valid;
+} __packed;
+
 #define ATH10K_RTS_MAX		2347
 #define ATH10K_FRAGMT_THRESHOLD_MIN	540
 #define ATH10K_FRAGMT_THRESHOLD_MAX	2346
@@ -4167,5 +4215,6 @@ int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id);
 int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 			     enum wmi_force_fw_hang_type type, u32 delay_ms);
 int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb);
+int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable);
 
 #endif /* _WMI_H_ */

