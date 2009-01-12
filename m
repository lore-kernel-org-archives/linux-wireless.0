Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:29397 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbZALVOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 16:14:31 -0500
Received: by yw-out-2324.google.com with SMTP id 9so3511745ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 13:14:29 -0800 (PST)
Message-ID: <496bb2b3.14098e0a.5beb.4b09@mx.google.com> (sfid-20090112_221446_426244_113275DB)
Date: Mon, 12 Jan 2009 13:14:27 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Andrey Yurovsky <andrey@cozybit.com>
Cc: dcbw@redhat.com, libertas-dev@lists.infradead.org
Subject: [PATCH v2] libertas: Fix alignment issues in libertas core
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Data structures that come over the wire from the WLAN firmware must be packed.
This fixes alignment problems on the blackfin architecture and, reportedly, on
the AVR32.

This is a replacement for the previous version of this patch which had also
explicitly used get_unaligned_ macros.  As Johannes Berg pointed out, these 
macros were unnecessary.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Signed-off-by: Colin McCabe <colin@cozybit.com>
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 2d8533c..a899aeb 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -32,7 +32,7 @@ struct txpd {
 	u8 pktdelay_2ms;
 	/* reserved */
 	u8 reserved1;
-};
+} __attribute__ ((packed));
 
 /* RxPD Descriptor */
 struct rxpd {
@@ -63,7 +63,7 @@ struct rxpd {
 	/* Pkt Priority */
 	u8 priority;
 	u8 reserved[3];
-};
+} __attribute__ ((packed));
 
 struct cmd_header {
 	__le16 command;
@@ -97,7 +97,7 @@ struct enc_key {
 struct lbs_offset_value {
 	u32 offset;
 	u32 value;
-};
+} __attribute__ ((packed));
 
 /* Define general data structure */
 /* cmd_DS_GEN */
@@ -107,7 +107,7 @@ struct cmd_ds_gen {
 	__le16 seqnum;
 	__le16 result;
 	void *cmdresp[0];
-};
+} __attribute__ ((packed));
 
 #define S_DS_GEN sizeof(struct cmd_ds_gen)
 
@@ -163,7 +163,7 @@ struct cmd_ds_802_11_subscribe_event {
 	 * bump this up a bit.
 	 */
 	uint8_t tlv[128];
-};
+} __attribute__ ((packed));
 
 /*
  * This scan handle Country Information IE(802.11d compliant)
@@ -180,7 +180,7 @@ struct cmd_ds_802_11_scan {
 	mrvlietypes_chanlistparamset_t ChanListParamSet;
 	mrvlietypes_ratesparamset_t OpRateSet;
 #endif
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_scan_rsp {
 	struct cmd_header hdr;
@@ -188,7 +188,7 @@ struct cmd_ds_802_11_scan_rsp {
 	__le16 bssdescriptsize;
 	uint8_t nr_sets;
 	uint8_t bssdesc_and_tlvbuffer[0];
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_get_log {
 	struct cmd_header hdr;
@@ -206,20 +206,20 @@ struct cmd_ds_802_11_get_log {
 	__le32 fcserror;
 	__le32 txframe;
 	__le32 wepundecryptable;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_mac_control {
 	struct cmd_header hdr;
 	__le16 action;
 	u16 reserved;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_mac_multicast_adr {
 	struct cmd_header hdr;
 	__le16 action;
 	__le16 nr_of_adrs;
 	u8 maclist[ETH_ALEN * MRVDRV_MAX_MULTICAST_LIST_SIZE];
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_gspi_bus_config {
 	struct cmd_header hdr;
@@ -233,14 +233,14 @@ struct cmd_ds_802_11_authenticate {
 	u8 macaddr[ETH_ALEN];
 	u8 authtype;
 	u8 reserved[10];
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_deauthenticate {
 	struct cmd_header hdr;
 
 	u8 macaddr[ETH_ALEN];
 	__le16 reasoncode;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_associate {
 	u8 peerstaaddr[6];
@@ -259,7 +259,7 @@ struct cmd_ds_802_11_associate {
 
 struct cmd_ds_802_11_associate_rsp {
 	struct ieeetypes_assocrsp assocRsp;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_set_wep {
 	struct cmd_header hdr;
@@ -273,7 +273,7 @@ struct cmd_ds_802_11_set_wep {
 	/* 40, 128bit or TXWEP */
 	uint8_t keytype[4];
 	uint8_t keymaterial[4][16];
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_3_get_stat {
 	__le32 xmitok;
@@ -282,7 +282,7 @@ struct cmd_ds_802_3_get_stat {
 	__le32 rcverror;
 	__le32 rcvnobuffer;
 	__le32 rcvcrcerror;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_get_stat {
 	__le32 txfragmentcnt;
@@ -302,7 +302,7 @@ struct cmd_ds_802_11_get_stat {
 	__le32 txbeacon;
 	__le32 rxbeacon;
 	__le32 wepundecryptable;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_snmp_mib {
 	struct cmd_header hdr;
@@ -311,58 +311,58 @@ struct cmd_ds_802_11_snmp_mib {
 	__le16 oid;
 	__le16 bufsize;
 	u8 value[128];
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_mac_reg_map {
 	__le16 buffersize;
 	u8 regmap[128];
 	__le16 reserved;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_bbp_reg_map {
 	__le16 buffersize;
 	u8 regmap[128];
 	__le16 reserved;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_rf_reg_map {
 	__le16 buffersize;
 	u8 regmap[64];
 	__le16 reserved;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_mac_reg_access {
 	__le16 action;
 	__le16 offset;
 	__le32 value;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_bbp_reg_access {
 	__le16 action;
 	__le16 offset;
 	u8 value;
 	u8 reserved[3];
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_rf_reg_access {
 	__le16 action;
 	__le16 offset;
 	u8 value;
 	u8 reserved[3];
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_radio_control {
 	struct cmd_header hdr;
 
 	__le16 action;
 	__le16 control;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_beacon_control {
 	__le16 action;
 	__le16 beacon_enable;
 	__le16 beacon_period;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_sleep_params {
 	struct cmd_header hdr;
@@ -387,7 +387,7 @@ struct cmd_ds_802_11_sleep_params {
 
 	/* reserved field, should be set to zero */
 	__le16 reserved;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_inactivity_timeout {
 	struct cmd_header hdr;
@@ -397,7 +397,7 @@ struct cmd_ds_802_11_inactivity_timeout {
 
 	/* Inactivity timeout in msec */
 	__le16 timeout;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_rf_channel {
 	struct cmd_header hdr;
@@ -407,7 +407,7 @@ struct cmd_ds_802_11_rf_channel {
 	__le16 rftype;      /* unused */
 	__le16 reserved;    /* unused */
 	u8 channellist[32]; /* unused */
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_rssi {
 	/* weighting factor */
@@ -416,21 +416,21 @@ struct cmd_ds_802_11_rssi {
 	__le16 reserved_0;
 	__le16 reserved_1;
 	__le16 reserved_2;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_rssi_rsp {
 	__le16 SNR;
 	__le16 noisefloor;
 	__le16 avgSNR;
 	__le16 avgnoisefloor;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_mac_address {
 	struct cmd_header hdr;
 
 	__le16 action;
 	u8 macadd[ETH_ALEN];
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_rf_tx_power {
 	struct cmd_header hdr;
@@ -439,7 +439,7 @@ struct cmd_ds_802_11_rf_tx_power {
 	__le16 curlevel;
 	s8 maxlevel;
 	s8 minlevel;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_rf_antenna {
 	__le16 action;
@@ -447,33 +447,33 @@ struct cmd_ds_802_11_rf_antenna {
 	/* Number of antennas or 0xffff(diversity) */
 	__le16 antennamode;
 
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_monitor_mode {
 	__le16 action;
 	__le16 mode;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_set_boot2_ver {
 	struct cmd_header hdr;
 
 	__le16 action;
 	__le16 version;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_fw_wake_method {
 	struct cmd_header hdr;
 
 	__le16 action;
 	__le16 method;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_sleep_period {
 	struct cmd_header hdr;
 
 	__le16 action;
 	__le16 period;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_ps_mode {
 	__le16 action;
@@ -481,7 +481,7 @@ struct cmd_ds_802_11_ps_mode {
 	__le16 multipledtim;
 	__le16 reserved;
 	__le16 locallisteninterval;
-};
+} __attribute__ ((packed));
 
 struct cmd_confirm_sleep {
 	struct cmd_header hdr;
@@ -491,7 +491,7 @@ struct cmd_confirm_sleep {
 	__le16 multipledtim;
 	__le16 reserved;
 	__le16 locallisteninterval;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_data_rate {
 	struct cmd_header hdr;
@@ -499,14 +499,14 @@ struct cmd_ds_802_11_data_rate {
 	__le16 action;
 	__le16 reserved;
 	u8 rates[MAX_RATES];
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_rate_adapt_rateset {
 	struct cmd_header hdr;
 	__le16 action;
 	__le16 enablehwauto;
 	__le16 bitmap;
-};
+} __attribute__ ((packed));
 
 struct cmd_ds_802_11_ad_hoc_start {
 	struct cmd_header hdr;
@@ -528,7 +528,7 @@ struct cmd_ds_802_11_ad_hoc_result {
 
 	u8 pad[3];
 	u8 bssid[ETH_ALEN];
-};
+} __attribute__ ((packed));
 
 struct adhoc_bssdesc {
 	u8 bssid[ETH_ALEN];
@@ -586,7 +586,7 @@ struct MrvlIEtype_keyParamSet {
 
 	/* key material of size keylen */
 	u8 key[32];
-};
+} __attribute__ ((packed));
 
 #define MAX_WOL_RULES 		16
 
@@ -598,7 +598,7 @@ struct host_wol_rule {
 	__le16 reserve;
 	__be32 sig_mask;
 	__be32 signature;
-};
+} __attribute__ ((packed));
 
 struct wol_config {
 	uint8_t action;
@@ -606,8 +606,7 @@ struct wol_config {
 	uint8_t no_rules_in_cmd;
 	uint8_t result;
 	struct host_wol_rule rule[MAX_WOL_RULES];
-};
-
+} __attribute__ ((packed));
 
 struct cmd_ds_host_sleep {
 	struct cmd_header hdr;


