Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12052 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaLBLHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 06:07:38 -0500
Subject: [PATCH v2 2/2] ath10k: add new wmi interface of NF cal period
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 2 Dec 2014 13:07:14 +0200
Message-ID: <20141202110714.14817.48208.stgit@potku.adurom.net> (sfid-20141202_120741_009028_C6087EB3)
In-Reply-To: <20141202110443.14817.85639.stgit@potku.adurom.net>
References: <20141202110443.14817.85639.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peter Oh <poh@qca.qualcomm.com>

Introduce a new wmi interface controls noise floor (NF) calibration
period via debugfs as firmware has introduced it on v10.2.

It allows users to modify frequency of NF calibration in millisecond
and changes RSSI reporting frequency consequently.
Short calibration period will trigger more frequent NF calibration,
so that RSSI reported in receive frames is more realistic.

Till now calibration was done at 30 seconds.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h    |    1 
 drivers/net/wireless/ath/ath10k/debug.c   |   80 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    1 
 drivers/net/wireless/ath/ath10k/wmi.c     |    2 +
 drivers/net/wireless/ath/ath10k/wmi.h     |    4 +
 5 files changed, 88 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 796ac8f3a654..1002689d8a89 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -327,6 +327,7 @@ struct ath10k_debug {
 	u32 fw_dbglog_mask;
 	u32 pktlog_filter;
 	u32 reg_addr;
+	u32 nf_cal_period;
 
 	u8 htt_max_amsdu;
 	u8 htt_max_ampdu;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index c15b5774dd20..70a9599aeb7a 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1608,6 +1608,73 @@ static const struct file_operations fops_cal_data = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_read_nf_cal_period(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	unsigned int len;
+	char buf[32];
+
+	len = scnprintf(buf, sizeof(buf), "%d\n",
+			ar->debug.nf_cal_period);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath10k_write_nf_cal_period(struct file *file,
+					  const char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	unsigned long period;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 0, &period);
+	if (ret)
+		return ret;
+
+	if (period > WMI_PDEV_PARAM_CAL_PERIOD_MAX)
+		return -EINVAL;
+
+	/* there's no way to switch back to the firmware default */
+	if (period == 0)
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ar->debug.nf_cal_period = period;
+
+	if (ar->state != ATH10K_STATE_ON) {
+		/* firmware is not running, nothing else to do */
+		ret = count;
+		goto exit;
+	}
+
+	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->cal_period,
+					ar->debug.nf_cal_period);
+	if (ret) {
+		ath10k_warn(ar, "cal period cfg failed from debugfs: %d\n",
+			    ret);
+		goto exit;
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
+static const struct file_operations fops_nf_cal_period = {
+	.read = ath10k_read_nf_cal_period,
+	.write = ath10k_write_nf_cal_period,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath10k_debug_start(struct ath10k *ar)
 {
 	int ret;
@@ -1643,6 +1710,16 @@ int ath10k_debug_start(struct ath10k *ar)
 			ath10k_warn(ar, "failed to disable pktlog: %d\n", ret);
 	}
 
+	if (ar->debug.nf_cal_period) {
+		ret = ath10k_wmi_pdev_set_param(ar,
+						ar->wmi.pdev_param->cal_period,
+						ar->debug.nf_cal_period);
+		if (ret)
+			/* not serious */
+			ath10k_warn(ar, "cal period cfg failed from debug start: %d\n",
+				    ret);
+	}
+
 	return ret;
 }
 
@@ -1881,6 +1958,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("cal_data", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_cal_data);
 
+	debugfs_create_file("nf_cal_period", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_nf_cal_period);
+
 	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED)) {
 		debugfs_create_file("dfs_simulate_radar", S_IWUSR,
 				    ar->debug.debugfs_phy, ar,
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index b21048c2a52e..1627ec58a229 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2096,6 +2096,7 @@ static struct wmi_pdev_param_map wmi_tlv_pdev_param_map = {
 	.fast_channel_reset = WMI_TLV_PDEV_PARAM_UNSUPPORTED,
 	.burst_dur = WMI_TLV_PDEV_PARAM_BURST_DUR,
 	.burst_enable = WMI_TLV_PDEV_PARAM_BURST_ENABLE,
+	.cal_period = WMI_PDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_vdev_param_map wmi_tlv_vdev_param_map = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ca46146d7718..024be2b269d5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -436,6 +436,7 @@ static struct wmi_pdev_param_map wmi_pdev_param_map = {
 	.fast_channel_reset = WMI_PDEV_PARAM_UNSUPPORTED,
 	.burst_dur = WMI_PDEV_PARAM_UNSUPPORTED,
 	.burst_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+	.cal_period = WMI_PDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_pdev_param_map wmi_10x_pdev_param_map = {
@@ -488,6 +489,7 @@ static struct wmi_pdev_param_map wmi_10x_pdev_param_map = {
 	.fast_channel_reset = WMI_10X_PDEV_PARAM_FAST_CHANNEL_RESET,
 	.burst_dur = WMI_10X_PDEV_PARAM_BURST_DUR,
 	.burst_enable = WMI_10X_PDEV_PARAM_BURST_ENABLE,
+	.cal_period = WMI_10X_PDEV_PARAM_CAL_PERIOD,
 };
 
 /* firmware 10.2 specific mappings */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4b31da5d3c4c..97f902f03ec5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2583,6 +2583,7 @@ struct wmi_pdev_param_map {
 	u32 fast_channel_reset;
 	u32 burst_dur;
 	u32 burst_enable;
+	u32 cal_period;
 };
 
 #define WMI_PDEV_PARAM_UNSUPPORTED 0
@@ -2803,6 +2804,9 @@ struct wmi_pdev_set_param_cmd {
 	__le32 param_value;
 } __packed;
 
+/* valid period is 1 ~ 60000ms, unit in millisecond */
+#define WMI_PDEV_PARAM_CAL_PERIOD_MAX 60000
+
 struct wmi_pdev_get_tpc_config_cmd {
 	/* parameter   */
 	__le32 param;

