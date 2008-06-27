Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31617 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYF0Pyx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 11:54:53 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>
Subject: [PATCH 1/1] mac80211: removing duplicated parsing of information elements
Date: Fri, 27 Jun 2008 18:54:48 +0300
Message-Id: <1214582088-1138-1-git-send-email-tomas.winkler@intel.com> (sfid-20080627_175459_183221_181AF6DE)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ester Kummer <ester.kummer@intel.com>

This patch removes the duplicated parsing of information elements
in ieee80211_rx_bss_info and in ieee_rx_mgmt_beacon

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Signed-off-by: Ester Kummer <ester.kummer@intel.com>
---
 net/mac80211/mlme.c |  188 ++++++++++++++++++++++++++-------------------------
 1 files changed, 97 insertions(+), 91 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 55659a7..0f8fed3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2537,11 +2537,10 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
 				  struct ieee80211_rx_status *rx_status,
+				  struct ieee802_11_elems *elems,
 				  int beacon)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee802_11_elems elems;
-	size_t baselen;
 	int freq, clen;
 	struct ieee80211_sta_bss *bss;
 	struct sta_info *sta;
@@ -2560,29 +2559,24 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	       print_mac(mac, mgmt->sa), print_mac(mac2, mgmt->da));
 #endif
 
-	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
-	if (baselen > len)
-		return;
-
 	beacon_timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
-	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
-	if (ieee80211_vif_is_mesh(&sdata->vif) && elems.mesh_id &&
-	    elems.mesh_config && mesh_matches_local(&elems, dev)) {
-		u64 rates = ieee80211_sta_get_rates(local, &elems,
+	if (ieee80211_vif_is_mesh(&sdata->vif) && elems->mesh_id &&
+	    elems->mesh_config && mesh_matches_local(elems, dev)) {
+		u64 rates = ieee80211_sta_get_rates(local, elems,
 						rx_status->band);
 
 		mesh_neighbour_update(mgmt->sa, rates, dev,
-				      mesh_peer_accepts_plinks(&elems, dev));
+				      mesh_peer_accepts_plinks(elems, dev));
 	}
 
 	rcu_read_lock();
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
+	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems->supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
 	    (sta = sta_info_get(local, mgmt->sa))) {
 		u64 prev_rates;
-		u64 supp_rates = ieee80211_sta_get_rates(local, &elems,
+		u64 supp_rates = ieee80211_sta_get_rates(local, elems,
 							rx_status->band);
 
 		prev_rates = sta->supp_rates[rx_status->band];
@@ -2607,8 +2601,8 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 
 	rcu_read_unlock();
 
-	if (elems.ds_params && elems.ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems.ds_params[0]);
+	if (elems->ds_params && elems->ds_params_len == 1)
+		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
 	else
 		freq = rx_status->freq;
 
@@ -2618,23 +2612,23 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 		return;
 
 #ifdef CONFIG_MAC80211_MESH
-	if (elems.mesh_config)
-		bss = ieee80211_rx_mesh_bss_get(dev, elems.mesh_id,
-				elems.mesh_id_len, elems.mesh_config, freq);
+	if (elems->mesh_config)
+		bss = ieee80211_rx_mesh_bss_get(dev, elems->mesh_id,
+				elems->mesh_id_len, elems->mesh_config, freq);
 	else
 #endif
 		bss = ieee80211_rx_bss_get(dev, mgmt->bssid, freq,
-					   elems.ssid, elems.ssid_len);
+					   elems->ssid, elems->ssid_len);
 	if (!bss) {
 #ifdef CONFIG_MAC80211_MESH
-		if (elems.mesh_config)
-			bss = ieee80211_rx_mesh_bss_add(dev, elems.mesh_id,
-				elems.mesh_id_len, elems.mesh_config,
-				elems.mesh_config_len, freq);
+		if (elems->mesh_config)
+			bss = ieee80211_rx_mesh_bss_add(dev, elems->mesh_id,
+				elems->mesh_id_len, elems->mesh_config,
+				elems->mesh_config_len, freq);
 		else
 #endif
 			bss = ieee80211_rx_bss_add(dev, mgmt->bssid, freq,
-						   elems.ssid, elems.ssid_len);
+						  elems->ssid, elems->ssid_len);
 		if (!bss)
 			return;
 	} else {
@@ -2647,43 +2641,43 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	}
 
 	/* save the ERP value so that it is available at association time */
-	if (elems.erp_info && elems.erp_info_len >= 1) {
-		bss->erp_value = elems.erp_info[0];
+	if (elems->erp_info && elems->erp_info_len >= 1) {
+		bss->erp_value = elems->erp_info[0];
 		bss->has_erp_value = 1;
 	}
 
-	if (elems.ht_cap_elem &&
-	     (!bss->ht_ie || bss->ht_ie_len != elems.ht_cap_elem_len ||
-	     memcmp(bss->ht_ie, elems.ht_cap_elem, elems.ht_cap_elem_len))) {
+	if (elems->ht_cap_elem &&
+	     (!bss->ht_ie || bss->ht_ie_len != elems->ht_cap_elem_len ||
+	     memcmp(bss->ht_ie, elems->ht_cap_elem, elems->ht_cap_elem_len))) {
 		kfree(bss->ht_ie);
-		bss->ht_ie = kmalloc(elems.ht_cap_elem_len + 2, GFP_ATOMIC);
+		bss->ht_ie = kmalloc(elems->ht_cap_elem_len + 2, GFP_ATOMIC);
 		if (bss->ht_ie) {
-			memcpy(bss->ht_ie, elems.ht_cap_elem - 2,
-				elems.ht_cap_elem_len + 2);
-			bss->ht_ie_len = elems.ht_cap_elem_len + 2;
+			memcpy(bss->ht_ie, elems->ht_cap_elem - 2,
+				elems->ht_cap_elem_len + 2);
+			bss->ht_ie_len = elems->ht_cap_elem_len + 2;
 		} else
 			bss->ht_ie_len = 0;
-	} else if (!elems.ht_cap_elem && bss->ht_ie) {
+	} else if (!elems->ht_cap_elem && bss->ht_ie) {
 		kfree(bss->ht_ie);
 		bss->ht_ie = NULL;
 		bss->ht_ie_len = 0;
 	}
 
-	if (elems.ht_info_elem &&
+	if (elems->ht_info_elem &&
 	     (!bss->ht_add_ie ||
-	     bss->ht_add_ie_len != elems.ht_info_elem_len ||
-	     memcmp(bss->ht_add_ie, elems.ht_info_elem,
-			elems.ht_info_elem_len))) {
+	     bss->ht_add_ie_len != elems->ht_info_elem_len ||
+	     memcmp(bss->ht_add_ie, elems->ht_info_elem,
+			elems->ht_info_elem_len))) {
 		kfree(bss->ht_add_ie);
 		bss->ht_add_ie =
-			kmalloc(elems.ht_info_elem_len + 2, GFP_ATOMIC);
+			kmalloc(elems->ht_info_elem_len + 2, GFP_ATOMIC);
 		if (bss->ht_add_ie) {
-			memcpy(bss->ht_add_ie, elems.ht_info_elem - 2,
-				elems.ht_info_elem_len + 2);
-			bss->ht_add_ie_len = elems.ht_info_elem_len + 2;
+			memcpy(bss->ht_add_ie, elems->ht_info_elem - 2,
+				elems->ht_info_elem_len + 2);
+			bss->ht_add_ie_len = elems->ht_info_elem_len + 2;
 		} else
 			bss->ht_add_ie_len = 0;
-	} else if (!elems.ht_info_elem && bss->ht_add_ie) {
+	} else if (!elems->ht_info_elem && bss->ht_add_ie) {
 		kfree(bss->ht_add_ie);
 		bss->ht_add_ie = NULL;
 		bss->ht_add_ie_len = 0;
@@ -2693,20 +2687,20 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	bss->capability = le16_to_cpu(mgmt->u.beacon.capab_info);
 
 	bss->supp_rates_len = 0;
-	if (elems.supp_rates) {
+	if (elems->supp_rates) {
 		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
-		if (clen > elems.supp_rates_len)
-			clen = elems.supp_rates_len;
-		memcpy(&bss->supp_rates[bss->supp_rates_len], elems.supp_rates,
+		if (clen > elems->supp_rates_len)
+			clen = elems->supp_rates_len;
+		memcpy(&bss->supp_rates[bss->supp_rates_len], elems->supp_rates,
 		       clen);
 		bss->supp_rates_len += clen;
 	}
-	if (elems.ext_supp_rates) {
+	if (elems->ext_supp_rates) {
 		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
-		if (clen > elems.ext_supp_rates_len)
-			clen = elems.ext_supp_rates_len;
+		if (clen > elems->ext_supp_rates_len)
+			clen = elems->ext_supp_rates_len;
 		memcpy(&bss->supp_rates[bss->supp_rates_len],
-		       elems.ext_supp_rates, clen);
+		       elems->ext_supp_rates, clen);
 		bss->supp_rates_len += clen;
 	}
 
@@ -2730,33 +2724,33 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 		return;
 	}
 
-	if (elems.wpa &&
-	    (!bss->wpa_ie || bss->wpa_ie_len != elems.wpa_len ||
-	     memcmp(bss->wpa_ie, elems.wpa, elems.wpa_len))) {
+	if (elems->wpa &&
+	    (!bss->wpa_ie || bss->wpa_ie_len != elems->wpa_len ||
+	     memcmp(bss->wpa_ie, elems->wpa, elems->wpa_len))) {
 		kfree(bss->wpa_ie);
-		bss->wpa_ie = kmalloc(elems.wpa_len + 2, GFP_ATOMIC);
+		bss->wpa_ie = kmalloc(elems->wpa_len + 2, GFP_ATOMIC);
 		if (bss->wpa_ie) {
-			memcpy(bss->wpa_ie, elems.wpa - 2, elems.wpa_len + 2);
-			bss->wpa_ie_len = elems.wpa_len + 2;
+			memcpy(bss->wpa_ie, elems->wpa - 2, elems->wpa_len + 2);
+			bss->wpa_ie_len = elems->wpa_len + 2;
 		} else
 			bss->wpa_ie_len = 0;
-	} else if (!elems.wpa && bss->wpa_ie) {
+	} else if (!elems->wpa && bss->wpa_ie) {
 		kfree(bss->wpa_ie);
 		bss->wpa_ie = NULL;
 		bss->wpa_ie_len = 0;
 	}
 
-	if (elems.rsn &&
-	    (!bss->rsn_ie || bss->rsn_ie_len != elems.rsn_len ||
-	     memcmp(bss->rsn_ie, elems.rsn, elems.rsn_len))) {
+	if (elems->rsn &&
+	    (!bss->rsn_ie || bss->rsn_ie_len != elems->rsn_len ||
+	     memcmp(bss->rsn_ie, elems->rsn, elems->rsn_len))) {
 		kfree(bss->rsn_ie);
-		bss->rsn_ie = kmalloc(elems.rsn_len + 2, GFP_ATOMIC);
+		bss->rsn_ie = kmalloc(elems->rsn_len + 2, GFP_ATOMIC);
 		if (bss->rsn_ie) {
-			memcpy(bss->rsn_ie, elems.rsn - 2, elems.rsn_len + 2);
-			bss->rsn_ie_len = elems.rsn_len + 2;
+			memcpy(bss->rsn_ie, elems->rsn - 2, elems->rsn_len + 2);
+			bss->rsn_ie_len = elems->rsn_len + 2;
 		} else
 			bss->rsn_ie_len = 0;
-	} else if (!elems.rsn && bss->rsn_ie) {
+	} else if (!elems->rsn && bss->rsn_ie) {
 		kfree(bss->rsn_ie);
 		bss->rsn_ie = NULL;
 		bss->rsn_ie_len = 0;
@@ -2776,20 +2770,21 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	 * inclusion of the WMM Parameters in beacons, however, is optional.
 	 */
 
-	if (elems.wmm_param &&
-	    (!bss->wmm_ie || bss->wmm_ie_len != elems.wmm_param_len ||
-	     memcmp(bss->wmm_ie, elems.wmm_param, elems.wmm_param_len))) {
+	if (elems->wmm_param &&
+	    (!bss->wmm_ie || bss->wmm_ie_len != elems->wmm_param_len ||
+	     memcmp(bss->wmm_ie, elems->wmm_param, elems->wmm_param_len))) {
 		kfree(bss->wmm_ie);
-		bss->wmm_ie = kmalloc(elems.wmm_param_len + 2, GFP_ATOMIC);
+		bss->wmm_ie = kmalloc(elems->wmm_param_len + 2, GFP_ATOMIC);
 		if (bss->wmm_ie) {
-			memcpy(bss->wmm_ie, elems.wmm_param - 2,
-			       elems.wmm_param_len + 2);
-			bss->wmm_ie_len = elems.wmm_param_len + 2;
+			memcpy(bss->wmm_ie, elems->wmm_param - 2,
+			       elems->wmm_param_len + 2);
+			bss->wmm_ie_len = elems->wmm_param_len + 2;
 		} else
 			bss->wmm_ie_len = 0;
-	} else if (elems.wmm_info &&
-		    (!bss->wmm_ie || bss->wmm_ie_len != elems.wmm_info_len ||
-		     memcmp(bss->wmm_ie, elems.wmm_info, elems.wmm_info_len))) {
+	} else if (elems->wmm_info &&
+		    (!bss->wmm_ie || bss->wmm_ie_len != elems->wmm_info_len ||
+		     memcmp(bss->wmm_ie, elems->wmm_info,
+						elems->wmm_info_len))) {
 		 /* As for certain AP's Fifth bit is not set in WMM IE in
 		  * beacon frames.So while parsing the beacon frame the
 		  * wmm_info structure is used instead of wmm_param.
@@ -2799,14 +2794,14 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 		  * n-band association.
 		  */
 		kfree(bss->wmm_ie);
-		bss->wmm_ie = kmalloc(elems.wmm_info_len + 2, GFP_ATOMIC);
+		bss->wmm_ie = kmalloc(elems->wmm_info_len + 2, GFP_ATOMIC);
 		if (bss->wmm_ie) {
-			memcpy(bss->wmm_ie, elems.wmm_info - 2,
-			       elems.wmm_info_len + 2);
-			bss->wmm_ie_len = elems.wmm_info_len + 2;
+			memcpy(bss->wmm_ie, elems->wmm_info - 2,
+			       elems->wmm_info_len + 2);
+			bss->wmm_ie_len = elems->wmm_info_len + 2;
 		} else
 			bss->wmm_ie_len = 0;
-	} else if (!elems.wmm_param && !elems.wmm_info && bss->wmm_ie) {
+	} else if (!elems->wmm_param && !elems->wmm_info && bss->wmm_ie) {
 		kfree(bss->wmm_ie);
 		bss->wmm_ie = NULL;
 		bss->wmm_ie_len = 0;
@@ -2817,8 +2812,9 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
 	    bss->capability & WLAN_CAPABILITY_IBSS &&
 	    bss->freq == local->oper_channel->center_freq &&
-	    elems.ssid_len == sdata->u.sta.ssid_len &&
-	    memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) == 0) {
+	    elems->ssid_len == sdata->u.sta.ssid_len &&
+	    memcmp(elems->ssid, sdata->u.sta.ssid,
+				sdata->u.sta.ssid_len) == 0) {
 		if (rx_status->flag & RX_FLAG_TSFT) {
 			/* in order for correct IBSS merging we need mactime
 			 *
@@ -2877,7 +2873,17 @@ static void ieee80211_rx_mgmt_probe_resp(struct net_device *dev,
 					 size_t len,
 					 struct ieee80211_rx_status *rx_status)
 {
-	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, 0);
+	size_t baselen;
+	struct ieee802_11_elems elems;
+
+	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
+	if (baselen > len)
+		return;
+
+	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
+				&elems);
+
+	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, &elems, 0);
 }
 
 
@@ -2894,7 +2900,14 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
 	struct ieee80211_conf *conf = &local->hw.conf;
 	u32 changed = 0;
 
-	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, 1);
+	/* Process beacon from the current BSS */
+	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
+	if (baselen > len)
+		return;
+
+	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
+
+	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, &elems, 1);
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
@@ -2905,13 +2918,6 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
 	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
-	/* Process beacon from the current BSS */
-	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
-	if (baselen > len)
-		return;
-
-	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
-
 	ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
 				 elems.wmm_param_len);
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

