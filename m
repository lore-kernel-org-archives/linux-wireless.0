Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42746 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3CTAwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 20:52:51 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] mac80211:  Optimize sta lookup for many VIFs
Date: Tue, 19 Mar 2013 17:52:44 -0700
Message-Id: <1363740764-1679-1-git-send-email-greearb@candelatech.com> (sfid-20130320_015255_058611_041FEECF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The sta_info hash is designed to deal with an AP
with lots of stations associated, or a station interface
connected to a single AP.

However, when you have lots of station VIFs connected
to the same AP, the sta_info hash becomes worthless
as there is a single hash bucket that contains all the
entries in a linked list.

So, have the sdata object cache one of its station
interfaces.  If we are a station VIF with a single
sta_info, then this means we can ignore the sta_info
hash entirely.

On a test case with 128 stations and 50 TCP streams,
tx performance went from around 80Mbps to 124Mbps.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v2:  Try quick-lookup only for Station interfaces.
     Set/clear the quick-lookup-pointer in the hash
     setup/clear logic instead of the constructor/destructor.

:100644 100644 a618bda... 5288a4f... M	net/mac80211/cfg.c
:100644 100644 493e2e8... c6386c7... M	net/mac80211/ieee80211_i.h
:100644 100644 415f9c6... db7e31d... M	net/mac80211/sta_info.c
 net/mac80211/cfg.c         |    5 +++++
 net/mac80211/ieee80211_i.h |    6 ++++++
 net/mac80211/sta_info.c    |   22 +++++++++++++++++++++-
 3 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a618bda..5288a4f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1287,6 +1287,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 	if (params->vlan && params->vlan != sta->sdata->dev) {
 		bool prev_4addr = false;
 		bool new_4addr = false;
+		struct sta_info *some_sta;
 
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
@@ -1312,7 +1313,11 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 			prev_4addr = true;
 		}
 
+		some_sta = rcu_dereference(sta->sdata->some_sta);
+		if (some_sta == sta)
+			rcu_assign_pointer(sta->sdata->some_sta, NULL);
 		sta->sdata = vlansdata;
+		rcu_assign_pointer(sta->sdata->some_sta, sta);
 
 		if (sta->sta_state == IEEE80211_STA_AUTHORIZED &&
 		    prev_4addr != new_4addr) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 493e2e8..c6386c7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -669,6 +669,12 @@ struct ieee80211_sub_if_data {
 	/* count for keys needing tailroom space allocation */
 	int crypto_tx_tailroom_needed_cnt;
 
+	/* A pointer to some station associated with this interface, or
+	 * NULL.  This allows opportunistic lookup for sta_info objects when
+	 * sdata is a station with a single sta_info.
+	 */
+	struct sta_info __rcu *some_sta;
+
 	struct net_device *dev;
 	struct ieee80211_local *local;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 415f9c6..db7e31d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -67,7 +67,11 @@
 static int sta_info_hash_del(struct ieee80211_local *local,
 			     struct sta_info *sta)
 {
-	struct sta_info *s;
+	struct sta_info *s, *some_sta;
+
+	some_sta = rcu_dereference(sta->sdata->some_sta);
+	if (some_sta == sta)
+		rcu_assign_pointer(sta->sdata->some_sta, NULL);
 
 	s = rcu_dereference_protected(local->sta_hash[STA_HASH(sta->sta.addr)],
 				      lockdep_is_held(&local->sta_mtx));
@@ -195,6 +199,20 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		struct sta_info *some_sta;
+
+		/* Shortcut for finding station entries for STATION VIFs */
+		some_sta = rcu_dereference(sdata->some_sta);
+		if (some_sta) {
+			if (WARN_ON(some_sta->sdata != sdata))
+				rcu_assign_pointer(sdata->some_sta, NULL);
+			else
+				if (ether_addr_equal(some_sta->sta.addr, addr))
+					return some_sta;
+		}
+	}
+
 	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
 				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
@@ -278,6 +296,8 @@ static void sta_info_hash_add(struct ieee80211_local *local,
 	lockdep_assert_held(&local->sta_mtx);
 	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
 	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
+
+	rcu_assign_pointer(sta->sdata->some_sta, sta);
 }
 
 static void sta_unblock(struct work_struct *wk)
-- 
1.7.3.4

