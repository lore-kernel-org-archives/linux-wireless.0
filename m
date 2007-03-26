Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:46945 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933691AbXCZWnP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 18:43:15 -0400
Subject: [patch 4/5] IEEE 802.11n management action frame data structures
From: mohamed <mabbas@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Content-Type: text/plain
Date: Mon, 26 Mar 2007 04:42:22 -0700
Message-Id: <1174909342.1364.60.camel@dell-4965.jf.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add draft IEEE 802.11n management action frame data structures and
constants

Several Action frame format are defined to support IEEE 802.11n
features. 
This patch add the data structure for Block Ack management action frame.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>

diff -Nupr wireless-dev/include/linux/ieee80211.h
wireless-dev-new/include/linux/ieee80211.h
--- wireless-dev/include/linux/ieee80211.h	2007-03-23 13:25:24.000000000
-0700
+++ wireless-dev-new/include/linux/ieee80211.h	2007-03-23
13:43:21.000000000 -0700
@@ -105,6 +105,19 @@ struct ieee80211_hdr {
 } __attribute__ ((packed));
 
 
+struct ieee802_11_addba_param {
+	 __le16 reserved:1;
+	 __le16 backPolicy:1;
+	 __le16 tid:4;
+	 __le16 bufSize:10;
+} __attribute__ ((packed));
+
+struct ieee80211_delba_param {
+	 __le16 reserved:11;
+	 __le16 intiator:1;
+	 __le16 tid:4;
+}__attribute__ ((packed));
+
 struct ieee80211_ht_capability {
 	__le16 capabilitiesInfo;
 	u8 mac_ht_params_info;
@@ -200,6 +213,25 @@ struct ieee80211_mgmt {
 					__u8 new_chan;
 					__u8 switch_count;
 				} __attribute__((packed)) chan_switch;
+				struct{
+					u8 action_code;
+					u8 dialog_token;
+					struct ieee802_11_addba_param capab;
+					__le16 timeout;
+					__le16 start_seq_num;
+				} __attribute__((packed)) addba_req;
+				struct{
+					u8 action_code;
+					u8 dialog_token;
+					__le16 status;
+					struct ieee802_11_addba_param capab;
+					__le16 timeout;
+				} __attribute__((packed)) addba_resp;
+				struct{
+					u8 action_code;	
+					struct ieee80211_delba_param params;
+					__le16 reason_code;
+				}__attribute__((packed)) delba;
 			} u;
 		} __attribute__ ((packed)) action;
 	} u;
@@ -266,6 +298,8 @@ enum ieee80211_statuscode {
 	/* 802.11g */
 	WLAN_STATUS_ASSOC_DENIED_NOSHORTTIME = 25,
 	WLAN_STATUS_ASSOC_DENIED_NODSSSOFDM = 26,
+	/* 802.11e */
+	WLAN_STATUS_REQUEST_DECLINED = 37,
 	/* 802.11i */
 	WLAN_STATUS_INVALID_IE = 40,
 	WLAN_STATUS_INVALID_GROUP_CIPHER = 41,
@@ -307,6 +341,23 @@ enum ieee80211_reasoncode {
 };
 
 
+/* Category Code */
+enum ieee80211_category {
+	WLAN_CATEGORY_SPECTRUM_MGMT = 0,
+	WLAN_CATEGORY_QOS = 1,
+	WLAN_CATEGORY_DLS = 2,
+	WLAN_CATEGORY_BACK = 3,
+	WLAN_CATEGORY_WMM = 17,
+};
+
+
+/* BACK Action Code */
+enum ieee80211_back_actioncode {
+	WLAN_ACTION_ADDBA_REQ = 0,
+	WLAN_ACTION_ADDBA_RESP = 1,
+	WLAN_ACTION_DELBA = 2,
+};
+
 /* Information Element IDs */
 enum ieee80211_eid {
 	WLAN_EID_SSID = 0,
