Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:58074 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab2E3IfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 04:35:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com,
	Etay Luz <eluz@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl: support changing dtim period on AP mode
Date: Wed, 30 May 2012 11:35:08 +0300
Message-Id: <1338366908-4654-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120530_103529_834194_53F227B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Etay Luz <eluz@qca.qualcomm.com>

This patch adds support for dtim_period configuration in beacon.

kvalo: add a comment about ignoring the error, use vif_idx,
add \n to the warning message

Signed-off-by: Etay Luz <eluz@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 +++++++-
 drivers/net/wireless/ath/ath6kl/wmi.c      |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    5 +++++
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6f20998..62688a4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2783,9 +2783,15 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	/* TODO:
 	 * info->interval
-	 * info->dtim_period
 	 */
 
+	ret = ath6kl_wmi_ap_set_dtim_cmd(ar->wmi, vif->fw_vif_idx,
+					 info->dtim_period);
+
+	/* ignore error, just print a warning and continue normally */
+	if (ret)
+		ath6kl_warn("Failed to set dtim_period in beacon: %d\n", ret);
+
 	if (info->beacon.head == NULL)
 		return -EINVAL;
 	mgmt = (struct ieee80211_mgmt *) info->beacon.head;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 43bce9c..a6caa67 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -752,6 +752,22 @@ int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid)
 				   NO_SYNC_WMIFLAG);
 }
 
+int ath6kl_wmi_ap_set_dtim_cmd(struct wmi *wmi, u8 if_idx, u32 dtim_period)
+{
+	struct sk_buff *skb;
+	struct set_dtim_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct set_dtim_cmd *) skb->data;
+
+	cmd->dtim_period = cpu_to_le32(dtim_period);
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				   WMI_AP_SET_DTIM_CMDID, NO_SYNC_WMIFLAG);
+}
+
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 7c94fe3..43339ac 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1617,6 +1617,10 @@ struct roam_ctrl_cmd {
 	u8 roam_ctrl;
 } __packed;
 
+struct set_dtim_cmd {
+	__le32 dtim_period;
+} __packed;
+
 /* BSS INFO HDR version 2.0 */
 struct wmi_bss_info_hdr2 {
 	__le16 ch; /* frequency in MHz */
@@ -2589,6 +2593,7 @@ int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 				   u16 list_id, u16 filter_id);
 int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
+int ath6kl_wmi_ap_set_dtim_cmd(struct wmi *wmi, u8 if_idx, u32 dtim_period);
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid);
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
 int ath6kl_wmi_mcast_filter_cmd(struct wmi *wmi, u8 if_idx, bool mc_all_on);
-- 
1.7.1

