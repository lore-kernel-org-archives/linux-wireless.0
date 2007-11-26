Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32326 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbXKZOVl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 09:21:41 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 02/15] mac80211: adding 802.11n definitions in ieee80211.h
Date: Mon, 26 Nov 2007 16:14:29 +0200
Message-Id: <11960864902404-git-send-email-ron.rindjunsky@intel.com> (sfid-20071126_142151_750020_10D73D33)
In-Reply-To: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds several structs and definitions to ieee80211.h
to support 802.11n draft specifications.
As 802.11n depends on and extends the 802.11e standard in several issues,
there are also several definitions that belong to 802.11e.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/linux/ieee80211.h |  134 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 214821a..dcdfc7c 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -54,6 +54,8 @@
 #define IEEE80211_STYPE_ACTION		0x00D0
 
 /* control */
+#define IEEE80211_STYPE_BACK_REQ	0x0080
+#define IEEE80211_STYPE_BACK		0x0090
 #define IEEE80211_STYPE_PSPOLL		0x00A0
 #define IEEE80211_STYPE_RTS		0x00B0
 #define IEEE80211_STYPE_CTS		0x00C0
@@ -185,6 +187,25 @@ struct ieee80211_mgmt {
 					u8 new_chan;
 					u8 switch_count;
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
+				} __attribute__((packed)) delba;
 			} u;
 		} __attribute__ ((packed)) action;
 	} u;
@@ -205,6 +226,66 @@ struct ieee80211_cts {
 	u8 ra[6];
 } __attribute__ ((packed));
 
+/**
+ * struct ieee80211_bar - HT Block Ack Request
+ *
+ * This structure refers to "HT BlockAckReq" as
+ * described in 802.11n draft section 7.2.1.7.1
+ */
+struct ieee80211_bar {
+	__le16 frame_control;
+	__le16 duration;
+	__u8 ra[6];
+	__u8 ta[6];
+	__u16 control;
+	__u16 start_seq_num;
+} __attribute__((packed));
+
+/**
+ * struct ieee80211_ht_cap - HT capabilities
+ *
+ * This structure refers to "HT capabilities element" as
+ * described in 802.11n draft section 7.3.2.52
+ */
+struct ieee80211_ht_cap {
+	__le16 cap_info;
+	u8 ampdu_params_info;
+	u8 supp_mcs_set[16];
+	__le16 extended_ht_cap_info;
+	__le32 tx_BF_cap_info;
+	u8 antenna_selection_info;
+} __attribute__ ((packed));
+
+/**
+ * struct ieee80211_ht_addt_info - HT additional information
+ *
+ * This structure refers to "HT information element" as
+ * described in 802.11n draft section 7.3.2.53
+ */
+struct ieee80211_ht_addt_info {
+	u8 control_chan;
+	u8 ht_param;
+	__le16 operation_mode;
+	__le16 stbc_param;
+	u8 basic_set[16];
+} __attribute__ ((packed));
+
+/* 802.11n HT capabilities masks */
+#define IEEE80211_HT_CAP_SUP_WIDTH		0x0002
+#define IEEE80211_HT_CAP_MIMO_PS		0x000C
+#define IEEE80211_HT_CAP_GRN_FLD		0x0010
+#define IEEE80211_HT_CAP_SGI_20			0x0020
+#define IEEE80211_HT_CAP_SGI_40			0x0040
+#define IEEE80211_HT_CAP_DELAY_BA		0x0400
+#define IEEE80211_HT_CAP_MAX_AMSDU		0x0800
+#define IEEE80211_HT_CAP_AMPDU_FACTOR		0x03
+#define IEEE80211_HT_CAP_AMPDU_DENSITY		0x1C
+/* 802.11n HT IE masks */
+#define IEEE80211_HT_IE_CHA_SEC_OFFSET		0x03
+#define IEEE80211_HT_IE_CHA_WIDTH		0x04
+#define IEEE80211_HT_IE_HT_PROTECTION		0x0003
+#define IEEE80211_HT_IE_NON_GF_STA_PRSNT	0x0004
+#define IEEE80211_HT_IE_NON_HT_STA_PRSNT	0x0010
 
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
@@ -271,6 +352,18 @@ enum ieee80211_statuscode {
 	WLAN_STATUS_UNSUPP_RSN_VERSION = 44,
 	WLAN_STATUS_INVALID_RSN_IE_CAP = 45,
 	WLAN_STATUS_CIPHER_SUITE_REJECTED = 46,
+	/* 802.11e */
+	WLAN_STATUS_UNSPECIFIED_QOS = 32,
+	WLAN_STATUS_ASSOC_DENIED_NOBANDWIDTH = 33,
+	WLAN_STATUS_ASSOC_DENIED_LOWACK = 34,
+	WLAN_STATUS_ASSOC_DENIED_UNSUPP_QOS = 35,
+	WLAN_STATUS_REQUEST_DECLINED = 37,
+	WLAN_STATUS_INVALID_QOS_PARAM = 38,
+	WLAN_STATUS_CHANGE_TSPEC = 39,
+	WLAN_STATUS_WAIT_TS_DELAY = 47,
+	WLAN_STATUS_NO_DIRECT_LINK = 48,
+	WLAN_STATUS_STA_NOT_PRESENT = 49,
+	WLAN_STATUS_STA_NOT_QSTA = 50,
 };
 
 
@@ -301,6 +394,16 @@ enum ieee80211_reasoncode {
 	WLAN_REASON_INVALID_RSN_IE_CAP = 22,
 	WLAN_REASON_IEEE8021X_FAILED = 23,
 	WLAN_REASON_CIPHER_SUITE_REJECTED = 24,
+	/* 802.11e */
+	WLAN_REASON_DISASSOC_UNSPECIFIED_QOS = 32,
+	WLAN_REASON_DISASSOC_QAP_NO_BANDWIDTH = 33,
+	WLAN_REASON_DISASSOC_LOW_ACK = 34,
+	WLAN_REASON_DISASSOC_QAP_EXCEED_TXOP = 35,
+	WLAN_REASON_QSTA_LEAVE_QBSS = 36,
+	WLAN_REASON_QSTA_NOT_USE = 37,
+	WLAN_REASON_QSTA_REQUIRE_SETUP = 38,
+	WLAN_REASON_QSTA_TIMEOUT = 39,
+	WLAN_REASON_QSTA_CIPHER_NOT_SUPP = 45,
 };
 
 
@@ -319,6 +422,15 @@ enum ieee80211_eid {
 	WLAN_EID_HP_PARAMS = 8,
 	WLAN_EID_HP_TABLE = 9,
 	WLAN_EID_REQUEST = 10,
+	/* 802.11e */
+	WLAN_EID_QBSS_LOAD = 11,
+	WLAN_EID_EDCA_PARAM_SET = 12,
+	WLAN_EID_TSPEC = 13,
+	WLAN_EID_TCLAS = 14,
+	WLAN_EID_SCHEDULE = 15,
+	WLAN_EID_TS_DELAY = 43,
+	WLAN_EID_TCLAS_PROCESSING = 44,
+	WLAN_EID_QOS_CAPA = 46,
 	/* 802.11h */
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,
@@ -333,6 +445,9 @@ enum ieee80211_eid {
 	/* 802.11g */
 	WLAN_EID_ERP_INFO = 42,
 	WLAN_EID_EXT_SUPP_RATES = 50,
+	/* 802.11n */
+	WLAN_EID_HT_CAPABILITY = 45,
+	WLAN_EID_HT_EXTRA_INFO = 61,
 	/* 802.11i */
 	WLAN_EID_RSN = 48,
 	WLAN_EID_WPA = 221,
@@ -341,6 +456,25 @@ enum ieee80211_eid {
 	WLAN_EID_QOS_PARAMETER = 222
 };
 
+/* Action category code */
+enum ieee80211_category {
+	WLAN_CATEGORY_SPECTRUM_MGMT = 0,
+	WLAN_CATEGORY_QOS = 1,
+	WLAN_CATEGORY_DLS = 2,
+	WLAN_CATEGORY_BACK = 3,
+	WLAN_CATEGORY_WMM = 17,
+};
+
+/* BACK action code */
+enum ieee80211_back_actioncode {
+	WLAN_ACTION_ADDBA_REQ = 0,
+	WLAN_ACTION_ADDBA_RESP = 1,
+	WLAN_ACTION_DELBA = 2,
+};
+
+/* A-MSDU 802.11n */
+#define IEEE80211_QOS_CONTROL_A_MSDU_PRESENT 0x0080
+
 /* cipher suite selectors */
 #define WLAN_CIPHER_SUITE_USE_GROUP	0x000FAC00
 #define WLAN_CIPHER_SUITE_WEP40		0x000FAC01
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
