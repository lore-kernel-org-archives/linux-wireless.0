Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46840 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbbFQI4W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:56:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 13/14] mac80211: move mesh related station fields to own struct
Date: Wed, 17 Jun 2015 10:41:14 +0200
Message-Id: <1434530475-3553-14-git-send-email-johannes@sipsolutions.net> (sfid-20150617_105630_816558_FE680DD4)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are now a fairly large number of mesh fields that really
aren't needed in any other modes; move those into their own
structure and allocate them separately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c        |   8 +--
 net/mac80211/mesh.c       |   2 +-
 net/mac80211/mesh_hwmp.c  |   2 +-
 net/mac80211/mesh_plink.c | 177 +++++++++++++++++++++++-----------------------
 net/mac80211/mesh_ps.c    |  42 +++++------
 net/mac80211/mesh_sync.c  |  16 ++---
 net/mac80211/sta_info.c   |  35 +++++----
 net/mac80211/sta_info.h   |  88 ++++++++++++-----------
 8 files changed, 194 insertions(+), 176 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5fc7788e2ff2..c9f8f34ac728 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1150,10 +1150,10 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		if (params->sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE) {
 			switch (params->plink_state) {
 			case NL80211_PLINK_ESTAB:
-				if (sta->plink_state != NL80211_PLINK_ESTAB)
+				if (sta->mesh->plink_state != NL80211_PLINK_ESTAB)
 					changed = mesh_plink_inc_estab_count(
 							sdata);
-				sta->plink_state = params->plink_state;
+				sta->mesh->plink_state = params->plink_state;
 
 				ieee80211_mps_sta_status_update(sta);
 				changed |= ieee80211_mps_set_sta_local_pm(sta,
@@ -1165,10 +1165,10 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 			case NL80211_PLINK_OPN_RCVD:
 			case NL80211_PLINK_CNF_RCVD:
 			case NL80211_PLINK_HOLDING:
-				if (sta->plink_state == NL80211_PLINK_ESTAB)
+				if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
 					changed = mesh_plink_dec_estab_count(
 							sdata);
-				sta->plink_state = params->plink_state;
+				sta->mesh->plink_state = params->plink_state;
 
 				ieee80211_mps_sta_status_update(sta);
 				changed |= ieee80211_mps_set_sta_local_pm(sta,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 817098add1d6..e06a5ca7c9a9 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -158,7 +158,7 @@ void mesh_sta_cleanup(struct sta_info *sta)
 	changed = mesh_accept_plinks_update(sdata);
 	if (!sdata->u.mesh.user_mpm) {
 		changed |= mesh_plink_deactivate(sta);
-		del_timer_sync(&sta->plink_timer);
+		del_timer_sync(&sta->mesh->plink_timer);
 	}
 
 	if (changed)
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 085edc1d056b..cd02810038cb 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -862,7 +862,7 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_lock();
 	sta = sta_info_get(sdata, mgmt->sa);
-	if (!sta || sta->plink_state != NL80211_PLINK_ESTAB) {
+	if (!sta || sta->mesh->plink_state != NL80211_PLINK_ESTAB) {
 		rcu_read_unlock();
 		return;
 	}
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 5438d13e2f00..1a7d98398626 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -16,7 +16,7 @@
 #define PLINK_GET_LLID(p) (p + 2)
 #define PLINK_GET_PLID(p) (p + 4)
 
-#define mod_plink_timer(s, t) (mod_timer(&s->plink_timer, \
+#define mod_plink_timer(s, t) (mod_timer(&s->mesh->plink_timer, \
 				jiffies + msecs_to_jiffies(t)))
 
 enum plink_event {
@@ -72,14 +72,14 @@ static bool rssi_threshold_check(struct ieee80211_sub_if_data *sdata,
  *
  * @sta: mesh peer link to restart
  *
- * Locking: this function must be called holding sta->plink_lock
+ * Locking: this function must be called holding sta->mesh->plink_lock
  */
 static inline void mesh_plink_fsm_restart(struct sta_info *sta)
 {
-	lockdep_assert_held(&sta->plink_lock);
-	sta->plink_state = NL80211_PLINK_LISTEN;
-	sta->llid = sta->plid = sta->reason = 0;
-	sta->plink_retries = 0;
+	lockdep_assert_held(&sta->mesh->plink_lock);
+	sta->mesh->plink_state = NL80211_PLINK_LISTEN;
+	sta->mesh->llid = sta->mesh->plid = sta->mesh->reason = 0;
+	sta->mesh->plink_retries = 0;
 }
 
 /*
@@ -119,7 +119,7 @@ static u32 mesh_set_short_slot_time(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		if (sdata != sta->sdata ||
-		    sta->plink_state != NL80211_PLINK_ESTAB)
+		    sta->mesh->plink_state != NL80211_PLINK_ESTAB)
 			continue;
 
 		short_slot = false;
@@ -169,7 +169,7 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		if (sdata != sta->sdata ||
-		    sta->plink_state != NL80211_PLINK_ESTAB)
+		    sta->mesh->plink_state != NL80211_PLINK_ESTAB)
 			continue;
 
 		if (sta->sta.bandwidth > IEEE80211_STA_RX_BW_20)
@@ -212,18 +212,18 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
  * All mesh paths with this peer as next hop will be flushed
  * Returns beacon changed flag if the beacon content changed.
  *
- * Locking: the caller must hold sta->plink_lock
+ * Locking: the caller must hold sta->mesh->plink_lock
  */
 static u32 __mesh_plink_deactivate(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 changed = 0;
 
-	lockdep_assert_held(&sta->plink_lock);
+	lockdep_assert_held(&sta->mesh->plink_lock);
 
-	if (sta->plink_state == NL80211_PLINK_ESTAB)
+	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
 		changed = mesh_plink_dec_estab_count(sdata);
-	sta->plink_state = NL80211_PLINK_BLOCKED;
+	sta->mesh->plink_state = NL80211_PLINK_BLOCKED;
 	mesh_path_flush_by_nexthop(sta);
 
 	ieee80211_mps_sta_status_update(sta);
@@ -245,13 +245,13 @@ u32 mesh_plink_deactivate(struct sta_info *sta)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 changed;
 
-	spin_lock_bh(&sta->plink_lock);
+	spin_lock_bh(&sta->mesh->plink_lock);
 	changed = __mesh_plink_deactivate(sta);
-	sta->reason = WLAN_REASON_MESH_PEER_CANCELED;
+	sta->mesh->reason = WLAN_REASON_MESH_PEER_CANCELED;
 	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
-			    sta->sta.addr, sta->llid, sta->plid,
-			    sta->reason);
-	spin_unlock_bh(&sta->plink_lock);
+			    sta->sta.addr, sta->mesh->llid, sta->mesh->plid,
+			    sta->mesh->reason);
+	spin_unlock_bh(&sta->mesh->plink_lock);
 
 	return changed;
 }
@@ -388,13 +388,14 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	sband = local->hw.wiphy->bands[band];
 	rates = ieee80211_sta_get_rates(sdata, elems, band, &basic_rates);
 
-	spin_lock_bh(&sta->plink_lock);
+	spin_lock_bh(&sta->mesh->plink_lock);
 	sta->last_rx = jiffies;
 
 	/* rates and capabilities don't change during peering */
-	if (sta->plink_state == NL80211_PLINK_ESTAB && sta->processed_beacon)
+	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB &&
+	    sta->mesh->processed_beacon)
 		goto out;
-	sta->processed_beacon = true;
+	sta->mesh->processed_beacon = true;
 
 	if (sta->sta.supp_rates[band] != rates)
 		changed |= IEEE80211_RC_SUPP_RATES_CHANGED;
@@ -421,7 +422,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	else
 		rate_control_rate_update(local, sband, sta, changed);
 out:
-	spin_unlock_bh(&sta->plink_lock);
+	spin_unlock_bh(&sta->mesh->plink_lock);
 }
 
 static struct sta_info *
@@ -436,7 +437,7 @@ __mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *hw_addr)
 	if (!sta)
 		return NULL;
 
-	sta->plink_state = NL80211_PLINK_LISTEN;
+	sta->mesh->plink_state = NL80211_PLINK_LISTEN;
 	sta->sta.wme = true;
 
 	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
@@ -524,7 +525,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 		goto out;
 
 	if (mesh_peer_accepts_plinks(elems) &&
-	    sta->plink_state == NL80211_PLINK_LISTEN &&
+	    sta->mesh->plink_state == NL80211_PLINK_LISTEN &&
 	    sdata->u.mesh.accepting_plinks &&
 	    sdata->u.mesh.mshcfg.auto_open_plinks &&
 	    rssi_threshold_check(sdata, sta))
@@ -554,52 +555,52 @@ static void mesh_plink_timer(unsigned long data)
 	if (sta->sdata->local->quiescing)
 		return;
 
-	spin_lock_bh(&sta->plink_lock);
+	spin_lock_bh(&sta->mesh->plink_lock);
 
 	/* If a timer fires just before a state transition on another CPU,
 	 * we may have already extended the timeout and changed state by the
 	 * time we've acquired the lock and arrived  here.  In that case,
 	 * skip this timer and wait for the new one.
 	 */
-	if (time_before(jiffies, sta->plink_timer.expires)) {
+	if (time_before(jiffies, sta->mesh->plink_timer.expires)) {
 		mpl_dbg(sta->sdata,
 			"Ignoring timer for %pM in state %s (timer adjusted)",
-			sta->sta.addr, mplstates[sta->plink_state]);
-		spin_unlock_bh(&sta->plink_lock);
+			sta->sta.addr, mplstates[sta->mesh->plink_state]);
+		spin_unlock_bh(&sta->mesh->plink_lock);
 		return;
 	}
 
 	/* del_timer() and handler may race when entering these states */
-	if (sta->plink_state == NL80211_PLINK_LISTEN ||
-	    sta->plink_state == NL80211_PLINK_ESTAB) {
+	if (sta->mesh->plink_state == NL80211_PLINK_LISTEN ||
+	    sta->mesh->plink_state == NL80211_PLINK_ESTAB) {
 		mpl_dbg(sta->sdata,
 			"Ignoring timer for %pM in state %s (timer deleted)",
-			sta->sta.addr, mplstates[sta->plink_state]);
-		spin_unlock_bh(&sta->plink_lock);
+			sta->sta.addr, mplstates[sta->mesh->plink_state]);
+		spin_unlock_bh(&sta->mesh->plink_lock);
 		return;
 	}
 
 	mpl_dbg(sta->sdata,
 		"Mesh plink timer for %pM fired on state %s\n",
-		sta->sta.addr, mplstates[sta->plink_state]);
+		sta->sta.addr, mplstates[sta->mesh->plink_state]);
 	sdata = sta->sdata;
 	mshcfg = &sdata->u.mesh.mshcfg;
 
-	switch (sta->plink_state) {
+	switch (sta->mesh->plink_state) {
 	case NL80211_PLINK_OPN_RCVD:
 	case NL80211_PLINK_OPN_SNT:
 		/* retry timer */
-		if (sta->plink_retries < mshcfg->dot11MeshMaxRetries) {
+		if (sta->mesh->plink_retries < mshcfg->dot11MeshMaxRetries) {
 			u32 rand;
 			mpl_dbg(sta->sdata,
 				"Mesh plink for %pM (retry, timeout): %d %d\n",
-				sta->sta.addr, sta->plink_retries,
-				sta->plink_timeout);
+				sta->sta.addr, sta->mesh->plink_retries,
+				sta->mesh->plink_timeout);
 			get_random_bytes(&rand, sizeof(u32));
-			sta->plink_timeout = sta->plink_timeout +
-					     rand % sta->plink_timeout;
-			++sta->plink_retries;
-			mod_plink_timer(sta, sta->plink_timeout);
+			sta->mesh->plink_timeout = sta->mesh->plink_timeout +
+					     rand % sta->mesh->plink_timeout;
+			++sta->mesh->plink_retries;
+			mod_plink_timer(sta, sta->mesh->plink_timeout);
 			action = WLAN_SP_MESH_PEERING_OPEN;
 			break;
 		}
@@ -609,31 +610,31 @@ static void mesh_plink_timer(unsigned long data)
 		/* confirm timer */
 		if (!reason)
 			reason = WLAN_REASON_MESH_CONFIRM_TIMEOUT;
-		sta->plink_state = NL80211_PLINK_HOLDING;
+		sta->mesh->plink_state = NL80211_PLINK_HOLDING;
 		mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
 		action = WLAN_SP_MESH_PEERING_CLOSE;
 		break;
 	case NL80211_PLINK_HOLDING:
 		/* holding timer */
-		del_timer(&sta->plink_timer);
+		del_timer(&sta->mesh->plink_timer);
 		mesh_plink_fsm_restart(sta);
 		break;
 	default:
 		break;
 	}
-	spin_unlock_bh(&sta->plink_lock);
+	spin_unlock_bh(&sta->mesh->plink_lock);
 	if (action)
 		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
-				    sta->llid, sta->plid, reason);
+				    sta->mesh->llid, sta->mesh->plid, reason);
 }
 
 static inline void mesh_plink_timer_set(struct sta_info *sta, u32 timeout)
 {
-	sta->plink_timer.expires = jiffies + msecs_to_jiffies(timeout);
-	sta->plink_timer.data = (unsigned long) sta;
-	sta->plink_timer.function = mesh_plink_timer;
-	sta->plink_timeout = timeout;
-	add_timer(&sta->plink_timer);
+	sta->mesh->plink_timer.expires = jiffies + msecs_to_jiffies(timeout);
+	sta->mesh->plink_timer.data = (unsigned long) sta;
+	sta->mesh->plink_timer.function = mesh_plink_timer;
+	sta->mesh->plink_timeout = timeout;
+	add_timer(&sta->mesh->plink_timer);
 }
 
 static bool llid_in_use(struct ieee80211_sub_if_data *sdata,
@@ -645,7 +646,7 @@ static bool llid_in_use(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
-		if (!memcmp(&sta->llid, &llid, sizeof(llid))) {
+		if (!memcmp(&sta->mesh->llid, &llid, sizeof(llid))) {
 			in_use = true;
 			break;
 		}
@@ -676,16 +677,16 @@ u32 mesh_plink_open(struct sta_info *sta)
 	if (!test_sta_flag(sta, WLAN_STA_AUTH))
 		return 0;
 
-	spin_lock_bh(&sta->plink_lock);
-	sta->llid = mesh_get_new_llid(sdata);
-	if (sta->plink_state != NL80211_PLINK_LISTEN &&
-	    sta->plink_state != NL80211_PLINK_BLOCKED) {
-		spin_unlock_bh(&sta->plink_lock);
+	spin_lock_bh(&sta->mesh->plink_lock);
+	sta->mesh->llid = mesh_get_new_llid(sdata);
+	if (sta->mesh->plink_state != NL80211_PLINK_LISTEN &&
+	    sta->mesh->plink_state != NL80211_PLINK_BLOCKED) {
+		spin_unlock_bh(&sta->mesh->plink_lock);
 		return 0;
 	}
-	sta->plink_state = NL80211_PLINK_OPN_SNT;
+	sta->mesh->plink_state = NL80211_PLINK_OPN_SNT;
 	mesh_plink_timer_set(sta, sdata->u.mesh.mshcfg.dot11MeshRetryTimeout);
-	spin_unlock_bh(&sta->plink_lock);
+	spin_unlock_bh(&sta->mesh->plink_lock);
 	mpl_dbg(sdata,
 		"Mesh plink: starting establishment with %pM\n",
 		sta->sta.addr);
@@ -694,7 +695,7 @@ u32 mesh_plink_open(struct sta_info *sta)
 	changed = ieee80211_mps_local_status_update(sdata);
 
 	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
-			    sta->sta.addr, sta->llid, 0, 0);
+			    sta->sta.addr, sta->mesh->llid, 0, 0);
 	return changed;
 }
 
@@ -702,10 +703,10 @@ u32 mesh_plink_block(struct sta_info *sta)
 {
 	u32 changed;
 
-	spin_lock_bh(&sta->plink_lock);
+	spin_lock_bh(&sta->mesh->plink_lock);
 	changed = __mesh_plink_deactivate(sta);
-	sta->plink_state = NL80211_PLINK_BLOCKED;
-	spin_unlock_bh(&sta->plink_lock);
+	sta->mesh->plink_state = NL80211_PLINK_BLOCKED;
+	spin_unlock_bh(&sta->mesh->plink_lock);
 
 	return changed;
 }
@@ -715,12 +716,11 @@ static void mesh_plink_close(struct ieee80211_sub_if_data *sdata,
 			     enum plink_event event)
 {
 	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
-
 	u16 reason = (event == CLS_ACPT) ?
 		     WLAN_REASON_MESH_CLOSE : WLAN_REASON_MESH_CONFIG;
 
-	sta->reason = reason;
-	sta->plink_state = NL80211_PLINK_HOLDING;
+	sta->mesh->reason = reason;
+	sta->mesh->plink_state = NL80211_PLINK_HOLDING;
 	mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
 }
 
@@ -730,8 +730,8 @@ static u32 mesh_plink_establish(struct ieee80211_sub_if_data *sdata,
 	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
 	u32 changed = 0;
 
-	del_timer(&sta->plink_timer);
-	sta->plink_state = NL80211_PLINK_ESTAB;
+	del_timer(&sta->mesh->plink_timer);
+	sta->mesh->plink_state = NL80211_PLINK_ESTAB;
 	changed |= mesh_plink_inc_estab_count(sdata);
 	changed |= mesh_set_ht_prot_mode(sdata);
 	changed |= mesh_set_short_slot_time(sdata);
@@ -758,18 +758,18 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 	u32 changed = 0;
 
 	mpl_dbg(sdata, "peer %pM in state %s got event %s\n", sta->sta.addr,
-		mplstates[sta->plink_state], mplevents[event]);
+		mplstates[sta->mesh->plink_state], mplevents[event]);
 
-	spin_lock_bh(&sta->plink_lock);
-	switch (sta->plink_state) {
+	spin_lock_bh(&sta->mesh->plink_lock);
+	switch (sta->mesh->plink_state) {
 	case NL80211_PLINK_LISTEN:
 		switch (event) {
 		case CLS_ACPT:
 			mesh_plink_fsm_restart(sta);
 			break;
 		case OPN_ACPT:
-			sta->plink_state = NL80211_PLINK_OPN_RCVD;
-			sta->llid = mesh_get_new_llid(sdata);
+			sta->mesh->plink_state = NL80211_PLINK_OPN_RCVD;
+			sta->mesh->llid = mesh_get_new_llid(sdata);
 			mesh_plink_timer_set(sta,
 					     mshcfg->dot11MeshRetryTimeout);
 
@@ -791,11 +791,11 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 			break;
 		case OPN_ACPT:
 			/* retry timer is left untouched */
-			sta->plink_state = NL80211_PLINK_OPN_RCVD;
+			sta->mesh->plink_state = NL80211_PLINK_OPN_RCVD;
 			action = WLAN_SP_MESH_PEERING_CONFIRM;
 			break;
 		case CNF_ACPT:
-			sta->plink_state = NL80211_PLINK_CNF_RCVD;
+			sta->mesh->plink_state = NL80211_PLINK_CNF_RCVD;
 			mod_plink_timer(sta, mshcfg->dot11MeshConfirmTimeout);
 			break;
 		default:
@@ -855,7 +855,7 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 	case NL80211_PLINK_HOLDING:
 		switch (event) {
 		case CLS_ACPT:
-			del_timer(&sta->plink_timer);
+			del_timer(&sta->mesh->plink_timer);
 			mesh_plink_fsm_restart(sta);
 			break;
 		case OPN_ACPT:
@@ -874,17 +874,18 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 		 */
 		break;
 	}
-	spin_unlock_bh(&sta->plink_lock);
+	spin_unlock_bh(&sta->mesh->plink_lock);
 	if (action) {
 		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
-				    sta->llid, sta->plid, sta->reason);
+				    sta->mesh->llid, sta->mesh->plid,
+				    sta->mesh->reason);
 
 		/* also send confirm in open case */
 		if (action == WLAN_SP_MESH_PEERING_OPEN) {
 			mesh_plink_frame_tx(sdata,
 					    WLAN_SP_MESH_PEERING_CONFIRM,
-					    sta->sta.addr, sta->llid,
-					    sta->plid, 0);
+					    sta->sta.addr, sta->mesh->llid,
+					    sta->mesh->plid, 0);
 		}
 	}
 
@@ -939,7 +940,7 @@ mesh_plink_get_event(struct ieee80211_sub_if_data *sdata,
 			mpl_dbg(sdata, "Mesh plink: Action frame from non-authed peer\n");
 			goto out;
 		}
-		if (sta->plink_state == NL80211_PLINK_BLOCKED)
+		if (sta->mesh->plink_state == NL80211_PLINK_BLOCKED)
 			goto out;
 	}
 
@@ -954,7 +955,7 @@ mesh_plink_get_event(struct ieee80211_sub_if_data *sdata,
 		if (!matches_local)
 			event = OPN_RJCT;
 		if (!mesh_plink_free_count(sdata) ||
-		    (sta->plid && sta->plid != plid))
+		    (sta->mesh->plid && sta->mesh->plid != plid))
 			event = OPN_IGNR;
 		else
 			event = OPN_ACPT;
@@ -963,14 +964,14 @@ mesh_plink_get_event(struct ieee80211_sub_if_data *sdata,
 		if (!matches_local)
 			event = CNF_RJCT;
 		if (!mesh_plink_free_count(sdata) ||
-		    sta->llid != llid ||
-		    (sta->plid && sta->plid != plid))
+		    sta->mesh->llid != llid ||
+		    (sta->mesh->plid && sta->mesh->plid != plid))
 			event = CNF_IGNR;
 		else
 			event = CNF_ACPT;
 		break;
 	case WLAN_SP_MESH_PEERING_CLOSE:
-		if (sta->plink_state == NL80211_PLINK_ESTAB)
+		if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
 			/* Do not check for llid or plid. This does not
 			 * follow the standard but since multiple plinks
 			 * per sta are not supported, it is necessary in
@@ -981,9 +982,9 @@ mesh_plink_get_event(struct ieee80211_sub_if_data *sdata,
 			 * restarted.
 			 */
 			event = CLS_ACPT;
-		else if (sta->plid != plid)
+		else if (sta->mesh->plid != plid)
 			event = CLS_IGNR;
-		else if (ie_len == 8 && sta->llid != llid)
+		else if (ie_len == 8 && sta->mesh->llid != llid)
 			event = CLS_IGNR;
 		else
 			event = CLS_ACPT;
@@ -1070,7 +1071,7 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 			mpl_dbg(sdata, "Mesh plink: failed to init peer!\n");
 			goto unlock_rcu;
 		}
-		sta->plid = plid;
+		sta->mesh->plid = plid;
 	} else if (!sta && event == OPN_RJCT) {
 		mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
 				    mgmt->sa, 0, plid,
@@ -1082,8 +1083,8 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* 802.11-2012 13.3.7.2 - update plid on CNF if not set */
-	if (!sta->plid && event == CNF_ACPT)
-		sta->plid = plid;
+	if (!sta->mesh->plid && event == CNF_ACPT)
+		sta->mesh->plid = plid;
 
 	changed |= mesh_plink_fsm(sdata, sta, event);
 
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index ad8b377b4b9f..29747f92b9b0 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -92,16 +92,16 @@ u32 ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
 		if (sdata != sta->sdata)
 			continue;
 
-		switch (sta->plink_state) {
+		switch (sta->mesh->plink_state) {
 		case NL80211_PLINK_OPN_SNT:
 		case NL80211_PLINK_OPN_RCVD:
 		case NL80211_PLINK_CNF_RCVD:
 			peering = true;
 			break;
 		case NL80211_PLINK_ESTAB:
-			if (sta->local_pm == NL80211_MESH_POWER_LIGHT_SLEEP)
+			if (sta->mesh->local_pm == NL80211_MESH_POWER_LIGHT_SLEEP)
 				light_sleep_cnt++;
-			else if (sta->local_pm == NL80211_MESH_POWER_DEEP_SLEEP)
+			else if (sta->mesh->local_pm == NL80211_MESH_POWER_DEEP_SLEEP)
 				deep_sleep_cnt++;
 			break;
 		default:
@@ -153,19 +153,19 @@ u32 ieee80211_mps_set_sta_local_pm(struct sta_info *sta,
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
-	if (sta->local_pm == pm)
+	if (sta->mesh->local_pm == pm)
 		return 0;
 
 	mps_dbg(sdata, "local STA operates in mode %d with %pM\n",
 		pm, sta->sta.addr);
 
-	sta->local_pm = pm;
+	sta->mesh->local_pm = pm;
 
 	/*
 	 * announce peer-specific power mode transition
 	 * (see IEEE802.11-2012 13.14.3.2 and 13.14.3.3)
 	 */
-	if (sta->plink_state == NL80211_PLINK_ESTAB)
+	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
 		mps_qos_null_tx(sta);
 
 	return ieee80211_mps_local_status_update(sdata);
@@ -197,8 +197,8 @@ void ieee80211_mps_set_frame_flags(struct ieee80211_sub_if_data *sdata,
 
 	if (is_unicast_ether_addr(hdr->addr1) &&
 	    ieee80211_is_data_qos(hdr->frame_control) &&
-	    sta->plink_state == NL80211_PLINK_ESTAB)
-		pm = sta->local_pm;
+	    sta->mesh->plink_state == NL80211_PLINK_ESTAB)
+		pm = sta->mesh->local_pm;
 	else
 		pm = sdata->u.mesh.nonpeer_pm;
 
@@ -241,16 +241,16 @@ void ieee80211_mps_sta_status_update(struct sta_info *sta)
 	 * use peer-specific power mode if peering is established and the
 	 * peer's power mode is known
 	 */
-	if (sta->plink_state == NL80211_PLINK_ESTAB &&
-	    sta->peer_pm != NL80211_MESH_POWER_UNKNOWN)
-		pm = sta->peer_pm;
+	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB &&
+	    sta->mesh->peer_pm != NL80211_MESH_POWER_UNKNOWN)
+		pm = sta->mesh->peer_pm;
 	else
-		pm = sta->nonpeer_pm;
+		pm = sta->mesh->nonpeer_pm;
 
 	do_buffer = (pm != NL80211_MESH_POWER_ACTIVE);
 
 	/* clear the MPSP flags for non-peers or active STA */
-	if (sta->plink_state != NL80211_PLINK_ESTAB) {
+	if (sta->mesh->plink_state != NL80211_PLINK_ESTAB) {
 		clear_sta_flag(sta, WLAN_STA_MPSP_OWNER);
 		clear_sta_flag(sta, WLAN_STA_MPSP_RECIPIENT);
 	} else if (!do_buffer) {
@@ -296,13 +296,13 @@ static void mps_set_sta_peer_pm(struct sta_info *sta,
 		pm = NL80211_MESH_POWER_ACTIVE;
 	}
 
-	if (sta->peer_pm == pm)
+	if (sta->mesh->peer_pm == pm)
 		return;
 
 	mps_dbg(sta->sdata, "STA %pM enters mode %d\n",
 		sta->sta.addr, pm);
 
-	sta->peer_pm = pm;
+	sta->mesh->peer_pm = pm;
 
 	ieee80211_mps_sta_status_update(sta);
 }
@@ -317,13 +317,13 @@ static void mps_set_sta_nonpeer_pm(struct sta_info *sta,
 	else
 		pm = NL80211_MESH_POWER_ACTIVE;
 
-	if (sta->nonpeer_pm == pm)
+	if (sta->mesh->nonpeer_pm == pm)
 		return;
 
 	mps_dbg(sta->sdata, "STA %pM sets non-peer mode to %d\n",
 		sta->sta.addr, pm);
 
-	sta->nonpeer_pm = pm;
+	sta->mesh->nonpeer_pm = pm;
 
 	ieee80211_mps_sta_status_update(sta);
 }
@@ -552,7 +552,7 @@ void ieee80211_mpsp_trigger_process(u8 *qc, struct sta_info *sta,
 	} else {
 		if (eosp)
 			clear_sta_flag(sta, WLAN_STA_MPSP_RECIPIENT);
-		else if (sta->local_pm != NL80211_MESH_POWER_ACTIVE)
+		else if (sta->mesh->local_pm != NL80211_MESH_POWER_ACTIVE)
 			set_sta_flag(sta, WLAN_STA_MPSP_RECIPIENT);
 
 		if (rspi && !test_and_set_sta_flag(sta, WLAN_STA_MPSP_OWNER))
@@ -577,9 +577,9 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 	int ac, buffer_local = 0;
 	bool has_buffered = false;
 
-	if (sta->plink_state == NL80211_PLINK_ESTAB)
+	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
 		has_buffered = ieee80211_check_tim(elems->tim, elems->tim_len,
-						   sta->llid);
+						   sta->mesh->llid);
 
 	if (has_buffered)
 		mps_dbg(sta->sdata, "%pM indicates buffered frames\n",
@@ -598,7 +598,7 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 	if (!has_buffered && !buffer_local)
 		return;
 
-	if (sta->plink_state == NL80211_PLINK_ESTAB)
+	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
 		mpsp_trigger_send(sta, has_buffered, !buffer_local);
 	else
 		mps_frame_deliver(sta, 1);
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 09625d6205c3..64bc22ad9496 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -127,14 +127,14 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 
 	/* Timing offset calculation (see 13.13.2.2.2) */
 	t_t = le64_to_cpu(mgmt->u.beacon.timestamp);
-	sta->t_offset = t_t - t_r;
+	sta->mesh->t_offset = t_t - t_r;
 
 	if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
-		s64 t_clockdrift = sta->t_offset_setpoint - sta->t_offset;
+		s64 t_clockdrift = sta->mesh->t_offset_setpoint - sta->mesh->t_offset;
 		msync_dbg(sdata,
-			  "STA %pM : sta->t_offset=%lld, sta->t_offset_setpoint=%lld, t_clockdrift=%lld\n",
-			  sta->sta.addr, (long long) sta->t_offset,
-			  (long long) sta->t_offset_setpoint,
+			  "STA %pM : t_offset=%lld, t_offset_setpoint=%lld, t_clockdrift=%lld\n",
+			  sta->sta.addr, (long long) sta->mesh->t_offset,
+			  (long long) sta->mesh->t_offset_setpoint,
 			  (long long) t_clockdrift);
 
 		if (t_clockdrift > TOFFSET_MAXIMUM_ADJUSTMENT ||
@@ -152,12 +152,12 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			ifmsh->sync_offset_clockdrift_max = t_clockdrift;
 		spin_unlock_bh(&ifmsh->sync_offset_lock);
 	} else {
-		sta->t_offset_setpoint = sta->t_offset - TOFFSET_SET_MARGIN;
+		sta->mesh->t_offset_setpoint = sta->mesh->t_offset - TOFFSET_SET_MARGIN;
 		set_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
 		msync_dbg(sdata,
-			  "STA %pM : offset was invalid, sta->t_offset=%lld\n",
+			  "STA %pM : offset was invalid, t_offset=%lld\n",
 			  sta->sta.addr,
-			  (long long) sta->t_offset);
+			  (long long) sta->mesh->t_offset);
 	}
 
 no_sync:
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d573a499750e..1eff5ab76bfd 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -249,6 +249,9 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 	if (sta->sta.txq[0])
 		kfree(to_txq_info(sta->sta.txq[0]));
 	kfree(rcu_dereference_raw(sta->sta.rates));
+#ifdef CONFIG_MAC80211_MESH
+	kfree(sta->mesh);
+#endif
 	kfree(sta);
 }
 
@@ -313,11 +316,16 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
 	mutex_init(&sta->ampdu_mlme.mtx);
 #ifdef CONFIG_MAC80211_MESH
-	spin_lock_init(&sta->plink_lock);
-	if (ieee80211_vif_is_mesh(&sdata->vif) &&
-	    !sdata->u.mesh.user_mpm)
-		init_timer(&sta->plink_timer);
-	sta->nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		sta->mesh = kzalloc(sizeof(*sta->mesh), gfp);
+		if (!sta->mesh)
+			goto free;
+		spin_lock_init(&sta->mesh->plink_lock);
+		if (ieee80211_vif_is_mesh(&sdata->vif) &&
+		    !sdata->u.mesh.user_mpm)
+			init_timer(&sta->mesh->plink_timer);
+		sta->mesh->nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
+	}
 #endif
 
 	memcpy(sta->addr, addr, ETH_ALEN);
@@ -406,6 +414,7 @@ free_txq:
 	if (sta->sta.txq[0])
 		kfree(to_txq_info(sta->sta.txq[0]));
 free:
+	kfree(sta->mesh);
 	kfree(sta);
 	return NULL;
 }
@@ -637,7 +646,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 	} else if (ieee80211_vif_is_mesh(&sta->sdata->vif)) {
 		ps = &sta->sdata->u.mesh.ps;
 		/* TIM map only for 1 <= PLID <= IEEE80211_MAX_AID */
-		id = sta->plid % (IEEE80211_MAX_AID + 1);
+		id = sta->mesh->plid % (IEEE80211_MAX_AID + 1);
 #endif
 	} else {
 		return;
@@ -1957,16 +1966,16 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 				 BIT(NL80211_STA_INFO_PEER_PM) |
 				 BIT(NL80211_STA_INFO_NONPEER_PM);
 
-		sinfo->llid = sta->llid;
-		sinfo->plid = sta->plid;
-		sinfo->plink_state = sta->plink_state;
+		sinfo->llid = sta->mesh->llid;
+		sinfo->plid = sta->mesh->plid;
+		sinfo->plink_state = sta->mesh->plink_state;
 		if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
 			sinfo->filled |= BIT(NL80211_STA_INFO_T_OFFSET);
-			sinfo->t_offset = sta->t_offset;
+			sinfo->t_offset = sta->mesh->t_offset;
 		}
-		sinfo->local_pm = sta->local_pm;
-		sinfo->peer_pm = sta->peer_pm;
-		sinfo->nonpeer_pm = sta->nonpeer_pm;
+		sinfo->local_pm = sta->mesh->local_pm;
+		sinfo->peer_pm = sta->mesh->peer_pm;
+		sinfo->nonpeer_pm = sta->mesh->nonpeer_pm;
 #endif
 	}
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 422984986263..9e568927c080 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -270,6 +270,48 @@ struct ieee80211_fast_tx {
 };
 
 /**
+ * struct mesh_sta - mesh STA information
+ * @plink_lock: serialize access to plink fields
+ * @llid: Local link ID
+ * @plid: Peer link ID
+ * @reason: Cancel reason on PLINK_HOLDING state
+ * @plink_retries: Retries in establishment
+ * @plink_state: peer link state
+ * @plink_timeout: timeout of peer link
+ * @plink_timer: peer link watch timer
+ * @t_offset: timing offset relative to this host
+ * @t_offset_setpoint: reference timing offset of this sta to be used when
+ * 	calculating clockdrift
+ * @local_pm: local link-specific power save mode
+ * @peer_pm: peer-specific power save mode towards local STA
+ * @nonpeer_pm: STA power save mode towards non-peer neighbors
+ * @processed_beacon: set to true after peer rates and capabilities are
+ *	processed
+ */
+struct mesh_sta {
+	struct timer_list plink_timer;
+
+	s64 t_offset;
+	s64 t_offset_setpoint;
+
+	spinlock_t plink_lock;
+	u16 llid;
+	u16 plid;
+	u16 reason;
+	u8 plink_retries;
+
+	bool processed_beacon;
+
+	enum nl80211_plink_state plink_state;
+	u32 plink_timeout;
+
+	/* mesh power save */
+	enum nl80211_mesh_power_mode local_pm;
+	enum nl80211_mesh_power_mode peer_pm;
+	enum nl80211_mesh_power_mode nonpeer_pm;
+};
+
+/**
  * struct sta_info - STA information
  *
  * This structure collects information about a station that
@@ -330,20 +372,7 @@ struct ieee80211_fast_tx {
  * @tid_seq: per-TID sequence numbers for sending to this STA
  * @ampdu_mlme: A-MPDU state machine state
  * @timer_to_tid: identity mapping to ID timers
- * @plink_lock: serialize access to plink fields
- * @llid: Local link ID
- * @plid: Peer link ID
- * @reason: Cancel reason on PLINK_HOLDING state
- * @plink_retries: Retries in establishment
- * @plink_state: peer link state
- * @plink_timeout: timeout of peer link
- * @plink_timer: peer link watch timer
- * @t_offset: timing offset relative to this host
- * @t_offset_setpoint: reference timing offset of this sta to be used when
- * 	calculating clockdrift
- * @local_pm: local link-specific power save mode
- * @peer_pm: peer-specific power save mode towards local STA
- * @nonpeer_pm: STA power save mode towards non-peer neighbors
+ * @mesh: mesh STA information
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -371,8 +400,6 @@ struct ieee80211_fast_tx {
  * @rx_msdu: MSDUs received from this station, using IEEE80211_NUM_TID
  *	entry for non-QoS frames
  * @fast_tx: TX fastpath information
- * @processed_beacon: set to true after peer rates and capabilities are
- *	processed
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -392,6 +419,10 @@ struct sta_info {
 
 	struct ieee80211_fast_tx __rcu *fast_tx;
 
+#ifdef CONFIG_MAC80211_MESH
+	struct mesh_sta *mesh;
+#endif
+
 	struct work_struct drv_deliver_wk;
 
 	u16 listen_interval;
@@ -457,29 +488,6 @@ struct sta_info {
 	struct sta_ampdu_mlme ampdu_mlme;
 	u8 timer_to_tid[IEEE80211_NUM_TIDS];
 
-#ifdef CONFIG_MAC80211_MESH
-	/*
-	 * Mesh peer link attributes, protected by plink_lock.
-	 * TODO: move to a sub-structure that is referenced with pointer?
-	 */
-	spinlock_t plink_lock;
-	u16 llid;
-	u16 plid;
-	u16 reason;
-	u8 plink_retries;
-	enum nl80211_plink_state plink_state;
-	u32 plink_timeout;
-	struct timer_list plink_timer;
-
-	s64 t_offset;
-	s64 t_offset_setpoint;
-	/* mesh power save */
-	enum nl80211_mesh_power_mode local_pm;
-	enum nl80211_mesh_power_mode peer_pm;
-	enum nl80211_mesh_power_mode nonpeer_pm;
-	bool processed_beacon;
-#endif
-
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct sta_info_debugfsdentries {
 		struct dentry *dir;
@@ -507,7 +515,7 @@ struct sta_info {
 static inline enum nl80211_plink_state sta_plink_state(struct sta_info *sta)
 {
 #ifdef CONFIG_MAC80211_MESH
-	return sta->plink_state;
+	return sta->mesh->plink_state;
 #endif
 	return NL80211_PLINK_LISTEN;
 }
-- 
2.1.4

