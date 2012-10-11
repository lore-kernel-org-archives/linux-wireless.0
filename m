Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2889 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab2JKQSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 12:18:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [RFC] wireless: cfg80211: add peer-to-peer related definitions
Date: Thu, 11 Oct 2012 16:18:24 +0200
Message-ID: <1349965104-14475-1-git-send-email-arend@broadcom.com> (sfid-20121011_181908_360457_F08CE2D4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Peer-to-Peer IE is vendor-specific IE identified by WiFi Alliance
OUI and specific P2P OUI type. The payload of this IE consists of
so-called P2P attributes. This patch adds definitions for processing
these attributes.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Johannes,

This patch is for 3.8. It applies to mac80211-next repository.

Gr. AvS
---
 include/linux/ieee80211.h |   78 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 8c803f0..7c4c075 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -168,6 +168,9 @@
 #define IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK	0x03
 #define IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT	5
 
+/* Vendor-specific IE */
+#define IEEE80211_VENDOR_SPEC_IE		0xDD
+
 #define IEEE80211_HT_CTL_LEN		4
 
 struct ieee80211_hdr {
@@ -905,6 +908,81 @@ struct ieee80211_tdls_data {
 	} u;
 } __packed;
 
+/*
+ * Peer-to-Peer IE attribute related definitions.
+ */
+/**
+ * enum ieee80211_p2p_attr_id - identifies type of peer-to-peer attribute.
+ */
+enum ieee80211_p2p_attr_id {
+	IEEE80211_P2P_ATTR_STATUS = 0,
+	IEEE80211_P2P_ATTR_MINOR_REASON,
+	IEEE80211_P2P_ATTR_CAPABILITY,
+	IEEE80211_P2P_ATTR_DEVICE_ID,
+	IEEE80211_P2P_ATTR_GO_INTENT,
+	IEEE80211_P2P_ATTR_GO_CONFIG_TIMEOUT,
+	IEEE80211_P2P_ATTR_LISTEN_CHANNEL,
+	IEEE80211_P2P_ATTR_GROUP_BSSID,
+	IEEE80211_P2P_ATTR_EXT_LISTEN_TIMING,
+	IEEE80211_P2P_ATTR_INTENDED_IFACE_ADDR,
+	IEEE80211_P2P_ATTR_MANAGABILITY,
+	IEEE80211_P2P_ATTR_CHANNEL_LIST,
+	IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
+	IEEE80211_P2P_ATTR_DEVICE_INFO,
+	IEEE80211_P2P_ATTR_GROUP_INFO,
+	IEEE80211_P2P_ATTR_GROUP_ID,
+	IEEE80211_P2P_ATTR_INTERFACE,
+	IEEE80211_P2P_ATTR_OPER_CHANNEL,
+	IEEE80211_P2P_ATTR_INVITE_FLAGS,
+	/* 19 - 220: Reserved */
+	IEEE80211_P2P_ATTR_VENDOR_SPECIFIC = 221,
+
+	IEEE80211_P2P_ATTR_MAX
+};
+
+struct ieee80211_p2p_chan_attr {
+	u8 country[3];
+	u8 class;
+	u8 channel;
+} __packed;
+
+/**
+ * struct ieee80211_p2p_attribute - attributes in WFA P2P vendor specific IE.
+ *
+ * @id: identifier according enum ieee80211_p2p_attr_id.
+ * @length: length of data buffer mapped by @u.
+ * @u: union holding information for this peer-to-peer attribute.
+ */
+struct ieee80211_p2p_attribute {
+	u8 id;
+	__le16 length;
+	union {
+		u8 status;
+		u8 minor_reason;
+		struct {
+			u8 device;
+			u8 group;
+		} __packed cap;
+		u8 devid[6];
+		u8 go_intent;
+		struct {
+			u8 group;
+			u8 client;
+		} __packed cfg_timeout;
+		struct ieee80211_p2p_chan_attr listen;
+		u8 bssid[6];
+		struct {
+			__le16 period;
+			__le16 interval;
+		} __packed listen_availability;
+		u8 ifc_addr[6];
+		u8 managability;
+		struct ieee80211_p2p_chan_attr operating;
+		u8 invitation;
+		u8 var_attr[0];
+	} u;
+} __packed;
+
 /**
  * struct ieee80211_bar - HT Block Ack Request
  *
-- 
1.7.9.5


