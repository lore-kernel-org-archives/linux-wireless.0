Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYCDQzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 11:55:18 -0500
Subject: [PATCH] mac80211: fix hardware scan completion
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bill Moss <bmoss@CLEMSON.EDU>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 17:54:35 +0100
Message-Id: <1204649676.25502.12.camel@johannes.berg> (sfid-20080304_165549_783589_88DE95F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211 MLME requires restarting timers after a scan
completes but this wasn't done when hardware scan offload
was added, so add it now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Bill Moss <bmoss@clemson.edu>
---
 net/mac80211/ieee80211_sta.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2008-03-01 19:28:56.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-03-01 19:28:57.000000000 +0100
@@ -3610,25 +3610,28 @@ void ieee80211_scan_completed(struct iee
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-
 		/* No need to wake the master device. */
 		if (sdata->dev == local->mdev)
 			continue;
 
-		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
-			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
-				ieee80211_send_nullfunc(local, sdata, 0);
-			ieee80211_sta_timer((unsigned long)sdata);
-		}
-
-		if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
-			ieee80211_sta_timer((unsigned long)sdata);
+		/* Tell AP we're back */
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
+		    sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
+			ieee80211_send_nullfunc(local, sdata, 0);
 
 		netif_wake_queue(sdata->dev);
 	}
+
+ done:
+	/* Restart STA timer for both SW and HW scan cases */
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+		    ieee80211_vif_is_mesh(&sdata->vif))
+			ieee80211_sta_timer((unsigned long)sdata);
+	}
+
 	rcu_read_unlock();
 
-done:
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		struct ieee80211_if_sta *ifsta = &sdata->u.sta;


