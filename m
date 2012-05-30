Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:48619 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2E3HnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 03:43:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com,
	Etay Luz <eluz@qca.qualcomm.com>
Subject: [PATCH] ath6kl: support changing dtim period on AP mode
Date: Wed, 30 May 2012 10:43:07 +0300
Message-Id: <1338363787-12314-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120530_094314_935633_0C4CEF2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Etay Luz <eluz@qca.qualcomm.com>

This patch adds support for dtim_period configuration in beacon.

kvalo: add a comment about ignoring the error

Signed-off-by: Etay Luz <eluz@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    7 ++++++-
 drivers/net/wireless/ath/ath6kl/wmi.c      |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    5 +++++
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6f20998..4f48c1a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2783,9 +2783,14 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	/* TODO:
 	 * info->interval
-	 * info->dtim_period
 	 */
 
+	ret = ath6kl_wmi_ap_set_dtim_cmd(ar->wmi, info->dtim_period);
+
+	/* ignore error, just print a warning and continue normally */
+	if (ret)
+		ath6kl_warn("Failed to set dtim_period in beacon: %d", ret);
+
 	if (info->beacon.head == NULL)
 		return -EINVAL;
 	mgmt = (struct ieee80211_mgmt *) info->beacon.head;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 43bce9c..e156443 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -752,6 +752,22 @@ int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid)
 				   NO_SYNC_WMIFLAG);
 }
 
+int ath6kl_wmi_ap_set_dtim_cmd(struct wmi *wmi, u32 dtim_period)
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
+	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_AP_SET_DTIM_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 7c94fe3..a63b549 100644
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
+int ath6kl_wmi_ap_set_dtim_cmd(struct wmi *wmi, u32 dtim_period);
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid);
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
 int ath6kl_wmi_mcast_filter_cmd(struct wmi *wmi, u8 if_idx, bool mc_all_on);
-- 
1.7.1

