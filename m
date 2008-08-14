Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:56670 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYHNSOX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 14:14:23 -0400
Received: from a88-112-98-38.elisa-laajakaista.fi ([88.112.98.38] helo=jm)
	by hostap.isc.org with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <j@w1.fi>)
	id 1KThJt-0005RG-2b
	for linux-wireless@vger.kernel.org; Thu, 14 Aug 2008 11:13:13 -0700
Date: Thu, 14 Aug 2008 21:13:35 +0300
From: Jouni Malinen <j@w1.fi>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: scan result IEs in one block
Message-ID: <20080814181335.GB7998@jm.kir.nu> (sfid-20080814_201427_064790_A4723CFF)
References: <20080814174709.GA7998@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080814174709.GA7998@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 14, 2008 at 08:47:09PM +0300, Jouni Malinen wrote:

> I haven't yet finished the patch to avoid using duplicate buffers for
> the IEs that were previously stored (RSN, WPA, WMM, HT), but that will
> hopefully be quite simple change to remove those from struct
> ieee80211_sta_bss and instead use simple helper functions that allow a
> specific IE to be fetched from the buffer containing all IEs

This was actually simpler for most parts since number of the separate
stored IEs were not really used for anything apart from filling in WEXT
scan results. It looks like the contents of none of the IEs was used at
all.. There were some odd comments (reference to a patent as a way of
referring WMM spec?!) and some comments about broken APs. I don't think
either of those was really needed since the only real use here was to
figure out whether WMM was being used or not and that can be done in a
much simpler way of just storing whether WMM info or WMM param IE was
there..

Here's an updated and closer to finished patch (could add support for
fragmenting IE data since WEXT seems to have an unfortunate limit on the
event message size.. urg). This gets rid of lots of unnecessary and over
complex code in scan result processing and makes it easier to support
new protocols in the future.



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
@@ -775,6 +770,9 @@ struct ieee80211_ra_tid {
 
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
@@ -2357,11 +2381,7 @@ ieee80211_rx_mesh_bss_add(struct net_dev
 
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
@@ -2654,43 +2674,6 @@ static void ieee80211_rx_bss_info(struct
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
 
@@ -2742,88 +2725,17 @@ static void ieee80211_rx_bss_info(struct
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
-
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
+	if (bss->ies == NULL || bss->ies_len < elems->total_len) {
+		kfree(bss->ies);
+		bss->ies = kmalloc(elems->total_len, GFP_ATOMIC);
+	}
+	if (bss->ies) {
+		memcpy(bss->ies, elems->ie_start, elems->total_len);
+		bss->ies_len = elems->total_len;
+	} else
+		bss->ies_len = 0;
 
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
@@ -4209,28 +4121,19 @@ ieee80211_sta_scan_result(struct net_dev
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
+	if (bss && bss->ies) {
+		/*
+		 * TODO: if bss->ies_len > IW_GENERIC_IE_MAX, should divide
+		 * IEs into multiple IWEVGENIE events (at IE boundaries).
+		 * This is unlikely to happen since IW_GENERIC_IE_MAX is 1024,
+		 * but it is possible that an AP would include up to 2250 or so
+		 * octets of IEs in ProbeResp.
+		 */
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = bss->ht_ie_len;
+		iwe.u.data.length = bss->ies_len;
 		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, bss->ht_ie);
+						  &iwe, bss->ies);
 	}
 
 	if (bss && bss->supp_rates_len > 0) {
 
-- 
Jouni Malinen                                            PGP id EFC895FA
