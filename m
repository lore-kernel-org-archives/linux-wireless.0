Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40449 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1KGF0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:26:53 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 01/11] ath6kl: Add wmi functions to add/delete WOW patterns
Date: Mon, 7 Nov 2011 10:55:37 +0530
Message-ID: <1320643547-3578-2-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_062700_002072_301FB631)
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These commands will be used in WOW suspend/resume functions
to configure WOW parameters like patterns to be matched
and it's mask value, etc.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   56 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |   17 ++++++++++
 2 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 612326d..925ef4c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2412,6 +2412,62 @@ int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd)
 	return ret;
 }
 
+int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
+				   u8 list_id, u8 filter_size,
+				   u8 filter_offset, u8 *filter, u8 *mask)
+{
+	struct sk_buff *skb;
+	struct wmi_add_wow_pattern_cmd *cmd;
+	u16 size;
+	u8 *filter_mask;
+	int ret;
+
+	/*
+	 * Allocate additional memory in the buffer to hold
+	 * filter and mask value, which is twice of filter_size.
+	 */
+	size = sizeof(*cmd) + (2 * filter_size);
+
+	skb = ath6kl_wmi_get_new_buf(size);
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_add_wow_pattern_cmd *) skb->data;
+	cmd->filter_list_id = list_id;
+	cmd->filter_size = filter_size;
+	cmd->filter_offset = filter_offset;
+
+	memcpy(cmd->filter, filter, filter_size);
+
+	filter_mask = (u8 *) (cmd->filter + filter_size);
+	memcpy(filter_mask, mask, filter_size);
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_ADD_WOW_PATTERN_CMDID,
+				  NO_SYNC_WMIFLAG);
+
+	return ret;
+}
+
+int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
+				   u16 list_id, u16 filter_id)
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
+	cmd->filter_list_id = cpu_to_le16(list_id);
+	cmd->filter_id = cpu_to_le16(filter_id);
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_DEL_WOW_PATTERN_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
 static int ath6kl_wmi_get_wow_list_event_rx(struct wmi *wmi, u8 * datap,
 					    int len)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 1d458f0..df42e4b 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1818,6 +1818,18 @@ struct wmi_set_ip_cmd {
 	__le32 ips[MAX_IP_ADDRS];
 } __packed;
 
+struct wmi_add_wow_pattern_cmd {
+	u8 filter_list_id;
+	u8 filter_size;
+	u8 filter_offset;
+	u8 filter[0];
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
@@ -2273,6 +2285,11 @@ int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len);
 s32 ath6kl_wmi_get_rate(s8 rate_index);
 
 int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd);
+int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
+				   u8 list_id, u8 filter_size,
+				   u8 filter_offset, u8 *filter, u8 *mask);
+int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
+				   u16 list_id, u16 filter_id);
 int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid);
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
-- 
1.7.1

