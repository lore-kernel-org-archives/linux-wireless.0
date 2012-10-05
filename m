Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24403 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2JEPnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 11:43:21 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <ath6kl-devel@qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 3/3] ath6kl: Support allow aggregation for each tids
Date: Fri, 5 Oct 2012 21:12:45 +0530
Message-ID: <1349451765-8459-3-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121005_174324_540056_0692BF03)
In-Reply-To: <1349451765-8459-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1349451765-8459-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Add support to have tx/rx mask for tids where aggregation
can be allowed.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   49 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c   |   19 ++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h   |   13 ++++++++
 3 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index bd5abf0..50b1773 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1825,6 +1825,53 @@ static const struct file_operations fops_addba_req = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath6kl_allow_aggr_write(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	struct ath6kl_vif *vif;
+	char buf[100];
+	ssize_t len = 0;
+	char *sptr, *token;
+	u16 tx_allow_aggr = 0, rx_allow_aggr = 0;
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
+	if (kstrtou16(token, 0, &tx_allow_aggr))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou16(token, 0, &rx_allow_aggr))
+		return -EINVAL;
+
+	ath6kl_wmi_allow_aggr_cmd(ar->wmi, vif->fw_vif_idx,
+				  tx_allow_aggr, rx_allow_aggr);
+
+	return count;
+}
+
+static const struct file_operations fops_allow_aggr = {
+	.write = ath6kl_allow_aggr_write,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 void ath6kl_debug_init(struct ath6kl *ar)
 {
 	skb_queue_head_init(&ar->debug.fwlog_queue);
@@ -1918,6 +1965,8 @@ int ath6kl_debug_init_fs(struct ath6kl *ar)
 	debugfs_create_file("addba_req", S_IWUSR, ar->debugfs_phy, ar,
 			    &fops_addba_req);
 
+	debugfs_create_file("allow_aggr", S_IWUSR, ar->debugfs_phy, ar,
+			    &fops_allow_aggr);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 183f573..072e78c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3808,6 +3808,25 @@ int ath6kl_wmi_send_addba_req_cmd(struct wmi *wmi, u8 if_idx, u8 tid, u8 aid)
 				   NO_SYNC_WMIFLAG);
 }
 
+int ath6kl_wmi_allow_aggr_cmd(struct wmi *wmi, u8 if_idx,
+			      u16 tx_allow_aggr, u16 rx_allow_aggr)
+{
+	struct sk_buff *skb;
+	struct wmi_allow_aggr_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_allow_aggr_cmd *) skb->data;
+	cmd->tx_allow_aggr = cpu_to_le16(tx_allow_aggr);
+	cmd->rx_allow_aggr = cpu_to_le16(rx_allow_aggr);
+
+
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_ALLOW_AGGR_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 static void ath6kl_wmi_hb_challenge_resp_event(struct wmi *wmi, u8 *datap,
 					       int len)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 9be7123..845d535 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2391,6 +2391,17 @@ struct wmi_addba_req_cmd {
 	u8 tid;
 } __packed;
 
+/*
+ * 16 bit mask to allow uplink/downlink
+ * ADDBA request negotiation, with each
+ * bit postion maps to corresponding tid.
+ */
+
+struct wmi_allow_aggr_cmd {
+	__le16 tx_allow_aggr;
+	__le16 rx_allow_aggr;
+} __packed;
+
 struct wmi_set_appie_extended_cmd {
 	u8 role_id;
 	u8 mgmt_frm_type;
@@ -2729,6 +2740,8 @@ int ath6kl_wmi_get_challenge_resp_cmd(struct wmi *wmi, u32 cookie, u32 source);
 int ath6kl_wmi_send_delba_req_cmd(struct wmi *wmi, u8 if_idx, u8 tid,
 				  u8 is_sender_initiator, u8 aid);
 int ath6kl_wmi_send_addba_req_cmd(struct wmi *wmi, u8 if_idx, u8 tid, u8 aid);
+int ath6kl_wmi_allow_aggr_cmd(struct wmi *wmi, u8 if_idx,
+			      u16 tx_allow_aggr, u16 rx_allow_aggr);
 
 struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx);
 void *ath6kl_wmi_init(struct ath6kl *devt);
-- 
1.7.0.4

