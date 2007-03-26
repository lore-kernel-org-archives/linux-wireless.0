Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48198 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933662AbXCZWh1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 18:37:27 -0400
Subject: [patch 1/5] Add draft IEEE 802.11n data structures and constants
From: mohamed <mabbas@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Content-Type: text/plain
Date: Mon, 26 Mar 2007 04:36:39 -0700
Message-Id: <1174908999.1364.50.camel@dell-4965.jf.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add draft IEEE 802.11n data structures and constants to ieee80211.h

Several information element were added to support 80211n capabilities.
This patch adds all data structures related to these information
element. 

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>

diff -Nupr wireless-dev/include/linux/ieee80211.h
wireless-dev-new/include/linux/ieee80211.h
--- wireless-dev/include/linux/ieee80211.h	2007-03-23 13:07:38.000000000
-0700
+++ wireless-dev-new/include/linux/ieee80211.h	2007-03-23
12:35:07.000000000 -0700
@@ -105,6 +105,23 @@ struct ieee80211_hdr {
 } __attribute__ ((packed));
 
 
+struct ieee80211_ht_capability {
+	__le16 capabilitiesInfo;
+	u8 mac_ht_params_info;
+	u8 supported_mcs_set[16];
+	__le16 extended_ht_capability_info;
+	__le32 tx_BF_capability_info;
+	u8 antenna_selection_info;
+}__attribute__ ((packed));
+
+struct ieee80211_ht_additional_info {
+	u8 control_chan;
+	u8 ht_param;
+	__le16 operation_mode;
+	__le16 stbc_param;
+	u8 basic_set[16];
+}__attribute__ ((packed));
+
 struct ieee80211_mgmt {
 	__le16 frame_control;
 	__le16 duration;
@@ -319,6 +336,9 @@ enum ieee80211_eid {
 	/* 802.11g */
 	WLAN_EID_ERP_INFO = 42,
 	WLAN_EID_EXT_SUPP_RATES = 50,
+	/* 802.11n */
+        WLAN_EID_HT_CAPABILITY = 45,
+        WLAN_EID_HT_EXTRA_INFO = 61,
 	/* 802.11i */
 	WLAN_EID_RSN = 48,
 	WLAN_EID_WPA = 221,
 
 
