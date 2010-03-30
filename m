Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:41624 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755663Ab0C3G3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 02:29:41 -0400
Date: Mon, 29 Mar 2010 23:29:31 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Send deauth/disassoc prior to dropping STA entry
Message-ID: <20100330062931.GB4953@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When management frame protection (IEEE 802.11w) is used, the
deauthentication and disassociation frames must be protected whenever
the encryption keys are configured. We were removing the STA entry and
with it, the keys, just before actually sending out these frames which
meant that the frames went out unprotected. The AP will drop them in
such a case. Fix this by reordering the operations a bit so that
sta_info_destroy_addr() gets called only after
ieee80211_send_deauth_disassoc().

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/mlme.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2010-03-29 23:23:12.000000000 -0700
+++ wireless-testing/net/mac80211/mlme.c	2010-03-29 23:24:14.000000000 -0700
@@ -778,7 +778,8 @@ static void ieee80211_set_associated(str
 	netif_carrier_on(sdata->dev);
 }
 
-static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
+				   bool remove_sta)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
@@ -851,7 +852,8 @@ static void ieee80211_set_disassoc(struc
 	changed |= BSS_CHANGED_BSSID;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
-	sta_info_destroy_addr(sdata, bssid);
+	if (remove_sta)
+		sta_info_destroy_addr(sdata, bssid);
 }
 
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
@@ -964,7 +966,7 @@ static void __ieee80211_connection_loss(
 
 	printk(KERN_DEBUG "Connection to AP %pM lost.\n", bssid);
 
-	ieee80211_set_disassoc(sdata);
+	ieee80211_set_disassoc(sdata, true);
 	ieee80211_recalc_idle(local);
 	mutex_unlock(&ifmgd->mtx);
 	/*
@@ -1030,7 +1032,7 @@ ieee80211_rx_mgmt_deauth(struct ieee8021
 	printk(KERN_DEBUG "%s: deauthenticated from %pM (Reason: %u)\n",
 			sdata->name, bssid, reason_code);
 
-	ieee80211_set_disassoc(sdata);
+	ieee80211_set_disassoc(sdata, true);
 	ieee80211_recalc_idle(sdata->local);
 
 	return RX_MGMT_CFG80211_DEAUTH;
@@ -1060,7 +1062,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 	printk(KERN_DEBUG "%s: disassociated from %pM (Reason: %u)\n",
 			sdata->name, mgmt->sa, reason_code);
 
-	ieee80211_set_disassoc(sdata);
+	ieee80211_set_disassoc(sdata, true);
 	ieee80211_recalc_idle(sdata->local);
 	return RX_MGMT_CFG80211_DISASSOC;
 }
@@ -1708,7 +1710,7 @@ static void ieee80211_sta_work(struct wo
 			printk(KERN_DEBUG "No probe response from AP %pM"
 				" after %dms, disconnecting.\n",
 				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
-			ieee80211_set_disassoc(sdata);
+			ieee80211_set_disassoc(sdata, true);
 			ieee80211_recalc_idle(local);
 			mutex_unlock(&ifmgd->mtx);
 			/*
@@ -2010,7 +2012,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 		}
 
 		/* Trying to reassociate - clear previous association state */
-		ieee80211_set_disassoc(sdata);
+		ieee80211_set_disassoc(sdata, true);
 	}
 	mutex_unlock(&ifmgd->mtx);
 
@@ -2114,7 +2116,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 
 	if (ifmgd->associated == req->bss) {
 		bssid = req->bss->bssid;
-		ieee80211_set_disassoc(sdata);
+		ieee80211_set_disassoc(sdata, true);
 		mutex_unlock(&ifmgd->mtx);
 	} else {
 		bool not_auth_yet = false;
@@ -2171,6 +2173,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 			   void *cookie)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	u8 bssid[ETH_ALEN];
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -2188,13 +2191,15 @@ int ieee80211_mgd_disassoc(struct ieee80
 	printk(KERN_DEBUG "%s: disassociating from %pM by local choice (reason=%d)\n",
 	       sdata->name, req->bss->bssid, req->reason_code);
 
-	ieee80211_set_disassoc(sdata);
+	memcpy(bssid, req->bss->bssid, ETH_ALEN);
+	ieee80211_set_disassoc(sdata, false);
 
 	mutex_unlock(&ifmgd->mtx);
 
 	ieee80211_send_deauth_disassoc(sdata, req->bss->bssid,
 			IEEE80211_STYPE_DISASSOC, req->reason_code,
 			cookie);
+	sta_info_destroy_addr(sdata, bssid);
 
 	ieee80211_recalc_idle(sdata->local);
 

-- 
Jouni Malinen                                            PGP id EFC895FA
