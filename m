Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbYBVOIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 09:08:10 -0500
Message-Id: <20080222111748.540603000@sipsolutions.net> (sfid-20080222_140819_469718_5EBF63FC)
References: <20080222111644.183587000@sipsolutions.net>
Date: Fri, 22 Feb 2008 12:16:46 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 2/8] mac80211: safely free beacon in ieee80211_if_reinit
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If ieee80211_if_reinit() is called from ieee80211_unregister_hw()
then it is possible that the driver will still request a beacon
(it is allowed to until ieee80211_unregister_hw() has returned.)
This means we need to use an RCU-protected write to the beacon
information even in this function.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_iface.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/ieee80211_iface.c	2008-02-21 14:35:24.000000000 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2008-02-21 15:13:17.000000000 +0100
@@ -193,6 +193,7 @@ void ieee80211_if_reinit(struct net_devi
 		/* Remove all virtual interfaces that use this BSS
 		 * as their sdata->bss */
 		struct ieee80211_sub_if_data *tsdata, *n;
+		struct beacon_data *beacon;
 
 		list_for_each_entry_safe(tsdata, n, &local->interfaces, list) {
 			if (tsdata != sdata && tsdata->bss == &sdata->u.ap) {
@@ -210,7 +211,10 @@ void ieee80211_if_reinit(struct net_devi
 			}
 		}
 
-		kfree(sdata->u.ap.beacon);
+		beacon = sdata->u.ap.beacon;
+		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
+		synchronize_rcu();
+		kfree(beacon);
 
 		while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
 			local->total_ps_buffered--;

-- 

