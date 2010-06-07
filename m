Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0FGLDC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 07:03:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OLa6f-0007AQ-2a
	for linux-wireless@vger.kernel.org; Mon, 07 Jun 2010 13:03:01 +0200
Message-Id: <20100607110159.064767920@sipsolutions.net>
Date: Mon, 07 Jun 2010 13:01:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 01/21] mac80211: simplify station/aggregation code
References: <20100607110133.472649120@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A number of places use RCU locking for accessing
the station list, even though they do not need
to. Use mutex locking instead to prepare for the
locking changes I want to make. The mlme code is
also using a WLAN_STA_DISASSOC flag that has the
same meaning as WLAN_STA_BLOCK_BA, so use that.

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
 net/mac80211/agg-tx.c   |   10 +---------
 net/mac80211/iface.c    |   13 -------------
 net/mac80211/mlme.c     |    6 +++---
 net/mac80211/pm.c       |   16 ++++------------
 net/mac80211/sta_info.h |    4 ----
 net/mac80211/util.c     |   31 ++++++++++++++++---------------
 6 files changed, 24 insertions(+), 56 deletions(-)

--- wireless-testing.orig/net/mac80211/pm.c	2010-06-01 09:51:49.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2010-06-01 10:19:33.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/util.c	2010-06-01 09:51:49.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-06-01 10:19:33.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/iface.c	2010-06-01 09:51:50.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-06-01 10:19:33.000000000 +0200
@@ -339,7 +339,6 @@ static int ieee80211_stop(struct net_dev
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
 	unsigned long flags;
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
@@ -356,18 +355,6 @@ static int ieee80211_stop(struct net_dev
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
--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-06-01 09:51:49.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-06-01 10:19:33.000000000 +0200
@@ -239,17 +239,9 @@ int ieee80211_start_tx_ba_session(struct
 	    sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EINVAL;
 
-	if (test_sta_flags(sta, WLAN_STA_DISASSOC)) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Disassociation is in progress. "
-		       "Denying BA session request\n");
-#endif
-		return -EINVAL;
-	}
-
 	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Suspend in progress. "
+		printk(KERN_DEBUG "BA sessions blocked. "
 		       "Denying BA session request\n");
 #endif
 		return -EINVAL;
--- wireless-testing.orig/net/mac80211/mlme.c	2010-06-01 09:51:49.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-06-01 10:19:33.000000000 +0200
@@ -898,13 +898,13 @@ static void ieee80211_set_disassoc(struc
 	netif_tx_stop_all_queues(sdata->dev);
 	netif_carrier_off(sdata->dev);
 
-	rcu_read_lock();
+	mutex_lock(&local->sta_mtx);
 	sta = sta_info_get(sdata, bssid);
 	if (sta) {
-		set_sta_flags(sta, WLAN_STA_DISASSOC);
+		set_sta_flags(sta, WLAN_STA_BLOCK_BA);
 		ieee80211_sta_tear_down_BA_sessions(sta);
 	}
-	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
 
 	changed |= ieee80211_reset_erp_info(sdata);
 
--- wireless-testing.orig/net/mac80211/sta_info.h	2010-06-01 09:51:49.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2010-06-01 10:19:33.000000000 +0200
@@ -42,9 +42,6 @@
  *	be in the queues
  * @WLAN_STA_PSPOLL: Station sent PS-poll while driver was keeping
  *	station in power-save mode, reply when the driver unblocks.
- * @WLAN_STA_DISASSOC: Disassociation in progress.
- *	This is used to reject TX BA session requests when disassociation
- *	is in progress.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -60,7 +57,6 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_BLOCK_BA	= 1<<11,
 	WLAN_STA_PS_DRIVER	= 1<<12,
 	WLAN_STA_PSPOLL		= 1<<13,
-	WLAN_STA_DISASSOC       = 1<<14,
 };
 
 #define STA_TID_NUM 16


