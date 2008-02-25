Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYBYPb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:31:58 -0500
Message-Id: <20080225153004.876977000@sipsolutions.net> (sfid-20080225_153207_333055_05680667)
References: <20080225152740.360393000@sipsolutions.net>
Date: Mon, 25 Feb 2008 16:27:42 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 02/10] mac80211: safely free beacon in ieee80211_if_reinit
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

--- everything.orig/net/mac80211/ieee80211_iface.c	2008-02-23 14:59:28.000000000 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2008-02-24 10:07:16.000000000 +0100
@@ -209,6 +209,7 @@ void ieee80211_if_reinit(struct net_devi
 		/* Remove all virtual interfaces that use this BSS
 		 * as their sdata->bss */
 		struct ieee80211_sub_if_data *tsdata, *n;
+		struct beacon_data *beacon;
 
 		list_for_each_entry_safe(tsdata, n, &local->interfaces, list) {
 			if (tsdata != sdata && tsdata->bss == &sdata->u.ap) {
@@ -226,7 +227,10 @@ void ieee80211_if_reinit(struct net_devi
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

