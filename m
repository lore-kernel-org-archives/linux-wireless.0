Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935861Ab3DJMnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 08:43:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/8] mac80211: parse VHT channel switch IEs
Date: Wed, 10 Apr 2013 14:43:41 +0200
Message-Id: <1365597822-27660-8-git-send-email-johannes@sipsolutions.net> (sfid-20130410_144356_396014_1E7DD326)
In-Reply-To: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
References: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

VHT introduces multiple IEs that need to be parsed for a
wide bandwidth channel switch. Two are (currently) needed
in mac80211:
 * wide bandwidth channel switch element
 * channel switch wrapper element

The former is contained in the latter for beacons and probe
responses, but not for the spectrum management action frames
so the IE parser needs a new argument to differentiate them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h  | 10 ++++++++++
 net/mac80211/ibss.c        |  2 +-
 net/mac80211/ieee80211_i.h |  7 ++++---
 net/mac80211/mesh.c        |  4 ++--
 net/mac80211/mesh_hwmp.c   |  2 +-
 net/mac80211/mesh_plink.c  |  2 +-
 net/mac80211/mlme.c        | 16 ++++++++--------
 net/mac80211/scan.c        |  2 +-
 net/mac80211/util.c        | 36 +++++++++++++++++++++++++++++++++++-
 9 files changed, 63 insertions(+), 18 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ce07161..06b0ed0 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -695,6 +695,14 @@ struct ieee80211_sec_chan_offs_ie {
 } __packed;
 
 /**
+ * struct ieee80211_wide_bw_chansw_ie - wide bandwidth channel switch IE
+ */
+struct ieee80211_wide_bw_chansw_ie {
+	u8 new_channel_width;
+	u8 new_center_freq_seg0, new_center_freq_seg1;
+} __packed;
+
+/**
  * struct ieee80211_tim
  *
  * This structure refers to "Traffic Indication Map information element"
@@ -1698,6 +1706,8 @@ enum ieee80211_eid {
 	WLAN_EID_VHT_CAPABILITY = 191,
 	WLAN_EID_VHT_OPERATION = 192,
 	WLAN_EID_OPMODE_NOTIF = 199,
+	WLAN_EID_WIDE_BW_CHANNEL_SWITCH = 194,
+	WLAN_EID_CHANNEL_SWITCH_WRAPPER = 196,
 
 	/* 802.11ad */
 	WLAN_EID_NON_TX_BSSID_CAP =  83,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 2a0b218..8c3905d 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -911,7 +911,7 @@ void ieee80211_rx_mgmt_probe_beacon(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
-				&elems);
+			       false, &elems);
 
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8f240c0..f4a65a3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1179,6 +1179,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_rann_ie *rann;
 	const struct ieee80211_channel_sw_ie *ch_switch_ie;
 	const struct ieee80211_ext_chansw_ie *ext_chansw_ie;
+	const struct ieee80211_wide_bw_chansw_ie *wide_bw_chansw_ie;
 	const u8 *country_elem;
 	const u8 *pwr_constr_elem;
 	const struct ieee80211_timeout_interval_ie *timeout_int;
@@ -1490,13 +1491,13 @@ static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb_tid(sdata, skb, 7);
 }
 
-u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
+u32 ieee802_11_parse_elems_crc(u8 *start, size_t len, bool action,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc);
-static inline void ieee802_11_parse_elems(u8 *start, size_t len,
+static inline void ieee802_11_parse_elems(u8 *start, size_t len, bool action,
 					  struct ieee802_11_elems *elems)
 {
-	ieee802_11_parse_elems_crc(start, len, elems, 0, 0);
+	ieee802_11_parse_elems_crc(start, len, action, elems, 0, 0);
 }
 
 u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0acc287..4b98476 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -838,7 +838,7 @@ ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
 	if (baselen > len)
 		return;
 
-	ieee802_11_parse_elems(pos, len - baselen, &elems);
+	ieee802_11_parse_elems(pos, len - baselen, false, &elems);
 
 	/* 802.11-2012 10.1.4.3.2 */
 	if ((!ether_addr_equal(mgmt->da, sdata->vif.addr) &&
@@ -899,7 +899,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
-			       &elems);
+			       false, &elems);
 
 	/* ignore non-mesh or secure / unsecure mismatch */
 	if ((!elems.mesh_id || !elems.mesh_config) ||
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index c82d5e6..486819c 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -880,7 +880,7 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 
 	baselen = (u8 *) mgmt->u.action.u.mesh_action.variable - (u8 *) mgmt;
 	ieee802_11_parse_elems(mgmt->u.action.u.mesh_action.variable,
-			len - baselen, &elems);
+			       len - baselen, false, &elems);
 
 	if (elems.preq) {
 		if (elems.preq_len != 37)
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index cdd4183..09bebed 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -687,7 +687,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		baseaddr += 4;
 		baselen += 4;
 	}
-	ieee802_11_parse_elems(baseaddr, len - baselen, &elems);
+	ieee802_11_parse_elems(baseaddr, len - baselen, true, &elems);
 
 	if (!elems.peering) {
 		mpl_dbg(sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 54d2cec..bfe70de 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2204,7 +2204,7 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 	u32 tx_flags = 0;
 
 	pos = mgmt->u.auth.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), false, &elems);
 	if (!elems.challenge)
 		return;
 	auth_data->expected_transaction = 4;
@@ -2469,7 +2469,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	}
 
 	pos = mgmt->u.assoc_resp.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), false, &elems);
 
 	if (!elems.supp_rates) {
 		sdata_info(sdata, "no SuppRates element in AssocResp\n");
@@ -2638,7 +2638,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		   capab_info, status_code, (u16)(aid & ~(BIT(15) | BIT(14))));
 
 	pos = mgmt->u.assoc_resp.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), false, &elems);
 
 	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
 	    elems.timeout_int &&
@@ -2761,7 +2761,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
-				&elems);
+			       false, &elems);
 
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 
@@ -2844,7 +2844,7 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->assoc_data && ifmgd->assoc_data->need_beacon &&
 	    ether_addr_equal(mgmt->bssid, ifmgd->assoc_data->bss->bssid)) {
 		ieee802_11_parse_elems(mgmt->u.beacon.variable,
-				       len - baselen, &elems);
+				       len - baselen, false, &elems);
 
 		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 		ifmgd->assoc_data->have_beacon = true;
@@ -2954,7 +2954,7 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ncrc = crc32_be(0, (void *)&mgmt->u.beacon.beacon_int, 4);
 	ncrc = ieee802_11_parse_elems_crc(mgmt->u.beacon.variable,
-					  len - baselen, &elems,
+					  len - baselen, false, &elems,
 					  care_about_ies, ncrc);
 
 	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
@@ -3142,7 +3142,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 			ieee802_11_parse_elems(
 				mgmt->u.action.u.chan_switch.variable,
-				ies_len, &elems);
+				ies_len, true, &elems);
 
 			if (elems.parse_error)
 				break;
@@ -3160,7 +3160,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 			ieee802_11_parse_elems(
 				mgmt->u.action.u.ext_chan_switch.variable,
-				ies_len, &elems);
+				ies_len, true, &elems);
 
 			if (elems.parse_error)
 				break;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 33fbf10..99b10392 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -181,7 +181,7 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 	if (baselen > skb->len)
 		return;
 
-	ieee802_11_parse_elems(elements, skb->len - baselen, &elems);
+	ieee802_11_parse_elems(elements, skb->len - baselen, false, &elems);
 
 	channel = ieee80211_get_channel(local->hw.wiphy, rx_status->freq);
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6ded61a..23bbfe0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -660,7 +660,7 @@ void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_queue_delayed_work);
 
-u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
+u32 ieee802_11_parse_elems_crc(u8 *start, size_t len, bool action,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc)
 {
@@ -668,6 +668,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 	u8 *pos = start;
 	bool calc_crc = filter != 0;
 	DECLARE_BITMAP(seen_elems, 256);
+	const u8 *ie;
 
 	bitmap_zero(seen_elems, 256);
 	memset(elems, 0, sizeof(*elems));
@@ -716,6 +717,11 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 		case WLAN_EID_PWR_CONSTRAINT:
 		case WLAN_EID_TIMEOUT_INTERVAL:
 		case WLAN_EID_SECONDARY_CHANNEL_OFFSET:
+		case WLAN_EID_WIDE_BW_CHANNEL_SWITCH:
+		/*
+		 * not listing WLAN_EID_CHANNEL_SWITCH_WRAPPER -- it seems possible
+		 * that if the content gets bigger it might be needed more than once
+		 */
 			if (test_bit(id, seen_elems)) {
 				elems->parse_error = true;
 				left -= elen;
@@ -877,6 +883,34 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			}
 			elems->sec_chan_offs = (void *)pos;
 			break;
+		case WLAN_EID_WIDE_BW_CHANNEL_SWITCH:
+			if (!action ||
+			    elen != sizeof(*elems->wide_bw_chansw_ie)) {
+				elem_parse_failed = true;
+				break;
+			}
+			elems->wide_bw_chansw_ie = (void *)pos;
+			break;
+		case WLAN_EID_CHANNEL_SWITCH_WRAPPER:
+			if (action) {
+				elem_parse_failed = true;
+				break;
+			}
+			/*
+			 * This is a bit tricky, but as we only care about
+			 * the wide bandwidth channel switch element, so
+			 * just parse it out manually.
+			 */
+			ie = cfg80211_find_ie(WLAN_EID_WIDE_BW_CHANNEL_SWITCH,
+					      pos, elen);
+			if (ie) {
+				if (ie[1] == sizeof(*elems->wide_bw_chansw_ie))
+					elems->wide_bw_chansw_ie =
+						(void *)(ie + 2);
+				else
+					elem_parse_failed = true;
+			}
+			break;
 		case WLAN_EID_COUNTRY:
 			elems->country_elem = pos;
 			elems->country_elem_len = elen;
-- 
1.8.0

