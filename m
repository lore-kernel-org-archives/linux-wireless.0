Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbZHFSpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 14:45:51 -0400
Message-Id: <20090806184234.138958484@sipsolutions.net>
References: <20090806184131.114246687@sipsolutions.net>
Date: Thu, 06 Aug 2009 20:41:32 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
Subject: [PATCH 1/3] mac80211: stay authenticated after disassoc
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After being disassociated by the AP, mac80211 currently
reports this to cfg80211, and then goes to delete the
association. That's fine, but cfg80211 assumes that it's
still authenticated, however, mac80211 throws away all
state.

This fixes mac80211 to keep track of the authentication
in that case so that cfg80211 can request a deauth or
new association properly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   31 ++++++++++++++++++++++---------
 2 files changed, 23 insertions(+), 9 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-08-06 20:34:45.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-08-06 20:34:49.000000000 +0200
@@ -284,6 +284,7 @@ struct ieee80211_if_managed {
 
 	struct mutex mtx;
 	struct ieee80211_bss *associated;
+	struct ieee80211_mgd_work *old_associate_work;
 	struct list_head work_list;
 
 	u8 bssid[ETH_ALEN];
--- wireless-testing.orig/net/mac80211/mlme.c	2009-08-06 20:34:45.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-08-06 20:34:49.000000000 +0200
@@ -880,10 +880,11 @@ static u32 ieee80211_handle_bss_capabili
 }
 
 static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_bss *bss,
+				     struct ieee80211_mgd_work *wk,
 				     u32 bss_info_changed)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_bss *bss = wk->bss;
 
 	bss_info_changed |= BSS_CHANGED_ASSOC;
 	/* set timing information */
@@ -896,6 +897,7 @@ static void ieee80211_set_associated(str
 		bss->cbss.capability, bss->has_erp_value, bss->erp_value);
 
 	sdata->u.mgd.associated = bss;
+	sdata->u.mgd.old_associate_work = wk;
 	memcpy(sdata->u.mgd.bssid, bss->cbss.bssid, ETH_ALEN);
 
 	/* just to be sure */
@@ -1010,7 +1012,8 @@ ieee80211_authenticate(struct ieee80211_
 	return RX_MGMT_NONE;
 }
 
-static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
+				   bool deauth)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
@@ -1028,6 +1031,16 @@ static void ieee80211_set_disassoc(struc
 	ifmgd->associated = NULL;
 	memset(ifmgd->bssid, 0, ETH_ALEN);
 
+	if (deauth) {
+		kfree(ifmgd->old_associate_work);
+		ifmgd->old_associate_work = NULL;
+	} else {
+		struct ieee80211_mgd_work *wk = ifmgd->old_associate_work;
+
+		wk->state = IEEE80211_MGD_STATE_IDLE;
+		list_add(&wk->list, &ifmgd->work_list);
+	}
+
 	/*
 	 * we need to commit the associated = NULL change because the
 	 * scan code uses that to determine whether this iface should
@@ -1345,7 +1358,7 @@ ieee80211_rx_mgmt_deauth(struct ieee8021
 			sdata->dev->name, bssid, reason_code);
 
 	if (!wk) {
-		ieee80211_set_disassoc(sdata);
+		ieee80211_set_disassoc(sdata, true);
 	} else {
 		list_del(&wk->list);
 		kfree(wk);
@@ -1378,7 +1391,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 	printk(KERN_DEBUG "%s: disassociated (Reason: %u)\n",
 			sdata->dev->name, reason_code);
 
-	ieee80211_set_disassoc(sdata);
+	ieee80211_set_disassoc(sdata, false);
 	return RX_MGMT_CFG80211_DISASSOC;
 }
 
@@ -1581,7 +1594,8 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
 	bss_conf->assoc_capability = capab_info;
-	ieee80211_set_associated(sdata, wk->bss, changed);
+	/* this will take ownership of wk */
+	ieee80211_set_associated(sdata, wk, changed);
 
 	/*
 	 * Start timer to probe the connection to the AP now.
@@ -1590,7 +1604,6 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	ieee80211_sta_rx_notify(sdata, (struct ieee80211_hdr *)mgmt);
 	mod_beacon_timer(sdata);
 
-	kfree(wk);
 	return RX_MGMT_CFG80211_ASSOC;
 }
 
@@ -2096,7 +2109,7 @@ static void ieee80211_sta_work(struct wo
 			printk(KERN_DEBUG "No probe response from AP %pM"
 				" after %dms, disconnecting.\n",
 				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
-			ieee80211_set_disassoc(sdata);
+			ieee80211_set_disassoc(sdata, true);
 			mutex_unlock(&ifmgd->mtx);
 			/*
 			 * must be outside lock due to cfg80211,
@@ -2500,7 +2513,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 
 	if (ifmgd->associated && &ifmgd->associated->cbss == req->bss) {
 		bssid = req->bss->bssid;
-		ieee80211_set_disassoc(sdata);
+		ieee80211_set_disassoc(sdata, true);
 	} else list_for_each_entry(wk, &ifmgd->work_list, list) {
 		if (&wk->bss->cbss == req->bss) {
 			bssid = req->bss->bssid;
@@ -2552,7 +2565,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 		return -ENOLINK;
 	}
 
-	ieee80211_set_disassoc(sdata);
+	ieee80211_set_disassoc(sdata, false);
 
 	mutex_unlock(&ifmgd->mtx);
 

-- 

