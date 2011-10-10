Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24423 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1JJKpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 06:45:41 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 2/5] ath6kl: Add debugfs file for target roam table
Date: Mon, 10 Oct 2011 13:43:28 +0300
Message-ID: <1318243411-16110-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20111010_124544_068690_7B12D91E)
In-Reply-To: <1318243411-16110-1-git-send-email-jouni@qca.qualcomm.com>
References: <1318243411-16110-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new roam_table debugfs file can be used to display the current
roam table from the target.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h  |    4 ++
 drivers/net/wireless/ath/ath6kl/debug.c |   75 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c   |   41 +++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h   |    7 +++
 4 files changed, 127 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 6d8a484..c58cfad 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -397,6 +397,7 @@ struct ath6kl_req_key {
 #define TESTMODE	     13
 #define CLEAR_BSSFILTER_ON_BEACON 14
 #define DTIM_PERIOD_AVAIL    15
+#define ROAM_TBL_PEND        16
 
 struct ath6kl {
 	struct device *dev;
@@ -529,6 +530,9 @@ struct ath6kl {
 		struct {
 			unsigned int invalid_rate;
 		} war_stats;
+
+		u8 *roam_tbl;
+		unsigned int roam_tbl_len;
 	} debug;
 #endif /* CONFIG_ATH6KL_DEBUG */
 };
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index b9bf28d..0b7fa26 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -966,6 +966,77 @@ static const struct file_operations fops_diag_reg_write = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath6kl_roam_table_read(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	int ret;
+	long left;
+	struct wmi_target_roam_tbl *tbl;
+	u16 num_entries, i;
+	char *buf;
+	unsigned int len, buf_len;
+	ssize_t ret_cnt;
+
+	if (down_interruptible(&ar->sem))
+		return -EBUSY;
+
+	set_bit(ROAM_TBL_PEND, &ar->flag);
+
+	ret = ath6kl_wmi_get_roam_tbl_cmd(ar->wmi);
+	if (ret) {
+		up(&ar->sem);
+		return ret;
+	}
+
+	left = wait_event_interruptible_timeout(
+		ar->event_wq, !test_bit(ROAM_TBL_PEND, &ar->flag), WMI_TIMEOUT);
+	up(&ar->sem);
+
+	if (left <= 0)
+		return -ETIMEDOUT;
+
+	if (ar->debug.roam_tbl == NULL)
+		return -ENOMEM;
+
+	tbl = (struct wmi_target_roam_tbl *) ar->debug.roam_tbl;
+	num_entries = le16_to_cpu(tbl->num_entries);
+
+	buf_len = 100 + num_entries * 100;
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+	len = 0;
+	len += scnprintf(buf + len, buf_len - len,
+			 "roam_mode=%u\n\n"
+			 "# roam_util bssid rssi rssidt last_rssi util bias\n",
+			 le16_to_cpu(tbl->roam_mode));
+
+	for (i = 0; i < num_entries; i++) {
+		struct wmi_bss_roam_info *info = &tbl->info[i];
+		len += scnprintf(buf + len, buf_len - len,
+				 "%d %pM %d %d %d %d %d\n",
+				 a_sle32_to_cpu(info->roam_util), info->bssid,
+				 info->rssi, info->rssidt, info->last_rssi,
+				 info->util, info->bias);
+	}
+
+	if (len > buf_len)
+		len = buf_len;
+
+	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	kfree(buf);
+	return ret_cnt;
+}
+
+static const struct file_operations fops_roam_table = {
+	.read = ath6kl_roam_table_read,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE);
@@ -1024,6 +1095,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("war_stats", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_war_stats);
 
+	debugfs_create_file("roam_table", S_IRUSR, ar->debugfs_phy, ar,
+			    &fops_roam_table);
+
 	return 0;
 }
 
@@ -1031,6 +1105,7 @@ void ath6kl_debug_cleanup(struct ath6kl *ar)
 {
 	vfree(ar->debug.fwlog_buf.buf);
 	kfree(ar->debug.fwlog_tmp);
+	kfree(ar->debug.roam_tbl);
 }
 
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ab782d7..425efb5 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2407,6 +2407,11 @@ int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi)
 	return ath6kl_wmi_simple_cmd(wmi, WMI_GET_TX_PWR_CMDID);
 }
 
+int ath6kl_wmi_get_roam_tbl_cmd(struct wmi *wmi)
+{
+	return ath6kl_wmi_simple_cmd(wmi, WMI_GET_ROAM_TBL_CMDID);
+}
+
 int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 status, u8 preamble_policy)
 {
 	struct sk_buff *skb;
@@ -2844,6 +2849,41 @@ static int ath6kl_wmi_control_rx_xtnd(struct wmi *wmi, struct sk_buff *skb)
 	return ret;
 }
 
+static int ath6kl_wmi_roam_tbl_event_rx(struct wmi *wmi, u8 *datap, int len)
+{
+#ifdef CONFIG_ATH6KL_DEBUG
+	struct ath6kl *ar = wmi->parent_dev;
+	struct wmi_target_roam_tbl *tbl;
+	u16 num_entries;
+
+	if (len < sizeof(*tbl))
+		return -EINVAL;
+
+	tbl = (struct wmi_target_roam_tbl *) datap;
+	num_entries = le16_to_cpu(tbl->num_entries);
+	if (sizeof(*tbl) + num_entries * sizeof(struct wmi_bss_roam_info) > len)
+		return -EINVAL;
+
+	if (ar->debug.roam_tbl == NULL ||
+	    ar->debug.roam_tbl_len < (unsigned int) len) {
+		kfree(ar->debug.roam_tbl);
+		ar->debug.roam_tbl = kmalloc(len, GFP_ATOMIC);
+		if (ar->debug.roam_tbl == NULL)
+			return -ENOMEM;
+	}
+
+	memcpy(ar->debug.roam_tbl, datap, len);
+	ar->debug.roam_tbl_len = len;
+
+	if (test_bit(ROAM_TBL_PEND, &ar->flag)) {
+		clear_bit(ROAM_TBL_PEND, &ar->flag);
+		wake_up(&ar->event_wq);
+	}
+#endif /* CONFIG_ATH6KL_DEBUG */
+
+	return 0;
+}
+
 /* Control Path */
 int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 {
@@ -2948,6 +2988,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_REPORT_ROAM_TBL_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REPORT_ROAM_TBL_EVENTID\n");
+		ret = ath6kl_wmi_roam_tbl_event_rx(wmi, datap, len);
 		break;
 	case WMI_EXTENSION_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_EXTENSION_EVENTID\n");
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 96102c6..f986da1 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1624,6 +1624,12 @@ struct wmi_bss_roam_info {
 	u8 reserved;
 } __packed;
 
+struct wmi_target_roam_tbl {
+	__le16 roam_mode;
+	__le16 num_entries;
+	struct wmi_bss_roam_info info[];
+} __packed;
+
 /* WMI_CAC_EVENTID */
 enum cac_indication {
 	CAC_INDICATION_ADMISSION = 0x00,
@@ -2221,6 +2227,7 @@ int ath6kl_wmi_setpmkid_cmd(struct wmi *wmi, const u8 *bssid,
 			    const u8 *pmkid, bool set);
 int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 dbM);
 int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi);
+int ath6kl_wmi_get_roam_tbl_cmd(struct wmi *wmi);
 
 int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, enum wmi_txop_cfg cfg);
 int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl);
-- 
1.7.4.1

