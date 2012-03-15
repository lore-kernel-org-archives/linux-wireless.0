Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33593 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2COSp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:45:27 -0400
Subject: [PATCH v3] wireless: rename ht_info to ht_operation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1331823014.3432.23.camel@jlt3.sipsolutions.net> (sfid-20120315_155029_590112_CAFFA07D)
References: <1331806879.3432.7.camel@jlt3.sipsolutions.net>
	 (sfid-20120315_112131_819302_49364FC7)  <1331823014.3432.23.camel@jlt3.sipsolutions.net>
	 (sfid-20120315_155029_590112_CAFFA07D)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 19:45:16 +0100
Message-ID: <1331837116.3432.33.camel@jlt3.sipsolutions.net> (sfid-20120315_194532_444707_C247B883)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since some of the HT code pre-dates 802.11n-2009
some names are wrong. The one that bothers me most
is that "HT operation" is called "HT information"
in our code and that causes confusion.

Rename "HT information" to "HT operation" and also
the control_chan field to primary_chan to match
the name used in the spec.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: fix patch for new mwifiex changes
v3: fix checkpatch

 drivers/net/wireless/mwifiex/11n.c  |   17 ++++++------
 drivers/net/wireless/mwifiex/fw.h   |    2 -
 drivers/net/wireless/mwifiex/join.c |   14 +++++-----
 drivers/net/wireless/mwifiex/main.h |    2 -
 drivers/net/wireless/mwifiex/scan.c |   12 ++++----
 drivers/net/wireless/wl12xx/main.c  |    2 -
 include/linux/ieee80211.h           |   14 ++++------
 include/net/mac80211.h              |    2 -
 net/mac80211/ibss.c                 |   16 +++++------
 net/mac80211/ieee80211_i.h          |   13 ++++-----
 net/mac80211/mesh.c                 |   12 ++++----
 net/mac80211/mesh.h                 |    2 -
 net/mac80211/mesh_plink.c           |    4 +-
 net/mac80211/mlme.c                 |   49 ++++++++++++++++++------------------
 net/mac80211/tx.c                   |    4 +-
 net/mac80211/util.c                 |   43 +++++++++++++++----------------
 16 files changed, 102 insertions(+), 106 deletions(-)

--- a/drivers/net/wireless/mwifiex/11n.c	2012-03-15 19:37:43.000000000 +0100
+++ b/drivers/net/wireless/mwifiex/11n.c	2012-03-15 19:43:55.000000000 +0100
@@ -350,25 +350,26 @@ mwifiex_cmd_append_11n_tlv(struct mwifie
 		ret_len += sizeof(struct mwifiex_ie_types_htcap);
 	}
 
-	if (bss_desc->bcn_ht_info) {
+	if (bss_desc->bcn_ht_oper) {
 		if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
 			ht_info = (struct mwifiex_ie_types_htinfo *) *buffer;
 			memset(ht_info, 0,
 			       sizeof(struct mwifiex_ie_types_htinfo));
 			ht_info->header.type =
-					cpu_to_le16(WLAN_EID_HT_INFORMATION);
+					cpu_to_le16(WLAN_EID_HT_OPERATION);
 			ht_info->header.len =
-				cpu_to_le16(sizeof(struct ieee80211_ht_info));
+				cpu_to_le16(
+					sizeof(struct ieee80211_ht_operation));
 
 			memcpy((u8 *) ht_info +
 			       sizeof(struct mwifiex_ie_types_header),
-			       (u8 *) bss_desc->bcn_ht_info +
+			       (u8 *) bss_desc->bcn_ht_oper +
 			       sizeof(struct ieee_types_header),
 			       le16_to_cpu(ht_info->header.len));
 
 			if (!(sband->ht_cap.cap &
 					IEEE80211_HT_CAP_SUP_WIDTH_20_40))
-				ht_info->ht_info.ht_param &=
+				ht_info->ht_oper.ht_param &=
 					~(IEEE80211_HT_PARAM_CHAN_WIDTH_ANY |
 					IEEE80211_HT_PARAM_CHA_SEC_OFFSET);
 
@@ -385,16 +386,16 @@ mwifiex_cmd_append_11n_tlv(struct mwifie
 			sizeof(struct mwifiex_ie_types_chan_list_param_set) -
 			sizeof(struct mwifiex_ie_types_header));
 		chan_list->chan_scan_param[0].chan_number =
-			bss_desc->bcn_ht_info->control_chan;
+			bss_desc->bcn_ht_oper->primary_chan;
 		chan_list->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
 		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 &&
-		    bss_desc->bcn_ht_info->ht_param &
+		    bss_desc->bcn_ht_oper->ht_param &
 		    IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)
 			SET_SECONDARYCHAN(chan_list->chan_scan_param[0].
 					  radio_type,
-					  (bss_desc->bcn_ht_info->ht_param &
+					  (bss_desc->bcn_ht_oper->ht_param &
 					  IEEE80211_HT_PARAM_CHA_SEC_OFFSET));
 
 		*buffer += sizeof(struct mwifiex_ie_types_chan_list_param_set);
--- a/drivers/net/wireless/mwifiex/scan.c	2012-03-15 19:37:43.000000000 +0100
+++ b/drivers/net/wireless/mwifiex/scan.c	2012-03-15 19:44:16.000000000 +0100
@@ -1221,9 +1221,9 @@ mwifiex_update_bss_desc_with_ie(struct m
 					sizeof(struct ieee_types_header) -
 					bss_entry->beacon_buf);
 			break;
-		case WLAN_EID_HT_INFORMATION:
-			bss_entry->bcn_ht_info = (struct ieee80211_ht_info *)
-					(current_ptr +
+		case WLAN_EID_HT_OPERATION:
+			bss_entry->bcn_ht_oper =
+				(struct ieee80211_ht_operation *)(current_ptr +
 					sizeof(struct ieee_types_header));
 			bss_entry->ht_info_offset = (u16) (current_ptr +
 					sizeof(struct ieee_types_header) -
@@ -1493,7 +1493,7 @@ mwifiex_update_curr_bss_params(struct mw
 	priv->curr_bss_params.bss_descriptor.bcn_ht_cap = NULL;
 	priv->curr_bss_params.bss_descriptor.ht_cap_offset =
 		0;
-	priv->curr_bss_params.bss_descriptor.bcn_ht_info = NULL;
+	priv->curr_bss_params.bss_descriptor.bcn_ht_oper = NULL;
 	priv->curr_bss_params.bss_descriptor.ht_info_offset =
 		0;
 	priv->curr_bss_params.bss_descriptor.bcn_bss_co_2040 =
@@ -2019,8 +2019,8 @@ mwifiex_save_curr_bcn(struct mwifiex_pri
 			(curr_bss->beacon_buf +
 			 curr_bss->ht_cap_offset);
 
-	if (curr_bss->bcn_ht_info)
-		curr_bss->bcn_ht_info = (struct ieee80211_ht_info *)
+	if (curr_bss->bcn_ht_oper)
+		curr_bss->bcn_ht_oper = (struct ieee80211_ht_operation *)
 			(curr_bss->beacon_buf +
 			 curr_bss->ht_info_offset);
 
--- a/drivers/net/wireless/wl12xx/main.c	2012-03-15 19:37:44.000000000 +0100
+++ b/drivers/net/wireless/wl12xx/main.c	2012-03-15 19:43:13.000000000 +0100
@@ -232,7 +232,7 @@ static struct conf_drv_settings default_
 				.rule        = CONF_BCN_RULE_PASS_ON_APPEARANCE,
 			},
 			[1] = {
-				.ie          = WLAN_EID_HT_INFORMATION,
+				.ie          = WLAN_EID_HT_OPERATION,
 				.rule        = CONF_BCN_RULE_PASS_ON_CHANGE,
 			},
 		},
--- a/include/linux/ieee80211.h	2012-03-15 19:37:43.000000000 +0100
+++ b/include/linux/ieee80211.h	2012-03-15 19:43:13.000000000 +0100
@@ -1007,13 +1007,13 @@ enum ieee80211_min_mpdu_spacing {
 };
 
 /**
- * struct ieee80211_ht_info - HT information
+ * struct ieee80211_ht_operation - HT operation IE
  *
- * This structure is the "HT information element" as
- * described in 802.11n D5.0 7.3.2.58
+ * This structure is the "HT operation element" as
+ * described in 802.11n-2009 7.3.2.57
  */
-struct ieee80211_ht_info {
-	u8 control_chan;
+struct ieee80211_ht_operation {
+	u8 primary_chan;
 	u8 ht_param;
 	__le16 operation_mode;
 	__le16 stbc_param;
@@ -1027,8 +1027,6 @@ struct ieee80211_ht_info {
 #define		IEEE80211_HT_PARAM_CHA_SEC_BELOW	0x03
 #define IEEE80211_HT_PARAM_CHAN_WIDTH_ANY		0x04
 #define IEEE80211_HT_PARAM_RIFS_MODE			0x08
-#define IEEE80211_HT_PARAM_SPSMP_SUPPORT		0x10
-#define IEEE80211_HT_PARAM_SERV_INTERVAL_GRAN		0xE0
 
 /* for operation_mode */
 #define IEEE80211_HT_OP_MODE_PROTECTION			0x0003
@@ -1301,7 +1299,7 @@ enum ieee80211_eid {
 	WLAN_EID_EXT_SUPP_RATES = 50,
 
 	WLAN_EID_HT_CAPABILITY = 45,
-	WLAN_EID_HT_INFORMATION = 61,
+	WLAN_EID_HT_OPERATION = 61,
 
 	WLAN_EID_RSN = 48,
 	WLAN_EID_MMIE = 76,
--- a/net/mac80211/mlme.c	2012-03-15 19:37:43.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-15 19:43:34.000000000 +0100
@@ -177,7 +177,7 @@ static int ecw2cw(int ecw)
  * HT abilities for a specific band.
  */
 static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
-			       struct ieee80211_ht_info *hti,
+			       struct ieee80211_ht_operation *ht_oper,
 			       const u8 *bssid, u16 ap_ht_cap_flags,
 			       bool beacon_htcap_ie)
 {
@@ -185,7 +185,7 @@ static u32 ieee80211_enable_ht(struct ie
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 	u32 changed = 0;
-	int hti_cfreq;
+	int ht_cfreq;
 	u16 ht_opmode;
 	bool enable_ht = true;
 	enum nl80211_channel_type prev_chantype;
@@ -196,10 +196,10 @@ static u32 ieee80211_enable_ht(struct ie
 	prev_chantype = sdata->vif.bss_conf.channel_type;
 
 
-	hti_cfreq = ieee80211_channel_to_frequency(hti->control_chan,
-						   sband->band);
+	ht_cfreq = ieee80211_channel_to_frequency(ht_oper->primary_chan,
+						  sband->band);
 	/* check that channel matches the right operating channel */
-	if (local->hw.conf.channel->center_freq != hti_cfreq) {
+	if (local->hw.conf.channel->center_freq != ht_cfreq) {
 		/* Some APs mess this up, evidently.
 		 * Netgear WNDR3700 sometimes reports 4 higher than
 		 * the actual channel, for instance.
@@ -207,11 +207,11 @@ static u32 ieee80211_enable_ht(struct ie
 		printk(KERN_DEBUG
 		       "%s: Wrong control channel in association"
 		       " response: configured center-freq: %d"
-		       " hti-cfreq: %d  hti->control_chan: %d"
+		       " ht-cfreq: %d  ht->control_chan: %d"
 		       " band: %d.  Disabling HT.\n",
 		       sdata->name,
 		       local->hw.conf.channel->center_freq,
-		       hti_cfreq, hti->control_chan,
+		       ht_cfreq, ht_oper->primary_chan,
 		       sband->band);
 		enable_ht = false;
 	}
@@ -222,8 +222,9 @@ static u32 ieee80211_enable_ht(struct ie
 		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
 		    !ieee80111_cfg_override_disables_ht40(sdata) &&
 		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
-		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
-			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+		    (ht_oper->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
+			switch (ht_oper->ht_param &
+					IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 				rx_channel_type = NL80211_CHAN_HT40PLUS;
 				break;
@@ -278,7 +279,7 @@ static u32 ieee80211_enable_ht(struct ie
 				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
 	}
 
-	ht_opmode = le16_to_cpu(hti->operation_mode);
+	ht_opmode = le16_to_cpu(ht_oper->operation_mode);
 
 	/* if bss configuration changed store the new one */
 	if (sdata->ht_opmode_valid != enable_ht ||
@@ -316,12 +317,12 @@ static int ieee80211_compatible_rates(co
 }
 
 static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
-				struct sk_buff *skb, const u8 *ht_info_ie,
+				struct sk_buff *skb, const u8 *ht_oper_ie,
 				struct ieee80211_supported_band *sband,
 				struct ieee80211_channel *channel,
 				enum ieee80211_smps_mode smps)
 {
-	struct ieee80211_ht_info *ht_info;
+	struct ieee80211_ht_operation *ht_oper;
 	u8 *pos;
 	u32 flags = channel->flags;
 	u16 cap;
@@ -329,21 +330,21 @@ static void ieee80211_add_ht_ie(struct i
 
 	BUILD_BUG_ON(sizeof(ht_cap) != sizeof(sband->ht_cap));
 
-	if (!ht_info_ie)
+	if (!ht_oper_ie)
 		return;
 
-	if (ht_info_ie[1] < sizeof(struct ieee80211_ht_info))
+	if (ht_oper_ie[1] < sizeof(struct ieee80211_ht_operation))
 		return;
 
 	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
 	ieee80211_apply_htcap_overrides(sdata, &ht_cap);
 
-	ht_info = (struct ieee80211_ht_info *)(ht_info_ie + 2);
+	ht_oper = (struct ieee80211_ht_operation *)(ht_oper_ie + 2);
 
 	/* determine capability flags */
 	cap = ht_cap.cap;
 
-	switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+	switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 		if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
 			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
@@ -557,7 +558,7 @@ static void ieee80211_send_assoc(struct
 	}
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
-		ieee80211_add_ht_ie(sdata, skb, assoc_data->ht_information_ie,
+		ieee80211_add_ht_ie(sdata, skb, assoc_data->ht_operation_ie,
 				    sband, local->oper_channel, ifmgd->ap_smps);
 
 	/* if present, add any custom non-vendor IEs that go after HT */
@@ -2092,9 +2093,9 @@ static bool ieee80211_assoc_success(stru
 		ieee80211_set_wmm_default(sdata, false);
 	changed |= BSS_CHANGED_QOS;
 
-	if (elems.ht_info_elem && elems.wmm_param &&
+	if (elems.ht_operation && elems.wmm_param &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
-		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
+		changed |= ieee80211_enable_ht(sdata, elems.ht_operation,
 					       cbss->bssid, ap_ht_cap_flags,
 					       false);
 
@@ -2319,7 +2320,7 @@ static const u64 care_about_ies =
 	(1ULL << WLAN_EID_CHANNEL_SWITCH) |
 	(1ULL << WLAN_EID_PWR_CONSTRAINT) |
 	(1ULL << WLAN_EID_HT_CAPABILITY) |
-	(1ULL << WLAN_EID_HT_INFORMATION);
+	(1ULL << WLAN_EID_HT_OPERATION);
 
 static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt,
@@ -2504,7 +2505,7 @@ static void ieee80211_rx_mgmt_beacon(str
 			erp_valid, erp_value);
 
 
-	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
+	if (elems.ht_cap_elem && elems.ht_operation && elems.wmm_param &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N)) {
 		struct sta_info *sta;
 		struct ieee80211_supported_band *sband;
@@ -2527,7 +2528,7 @@ static void ieee80211_rx_mgmt_beacon(str
 
 		rcu_read_unlock();
 
-		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
+		changed |= ieee80211_enable_ht(sdata, elems.ht_operation,
 					       bssid, ap_ht_cap_flags, true);
 	}
 
@@ -3335,8 +3336,8 @@ int ieee80211_mgd_assoc(struct ieee80211
 	assoc_data->wmm = bss->wmm_used && (local->hw.queues >= 4);
 	assoc_data->supp_rates = bss->supp_rates;
 	assoc_data->supp_rates_len = bss->supp_rates_len;
-	assoc_data->ht_information_ie =
-		ieee80211_bss_get_ie(req->bss, WLAN_EID_HT_INFORMATION);
+	assoc_data->ht_operation_ie =
+		ieee80211_bss_get_ie(req->bss, WLAN_EID_HT_OPERATION);
 
 	if (bss->wmm_used && bss->uapsd_supported &&
 	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
--- a/net/mac80211/util.c	2012-03-15 19:37:43.000000000 +0100
+++ b/net/mac80211/util.c	2012-03-15 19:43:13.000000000 +0100
@@ -684,9 +684,9 @@ u32 ieee802_11_parse_elems_crc(u8 *start
 			else
 				elem_parse_failed = true;
 			break;
-		case WLAN_EID_HT_INFORMATION:
-			if (elen >= sizeof(struct ieee80211_ht_info))
-				elems->ht_info_elem = (void *)pos;
+		case WLAN_EID_HT_OPERATION:
+			if (elen >= sizeof(struct ieee80211_ht_operation))
+				elems->ht_operation = (void *)pos;
 			else
 				elem_parse_failed = true;
 			break;
@@ -1611,57 +1611,56 @@ u8 *ieee80211_ie_build_ht_cap(u8 *pos, s
 	return pos;
 }
 
-u8 *ieee80211_ie_build_ht_info(u8 *pos,
-			       struct ieee80211_sta_ht_cap *ht_cap,
+u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       struct ieee80211_channel *channel,
 			       enum nl80211_channel_type channel_type)
 {
-	struct ieee80211_ht_info *ht_info;
+	struct ieee80211_ht_operation *ht_oper;
 	/* Build HT Information */
-	*pos++ = WLAN_EID_HT_INFORMATION;
-	*pos++ = sizeof(struct ieee80211_ht_info);
-	ht_info = (struct ieee80211_ht_info *)pos;
-	ht_info->control_chan =
+	*pos++ = WLAN_EID_HT_OPERATION;
+	*pos++ = sizeof(struct ieee80211_ht_operation);
+	ht_oper = (struct ieee80211_ht_operation *)pos;
+	ht_oper->primary_chan =
 			ieee80211_frequency_to_channel(channel->center_freq);
 	switch (channel_type) {
 	case NL80211_CHAN_HT40MINUS:
-		ht_info->ht_param = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+		ht_oper->ht_param = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
 		break;
 	case NL80211_CHAN_HT40PLUS:
-		ht_info->ht_param = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		ht_oper->ht_param = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
 		break;
 	case NL80211_CHAN_HT20:
 	default:
-		ht_info->ht_param = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+		ht_oper->ht_param = IEEE80211_HT_PARAM_CHA_SEC_NONE;
 		break;
 	}
 	if (ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
-		ht_info->ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
+		ht_oper->ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
 
 	/*
 	 * Note: According to 802.11n-2009 9.13.3.1, HT Protection field and
 	 * RIFS Mode are reserved in IBSS mode, therefore keep them at 0
 	 */
-	ht_info->operation_mode = 0x0000;
-	ht_info->stbc_param = 0x0000;
+	ht_oper->operation_mode = 0x0000;
+	ht_oper->stbc_param = 0x0000;
 
 	/* It seems that Basic MCS set and Supported MCS set
 	   are identical for the first 10 bytes */
-	memset(&ht_info->basic_set, 0, 16);
-	memcpy(&ht_info->basic_set, &ht_cap->mcs, 10);
+	memset(&ht_oper->basic_set, 0, 16);
+	memcpy(&ht_oper->basic_set, &ht_cap->mcs, 10);
 
-	return pos + sizeof(struct ieee80211_ht_info);
+	return pos + sizeof(struct ieee80211_ht_operation);
 }
 
 enum nl80211_channel_type
-ieee80211_ht_info_to_channel_type(struct ieee80211_ht_info *ht_info)
+ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper)
 {
 	enum nl80211_channel_type channel_type;
 
-	if (!ht_info)
+	if (!ht_oper)
 		return NL80211_CHAN_NO_HT;
 
-	switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+	switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
 		channel_type = NL80211_CHAN_HT20;
 		break;
--- a/drivers/net/wireless/mwifiex/fw.h	2012-03-15 19:37:43.000000000 +0100
+++ b/drivers/net/wireless/mwifiex/fw.h	2012-03-15 19:43:13.000000000 +0100
@@ -1045,7 +1045,7 @@ struct mwifiex_ie_types_htcap {
 
 struct mwifiex_ie_types_htinfo {
 	struct mwifiex_ie_types_header header;
-	struct ieee80211_ht_info ht_info;
+	struct ieee80211_ht_operation ht_oper;
 } __packed;
 
 struct mwifiex_ie_types_2040bssco {
--- a/drivers/net/wireless/mwifiex/main.h	2012-03-15 19:37:43.000000000 +0100
+++ b/drivers/net/wireless/mwifiex/main.h	2012-03-15 19:43:13.000000000 +0100
@@ -269,7 +269,7 @@ struct mwifiex_bssdescriptor {
 	u8  disable_11n;
 	struct ieee80211_ht_cap *bcn_ht_cap;
 	u16 ht_cap_offset;
-	struct ieee80211_ht_info *bcn_ht_info;
+	struct ieee80211_ht_operation *bcn_ht_oper;
 	u16 ht_info_offset;
 	u8 *bcn_bss_co_2040;
 	u16 bss_co_2040_offset;
--- a/include/net/mac80211.h	2012-03-15 19:37:43.000000000 +0100
+++ b/include/net/mac80211.h	2012-03-15 19:43:13.000000000 +0100
@@ -242,7 +242,7 @@ enum ieee80211_rssi_event {
  * @channel_type: Channel type for this BSS -- the hardware might be
  *	configured for HT40+ while this BSS only uses no-HT, for
  *	example.
- * @ht_operation_mode: HT operation mode (like in &struct ieee80211_ht_info).
+ * @ht_operation_mode: HT operation mode like in &struct ieee80211_ht_operation.
  *	This field is only valid when the channel type is one of the HT types.
  * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
  *	implies disabled
--- a/net/mac80211/ibss.c	2012-03-15 19:37:43.000000000 +0100
+++ b/net/mac80211/ibss.c	2012-03-15 19:43:13.000000000 +0100
@@ -160,13 +160,11 @@ static void __ieee80211_sta_join_ibss(st
 	if (channel_type && sband->ht_cap.ht_supported) {
 		pos = skb_put(skb, 4 +
 				   sizeof(struct ieee80211_ht_cap) +
-				   sizeof(struct ieee80211_ht_info));
+				   sizeof(struct ieee80211_ht_operation));
 		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
 						sband->ht_cap.cap);
-		pos = ieee80211_ie_build_ht_info(pos,
-						 &sband->ht_cap,
-						 chan,
-						 channel_type);
+		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
+						 chan, channel_type);
 	}
 
 	if (local->hw.queues >= 4) {
@@ -441,13 +439,13 @@ static void ieee80211_rx_bss_info(struct
 		if (sta && elems->wmm_info)
 			set_sta_flag(sta, WLAN_STA_WME);
 
-		if (sta && elems->ht_info_elem && elems->ht_cap_elem &&
+		if (sta && elems->ht_operation && elems->ht_cap_elem &&
 		    sdata->u.ibss.channel_type != NL80211_CHAN_NO_HT) {
 			/* we both use HT */
 			struct ieee80211_sta_ht_cap sta_ht_cap_new;
 			enum nl80211_channel_type channel_type =
-				ieee80211_ht_info_to_channel_type(
-							elems->ht_info_elem);
+				ieee80211_ht_oper_to_channel_type(
+							elems->ht_operation);
 
 			ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 							  elems->ht_cap_elem,
@@ -1063,7 +1061,7 @@ int ieee80211_ibss_join(struct ieee80211
 			    4 /* IBSS params */ +
 			    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
 			    2 + sizeof(struct ieee80211_ht_cap) +
-			    2 + sizeof(struct ieee80211_ht_info) +
+			    2 + sizeof(struct ieee80211_ht_operation) +
 			    params->ie_len);
 	if (!skb)
 		return -ENOMEM;
--- a/net/mac80211/ieee80211_i.h	2012-03-15 19:37:43.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2012-03-15 19:43:13.000000000 +0100
@@ -397,7 +397,7 @@ struct ieee80211_mgd_auth_data {
 struct ieee80211_mgd_assoc_data {
 	struct cfg80211_bss *bss;
 	const u8 *supp_rates;
-	const u8 *ht_information_ie;
+	const u8 *ht_operation_ie;
 
 	unsigned long timeout;
 	int tries;
@@ -1117,7 +1117,7 @@ struct ieee802_11_elems {
 	u8 *wmm_info;
 	u8 *wmm_param;
 	struct ieee80211_ht_cap *ht_cap_elem;
-	struct ieee80211_ht_info *ht_info_elem;
+	struct ieee80211_ht_operation *ht_operation;
 	struct ieee80211_meshconf_ie *mesh_config;
 	u8 *mesh_id;
 	u8 *peering;
@@ -1470,10 +1470,9 @@ size_t ieee80211_ie_split(const u8 *ies,
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
 u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			      u16 cap);
-u8 *ieee80211_ie_build_ht_info(u8 *pos,
-				struct ieee80211_sta_ht_cap *ht_cap,
-				struct ieee80211_channel *channel,
-				enum nl80211_channel_type channel_type);
+u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
+			       struct ieee80211_channel *channel,
+			       enum nl80211_channel_type channel_type);
 
 /* internal work items */
 void ieee80211_work_init(struct ieee80211_local *local);
@@ -1501,7 +1500,7 @@ bool ieee80211_set_channel_type(struct i
 				struct ieee80211_sub_if_data *sdata,
 				enum nl80211_channel_type chantype);
 enum nl80211_channel_type
-ieee80211_ht_info_to_channel_type(struct ieee80211_ht_info *ht_info);
+ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper);
 enum nl80211_channel_type ieee80211_get_tx_channel_type(
 					struct ieee80211_local *local,
 					enum nl80211_channel_type channel_type);
--- a/net/mac80211/mesh.c	2012-03-15 19:37:43.000000000 +0100
+++ b/net/mac80211/mesh.c	2012-03-15 19:43:13.000000000 +0100
@@ -98,9 +98,9 @@ bool mesh_matches_local(struct ieee802_1
 		goto mismatch;
 
 	/* disallow peering with mismatched channel types for now */
-	if (ie->ht_info_elem &&
+	if (ie->ht_operation &&
 	    (local->_oper_channel_type !=
-	     ieee80211_ht_info_to_channel_type(ie->ht_info_elem)))
+	     ieee80211_ht_oper_to_channel_type(ie->ht_operation)))
 		goto mismatch;
 
 	return true;
@@ -371,7 +371,7 @@ int mesh_add_ht_cap_ie(struct sk_buff *s
 	return 0;
 }
 
-int mesh_add_ht_info_ie(struct sk_buff *skb,
+int mesh_add_ht_oper_ie(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -385,11 +385,11 @@ int mesh_add_ht_info_ie(struct sk_buff *
 	if (!ht_cap->ht_supported || channel_type == NL80211_CHAN_NO_HT)
 		return 0;
 
-	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_info))
+	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_operation))
 		return -ENOMEM;
 
-	pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_info));
-	ieee80211_ie_build_ht_info(pos, ht_cap, channel, channel_type);
+	pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_operation));
+	ieee80211_ie_build_ht_oper(pos, ht_cap, channel, channel_type);
 
 	return 0;
 }
--- a/net/mac80211/mesh_plink.c	2012-03-15 19:37:43.000000000 +0100
+++ b/net/mac80211/mesh_plink.c	2012-03-15 19:43:13.000000000 +0100
@@ -187,7 +187,7 @@ static int mesh_plink_frame_tx(struct ie
 			    2 + sdata->u.mesh.mesh_id_len +
 			    2 + sizeof(struct ieee80211_meshconf_ie) +
 			    2 + sizeof(struct ieee80211_ht_cap) +
-			    2 + sizeof(struct ieee80211_ht_info) +
+			    2 + sizeof(struct ieee80211_ht_operation) +
 			    2 + 8 + /* peering IE */
 			    sdata->u.mesh.ie_len);
 	if (!skb)
@@ -263,7 +263,7 @@ static int mesh_plink_frame_tx(struct ie
 
 	if (action != WLAN_SP_MESH_PEERING_CLOSE) {
 		if (mesh_add_ht_cap_ie(skb, sdata) ||
-		    mesh_add_ht_info_ie(skb, sdata))
+		    mesh_add_ht_oper_ie(skb, sdata))
 			return -1;
 	}
 
--- a/net/mac80211/tx.c	2012-03-15 19:37:43.000000000 +0100
+++ b/net/mac80211/tx.c	2012-03-15 19:43:13.000000000 +0100
@@ -2390,7 +2390,7 @@ struct sk_buff *ieee80211_beacon_get_tim
 				    2 + 3 + /* DS params */
 				    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
 				    2 + sizeof(struct ieee80211_ht_cap) +
-				    2 + sizeof(struct ieee80211_ht_info) +
+				    2 + sizeof(struct ieee80211_ht_operation) +
 				    2 + sdata->u.mesh.mesh_id_len +
 				    2 + sizeof(struct ieee80211_meshconf_ie) +
 				    sdata->u.mesh.ie_len);
@@ -2419,7 +2419,7 @@ struct sk_buff *ieee80211_beacon_get_tim
 		    ieee80211_add_ext_srates_ie(&sdata->vif, skb) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_ht_cap_ie(skb, sdata) ||
-		    mesh_add_ht_info_ie(skb, sdata) ||
+		    mesh_add_ht_oper_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata) ||
 		    mesh_add_vendor_ies(skb, sdata)) {
--- a/net/mac80211/mesh.h	2012-03-15 19:37:43.000000000 +0100
+++ b/net/mac80211/mesh.h	2012-03-15 19:43:13.000000000 +0100
@@ -220,7 +220,7 @@ int mesh_add_ds_params_ie(struct sk_buff
 			  struct ieee80211_sub_if_data *sdata);
 int mesh_add_ht_cap_ie(struct sk_buff *skb,
 		       struct ieee80211_sub_if_data *sdata);
-int mesh_add_ht_info_ie(struct sk_buff *skb,
+int mesh_add_ht_oper_ie(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata);
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
--- a/drivers/net/wireless/mwifiex/join.c	2012-03-15 19:37:44.000000000 +0100
+++ b/drivers/net/wireless/mwifiex/join.c	2012-03-15 19:43:13.000000000 +0100
@@ -932,20 +932,20 @@ mwifiex_cmd_802_11_ad_hoc_start(struct m
 		/* Fill HT INFORMATION */
 		ht_info = (struct mwifiex_ie_types_htinfo *) pos;
 		memset(ht_info, 0, sizeof(struct mwifiex_ie_types_htinfo));
-		ht_info->header.type = cpu_to_le16(WLAN_EID_HT_INFORMATION);
+		ht_info->header.type = cpu_to_le16(WLAN_EID_HT_OPERATION);
 		ht_info->header.len =
-				cpu_to_le16(sizeof(struct ieee80211_ht_info));
+			cpu_to_le16(sizeof(struct ieee80211_ht_operation));
 
-		ht_info->ht_info.control_chan =
+		ht_info->ht_oper.primary_chan =
 			(u8) priv->curr_bss_params.bss_descriptor.channel;
 		if (adapter->sec_chan_offset) {
-			ht_info->ht_info.ht_param = adapter->sec_chan_offset;
-			ht_info->ht_info.ht_param |=
+			ht_info->ht_oper.ht_param = adapter->sec_chan_offset;
+			ht_info->ht_oper.ht_param |=
 					IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
 		}
-		ht_info->ht_info.operation_mode =
+		ht_info->ht_oper.operation_mode =
 		     cpu_to_le16(IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
-		ht_info->ht_info.basic_set[0] = 0xff;
+		ht_info->ht_oper.basic_set[0] = 0xff;
 		pos += sizeof(struct mwifiex_ie_types_htinfo);
 		cmd_append_size +=
 				sizeof(struct mwifiex_ie_types_htinfo);


