Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17011 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab2AIHpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 02:45:47 -0500
From: Thirumalai <tpachamu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Thirumalai <tpachamu@qca.qualcomm.com>
Subject: [PATCH 1/4] ath6kl: Add new WMI functions for uAPSD
Date: Mon, 9 Jan 2012 13:15:05 +0530
Message-ID: <1326095106-1572-1-git-send-email-tpachamu@qca.qualcomm.com> (sfid-20120109_084550_501111_A6AA1378)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WMI functions are added
* To enable/disable uapsd
* To signal the firmware about buffered frames
  in the host for the APSD WMM AC.

Signed-off-by: Thirumalai <tpachamu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   37 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |   17 +++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index c6ca660..cda9cc7 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2948,6 +2948,43 @@ int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 if_idx, u8 cmd, const u8 *mac,
 				   NO_SYNC_WMIFLAG);
 }
 
+/* This command will be used to enable/disable AP uAPSD feature */
+int ath6kl_wmi_ap_set_apsd(struct wmi *wmi, u8 if_idx, u8 enable)
+{
+	struct wmi_ap_set_apsd_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_ap_set_apsd_cmd *)skb->data;
+	cmd->enable = enable;
+
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_AP_SET_APSD_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
+int ath6kl_wmi_set_apsd_bfrd_traf(struct wmi *wmi, u8 if_idx,
+					     u16 aid, u16 bitmap, u32 flags)
+{
+	struct wmi_ap_apsd_buffered_traffic_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_ap_apsd_buffered_traffic_cmd *)skb->data;
+	cmd->aid = cpu_to_le16(aid);
+	cmd->bitmap = cpu_to_le16(bitmap);
+	cmd->flags = cpu_to_le32(flags);
+
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				   WMI_AP_APSD_BUFFERED_TRAFFIC_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 static int ath6kl_wmi_pspoll_event_rx(struct wmi *wmi, u8 *datap, int len,
 				      struct ath6kl_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 2b43599..c48e289 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2107,6 +2107,19 @@ struct wmi_rx_frame_format_cmd {
 } __packed;
 
 /* AP mode events */
+struct wmi_ap_set_apsd_cmd {
+	u8 enable;
+} __packed;
+
+enum wmi_ap_apsd_buffered_traffic_flags {
+	WMI_AP_APSD_NO_DELIVERY_FRAMES =  0x1,
+};
+
+struct wmi_ap_apsd_buffered_traffic_cmd {
+	__le16 aid;
+	__le16 bitmap;
+	__le32 flags;
+} __packed;
 
 /* WMI_PS_POLL_EVENT */
 struct wmi_pspoll_event {
@@ -2434,7 +2447,11 @@ int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid);
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
+int ath6kl_wmi_ap_set_apsd(struct wmi *wmi, u8 if_idx, u8 enable);
 
+int ath6kl_wmi_set_apsd_bfrd_traf(struct wmi *wmi,
+						u8 if_idx, u16 aid,
+						u16 bitmap, u32 flags);
 /* AP mode */
 int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, u8 if_idx,
 				 struct wmi_connect_cmd *p);
-- 
1.7.4.1

