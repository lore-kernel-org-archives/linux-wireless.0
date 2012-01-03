Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28044 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2ACJL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 04:11:57 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 1/3] ath6kl: Add a function in wmi to send WMI_MCAST_FILTER_CMDID
Date: Tue, 3 Jan 2012 14:41:59 +0530
Message-ID: <1325581921-5249-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120103_101222_205546_50D2379C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used to disable/enable multicast receive.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   17 +++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |    5 +++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 1e31c38..ccd29db 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2855,6 +2855,23 @@ int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len)
 	return ret;
 }
 
+int ath6kl_wmi_mcast_filter_cmd(struct wmi *wmi, u8 if_idx, bool mc_all_on)
+{
+	struct sk_buff *skb;
+	struct wmi_mcast_filter_cmd *cmd;
+	int ret;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_mcast_filter_cmd *) skb->data;
+	cmd->mcast_all_enable = mc_all_on;
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_MCAST_FILTER_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
 
 s32 ath6kl_wmi_get_rate(s8 rate_index)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 96e3cc1..7b3b244 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1237,6 +1237,10 @@ enum target_event_report_config {
 	NO_DISCONN_EVT_IN_RECONN
 };
 
+struct wmi_mcast_filter_cmd {
+	u8 mcast_all_enable;
+} __packed;
+
 /* Command Replies */
 
 /* WMI_GET_CHANNEL_LIST_CMDID reply */
@@ -2432,6 +2436,7 @@ int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid);
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
+int ath6kl_wmi_mcast_filter_cmd(struct wmi *wmi, u8 if_idx, bool mc_all_on);
 
 /* AP mode */
 int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, u8 if_idx,
-- 
1.7.0.4

