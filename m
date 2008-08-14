Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:58183 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbYHNRr5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 13:47:57 -0400
Received: from a88-112-98-38.elisa-laajakaista.fi ([88.112.98.38] helo=jm)
	by hostap.isc.org with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <j@w1.fi>)
	id 1KTguJ-0005JQ-Ur
	for linux-wireless@vger.kernel.org; Thu, 14 Aug 2008 10:46:46 -0700
Date: Thu, 14 Aug 2008 20:47:09 +0300
From: Jouni Malinen <j@w1.fi>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: scan result IEs in one block
Message-ID: <20080814174709.GA7998@jm.kir.nu> (sfid-20080814_194800_254222_A7ED0594)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change to how IEs from scan results are reported to user space (and
stored internally) has been discussed couple of times earlier. In order
to be able to support new protocols (e.g., IEEE 802.11r) that add new
IEs without requiring changes in mac80211/WEXT event structures, the
full set of all IEs from Beacon/ProbeResp frames should be sent as a
single block into user space. However, no one seems to have had enough
interest to actually do something concrete to get this change in, so
looks like I have to start.. ;-)

The patch below does the initial step by adding a new buffer for all
IEs. I verified that this worked fine with wpa_supplicant when
associating with WPA-PSK.

I haven't yet finished the patch to avoid using duplicate buffers for
the IEs that were previously stored (RSN, WPA, WMM, HT), but that will
hopefully be quite simple change to remove those from struct
ieee80211_sta_bss and instead use simple helper functions that allow a
specific IE to be fetched from the buffer containing all IEs (this
design is already used in wpa_supplicant and I'll just copy the code
from there).

I'll finish the work on this and submit a more complete version for
inclusion after some more testing. Though, any comments on the design
would be welcome at this point.


Index: wireless-testing/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-testing.orig/net/mac80211/ieee80211_i.h
+++ wireless-testing/net/mac80211/ieee80211_i.h
@@ -87,6 +87,10 @@ struct ieee80211_sta_bss {
 	enum ieee80211_band band;
 	int freq;
 	int signal, noise, qual;
+	u8 *ies; /* all information elements from the last Beacon or Probe
+		  * Response frames; note Beacon frame is not allowed to
+		  * override values from Probe Response */
+	size_t ies_len;
 	u8 *wpa_ie;
 	size_t wpa_ie_len;
 	u8 *rsn_ie;
@@ -775,6 +779,9 @@ struct ieee80211_ra_tid {
 
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
@@ -2357,6 +2359,7 @@ ieee80211_rx_mesh_bss_add(struct net_dev
 
 static void ieee80211_rx_bss_free(struct ieee80211_sta_bss *bss)
 {
+	kfree(bss->ies);
 	kfree(bss->wpa_ie);
 	kfree(bss->rsn_ie);
 	kfree(bss->wmm_ie);
@@ -2742,6 +2745,16 @@ static void ieee80211_rx_bss_info(struct
 		return;
 	}
 
+	if (bss->ies == NULL || bss->ies_len < elems->total_len) {
+		kfree(bss->ies);
+		bss->ies = kmalloc(elems->total_len, GFP_ATOMIC);
+	}
+	if (bss->ies) {
+		memcpy(bss->ies, elems->ie_start, elems->total_len);
+		bss->ies_len = elems->total_len;
+	} else
+		bss->ies_len = 0;
+
 	if (elems->wpa &&
 	    (!bss->wpa_ie || bss->wpa_ie_len != elems->wpa_len ||
 	     memcmp(bss->wpa_ie, elems->wpa, elems->wpa_len))) {
@@ -4209,28 +4222,19 @@ ieee80211_sta_scan_result(struct net_dev
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
