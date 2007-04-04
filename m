Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:19620 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992442AbXDCWgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2007 18:36:10 -0400
Message-ID: <46137FDE.3050401@linux.intel.com>
Date: Wed, 04 Apr 2007 03:37:18 -0700
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
CC: mabbas@linux.intel.com
Subject: Re: [patch 1/5] Add draft IEEE 802.11n data structures and constants
References: <1174908999.1364.50.camel@dell-4965.jf.intel.com> <b3153e950704031518v11971e20nab4879da9629a475@mail.gmail.com>
In-Reply-To: <b3153e950704031518v11971e20nab4879da9629a475@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

modified patch at the end

Add draft IEEE 802.11n data structures and constants to ieee80211.h

Several information element were added to support 80211n capabilities.
This patch adds all data structures related to these information element.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ae19306..6bf824b 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -106,6 +106,23 @@ struct ieee80211_hdr {
 } __attribute__ ((packed));
 
 
+struct ieee80211_ht_capability {
+	__le16 capabilities_info;
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
@@ -321,6 +338,9 @@ enum ieee80211_eid {
 	/* 802.11g */
 	WLAN_EID_ERP_INFO = 42,
 	WLAN_EID_EXT_SUPP_RATES = 50,
+	/* 802.11n */
+	WLAN_EID_HT_CAPABILITY = 45,
+	WLAN_EID_HT_EXTRA_INFO = 61,
 	/* 802.11i */
 	WLAN_EID_RSN = 48,
 	WLAN_EID_WPA = 221,
@@ -329,6 +349,9 @@ enum ieee80211_eid {
 	WLAN_EID_QOS_PARAMETER = 222
 };
 
+/* 80211n */
+#define IEEE80211_QOS_CONTROL_A_MSDU_PRESENT 0x0080
+
 /* cipher suite selectors */
 #define WLAN_CIPHER_SUITE_USE_GROUP	0x000FAC00
 #define WLAN_CIPHER_SUITE_WEP40		0x000FAC01
