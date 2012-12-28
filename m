Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2L1LOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 06:14:33 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: use __packed in ieee80211.h
Date: Fri, 28 Dec 2012 12:14:51 +0100
Message-Id: <1356693291-12102-1-git-send-email-johannes@sipsolutions.net> (sfid-20121228_121443_613309_3CAAEB7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use __packed instead of __attribute__((packed)).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 84 +++++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 77c8873..d827f2f 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -180,7 +180,7 @@ struct ieee80211_hdr {
 	u8 addr3[6];
 	__le16 seq_ctrl;
 	u8 addr4[6];
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee80211_hdr_3addr {
 	__le16 frame_control;
@@ -189,7 +189,7 @@ struct ieee80211_hdr_3addr {
 	u8 addr2[6];
 	u8 addr3[6];
 	__le16 seq_ctrl;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee80211_qos_hdr {
 	__le16 frame_control;
@@ -199,7 +199,7 @@ struct ieee80211_qos_hdr {
 	u8 addr3[6];
 	__le16 seq_ctrl;
 	__le16 qos_ctrl;
-} __attribute__ ((packed));
+} __packed;
 
 /**
  * ieee80211_has_tods - check if IEEE80211_FCTL_TODS is set
@@ -576,7 +576,7 @@ struct ieee80211s_hdr {
 	__le32 seqnum;
 	u8 eaddr1[6];
 	u8 eaddr2[6];
-} __attribute__ ((packed));
+} __packed;
 
 /* Mesh flags */
 #define MESH_FLAGS_AE_A4 	0x1
@@ -614,7 +614,7 @@ struct ieee80211_quiet_ie {
 	u8 period;
 	__le16 duration;
 	__le16 offset;
-} __attribute__ ((packed));
+} __packed;
 
 /**
  * struct ieee80211_msrment_ie
@@ -626,7 +626,7 @@ struct ieee80211_msrment_ie {
 	u8 mode;
 	u8 type;
 	u8 request[0];
-} __attribute__ ((packed));
+} __packed;
 
 /**
  * struct ieee80211_channel_sw_ie
@@ -637,7 +637,7 @@ struct ieee80211_channel_sw_ie {
 	u8 mode;
 	u8 new_ch_num;
 	u8 count;
-} __attribute__ ((packed));
+} __packed;
 
 /**
  * struct ieee80211_ext_chansw_ie
@@ -662,7 +662,7 @@ struct ieee80211_tim_ie {
 	u8 bitmap_ctrl;
 	/* variable size: 1 - 251 bytes */
 	u8 virtual_map[1];
-} __attribute__ ((packed));
+} __packed;
 
 /**
  * struct ieee80211_meshconf_ie
@@ -677,7 +677,7 @@ struct ieee80211_meshconf_ie {
 	u8 meshconf_auth;
 	u8 meshconf_form;
 	u8 meshconf_cap;
-} __attribute__ ((packed));
+} __packed;
 
 /**
  * enum mesh_config_capab_flags - Mesh Configuration IE capability field flags
@@ -707,7 +707,7 @@ struct ieee80211_rann_ie {
 	__le32 rann_seq;
 	__le32 rann_interval;
 	__le32 rann_metric;
-} __attribute__ ((packed));
+} __packed;
 
 enum ieee80211_rann_flags {
 	RANN_FLAG_IS_GATE = 1 << 0,
@@ -729,33 +729,33 @@ struct ieee80211_mgmt {
 			__le16 status_code;
 			/* possibly followed by Challenge text */
 			u8 variable[0];
-		} __attribute__ ((packed)) auth;
+		} __packed auth;
 		struct {
 			__le16 reason_code;
-		} __attribute__ ((packed)) deauth;
+		} __packed deauth;
 		struct {
 			__le16 capab_info;
 			__le16 listen_interval;
 			/* followed by SSID and Supported rates */
 			u8 variable[0];
-		} __attribute__ ((packed)) assoc_req;
+		} __packed assoc_req;
 		struct {
 			__le16 capab_info;
 			__le16 status_code;
 			__le16 aid;
 			/* followed by Supported rates */
 			u8 variable[0];
-		} __attribute__ ((packed)) assoc_resp, reassoc_resp;
+		} __packed assoc_resp, reassoc_resp;
 		struct {
 			__le16 capab_info;
 			__le16 listen_interval;
 			u8 current_ap[6];
 			/* followed by SSID and Supported rates */
 			u8 variable[0];
-		} __attribute__ ((packed)) reassoc_req;
+		} __packed reassoc_req;
 		struct {
 			__le16 reason_code;
-		} __attribute__ ((packed)) disassoc;
+		} __packed disassoc;
 		struct {
 			__le64 timestamp;
 			__le16 beacon_int;
@@ -763,11 +763,11 @@ struct ieee80211_mgmt {
 			/* followed by some of SSID, Supported rates,
 			 * FH Params, DS Params, CF Params, IBSS Params, TIM */
 			u8 variable[0];
-		} __attribute__ ((packed)) beacon;
+		} __packed beacon;
 		struct {
 			/* only variable items: SSID, Supported rates */
 			u8 variable[0];
-		} __attribute__ ((packed)) probe_req;
+		} __packed probe_req;
 		struct {
 			__le64 timestamp;
 			__le16 beacon_int;
@@ -775,7 +775,7 @@ struct ieee80211_mgmt {
 			/* followed by some of SSID, Supported rates,
 			 * FH Params, DS Params, CF Params, IBSS Params */
 			u8 variable[0];
-		} __attribute__ ((packed)) probe_resp;
+		} __packed probe_resp;
 		struct {
 			u8 category;
 			union {
@@ -784,55 +784,55 @@ struct ieee80211_mgmt {
 					u8 dialog_token;
 					u8 status_code;
 					u8 variable[0];
-				} __attribute__ ((packed)) wme_action;
+				} __packed wme_action;
 				struct{
 					u8 action_code;
 					u8 element_id;
 					u8 length;
 					struct ieee80211_channel_sw_ie sw_elem;
-				} __attribute__((packed)) chan_switch;
+				} __packed chan_switch;
 				struct{
 					u8 action_code;
 					u8 dialog_token;
 					u8 element_id;
 					u8 length;
 					struct ieee80211_msrment_ie msr_elem;
-				} __attribute__((packed)) measurement;
+				} __packed measurement;
 				struct{
 					u8 action_code;
 					u8 dialog_token;
 					__le16 capab;
 					__le16 timeout;
 					__le16 start_seq_num;
-				} __attribute__((packed)) addba_req;
+				} __packed addba_req;
 				struct{
 					u8 action_code;
 					u8 dialog_token;
 					__le16 status;
 					__le16 capab;
 					__le16 timeout;
-				} __attribute__((packed)) addba_resp;
+				} __packed addba_resp;
 				struct{
 					u8 action_code;
 					__le16 params;
 					__le16 reason_code;
-				} __attribute__((packed)) delba;
+				} __packed delba;
 				struct {
 					u8 action_code;
 					u8 variable[0];
-				} __attribute__((packed)) self_prot;
+				} __packed self_prot;
 				struct{
 					u8 action_code;
 					u8 variable[0];
-				} __attribute__((packed)) mesh_action;
+				} __packed mesh_action;
 				struct {
 					u8 action;
 					u8 trans_id[WLAN_SA_QUERY_TR_ID_LEN];
-				} __attribute__ ((packed)) sa_query;
+				} __packed sa_query;
 				struct {
 					u8 action;
 					u8 smps_control;
-				} __attribute__ ((packed)) ht_smps;
+				} __packed ht_smps;
 				struct {
 					u8 action_code;
 					u8 dialog_token;
@@ -840,9 +840,9 @@ struct ieee80211_mgmt {
 					u8 variable[0];
 				} __packed tdls_discover_resp;
 			} u;
-		} __attribute__ ((packed)) action;
+		} __packed action;
 	} u;
-} __attribute__ ((packed));
+} __packed;
 
 /* Supported Rates value encodings in 802.11n-2009 7.3.2.2 */
 #define BSS_MEMBERSHIP_SELECTOR_HT_PHY	127
@@ -858,7 +858,7 @@ struct ieee80211_mmie {
 	__le16 key_id;
 	u8 sequence_number[6];
 	u8 mic[8];
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee80211_vendor_ie {
 	u8 element_id;
@@ -873,20 +873,20 @@ struct ieee80211_rts {
 	__le16 duration;
 	u8 ra[6];
 	u8 ta[6];
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee80211_cts {
 	__le16 frame_control;
 	__le16 duration;
 	u8 ra[6];
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee80211_pspoll {
 	__le16 frame_control;
 	__le16 aid;
 	u8 bssid[6];
 	u8 ta[6];
-} __attribute__ ((packed));
+} __packed;
 
 /* TDLS */
 
@@ -979,7 +979,7 @@ struct ieee80211_bar {
 	__u8 ta[6];
 	__le16 control;
 	__le16 start_seq_num;
-} __attribute__((packed));
+} __packed;
 
 /* 802.11 BAR control masks */
 #define IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL	0x0000
@@ -1004,7 +1004,7 @@ struct ieee80211_mcs_info {
 	__le16 rx_highest;
 	u8 tx_params;
 	u8 reserved[3];
-} __attribute__((packed));
+} __packed;
 
 /* 802.11n HT capability MSC set */
 #define IEEE80211_HT_MCS_RX_HIGHEST_MASK	0x3ff
@@ -1043,7 +1043,7 @@ struct ieee80211_ht_cap {
 	__le16 extended_ht_cap_info;
 	__le32 tx_BF_cap_info;
 	u8 antenna_selection_info;
-} __attribute__ ((packed));
+} __packed;
 
 /* 802.11n HT capabilities masks (for cap_info) */
 #define IEEE80211_HT_CAP_LDPC_CODING		0x0001
@@ -1114,7 +1114,7 @@ struct ieee80211_ht_operation {
 	__le16 operation_mode;
 	__le16 stbc_param;
 	u8 basic_set[16];
-} __attribute__ ((packed));
+} __packed;
 
 /* for ht_param */
 #define IEEE80211_HT_PARAM_CHA_SEC_OFFSET		0x03
@@ -1851,14 +1851,14 @@ struct ieee80211_country_ie_triplet {
 			u8 first_channel;
 			u8 num_channels;
 			s8 max_power;
-		} __attribute__ ((packed)) chans;
+		} __packed chans;
 		struct {
 			u8 reg_extension_id;
 			u8 reg_class;
 			u8 coverage_class;
-		} __attribute__ ((packed)) ext;
+		} __packed ext;
 	};
-} __attribute__ ((packed));
+} __packed;
 
 enum ieee80211_timeout_interval_type {
 	WLAN_TIMEOUT_REASSOC_DEADLINE = 1 /* 802.11r */,
-- 
1.8.0

