Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab3BONmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 08:42:24 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: marco@cozybit.com, thomas@cozybit.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: clean up mesh_sync coding style
Date: Fri, 15 Feb 2013 14:42:18 +0100
Message-Id: <1360935738-16289-1-git-send-email-johannes@sipsolutions.net> (sfid-20130215_144226_673729_174E47A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to break to fit 72 columns, and
some other cleanups.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_sync.c | 47 ++++++++++++++++-------------------------------
 1 file changed, 16 insertions(+), 31 deletions(-)

diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index aa8d1e4..05a256b 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -43,7 +43,7 @@ struct sync_method {
 static bool mesh_peer_tbtt_adjusting(struct ieee802_11_elems *ie)
 {
 	return (ie->mesh_config->meshconf_cap &
-	    IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING) != 0;
+			IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING) != 0;
 }
 
 void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
@@ -112,7 +112,8 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 
 	if (elems->mesh_config && mesh_peer_tbtt_adjusting(elems)) {
 		clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
-		msync_dbg(sdata, "STA %pM : is adjusting TBTT\n", sta->sta.addr);
+		msync_dbg(sdata, "STA %pM : is adjusting TBTT\n",
+			  sta->sta.addr);
 		goto no_sync;
 	}
 
@@ -129,18 +130,15 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	sta->t_offset = t_t - t_r;
 
 	if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
-		s64 t_clockdrift = sta->t_offset_setpoint
-				   - sta->t_offset;
+		s64 t_clockdrift = sta->t_offset_setpoint - sta->t_offset;
 		msync_dbg(sdata,
 			  "STA %pM : sta->t_offset=%lld, sta->t_offset_setpoint=%lld, t_clockdrift=%lld\n",
-			  sta->sta.addr,
-			  (long long) sta->t_offset,
-			  (long long)
-			  sta->t_offset_setpoint,
+			  sta->sta.addr, (long long) sta->t_offset,
+			  (long long) sta->t_offset_setpoint,
 			  (long long) t_clockdrift);
 
 		if (t_clockdrift > TOFFSET_MAXIMUM_ADJUSTMENT ||
-			t_clockdrift < -TOFFSET_MAXIMUM_ADJUSTMENT) {
+		    t_clockdrift < -TOFFSET_MAXIMUM_ADJUSTMENT) {
 			msync_dbg(sdata,
 				  "STA %pM : t_clockdrift=%lld too large, setpoint reset\n",
 				  sta->sta.addr,
@@ -149,15 +147,10 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			goto no_sync;
 		}
 
-		rcu_read_unlock();
-
 		spin_lock_bh(&ifmsh->sync_offset_lock);
-		if (t_clockdrift >
-		    ifmsh->sync_offset_clockdrift_max)
-			ifmsh->sync_offset_clockdrift_max
-				= t_clockdrift;
+		if (t_clockdrift > ifmsh->sync_offset_clockdrift_max)
+			ifmsh->sync_offset_clockdrift_max = t_clockdrift;
 		spin_unlock_bh(&ifmsh->sync_offset_lock);
-
 	} else {
 		sta->t_offset_setpoint = sta->t_offset - TOFFSET_SET_MARGIN;
 		set_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
@@ -165,9 +158,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			  "STA %pM : offset was invalid, sta->t_offset=%lld\n",
 			  sta->sta.addr,
 			  (long long) sta->t_offset);
-		rcu_read_unlock();
 	}
-	return;
 
 no_sync:
 	rcu_read_unlock();
@@ -177,14 +168,12 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-	WARN_ON(ifmsh->mesh_sp_id
-		!= IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
+	WARN_ON(ifmsh->mesh_sp_id != IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
 	BUG_ON(!rcu_read_lock_held());
 
 	spin_lock_bh(&ifmsh->sync_offset_lock);
 
-	if (ifmsh->sync_offset_clockdrift_max >
-		TOFFSET_MINIMUM_ADJUSTMENT) {
+	if (ifmsh->sync_offset_clockdrift_max > TOFFSET_MINIMUM_ADJUSTMENT) {
 		/* Since ajusting the tsf here would
 		 * require a possibly blocking call
 		 * to the driver tsf setter, we punt
@@ -193,8 +182,7 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 		msync_dbg(sdata,
 			  "TBTT : kicking off TBTT adjustment with clockdrift_max=%lld\n",
 			  ifmsh->sync_offset_clockdrift_max);
-		set_bit(MESH_WORK_DRIFT_ADJUST,
-			&ifmsh->wrkq_flags);
+		set_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags);
 
 		ifmsh->adjusting_tbtt = true;
 	} else {
@@ -220,14 +208,11 @@ static const struct sync_method sync_methods[] = {
 
 const struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method)
 {
-	const struct ieee80211_mesh_sync_ops *ops = NULL;
-	u8 i;
+	int i;
 
 	for (i = 0 ; i < ARRAY_SIZE(sync_methods); ++i) {
-		if (sync_methods[i].method == method) {
-			ops = &sync_methods[i].ops;
-			break;
-		}
+		if (sync_methods[i].method == method)
+			return &sync_methods[i].ops;
 	}
-	return ops;
+	return NULL;
 }
-- 
1.8.0

