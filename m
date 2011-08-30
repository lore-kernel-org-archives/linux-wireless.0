Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:53225 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1H3Noq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 09:44:46 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id 3AB76EF827
	for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 16:44:45 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 1892B158A6C
	for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 16:44:43 +0300 (EEST)
Subject: [PATCH 2/4] ath6kl: implement support to set firmware log parameters
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Tue, 30 Aug 2011 16:44:42 +0300
Message-ID: <20110830134442.21543.18052.stgit@localhost6.localdomain6> (sfid-20110830_154449_735028_B588C30F)
In-Reply-To: <20110830134432.21543.89808.stgit@localhost6.localdomain6>
References: <20110830134432.21543.89808.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware log parameters can be controlled now with help of fwlog_mask
debugfs file.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h  |    1 +
 drivers/net/wireless/ath/ath6kl/debug.c |   56 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c   |   19 +++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h   |    6 +++
 4 files changed, 82 insertions(+), 0 deletions(-)

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
index b2706da..80c05f2 100644
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
@@ -280,6 +282,51 @@ static const struct file_operations fops_fwlog = {
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
+	char buf[16];
+	int ret, len;
+
+	len = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf,
+				     count);
+	buf[len] = '\0';
+
+	if (buf[len - 1] == '\n')
+		buf[len - 1] = '\0';
+
+	ret = kstrtou32(buf, 16, &ar->debug.fwlog_mask);
+	if (ret)
+		return ret;
+
+	ret = ath6kl_wmi_config_debug_module_cmd(ar->wmi,
+						 ATH6KL_FWLOG_VALID_MASK,
+						 ar->debug.fwlog_mask);
+	return ret;
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
@@ -497,6 +544,12 @@ int ath6kl_debug_init(struct ath6kl *ar)
 
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
@@ -514,6 +567,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
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

