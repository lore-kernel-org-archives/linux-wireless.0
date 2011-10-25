Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37729 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab1JYKh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:37:58 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 1/7] ath6kl: Add wmi functions to add/delete wow patterns
Date: Tue, 25 Oct 2011 16:07:21 +0530
Message-ID: <1319539047-8756-2-git-send-email-rmani@qca.qualcomm.com> (sfid-20111025_123800_416226_CE14A5E8)
In-Reply-To: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   53 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |   17 ++++++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 7b6bfdd..f38b30e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2356,6 +2356,59 @@ int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd)
 	return ret;
 }
 
+int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi,
+				   struct wmi_add_wow_pattern_cmd *add_wow_cmd,
+				   u8 *pattern, u8 *mask)
+{
+	struct sk_buff *skb;
+	struct wmi_add_wow_pattern_cmd *cmd;
+	u16 size;
+	u8 *filter_mask;
+	int ret;
+
+	size = sizeof(*cmd) +
+		((2 * add_wow_cmd->filter_size) * sizeof(u8));
+
+	skb = ath6kl_wmi_get_new_buf(size);
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_add_wow_pattern_cmd *) skb->data;
+	cmd->filter_list_id = add_wow_cmd->filter_list_id;
+	cmd->filter_offset = add_wow_cmd->filter_offset;
+	cmd->filter_size = add_wow_cmd->filter_size;
+
+	memcpy(cmd->filter, pattern, add_wow_cmd->filter_size);
+
+	filter_mask = (u8 *) (cmd->filter + cmd->filter_size);
+	memcpy(filter_mask, mask, add_wow_cmd->filter_size);
+
+	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_ADD_WOW_PATTERN_CMDID,
+			NO_SYNC_WMIFLAG);
+
+	return ret;
+}
+
+int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi,
+				   struct wmi_del_wow_pattern_cmd *del_wow_cmd)
+{
+	struct sk_buff *skb;
+	struct wmi_del_wow_pattern_cmd *cmd;
+	int ret;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_del_wow_pattern_cmd *) skb->data;
+	memcpy(cmd, del_wow_cmd, sizeof(*cmd));
+
+	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_DEL_WOW_PATTERN_CMDID,
+			NO_SYNC_WMIFLAG);
+
+	return ret;
+}
+
 static int ath6kl_wmi_get_wow_list_event_rx(struct wmi *wmi, u8 * datap,
 					    int len)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index f0ca899..3a54933 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1796,6 +1796,18 @@ struct wmi_set_ip_cmd {
 	__le32 ips[MAX_IP_ADDRS];
 } __packed;
 
+struct wmi_add_wow_pattern_cmd {
+	u8 filter_list_id;
+	u8 filter_size;
+	u8 filter_offset;
+	u8 filter[1];
+} __packed;
+
+struct wmi_del_wow_pattern_cmd {
+	__le16 filter_list_id;
+	__le16 filter_id;
+} __packed;
+
 /* WMI_GET_WOW_LIST_CMD reply  */
 struct wmi_get_wow_list_reply {
 	/* number of patterns in reply */
@@ -2243,6 +2255,11 @@ int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len);
 s32 ath6kl_wmi_get_rate(s8 rate_index);
 
 int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd);
+int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi,
+				   struct wmi_add_wow_pattern_cmd *add_wow_cmd,
+				   u8 *pattern, u8 *mask);
+int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi,
+				   struct wmi_del_wow_pattern_cmd *del_wow_cmd);
 int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid);
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
-- 
1.7.0.4

