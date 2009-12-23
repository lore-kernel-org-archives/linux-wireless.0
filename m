Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbZLWMWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:22:17 -0500
Message-Id: <20091223121615.471472720@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:15:33 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH next 04/18] mac80211: let cfg80211 manage auth state
References: <20091223121529.289129599@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 currently hangs on to the auth state by
keeping it on the work list. That can lead to
confusing behaviour like rejecting scans while
authenticated to any AP (but not yet associated.)
It also means that it needs to keep track of the
work struct while associated for when it gets
disassociated (or disassociates.)

Change this to free the work struct after the
authentication completed successfully and
allocate a new one for associating, thereby
letting cfg80211 manage the auth state. Another
change necessary for this is to tell cfg80211
about all unicast deauth frames sent to mac80211
since now it can no longer check the auth state,
but that check was racy anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    3 
 net/mac80211/mlme.c        |  173 ++++++++++++++++++---------------------------
 2 files changed, 73 insertions(+), 103 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-12-23 13:11:13.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-12-23 13:11:20.000000000 +0100
@@ -949,11 +949,10 @@ static u32 ieee80211_handle_bss_capabili
 }
 
 static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_mgd_work *wk,
+				     struct ieee80211_bss *bss,
 				     u32 bss_info_changed)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_bss *bss = wk->bss;
 
 	bss_info_changed |= BSS_CHANGED_ASSOC;
 	/* set timing information */
@@ -966,7 +965,6 @@ static void ieee80211_set_associated(str
 		bss->cbss.capability, bss->has_erp_value, bss->erp_value);
 
 	sdata->u.mgd.associated = bss;
-	sdata->u.mgd.old_associate_work = wk;
 	memcpy(sdata->u.mgd.bssid, bss->cbss.bssid, ETH_ALEN);
 
 	/* just to be sure */
@@ -1098,8 +1096,7 @@ ieee80211_authenticate(struct ieee80211_
 	return RX_MGMT_NONE;
 }
 
-static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
-				   bool deauth)
+static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
@@ -1117,16 +1114,6 @@ static void ieee80211_set_disassoc(struc
 	ifmgd->associated = NULL;
 	memset(ifmgd->bssid, 0, ETH_ALEN);
 
-	if (deauth) {
-		kfree(ifmgd->old_associate_work);
-		ifmgd->old_associate_work = NULL;
-	} else {
-		struct ieee80211_mgd_work *wk = ifmgd->old_associate_work;
-
-		wk->state = IEEE80211_MGD_STATE_IDLE;
-		list_add(&wk->list, &ifmgd->work_list);
-	}
-
 	/*
 	 * we need to commit the associated = NULL change because the
 	 * scan code uses that to determine whether this iface should
@@ -1341,7 +1328,8 @@ EXPORT_SYMBOL(ieee80211_beacon_loss);
 static void ieee80211_auth_completed(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgd_work *wk)
 {
-	wk->state = IEEE80211_MGD_STATE_IDLE;
+	list_del(&wk->list);
+	kfree(wk);
 	printk(KERN_DEBUG "%s: authenticated\n", sdata->name);
 }
 
@@ -1419,7 +1407,6 @@ ieee80211_rx_mgmt_auth(struct ieee80211_
 
 static enum rx_mgmt_action __must_check
 ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
-			 struct ieee80211_mgd_work *wk,
 			 struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -1431,23 +1418,15 @@ ieee80211_rx_mgmt_deauth(struct ieee8021
 
 	ASSERT_MGD_MTX(ifmgd);
 
-	if (wk)
-		bssid = wk->bss->cbss.bssid;
-	else
-		bssid = ifmgd->associated->cbss.bssid;
+	bssid = ifmgd->associated->cbss.bssid;
 
 	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
 	printk(KERN_DEBUG "%s: deauthenticated from %pM (Reason: %u)\n",
 			sdata->name, bssid, reason_code);
 
-	if (!wk) {
-		ieee80211_set_disassoc(sdata, true);
-		ieee80211_recalc_idle(sdata->local);
-	} else {
-		list_del(&wk->list);
-		kfree(wk);
-	}
+	ieee80211_set_disassoc(sdata);
+	ieee80211_recalc_idle(sdata->local);
 
 	return RX_MGMT_CFG80211_DEAUTH;
 }
@@ -1476,7 +1455,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 	printk(KERN_DEBUG "%s: disassociated from %pM (Reason: %u)\n",
 			sdata->name, mgmt->sa, reason_code);
 
-	ieee80211_set_disassoc(sdata, false);
+	ieee80211_set_disassoc(sdata);
 	ieee80211_recalc_idle(sdata->local);
 	return RX_MGMT_CFG80211_DISASSOC;
 }
@@ -1492,6 +1471,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
+	struct ieee80211_bss *bss = wk->bss;
 	u32 rates, basic_rates;
 	u16 capab_info, status_code, aid;
 	struct ieee802_11_elems elems;
@@ -1510,7 +1490,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	if (len < 24 + 6)
 		return RX_MGMT_NONE;
 
-	if (memcmp(wk->bss->cbss.bssid, mgmt->sa, ETH_ALEN) != 0)
+	if (memcmp(bss->cbss.bssid, mgmt->sa, ETH_ALEN) != 0)
 		return RX_MGMT_NONE;
 
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
@@ -1540,10 +1520,17 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 		return RX_MGMT_NONE;
 	}
 
+	/*
+	 * Here the association was either successful or not.
+	 */
+
+	/* delete work item -- must be before set_associated for PS */
+	list_del(&wk->list);
+	kfree(wk);
+
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
 		       sdata->name, status_code);
-		wk->state = IEEE80211_MGD_STATE_IDLE;
 		return RX_MGMT_CFG80211_ASSOC;
 	}
 
@@ -1561,7 +1548,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	printk(KERN_DEBUG "%s: associated\n", sdata->name);
 	ifmgd->aid = aid;
 
-	sta = sta_info_alloc(sdata, wk->bss->cbss.bssid, GFP_KERNEL);
+	sta = sta_info_alloc(sdata, bss->cbss.bssid, GFP_KERNEL);
 	if (!sta) {
 		printk(KERN_DEBUG "%s: failed to alloc STA entry for"
 		       " the AP\n", sdata->name);
@@ -1653,18 +1640,14 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	    (ifmgd->flags & IEEE80211_STA_WMM_ENABLED) &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
-					       wk->bss->cbss.bssid,
+					       bss->cbss.bssid,
 					       ap_ht_cap_flags);
 
-        /* delete work item -- must be before set_associated for PS */
-	list_del(&wk->list);
-
 	/* set AID and assoc capability,
 	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
 	bss_conf->assoc_capability = capab_info;
-	/* this will take ownership of wk */
-	ieee80211_set_associated(sdata, wk, changed);
+	ieee80211_set_associated(sdata, bss, changed);
 
 	/*
 	 * Start timer to probe the connection to the AP now.
@@ -2007,8 +1990,7 @@ static void ieee80211_sta_rx_queued_mgmt
 						     skb->len, rx_status);
 			break;
 		case IEEE80211_STYPE_DEAUTH:
-			rma = ieee80211_rx_mgmt_deauth(sdata, NULL,
-						       mgmt, skb->len);
+			rma = ieee80211_rx_mgmt_deauth(sdata, mgmt, skb->len);
 			break;
 		case IEEE80211_STYPE_DISASSOC:
 			rma = ieee80211_rx_mgmt_disassoc(sdata, mgmt, skb->len);
@@ -2059,8 +2041,15 @@ static void ieee80211_sta_rx_queued_mgmt
 							   skb->len, true);
 			break;
 		case IEEE80211_STYPE_DEAUTH:
-			rma = ieee80211_rx_mgmt_deauth(sdata, wk, mgmt,
-						       skb->len);
+			if (skb->len >= 24 + 2 /* mgmt + deauth reason */) {
+				/*
+				 * We get here if we get deauth while
+				 * trying to auth/assoc. Telling cfg80211
+				 * is handled below, unconditionally.
+				 */
+				list_del(&wk->list);
+				kfree(wk);
+			}
 			break;
 		}
 		/*
@@ -2074,6 +2063,12 @@ static void ieee80211_sta_rx_queued_mgmt
 
 	mutex_unlock(&ifmgd->mtx);
 
+	if (skb->len >= 24 + 2 /* mgmt + deauth reason */ &&
+	    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DEAUTH) {
+		WARN_ON(rma != RX_MGMT_NONE);
+		rma = RX_MGMT_CFG80211_DEAUTH;
+	}
+
 	switch (rma) {
 	case RX_MGMT_NONE:
 		/* no action */
@@ -2124,7 +2119,6 @@ static void ieee80211_sta_work(struct wo
 	struct ieee80211_mgd_work *wk, *tmp;
 	LIST_HEAD(free_work);
 	enum rx_mgmt_action rma;
-	bool anybusy = false;
 
 	if (!ieee80211_sdata_running(sdata))
 		return;
@@ -2179,7 +2173,7 @@ static void ieee80211_sta_work(struct wo
 			printk(KERN_DEBUG "No probe response from AP %pM"
 				" after %dms, disconnecting.\n",
 				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
-			ieee80211_set_disassoc(sdata, true);
+			ieee80211_set_disassoc(sdata);
 			ieee80211_recalc_idle(local);
 			mutex_unlock(&ifmgd->mtx);
 			/*
@@ -2211,8 +2205,6 @@ static void ieee80211_sta_work(struct wo
 		switch (wk->state) {
 		default:
 			WARN_ON(1);
-			/* fall through */
-		case IEEE80211_MGD_STATE_IDLE:
 			/* nothing */
 			rma = RX_MGMT_NONE;
 			break;
@@ -2235,20 +2227,19 @@ static void ieee80211_sta_work(struct wo
 		case RX_MGMT_CFG80211_ASSOC_TO:
 			list_del(&wk->list);
 			list_add(&wk->list, &free_work);
-			wk->tries = rma; /* small abuse but only local */
+			/*
+			 * small abuse but only local -- keep the
+			 * action type in wk->timeout while the item
+			 * is on the cleanup list
+			 */
+			wk->timeout = rma;
 			break;
 		default:
 			WARN(1, "unexpected: %d", rma);
 		}
 	}
 
-	list_for_each_entry(wk, &ifmgd->work_list, list) {
-		if (wk->state != IEEE80211_MGD_STATE_IDLE) {
-			anybusy = true;
-			break;
-		}
-	}
-	if (!anybusy &&
+	if (list_empty(&ifmgd->work_list) &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request))
 		ieee80211_queue_delayed_work(&local->hw,
 					     &local->scan_work,
@@ -2257,7 +2248,8 @@ static void ieee80211_sta_work(struct wo
 	mutex_unlock(&ifmgd->mtx);
 
 	list_for_each_entry_safe(wk, tmp, &free_work, list) {
-		switch (wk->tries) {
+		/* see above how we're using wk->timeout */
+		switch (wk->timeout) {
 		case RX_MGMT_CFG80211_AUTH_TO:
 			cfg80211_send_auth_timeout(sdata->dev,
 						   wk->bss->cbss.bssid);
@@ -2267,7 +2259,7 @@ static void ieee80211_sta_work(struct wo
 						    wk->bss->cbss.bssid);
 			break;
 		default:
-			WARN(1, "unexpected: %d", wk->tries);
+			WARN(1, "unexpected: %lu", wk->timeout);
 		}
 
 		list_del(&wk->list);
@@ -2495,35 +2487,18 @@ int ieee80211_mgd_assoc(struct ieee80211
 			struct cfg80211_assoc_request *req)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_mgd_work *wk, *found = NULL;
+	struct ieee80211_mgd_work *wk;
+	const u8 *ssid;
 	int i, err;
 
 	mutex_lock(&ifmgd->mtx);
 
-	list_for_each_entry(wk, &ifmgd->work_list, list) {
-		if (&wk->bss->cbss == req->bss &&
-		    wk->state == IEEE80211_MGD_STATE_IDLE) {
-			found = wk;
-			break;
-		}
-	}
-
-	if (!found) {
-		err = -ENOLINK;
-		goto out;
-	}
-
-	list_del(&found->list);
-
-	wk = krealloc(found, sizeof(*wk) + req->ie_len, GFP_KERNEL);
+	wk = kzalloc(sizeof(*wk) + req->ie_len, GFP_KERNEL);
 	if (!wk) {
-		list_add(&found->list, &ifmgd->work_list);
 		err = -ENOMEM;
 		goto out;
 	}
 
-	list_add(&wk->list, &ifmgd->work_list);
-
 	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
 
 	for (i = 0; i < req->crypto.n_ciphers_pairwise; i++)
@@ -2532,8 +2507,6 @@ int ieee80211_mgd_assoc(struct ieee80211
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104)
 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
-	sdata->local->oper_channel = req->bss->channel;
-	ieee80211_hw_config(sdata->local, 0);
 
 	if (req->ie && req->ie_len) {
 		memcpy(wk->ie, req->ie, req->ie_len);
@@ -2541,11 +2514,16 @@ int ieee80211_mgd_assoc(struct ieee80211
 	} else
 		wk->ie_len = 0;
 
+	wk->bss = (void *)req->bss;
+
+	ssid = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
+	memcpy(wk->ssid, ssid + 2, ssid[1]);
+	wk->ssid_len = ssid[1];
+
 	if (req->prev_bssid)
 		memcpy(wk->prev_bssid, req->prev_bssid, ETH_ALEN);
 
 	wk->state = IEEE80211_MGD_STATE_ASSOC;
-	wk->tries = 0;
 	wk->timeout = jiffies; /* run right away */
 
 	if (req->use_mfp) {
@@ -2561,6 +2539,10 @@ int ieee80211_mgd_assoc(struct ieee80211
 	else
 		ifmgd->flags &= ~IEEE80211_STA_CONTROL_PORT;
 
+	sdata->local->oper_channel = req->bss->channel;
+	ieee80211_hw_config(sdata->local, 0);
+
+	list_add(&wk->list, &ifmgd->work_list);
 	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.work);
 
 	err = 0;
@@ -2576,23 +2558,23 @@ int ieee80211_mgd_deauth(struct ieee8021
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_work *wk;
-	const u8 *bssid = NULL;
+	const u8 *bssid = req->bss->bssid;
 	bool not_auth_yet = false;
 
 	mutex_lock(&ifmgd->mtx);
 
 	if (ifmgd->associated && &ifmgd->associated->cbss == req->bss) {
 		bssid = req->bss->bssid;
-		ieee80211_set_disassoc(sdata, true);
+		ieee80211_set_disassoc(sdata);
 	} else list_for_each_entry(wk, &ifmgd->work_list, list) {
-		if (&wk->bss->cbss == req->bss) {
-			bssid = req->bss->bssid;
-			if (wk->state == IEEE80211_MGD_STATE_PROBE)
-				not_auth_yet = true;
-			list_del(&wk->list);
-			kfree(wk);
-			break;
-		}
+		if (wk->state != IEEE80211_MGD_STATE_PROBE)
+			continue;
+		if (req->bss != &wk->bss->cbss)
+			continue;
+		not_auth_yet = true;
+		list_del(&wk->list);
+		kfree(wk);
+		break;
 	}
 
 	/*
@@ -2609,17 +2591,6 @@ int ieee80211_mgd_deauth(struct ieee8021
 		return 0;
 	}
 
-	/*
-	 * cfg80211 should catch this ... but it's racy since
-	 * we can receive a deauth frame, process it, hand it
-	 * to cfg80211 while that's in a locked section already
-	 * trying to tell us that the user wants to disconnect.
-	 */
-	if (!bssid) {
-		mutex_unlock(&ifmgd->mtx);
-		return -ENOLINK;
-	}
-
 	mutex_unlock(&ifmgd->mtx);
 
 	printk(KERN_DEBUG "%s: deauthenticating from %pM by local choice (reason=%d)\n",
@@ -2656,7 +2627,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 	printk(KERN_DEBUG "%s: disassociating from %pM by local choice (reason=%d)\n",
 	       sdata->name, req->bss->bssid, req->reason_code);
 
-	ieee80211_set_disassoc(sdata, false);
+	ieee80211_set_disassoc(sdata);
 
 	mutex_unlock(&ifmgd->mtx);
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-12-23 13:11:13.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-12-23 13:11:20.000000000 +0100
@@ -228,7 +228,7 @@ struct mesh_preq_queue {
 };
 
 enum ieee80211_mgd_state {
-	IEEE80211_MGD_STATE_IDLE,
+	IEEE80211_MGD_STATE_INVALID,
 	IEEE80211_MGD_STATE_PROBE,
 	IEEE80211_MGD_STATE_AUTH,
 	IEEE80211_MGD_STATE_ASSOC,
@@ -285,7 +285,6 @@ struct ieee80211_if_managed {
 
 	struct mutex mtx;
 	struct ieee80211_bss *associated;
-	struct ieee80211_mgd_work *old_associate_work;
 	struct list_head work_list;
 
 	u8 bssid[ETH_ALEN];


