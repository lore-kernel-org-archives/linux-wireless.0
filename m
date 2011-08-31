Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36478 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1HaJc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 05:32:26 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Add debugfs entry to modify roaming parameters.
Date: Wed, 31 Aug 2011 15:02:19 +0530
Message-ID: <1314783139-19254-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20110831_113231_460077_EB780C86)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware initiates roaming only after it reaches a rssi of 20.
This lower rssi threshold can be modified through a wmi command
to modify the roaming behavior.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h  |    1 +
 drivers/net/wireless/ath/ath6kl/debug.c |   47 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/init.c  |    1 +
 drivers/net/wireless/ath/ath6kl/wmi.c   |   23 +++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h   |   48 +++++++++++++++++++++++++++++++
 5 files changed, 120 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c5537b3..28540fc 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -402,6 +402,7 @@ struct ath6kl {
 	u16 bss_ch;
 	u16 listen_intvl_b;
 	u16 listen_intvl_t;
+	u8 lrssi_roam_threshold;
 	struct ath6kl_version version;
 	u32 target_type;
 	u8 tx_pwr;
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 2b46287..aac5bf4 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -356,6 +356,51 @@ static const struct file_operations fops_credit_dist_stats = {
 	.llseek = default_llseek,
 };
 
+static ssize_t write_file_lrssi_roam_threshold(struct file *file,
+					       const char __user *user_buf,
+					       size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	unsigned long lrssi_roam_threshold;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &lrssi_roam_threshold))
+		return -EINVAL;
+
+	ar->lrssi_roam_threshold = lrssi_roam_threshold;
+
+	ath6kl_wmi_set_roam_lrssi_cmd(ar->wmi, ar->lrssi_roam_threshold);
+
+	return count;
+}
+
+static ssize_t read_file_lrssi_roam_threshold(struct file *file,
+					      char __user *user_buf,
+					      size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = snprintf(buf, sizeof(buf), "%u\n", ar->lrssi_roam_threshold);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_lrssi_roam_threshold = {
+	.read = read_file_lrssi_roam_threshold,
+	.write = write_file_lrssi_roam_threshold,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	ar->debugfs_phy = debugfs_create_dir("ath6kl",
@@ -369,6 +414,8 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("credit_dist_stats", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_credit_dist_stats);
 
+	debugfs_create_file("lrssi_roam_threshold", S_IRUSR | S_IWUSR,
+			    ar->debugfs_phy, ar, &fops_lrssi_roam_threshold);
 	return 0;
 }
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index ad9716c..99b63b4 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -292,6 +292,7 @@ static void ath6kl_init_control_info(struct ath6kl *ar)
 	memset(&ar->sc_params, 0, sizeof(ar->sc_params));
 	ar->sc_params.short_scan_ratio = WMI_SHORTSCANRATIO_DEFAULT;
 	ar->sc_params.scan_ctrl_flags = DEFAULT_SCAN_CTRL_FLAGS;
+	ar->lrssi_roam_threshold = DEF_LRSSI_ROAM_THRESHOLD;
 
 	memset((u8 *)ar->sta_list, 0,
 	       AP_MAX_NUM_STA * sizeof(struct ath6kl_sta));
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index d116d0e..d24f21b 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -470,6 +470,29 @@ static int ath6kl_wmi_ready_event_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
+int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi)
+{
+	struct sk_buff *skb;
+	struct roam_ctrl_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct roam_ctrl_cmd *) skb->data;
+
+	cmd->info.params.lrssi_scan_period = cpu_to_le16(DEF_LRSSI_SCAN_PERIOD);
+	cmd->info.params.lrssi_scan_threshold = a_cpu_to_sle16(lrssi +
+						       DEF_SCAN_FOR_ROAM_INTVL);
+	cmd->info.params.lrssi_roam_threshold = a_cpu_to_sle16(lrssi);
+	cmd->info.params.roam_rssi_floor = DEF_LRSSI_ROAM_FLOOR;
+	cmd->roam_ctrl = WMI_SET_LRSSI_SCAN_PARAMS;
+
+	ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_ROAM_CTRL_CMDID, NO_SYNC_WMIFLAG);
+
+	return 0;
+}
+
 static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	struct wmi_connect_event *ev;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 8fa5d6e..4df11e9 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1265,6 +1265,53 @@ enum wmi_bi_ftype {
 	PROBEREQ_FTYPE,
 };
 
+/*
+ * Roam control
+ * Mechanism to modify the roaming behavior in the firmware.
+ * The lower rssi at which the station has to roam can be passed with
+ * WMI_SET_LRSSI_SCAN_PARAMS. Subtract 96 from RSSI to get the signal
+ * level in dBm.
+ */
+#define DEF_LRSSI_SCAN_PERIOD		 5
+#define DEF_LRSSI_ROAM_THRESHOLD	20
+#define DEF_LRSSI_ROAM_FLOOR		60
+#define DEF_SCAN_FOR_ROAM_INTVL		 2
+
+enum wmi_roam_ctrl {
+	WMI_FORCE_ROAM = 1,
+	WMI_SET_ROAM_MODE,
+	WMI_SET_HOST_BIAS,
+	WMI_SET_LRSSI_SCAN_PARAMS,
+};
+
+struct bss_bias {
+	u8 bssid[ETH_ALEN];
+	u8  bias;
+} __packed;
+
+struct bss_bias_info {
+	u8 num_bss;
+	struct bss_bias bss_bias[1];
+} __packed;
+
+struct low_rssi_scan_params {
+	__le16 lrssi_scan_period;
+	a_sle16 lrssi_scan_threshold;
+	a_sle16 lrssi_roam_threshold;
+	u8 roam_rssi_floor;
+	u8 reserved[1];
+} __packed;
+
+struct roam_ctrl_cmd {
+	union {
+		u8 bssid[ETH_ALEN];
+		u8 roam_mode;
+		struct bss_bias_info bss;
+		struct low_rssi_scan_params params;
+	} __packed info;
+	u8 roam_ctrl;
+} __packed;
+
 struct wmi_bss_info_hdr {
 	__le16 ch;
 
@@ -1998,6 +2045,7 @@ int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl);
 s32 ath6kl_wmi_get_rate(s8 rate_index);
 
 int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd);
+int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
 
 struct bss *ath6kl_wmi_find_ssid_node(struct wmi *wmi, u8 *ssid,
 				      u32 ssid_len, bool is_wpa2,
-- 
1.7.1

