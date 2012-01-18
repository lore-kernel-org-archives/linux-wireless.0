Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab2ARNK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 08:10:28 -0500
Subject: [PATCH 3.3] mac80211: fix work removal on deauth request
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jan 2012 14:10:25 +0100
Message-ID: <1326892225.4778.5.camel@jlt3.sipsolutions.net> (sfid-20120118_141045_515551_8736BF94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When deauth is requested while an auth or assoc
work item is in progress, we currently delete it
without regard for any state it might need to
clean up. Fix it by cleaning up for those items.

In the case Pontus found, the problem manifested
itself as such:

authenticate with 00:23:69:aa:dd:7b (try 1)
authenticated
failed to insert Dummy STA entry for the AP (error -17)
deauthenticating from 00:23:69:aa:dd:7b by local choice (reason=2)

It could also happen differently if the driver
uses the tx_sync callback.

We can't just call the ->done() method of the work
items because that will lock up due to the locking
in cfg80211. This fix isn't very clean, but that
seems acceptable since I have patches pending to
remove this code completely.

Cc: stable@vger.kernel.org
Reported-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Tested-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

--- a/net/mac80211/mlme.c	2012-01-18 14:04:33.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-01-18 14:04:34.000000000 +0100
@@ -2750,7 +2750,6 @@ int ieee80211_mgd_deauth(struct ieee8021
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_work *wk;
 	u8 bssid[ETH_ALEN];
 	bool assoc_bss = false;
 
@@ -2763,30 +2762,47 @@ int ieee80211_mgd_deauth(struct ieee8021
 		assoc_bss = true;
 	} else {
 		bool not_auth_yet = false;
+		struct ieee80211_work *tmp, *wk = NULL;
 
 		mutex_unlock(&ifmgd->mtx);
 
 		mutex_lock(&local->mtx);
-		list_for_each_entry(wk, &local->work_list, list) {
-			if (wk->sdata != sdata)
+		list_for_each_entry(tmp, &local->work_list, list) {
+			if (tmp->sdata != sdata)
 				continue;
 
-			if (wk->type != IEEE80211_WORK_DIRECT_PROBE &&
-			    wk->type != IEEE80211_WORK_AUTH &&
-			    wk->type != IEEE80211_WORK_ASSOC &&
-			    wk->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
+			if (tmp->type != IEEE80211_WORK_DIRECT_PROBE &&
+			    tmp->type != IEEE80211_WORK_AUTH &&
+			    tmp->type != IEEE80211_WORK_ASSOC &&
+			    tmp->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
 				continue;
 
-			if (memcmp(req->bss->bssid, wk->filter_ta, ETH_ALEN))
+			if (memcmp(req->bss->bssid, tmp->filter_ta, ETH_ALEN))
 				continue;
 
-			not_auth_yet = wk->type == IEEE80211_WORK_DIRECT_PROBE;
-			list_del_rcu(&wk->list);
-			free_work(wk);
+			not_auth_yet = tmp->type == IEEE80211_WORK_DIRECT_PROBE;
+			list_del_rcu(&tmp->list);
+			synchronize_rcu();
+			wk = tmp;
 			break;
 		}
 		mutex_unlock(&local->mtx);
 
+		if (wk && wk->type == IEEE80211_WORK_ASSOC) {
+			/* clean up dummy sta & TX sync */
+			sta_info_destroy_addr(wk->sdata, wk->filter_ta);
+			if (wk->assoc.synced)
+				drv_finish_tx_sync(local, wk->sdata,
+						   wk->filter_ta,
+						   IEEE80211_TX_SYNC_ASSOC);
+		} else if (wk && wk->type == IEEE80211_WORK_AUTH) {
+			if (wk->probe_auth.synced)
+				drv_finish_tx_sync(local, wk->sdata,
+						   wk->filter_ta,
+						   IEEE80211_TX_SYNC_AUTH);
+		}
+		kfree(wk);
+
 		/*
 		 * If somebody requests authentication and we haven't
 		 * sent out an auth frame yet there's no need to send


