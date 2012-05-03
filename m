Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:37298 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755391Ab2ECHXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:23:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	harvey yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 13/18] mwifiex: add AP event handling framework
Date: Thu,  3 May 2012 00:22:35 -0700
Message-Id: <1336029760-22565-14-git-send-email-bzhao@marvell.com> (sfid-20120503_092405_448812_C7EBB50B)
In-Reply-To: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Added logic to handle AP event that are generated
by the firmware. As MLME/SME is implemented in the
firmware, events such as station association and
deauthentication, must be sent to userspace (hostapd)
for creating and deleting station database.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |    5 +++
 drivers/net/wireless/mwifiex/fw.h        |   18 ++++++++++-
 drivers/net/wireless/mwifiex/main.h      |    1 +
 drivers/net/wireless/mwifiex/sta_event.c |   51 +++++++++++++++++++++++++++++-
 4 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 07e38e3..5a0f20c 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1237,6 +1237,11 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		goto done;
 	}
 
+	if (priv->bss_mode == NL80211_IFTYPE_AP) {
+		wiphy_err(wiphy, "skip association request for AP interface\n");
+		goto done;
+	}
+
 	wiphy_dbg(wiphy, "info: Trying to associate to %s and bssid %pM\n",
 		  (char *) sme->ssid, sme->bssid);
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 07243c0..77f82fc 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -117,6 +117,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_POWER_GROUP        (PROPRIETARY_TLV_BASE_ID + 84)
 #define TLV_TYPE_UAP_RETRY_LIMIT    (PROPRIETARY_TLV_BASE_ID + 93)
 #define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
+#define TLV_TYPE_UAP_MGMT_FRAME     (PROPRIETARY_TLV_BASE_ID + 104)
 #define TLV_TYPE_MGMT_IE            (PROPRIETARY_TLV_BASE_ID + 105)
 #define TLV_TYPE_AUTO_DS_PARAM      (PROPRIETARY_TLV_BASE_ID + 113)
 #define TLV_TYPE_PS_PARAM           (PROPRIETARY_TLV_BASE_ID + 114)
@@ -324,15 +325,20 @@ enum ENH_PS_MODES {
 #define EVENT_DATA_SNR_HIGH             0x00000027
 #define EVENT_LINK_QUALITY              0x00000028
 #define EVENT_PORT_RELEASE              0x0000002b
+#define EVENT_UAP_STA_DEAUTH            0x0000002c
+#define EVENT_UAP_STA_ASSOC             0x0000002d
+#define EVENT_UAP_BSS_START             0x0000002e
 #define EVENT_PRE_BEACON_LOST           0x00000031
 #define EVENT_ADDBA                     0x00000033
 #define EVENT_DELBA                     0x00000034
 #define EVENT_BA_STREAM_TIEMOUT         0x00000037
 #define EVENT_AMSDU_AGGR_CTRL           0x00000042
+#define EVENT_UAP_BSS_IDLE              0x00000043
+#define EVENT_UAP_BSS_ACTIVE            0x00000044
 #define EVENT_WEP_ICV_ERR               0x00000046
 #define EVENT_HS_ACT_REQ                0x00000047
 #define EVENT_BW_CHANGE                 0x00000048
-
+#define EVENT_UAP_MIC_COUNTERMEASURES   0x0000004c
 #define EVENT_HOSTWAKE_STAIE		0x0000004d
 
 #define EVENT_ID_MASK                   0xffff
@@ -1119,6 +1125,16 @@ struct host_cmd_tlv {
 	__le16 len;
 } __packed;
 
+struct mwifiex_assoc_event {
+	u8 sta_addr[ETH_ALEN];
+	__le16 type;
+	__le16 len;
+	__le16 frame_control;
+	__le16 cap_info;
+	__le16 listen_interval;
+	u8 data[0];
+} __packed;
+
 struct host_cmd_ds_sys_config {
 	__le16 action;
 	u8 tlv[0];
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index acea8d4..b0a8338 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -116,6 +116,7 @@ enum {
 #define MAX_FREQUENCY_BAND_BG   2484
 
 #define MWIFIEX_EVENT_HEADER_LEN           4
+#define MWIFIEX_UAP_EVENT_EXTRA_HEADER	   2
 
 #define MWIFIEX_TYPE_LEN			4
 #define MWIFIEX_USB_TYPE_CMD			0xF00DFACE
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index f6bbb93..4ace5a3 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -184,8 +184,10 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 int mwifiex_process_sta_event(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int ret = 0;
+	int len, ret = 0;
 	u32 eventcause = adapter->event_cause;
+	struct station_info sinfo;
+	struct mwifiex_assoc_event *event;
 
 	switch (eventcause) {
 	case EVENT_DUMMY_HOST_WAKEUP_SIGNAL:
@@ -402,6 +404,53 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 	case EVENT_HOSTWAKE_STAIE:
 		dev_dbg(adapter->dev, "event: HOSTWAKE_STAIE %d\n", eventcause);
 		break;
+
+	case EVENT_UAP_STA_ASSOC:
+		skb_pull(adapter->event_skb, MWIFIEX_UAP_EVENT_EXTRA_HEADER);
+		memset(&sinfo, 0, sizeof(sinfo));
+		event = (struct mwifiex_assoc_event *)adapter->event_skb->data;
+		if (le16_to_cpu(event->type) == TLV_TYPE_UAP_MGMT_FRAME) {
+			len = -1;
+
+			if (ieee80211_is_assoc_req(event->frame_control))
+				len = 0;
+			else if (ieee80211_is_reassoc_req(event->frame_control))
+				/* There will be ETH_ALEN bytes of
+				 * current_ap_addr before the re-assoc ies.
+				 */
+				len = ETH_ALEN;
+
+			if (len != -1) {
+				sinfo.filled = STATION_INFO_ASSOC_REQ_IES;
+				sinfo.assoc_req_ies = (u8 *)&event->data[len];
+				len = (u8 *)sinfo.assoc_req_ies -
+				      (u8 *)&event->frame_control;
+				sinfo.assoc_req_ies_len =
+					le16_to_cpu(event->len) - (u16)len;
+			}
+		}
+		cfg80211_new_sta(priv->netdev, event->sta_addr, &sinfo,
+				 GFP_KERNEL);
+		break;
+	case EVENT_UAP_STA_DEAUTH:
+		skb_pull(adapter->event_skb, MWIFIEX_UAP_EVENT_EXTRA_HEADER);
+		cfg80211_del_sta(priv->netdev, adapter->event_skb->data,
+				 GFP_KERNEL);
+		break;
+	case EVENT_UAP_BSS_IDLE:
+		priv->media_connected = false;
+		break;
+	case EVENT_UAP_BSS_ACTIVE:
+		priv->media_connected = true;
+		break;
+	case EVENT_UAP_BSS_START:
+		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
+		memcpy(priv->netdev->dev_addr, adapter->event_body+2, ETH_ALEN);
+		break;
+	case EVENT_UAP_MIC_COUNTERMEASURES:
+		/* For future development */
+		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
+		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
-- 
1.7.0.2

