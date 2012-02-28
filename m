Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41795 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655Ab2B1XIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 18:08:49 -0500
Cc: <kvalo@qca.qualcomm.com>, <ath6kl-devel@qualcomm.com>
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: implement hidden ssid
Date: Tue, 28 Feb 2012 15:08:46 -0800
Message-ID: <1330470526-8155-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120229_000914_976167_BEC00749)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath6kl FW does not distinguish between different types of hidden
SSIDs (empty or null), so treat all cfg80211 requests for hidden ssid
the same.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    7 ++++++-
 drivers/net/wireless/ath/ath6kl/wmi.c      |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    5 +++++
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 9187caa..e33b51b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2354,6 +2354,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	struct ieee80211_mgmt *mgmt;
+	bool hidden = false;
 	u8 *ies;
 	int ies_len;
 	struct wmi_connect_cmd p;
@@ -2414,7 +2415,11 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(vif->ssid, info->ssid, info->ssid_len);
 	vif->ssid_len = info->ssid_len;
 	if (info->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE)
-		return -EOPNOTSUPP; /* TODO */
+		hidden = true;
+
+	res = ath6kl_wmi_ap_hidden_ssid(ar->wmi, vif->fw_vif_idx, hidden);
+	if (res)
+		return res;
 
 	ret = ath6kl_set_auth_type(vif, info->auth_type);
 	if (ret)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 69db2c9..c1a7c38 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3037,6 +3037,22 @@ int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 if_idx, u8 cmd, const u8 *mac,
 				   NO_SYNC_WMIFLAG);
 }
 
+int ath6kl_wmi_ap_hidden_ssid(struct wmi *wmi, u8 if_idx, bool enable)
+{
+	struct sk_buff *skb;
+	struct wmi_ap_hidden_ssid_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_ap_hidden_ssid_cmd *) skb->data;
+	cmd->hidden_ssid = enable ? 1 : 0;
+
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_AP_HIDDEN_SSID_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 /* This command will be used to enable/disable AP uAPSD feature */
 int ath6kl_wmi_ap_set_apsd(struct wmi *wmi, u8 if_idx, u8 enable)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 0b05021..5fe1c2c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2135,6 +2135,10 @@ struct wmi_rx_frame_format_cmd {
 	u8 reserved[1];
 } __packed;
 
+struct wmi_ap_hidden_ssid_cmd {
+	u8 hidden_ssid;
+} __packed;
+
 /* AP mode events */
 struct wmi_ap_set_apsd_cmd {
 	u8 enable;
@@ -2497,6 +2501,7 @@ u8 ath6kl_wmi_get_traffic_class(u8 user_priority);
 
 u8 ath6kl_wmi_determine_user_priority(u8 *pkt, u32 layer2_pri);
 /* AP mode */
+int ath6kl_wmi_ap_hidden_ssid(struct wmi *wmi, u8 if_idx, bool enable);
 int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, u8 if_idx,
 				 struct wmi_connect_cmd *p);
 
-- 
1.7.5.4

