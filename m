Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40323 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1JJKqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 06:46:02 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 3/5] ath6kl: Add debugfs files for roaming control
Date: Mon, 10 Oct 2011 13:43:29 +0300
Message-ID: <1318243411-16110-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20111010_124606_299521_CD264367)
In-Reply-To: <1318243411-16110-1-git-send-email-jouni@qca.qualcomm.com>
References: <1318243411-16110-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roaming mode can be changed by writing roam mode (default, bssbias, or
lock) to roam_mode. Forced roam can be requested by writing the BSSID
into force_roam.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   84 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c   |   40 +++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h   |   21 ++++++--
 3 files changed, 139 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 0b7fa26..51eb626 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1037,6 +1037,84 @@ static const struct file_operations fops_roam_table = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath6kl_force_roam_write(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	int ret;
+	char buf[20];
+	size_t len;
+	u8 bssid[ETH_ALEN];
+	int i;
+	int addr[ETH_ALEN];
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+
+	if (sscanf(buf, "%02x:%02x:%02x:%02x:%02x:%02x",
+		   &addr[0], &addr[1], &addr[2], &addr[3], &addr[4], &addr[5])
+	    != ETH_ALEN)
+		return -EINVAL;
+	for (i = 0; i < ETH_ALEN; i++)
+		bssid[i] = addr[i];
+
+	ret = ath6kl_wmi_force_roam_cmd(ar->wmi, bssid);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static const struct file_operations fops_force_roam = {
+	.write = ath6kl_force_roam_write,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t ath6kl_roam_mode_write(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	int ret;
+	char buf[20];
+	size_t len;
+	enum wmi_roam_mode mode;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+	if (len > 0 && buf[len - 1] == '\n')
+		buf[len - 1] = '\0';
+
+	if (strcasecmp(buf, "default") == 0)
+		mode = WMI_DEFAULT_ROAM_MODE;
+	else if (strcasecmp(buf, "bssbias") == 0)
+		mode = WMI_HOST_BIAS_ROAM_MODE;
+	else if (strcasecmp(buf, "lock") == 0)
+		mode = WMI_LOCK_BSS_MODE;
+	else
+		return -EINVAL;
+
+	ret = ath6kl_wmi_set_roam_mode_cmd(ar->wmi, mode);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static const struct file_operations fops_roam_mode = {
+	.write = ath6kl_roam_mode_write,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE);
@@ -1098,6 +1176,12 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("roam_table", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_roam_table);
 
+	debugfs_create_file("force_roam", S_IWUSR, ar->debugfs_phy, ar,
+			    &fops_force_roam);
+
+	debugfs_create_file("roam_mode", S_IWUSR, ar->debugfs_phy, ar,
+			    &fops_roam_mode);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 425efb5..fdb3712 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -682,6 +682,46 @@ int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi)
 	return 0;
 }
 
+int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid)
+{
+	struct sk_buff *skb;
+	struct roam_ctrl_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct roam_ctrl_cmd *) skb->data;
+	memset(cmd, 0, sizeof(*cmd));
+
+	memcpy(cmd->info.bssid, bssid, ETH_ALEN);
+	cmd->roam_ctrl = WMI_FORCE_ROAM;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "force roam to %pM\n", bssid);
+	return ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_ROAM_CTRL_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
+int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode)
+{
+	struct sk_buff *skb;
+	struct roam_ctrl_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct roam_ctrl_cmd *) skb->data;
+	memset(cmd, 0, sizeof(*cmd));
+
+	cmd->info.roam_mode = mode;
+	cmd->roam_ctrl = WMI_SET_ROAM_MODE;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "set roam mode %d\n", mode);
+	return ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_ROAM_CTRL_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	struct wmi_connect_event *ev;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index f986da1..f0ca899 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1354,14 +1354,20 @@ enum wmi_roam_ctrl {
 	WMI_SET_LRSSI_SCAN_PARAMS,
 };
 
+enum wmi_roam_mode {
+	WMI_DEFAULT_ROAM_MODE = 1, /* RSSI based roam */
+	WMI_HOST_BIAS_ROAM_MODE = 2, /* Host bias based roam */
+	WMI_LOCK_BSS_MODE = 3, /* Lock to the current BSS */
+};
+
 struct bss_bias {
 	u8 bssid[ETH_ALEN];
-	u8  bias;
+	s8 bias;
 } __packed;
 
 struct bss_bias_info {
 	u8 num_bss;
-	struct bss_bias bss_bias[1];
+	struct bss_bias bss_bias[0];
 } __packed;
 
 struct low_rssi_scan_params {
@@ -1374,10 +1380,11 @@ struct low_rssi_scan_params {
 
 struct roam_ctrl_cmd {
 	union {
-		u8 bssid[ETH_ALEN];
-		u8 roam_mode;
-		struct bss_bias_info bss;
-		struct low_rssi_scan_params params;
+		u8 bssid[ETH_ALEN]; /* WMI_FORCE_ROAM */
+		u8 roam_mode; /* WMI_SET_ROAM_MODE */
+		struct bss_bias_info bss; /* WMI_SET_HOST_BIAS */
+		struct low_rssi_scan_params params; /* WMI_SET_LRSSI_SCAN_PARAMS
+						     */
 	} __packed info;
 	u8 roam_ctrl;
 } __packed;
@@ -2237,6 +2244,8 @@ s32 ath6kl_wmi_get_rate(s8 rate_index);
 
 int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd);
 int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
+int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid);
+int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
 
 /* AP mode */
 int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, struct wmi_connect_cmd *p);
-- 
1.7.4.1

