Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39415 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbYJVJlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 05:41:45 -0400
Subject: [PATCH] mac80211: insert AP sta entry after filling it
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 11:41:38 +0200
Message-Id: <1224668498.28639.42.camel@johannes.berg> (sfid-20081022_114216_074779_01E34919)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We never clearly defined the semantics of the sta_notify callback
and it was originally posted for iwlwifi which still doesn't use
it at all. With the recent HT rework ath9k started relying on it,
but I made a mistake there in that I made ath9k assume the HT
information has already been filled in at sta_notify time. This
isn't a hard thing to do, so do it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
John, this fixes a regression from "mac80211: rewrite HT handling".

 net/mac80211/mlme.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-10-22 11:02:03.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-10-22 11:06:46.000000000 +0200
@@ -1195,7 +1195,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	u32 changed = 0;
 	int i, j;
 	DECLARE_MAC_BUF(mac);
-	bool have_higher_than_11mbit = false;
+	bool have_higher_than_11mbit = false, newsta = false;
 
 	/* AssocResp and ReassocResp have identical structure, so process both
 	 * of them in this function. */
@@ -1258,7 +1258,8 @@ static void ieee80211_rx_mgmt_assoc_resp
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
 		struct ieee80211_bss *bss;
-		int err;
+
+		newsta = true;
 
 		sta = sta_info_alloc(sdata, ifsta->bssid, GFP_ATOMIC);
 		if (!sta) {
@@ -1277,13 +1278,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 			ieee80211_rx_bss_put(local, bss);
 		}
 
-		err = sta_info_insert(sta);
-		if (err) {
-			printk(KERN_DEBUG "%s: failed to insert STA entry for"
-			       " the AP (error %d)\n", sdata->dev->name, err);
-			rcu_read_unlock();
-			return;
-		}
 		/* update new sta with its last rx activity */
 		sta->last_rx = jiffies;
 	}
@@ -1353,13 +1347,24 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	rate_control_rate_init(sta);
 
-	if (elems.wmm_param) {
+	if (elems.wmm_param)
 		set_sta_flags(sta, WLAN_STA_WME);
-		rcu_read_unlock();
+
+	if (newsta) {
+		int err = sta_info_insert(sta);
+		if (err) {
+			printk(KERN_DEBUG "%s: failed to insert STA entry for"
+			       " the AP (error %d)\n", sdata->dev->name, err);
+			rcu_read_unlock();
+			return;
+		}
+	}
+
+	rcu_read_unlock();
+
+	if (elems.wmm_param)
 		ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
 					 elems.wmm_param_len);
-	} else
-		rcu_read_unlock();
 
 	/* set AID and assoc capability,
 	 * ieee80211_set_associated() will tell the driver */


