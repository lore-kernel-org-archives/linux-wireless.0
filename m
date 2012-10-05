Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24242 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab2JEPnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 11:43:08 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <ath6kl-devel@qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 2/3] ath6kl: Add support to send ADDBA request from userspace
Date: Fri, 5 Oct 2012 21:12:44 +0530
Message-ID: <1349451765-8459-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121005_174312_149153_373FE087)
In-Reply-To: <1349451765-8459-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1349451765-8459-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Support sending ADDBA request to the client with
the following parameters tid, aid.

usage: echo "0 1" > addba_req

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   50 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c   |   16 ++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h   |    5 +++
 3 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 933028f..bd5abf0 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1778,6 +1778,53 @@ static const struct file_operations fops_delba_req = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath6kl_send_addba_req_write(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	struct ath6kl_vif *vif;
+	char buf[100];
+	ssize_t len = 0;
+	char *sptr, *token;
+	u8 tid = 0, aid = 0;
+
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	sptr = buf;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou8(token, 0, &tid))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou8(token, 0, &aid))
+		return -EINVAL;
+
+	ath6kl_wmi_send_addba_req_cmd(ar->wmi, vif->fw_vif_idx,
+				      tid, aid);
+
+	return count;
+}
+
+static const struct file_operations fops_addba_req = {
+	.write = ath6kl_send_addba_req_write,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 void ath6kl_debug_init(struct ath6kl *ar)
 {
 	skb_queue_head_init(&ar->debug.fwlog_queue);
@@ -1868,6 +1915,9 @@ int ath6kl_debug_init_fs(struct ath6kl *ar)
 	debugfs_create_file("delba_req", S_IWUSR, ar->debugfs_phy, ar,
 			    &fops_delba_req);
 
+	debugfs_create_file("addba_req", S_IWUSR, ar->debugfs_phy, ar,
+			    &fops_addba_req);
+
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 4914831..183f573 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3792,6 +3792,22 @@ int ath6kl_wmi_send_delba_req_cmd(struct wmi *wmi, u8 if_idx,
 				   NO_SYNC_WMIFLAG);
 }
 
+int ath6kl_wmi_send_addba_req_cmd(struct wmi *wmi, u8 if_idx, u8 tid, u8 aid)
+{
+	struct sk_buff *skb;
+	struct wmi_addba_req_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_addba_req_cmd_req_cmd *) skb->data;
+	cmd->tid = (tid & 0xf) | (aid << 4);
+
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_ADDBA_REQ_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 static void ath6kl_wmi_hb_challenge_resp_event(struct wmi *wmi, u8 *datap,
 					       int len)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 7ec7bec..9be7123 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2387,6 +2387,10 @@ struct wmi_delba_req_cmd {
 	u8 is_sender_initiator;
 } __packed;
 
+struct wmi_addba_req_cmd {
+	u8 tid;
+} __packed;
+
 struct wmi_set_appie_extended_cmd {
 	u8 role_id;
 	u8 mgmt_frm_type;
@@ -2724,6 +2728,7 @@ void ath6kl_wmi_sscan_timer(unsigned long ptr);
 int ath6kl_wmi_get_challenge_resp_cmd(struct wmi *wmi, u32 cookie, u32 source);
 int ath6kl_wmi_send_delba_req_cmd(struct wmi *wmi, u8 if_idx, u8 tid,
 				  u8 is_sender_initiator, u8 aid);
+int ath6kl_wmi_send_addba_req_cmd(struct wmi *wmi, u8 if_idx, u8 tid, u8 aid);
 
 struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx);
 void *ath6kl_wmi_init(struct ath6kl *devt);
-- 
1.7.0.4

