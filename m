Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:23981 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbYCCUUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 15:20:54 -0500
Received: by wa-out-1112.google.com with SMTP id v27so277416wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 12:20:53 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 29 Feb 2008 15:46:08 -0800
Subject: [PATCH 08/10] mac80211: add PLINK_ prefix and kernel doc to enum plink_state
Message-ID: <47cc5da3.1dba720a.4da5.ffffaa95@mx.google.com> (sfid-20080303_202100_907515_8A09ECA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh.c         |    6 ++--
 net/mac80211/mesh_pathtbl.c |    6 ++--
 net/mac80211/mesh_plink.c   |   69 ++++++++++++++++++++++---------------------
 net/mac80211/rx.c           |    2 +-
 net/mac80211/sta_info.c     |    2 +-
 net/mac80211/sta_info.h     |   31 +++++++++++++-----
 6 files changed, 65 insertions(+), 51 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 54d5ced..594a335 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -91,9 +91,9 @@ void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 
 	/* In case mesh_plink_free_count > 0 and mesh_plinktbl_capacity == 0,
 	 * the mesh interface might be able to establish plinks with peers that
-	 * are already on the table but are not on ESTAB state. However, in
-	 * general the mesh interface is not accepting peer link requests from
-	 * new peers, and that must be reflected in the beacon
+	 * are already on the table but are not on PLINK_ESTAB state. However,
+	 * in general the mesh interface is not accepting peer link requests
+	 * from new peers, and that must be reflected in the beacon
 	 */
 	free_plinks = mesh_plink_availables(sdata);
 
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index f74e4ce..135022d 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -261,9 +261,9 @@ EXPORT_SYMBOL(mesh_plink_broken);
  *
  * @sta - mesh peer to match
  *
- * RCU notes: this function is called when a mesh plink transitions from ESTAB
- * to any other state, since ESTAB state is the only one that allows path
- * creation. This will happen before the sta can be freed (because
+ * RCU notes: this function is called when a mesh plink transitions from
+ * PLINK_ESTAB to any other state, since PLINK_ESTAB state is the only one that
+ * allows path creation. This will happen before the sta can be freed (because
  * sta_info_destroy() calls this) so any reader in a rcu read block will be
  * protected against the plink disappearing.
  */
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 23d951a..18fe524 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -84,7 +84,7 @@ void mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
  */
 static inline void mesh_plink_fsm_restart(struct sta_info *sta)
 {
-	sta->plink_state = LISTEN;
+	sta->plink_state = PLINK_LISTEN;
 	sta->llid = sta->plid = sta->reason = 0;
 	sta->plink_retries = 0;
 }
@@ -121,9 +121,9 @@ static void __mesh_plink_deactivate(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
-	if (sta->plink_state == ESTAB)
+	if (sta->plink_state == PLINK_ESTAB)
 		mesh_plink_dec_estab_count(sdata);
-	sta->plink_state = BLOCKED;
+	sta->plink_state = PLINK_BLOCKED;
 	mesh_path_flush_by_nexthop(sta);
 }
 
@@ -243,7 +243,7 @@ void mesh_neighbour_update(u8 *hw_addr, u64 rates, struct net_device *dev,
 
 	sta->last_rx = jiffies;
 	sta->supp_rates[local->hw.conf.channel->band] = rates;
-	if (peer_accepting_plinks && sta->plink_state == LISTEN &&
+	if (peer_accepting_plinks && sta->plink_state == PLINK_LISTEN &&
 			sdata->u.sta.accepting_plinks &&
 			sdata->u.sta.mshcfg.auto_open_plinks)
 		mesh_plink_open(sta);
@@ -283,8 +283,8 @@ static void mesh_plink_timer(unsigned long data)
 	dev = sdata->dev;
 
 	switch (sta->plink_state) {
-	case OPN_RCVD:
-	case OPN_SNT:
+	case PLINK_OPN_RCVD:
+	case PLINK_OPN_SNT:
 		/* retry timer */
 		if (sta->plink_retries < dot11MeshMaxRetries(sdata)) {
 			u32 rand;
@@ -303,17 +303,17 @@ static void mesh_plink_timer(unsigned long data)
 		}
 		reason = cpu_to_le16(MESH_MAX_RETRIES);
 		/* fall through on else */
-	case CNF_RCVD:
+	case PLINK_CNF_RCVD:
 		/* confirm timer */
 		if (!reason)
 			reason = cpu_to_le16(MESH_CONFIRM_TIMEOUT);
-		sta->plink_state = HOLDING;
+		sta->plink_state = PLINK_HOLDING;
 		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 		spin_unlock_bh(&sta->plink_lock);
 		mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid, plid,
 				    reason);
 		break;
-	case HOLDING:
+	case PLINK_HOLDING:
 		/* holding timer */
 		del_timer(&sta->plink_timer);
 		mesh_plink_fsm_restart(sta);
@@ -345,11 +345,11 @@ int mesh_plink_open(struct sta_info *sta)
 	spin_lock_bh(&sta->plink_lock);
 	get_random_bytes(&llid, 2);
 	sta->llid = llid;
-	if (sta->plink_state != LISTEN) {
+	if (sta->plink_state != PLINK_LISTEN) {
 		spin_unlock_bh(&sta->plink_lock);
 		return -EBUSY;
 	}
-	sta->plink_state = OPN_SNT;
+	sta->plink_state = PLINK_OPN_SNT;
 	mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
 	spin_unlock_bh(&sta->plink_lock);
 	mpl_dbg("Mesh plink: starting establishment with %s\n",
@@ -367,7 +367,7 @@ void mesh_plink_block(struct sta_info *sta)
 
 	spin_lock_bh(&sta->plink_lock);
 	__mesh_plink_deactivate(sta);
-	sta->plink_state = BLOCKED;
+	sta->plink_state = PLINK_BLOCKED;
 	spin_unlock_bh(&sta->plink_lock);
 }
 
@@ -385,18 +385,19 @@ int mesh_plink_close(struct sta_info *sta)
 	sta->reason = cpu_to_le16(MESH_LINK_CANCELLED);
 	reason = sta->reason;
 
-	if (sta->plink_state == LISTEN || sta->plink_state == BLOCKED) {
+	if (sta->plink_state == PLINK_LISTEN ||
+	    sta->plink_state == PLINK_BLOCKED) {
 		mesh_plink_fsm_restart(sta);
 		spin_unlock_bh(&sta->plink_lock);
 		return 0;
-	} else if (sta->plink_state == ESTAB) {
+	} else if (sta->plink_state == PLINK_ESTAB) {
 		__mesh_plink_deactivate(sta);
 		/* The timer should not be running */
 		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 	} else if (!mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata)))
 		sta->ignore_plink_timer = true;
 
-	sta->plink_state = HOLDING;
+	sta->plink_state = PLINK_HOLDING;
 	llid = sta->llid;
 	plid = sta->plid;
 	spin_unlock_bh(&sta->plink_lock);
@@ -468,7 +469,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 		return;
 	}
 
-	if (sta && sta->plink_state == BLOCKED) {
+	if (sta && sta->plink_state == PLINK_BLOCKED) {
 		rcu_read_unlock();
 		return;
 	}
@@ -529,7 +530,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 				event = CNF_ACPT;
 			break;
 		case PLINK_CLOSE:
-			if (sta->plink_state == ESTAB)
+			if (sta->plink_state == PLINK_ESTAB)
 				/* Do not check for llid or plid. This does not
 				 * follow the standard but since multiple plinks
 				 * per sta are not supported, it is necessary in
@@ -562,14 +563,14 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 	reason = 0;
 	switch (sta->plink_state) {
 		/* spin_unlock as soon as state is updated at each case */
-	case LISTEN:
+	case PLINK_LISTEN:
 		switch (event) {
 		case CLS_ACPT:
 			mesh_plink_fsm_restart(sta);
 			spin_unlock_bh(&sta->plink_lock);
 			break;
 		case OPN_ACPT:
-			sta->plink_state = OPN_RCVD;
+			sta->plink_state = PLINK_OPN_RCVD;
 			sta->plid = plid;
 			get_random_bytes(&llid, 2);
 			sta->llid = llid;
@@ -586,7 +587,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 		}
 		break;
 
-	case OPN_SNT:
+	case PLINK_OPN_SNT:
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
@@ -595,7 +596,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 			if (!reason)
 				reason = cpu_to_le16(MESH_CLOSE_RCVD);
 			sta->reason = reason;
-			sta->plink_state = HOLDING;
+			sta->plink_state = PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
 					     dot11MeshHoldingTimeout(sdata)))
 				sta->ignore_plink_timer = true;
@@ -607,7 +608,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 			break;
 		case OPN_ACPT:
 			/* retry timer is left untouched */
-			sta->plink_state = OPN_RCVD;
+			sta->plink_state = PLINK_OPN_RCVD;
 			sta->plid = plid;
 			llid = sta->llid;
 			spin_unlock_bh(&sta->plink_lock);
@@ -615,7 +616,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 					    plid, 0);
 			break;
 		case CNF_ACPT:
-			sta->plink_state = CNF_RCVD;
+			sta->plink_state = PLINK_CNF_RCVD;
 			if (!mod_plink_timer(sta,
 					     dot11MeshConfirmTimeout(sdata)))
 				sta->ignore_plink_timer = true;
@@ -628,7 +629,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 		}
 		break;
 
-	case OPN_RCVD:
+	case PLINK_OPN_RCVD:
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
@@ -637,7 +638,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 			if (!reason)
 				reason = cpu_to_le16(MESH_CLOSE_RCVD);
 			sta->reason = reason;
-			sta->plink_state = HOLDING;
+			sta->plink_state = PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
 					     dot11MeshHoldingTimeout(sdata)))
 				sta->ignore_plink_timer = true;
@@ -655,7 +656,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 			break;
 		case CNF_ACPT:
 			del_timer(&sta->plink_timer);
-			sta->plink_state = ESTAB;
+			sta->plink_state = PLINK_ESTAB;
 			mesh_plink_inc_estab_count(sdata);
 			spin_unlock_bh(&sta->plink_lock);
 			mpl_dbg("Mesh plink with %s ESTABLISHED\n",
@@ -667,7 +668,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 		}
 		break;
 
-	case CNF_RCVD:
+	case PLINK_CNF_RCVD:
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
@@ -676,7 +677,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 			if (!reason)
 				reason = cpu_to_le16(MESH_CLOSE_RCVD);
 			sta->reason = reason;
-			sta->plink_state = HOLDING;
+			sta->plink_state = PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
 					     dot11MeshHoldingTimeout(sdata)))
 				sta->ignore_plink_timer = true;
@@ -688,7 +689,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 			break;
 		case OPN_ACPT:
 			del_timer(&sta->plink_timer);
-			sta->plink_state = ESTAB;
+			sta->plink_state = PLINK_ESTAB;
 			mesh_plink_inc_estab_count(sdata);
 			spin_unlock_bh(&sta->plink_lock);
 			mpl_dbg("Mesh plink with %s ESTABLISHED\n",
@@ -702,13 +703,13 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 		}
 		break;
 
-	case ESTAB:
+	case PLINK_ESTAB:
 		switch (event) {
 		case CLS_ACPT:
 			reason = cpu_to_le16(MESH_CLOSE_RCVD);
 			sta->reason = reason;
 			__mesh_plink_deactivate(sta);
-			sta->plink_state = HOLDING;
+			sta->plink_state = PLINK_HOLDING;
 			llid = sta->llid;
 			mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 			spin_unlock_bh(&sta->plink_lock);
@@ -726,7 +727,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 			break;
 		}
 		break;
-	case HOLDING:
+	case PLINK_HOLDING:
 		switch (event) {
 		case CLS_ACPT:
 			if (del_timer(&sta->plink_timer))
@@ -749,8 +750,8 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 		}
 		break;
 	default:
-		/* should not get here, BLOCKED is dealt with at the beggining
-		 * of the function
+		/* should not get here, PLINK_BLOCKED is dealt with at the
+		 * beggining of the function
 		 */
 		spin_unlock_bh(&sta->plink_lock);
 		break;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8e1e285..644d277 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -411,7 +411,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 	 * establisment frame, beacon or probe, drop the frame.
 	 */
 
-	if (!rx->sta || sta_plink_state(rx->sta) != ESTAB) {
+	if (!rx->sta || sta_plink_state(rx->sta) != PLINK_ESTAB) {
 		struct ieee80211_mgmt *mgmt;
 
 		if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT)
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 909fa38..e27f896 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -248,7 +248,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 #ifdef CONFIG_MAC80211_MESH
-	sta->plink_state = LISTEN;
+	sta->plink_state = PLINK_LISTEN;
 	spin_lock_init(&sta->plink_lock);
 	init_timer(&sta->plink_timer);
 #endif
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 547bfc3..f166c80 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -106,14 +106,27 @@ struct tid_ampdu_rx {
 	struct timer_list session_timer;
 };
 
+/**
+ * enum plink_state - state of a mesh peer link finite state machine
+ *
+ * @PLINK_LISTEN: initial state, considered the implicit state of non existant
+ * 	mesh peer links
+ * @PLINK_OPN_SNT: mesh plink open frame has been sent to this mesh peer
+ * @PLINK_OPN_RCVD: mesh plink open frame has been received from this mesh peer
+ * @PLINK_CNF_RCVD: mesh plink confirm frame has been received from this mesh
+ * 	peer
+ * @PLINK_ESTAB: mesh peer link is established
+ * @PLINK_HOLDING: mesh peer link is being closed or cancelled
+ * @PLINK_BLOCKED: all frames transmitted from this mesh plink are discarded
+ */
 enum plink_state {
-	LISTEN,
-	OPN_SNT,
-	OPN_RCVD,
-	CNF_RCVD,
-	ESTAB,
-	HOLDING,
-	BLOCKED
+	PLINK_LISTEN,
+	PLINK_OPN_SNT,
+	PLINK_OPN_RCVD,
+	PLINK_CNF_RCVD,
+	PLINK_ESTAB,
+	PLINK_HOLDING,
+	PLINK_BLOCKED
 };
 
 /**
@@ -248,7 +261,7 @@ struct sta_info {
 	 */
 	__le16 llid;		/* Local link ID */
 	__le16 plid;		/* Peer link ID */
-	__le16 reason;		/* Buffer for cancel reason on HOLDING state */
+	__le16 reason;		/* Cancel reason on PLINK_HOLDING state */
 	u8 plink_retries;	/* Retries in establishment */
 	bool ignore_plink_timer;
 	enum plink_state plink_state;
@@ -280,7 +293,7 @@ static inline enum plink_state sta_plink_state(struct sta_info *sta)
 #ifdef CONFIG_MAC80211_MESH
 	return sta->plink_state;
 #endif
-	return LISTEN;
+	return PLINK_LISTEN;
 }
 
 
-- 
1.5.2.5



