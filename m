Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:3699 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaKYUCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 15:02:48 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath10k: add new wmi interface of NF cal period
Date: Tue, 25 Nov 2014 12:02:45 -0800
Message-ID: <1416945765-26902-2-git-send-email-poh@qca.qualcomm.com> (sfid-20141125_210305_098792_9CB978FB)
In-Reply-To: <1416945765-26902-1-git-send-email-poh@qca.qualcomm.com>
References: <1416945765-26902-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce a new wmi interface controls noise floor (NF) calibration
period via debugfs as firmware has introduced it on v10.2.

It allows users to modify frequency of NF calibration in millisecond
and changes RSSI reporting frequency consequently.
Short calibration period will trigger more frequent NF calibration,
so that RSSI reported in receive frames is more realistic.

Till now calibration was done at 30 seconds.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  1 +
 drivers/net/wireless/ath/ath10k/debug.c | 64 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c   |  2 ++
 drivers/net/wireless/ath/ath10k/wmi.h   |  1 +
 4 files changed, 68 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8f86bd3..5de988c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -320,6 +320,7 @@ struct ath10k_debug {
 	/* protected by conf_mutex */
 	u32 fw_dbglog_mask;
 	u32 pktlog_filter;
+	u32 fw_cal_period;
 
 	u8 htt_max_amsdu;
 	u8 htt_max_ampdu;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f10721d..d8426fd 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1381,6 +1381,67 @@ static const struct file_operations fops_cal_data = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_read_cal_period(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	unsigned int len;
+	char buf[32];
+
+	len = scnprintf(buf, sizeof(buf), "%d\n",
+			ar->debug.fw_cal_period);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath10k_write_cal_period(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	unsigned long period;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 0, &period);
+	if (ret)
+		return ret;
+	/* period unit in millisecond */
+	if (period < 1 || period > 60000)
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ar->debug.fw_cal_period = period;
+
+	if (ar->state == ATH10K_STATE_ON) {
+		ret = ath10k_wmi_pdev_set_param
+			(ar, ar->wmi.pdev_param->cal_period,
+			ar->debug.fw_cal_period);
+		if (ret) {
+			ath10k_warn
+				(ar, "cal period cfg failed from debugfs: %d\n",
+				ret);
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
+static const struct file_operations fops_cal_period = {
+	.read = ath10k_read_cal_period,
+	.write = ath10k_write_cal_period,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath10k_debug_start(struct ath10k *ar)
 {
 	int ret;
@@ -1645,6 +1706,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("cal_data", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_cal_data);
 
+	debugfs_create_file("cal_period", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_cal_period);
+
 	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED)) {
 		debugfs_create_file("dfs_simulate_radar", S_IWUSR,
 				    ar->debug.debugfs_phy, ar,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c300a53..b144b39 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -434,6 +434,7 @@ static struct wmi_pdev_param_map wmi_pdev_param_map = {
 	.fast_channel_reset = WMI_PDEV_PARAM_UNSUPPORTED,
 	.burst_dur = WMI_PDEV_PARAM_UNSUPPORTED,
 	.burst_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+	.cal_period = WMI_PDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_pdev_param_map wmi_10x_pdev_param_map = {
@@ -486,6 +487,7 @@ static struct wmi_pdev_param_map wmi_10x_pdev_param_map = {
 	.fast_channel_reset = WMI_10X_PDEV_PARAM_FAST_CHANNEL_RESET,
 	.burst_dur = WMI_10X_PDEV_PARAM_BURST_DUR,
 	.burst_enable = WMI_10X_PDEV_PARAM_BURST_ENABLE,
+	.cal_period = WMI_10X_PDEV_PARAM_CAL_PERIOD,
 };
 
 /* firmware 10.2 specific mappings */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 8fa0192..fe35ba9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2497,6 +2497,7 @@ struct wmi_pdev_param_map {
 	u32 fast_channel_reset;
 	u32 burst_dur;
 	u32 burst_enable;
+	u32 cal_period; /* valid period is 1 ~ 60000ms */
 };
 
 #define WMI_PDEV_PARAM_UNSUPPORTED 0
-- 
1.9.1

