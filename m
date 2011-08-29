Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25741 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1H2M1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 08:27:46 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 04/20] ath6kl: Use change_station() to authorize/unauthorize STAs
Date: Mon, 29 Aug 2011 15:23:45 +0300
Message-ID: <1314620641-24257-5-git-send-email-jouni@qca.qualcomm.com> (sfid-20110829_142749_001650_3B683F1B)
In-Reply-To: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   18 ++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   17 +++++++++++++++++
 3 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0bfd5b0..898f394 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1637,6 +1637,25 @@ static int ath6kl_del_beacon(struct wiphy *wiphy, struct net_device *dev)
 	return 0;
 }
 
+static int ath6kl_change_station(struct wiphy *wiphy, struct net_device *dev,
+				 u8 *mac, struct station_parameters *params)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+
+	if (ar->nw_type != AP_NETWORK)
+		return -EOPNOTSUPP;
+
+	/* Use this only for authorizing/unauthorizing a station */
+	if (!(params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED)))
+		return -EOPNOTSUPP;
+
+	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_AUTHORIZED))
+		return ath6kl_wmi_ap_set_mlme(ar->wmi, WMI_AP_MLME_AUTHORIZE,
+					      mac, 0);
+	return ath6kl_wmi_ap_set_mlme(ar->wmi, WMI_AP_MLME_UNAUTHORIZE, mac,
+				      0);
+}
+
 static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.change_virtual_intf = ath6kl_cfg80211_change_iface,
 	.scan = ath6kl_cfg80211_scan,
@@ -1663,6 +1682,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.add_beacon = ath6kl_add_beacon,
 	.set_beacon = ath6kl_set_beacon,
 	.del_beacon = ath6kl_del_beacon,
+	.change_station = ath6kl_change_station,
 };
 
 struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index eb8f6b1..5c6688b 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2421,6 +2421,24 @@ int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, struct wmi_connect_cmd *p)
 	return res;
 }
 
+int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 cmd, const u8 *mac, u16 reason)
+{
+	struct sk_buff *skb;
+	struct wmi_ap_set_mlme_cmd *cm;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cm));
+	if (!skb)
+		return -ENOMEM;
+
+	cm = (struct wmi_ap_set_mlme_cmd *) skb->data;
+	memcpy(cm->mac, mac, ETH_ALEN);
+	cm->reason = cpu_to_le16(reason);
+	cm->cmd = cmd;
+
+	return ath6kl_wmi_cmd_send(wmip, skb, WMI_AP_SET_MLME_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 static int ath6kl_wmi_pspoll_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	struct wmi_pspoll_event *ev;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 1d96afd..2d22c7f9 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1804,6 +1804,21 @@ struct wmi_tx_complete_event {
 
 /* Used with WMI_AP_SET_NUM_STA_CMDID */
 
+/*
+ * Used with WMI_AP_SET_MLME_CMDID
+ */
+struct wmi_ap_set_mlme_cmd {
+	u8 mac[ETH_ALEN];
+	u16 reason;		/* 802.11 reason code */
+	u8 cmd;			/* operation to perform */
+/* MLME Commands */
+#define WMI_AP_MLME_ASSOC       1   /* associate station */
+#define WMI_AP_DISASSOC         2   /* disassociate station */
+#define WMI_AP_DEAUTH           3   /* deauthenticate station */
+#define WMI_AP_MLME_AUTHORIZE   4   /* authorize station */
+#define WMI_AP_MLME_UNAUTHORIZE 5   /* unauthorize station */
+} __packed;
+
 struct wmi_ap_set_pvb_cmd {
 	__le32 flag;
 	__le16 aid;
@@ -2023,6 +2038,8 @@ void ath6kl_wmi_node_return(struct wmi *wmi, struct bss *bss);
 /* AP mode */
 int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, struct wmi_connect_cmd *p);
 
+int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 cmd, const u8 *mac, u16 reason);
+
 int ath6kl_wmi_set_pvb_cmd(struct wmi *wmi, u16 aid, bool flag);
 
 int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 rx_meta_version,
-- 
1.7.4.1

