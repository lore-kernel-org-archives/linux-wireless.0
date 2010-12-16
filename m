Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51851 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab0LPA6B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 19:58:01 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: convert uses of __attribute__ ((packed)) to __packed
Date: Wed, 15 Dec 2010 16:57:59 -0800
Message-Id: <1292461079-26318-4-git-send-email-bzhao@marvell.com>
In-Reply-To: <1292461079-26318-1-git-send-email-bzhao@marvell.com>
References: <1292461079-26318-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kiran Divekar <dkiran@marvell.com>

Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h |    8 +-
 drivers/net/wireless/mwifiex/fw.h   |  180 +++++++++++++++++-----------------
 drivers/net/wireless/mwifiex/ieee.h |   50 +++++-----
 3 files changed, 119 insertions(+), 119 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 155c071..95d9642 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -224,21 +224,21 @@ enum mwifiex_cmd_result_e {
 	MWIFIEX_CMD_RESULT_FAILURE = 1,
 	MWIFIEX_CMD_RESULT_TIMEOUT = 2,
 	MWIFIEX_CMD_RESULT_INVALID_DATA = 3
-} __attribute__ ((packed));
+} __packed;
 
 enum mwifiex_wmm_ac_e {
 	WMM_AC_BK,
 	WMM_AC_BE,
 	WMM_AC_VI,
 	WMM_AC_VO
-} __attribute__ ((packed));
+} __packed;
 
 enum mwifiex_wmm_queue_config_action_e {
 	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_GET = 0,
 	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_SET = 1,
 	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_DEFAULT = 2,
 	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_MAX
-} __attribute__ ((packed));
+} __packed;
 
 enum mwifiex_wmm_queue_stats_action_e {
 	MWIFIEX_WMM_STATS_ACTION_START = 0,
@@ -247,7 +247,7 @@ enum mwifiex_wmm_queue_stats_action_e {
 	MWIFIEX_WMM_STATS_ACTION_SET_CFG = 3,	/* Not currently used */
 	MWIFIEX_WMM_STATS_ACTION_GET_CFG = 4,	/* Not currently used */
 	MWIFIEX_WMM_STATS_ACTION_MAX
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_device {
 	struct mwifiex_bss_attr bss_attr[MWIFIEX_MAX_BSS_NUM];
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 16cdb85..834122c 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -481,12 +481,12 @@ struct mwifiex_802_11_fixed_ies {
 struct mwifiex_ie_types_header {
 	__le16 type;
 	__le16 len;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_data {
 	struct mwifiex_ie_types_header header;
 	u8 data[1];
-} __attribute__ ((packed));
+} __packed;
 
 #define MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET 0x01
 #define MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET 0x08
@@ -502,7 +502,7 @@ struct txpd {
 	u8 flags;
 	u8 pkt_delay_2ms;
 	u8 reserved1;
-} __attribute__ ((packed));
+} __packed;
 
 struct rxpd {
 	u8 bss_type;
@@ -520,7 +520,7 @@ struct rxpd {
 	 * [Bit 2]  HT Guard Interval: LGI = 0, SGI = 1 */
 	u8 ht_info;
 	u8 reserved;
-} __attribute__ ((packed));
+} __packed;
 
 enum mwifiex_chan_scan_mode_bitmasks {
 	MWIFIEX_PASSIVE_SCAN = BIT(0),
@@ -535,12 +535,12 @@ struct mwifiex_chan_scan_param_set {
 	u8 chan_scan_mode_bitmap;
 	__le16 min_scan_time;
 	__le16 max_scan_time;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_chan_list_param_set {
 	struct mwifiex_ie_types_header header;
 	struct mwifiex_chan_scan_param_set chan_scan_param[1];
-} __attribute__ ((packed));
+} __packed;
 
 struct chan_band_param_set {
 	u8 radio_type;
@@ -550,45 +550,45 @@ struct chan_band_param_set {
 struct mwifiex_ie_types_chan_band_list_param_set {
 	struct mwifiex_ie_types_header header;
 	struct chan_band_param_set chan_band_param[1];
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_rates_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 rates[1];
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_ssid_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 ssid[1];
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_num_probes {
 	struct mwifiex_ie_types_header header;
 	__le16 num_probes;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_wildcard_ssid_params {
 	struct mwifiex_ie_types_header header;
 	u8 max_ssid_length;
 	u8 ssid[1];
-} __attribute__ ((packed));
+} __packed;
 
 #define TSF_DATA_SIZE            8
 struct mwifiex_ie_types_tsf_timestamp {
 	struct mwifiex_ie_types_header header;
 	u8 tsf_data[1];
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_cf_param_set {
 	u8 cfp_cnt;
 	u8 cfp_period;
 	u16 cfp_max_duration;
 	u16 cfp_duration_remaining;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ibss_param_set {
 	u16 atim_window;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_ss_param_set {
 	struct mwifiex_ie_types_header header;
@@ -596,18 +596,18 @@ struct mwifiex_ie_types_ss_param_set {
 		struct mwifiex_cf_param_set cf_param_set[1];
 		struct mwifiex_ibss_param_set ibss_param_set[1];
 	} cf_ibss;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_fh_param_set {
 	u16 dwell_time;
 	u8 hop_set;
 	u8 hop_pattern;
 	u8 hop_index;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ds_param_set {
 	u8 current_chan;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_phy_param_set {
 	struct mwifiex_ie_types_header header;
@@ -615,12 +615,12 @@ struct mwifiex_ie_types_phy_param_set {
 		struct mwifiex_fh_param_set fh_param_set[1];
 		struct mwifiex_ds_param_set ds_param_set[1];
 	} fh_ds;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_auth_type {
 	struct mwifiex_ie_types_header header;
 	__le16 auth_type;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_vendor_param_set {
 	struct mwifiex_ie_types_header header;
@@ -630,7 +630,7 @@ struct mwifiex_ie_types_vendor_param_set {
 struct mwifiex_ie_types_rsn_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 rsn_ie[1];
-} __attribute__ ((packed));
+} __packed;
 
 #define KEYPARAMSET_FIXED_LEN 6
 
@@ -641,12 +641,12 @@ struct mwifiex_ie_type_key_param_set {
 	__le16 key_info;
 	__le16 key_len;
 	u8 key[50];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_key_material {
 	__le16 action;
 	struct mwifiex_ie_type_key_param_set key_param_set;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_gen {
 	u16 command;
@@ -660,7 +660,7 @@ struct host_cmd_ds_gen {
 struct host_cmd_ds_802_11_sleep_period {
 	__le16 action;
 	__le16 sleep_pd;
-} __attribute__ ((packed));
+} __packed;
 
 enum sleep_resp_ctrl {
 	RESP_NOT_NEEDED = 0,
@@ -705,12 +705,12 @@ struct auto_ps_param {
 struct mwifiex_ie_types_auto_ds_param {
 	struct mwifiex_ie_types_header header;
 	struct mwifiex_auto_ds_param param;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_ps_param {
 	struct mwifiex_ie_types_header header;
 	struct mwifiex_ps_param param;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_ps_mode_enh {
 	__le16 action;
@@ -722,7 +722,7 @@ struct host_cmd_ds_802_11_ps_mode_enh {
 		__le16 ps_bitmap;
 		struct auto_ps_param auto_ps;
 	} params;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_get_hw_spec {
 	__le16 hw_if_version;
@@ -741,7 +741,7 @@ struct host_cmd_ds_get_hw_spec {
 	u8 dev_mcs_support;
 	__le16 mp_end_port;	/* SDIO only, reserved for other interfacces */
 	__le16 reserved_4;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_rssi_info {
 	__le16 action;
@@ -781,12 +781,12 @@ struct host_cmd_ds_mac_multicast_adr {
 	__le16 num_of_adrs;
 	u8 mac_list[MWIFIEX_MAC_ADDR_LENGTH *
 		      MWIFIEX_MAX_MULTICAST_LIST_SIZE];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_deauthenticate {
 	u8 mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
 	__le16 reason_code;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_associate {
 	u8 peer_sta_addr[MWIFIEX_MAC_ADDR_LENGTH];
@@ -794,11 +794,11 @@ struct host_cmd_ds_802_11_associate {
 	__le16 listen_interval;
 	__le16 beacon_period;
 	u8 dtim_period;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_associate_rsp {
 	struct ieee_types_assoc_rsp assoc_rsp;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_ad_hoc_start {
 	u8 ssid[IW_ESSID_MAX_SIZE];
@@ -810,12 +810,12 @@ struct host_cmd_ds_802_11_ad_hoc_start {
 	u16 reserved1;
 	__le16 cap_info_bitmap;
 	u8 DataRate[HOSTCMD_SUPPORTED_RATES];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_ad_hoc_result {
 	u8 pad[3];
 	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
-} __attribute__ ((packed));
+} __packed;
 
 struct adhoc_bss_desc {
 	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
@@ -835,13 +835,13 @@ struct adhoc_bss_desc {
 	 *  It is used in the Adhoc join command and will cause a
 	 *  binary layout mismatch with the firmware
 	 */
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_ad_hoc_join {
 	struct adhoc_bss_desc bss_descriptor;
 	u16 reserved1;
 	u16 reserved2;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_get_log {
 	__le32 mcast_tx_frame;
@@ -866,7 +866,7 @@ struct host_cmd_ds_tx_rate_query {
 	 * [Bit 1]  HT Bandwidth: BW20 = 0, BW40 = 1
 	 * [Bit 2]  HT Guard Interval: LGI = 0, SGI = 1 */
 	u8 ht_info;
-} __attribute__ ((packed));
+} __packed;
 
 enum Host_Sleep_Action {
 	HS_CONFIGURE = 0x0001,
@@ -877,11 +877,11 @@ struct mwifiex_hs_config_param {
 	__le32 conditions;
 	u8 gpio;
 	u8 gap;
-} __attribute__ ((packed));
+} __packed;
 
 struct hs_activate_param {
 	u16 resp_ctrl;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_hs_cfg_enh {
 	__le16 action;
@@ -890,7 +890,7 @@ struct host_cmd_ds_802_11_hs_cfg_enh {
 		struct mwifiex_hs_config_param hs_config;
 		struct hs_activate_param hs_activate;
 	} params;
-} __attribute__ ((packed));
+} __packed;
 
 enum SNMP_MIB_INDEX {
 	OP_RATE_SET_I = 1,
@@ -909,7 +909,7 @@ struct host_cmd_ds_802_11_snmp_mib {
 	__le16 oid;
 	__le16 buf_size;
 	u8 value[1];
-} __attribute__ ((packed));
+} __packed;
 
 #define RADIO_ON                                0x01
 #define RADIO_OFF                               0x00
@@ -920,18 +920,18 @@ struct mwifiex_rate_scope {
 	__le16 hr_dsss_rate_bitmap;
 	__le16 ofdm_rate_bitmap;
 	__le16 ht_mcs_rate_bitmap[8];
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_rate_drop_pattern {
 	__le16 type;
 	__le16 length;
 	__le32 rate_drop_mode;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_tx_rate_cfg {
 	__le16 action;
 	__le16 cfg_index;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_power_group {
 	u8 modulation_class;
@@ -942,18 +942,18 @@ struct mwifiex_power_group {
 	s8 power_max;
 	u8 ht_bandwidth;
 	u8 reserved;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_types_power_group {
 	u16 type;
 	u16 length;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_txpwr_cfg {
 	__le16 action;
 	__le16 cfg_index;
 	__le32 mode;
-} __attribute__ ((packed));
+} __packed;
 
 #define MWIFIEX_USER_SCAN_CHAN_MAX             50
 
@@ -990,7 +990,7 @@ struct mwifiex_scan_cmd_config {
 	 */
 	u8 tlv_buf[1];	/* SSID TLV(s) and ChanList TLVs are stored
 				   here */
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_user_scan_chan {
 	u8 chan_number;
@@ -998,12 +998,12 @@ struct mwifiex_user_scan_chan {
 	u8 scan_type;
 	u8 reserved;
 	u32 scan_time;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_user_scan_ssid {
 	u8 ssid[IW_ESSID_MAX_SIZE + 1];
 	u8 max_len;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_user_scan_cfg {
 	/**
@@ -1044,50 +1044,50 @@ struct mwifiex_user_scan_cfg {
 	 *  Variable number (fixed maximum) of channels to scan up
 	 */
 	struct mwifiex_user_scan_chan chan_list[MWIFIEX_USER_SCAN_CHAN_MAX];
-} __attribute__ ((packed));
+} __packed;
 
 struct ie_body {
 	u8 grp_key_oui[4];
 	u8 ptk_cnt[2];
 	u8 ptk_body[4];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_scan {
 	u8 bss_mode;
 	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
 	u8 tlv_buffer[1];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_scan_rsp {
 	__le16 bss_descript_size;
 	u8 number_of_sets;
 	u8 bss_desc_and_tlv_buffer[1];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_bg_scan_query {
 	u8 flush;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_bg_scan_query_rsp {
 	u32 report_condition;
 	struct host_cmd_ds_802_11_scan_rsp scan_resp;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ietypes_domain_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 country_code[COUNTRY_CODE_LEN];
 	struct ieee80211_country_ie_triplet triplet[1];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11d_domain_info {
 	__le16 action;
 	struct mwifiex_ietypes_domain_param_set domain;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11d_domain_info_rsp {
 	__le16 action;
 	struct mwifiex_ietypes_domain_param_set domain;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_11n_addba_req {
 	u8 add_req_result;
@@ -1096,7 +1096,7 @@ struct host_cmd_ds_11n_addba_req {
 	__le16 block_ack_param_set;
 	__le16 block_ack_tmo;
 	__le16 ssn;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_11n_addba_rsp {
 	u8 add_rsp_result;
@@ -1106,7 +1106,7 @@ struct host_cmd_ds_11n_addba_rsp {
 	__le16 block_ack_param_set;
 	__le16 block_ack_tmo;
 	__le16 ssn;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_11n_delba {
 	u8 del_result;
@@ -1114,32 +1114,32 @@ struct host_cmd_ds_11n_delba {
 	__le16 del_ba_param_set;
 	__le16 reason_code;
 	u8 reserved;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_11n_batimeout {
 	u8 tid;
 	u8 peer_mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
 	u8 origninator;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_11n_cfg {
 	__le16 action;
 	__le16 ht_tx_cap;
 	__le16 ht_tx_info;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_txbuf_cfg {
 	__le16 action;
 	__le16 buff_size;
 	__le16 mp_end_port;	/* SDIO only, reserved for other interfacces */
 	__le16 reserved3;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_amsdu_aggr_ctrl {
 	__le16 action;
 	__le16 enable;
 	__le16 curr_buf_size;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_wmm_param_set {
 	struct mwifiex_ie_types_header header;
@@ -1160,7 +1160,7 @@ struct host_cmd_ds_wmm_get_status {
 	u8 queue_status_tlv[sizeof(struct mwifiex_ie_types_wmm_queue_status) *
 			      IEEE80211_MAX_QUEUES];
 	u8 wmm_param_tlv[sizeof(struct ieee_types_wmm_parameter) + 2];
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_wmm_ac_status {
 	u8 disabled;
@@ -1171,32 +1171,32 @@ struct mwifiex_wmm_ac_status {
 struct mwifiex_ie_types_htcap {
 	struct mwifiex_ie_types_header header;
 	struct ieee_htcap ht_cap;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_htinfo {
 	struct mwifiex_ie_types_header header;
 	struct ieee_htinfo ht_info;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_2040bssco {
 	struct mwifiex_ie_types_header header;
 	struct ieee_bssco_2040 bss_co_2040;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_extcap {
 	struct mwifiex_ie_types_header header;
 	struct ieee_extcap ext_cap;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_pmk {
 	struct mwifiex_ie_types_header header;
 	u8 pmk[1];
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_passphrase {
 	struct mwifiex_ie_types_header header;
 	char passphrase[1];
-} __attribute__ ((packed));
+} __packed;
 
 /* unicastcipher:
  *      Bit 0   : RFU
@@ -1215,7 +1215,7 @@ struct mwifiex_ie_types_cipher {
 	struct mwifiex_ie_types_header header;
 	u8 pair_cipher;
 	u8 group_cipher;
-} __attribute__ ((packed));
+} __packed;
 
 /* rsnMode:
  *      Bit 0    : No RSN
@@ -1229,12 +1229,12 @@ struct mwifiex_ie_types_cipher {
 struct mwifiex_ie_types_encrproto {
 	struct mwifiex_ie_types_header header;
 	__le16 rsn_mode;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_ie_types_bssid {
 	struct mwifiex_ie_types_header header;
 	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
-} __attribute__ ((packed));
+} __packed;
 
 /*
  * This struct will handle GET,SET,CLEAR function for embedded
@@ -1250,7 +1250,7 @@ struct host_cmd_ds_802_11_supplicant_pmk {
 	 * mwifiex_ie_types_passphrase		passphrase;
 	 * mwifiex_ie_types_bssid		bssid;
 	 */
-} __attribute__ ((packed));
+} __packed;
 
 /*
  * This struct will GET the Supplicant supported bitmaps
@@ -1263,34 +1263,34 @@ struct host_cmd_ds_802_11_supplicant_profile {
 	__le16 reserved;
 	u8 tlv_buf[1];
 	/* mwifiex_ie_types_encrproto */
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_mac_reg_access {
 	__le16 action;
 	__le16 offset;
 	__le32 value;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_bbp_reg_access {
 	__le16 action;
 	__le16 offset;
 	u8 value;
 	u8 reserved[3];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_rf_reg_access {
 	__le16 action;
 	__le16 offset;
 	u8 value;
 	u8 reserved[3];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_pmic_reg_access {
 	__le16 action;
 	__le16 offset;
 	u8 value;
 	u8 reserved[3];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_eeprom_access {
 	__le16 action;
@@ -1298,7 +1298,7 @@ struct host_cmd_ds_802_11_eeprom_access {
 	__le16 offset;
 	__le16 byte_count;
 	u8 value;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_rf_channel {
 	__le16 action;
@@ -1306,17 +1306,17 @@ struct host_cmd_ds_802_11_rf_channel {
 	__le16 rf_type;
 	__le16 reserved;
 	u8 reserved_1[32];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_version_ext {
 	u8 version_str_sel;
 	char version_str[128];
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_rf_antenna {
 	__le16 action;
 	__le16 antenna_mode;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_802_11_ibss_status {
 	__le16 action;
@@ -1325,14 +1325,14 @@ struct host_cmd_ds_802_11_ibss_status {
 	__le16 beacon_interval;
 	__le16 atim_window;
 	__le16 use_g_rate_protect;
-} __attribute__ ((packed));
+} __packed;
 
 #define CONNECTION_TYPE_INFRA   0
 #define CONNECTION_TYPE_ADHOC   1
 
 struct host_cmd_ds_set_bss_mode {
 	u8 con_type;
-} __attribute__ ((packed));
+} __packed;
 
 struct host_cmd_ds_command {
 	__le16 command;
@@ -1387,7 +1387,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_802_11_eeprom_access eeprom;
 		struct host_cmd_ds_802_11_sleep_period sleep_pd;
 	} params;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_opt_sleep_confirm {
 	__le16 command;
@@ -1396,10 +1396,10 @@ struct mwifiex_opt_sleep_confirm {
 	__le16 result;
 	__le16 action;
 	struct sleep_confirm_param sleep_cfm;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_opt_sleep_confirm_buffer {
 	u8 hdr[4];
 	struct mwifiex_opt_sleep_confirm ps_cfm_sleep;
-} __attribute__ ((packed));
+} __packed;
 #endif /* !_MWIFIEX_FW_H_ */
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index ae85c8a..263380c 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -29,7 +29,7 @@
 struct ieee_types_header {
 	u8 element_id;
 	u8 len;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_vendor_header {
 	u8 element_id;
@@ -38,17 +38,17 @@ struct ieee_types_vendor_header {
 	u8 oui_type;
 	u8 oui_subtype;
 	u8 version;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_vendor_specific {
 	struct ieee_types_vendor_header vend_hdr;
 	u8 data[IEEE_MAX_IE_SIZE - sizeof(struct ieee_types_vendor_header)];
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_generic {
 	struct ieee_types_header ieee_hdr;
 	u8 data[IEEE_MAX_IE_SIZE - sizeof(struct ieee_types_header)];
-} __attribute__ ((packed));
+} __packed;
 
 #define CAPINFO_MASK    (~(BIT(15) | BIT(14) |            \
 				BIT(12) | BIT(11) | BIT(9)))
@@ -60,18 +60,18 @@ struct ieee_types_cf_param_set {
 	u8 cfp_period;
 	u16 cfp_max_duration;
 	u16 cfp_duration_remaining;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_ibss_param_set {
 	u8 element_id;
 	u8 len;
 	__le16 atim_window;
-} __attribute__ ((packed));
+} __packed;
 
 union ieee_types_ss_param_set {
 	struct ieee_types_cf_param_set cf_param_set;
 	struct ieee_types_ibss_param_set ibss_param_set;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_fh_param_set {
 	u8 element_id;
@@ -80,31 +80,31 @@ struct ieee_types_fh_param_set {
 	u8 hop_set;
 	u8 hop_pattern;
 	u8 hop_index;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_ds_param_set {
 	u8 element_id;
 	u8 len;
 	u8 current_chan;
-} __attribute__ ((packed));
+} __packed;
 
 union ieee_types_phy_param_set {
 	struct ieee_types_fh_param_set fh_param_set;
 	struct ieee_types_ds_param_set ds_param_set;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_erp_info {
 	u8 element_id;
 	u8 len;
 	u8 erp_flags;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_assoc_rsp {
 	__le16 cap_info_bitmap;
 	__le16 status_code;
 	__le16 a_id;
 	u8 ie_buffer[1];
-} __attribute__ ((packed));
+} __packed;
 
 enum ieee_types_wmm_aciaifsn_bitmasks {
 	MWIFIEX_AIFSN = (BIT(0) | BIT(1) | BIT(2) | BIT(3)),
@@ -121,7 +121,7 @@ struct ieee_types_wmm_ac_parameters {
 	u8 aci_aifsn_bitmap;
 	u8 ecw_bitmap;
 	__le16 tx_op_limit;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_wmm_info {
 
@@ -137,7 +137,7 @@ struct ieee_types_wmm_info {
 	struct ieee_types_vendor_header vend_hdr;
 
 	u8 qos_info_bitmap;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_wmm_parameter {
 	/**
@@ -153,7 +153,7 @@ struct ieee_types_wmm_parameter {
 	u8 qos_info_bitmap;
 	u8 reserved;
 	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_MAX_QUEUES];
-} __attribute__ ((packed));
+} __packed;
 
 #define MWIFIEX_MAX_TRIPLET_802_11D		83
 #define COUNTRY_CODE_LEN			3
@@ -165,7 +165,7 @@ struct ieee_htcap {
 	__le16 ht_ext_cap;
 	u32 tx_bf_cap;
 	u8 asel;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_htinfo {
 	u8 pri_chan;
@@ -173,15 +173,15 @@ struct ieee_htinfo {
 	u16 field3;
 	u16 field4;
 	u8 basic_mcs_set[16];
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_bssco_2040 {
 	u8 bss_co_2040_value;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_extcap {
 	u8 ext_cap_value;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_obss_scan_param {
 	u16 obss_scan_passive_dwell;
@@ -191,32 +191,32 @@ struct ieee_obss_scan_param {
 	u16 obss_scan_active_total;
 	u16 bss_width_chan_trans_delay;
 	u16 obss_scan_active_threshold;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_htcap {
 	struct ieee_types_header ieee_hdr;
 	struct ieee_htcap ht_cap;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_htinfo {
 	struct ieee_types_header ieee_hdr;
 	struct ieee_htinfo ht_info;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_2040bssco {
 	struct ieee_types_header ieee_hdr;
 	struct ieee_bssco_2040 bss_co_2040;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_extcap {
 	struct ieee_types_header ieee_hdr;
 	struct ieee_extcap ext_cap;
-} __attribute__ ((packed));
+} __packed;
 
 struct ieee_types_obss_scan_param {
 	struct ieee_types_header ieee_hdr;
 	struct ieee_obss_scan_param obss_scan;
-} __attribute__ ((packed));
+} __packed;
 
 struct mwifiex_bssdescriptor {
 	u8 mac_address[MWIFIEX_MAC_ADDR_LENGTH];
-- 
1.7.0.2

