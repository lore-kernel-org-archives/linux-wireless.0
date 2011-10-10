Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34877 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1JJKt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 06:49:26 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 4/5] ath6kl: Add debugfs control for keepalive and disconnection timeout
Date: Mon, 10 Oct 2011 13:43:30 +0300
Message-ID: <1318243411-16110-5-git-send-email-jouni@qca.qualcomm.com> (sfid-20111010_124929_095021_AFF43979)
In-Reply-To: <1318243411-16110-1-git-send-email-jouni@qca.qualcomm.com>
References: <1318243411-16110-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new debugfs files keepalive and disconnect_timeout can be used to
fetch the current values and to change the values for keepalive and
disconnect event timeout (both in seconds).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h  |    3 +
 drivers/net/wireless/ath/ath6kl/debug.c |   85 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c   |    8 +++
 3 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c58cfad..31e5c7e 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -533,6 +533,9 @@ struct ath6kl {
 
 		u8 *roam_tbl;
 		unsigned int roam_tbl_len;
+
+		u8 keepalive;
+		u8 disc_timeout;
 	} debug;
 #endif /* CONFIG_ATH6KL_DEBUG */
 };
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 51eb626..9035002 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1115,6 +1115,85 @@ static const struct file_operations fops_roam_mode = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath6kl_keepalive_read(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	char buf[16];
+	int len;
+
+	len = snprintf(buf, sizeof(buf), "%u\n", ar->debug.keepalive);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath6kl_keepalive_write(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	int ret;
+	u8 val;
+
+	ret = kstrtou8_from_user(user_buf, count, 0, &val);
+	if (ret)
+		return ret;
+
+	ret = ath6kl_wmi_set_keepalive_cmd(ar->wmi, val);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static const struct file_operations fops_keepalive = {
+	.open = ath6kl_debugfs_open,
+	.read = ath6kl_keepalive_read,
+	.write = ath6kl_keepalive_write,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t ath6kl_disconnect_timeout_read(struct file *file,
+					      char __user *user_buf,
+					      size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	char buf[16];
+	int len;
+
+	len = snprintf(buf, sizeof(buf), "%u\n", ar->debug.disc_timeout);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath6kl_disconnect_timeout_write(struct file *file,
+					       const char __user *user_buf,
+					       size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	int ret;
+	u8 val;
+
+	ret = kstrtou8_from_user(user_buf, count, 0, &val);
+	if (ret)
+		return ret;
+
+	ret = ath6kl_wmi_disctimeout_cmd(ar->wmi, val);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static const struct file_operations fops_disconnect_timeout = {
+	.open = ath6kl_debugfs_open,
+	.read = ath6kl_disconnect_timeout_read,
+	.write = ath6kl_disconnect_timeout_write,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE);
@@ -1182,6 +1261,12 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("roam_mode", S_IWUSR, ar->debugfs_phy, ar,
 			    &fops_roam_mode);
 
+	debugfs_create_file("keepalive", S_IRUSR | S_IWUSR, ar->debugfs_phy, ar,
+			    &fops_keepalive);
+
+	debugfs_create_file("disconnect_timeout", S_IRUSR | S_IWUSR,
+			    ar->debugfs_phy, ar, &fops_disconnect_timeout);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index fdb3712..dd8110c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1940,6 +1940,10 @@ int ath6kl_wmi_disctimeout_cmd(struct wmi *wmi, u8 timeout)
 
 	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_DISC_TIMEOUT_CMDID,
 				  NO_SYNC_WMIFLAG);
+#ifdef CONFIG_ATH6KL_DEBUG
+	if (ret == 0)
+		wmi->parent_dev->debug.disc_timeout = timeout;
+#endif /* CONFIG_ATH6KL_DEBUG */
 	return ret;
 }
 
@@ -2524,6 +2528,10 @@ int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl)
 
 	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_KEEPALIVE_CMDID,
 				  NO_SYNC_WMIFLAG);
+#ifdef CONFIG_ATH6KL_DEBUG
+	if (ret == 0)
+		wmi->parent_dev->debug.keepalive = keep_alive_intvl;
+#endif /* CONFIG_ATH6KL_DEBUG */
 	return ret;
 }
 
-- 
1.7.4.1

