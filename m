Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946785Ab3BHRZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:25:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 04/14] wireless: define VHT operating mode action frame
Date: Fri,  8 Feb 2013 18:25:34 +0100
Message-Id: <1360344344-15742-5-git-send-email-johannes@sipsolutions.net> (sfid-20130208_182838_220591_90E0733A)
In-Reply-To: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Define the action frame format, the VHT category
and its action types and the field format and EID
for operating mode notifications.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 8d74522..6496545 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -726,6 +726,30 @@ enum ieee80211_ht_chanwidth_values {
 	IEEE80211_HT_CHANWIDTH_ANY = 1,
 };
 
+/**
+ * enum ieee80211_vht_opmode_bits - VHT operating mode field bits
+ * @IEEE80211_VHT_OPMODE_CHANWIDTH_MASK: channel width mask
+ * @IEEE80211_VHT_OPMODE_CHANWIDTH_20MHZ: 20 MHz channel width
+ * @IEEE80211_VHT_OPMODE_CHANWIDTH_40MHZ: 40 MHz channel width
+ * @IEEE80211_VHT_OPMODE_CHANWIDTH_80MHZ: 80 MHz channel width
+ * @IEEE80211_VHT_OPMODE_CHANWIDTH_160MHZ: 160 MHz or 80+80 MHz channel width
+ * @IEEE80211_VHT_OPMODE_RX_NSS_MASK: number of spatial streams mask
+ *	(the NSS value is the value of this field + 1)
+ * @IEEE80211_VHT_OPMODE_RX_NSS_SHIFT: number of spatial streams shift
+ * @IEEE80211_VHT_OPMODE_RX_NSS_TYPE_BF: indicates streams in SU-MIMO PPDU
+ *	using a beamforming steering matrix
+ */
+enum ieee80211_vht_opmode_bits {
+	IEEE80211_VHT_OPMODE_CHANWIDTH_MASK	= 3,
+	IEEE80211_VHT_OPMODE_CHANWIDTH_20MHZ	= 0,
+	IEEE80211_VHT_OPMODE_CHANWIDTH_40MHZ	= 1,
+	IEEE80211_VHT_OPMODE_CHANWIDTH_80MHZ	= 2,
+	IEEE80211_VHT_OPMODE_CHANWIDTH_160MHZ	= 3,
+	IEEE80211_VHT_OPMODE_RX_NSS_MASK	= 0x70,
+	IEEE80211_VHT_OPMODE_RX_NSS_SHIFT	= 4,
+	IEEE80211_VHT_OPMODE_RX_NSS_TYPE_BF	= 0x80,
+};
+
 #define WLAN_SA_QUERY_TR_ID_LEN 2
 
 struct ieee80211_mgmt {
@@ -856,6 +880,10 @@ struct ieee80211_mgmt {
 					__le16 capability;
 					u8 variable[0];
 				} __packed tdls_discover_resp;
+				struct {
+					u8 action_code;
+					u8 operating_mode;
+				} __packed vht_opmode_notif;
 			} u;
 		} __packed action;
 	} u;
@@ -1610,6 +1638,7 @@ enum ieee80211_eid {
 
 	WLAN_EID_VHT_CAPABILITY = 191,
 	WLAN_EID_VHT_OPERATION = 192,
+	WLAN_EID_VHT_OPMODE_NOTIF = 199,
 
 	/* 802.11ad */
 	WLAN_EID_NON_TX_BSSID_CAP =  83,
@@ -1664,6 +1693,7 @@ enum ieee80211_category {
 	WLAN_CATEGORY_WMM = 17,
 	WLAN_CATEGORY_FST = 18,
 	WLAN_CATEGORY_UNPROT_DMG = 20,
+	WLAN_CATEGORY_VHT = 21,
 	WLAN_CATEGORY_VENDOR_SPECIFIC_PROTECTED = 126,
 	WLAN_CATEGORY_VENDOR_SPECIFIC = 127,
 };
@@ -1689,6 +1719,13 @@ enum ieee80211_ht_actioncode {
 	WLAN_HT_ACTION_ASEL_IDX_FEEDBACK = 7,
 };
 
+/* VHT action codes */
+enum ieee80211_vht_actioncode {
+	WLAN_VHT_ACTION_COMPRESSED_BF = 0,
+	WLAN_VHT_ACTION_GROUPID_MGMT = 1,
+	WLAN_VHT_ACTION_OPMODE_NOTIF = 2,
+};
+
 /* Self Protected Action codes */
 enum ieee80211_self_protected_actioncode {
 	WLAN_SP_RESERVED = 0,
-- 
1.8.0

