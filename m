Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54010 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYCASVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 13:21:35 -0500
Subject: Re: bughost-1583&1499
From: Johannes Berg <johannes@sipsolutions.net>
To: Bill Moss <bmoss@CLEMSON.EDU>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <47C983A6.8060502@clemson.edu>
References: <47C983A6.8060502@clemson.edu>
Content-Type: text/plain
Date: Sat, 01 Mar 2008 19:21:11 +0100
Message-Id: <1204395671.3917.4.camel@johannes.berg> (sfid-20080301_182157_759850_0D77CB2C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bill,

> I sent an early version of this report to Johannes and Reinette a week 
> ago. Johannes said he would look at it after finishing the mesh stuff 
> and he wanted Zhu to look at it too. This report contains some further 
> analysis. This is a pernicious bug for new users of Fedora so I don't 
> want it to fall on the floor.

Thanks for reminding me, I completely forgot to look at it again after
the mesh stuff.

> done:  <----------- Add
>        rcu_read_lock();
>        list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> 
>                /* No need to wake the master device. */
>                if (sdata->dev == local->mdev)
>                        continue;
> 
>                if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
>                        if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
>                                ieee80211_send_nullfunc(local, sdata, 0);
>                        ieee80211_sta_timer((unsigned long)sdata);
>                }
> 
>                netif_wake_queue(sdata->dev);
>        }
>        rcu_read_unlock();
> 
> done:  <---------- Remove

I think this patch is wrong because it will result in sending a nullfunc
frame to the AP which the firmware should already have done in
hardware-scan case.

Can you try the patch below? I think it would be a better fix, the only
drawback is that we do two list iterations... I hope we'll never have
that many virtual interfaces on the list that it matters. But if this
patch works I can also refactor the function completely, just trying to
understand whether the STA timer really is the problem.

johannes

---
 net/mac80211/ieee80211_sta.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2008-03-01 19:16:13.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-03-01 19:18:58.000000000 +0100
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


