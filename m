Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:61684 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaJBMEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 08:04:47 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/4] ath10k: Add support to configure pktlog filter
Date: Thu, 2 Oct 2014 17:36:07 +0530
Message-ID: <1412251570-31096-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141002_140452_572838_D68003A2)
In-Reply-To: <1412251570-31096-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1412251570-31096-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to configure packet log filters (tx, rx, rate control)
via debugfs. To disable htt pktlog events set the filters to 0.

ex:

To enable pktlog for all filters

   echo 0x1f > /sys/kernel/debug/ieee80211/phy*/ath10k/pktlog_filter

To disable pktlog

   echo 0 > /sys/kernel/debug/ieee80211/phy*/ath10k/pktlog_filter

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  2 ++
 drivers/net/wireless/ath/ath10k/debug.c | 63 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/debug.h |  9 +++++
 drivers/net/wireless/ath/ath10k/wmi.c   | 33 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h   |  6 ++++
 5 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 674e38c..f361226 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -302,7 +302,9 @@ struct ath10k_debug {
 	struct ath10k_dfs_stats dfs_stats;
 	struct ath_dfs_pool_stats dfs_pool_stats;
 
+	/* protected by conf_mutex */
 	u32 fw_dbglog_mask;
+	u32 pktlog_filter;
 
 	u8 htt_max_amsdu;
 	u8 htt_max_ampdu;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 680d508..48672da 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1195,7 +1195,17 @@ int ath10k_debug_start(struct ath10k *ar)
 				    ret);
 	}
 
-	return 0;
+	if (ar->debug.pktlog_filter)
+		ret = ath10k_wmi_pdev_pktlog_enable(ar,
+						    ar->debug.pktlog_filter);
+	else
+		ret = ath10k_wmi_pdev_pktlog_disable(ar);
+
+	if (ret)
+		ath10k_warn(ar, "failed to send pktlog command: %d filter %x",
+			    ret, ar->debug.pktlog_filter);
+
+	return ret;
 }
 
 void ath10k_debug_stop(struct ath10k *ar)
@@ -1292,6 +1302,54 @@ static const struct file_operations fops_dfs_stats = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_write_pktlog_filter(struct file *file,
+					  const char __user *ubuf,
+					  size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u32 filter;
+	int ret;
+
+	if (kstrtouint_from_user(ubuf, count, 0, &filter))
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+	if (filter && (filter != ar->debug.pktlog_filter))
+		ret = ath10k_wmi_pdev_pktlog_enable(ar, filter);
+	else
+		ret = ath10k_wmi_pdev_pktlog_disable(ar);
+
+	ar->debug.pktlog_filter = filter;
+	mutex_unlock(&ar->conf_mutex);
+
+	if (ret)
+		ath10k_warn(ar, "failed to send pktlog command: %d filter %x",
+			    ret, ar->debug.pktlog_filter);
+
+	return count;
+}
+
+static ssize_t ath10k_read_pktlog_filter(struct file *file, char __user *ubuf,
+					 size_t count, loff_t *ppos)
+{
+	char buf[32];
+	struct ath10k *ar = file->private_data;
+	int len = 0;
+
+	mutex_lock(&ar->conf_mutex);
+	len = scnprintf(buf, sizeof(buf) - len, "%08x\n",
+			ar->debug.pktlog_filter);
+	mutex_unlock(&ar->conf_mutex);
+
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_pktlog_filter = {
+	.read = ath10k_read_pktlog_filter,
+	.write = ath10k_write_pktlog_filter,
+	.open = simple_open
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
@@ -1370,6 +1428,9 @@ int ath10k_debug_register(struct ath10k *ar)
 				    &fops_dfs_stats);
 	}
 
+	debugfs_create_file("pktlog_filter", S_IRUGO | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_pktlog_filter);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index efbcd29..794e6bb 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -38,6 +38,15 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 
+enum ath10k_pktlog_filter {
+	ATH10K_PKTLOG_RX         = 0x000000001,
+	ATH10K_PKTLOG_TX         = 0x000000002,
+	ATH10K_PKTLOG_RCFIND     = 0x000000004,
+	ATH10K_PKTLOG_RCUPDATE   = 0x000000008,
+	ATH10K_PKTLOG_DBG_PRINT  = 0x000000010,
+	ATH10K_PKTLOG_ANY        = 0x00000001f,
+};
+
 extern unsigned int ath10k_debug_mask;
 
 __printf(2, 3) void ath10k_info(struct ath10k *ar, const char *fmt, ...);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f65032f..c145b98 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4345,6 +4345,39 @@ int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->dbglog_cfg_cmdid);
 }
 
+int ath10k_wmi_pdev_pktlog_enable(struct ath10k *ar, u32 ev_bitmap)
+{
+	struct wmi_pdev_pktlog_enable_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	ev_bitmap &= ATH10K_PKTLOG_ANY;
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi enable pktlog filter:%x\n", ev_bitmap);
+
+	cmd = (struct wmi_pdev_pktlog_enable_cmd *)skb->data;
+	cmd->ev_bitmap = __cpu_to_le32(ev_bitmap);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_pktlog_enable_cmdid);
+}
+
+int ath10k_wmi_pdev_pktlog_disable(struct ath10k *ar)
+{
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, 0);
+	if (!skb)
+		return -ENOMEM;
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi disable pktlog\n");
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_pktlog_disable_cmdid);
+}
+
 int ath10k_wmi_attach(struct ath10k *ar)
 {
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 6243dbe..a38d788 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2787,6 +2787,10 @@ struct wmi_pdev_set_channel_cmd {
 	struct wmi_channel chan;
 } __packed;
 
+struct wmi_pdev_pktlog_enable_cmd {
+	__le32 ev_bitmap;
+} __packed;
+
 /* Customize the DSCP (bit) to TID (0-7) mapping for QOS */
 #define WMI_DSCP_MAP_MAX    (64)
 struct wmi_pdev_set_dscp_tid_map_cmd {
@@ -4647,5 +4651,7 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable);
 int ath10k_wmi_pull_fw_stats(struct ath10k *ar, struct sk_buff *skb,
 			     struct ath10k_fw_stats *stats);
+int ath10k_wmi_pdev_pktlog_enable(struct ath10k *ar, u32 ev_list);
+int ath10k_wmi_pdev_pktlog_disable(struct ath10k *ar);
 
 #endif /* _WMI_H_ */
-- 
2.1.1

