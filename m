Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZG3To2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 15:44:28 -0400
Subject: [PATCH] mac80211: fix powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 21:43:55 +0200
Message-Id: <1248983035.10971.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the recent MLME rework I did broke powersave
because the ps_sdata isn't assigned at the right time,
and the work item wasn't removed from the list before
calling ieee80211_recalc_ps(). To be more specific,
this broke the case where you'd enabled PS before
associating, either automatically or with iwconfig.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Oops.

 net/mac80211/mlme.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-27 22:35:02.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-30 21:23:52.000000000 +0200
@@ -916,12 +916,9 @@ static void ieee80211_set_associated(str
 
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
-	/* will be same as sdata */
-	if (local->ps_sdata) {
-		mutex_lock(&local->iflist_mtx);
-		ieee80211_recalc_ps(local, -1);
-		mutex_unlock(&local->iflist_mtx);
-	}
+	mutex_lock(&local->iflist_mtx);
+	ieee80211_recalc_ps(local, -1);
+	mutex_unlock(&local->iflist_mtx);
 
 	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
@@ -1570,6 +1567,9 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 					       wk->bss->cbss.bssid,
 					       ap_ht_cap_flags);
 
+        /* delete work item -- must be before set_associated for PS */
+	list_del(&wk->list);
+
 	/* set AID and assoc capability,
 	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
@@ -1583,7 +1583,6 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	ieee80211_sta_rx_notify(sdata, (struct ieee80211_hdr *)mgmt);
 	mod_beacon_timer(sdata);
 
-	list_del(&wk->list);
 	kfree(wk);
 	return RX_MGMT_CFG80211_ASSOC;
 }


