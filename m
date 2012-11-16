Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17695 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2KPMx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 07:53:27 -0500
To: <ath6kl-devel@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Sumathi Mandipati <sumathi@qca.qualcomm.com>
Subject: [PATCH 6/8] ath6kl: Parse beacon interval from userspace
Date: Fri, 16 Nov 2012 18:23:15 +0530
Message-ID: <1353070395-6078-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121116_135330_056598_F06609D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Parse beacon interval from userspace to
firmware. Incase the firmware does not
supports it, just print a warning message
and continue with AP settings.

Cc: Sumathi Mandipati <sumathi@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 +++++---
 drivers/net/wireless/ath/ath6kl/wmi.c      |   17 +++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    6 ++++++
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b8d99c2..8325daf 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2769,9 +2769,11 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	ar->ap_mode_bkey.valid = false;
 
-	/* TODO:
-	 * info->interval
-	 */
+	ret = ath6kl_wmi_ap_set_beacon_intvl_cmd(ar->wmi, vif->fw_vif_idx,
+						 info->beacon_interval);
+
+	if (ret)
+		ath6kl_warn("Failed to set beacon interval: %d\n", ret);
 
 	ret = ath6kl_wmi_ap_set_dtim_cmd(ar->wmi, vif->fw_vif_idx,
 					 info->dtim_period);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 7c5da1e..fb11199 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -752,6 +752,23 @@ int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid)
 				   NO_SYNC_WMIFLAG);
 }
 
+int ath6kl_wmi_ap_set_beacon_intvl_cmd(struct wmi *wmi, u8 if_idx,
+				       u32 beacon_intvl)
+{
+	struct sk_buff *skb;
+	struct set_beacon_int_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct set_beacon_int_cmd *) skb->data;
+
+	cmd->beacon_intvl = cpu_to_le32(beacon_intvl);
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				   WMI_SET_BEACON_INT_CMDID, NO_SYNC_WMIFLAG);
+}
+
 int ath6kl_wmi_ap_set_dtim_cmd(struct wmi *wmi, u8 if_idx, u32 dtim_period)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 98b1755..b5f2265 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1660,6 +1660,10 @@ struct roam_ctrl_cmd {
 	u8 roam_ctrl;
 } __packed;
 
+struct set_beacon_int_cmd {
+	__le32 beacon_intvl;
+} __packed;
+
 struct set_dtim_cmd {
 	__le32 dtim_period;
 } __packed;
@@ -2649,6 +2653,8 @@ int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 int ath6kl_wmi_set_rssi_filter_cmd(struct wmi *wmi, u8 if_idx, s8 rssi);
 int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
 int ath6kl_wmi_ap_set_dtim_cmd(struct wmi *wmi, u8 if_idx, u32 dtim_period);
+int ath6kl_wmi_ap_set_beacon_intvl_cmd(struct wmi *wmi, u8 if_idx,
+				       u32 beacon_interval);
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid);
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
 int ath6kl_wmi_mcast_filter_cmd(struct wmi *wmi, u8 if_idx, bool mc_all_on);
-- 
1.7.0.4

