Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27939 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2ACJMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 04:12:05 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 2/3] ath6kl: Add a function in wmi.c to add/delete a multicast filter
Date: Tue, 3 Jan 2012 14:42:00 +0530
Message-ID: <1325581921-5249-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120103_101223_870055_147DFCB4)
In-Reply-To: <1325581921-5249-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1325581921-5249-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |    7 +++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ccd29db..44b9ebc 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2873,6 +2873,34 @@ int ath6kl_wmi_mcast_filter_cmd(struct wmi *wmi, u8 if_idx, bool mc_all_on)
 	return ret;
 }
 
+int ath6kl_wmi_add_del_mcast_filter_cmd(struct wmi *wmi, u8 if_idx,
+					u8 *filter, bool add_filter)
+{
+	struct sk_buff *skb;
+	struct wmi_mcast_filter_add_del_cmd *cmd;
+	int ret;
+
+	if ((filter[0] != 0x33 || filter[1] != 0x33) &&
+	    (filter[0] != 0x01 || filter[1] != 0x00 ||
+	    filter[2] != 0x5e || filter[3] > 0x7f)) {
+		ath6kl_warn("invalid multicast filter address\n");
+		return -EINVAL;
+	}
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_mcast_filter_add_del_cmd *) skb->data;
+	memcpy(cmd->mcast_mac, filter, ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE);
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				  add_filter ? WMI_SET_MCAST_FILTER_CMDID :
+				  WMI_DEL_MCAST_FILTER_CMDID,
+				  NO_SYNC_WMIFLAG);
+
+	return ret;
+}
+
 s32 ath6kl_wmi_get_rate(s8 rate_index)
 {
 	if (rate_index == RATE_AUTO)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 7b3b244..f265b45 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1241,6 +1241,11 @@ struct wmi_mcast_filter_cmd {
 	u8 mcast_all_enable;
 } __packed;
 
+#define ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE 6
+struct wmi_mcast_filter_add_del_cmd {
+	u8 mcast_mac[ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE];
+} __packed;
+
 /* Command Replies */
 
 /* WMI_GET_CHANNEL_LIST_CMDID reply */
@@ -2437,6 +2442,8 @@ int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid);
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
 int ath6kl_wmi_mcast_filter_cmd(struct wmi *wmi, u8 if_idx, bool mc_all_on);
+int ath6kl_wmi_add_del_mcast_filter_cmd(struct wmi *wmi, u8 if_idx,
+					u8 *filter, bool add_filter);
 
 /* AP mode */
 int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, u8 if_idx,
-- 
1.7.0.4

