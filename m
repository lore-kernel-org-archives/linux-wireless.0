Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbYBWOWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:22:04 -0500
Message-Id: <20080223142007.221019000@sipsolutions.net> (sfid-20080223_142344_230465_D3A87F6E)
References: <20080223141703.194775000@sipsolutions.net>
Date: Sat, 23 Feb 2008 15:17:04 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 01/18] wireless: various definitions for mesh networking
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis Carlos Cobo <luisca@cozybit.com>

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- everything.orig/include/linux/ieee80211.h	2008-02-23 14:11:44.000000000 +0100
+++ everything/include/linux/ieee80211.h	2008-02-23 14:11:52.000000000 +0100
@@ -97,6 +97,7 @@
 #define IEEE80211_MAX_FRAME_LEN		2352
 
 #define IEEE80211_MAX_SSID_LEN		32
+#define IEEE80211_MAX_MESH_ID_LEN	32
 
 struct ieee80211_hdr {
 	__le16 frame_control;
@@ -109,6 +110,16 @@ struct ieee80211_hdr {
 } __attribute__ ((packed));
 
 
+struct ieee80211s_hdr {
+	u8 flags;
+	u8 ttl;
+	u8 seqnum[3];
+	u8 eaddr1[6];
+	u8 eaddr2[6];
+	u8 eaddr3[6];
+} __attribute__ ((packed));
+
+
 struct ieee80211_mgmt {
 	__le16 frame_control;
 	__le16 duration;
@@ -206,6 +217,23 @@ struct ieee80211_mgmt {
 					__le16 params;
 					__le16 reason_code;
 				} __attribute__((packed)) delba;
+				struct{
+					u8 action_code;
+					/* capab_info for open and confirm,
+					 * reason for close
+					 */
+					__le16 aux;
+					/* Followed in plink_confirm by status
+					 * code, AID and supported rates,
+					 * and directly by supported rates in
+					 * plink_open and plink_close
+					 */
+					u8 variable[0];
+				} __attribute__((packed)) plink_action;
+				struct{
+					u8 action_code;
+					u8 variable[0];
+				} __attribute__((packed)) mesh_action;
 			} u;
 		} __attribute__ ((packed)) action;
 	} u;
@@ -437,6 +465,13 @@ enum ieee80211_eid {
 	WLAN_EID_TS_DELAY = 43,
 	WLAN_EID_TCLAS_PROCESSING = 44,
 	WLAN_EID_QOS_CAPA = 46,
+	/* 802.11s */
+	WLAN_EID_MESH_CONFIG = 36,      /* Pending IEEE 802.11 ANA approval */
+	WLAN_EID_MESH_ID = 37,          /* Pending IEEE 802.11 ANA approval */
+	WLAN_EID_PEER_LINK = 40,	/* Pending IEEE 802.11 ANA approval */
+	WLAN_EID_PREQ = 53,		/* Pending IEEE 802.11 ANA approval */
+	WLAN_EID_PREP = 54,		/* Pending IEEE 802.11 ANA approval */
+	WLAN_EID_PERR = 55,		/* Pending IEEE 802.11 ANA approval */
 	/* 802.11h */
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,

-- 

