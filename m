Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:37653 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab1HaLJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 07:09:31 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id E3E8BEBA7F
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:09:29 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id C2FD1158A64
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:09:27 +0300 (EEST)
Subject: [PATCH v2 2/4] ath6kl: implement support to set firmware log
	parameters
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Wed, 31 Aug 2011 14:09:27 +0300
Message-ID: <20110831110927.19680.85698.stgit@localhost6.localdomain6> (sfid-20110831_130934_482423_471D8A80)
In-Reply-To: <20110831110650.19680.35966.stgit@localhost6.localdomain6>
References: <20110831110650.19680.35966.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware log parameters can be controlled now with help of fwlog_mask
debugfs file.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h  |    1 +
 drivers/net/wireless/ath/ath6kl/debug.c |   51 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c   |   19 ++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h   |    6 ++++
 4 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 89ca343..d5c21bf 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -475,6 +475,7 @@ struct ath6kl {
 		struct circ_buf fwlog_buf;
 		spinlock_t fwlog_lock;
 		void *fwlog_tmp;
+		u32 fwlog_mask;
 	} debug;
 #endif /* CONFIG_ATH6KL_DEBUG */
 
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index b2706da..239c092 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -17,6 +17,7 @@
 #include "core.h"
 
 #include <linux/circ_buf.h>
+#include <linux/fs.h>
 
 #include "debug.h"
 #include "target.h"
@@ -32,6 +33,7 @@ struct ath6kl_fwlog_slot {
 #define ATH6KL_FWLOG_SIZE 32768
 #define ATH6KL_FWLOG_SLOT_SIZE (sizeof(struct ath6kl_fwlog_slot) + \
 				ATH6KL_FWLOG_PAYLOAD_SIZE)
+#define ATH6KL_FWLOG_VALID_MASK 0x1ffff
 
 int ath6kl_printk(const char *level, const char *fmt, ...)
 {
@@ -280,6 +282,46 @@ static const struct file_operations fops_fwlog = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath6kl_fwlog_mask_read(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	char buf[16];
+	int len;
+
+	len = snprintf(buf, sizeof(buf), "0x%x\n", ar->debug.fwlog_mask);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath6kl_fwlog_mask_write(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	int ret;
+
+	ret = kstrtou32_from_user(user_buf, count, 0, &ar->debug.fwlog_mask);
+	if (ret)
+		return ret;
+
+	ret = ath6kl_wmi_config_debug_module_cmd(ar->wmi,
+						 ATH6KL_FWLOG_VALID_MASK,
+						 ar->debug.fwlog_mask);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static const struct file_operations fops_fwlog_mask = {
+	.open = ath6kl_debugfs_open,
+	.read = ath6kl_fwlog_mask_read,
+	.write = ath6kl_fwlog_mask_write,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
@@ -497,6 +539,12 @@ int ath6kl_debug_init(struct ath6kl *ar)
 
 	spin_lock_init(&ar->debug.fwlog_lock);
 
+	/*
+	 * Actually we are lying here but don't know how to read the mask
+	 * value from the firmware.
+	 */
+	ar->debug.fwlog_mask = 0;
+
 	ar->debugfs_phy = debugfs_create_dir("ath6kl",
 					     ar->wdev->wiphy->debugfsdir);
 	if (!ar->debugfs_phy) {
@@ -514,6 +562,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("fwlog", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_fwlog);
 
+	debugfs_create_file("fwlog_mask", S_IRUSR | S_IWUSR, ar->debugfs_phy,
+			    ar, &fops_fwlog_mask);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index b96a734..fc40009 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2203,6 +2203,25 @@ int ath6kl_wmi_get_challenge_resp_cmd(struct wmi *wmi, u32 cookie, u32 source)
 	return ret;
 }
 
+int ath6kl_wmi_config_debug_module_cmd(struct wmi *wmi, u32 valid, u32 config)
+{
+	struct ath6kl_wmix_dbglog_cfg_module_cmd *cmd;
+	struct sk_buff *skb;
+	int ret;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct ath6kl_wmix_dbglog_cfg_module_cmd *) skb->data;
+	cmd->valid = cpu_to_le32(valid);
+	cmd->config = cpu_to_le32(config);
+
+	ret = ath6kl_wmi_cmd_send_xtnd(wmi, skb, WMIX_DBGLOG_CFG_MODULE_CMDID,
+				       NO_SYNC_WMIFLAG);
+	return ret;
+}
+
 int ath6kl_wmi_get_stats_cmd(struct wmi *wmi)
 {
 	return ath6kl_wmi_simple_cmd(wmi, WMI_GET_STATISTICS_CMDID);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 8fa5d6e..240e64c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1898,6 +1898,11 @@ struct wmix_hb_challenge_resp_cmd {
 	__le32 source;
 } __packed;
 
+struct ath6kl_wmix_dbglog_cfg_module_cmd {
+	__le32 valid;
+	__le32 config;
+} __packed;
+
 /* End of Extended WMI (WMIX) */
 
 enum wmi_sync_flag {
@@ -1977,6 +1982,7 @@ int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 status,
 				 u8 preamble_policy);
 
 int ath6kl_wmi_get_challenge_resp_cmd(struct wmi *wmi, u32 cookie, u32 source);
+int ath6kl_wmi_config_debug_module_cmd(struct wmi *wmi, u32 valid, u32 config);
 
 int ath6kl_wmi_get_stats_cmd(struct wmi *wmi);
 int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 key_index,

