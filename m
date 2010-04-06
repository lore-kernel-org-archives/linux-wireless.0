Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47117 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0DFJWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:22:41 -0400
Message-Id: <20100406092141.174938785@sipsolutions.net>
Date: Tue, 06 Apr 2010 11:18:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] mac80211: annotate station rcu dereferences
References: <20100406091841.549805267@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new RCU lockdep support warns about these
in some contexts -- make it aware of the locks
used to protect all this. Different locks are
used in different contexts which unfortunately
means we can't get perfect checking.

Also remove rcu_dereference() from two places
that don't actually dereference the pointers.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c     |    4 ++--
 net/mac80211/sta_info.c |   20 ++++++++++++++++----
 2 files changed, 18 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/sta_info.c	2010-04-06 09:07:30.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-04-06 09:07:33.000000000 +0200
@@ -93,12 +93,18 @@ struct sta_info *sta_info_get(struct iee
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
-	sta = rcu_dereference(local->sta_hash[STA_HASH(addr)]);
+	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
+				    rcu_read_lock_held() ||
+				    lockdep_is_held(&local->sta_lock) ||
+				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
 		if (sta->sdata == sdata &&
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
-		sta = rcu_dereference(sta->hnext);
+		sta = rcu_dereference_check(sta->hnext,
+					    rcu_read_lock_held() ||
+					    lockdep_is_held(&local->sta_lock) ||
+					    lockdep_is_held(&local->sta_mtx));
 	}
 	return sta;
 }
@@ -113,13 +119,19 @@ struct sta_info *sta_info_get_bss(struct
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
-	sta = rcu_dereference(local->sta_hash[STA_HASH(addr)]);
+	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
+				    rcu_read_lock_held() ||
+				    lockdep_is_held(&local->sta_lock) ||
+				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
 		if ((sta->sdata == sdata ||
 		     sta->sdata->bss == sdata->bss) &&
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
-		sta = rcu_dereference(sta->hnext);
+		sta = rcu_dereference_check(sta->hnext,
+					    rcu_read_lock_held() ||
+					    lockdep_is_held(&local->sta_lock) ||
+					    lockdep_is_held(&local->sta_mtx));
 	}
 	return sta;
 }
--- wireless-testing.orig/net/mac80211/main.c	2010-04-06 09:07:30.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-04-06 09:07:33.000000000 +0200
@@ -225,11 +225,11 @@ void ieee80211_bss_info_change_notify(st
 			switch (sdata->vif.type) {
 			case NL80211_IFTYPE_AP:
 				sdata->vif.bss_conf.enable_beacon =
-					!!rcu_dereference(sdata->u.ap.beacon);
+					!!sdata->u.ap.beacon;
 				break;
 			case NL80211_IFTYPE_ADHOC:
 				sdata->vif.bss_conf.enable_beacon =
-					!!rcu_dereference(sdata->u.ibss.presp);
+					!!sdata->u.ibss.presp;
 				break;
 			case NL80211_IFTYPE_MESH_POINT:
 				sdata->vif.bss_conf.enable_beacon = true;


