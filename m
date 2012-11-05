Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3694 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab2KEO3Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 09:29:24 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] wireless: add peer-to-peer related definitions
Date: Mon, 5 Nov 2012 15:29:09 +0100
Message-ID: <1352125749-4500-1-git-send-email-arend@broadcom.com> (sfid-20121105_152947_613589_FE5E65ED)
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

I reworked the patch adding only the enumeration.

Gr. AvS
---
 include/linux/ieee80211.h |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 85764a9..4530d49 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -905,6 +905,38 @@ struct ieee80211_tdls_data {
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
 /**
  * struct ieee80211_bar - HT Block Ack Request
  *
-- 
1.7.9.5


