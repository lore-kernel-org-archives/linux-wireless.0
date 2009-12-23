Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41953 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbZLWMWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:22:25 -0500
Message-Id: <20091223121615.694781760@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:15:34 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH next 05/18] mac80211: generalise management work a bit
References: <20091223121529.289129599@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As a first step of generalising management work,
this renames a few things and puts more information
directly into the struct so that auth/assoc need
not access the BSS pointer as often -- in fact it
can be removed from auth completely. Also since the
previous patch made sure a new work item is used
for association, we can make the different data a
union.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |   53 ++++++----
 net/mac80211/mlme.c        |  226 +++++++++++++++++++++++++++------------------
 2 files changed, 172 insertions(+), 107 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-12-23 13:11:20.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-12-23 13:11:20.000000000 +0100
@@ -227,31 +227,48 @@ struct mesh_preq_queue {
 	u8 flags;
 };
 
-enum ieee80211_mgd_state {
-	IEEE80211_MGD_STATE_INVALID,
-	IEEE80211_MGD_STATE_PROBE,
-	IEEE80211_MGD_STATE_AUTH,
-	IEEE80211_MGD_STATE_ASSOC,
+enum ieee80211_work_type {
+	IEEE80211_WORK_AUTH_PROBE,
+	IEEE80211_WORK_AUTH,
+	IEEE80211_WORK_ASSOC,
 };
 
-struct ieee80211_mgd_work {
+struct ieee80211_work {
 	struct list_head list;
-	struct ieee80211_bss *bss;
-	int ie_len;
-	u8 prev_bssid[ETH_ALEN];
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	u8 ssid_len;
-	unsigned long timeout;
-	enum ieee80211_mgd_state state;
-	u16 auth_alg, auth_transaction;
 
-	int tries;
+	struct ieee80211_channel *chan;
+	/* XXX: chan type? -- right now not really needed */
+	unsigned long timeout;
+	enum ieee80211_work_type type;
 
-	u8 key[WLAN_KEY_LEN_WEP104];
-	u8 key_len, key_idx;
+	union {
+		struct {
+			int tries;
+			u16 algorithm, transaction;
+			u8 ssid[IEEE80211_MAX_SSID_LEN];
+			u8 ssid_len;
+			u8 bssid[ETH_ALEN];
+			u8 key[WLAN_KEY_LEN_WEP104];
+			u8 key_len, key_idx;
+			bool privacy;
+		} auth;
+		struct {
+			struct ieee80211_bss *bss;
+			const u8 *supp_rates;
+			const u8 *ht_information_ie;
+			int tries;
+			u16 capability;
+			u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
+			u8 ssid[IEEE80211_MAX_SSID_LEN];
+			u8 ssid_len;
+			u8 supp_rates_len;
+			bool wmm_used;
+		} assoc;
+	};
 
+	int ie_len;
 	/* must be last */
-	u8 ie[0]; /* for auth or assoc frame, not probe */
+	u8 ie[0];
 };
 
 /* flags used in struct ieee80211_if_managed.flags */
--- wireless-testing.orig/net/mac80211/mlme.c	2009-12-23 13:11:20.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-12-23 13:11:20.000000000 +0100
@@ -125,15 +125,15 @@ static int ecw2cw(int ecw)
 	return (1 << ecw) - 1;
 }
 
-static int ieee80211_compatible_rates(struct ieee80211_bss *bss,
+static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
 				      struct ieee80211_supported_band *sband,
 				      u32 *rates)
 {
 	int i, j, count;
 	*rates = 0;
 	count = 0;
-	for (i = 0; i < bss->supp_rates_len; i++) {
-		int rate = (bss->supp_rates[i] & 0x7F) * 5;
+	for (i = 0; i < supp_rates_len; i++) {
+		int rate = (supp_rates[i] & 0x7F) * 5;
 
 		for (j = 0; j < sband->n_bitrates; j++)
 			if (sband->bitrates[j].bitrate == rate) {
@@ -232,7 +232,7 @@ static u32 ieee80211_enable_ht(struct ie
 /* frame sending functions */
 
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_mgd_work *wk)
+				 struct ieee80211_work *wk)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
@@ -248,7 +248,7 @@ static void ieee80211_send_assoc(struct 
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
 			    sizeof(*mgmt) + 200 + wk->ie_len +
-			    wk->ssid_len);
+			    wk->assoc.ssid_len);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for assoc "
 		       "frame\n", sdata->name);
@@ -267,35 +267,37 @@ static void ieee80211_send_assoc(struct 
 			capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
 
-	if (wk->bss->cbss.capability & WLAN_CAPABILITY_PRIVACY)
+	if (wk->assoc.capability & WLAN_CAPABILITY_PRIVACY)
 		capab |= WLAN_CAPABILITY_PRIVACY;
-	if (wk->bss->wmm_used)
+	if (wk->assoc.wmm_used)
 		wmm = 1;
 
 	/* get all rates supported by the device and the AP as
 	 * some APs don't like getting a superset of their rates
 	 * in the association request (e.g. D-Link DAP 1353 in
 	 * b-only mode) */
-	rates_len = ieee80211_compatible_rates(wk->bss, sband, &rates);
+	rates_len = ieee80211_compatible_rates(wk->assoc.supp_rates,
+					       wk->assoc.supp_rates_len,
+					       sband, &rates);
 
-	if ((wk->bss->cbss.capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
+	if ((wk->assoc.capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
 	    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
 		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
 
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, wk->bss->cbss.bssid, ETH_ALEN);
+	memcpy(mgmt->da, wk->assoc.bssid, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
-	memcpy(mgmt->bssid, wk->bss->cbss.bssid, ETH_ALEN);
+	memcpy(mgmt->bssid, wk->assoc.bssid, ETH_ALEN);
 
-	if (!is_zero_ether_addr(wk->prev_bssid)) {
+	if (!is_zero_ether_addr(wk->assoc.prev_bssid)) {
 		skb_put(skb, 10);
 		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						  IEEE80211_STYPE_REASSOC_REQ);
 		mgmt->u.reassoc_req.capab_info = cpu_to_le16(capab);
 		mgmt->u.reassoc_req.listen_interval =
 				cpu_to_le16(local->hw.conf.listen_interval);
-		memcpy(mgmt->u.reassoc_req.current_ap, wk->prev_bssid,
+		memcpy(mgmt->u.reassoc_req.current_ap, wk->assoc.prev_bssid,
 		       ETH_ALEN);
 	} else {
 		skb_put(skb, 4);
@@ -307,10 +309,10 @@ static void ieee80211_send_assoc(struct 
 	}
 
 	/* SSID */
-	ies = pos = skb_put(skb, 2 + wk->ssid_len);
+	ies = pos = skb_put(skb, 2 + wk->assoc.ssid_len);
 	*pos++ = WLAN_EID_SSID;
-	*pos++ = wk->ssid_len;
-	memcpy(pos, wk->ssid, wk->ssid_len);
+	*pos++ = wk->assoc.ssid_len;
+	memcpy(pos, wk->assoc.ssid, wk->assoc.ssid_len);
 
 	/* add all rates which were marked to be used above */
 	supp_rates_len = rates_len;
@@ -392,7 +394,7 @@ static void ieee80211_send_assoc(struct 
 	 */
 	if (wmm && (ifmgd->flags & IEEE80211_STA_WMM_ENABLED) &&
 	    sband->ht_cap.ht_supported &&
-	    (ht_ie = ieee80211_bss_get_ie(&wk->bss->cbss, WLAN_EID_HT_INFORMATION)) &&
+	    (ht_ie = wk->assoc.ht_information_ie) &&
 	    ht_ie[1] >= sizeof(struct ieee80211_ht_info) &&
 	    (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))) {
 		struct ieee80211_ht_info *ht_info =
@@ -1011,23 +1013,43 @@ static void ieee80211_set_associated(str
 	netif_carrier_on(sdata->dev);
 }
 
+static void ieee80211_remove_auth_bss(struct ieee80211_local *local,
+				      struct ieee80211_work *wk)
+{
+	struct cfg80211_bss *cbss;
+	u16 capa_val = WLAN_CAPABILITY_ESS;
+
+	if (wk->auth.privacy)
+		capa_val |= WLAN_CAPABILITY_PRIVACY;
+
+	cbss = cfg80211_get_bss(local->hw.wiphy, wk->chan, wk->auth.bssid,
+				wk->auth.ssid, wk->auth.ssid_len,
+				WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_PRIVACY,
+				capa_val);
+	if (!cbss)
+		return;
+
+	cfg80211_unlink_bss(local->hw.wiphy, cbss);
+	cfg80211_put_bss(cbss);
+}
+
 static enum rx_mgmt_action __must_check
 ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata,
-		       struct ieee80211_mgd_work *wk)
+		       struct ieee80211_work *wk)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 
-	wk->tries++;
-	if (wk->tries > IEEE80211_AUTH_MAX_TRIES) {
+	wk->auth.tries++;
+	if (wk->auth.tries > IEEE80211_AUTH_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: direct probe to AP %pM timed out\n",
-		       sdata->name, wk->bss->cbss.bssid);
+		       sdata->name, wk->auth.bssid);
 
 		/*
 		 * Most likely AP is not in the range so remove the
 		 * bss struct for that AP.
 		 */
-		cfg80211_unlink_bss(local->hw.wiphy, &wk->bss->cbss);
+		ieee80211_remove_auth_bss(local, wk);
 
 		/*
 		 * We might have a pending scan which had no chance to run yet
@@ -1039,14 +1061,14 @@ ieee80211_direct_probe(struct ieee80211_
 	}
 
 	printk(KERN_DEBUG "%s: direct probe to AP %pM (try %d)\n",
-			sdata->name, wk->bss->cbss.bssid,
-			wk->tries);
+			sdata->name, wk->auth.bssid, wk->auth.tries);
 
 	/*
 	 * Direct probe is sent to broadcast address as some APs
 	 * will not answer to direct packet in unassociated state.
 	 */
-	ieee80211_send_probe_req(sdata, NULL, wk->ssid, wk->ssid_len, NULL, 0);
+	ieee80211_send_probe_req(sdata, NULL, wk->auth.ssid, wk->auth.ssid_len,
+				 NULL, 0);
 
 	wk->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
 	run_again(ifmgd, wk->timeout);
@@ -1057,22 +1079,21 @@ ieee80211_direct_probe(struct ieee80211_
 
 static enum rx_mgmt_action __must_check
 ieee80211_authenticate(struct ieee80211_sub_if_data *sdata,
-		       struct ieee80211_mgd_work *wk)
+		       struct ieee80211_work *wk)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 
-	wk->tries++;
-	if (wk->tries > IEEE80211_AUTH_MAX_TRIES) {
+	wk->auth.tries++;
+	if (wk->auth.tries > IEEE80211_AUTH_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: authentication with AP %pM"
-		       " timed out\n",
-		       sdata->name, wk->bss->cbss.bssid);
+		       " timed out\n", sdata->name, wk->auth.bssid);
 
 		/*
 		 * Most likely AP is not in the range so remove the
 		 * bss struct for that AP.
 		 */
-		cfg80211_unlink_bss(local->hw.wiphy, &wk->bss->cbss);
+		ieee80211_remove_auth_bss(local, wk);
 
 		/*
 		 * We might have a pending scan which had no chance to run yet
@@ -1084,11 +1105,11 @@ ieee80211_authenticate(struct ieee80211_
 	}
 
 	printk(KERN_DEBUG "%s: authenticate with AP %pM (try %d)\n",
-	       sdata->name, wk->bss->cbss.bssid, wk->tries);
+	       sdata->name, wk->auth.bssid, wk->auth.tries);
 
-	ieee80211_send_auth(sdata, 1, wk->auth_alg, wk->ie, wk->ie_len,
-			    wk->bss->cbss.bssid, NULL, 0, 0);
-	wk->auth_transaction = 2;
+	ieee80211_send_auth(sdata, 1, wk->auth.algorithm, wk->ie, wk->ie_len,
+			    wk->auth.bssid, NULL, 0, 0);
+	wk->auth.transaction = 2;
 
 	wk->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
 	run_again(ifmgd, wk->timeout);
@@ -1184,22 +1205,22 @@ static void ieee80211_set_disassoc(struc
 
 static enum rx_mgmt_action __must_check
 ieee80211_associate(struct ieee80211_sub_if_data *sdata,
-		    struct ieee80211_mgd_work *wk)
+		    struct ieee80211_work *wk)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 
-	wk->tries++;
-	if (wk->tries > IEEE80211_ASSOC_MAX_TRIES) {
+	wk->assoc.tries++;
+	if (wk->assoc.tries > IEEE80211_ASSOC_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: association with AP %pM"
 		       " timed out\n",
-		       sdata->name, wk->bss->cbss.bssid);
+		       sdata->name, wk->assoc.bssid);
 
 		/*
 		 * Most likely AP is not in the range so remove the
 		 * bss struct for that AP.
 		 */
-		cfg80211_unlink_bss(local->hw.wiphy, &wk->bss->cbss);
+		cfg80211_unlink_bss(local->hw.wiphy, &wk->assoc.bss->cbss);
 
 		/*
 		 * We might have a pending scan which had no chance to run yet
@@ -1211,7 +1232,7 @@ ieee80211_associate(struct ieee80211_sub
 	}
 
 	printk(KERN_DEBUG "%s: associate with AP %pM (try %d)\n",
-	       sdata->name, wk->bss->cbss.bssid, wk->tries);
+	       sdata->name, wk->assoc.bssid, wk->assoc.tries);
 	ieee80211_send_assoc(sdata, wk);
 
 	wk->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
@@ -1326,7 +1347,7 @@ void ieee80211_beacon_loss(struct ieee80
 EXPORT_SYMBOL(ieee80211_beacon_loss);
 
 static void ieee80211_auth_completed(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_mgd_work *wk)
+				     struct ieee80211_work *wk)
 {
 	list_del(&wk->list);
 	kfree(wk);
@@ -1335,7 +1356,7 @@ static void ieee80211_auth_completed(str
 
 
 static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_mgd_work *wk,
+				     struct ieee80211_work *wk,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
 {
@@ -1346,38 +1367,38 @@ static void ieee80211_auth_challenge(str
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
 	if (!elems.challenge)
 		return;
-	ieee80211_send_auth(sdata, 3, wk->auth_alg,
+	ieee80211_send_auth(sdata, 3, wk->auth.algorithm,
 			    elems.challenge - 2, elems.challenge_len + 2,
-			    wk->bss->cbss.bssid,
-			    wk->key, wk->key_len, wk->key_idx);
-	wk->auth_transaction = 4;
+			    wk->auth.bssid, wk->auth.key, wk->auth.key_len,
+			    wk->auth.key_idx);
+	wk->auth.transaction = 4;
 }
 
 static enum rx_mgmt_action __must_check
 ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
-		       struct ieee80211_mgd_work *wk,
+		       struct ieee80211_work *wk,
 		       struct ieee80211_mgmt *mgmt, size_t len)
 {
 	u16 auth_alg, auth_transaction, status_code;
 
-	if (wk->state != IEEE80211_MGD_STATE_AUTH)
+	if (wk->type != IEEE80211_WORK_AUTH)
 		return RX_MGMT_NONE;
 
 	if (len < 24 + 6)
 		return RX_MGMT_NONE;
 
-	if (memcmp(wk->bss->cbss.bssid, mgmt->sa, ETH_ALEN) != 0)
+	if (memcmp(wk->auth.bssid, mgmt->sa, ETH_ALEN) != 0)
 		return RX_MGMT_NONE;
 
-	if (memcmp(wk->bss->cbss.bssid, mgmt->bssid, ETH_ALEN) != 0)
+	if (memcmp(wk->auth.bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return RX_MGMT_NONE;
 
 	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
 	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
 	status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
-	if (auth_alg != wk->auth_alg ||
-	    auth_transaction != wk->auth_transaction)
+	if (auth_alg != wk->auth.algorithm ||
+	    auth_transaction != wk->auth.transaction)
 		return RX_MGMT_NONE;
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
@@ -1386,14 +1407,14 @@ ieee80211_rx_mgmt_auth(struct ieee80211_
 		return RX_MGMT_CFG80211_AUTH;
 	}
 
-	switch (wk->auth_alg) {
+	switch (wk->auth.algorithm) {
 	case WLAN_AUTH_OPEN:
 	case WLAN_AUTH_LEAP:
 	case WLAN_AUTH_FT:
 		ieee80211_auth_completed(sdata, wk);
 		return RX_MGMT_CFG80211_AUTH;
 	case WLAN_AUTH_SHARED_KEY:
-		if (wk->auth_transaction == 4) {
+		if (wk->auth.transaction == 4) {
 			ieee80211_auth_completed(sdata, wk);
 			return RX_MGMT_CFG80211_AUTH;
 		} else
@@ -1463,7 +1484,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 
 static enum rx_mgmt_action __must_check
 ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
-			     struct ieee80211_mgd_work *wk,
+			     struct ieee80211_work *wk,
 			     struct ieee80211_mgmt *mgmt, size_t len,
 			     bool reassoc)
 {
@@ -1471,7 +1492,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
-	struct ieee80211_bss *bss = wk->bss;
+	struct ieee80211_bss *bss = wk->assoc.bss;
 	u32 rates, basic_rates;
 	u16 capab_info, status_code, aid;
 	struct ieee802_11_elems elems;
@@ -1701,7 +1722,7 @@ static void ieee80211_rx_bss_info(struct
 
 
 static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_mgd_work *wk,
+					 struct ieee80211_work *wk,
 					 struct ieee80211_mgmt *mgmt, size_t len,
 					 struct ieee80211_rx_status *rx_status)
 {
@@ -1726,11 +1747,11 @@ static void ieee80211_rx_mgmt_probe_resp
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, false);
 
 	/* direct probe may be part of the association flow */
-	if (wk && wk->state == IEEE80211_MGD_STATE_PROBE) {
+	if (wk && wk->type == IEEE80211_WORK_AUTH_PROBE) {
 		printk(KERN_DEBUG "%s: direct probe responded\n",
 		       sdata->name);
-		wk->tries = 0;
-		wk->state = IEEE80211_MGD_STATE_AUTH;
+		wk->auth.tries = 0;
+		wk->type = IEEE80211_WORK_AUTH;
 		WARN_ON(ieee80211_authenticate(sdata, wk) != RX_MGMT_NONE);
 	}
 
@@ -1967,7 +1988,7 @@ static void ieee80211_sta_rx_queued_mgmt
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_mgd_work *wk;
+	struct ieee80211_work *wk;
 	enum rx_mgmt_action rma = RX_MGMT_NONE;
 	u16 fc;
 
@@ -2021,7 +2042,20 @@ static void ieee80211_sta_rx_queued_mgmt
 	}
 
 	list_for_each_entry(wk, &ifmgd->work_list, list) {
-		if (memcmp(wk->bss->cbss.bssid, mgmt->bssid, ETH_ALEN) != 0)
+		const u8 *bssid = NULL;
+
+		switch (wk->type) {
+		case IEEE80211_WORK_AUTH_PROBE:
+		case IEEE80211_WORK_AUTH:
+			bssid = wk->auth.bssid;
+			break;
+		case IEEE80211_WORK_ASSOC:
+			bssid = wk->assoc.bssid;
+			break;
+		default:
+			continue;
+		}
+		if (memcmp(bssid, mgmt->bssid, ETH_ALEN) != 0)
 			continue;
 
 		switch (fc & IEEE80211_FCTL_STYPE) {
@@ -2116,7 +2150,7 @@ static void ieee80211_sta_work(struct wo
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd;
 	struct sk_buff *skb;
-	struct ieee80211_mgd_work *wk, *tmp;
+	struct ieee80211_work *wk, *tmp;
 	LIST_HEAD(free_work);
 	enum rx_mgmt_action rma;
 
@@ -2202,19 +2236,19 @@ static void ieee80211_sta_work(struct wo
 			continue;
 		}
 
-		switch (wk->state) {
+		switch (wk->type) {
 		default:
 			WARN_ON(1);
 			/* nothing */
 			rma = RX_MGMT_NONE;
 			break;
-		case IEEE80211_MGD_STATE_PROBE:
+		case IEEE80211_WORK_AUTH_PROBE:
 			rma = ieee80211_direct_probe(sdata, wk);
 			break;
-		case IEEE80211_MGD_STATE_AUTH:
+		case IEEE80211_WORK_AUTH:
 			rma = ieee80211_authenticate(sdata, wk);
 			break;
-		case IEEE80211_MGD_STATE_ASSOC:
+		case IEEE80211_WORK_ASSOC:
 			rma = ieee80211_associate(sdata, wk);
 			break;
 		}
@@ -2251,12 +2285,11 @@ static void ieee80211_sta_work(struct wo
 		/* see above how we're using wk->timeout */
 		switch (wk->timeout) {
 		case RX_MGMT_CFG80211_AUTH_TO:
-			cfg80211_send_auth_timeout(sdata->dev,
-						   wk->bss->cbss.bssid);
+			cfg80211_send_auth_timeout(sdata->dev, wk->auth.bssid);
 			break;
 		case RX_MGMT_CFG80211_ASSOC_TO:
 			cfg80211_send_assoc_timeout(sdata->dev,
-						    wk->bss->cbss.bssid);
+						    wk->assoc.bssid);
 			break;
 		default:
 			WARN(1, "unexpected: %lu", wk->timeout);
@@ -2423,7 +2456,7 @@ int ieee80211_mgd_auth(struct ieee80211_
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *ssid;
-	struct ieee80211_mgd_work *wk;
+	struct ieee80211_work *wk;
 	u16 auth_alg;
 
 	switch (req->auth_type) {
@@ -2447,7 +2480,7 @@ int ieee80211_mgd_auth(struct ieee80211_
 	if (!wk)
 		return -ENOMEM;
 
-	wk->bss = (void *)req->bss;
+	memcpy(wk->auth.bssid, req->bss->bssid, ETH_ALEN);;
 
 	if (req->ie && req->ie_len) {
 		memcpy(wk->ie, req->ie, req->ie_len);
@@ -2455,22 +2488,27 @@ int ieee80211_mgd_auth(struct ieee80211_
 	}
 
 	if (req->key && req->key_len) {
-		wk->key_len = req->key_len;
-		wk->key_idx = req->key_idx;
-		memcpy(wk->key, req->key, req->key_len);
+		wk->auth.key_len = req->key_len;
+		wk->auth.key_idx = req->key_idx;
+		memcpy(wk->auth.key, req->key, req->key_len);
 	}
 
 	ssid = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
-	memcpy(wk->ssid, ssid + 2, ssid[1]);
-	wk->ssid_len = ssid[1];
+	memcpy(wk->auth.ssid, ssid + 2, ssid[1]);
+	wk->auth.ssid_len = ssid[1];
+
+	wk->auth.algorithm = auth_alg;
+	wk->auth.privacy = req->bss->capability & WLAN_CAPABILITY_PRIVACY;
 
-	wk->state = IEEE80211_MGD_STATE_PROBE;
-	wk->auth_alg = auth_alg;
+	wk->type = IEEE80211_WORK_AUTH_PROBE;
 	wk->timeout = jiffies; /* run right away */
+	wk->chan = req->bss->channel;
 
 	/*
 	 * XXX: if still associated need to tell AP that we're going
 	 *	to sleep and then change channel etc.
+	 *	For now switch channel here, later will be handled
+	 *	by submitting this as an off-channel work item.
 	 */
 	sdata->local->oper_channel = req->bss->channel;
 	ieee80211_hw_config(sdata->local, 0);
@@ -2487,7 +2525,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 			struct cfg80211_assoc_request *req)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_mgd_work *wk;
+	struct ieee80211_work *wk;
 	const u8 *ssid;
 	int i, err;
 
@@ -2514,17 +2552,27 @@ int ieee80211_mgd_assoc(struct ieee80211
 	} else
 		wk->ie_len = 0;
 
-	wk->bss = (void *)req->bss;
+	wk->assoc.bss = (void *)req->bss;
+
+	memcpy(wk->assoc.bssid, req->bss->bssid, ETH_ALEN);
+
+	wk->assoc.capability = req->bss->capability;
+	wk->assoc.wmm_used = wk->assoc.bss->wmm_used;
+	wk->assoc.supp_rates = wk->assoc.bss->supp_rates;
+	wk->assoc.supp_rates_len = wk->assoc.bss->supp_rates_len;
+	wk->assoc.ht_information_ie =
+		ieee80211_bss_get_ie(req->bss, WLAN_EID_HT_INFORMATION);
 
 	ssid = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
-	memcpy(wk->ssid, ssid + 2, ssid[1]);
-	wk->ssid_len = ssid[1];
+	memcpy(wk->assoc.ssid, ssid + 2, ssid[1]);
+	wk->assoc.ssid_len = ssid[1];
 
 	if (req->prev_bssid)
-		memcpy(wk->prev_bssid, req->prev_bssid, ETH_ALEN);
+		memcpy(wk->assoc.prev_bssid, req->prev_bssid, ETH_ALEN);
 
-	wk->state = IEEE80211_MGD_STATE_ASSOC;
+	wk->type = IEEE80211_WORK_ASSOC;
 	wk->timeout = jiffies; /* run right away */
+	wk->chan = req->bss->channel;
 
 	if (req->use_mfp) {
 		ifmgd->mfp = IEEE80211_MFP_REQUIRED;
@@ -2557,7 +2605,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 			 void *cookie)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_mgd_work *wk;
+	struct ieee80211_work *wk;
 	const u8 *bssid = req->bss->bssid;
 	bool not_auth_yet = false;
 
@@ -2567,9 +2615,9 @@ int ieee80211_mgd_deauth(struct ieee8021
 		bssid = req->bss->bssid;
 		ieee80211_set_disassoc(sdata);
 	} else list_for_each_entry(wk, &ifmgd->work_list, list) {
-		if (wk->state != IEEE80211_MGD_STATE_PROBE)
+		if (wk->type != IEEE80211_WORK_AUTH_PROBE)
 			continue;
-		if (req->bss != &wk->bss->cbss)
+		if (memcmp(req->bss->bssid, wk->auth.bssid, ETH_ALEN))
 			continue;
 		not_auth_yet = true;
 		list_del(&wk->list);


