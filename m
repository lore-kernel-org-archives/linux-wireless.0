Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab0E1S5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 14:57:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OI4kQ-00047S-IN
	for linux-wireless@vger.kernel.org; Fri, 28 May 2010 20:57:34 +0200
Message-Id: <20100528185504.694480801@sipsolutions.net>
Date: Fri, 28 May 2010 20:53:03 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/7] mac80211: simplify station/aggregation code
References: <20100528185302.639535282@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A number of places use RCU locking for accessing
the station list, even though they do not need
to. Use mutex locking instead to prepare for the
locking changes I want to make.

While doing so, combine places where we loop
over stations twice, and optimise away some of
the loops by checking if the hardware supports
aggregation at all first.

Also fix a more theoretical race condition: right
now we could resume, set up an aggregation session,
and right after tear it down again due to the code
that is needed for hardware reconfiguration here.
Also mark add a comment to that code marking it as
a workaround.

Finally, remove a pointless aggregation disabling
loop when an interface is stopped, directly after
that we remove all stations from it which will also
disable all aggregation sessions that may still be
active, and does so in a race-free way unlike the
current loop that doesn't block new sessions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |   13 -------------
 net/mac80211/pm.c    |   16 ++++------------
 net/mac80211/util.c  |   31 ++++++++++++++++---------------
 3 files changed, 20 insertions(+), 40 deletions(-)

--- wireless-testing.orig/net/mac80211/pm.c	2010-05-28 20:35:58.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2010-05-28 20:36:01.000000000 +0200
@@ -40,22 +40,14 @@ int __ieee80211_suspend(struct ieee80211
 	list_for_each_entry(sdata, &local->interfaces, list)
 		ieee80211_disable_keys(sdata);
 
-	/* Tear down aggregation sessions */
-
-	rcu_read_lock();
-
-	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
-		list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	/* tear down aggregation sessions and remove STAs */
+	mutex_lock(&local->sta_mtx);
+	list_for_each_entry(sta, &local->sta_list, list) {
+		if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
 			set_sta_flags(sta, WLAN_STA_BLOCK_BA);
 			ieee80211_sta_tear_down_BA_sessions(sta);
 		}
-	}
 
-	rcu_read_unlock();
-
-	/* remove STAs */
-	mutex_lock(&local->sta_mtx);
-	list_for_each_entry(sta, &local->sta_list, list) {
 		if (sta->uploaded) {
 			sdata = sta->sdata;
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
--- wireless-testing.orig/net/mac80211/util.c	2010-05-28 20:35:58.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-05-28 20:36:01.000000000 +0200
@@ -1138,18 +1138,6 @@ int ieee80211_reconfig(struct ieee80211_
 	}
 	mutex_unlock(&local->sta_mtx);
 
-	/* Clear Suspend state so that ADDBA requests can be processed */
-
-	rcu_read_lock();
-
-	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
-		list_for_each_entry_rcu(sta, &local->sta_list, list) {
-			clear_sta_flags(sta, WLAN_STA_BLOCK_BA);
-		}
-	}
-
-	rcu_read_unlock();
-
 	/* setup RTS threshold */
 	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
 
@@ -1202,13 +1190,26 @@ int ieee80211_reconfig(struct ieee80211_
 		}
 	}
 
-	rcu_read_lock();
+	/*
+	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
+	 * sessions can be established after a resume.
+	 *
+	 * Also tear down aggregation sessions since reconfiguring
+	 * them in a hardware restart scenario is not easily done
+	 * right now, and the hardware will have lost information
+	 * about the sessions, but we and the AP still think they
+	 * are active. This is really a workaround though.
+	 */
 	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
-		list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		mutex_lock(&local->sta_mtx);
+
+		list_for_each_entry(sta, &local->sta_list, list) {
 			ieee80211_sta_tear_down_BA_sessions(sta);
+			clear_sta_flags(sta, WLAN_STA_BLOCK_BA);
 		}
+
+		mutex_unlock(&local->sta_mtx);
 	}
-	rcu_read_unlock();
 
 	/* add back keys */
 	list_for_each_entry(sdata, &local->interfaces, list)
--- wireless-testing.orig/net/mac80211/iface.c	2010-05-28 20:36:00.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-05-28 20:36:01.000000000 +0200
@@ -340,7 +340,6 @@ static int ieee80211_stop(struct net_dev
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
 	unsigned long flags;
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
@@ -357,18 +356,6 @@ static int ieee80211_stop(struct net_dev
 	ieee80211_work_purge(sdata);
 
 	/*
-	 * Now delete all active aggregation sessions.
-	 */
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
-		if (sta->sdata == sdata)
-			ieee80211_sta_tear_down_BA_sessions(sta);
-	}
-
-	rcu_read_unlock();
-
-	/*
 	 * Remove all stations associated with this interface.
 	 *
 	 * This must be done before calling ops->remove_interface()


