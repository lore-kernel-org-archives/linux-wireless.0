Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:45563 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282AbYHOTWc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 15:22:32 -0400
Date: Fri, 15 Aug 2008 22:21:27 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Handle scan result IEs in one block
Message-ID: <20080815192127.GG7998@jm.kir.nu> (sfid-20080815_212236_855176_5003DBCC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up and extend scan result processing by storing all the IEs from
Beacon/Probe Response frames in a single block instead of allocating
memory for each specific IE separately. This removes lot of unnecessary
code and automatically supports reporting of new IEs (e.g., IEEE
802.11r) into user space without need to manually extend mac80211
scanning code whenever a new protocol adds IE(s).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-testing.orig/net/mac80211/ieee80211_i.h
+++ wireless-testing/net/mac80211/ieee80211_i.h
@@ -87,16 +87,11 @@ struct ieee80211_sta_bss {
 	enum ieee80211_band band;
 	int freq;
 	int signal, noise, qual;
-	u8 *wpa_ie;
-	size_t wpa_ie_len;
-	u8 *rsn_ie;
-	size_t rsn_ie_len;
-	u8 *wmm_ie;
-	size_t wmm_ie_len;
-	u8 *ht_ie;
-	size_t ht_ie_len;
-	u8 *ht_add_ie;
-	size_t ht_add_ie_len;
+	u8 *ies; /* all information elements from the last Beacon or Probe
+		  * Response frames; note Beacon frame is not allowed to
+		  * override values from Probe Response */
+	size_t ies_len;
+	bool wmm_used;
 #ifdef CONFIG_MAC80211_MESH
 	u8 *mesh_id;
 	size_t mesh_id_len;
@@ -766,6 +761,9 @@ struct ieee80211_ra_tid {
 
 /* Parsed Information Elements */
 struct ieee802_11_elems {
+	u8 *ie_start;
+	size_t total_len;
+
 	/* pointers to IEs */
 	u8 *ssid;
 	u8 *supp_rates;
Index: wireless-testing/net/mac80211/mlme.c
===================================================================
--- wireless-testing.orig/net/mac80211/mlme.c
+++ wireless-testing/net/mac80211/mlme.c
@@ -97,6 +97,8 @@ void ieee802_11_parse_elems(u8 *start, s
 	u8 *pos = start;
 
 	memset(elems, 0, sizeof(*elems));
+	elems->ie_start = start;
+	elems->total_len = len;
 
 	while (left >= 2) {
 		u8 id, elen;
@@ -233,6 +235,27 @@ void ieee802_11_parse_elems(u8 *start, s
 }
 
 
+static u8 * ieee80211_bss_get_ie(struct ieee80211_sta_bss *bss, u8 ie)
+{
+	u8 *end, *pos;
+
+	pos = bss->ies;
+	if (pos == NULL)
+		return NULL;
+	end = pos + bss->ies_len;
+
+	while (pos + 1 < end) {
+		if (pos + 2 + pos[1] > end)
+			break;
+		if (pos[0] == ie)
+			return pos;
+		pos += 2 + pos[1];
+	}
+
+	return NULL;
+}
+
+
 static int ecw2cw(int ecw)
 {
 	return (1 << ecw) - 1;
@@ -709,7 +732,7 @@ static void ieee80211_send_assoc(struct 
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	u8 *pos, *ies;
+	u8 *pos, *ies, *ht_add_ie;
 	int i, len, count, rates_len, supp_rates_len;
 	u16 capab;
 	struct ieee80211_sta_bss *bss;
@@ -744,7 +767,7 @@ static void ieee80211_send_assoc(struct 
 	if (bss) {
 		if (bss->capability & WLAN_CAPABILITY_PRIVACY)
 			capab |= WLAN_CAPABILITY_PRIVACY;
-		if (bss->wmm_ie)
+		if (bss->wmm_used)
 			wmm = 1;
 
 		/* get all rates supported by the device and the AP as
@@ -866,9 +889,10 @@ static void ieee80211_send_assoc(struct 
 
 	/* wmm support is a must to HT */
 	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
-	    sband->ht_info.ht_supported && bss->ht_add_ie) {
+	    sband->ht_info.ht_supported &&
+	    (ht_add_ie = ieee80211_bss_get_ie(bss, WLAN_EID_HT_EXTRA_INFO))) {
 		struct ieee80211_ht_addt_info *ht_add_info =
-			(struct ieee80211_ht_addt_info *)bss->ht_add_ie;
+			(struct ieee80211_ht_addt_info *)ht_add_ie;
 		u16 cap = sband->ht_info.cap;
 		__le16 tmp;
 		u32 flags = local->hw.conf.channel->flags;
@@ -2354,11 +2378,7 @@ ieee80211_rx_mesh_bss_add(struct net_dev
 
 static void ieee80211_rx_bss_free(struct ieee80211_sta_bss *bss)
 {
-	kfree(bss->wpa_ie);
-	kfree(bss->rsn_ie);
-	kfree(bss->wmm_ie);
-	kfree(bss->ht_ie);
-	kfree(bss->ht_add_ie);
+	kfree(bss->ies);
 	kfree(bss_mesh_id(bss));
 	kfree(bss_mesh_cfg(bss));
 	kfree(bss);
@@ -2651,43 +2671,6 @@ static void ieee80211_rx_bss_info(struct
 		bss->has_erp_value = 1;
 	}
 
-	if (elems->ht_cap_elem &&
-	     (!bss->ht_ie || bss->ht_ie_len != elems->ht_cap_elem_len ||
-	     memcmp(bss->ht_ie, elems->ht_cap_elem, elems->ht_cap_elem_len))) {
-		kfree(bss->ht_ie);
-		bss->ht_ie = kmalloc(elems->ht_cap_elem_len + 2, GFP_ATOMIC);
-		if (bss->ht_ie) {
-			memcpy(bss->ht_ie, elems->ht_cap_elem - 2,
-				elems->ht_cap_elem_len + 2);
-			bss->ht_ie_len = elems->ht_cap_elem_len + 2;
-		} else
-			bss->ht_ie_len = 0;
-	} else if (!elems->ht_cap_elem && bss->ht_ie) {
-		kfree(bss->ht_ie);
-		bss->ht_ie = NULL;
-		bss->ht_ie_len = 0;
-	}
-
-	if (elems->ht_info_elem &&
-	     (!bss->ht_add_ie ||
-	     bss->ht_add_ie_len != elems->ht_info_elem_len ||
-	     memcmp(bss->ht_add_ie, elems->ht_info_elem,
-			elems->ht_info_elem_len))) {
-		kfree(bss->ht_add_ie);
-		bss->ht_add_ie =
-			kmalloc(elems->ht_info_elem_len + 2, GFP_ATOMIC);
-		if (bss->ht_add_ie) {
-			memcpy(bss->ht_add_ie, elems->ht_info_elem - 2,
-				elems->ht_info_elem_len + 2);
-			bss->ht_add_ie_len = elems->ht_info_elem_len + 2;
-		} else
-			bss->ht_add_ie_len = 0;
-	} else if (!elems->ht_info_elem && bss->ht_add_ie) {
-		kfree(bss->ht_add_ie);
-		bss->ht_add_ie = NULL;
-		bss->ht_add_ie_len = 0;
-	}
-
 	bss->beacon_int = le16_to_cpu(mgmt->u.beacon.beacon_int);
 	bss->capability = le16_to_cpu(mgmt->u.beacon.capab_info);
 
@@ -2739,88 +2722,17 @@ static void ieee80211_rx_bss_info(struct
 		return;
 	}
 
-	if (elems->wpa &&
-	    (!bss->wpa_ie || bss->wpa_ie_len != elems->wpa_len ||
-	     memcmp(bss->wpa_ie, elems->wpa, elems->wpa_len))) {
-		kfree(bss->wpa_ie);
-		bss->wpa_ie = kmalloc(elems->wpa_len + 2, GFP_ATOMIC);
-		if (bss->wpa_ie) {
-			memcpy(bss->wpa_ie, elems->wpa - 2, elems->wpa_len + 2);
-			bss->wpa_ie_len = elems->wpa_len + 2;
-		} else
-			bss->wpa_ie_len = 0;
-	} else if (!elems->wpa && bss->wpa_ie) {
-		kfree(bss->wpa_ie);
-		bss->wpa_ie = NULL;
-		bss->wpa_ie_len = 0;
-	}
-
-	if (elems->rsn &&
-	    (!bss->rsn_ie || bss->rsn_ie_len != elems->rsn_len ||
-	     memcmp(bss->rsn_ie, elems->rsn, elems->rsn_len))) {
-		kfree(bss->rsn_ie);
-		bss->rsn_ie = kmalloc(elems->rsn_len + 2, GFP_ATOMIC);
-		if (bss->rsn_ie) {
-			memcpy(bss->rsn_ie, elems->rsn - 2, elems->rsn_len + 2);
-			bss->rsn_ie_len = elems->rsn_len + 2;
-		} else
-			bss->rsn_ie_len = 0;
-	} else if (!elems->rsn && bss->rsn_ie) {
-		kfree(bss->rsn_ie);
-		bss->rsn_ie = NULL;
-		bss->rsn_ie_len = 0;
-	}
+	if (bss->ies == NULL || bss->ies_len < elems->total_len) {
+		kfree(bss->ies);
+		bss->ies = kmalloc(elems->total_len, GFP_ATOMIC);
+	}
+	if (bss->ies) {
+		memcpy(bss->ies, elems->ie_start, elems->total_len);
+		bss->ies_len = elems->total_len;
+	} else
+		bss->ies_len = 0;
 
-	/*
-	 * Cf.
-	 * http://www.wipo.int/pctdb/en/wo.jsp?wo=2007047181&IA=WO2007047181&DISPLAY=DESC
-	 *
-	 * quoting:
-	 *
-	 * In particular, "Wi-Fi CERTIFIED for WMM - Support for Multimedia
-	 * Applications with Quality of Service in Wi-Fi Networks," Wi- Fi
-	 * Alliance (September 1, 2004) is incorporated by reference herein.
-	 * The inclusion of the WMM Parameters in probe responses and
-	 * association responses is mandatory for WMM enabled networks. The
-	 * inclusion of the WMM Parameters in beacons, however, is optional.
-	 */
-
-	if (elems->wmm_param &&
-	    (!bss->wmm_ie || bss->wmm_ie_len != elems->wmm_param_len ||
-	     memcmp(bss->wmm_ie, elems->wmm_param, elems->wmm_param_len))) {
-		kfree(bss->wmm_ie);
-		bss->wmm_ie = kmalloc(elems->wmm_param_len + 2, GFP_ATOMIC);
-		if (bss->wmm_ie) {
-			memcpy(bss->wmm_ie, elems->wmm_param - 2,
-			       elems->wmm_param_len + 2);
-			bss->wmm_ie_len = elems->wmm_param_len + 2;
-		} else
-			bss->wmm_ie_len = 0;
-	} else if (elems->wmm_info &&
-		    (!bss->wmm_ie || bss->wmm_ie_len != elems->wmm_info_len ||
-		     memcmp(bss->wmm_ie, elems->wmm_info,
-						elems->wmm_info_len))) {
-		 /* As for certain AP's Fifth bit is not set in WMM IE in
-		  * beacon frames.So while parsing the beacon frame the
-		  * wmm_info structure is used instead of wmm_param.
-		  * wmm_info structure was never used to set bss->wmm_ie.
-		  * This code fixes this problem by copying the WME
-		  * information from wmm_info to bss->wmm_ie and enabling
-		  * n-band association.
-		  */
-		kfree(bss->wmm_ie);
-		bss->wmm_ie = kmalloc(elems->wmm_info_len + 2, GFP_ATOMIC);
-		if (bss->wmm_ie) {
-			memcpy(bss->wmm_ie, elems->wmm_info - 2,
-			       elems->wmm_info_len + 2);
-			bss->wmm_ie_len = elems->wmm_info_len + 2;
-		} else
-			bss->wmm_ie_len = 0;
-	} else if (!elems->wmm_param && !elems->wmm_info && bss->wmm_ie) {
-		kfree(bss->wmm_ie);
-		bss->wmm_ie = NULL;
-		bss->wmm_ie_len = 0;
-	}
+	bss->wmm_used = elems->wmm_param || elems->wmm_info;
 
 	/* check if we need to merge IBSS */
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
@@ -4126,6 +4038,48 @@ int ieee80211_sta_req_scan(struct net_de
 	return 0;
 }
 
+
+static void ieee80211_sta_add_scan_ies(struct iw_request_info *info,
+				       struct ieee80211_sta_bss *bss,
+				       char **current_ev, char *end_buf)
+{
+	u8 *pos, *end, *next;
+	struct iw_event iwe;
+
+	if (bss == NULL || bss->ies == NULL)
+		return;
+
+	/*
+	 * If needed, fragment the IEs buffer (at IE boundaries) into short
+	 * enough fragments to fit into IW_GENERIC_IE_MAX octet messages.
+	 */
+	pos = bss->ies;
+	end = pos + bss->ies_len;
+
+	while (end - pos > IW_GENERIC_IE_MAX) {
+		next = pos + 2 + pos[1];
+		while (next + 2 + next[1] - pos < IW_GENERIC_IE_MAX)
+			next = next + 2 + next[1];
+
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVGENIE;
+		iwe.u.data.length = next - pos;
+		*current_ev = iwe_stream_add_point(info, *current_ev,
+						   end_buf, &iwe, pos);
+
+		pos = next;
+	}
+
+	if (end > pos) {
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVGENIE;
+		iwe.u.data.length = end - pos;
+		*current_ev = iwe_stream_add_point(info, *current_ev,
+						   end_buf, &iwe, pos);
+	}
+}
+
+
 static char *
 ieee80211_sta_scan_result(struct net_device *dev,
 			  struct iw_request_info *info,
@@ -4206,29 +4160,7 @@ ieee80211_sta_scan_result(struct net_dev
 	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
 					  &iwe, "");
 
-	if (bss && bss->wpa_ie) {
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = bss->wpa_ie_len;
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, bss->wpa_ie);
-	}
-
-	if (bss && bss->rsn_ie) {
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = bss->rsn_ie_len;
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, bss->rsn_ie);
-	}
-
-	if (bss && bss->ht_ie) {
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = bss->ht_ie_len;
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, bss->ht_ie);
-	}
+	ieee80211_sta_add_scan_ies(info, bss, &current_ev, end_buf);
 
 	if (bss && bss->supp_rates_len > 0) {
 		/* display all supported rates in readable format */


-- 
Jouni Malinen                                            PGP id EFC895FA
