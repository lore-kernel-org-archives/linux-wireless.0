Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761804AbYDPPoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 11:44:13 -0400
Subject: [PATCH] mac80211: rework scanning to account for probe
	response/beacon difference
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bill Moss <bmoss@CLEMSON.EDU>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 17:43:20 +0200
Message-Id: <1208360600.11676.43.camel@johannes.berg> (sfid-20080416_164418_391021_8E714D72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reworks the scanning code (ieee80211_rx_bss_info) to take
more parameters from beacons and keep a BSS info structure alive when
only beacons for it are received. This fixes a problem with iwlwifi
drivers (where we don't understand the root cause of the problem yet)
and another driver for some broken hardware (which cannot send probe
requests unless associated, so can't always actively scan.)

Signed-off-by: Bill Moss <bmoss@clemson.edu>
[jmberg: reformatted comments, make probe_resp a bool]
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    2 -
 net/mac80211/mlme.c        |   85 +++++++++++++++++++++++++++------------------
 2 files changed, 52 insertions(+), 35 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-04-16 16:53:38.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-04-16 17:42:05.000000000 +0200
@@ -2588,22 +2588,29 @@ static void ieee80211_rx_bss_info(struct
 #endif
 	}
 
-	bss->band = rx_status->band;
-
-	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
-	    bss->probe_resp && beacon) {
-		/* STA mode:
-		 * Do not allow beacon to override data from Probe Response. */
-		ieee80211_rx_bss_put(dev, bss);
-		return;
-	}
-
 	/* save the ERP value so that it is available at association time */
 	if (elems.erp_info && elems.erp_info_len >= 1) {
 		bss->erp_value = elems.erp_info[0];
 		bss->has_erp_value = 1;
 	}
 
+	if (elems.ht_cap_elem &&
+	     (!bss->ht_ie || bss->ht_ie_len != elems.ht_cap_elem_len ||
+	     memcmp(bss->ht_ie, elems.ht_cap_elem, elems.ht_cap_elem_len))) {
+		kfree(bss->ht_ie);
+		bss->ht_ie = kmalloc(elems.ht_cap_elem_len + 2, GFP_ATOMIC);
+		if (bss->ht_ie) {
+			memcpy(bss->ht_ie, elems.ht_cap_elem - 2,
+				elems.ht_cap_elem_len + 2);
+			bss->ht_ie_len = elems.ht_cap_elem_len + 2;
+		} else
+			bss->ht_ie_len = 0;
+	} else if (!elems.ht_cap_elem && bss->ht_ie) {
+		kfree(bss->ht_ie);
+		bss->ht_ie = NULL;
+		bss->ht_ie_len = 0;
+	}
+
 	bss->beacon_int = le16_to_cpu(mgmt->u.beacon.beacon_int);
 	bss->capability = le16_to_cpu(mgmt->u.beacon.capab_info);
 
@@ -2625,6 +2632,26 @@ static void ieee80211_rx_bss_info(struct
 		bss->supp_rates_len += clen;
 	}
 
+	bss->band = rx_status->band;
+
+	bss->timestamp = beacon_timestamp;
+	bss->last_update = jiffies;
+	bss->rssi = rx_status->ssi;
+	bss->signal = rx_status->signal;
+	bss->noise = rx_status->noise;
+	if (!beacon && !bss->probe_resp)
+		bss->probe_resp = true;
+
+	/*
+	 * In STA mode, the remaining parameters should not be overridden
+	 * by beacons because they're not necessarily accurate there.
+	 */
+	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+	    bss->probe_resp && beacon) {
+		ieee80211_rx_bss_put(dev, bss);
+		return;
+	}
+
 	if (elems.wpa &&
 	    (!bss->wpa_ie || bss->wpa_ie_len != elems.wpa_len ||
 	     memcmp(bss->wpa_ie, elems.wpa, elems.wpa_len))) {
@@ -2657,6 +2684,20 @@ static void ieee80211_rx_bss_info(struct
 		bss->rsn_ie_len = 0;
 	}
 
+	/*
+	 * Cf.
+	 * http://www.wipo.int/pctdb/en/wo.jsp?wo=2007047181&IA=WO2007047181&DISPLAY=DESC
+	 *
+	 * quoting:
+	 *
+	 * In particular, "Wi-Fi CERTIFIED for WMM - Support for Multimedia
+	 * Applications with Quality of Service in Wi-Fi Networks," Wi- Fi
+	 * Alliance (September 1, 2004) is incorporated by reference herein.
+	 * The inclusion of the WMM Parameters in probe responses and
+	 * association responses is mandatory for WMM enabled networks. The
+	 * inclusion of the WMM Parameters in beacons, however, is optional.
+	 */
+
 	if (elems.wmm_param &&
 	    (!bss->wmm_ie || bss->wmm_ie_len != elems.wmm_param_len ||
 	     memcmp(bss->wmm_ie, elems.wmm_param, elems.wmm_param_len))) {
@@ -2673,30 +2714,6 @@ static void ieee80211_rx_bss_info(struct
 		bss->wmm_ie = NULL;
 		bss->wmm_ie_len = 0;
 	}
-	if (elems.ht_cap_elem &&
-	    (!bss->ht_ie || bss->ht_ie_len != elems.ht_cap_elem_len ||
-	     memcmp(bss->ht_ie, elems.ht_cap_elem, elems.ht_cap_elem_len))) {
-		kfree(bss->ht_ie);
-		bss->ht_ie = kmalloc(elems.ht_cap_elem_len + 2, GFP_ATOMIC);
-		if (bss->ht_ie) {
-			memcpy(bss->ht_ie, elems.ht_cap_elem - 2,
-			       elems.ht_cap_elem_len + 2);
-			bss->ht_ie_len = elems.ht_cap_elem_len + 2;
-		} else
-			bss->ht_ie_len = 0;
-	} else if (!elems.ht_cap_elem && bss->ht_ie) {
-		kfree(bss->ht_ie);
-		bss->ht_ie = NULL;
-		bss->ht_ie_len = 0;
-	}
-
-	bss->timestamp = beacon_timestamp;
-	bss->last_update = jiffies;
-	bss->rssi = rx_status->ssi;
-	bss->signal = rx_status->signal;
-	bss->noise = rx_status->noise;
-	if (!beacon)
-		bss->probe_resp++;
 
 	/* check if we need to merge IBSS */
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
--- everything.orig/net/mac80211/ieee80211_i.h	2008-04-16 17:35:36.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-04-16 17:42:05.000000000 +0200
@@ -102,7 +102,7 @@ struct ieee80211_sta_bss {
 	u64 timestamp;
 	int beacon_int;
 
-	int probe_resp;
+	bool probe_resp;
 	unsigned long last_update;
 
 	/* during assocation, we save an ERP value from a probe response so


