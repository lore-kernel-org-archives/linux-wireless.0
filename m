Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22094 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbbE1TZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 15:25:40 -0400
From: Yanbo Li <yanbol@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath10k: Add the adjacent wlan radio interference detecting interface
Date: Thu, 28 May 2015 12:23:05 -0700
Message-ID: <1432840986-21918-1-git-send-email-yanbol@qca.qualcomm.com> (sfid-20150528_212544_564690_A5D3F1F8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some platforms integrate several radios together. When one radio wants to
spectral scan the currently channel, the adjacent radio's activity will
introduce some interference in the spectral scan result. To combat the
problem, enable the FW to set a special mark within the spectral scan
results. Using such a mark the user who is processing the data can identify
whether the data has been introduced to interference by the adjacent radio
during that period. The user can interpret more accurate spectral scan results
given marks where interference occurred.

This technique requires the preconditions that the scanning and adjacent radio
have some physical connection to make them aware of each other's activity
from within the FW layer, and the FW claimed supporting this capability.

To enable this feature, execute:
echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/adjacent_wlan_interfrc

Then run the spectral scan steps.
...
To check whether the spectral scan data be interfered, execute:

cat /sys/kernel/debug/ieee80211/phyX/ath10k/adjacent_wlan_interfrc

INTERFRC DETECT FOR SPEC SCAN: Enable/Disable
	5G_interference: X/0
	2G_Interference: X/0
X means the interference number in the scan period, 0 means no interference.
These counters will be reset when next round spectral scan be triggered

Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h     |  8 ++++
 drivers/net/wireless/ath/ath10k/debug.c    | 65 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/spectral.c | 14 +++++++
 drivers/net/wireless/ath/ath10k/wmi.c      |  6 +++
 drivers/net/wireless/ath/ath10k/wmi.h      | 10 +++++
 5 files changed, 103 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4a84e17016c9..fb0e8521fc45 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -489,6 +489,10 @@ enum ath10k_cal_mode {
 	ATH10K_CAL_MODE_DT,
 };
 
+enum ath10k_wlan_interfrc_mask {
+	ATH10K_SPECTRAL_INTERFRC	= 0x00000001,
+};
+
 static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
 {
 	switch (mode) {
@@ -709,6 +713,8 @@ struct ath10k {
 		/* spectral_mode and spec_config are protected by conf_mutex */
 		enum ath10k_spectral_mode mode;
 		struct ath10k_spec_scan config;
+		u32 interfrc_5g;
+		u32 interfrc_2g;
 	} spectral;
 
 	struct {
@@ -729,6 +735,8 @@ struct ath10k {
 	} stats;
 
 	bool btc_feature;
+	/* Detect the adjacent wifi radio interference */
+	enum ath10k_wlan_interfrc_mask wlan_interfrc_mask;
 
 	struct ath10k_thermal thermal;
 	struct ath10k_wow wow;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 820a12bc0dd8..534dfb8ada95 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2142,6 +2142,66 @@ static const struct file_operations fops_btc_feature = {
 	.open = simple_open
 };
 
+static ssize_t ath10k_write_adjacent_wlan_interfrc(struct file *file,
+						   const char __user *ubuf,
+						   size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u32 flag;
+
+	if (kstrtouint_from_user(ubuf, count, 0, &flag))
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+	if (flag != ar->wlan_interfrc_mask) {
+		ar->wlan_interfrc_mask = flag;
+		queue_work(ar->workqueue, &ar->restart_work);
+	}
+	mutex_unlock(&ar->conf_mutex);
+
+	return count;
+}
+
+#define ATH10K_WLAN_INTFRC_REPORT_SIZE	256
+
+static ssize_t ath10k_read_adjacent_wlan_interfrc(struct file *file,
+						  char __user *ubuf,
+						  size_t count, loff_t *ppos)
+{
+	char buf[ATH10K_WLAN_INTFRC_REPORT_SIZE];
+	struct ath10k *ar = file->private_data;
+	unsigned int len = 0;
+	unsigned int buf_len = ATH10K_WLAN_INTFRC_REPORT_SIZE;
+	u32 interfrc_5g, interfrc_2g;
+
+	mutex_lock(&ar->conf_mutex);
+
+	len += scnprintf(buf, buf_len,
+			 "INTERFRC DETECT FOR SPEC SCAN: %s\n",
+			 ar->wlan_interfrc_mask & ATH10K_SPECTRAL_INTERFRC ?
+			 "Enable" : "Disable");
+
+	spin_lock_bh(&ar->data_lock);
+	interfrc_5g = ar->spectral.interfrc_5g;
+	interfrc_2g = ar->spectral.interfrc_2g;
+	spin_unlock_bh(&ar->data_lock);
+
+	len += scnprintf(buf + len, buf_len - len, "5G INTERFRC: %d\n",
+			 interfrc_5g);
+	len += scnprintf(buf + len, buf_len - len, "2G INTERFRC: %d\n",
+			 interfrc_2g);
+
+	mutex_unlock(&ar->conf_mutex);
+
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_adjacent_wlan_interfrc = {
+	.read = ath10k_read_adjacent_wlan_interfrc,
+	.write = ath10k_write_adjacent_wlan_interfrc,
+	.open = simple_open
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
@@ -2247,6 +2307,11 @@ int ath10k_debug_register(struct ath10k *ar)
 
 	debugfs_create_file("btc_feature", S_IRUGO | S_IWUSR,
 			    ar->debug.debugfs_phy, ar, &fops_btc_feature);
+
+	debugfs_create_file("adjacent_wlan_interfrc", S_IRUGO | S_IWUSR,
+			    ar->debug.debugfs_phy, ar,
+			    &fops_adjacent_wlan_interfrc);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
index 8dcd424aa502..35892409ec6a 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.c
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -76,6 +76,15 @@ int ath10k_spectral_process_fft(struct ath10k *ar,
 	reg0 = __le32_to_cpu(fftr->reg0);
 	reg1 = __le32_to_cpu(fftr->reg1);
 
+	spin_lock_bh(&ar->data_lock);
+	if (phyerr->phy_err_code == PHY_ERROR_SPECTRAL_SCAN) {
+		if (phyerr->rsvd0 & PHYERR_FLAG_INTERFRC_5G)
+			ar->spectral.interfrc_5g++;
+		if (phyerr->rsvd0 & PHYERR_FLAG_INTERFRC_2G)
+			ar->spectral.interfrc_2g++;
+	}
+	spin_unlock_bh(&ar->data_lock);
+
 	length = sizeof(*fft_sample) - sizeof(struct fft_sample_tlv) + bin_len;
 	fft_sample->tlv.type = ATH_FFT_SAMPLE_ATH10K;
 	fft_sample->tlv.length = __cpu_to_be16(length);
@@ -318,6 +327,11 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 			 */
 			res = ath10k_spectral_scan_config(ar,
 							  ar->spectral.mode);
+			spin_lock_bh(&ar->data_lock);
+			ar->spectral.interfrc_5g = 0;
+			ar->spectral.interfrc_2g = 0;
+			spin_unlock_bh(&ar->data_lock);
+
 			if (res < 0) {
 				ath10k_warn(ar, "failed to reconfigure spectral scan: %d\n",
 					    res);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index e3c880230ee6..1fb850817589 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3936,6 +3936,12 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	if (ar->btc_feature &&
 	    test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
 		features |= WMI_10_2_COEX_GPIO;
+
+	if ((ar->wlan_interfrc_mask & ATH10K_SPECTRAL_INTERFRC) &&
+	    (test_bit(WMI_SERVICE_ADJ_RADIO_SPECTRAL_INTERFRC,
+		      ar->wmi.svc_map)))
+		features |= WMI_10_2_ADJ_RADIO_SPECTRAL_INTERFRC;
+
 	cmd->resource_config.feature_mask = __cpu_to_le32(features);
 
 	memcpy(&cmd->resource_config.common, &config, sizeof(config));
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index cad72ae76253..36bb0768d87f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -150,6 +150,7 @@ enum wmi_service {
 	WMI_SERVICE_SAP_AUTH_OFFLOAD,
 	WMI_SERVICE_ATF,
 	WMI_SERVICE_COEX_GPIO,
+	WMI_SERVICE_ADJ_RADIO_SPECTRAL_INTERFRC,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -181,6 +182,7 @@ enum wmi_10x_service {
 	WMI_10X_SERVICE_SMART_ANTENNA_HW_SUPPORT,
 	WMI_10X_SERVICE_ATF,
 	WMI_10X_SERVICE_COEX_GPIO,
+	WMI_10X_SERVICE_ADJ_RADIO_SPECTRAL_INTERFRC,
 };
 
 enum wmi_main_service {
@@ -299,6 +301,8 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_SAP_AUTH_OFFLOAD);
 	SVCSTR(WMI_SERVICE_ATF);
 	SVCSTR(WMI_SERVICE_COEX_GPIO);
+	SVCSTR(WMI_SERVICE_ADJ_RADIO_SPECTRAL_INTERFRC);
+
 	default:
 		return NULL;
 	}
@@ -366,6 +370,8 @@ static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_ATF, len);
 	SVCMAP(WMI_10X_SERVICE_COEX_GPIO,
 	       WMI_SERVICE_COEX_GPIO, len);
+	SVCMAP(WMI_10X_SERVICE_ADJ_RADIO_SPECTRAL_INTERFRC,
+	       WMI_SERVICE_ADJ_RADIO_SPECTRAL_INTERFRC, len);
 }
 
 static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out,
@@ -1966,6 +1972,7 @@ enum wmi_10_2_feature_mask {
 	WMI_10_2_RX_BATCH_MODE = BIT(0),
 	WMI_10_2_ATF_CONFIG    = BIT(1),
 	WMI_10_2_COEX_GPIO     = BIT(3),
+	WMI_10_2_ADJ_RADIO_SPECTRAL_INTERFRC	= BIT(4),
 };
 
 struct wmi_resource_config_10_2 {
@@ -2339,6 +2346,9 @@ struct wmi_mgmt_rx_event_v2 {
 #define PHY_ERROR_FALSE_RADAR_EXT		0x24
 #define PHY_ERROR_RADAR				0x05
 
+#define PHYERR_FLAG_INTERFRC_5G			0x01
+#define PHYERR_FLAG_INTERFRC_2G			0x02
+
 struct wmi_phyerr {
 	__le32 tsf_timestamp;
 	__le16 freq1;
-- 
1.9.1

