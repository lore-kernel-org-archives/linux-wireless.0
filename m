Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46836 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0LJCYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 21:24:44 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: remove bitfields and __BIG_ENDIAN_BITFIELD
Date: Thu,  9 Dec 2010 18:24:42 -0800
Message-Id: <1291947882-9124-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1291947882-9124-1-git-send-email-bzhao@marvell.com>
References: <1291947882-9124-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

and some struct ieee_types_ definitions in ieee.h

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    8 +--
 drivers/net/wireless/mwifiex/fw.h       |   23 +++-----
 drivers/net/wireless/mwifiex/ieee.h     |   93 +++++-------------------------
 drivers/net/wireless/mwifiex/join.c     |   39 +++++--------
 drivers/net/wireless/mwifiex/scan.c     |   34 ++++++------
 drivers/net/wireless/mwifiex/wmm.c      |   41 +++++++++-----
 6 files changed, 86 insertions(+), 152 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 7861cb7..99dade5 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1251,7 +1251,6 @@ mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 	u8 *ie, *tmp, *ie_buf;
 	u32 ie_len;
 	u64 ts = 0;
-	u8 *cap;
 	u8 *beacon;
 	int beacon_size;
 	u8 element_id;
@@ -1313,11 +1312,11 @@ mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 		if (beacon) {
 			beacon += sizeof(scan_table[i].beacon_period)
 				+ sizeof(scan_table[i].time_stamp) +
-				+sizeof(scan_table[i].cap_info);
+				+sizeof(scan_table[i].cap_info_bitmap);
 
 			beacon_size -= sizeof(scan_table[i].beacon_period)
 				+ sizeof(scan_table[i].time_stamp)
-				+ sizeof(scan_table[i].cap_info);
+				+ sizeof(scan_table[i].cap_info_bitmap);
 		}
 
 		while (beacon_size >= sizeof(struct ieee_types_header)) {
@@ -1359,10 +1358,9 @@ mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 		}
 		chan = ieee80211_get_channel(priv->wdev->wiphy,
 				scan_table[i].freq);
-		cap = (u8 *) &scan_table[i].cap_info;
 		cfg80211_inform_bss(priv->wdev->wiphy, chan,
 				scan_table[i].mac_address,
-				    ts, (u16) (*cap),
+				    ts, scan_table[i].cap_info_bitmap,
 				    scan_table[i].beacon_period, ie_buf, ie_len,
 				    scan_table[i].rssi, GFP_KERNEL);
 	}
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index d8f4011..16cdb85 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -522,24 +522,17 @@ struct rxpd {
 	u8 reserved;
 } __attribute__ ((packed));
 
-struct mwifiex_chan_scan_mode {
-#ifdef __BIG_ENDIAN__BITFIELD
-	u8 reserved_2_7:6;
-	u8 disable_chan_filt:1;
-	u8 passive_scan:1;
-#else
-	u8 passive_scan:1;
-	u8 disable_chan_filt:1;
-	u8 reserved_2_7:6;
-#endif
-} __attribute__ ((packed));
+enum mwifiex_chan_scan_mode_bitmasks {
+	MWIFIEX_PASSIVE_SCAN = BIT(0),
+	MWIFIEX_DISABLE_CHAN_FILT = BIT(1),
+};
 
 #define SECOND_CHANNEL_BELOW    0x30
 #define SECOND_CHANNEL_ABOVE    0x10
 struct mwifiex_chan_scan_param_set {
 	u8 radio_type;
 	u8 chan_number;
-	struct mwifiex_chan_scan_mode chan_scan_mode;
+	u8 chan_scan_mode_bitmap;
 	__le16 min_scan_time;
 	__le16 max_scan_time;
 } __attribute__ ((packed));
@@ -797,7 +790,7 @@ struct host_cmd_ds_802_11_deauthenticate {
 
 struct host_cmd_ds_802_11_associate {
 	u8 peer_sta_addr[MWIFIEX_MAC_ADDR_LENGTH];
-	struct ieee_types_cap_info cap_info;
+	__le16 cap_info_bitmap;
 	__le16 listen_interval;
 	__le16 beacon_period;
 	u8 dtim_period;
@@ -815,7 +808,7 @@ struct host_cmd_ds_802_11_ad_hoc_start {
 	union ieee_types_ss_param_set ss_param_set;
 	union ieee_types_phy_param_set phy_param_set;
 	u16 reserved1;
-	struct ieee_types_cap_info cap;
+	__le16 cap_info_bitmap;
 	u8 DataRate[HOSTCMD_SUPPORTED_RATES];
 } __attribute__ ((packed));
 
@@ -834,7 +827,7 @@ struct adhoc_bss_desc {
 	u8 local_time[8];
 	union ieee_types_phy_param_set phy_param_set;
 	union ieee_types_ss_param_set ss_param_set;
-	struct ieee_types_cap_info cap;
+	__le16 cap_info_bitmap;
 	u8 data_rates[HOSTCMD_SUPPORTED_RATES];
 
 	/*
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index 3245f17..ae85c8a 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -53,41 +53,6 @@ struct ieee_types_generic {
 #define CAPINFO_MASK    (~(BIT(15) | BIT(14) |            \
 				BIT(12) | BIT(11) | BIT(9)))
 
-struct ieee_types_cap_info {
-#ifdef __BIG_ENDIAN_BITFIELD
-	u8 rsrvd1:2;
-	u8 dsss_ofdm:1;
-	u8 rsvrd2:2;
-	u8 short_slot_time:1;
-	u8 rsrvd3:1;
-	u8 spectrum_mgmt:1;
-	u8 chan_agility:1;
-	u8 pbcc:1;
-	u8 short_preamble:1;
-	u8 privacy:1;
-	u8 cf_poll_rqst:1;
-	u8 cf_pollable:1;
-	u8 ibss:1;
-	u8 ess:1;
-#else
-	u8 ess:1;
-	u8 ibss:1;
-	u8 cf_pollable:1;
-	u8 cf_poll_rqst:1;
-	u8 privacy:1;
-	u8 short_preamble:1;
-	u8 pbcc:1;
-	u8 chan_agility:1;
-	u8 spectrum_mgmt:1;
-	u8 rsrvd3:1;
-	u8 short_slot_time:1;
-	u8 Apsd:1;
-	u8 rsvrd2:1;
-	u8 dsss_ofdm:1;
-	u8 rsrvd1:2;
-#endif
-} __attribute__ ((packed));
-
 struct ieee_types_cf_param_set {
 	u8 element_id;
 	u8 len;
@@ -135,52 +100,27 @@ struct ieee_types_erp_info {
 } __attribute__ ((packed));
 
 struct ieee_types_assoc_rsp {
-	struct ieee_types_cap_info capability;
+	__le16 cap_info_bitmap;
 	__le16 status_code;
 	__le16 a_id;
 	u8 ie_buffer[1];
 } __attribute__ ((packed));
 
-struct ieee_types_wmm_qos_info {
-#ifdef __BIG_ENDIAN_BITFIELD
-	u8 qos_uapsd:1;
-	u8 reserved:3;
-	u8 para_set_count:4;
-#else
-	u8 para_set_count:4;
-	u8 reserved:3;
-	u8 qos_uapsd:1;
-#endif
-} __attribute__ ((packed));
-
-struct ieee_types_wmm_aciaifsn {
-#ifdef __BIG_ENDIAN_BITFIELD
-	u8 reserved:1;
-	u8 aci:2;
-	u8 acm:1;
-	u8 aifsn:4;
-#else
-	u8 aifsn:4;
-	u8 acm:1;
-	u8 aci:2;
-	u8 reserved:1;
-#endif
-} __attribute__ ((packed));
+enum ieee_types_wmm_aciaifsn_bitmasks {
+	MWIFIEX_AIFSN = (BIT(0) | BIT(1) | BIT(2) | BIT(3)),
+	MWIFIEX_ACM = BIT(4),
+	MWIFIEX_ACI = (BIT(5) | BIT(6)),
+};
 
-struct ieee_types_wmm_ecw {
-#ifdef __BIG_ENDIAN_BITFIELD
-	u8 ecw_max:4;
-	u8 ecw_min:4;
-#else
-	u8 ecw_min:4;
-	u8 ecw_max:4;
-#endif
-} __attribute__ ((packed));
+enum ieee_types_wmm_ecw_bitmasks {
+	MWIFIEX_ECW_MIN = (BIT(0) | BIT(1) | BIT(2) | BIT(3)),
+	MWIFIEX_ECW_MAX = (BIT(4) | BIT(5) | BIT(6) | BIT(7)),
+};
 
 struct ieee_types_wmm_ac_parameters {
-	struct ieee_types_wmm_aciaifsn aci_aifsn;   /**< AciAifSn */
-	struct ieee_types_wmm_ecw ecw;		    /**< Ecw */
-	__le16 tx_op_limit;		      /**< Tx op limit */
+	u8 aci_aifsn_bitmap;
+	u8 ecw_bitmap;
+	__le16 tx_op_limit;
 } __attribute__ ((packed));
 
 struct ieee_types_wmm_info {
@@ -196,8 +136,7 @@ struct ieee_types_wmm_info {
 	 */
 	struct ieee_types_vendor_header vend_hdr;
 
-	struct ieee_types_wmm_qos_info qos_info;
-
+	u8 qos_info_bitmap;
 } __attribute__ ((packed));
 
 struct ieee_types_wmm_parameter {
@@ -211,7 +150,7 @@ struct ieee_types_wmm_parameter {
 	 *   Version     [1]
 	 */
 	struct ieee_types_vendor_header vend_hdr;
-	struct ieee_types_wmm_qos_info qos_info;
+	u8 qos_info_bitmap;
 	u8 reserved;
 	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_MAX_QUEUES];
 } __attribute__ ((packed));
@@ -302,7 +241,7 @@ struct mwifiex_bssdescriptor {
 	u8 time_stamp[8];
 	union ieee_types_phy_param_set phy_param_set;
 	union ieee_types_ss_param_set ss_param_set;
-	struct ieee_types_cap_info cap_info;
+	u16 cap_info_bitmap;
 	struct ieee_types_wmm_parameter wmm_ie;
 	u8  disable_11n;
 	struct ieee_types_htcap *bcn_ht_cap;
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 2888f54..264cb01 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -381,7 +381,7 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	/* Set the beacon period */
 	assoc->beacon_period = cpu_to_le16(bss_desc->beacon_period);
 
-	pos += sizeof(assoc->cap_info);
+	pos += sizeof(assoc->cap_info_bitmap);
 	pos += sizeof(assoc->listen_interval);
 	pos += sizeof(assoc->beacon_period);
 	pos += sizeof(assoc->dtim_period);
@@ -605,7 +605,7 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	cmd->size = cpu_to_le16((u16) (pos - (u8 *) assoc) + S_DS_GEN);
 
 	/* Set the Capability info at last */
-	memcpy(&tmp_cap, &bss_desc->cap_info, sizeof(assoc->cap_info));
+	tmp_cap = bss_desc->cap_info_bitmap;
 
 	if (priv->adapter->config_bands == BAND_B)
 		SHORT_SLOT_TIME_DISABLED(tmp_cap);
@@ -613,7 +613,7 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	tmp_cap &= CAPINFO_MASK;
 	PRINTM(MINFO, "ASSOC_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
 	       tmp_cap, CAPINFO_MASK);
-	memcpy(&assoc->cap_info, &tmp_cap, sizeof(assoc->cap_info));
+	assoc->cap_info_bitmap = cpu_to_le16(tmp_cap);
 
 done:
 	LEAVE();
@@ -712,7 +712,7 @@ mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 		PRINTM(MERROR, "ASSOC_RESP: Association Failed, "
 		       "status code = %d, error = 0x%x, a_id = 0x%x\n",
 		       le16_to_cpu(assoc_rsp->status_code),
-		       le16_to_cpu(*(__le16 *) &assoc_rsp->capability),
+		       le16_to_cpu(assoc_rsp->cap_info_bitmap),
 		       le16_to_cpu(assoc_rsp->a_id));
 
 		ret = MWIFIEX_STATUS_FAILURE;
@@ -765,7 +765,8 @@ mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 	if (priv->wmm_enabled)
 		priv->curr_bss_params.wmm_uapsd_enabled
-			= bss_desc->wmm_ie.qos_info.qos_uapsd;
+			= ((bss_desc->wmm_ie.qos_info_bitmap &
+				IEEE80211_WMM_IE_AP_QOSINFO_UAPSD) ? 1 : 0);
 
 	PRINTM(MINFO, "ASSOC_RESP: curr_pkt_filter is 0x%x\n",
 	       priv->curr_pkt_filter);
@@ -989,19 +990,19 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	       sizeof(union ieee_types_ss_param_set));
 
 	/* Set Capability info */
-	adhoc_start->cap.ess = 0;
-	adhoc_start->cap.ibss = 1;
-	bss_desc->cap_info.ibss = 1;
+	bss_desc->cap_info_bitmap |= WLAN_CAPABILITY_IBSS;
+	tmp_cap = le16_to_cpu(adhoc_start->cap_info_bitmap);
+	tmp_cap &= ~WLAN_CAPABILITY_ESS;
+	tmp_cap |= WLAN_CAPABILITY_IBSS;
 
 	/* Set up privacy in bss_desc */
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED
 			|| priv->sec_info.wpa_enabled
 			|| priv->sec_info.ewpa_enabled) {
 		/** Ad-Hoc capability privacy on */
-#define AD_HOC_CAP_PRIVACY_ON   1
 		PRINTM(MINFO, "ADHOC_S_CMD: wep_status set, Privacy to WEP\n");
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
-		adhoc_start->cap.privacy = AD_HOC_CAP_PRIVACY_ON;
+		tmp_cap |= WLAN_CAPABILITY_PRIVACY;
 	} else {
 		PRINTM(MWARN, "ADHOC_S_CMD: wep_status NOT set, Setting "
 				"Privacy to ACCEPT ALL\n");
@@ -1178,14 +1179,12 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			    (sizeof(struct host_cmd_ds_802_11_ad_hoc_start)
 			     + S_DS_GEN + cmd_append_size));
 
-	memcpy(&tmp_cap, &adhoc_start->cap, sizeof(u16));
-
 	if (adapter->adhoc_start_band == BAND_B)
 		SHORT_SLOT_TIME_DISABLED(tmp_cap);
 	else
 		SHORT_SLOT_TIME_ENABLED(tmp_cap);
 
-	memcpy(&adhoc_start->cap, &tmp_cap, sizeof(u16));
+	adhoc_start->cap_info_bitmap = cpu_to_le16(tmp_cap);
 
 	ret = MWIFIEX_STATUS_SUCCESS;
 done:
@@ -1271,15 +1270,12 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 	memcpy(&adhoc_join->bss_descriptor.ss_param_set,
 	       &bss_desc->ss_param_set, sizeof(union ieee_types_ss_param_set));
 
-	memcpy(&tmp_cap, &bss_desc->cap_info,
-	       sizeof(struct ieee_types_cap_info));
+	tmp_cap = bss_desc->cap_info_bitmap;
 
 	tmp_cap &= CAPINFO_MASK;
 
 	PRINTM(MINFO, "ADHOC_J_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
 	       tmp_cap, CAPINFO_MASK);
-	memcpy(&adhoc_join->bss_descriptor.cap, &tmp_cap,
-	       sizeof(struct ieee_types_cap_info));
 
 	/* Information on BSSID descriptor passed to FW */
 	PRINTM(MINFO,
@@ -1319,7 +1315,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED
 	    || priv->sec_info.wpa_enabled || priv->sec_info.ewpa_enabled)
-		adhoc_join->bss_descriptor.cap.privacy = AD_HOC_CAP_PRIVACY_ON;
+		tmp_cap |= WLAN_CAPABILITY_PRIVACY;
 
 	if (IS_SUPPORT_MULTI_BANDS(priv->adapter)) {
 		/* Append a channel TLV */
@@ -1460,11 +1456,8 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			    (sizeof(struct host_cmd_ds_802_11_ad_hoc_join)
 			     + S_DS_GEN + cmd_append_size));
 
-	memcpy(&tmp_cap, &adhoc_join->bss_descriptor.cap,
-	       sizeof(struct ieee_types_cap_info));
-
-	memcpy(&adhoc_join->bss_descriptor.cap,
-	       &tmp_cap, sizeof(struct ieee_types_cap_info));
+	adhoc_join->bss_descriptor.cap_info_bitmap =
+				cpu_to_le16(tmp_cap);
 
 done:
 	LEAVE();
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index d69a6cb..f496045 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -731,19 +731,18 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 							active_scan_time);
 			}
 			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
-				scan_chan_list[chan_idx].chan_scan_mode.
-				passive_scan = true;
+				scan_chan_list[chan_idx].chan_scan_mode_bitmap
+					|= MWIFIEX_PASSIVE_SCAN;
 			else
-				scan_chan_list[chan_idx].chan_scan_mode.
-				passive_scan = false;
+				scan_chan_list[chan_idx].chan_scan_mode_bitmap
+					&= ~MWIFIEX_PASSIVE_SCAN;
 			scan_chan_list[chan_idx].chan_number =
 							(u32) ch->hw_value;
 			if (filtered_scan) {
 				scan_chan_list[chan_idx].max_scan_time =
 				cpu_to_le16(adapter->specific_scan_time);
-				scan_chan_list[chan_idx].chan_scan_mode.
-				disable_chan_filt =
-					true;
+				scan_chan_list[chan_idx].chan_scan_mode_bitmap
+					|= MWIFIEX_DISABLE_CHAN_FILT;
 			}
 		}
 
@@ -822,8 +821,10 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			       "Dur(%d)\n",
 			       tmp_chan_list->chan_number,
 			       tmp_chan_list->radio_type,
-			       tmp_chan_list->chan_scan_mode.passive_scan,
-			       tmp_chan_list->chan_scan_mode.disable_chan_filt,
+			       tmp_chan_list->chan_scan_mode_bitmap
+			       & MWIFIEX_PASSIVE_SCAN,
+			       (tmp_chan_list->chan_scan_mode_bitmap
+			       & MWIFIEX_DISABLE_CHAN_FILT) >> 1,
 			       le16_to_cpu(tmp_chan_list->max_scan_time));
 
 			/* Copy the current channel TLV to the command being
@@ -1172,10 +1173,12 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 
 			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE) {
 				(scan_chan_list +
-				 chan_idx)->chan_scan_mode.passive_scan = true;
+				 chan_idx)->chan_scan_mode_bitmap
+					|= MWIFIEX_PASSIVE_SCAN;
 			} else {
 				(scan_chan_list +
-				 chan_idx)->chan_scan_mode.passive_scan = false;
+				 chan_idx)->chan_scan_mode_bitmap
+					&= ~MWIFIEX_PASSIVE_SCAN;
 			}
 
 			if (user_scan_in->chan_list[chan_idx].scan_time) {
@@ -1334,7 +1337,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	struct ieee_types_ds_param_set *ds_param_set;
 	struct ieee_types_cf_param_set *cf_param_set;
 	struct ieee_types_ibss_param_set *ibss_param_set;
-	struct ieee_types_cap_info *cap_info;
 	struct mwifiex_802_11_fixed_ies fixed_ie;
 	u8 *current_ptr;
 	u8 *rate;
@@ -1434,9 +1436,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	memcpy(&fixed_ie.capabilities, current_ptr, 2);
 	PRINTM(MINFO, "InterpretIE: fixed_ie.capabilities=0x%X\n",
 	       fixed_ie.capabilities);
-	cap_info = (struct ieee_types_cap_info *) &fixed_ie.capabilities;
-	memcpy(&bss_entry->cap_info, cap_info,
-	       sizeof(struct ieee_types_cap_info));
+	bss_entry->cap_info_bitmap = le16_to_cpu(fixed_ie.capabilities);
 	current_ptr += 2;
 	bytes_left_for_current_beacon -= 2;
 
@@ -1447,14 +1447,14 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	HEXDUMP("InterpretIE: IE info", (u8 *) current_ptr,
 		bytes_left_for_current_beacon);
 
-	if (cap_info->privacy) {
+	if (bss_entry->cap_info_bitmap & WLAN_CAPABILITY_PRIVACY) {
 		PRINTM(MINFO, "InterpretIE: AP WEP enabled\n");
 		bss_entry->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
 	} else {
 		bss_entry->privacy = MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL;
 	}
 
-	if (cap_info->ibss == 1)
+	if (bss_entry->cap_info_bitmap & WLAN_CAPABILITY_IBSS)
 		bss_entry->bss_mode = MWIFIEX_BSS_MODE_IBSS;
 	else
 		bss_entry->bss_mode = MWIFIEX_BSS_MODE_INFRA;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 4758151..3993845 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -91,10 +91,14 @@ mwifiex_wmm_ac_debug_print(const struct ieee_types_wmm_ac_parameters *ac_param)
 
 	PRINTM(MINFO, "WMM AC_%s: ACI=%d, ACM=%d, Aifsn=%d, "
 	       "EcwMin=%d, EcwMax=%d, TxopLimit=%d\n",
-	       ac_str[wmm_aci_to_qidx_map[ac_param->aci_aifsn.aci]],
-	       ac_param->aci_aifsn.aci, ac_param->aci_aifsn.acm,
-	       ac_param->aci_aifsn.aifsn, ac_param->ecw.ecw_min,
-	       ac_param->ecw.ecw_max, le16_to_cpu(ac_param->tx_op_limit));
+	       ac_str[wmm_aci_to_qidx_map[(ac_param->aci_aifsn_bitmap
+	       & MWIFIEX_ACI) >> 5]],
+	       (ac_param->aci_aifsn_bitmap & MWIFIEX_ACI) >> 5,
+	       (ac_param->aci_aifsn_bitmap & MWIFIEX_ACM) >> 4,
+	       ac_param->aci_aifsn_bitmap & MWIFIEX_AIFSN,
+	       ac_param->ecw_bitmap & MWIFIEX_ECW_MIN,
+	       (ac_param->ecw_bitmap & MWIFIEX_ECW_MAX) >> 4,
+	       le16_to_cpu(ac_param->tx_op_limit));
 
 	LEAVE();
 }
@@ -262,23 +266,28 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 		(u8 *) wmm_ie, sizeof(struct ieee_types_wmm_parameter));
 
 	PRINTM(MINFO, "WMM Parameter IE: version=%d, "
-	       "qos_info Parameter Set Count=%d, Reserved=%#x\n",
-	       wmm_ie->vend_hdr.version, wmm_ie->qos_info.para_set_count,
-	       wmm_ie->reserved);
+		"qos_info Parameter Set Count=%d, Reserved=%#x\n",
+		wmm_ie->vend_hdr.version, wmm_ie->qos_info_bitmap &
+		IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK,
+		wmm_ie->reserved);
 
 	for (num_ac = 0; num_ac < ARRAY_SIZE(wmm_ie->ac_params); num_ac++) {
-		cw_min = (1 << wmm_ie->ac_params[num_ac].ecw.ecw_min) - 1;
+		cw_min = (1 << (wmm_ie->ac_params[num_ac].ecw_bitmap &
+			MWIFIEX_ECW_MIN)) - 1;
 		avg_back_off =
 			(cw_min >> 1) +
-			wmm_ie->ac_params[num_ac].aci_aifsn.aifsn;
+			(wmm_ie->ac_params[num_ac].aci_aifsn_bitmap &
+			MWIFIEX_AIFSN);
 
-		ac_idx = wmm_aci_to_qidx_map[wmm_ie->ac_params[num_ac].
-					     aci_aifsn.aci];
+		ac_idx = wmm_aci_to_qidx_map[(wmm_ie->ac_params[num_ac].
+					     aci_aifsn_bitmap &
+					     MWIFIEX_ACI) >> 5];
 		priv->wmm.queue_priority[ac_idx] = ac_idx;
 		tmp[ac_idx] = avg_back_off;
 
 		PRINTM(MINFO, "WMM: CWmax=%d CWmin=%d Avg Back-off=%d\n",
-		       (1 << wmm_ie->ac_params[num_ac].ecw.ecw_max) - 1,
+		       (1 << ((wmm_ie->ac_params[num_ac].ecw_bitmap &
+		       MWIFIEX_ECW_MAX) >> 4)) - 1,
 		       cw_min, avg_back_off);
 		mwifiex_wmm_ac_debug_print(&wmm_ie->ac_params[num_ac]);
 	}
@@ -887,8 +896,9 @@ mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 						WLAN_EID_VENDOR_SPECIFIC;
 
 			PRINTM(MINFO, "CMD_RESP: WMM_GET_STATUS: WMM Parameter "
-					"Set: %d\n",
-					wmm_param_ie->qos_info.para_set_count);
+				"Set Count: %d\n",
+				wmm_param_ie->qos_info_bitmap &
+				IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK);
 
 			memcpy((u8 *) &priv->curr_bss_params.bss_descriptor.
 			       wmm_ie, wmm_param_ie,
@@ -962,7 +972,8 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 		wmm_tlv->header.len = cpu_to_le16((u16) wmm_info_ie[1]);
 		memcpy(wmm_tlv->wmm_ie, &wmm_info_ie[2],
 			le16_to_cpu(wmm_tlv->header.len));
-		if (wmm_ie->qos_info.qos_uapsd)
+		if (wmm_ie->qos_info_bitmap &
+				IEEE80211_WMM_IE_AP_QOSINFO_UAPSD)
 			memcpy((u8 *) (wmm_tlv->wmm_ie
 					+ le16_to_cpu(wmm_tlv->header.len)
 					 - sizeof(priv->wmm_qosinfo)),
-- 
1.7.0.2

