Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:19855 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992443AbXDCWgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2007 18:36:31 -0400
Message-ID: <46137FFA.6080202@linux.intel.com>
Date: Wed, 04 Apr 2007 03:37:46 -0700
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mabbas@linux.intel.com
Subject: Re: [patch 4/5] IEEE 802.11n management action frame data structures
References: <1174909342.1364.60.camel@dell-4965.jf.intel.com> <20070326164503.f276cd71.randy.dunlap@oracle.com>
In-Reply-To: <20070326164503.f276cd71.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

modified patch at the end

Randy Dunlap wrote:
> On Mon, 26 Mar 2007 04:42:22 -0700 mohamed wrote:
>
>   
>>  
>> +struct ieee802_11_addba_param {
>> +	 __le16 reserved:1;
>> +	 __le16 backPolicy:1;
>> +	 __le16 tid:4;
>> +	 __le16 bufSize:10;
>> +} __attribute__ ((packed));
>> +
>> +struct ieee80211_delba_param {
>> +	 __le16 reserved:11;
>> +	 __le16 intiator:1;
>> +	 __le16 tid:4;
>> +}__attribute__ ((packed));
>>     
>
> These bitfields are all local to one machine, not transported
> across a network to systems where the bitfields may be represented
> differently?
>
>
>   


Add draft IEEE 802.11n management action frame data structures and constants

Several Action frame format are defined to support IEEE 802.11n features.
This patch add the data structure for Block Ack management action frame.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 6bf824b..6d2c20e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -201,6 +201,25 @@ struct ieee80211_mgmt {
 					__u8 new_chan;
 					__u8 switch_count;
 				} __attribute__((packed)) chan_switch;
+				struct{
+					u8 action_code;
+					u8 dialog_token;
+					__le16 capab;
+					__le16 timeout;
+					__le16 start_seq_num;
+				} __attribute__((packed)) addba_req;
+				struct{
+					u8 action_code;
+					u8 dialog_token;
+					__le16 status;
+					__le16 capab;
+					__le16 timeout;
+				} __attribute__((packed)) addba_resp;
+				struct{
+					u8 action_code;	
+					__le16 params;
+					__le16 reason_code;
+				}__attribute__((packed)) delba;
 			} u;
 		} __attribute__ ((packed)) action;
 	} u;
@@ -268,6 +287,8 @@ enum ieee80211_statuscode {
 	/* 802.11g */
 	WLAN_STATUS_ASSOC_DENIED_NOSHORTTIME = 25,
 	WLAN_STATUS_ASSOC_DENIED_NODSSSOFDM = 26,
+	/* 802.11e */
+	WLAN_STATUS_REQUEST_DECLINED = 37,
 	/* 802.11i */
 	WLAN_STATUS_INVALID_IE = 40,
 	WLAN_STATUS_INVALID_GROUP_CIPHER = 41,
@@ -309,6 +330,23 @@ enum ieee80211_reasoncode {
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
