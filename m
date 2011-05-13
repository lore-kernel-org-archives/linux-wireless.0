Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34990 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1EMRp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 13:45:58 -0400
Received: by pzk9 with SMTP id 9so1260870pzk.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 10:45:58 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH] nl80211: Move peer link state definition to nl80211
Date: Fri, 13 May 2011 10:45:43 -0700
Message-Id: <1305308743-30048-1-git-send-email-javier@cozybit.com> (sfid-20110513_194602_835432_AF1858A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These definitions need to be exposed now that we can set the peer link
states via NL80211_ATTR_STA_PLINK_STATE.  They were already being
(opaquely) reported by NL80211_STA_INFO_PLINK_STATE.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h   |   41 +++++++++++++++++++++++--
 include/net/cfg80211.h    |   27 -----------------
 net/mac80211/cfg.c        |    6 ++--
 net/mac80211/mesh_plink.c |   72 ++++++++++++++++++++++----------------------
 net/mac80211/rx.c         |    2 +-
 net/mac80211/sta_info.c   |    2 +-
 net/mac80211/sta_info.h   |    6 ++--
 net/wireless/nl80211.c    |    2 +-
 8 files changed, 83 insertions(+), 75 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 9f2c8f2..0948d55 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -940,9 +940,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_SUPPORT_MESH_AUTH: Currently, this means the underlying driver
  *	allows auth frames in a mesh to be passed to userspace for processing via
  *	the @NL80211_MESH_SETUP_USERSPACE_AUTH flag.
- * @NL80211_ATTR_STA_PLINK_STATE: The state of a mesh peer link. Used when
- *      userspace is driving the peer link management state machine.
- *      @NL80211_MESH_SETUP_USERSPACE_AMPE must be enabled.
+ * @NL80211_ATTR_STA_PLINK_STATE: The state of a mesh peer link as
+ *	defined in &enum nl80211_plink_state. Used when userspace is
+ *	driving the peer link management state machine.
+ *	@NL80211_MESH_SETUP_USERSPACE_AMPE must be enabled.
  *
  * @NL80211_ATTR_WOWLAN_SUPPORTED: indicates, as part of the wiphy capabilities,
  *	the supported WoWLAN triggers
@@ -1350,6 +1351,7 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_LLID: the station's mesh LLID
  * @NL80211_STA_INFO_PLID: the station's mesh PLID
  * @NL80211_STA_INFO_PLINK_STATE: peer link state for the station
+ *	(see %enum nl80211_plink_state)
  * @NL80211_STA_INFO_RX_BITRATE: last unicast data frame rx rate, nested
  *	attribute, like NL80211_STA_INFO_TX_BITRATE.
  * @NL80211_STA_INFO_BSS_PARAM: current station's view of BSS, nested attribute
@@ -2206,4 +2208,37 @@ enum nl80211_wowlan_triggers {
 	MAX_NL80211_WOWLAN_TRIG = NUM_NL80211_WOWLAN_TRIG - 1
 };
 
+
+/**
+ * enum nl80211_plink_state - state of a mesh peer link finite state machine
+ *
+ * @NL80211_PLINK_LISTEN: initial state, considered the implicit
+ *	state of non existant mesh peer links
+ * @NL80211_PLINK_OPN_SNT: mesh plink open frame has been sent to
+ *	this mesh peer
+ * @NL80211_PLINK_OPN_RCVD: mesh plink open frame has been received
+ *	from this mesh peer
+ * @NL80211_PLINK_CNF_RCVD: mesh plink confirm frame has been
+ *	received from this mesh peer
+ * @NL80211_PLINK_ESTAB: mesh peer link is established
+ * @NL80211_PLINK_HOLDING: mesh peer link is being closed or cancelled
+ * @NL80211_PLINK_BLOCKED: all frames transmitted from this mesh
+ *	plink are discarded
+ * @NUM_NL80211_PLINK_STATES: number of peer link states
+ * @MAX_NL80211_PLINK_STATES: highest numerical value of plink states
+ */
+enum nl80211_plink_state {
+	NL80211_PLINK_LISTEN,
+	NL80211_PLINK_OPN_SNT,
+	NL80211_PLINK_OPN_RCVD,
+	NL80211_PLINK_CNF_RCVD,
+	NL80211_PLINK_ESTAB,
+	NL80211_PLINK_HOLDING,
+	NL80211_PLINK_BLOCKED,
+
+	/* keep last */
+	NUM_NL80211_PLINK_STATES,
+	MAX_NL80211_PLINK_STATES = NUM_NL80211_PLINK_STATES - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e1f1b41..6416f53 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -372,33 +372,6 @@ enum plink_actions {
 };
 
 /**
- * enum plink_states - state of a mesh peer link finite state machine
- *
- * @PLINK_LISTEN: initial state, considered the implicit state of non
- * existant mesh peer links
- * @PLINK_OPN_SNT: mesh plink open frame has been sent to this mesh
- * peer @PLINK_OPN_RCVD: mesh plink open frame has been received from
- * this mesh peer
- * @PLINK_CNF_RCVD: mesh plink confirm frame has been received from
- * this mesh peer
- * @PLINK_ESTAB: mesh peer link is established
- * @PLINK_HOLDING: mesh peer link is being closed or cancelled
- * @PLINK_BLOCKED: all frames transmitted from this mesh plink are
- * discarded
- * @PLINK_INVALID: reserved
- */
-enum plink_state {
-	PLINK_LISTEN,
-	PLINK_OPN_SNT,
-	PLINK_OPN_RCVD,
-	PLINK_CNF_RCVD,
-	PLINK_ESTAB,
-	PLINK_HOLDING,
-	PLINK_BLOCKED,
-	PLINK_INVALID,
-};
-
-/**
  * struct station_parameters - station parameters
  *
  * Used to change and create a new station.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2d1c1a5..008cca1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -733,9 +733,9 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 #ifdef CONFIG_MAC80211_MESH
 		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED)
 			switch (params->plink_state) {
-			case PLINK_LISTEN:
-			case PLINK_ESTAB:
-			case PLINK_BLOCKED:
+			case NL80211_PLINK_LISTEN:
+			case NL80211_PLINK_ESTAB:
+			case NL80211_PLINK_BLOCKED:
 				sta->plink_state = params->plink_state;
 				break;
 			default:
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 2c37bee..f4adc09 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -83,7 +83,7 @@ void mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
  */
 static inline void mesh_plink_fsm_restart(struct sta_info *sta)
 {
-	sta->plink_state = PLINK_LISTEN;
+	sta->plink_state = NL80211_PLINK_LISTEN;
 	sta->llid = sta->plid = sta->reason = 0;
 	sta->plink_retries = 0;
 }
@@ -126,11 +126,11 @@ static bool __mesh_plink_deactivate(struct sta_info *sta)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	bool deactivated = false;
 
-	if (sta->plink_state == PLINK_ESTAB) {
+	if (sta->plink_state == NL80211_PLINK_ESTAB) {
 		mesh_plink_dec_estab_count(sdata);
 		deactivated = true;
 	}
-	sta->plink_state = PLINK_BLOCKED;
+	sta->plink_state = NL80211_PLINK_BLOCKED;
 	mesh_path_flush_by_nexthop(sta);
 
 	return deactivated;
@@ -268,7 +268,7 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 	sta->last_rx = jiffies;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
 	if (mesh_peer_accepts_plinks(elems) &&
-			sta->plink_state == PLINK_LISTEN &&
+			sta->plink_state == NL80211_PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
 			sdata->u.mesh.mshcfg.auto_open_plinks)
 		mesh_plink_open(sta);
@@ -308,8 +308,8 @@ static void mesh_plink_timer(unsigned long data)
 	sdata = sta->sdata;
 
 	switch (sta->plink_state) {
-	case PLINK_OPN_RCVD:
-	case PLINK_OPN_SNT:
+	case NL80211_PLINK_OPN_RCVD:
+	case NL80211_PLINK_OPN_SNT:
 		/* retry timer */
 		if (sta->plink_retries < dot11MeshMaxRetries(sdata)) {
 			u32 rand;
@@ -328,17 +328,17 @@ static void mesh_plink_timer(unsigned long data)
 		}
 		reason = cpu_to_le16(MESH_MAX_RETRIES);
 		/* fall through on else */
-	case PLINK_CNF_RCVD:
+	case NL80211_PLINK_CNF_RCVD:
 		/* confirm timer */
 		if (!reason)
 			reason = cpu_to_le16(MESH_CONFIRM_TIMEOUT);
-		sta->plink_state = PLINK_HOLDING;
+		sta->plink_state = NL80211_PLINK_HOLDING;
 		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 		spin_unlock_bh(&sta->lock);
 		mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid, plid,
 				    reason);
 		break;
-	case PLINK_HOLDING:
+	case NL80211_PLINK_HOLDING:
 		/* holding timer */
 		del_timer(&sta->plink_timer);
 		mesh_plink_fsm_restart(sta);
@@ -386,11 +386,11 @@ int mesh_plink_open(struct sta_info *sta)
 	spin_lock_bh(&sta->lock);
 	get_random_bytes(&llid, 2);
 	sta->llid = llid;
-	if (sta->plink_state != PLINK_LISTEN) {
+	if (sta->plink_state != NL80211_PLINK_LISTEN) {
 		spin_unlock_bh(&sta->lock);
 		return -EBUSY;
 	}
-	sta->plink_state = PLINK_OPN_SNT;
+	sta->plink_state = NL80211_PLINK_OPN_SNT;
 	mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
 	spin_unlock_bh(&sta->lock);
 	mpl_dbg("Mesh plink: starting establishment with %pM\n",
@@ -407,7 +407,7 @@ void mesh_plink_block(struct sta_info *sta)
 
 	spin_lock_bh(&sta->lock);
 	deactivated = __mesh_plink_deactivate(sta);
-	sta->plink_state = PLINK_BLOCKED;
+	sta->plink_state = NL80211_PLINK_BLOCKED;
 	spin_unlock_bh(&sta->lock);
 
 	if (deactivated)
@@ -430,13 +430,13 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	__le16 plid, llid, reason;
 #ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
 	static const char *mplstates[] = {
-		[PLINK_LISTEN] = "LISTEN",
-		[PLINK_OPN_SNT] = "OPN-SNT",
-		[PLINK_OPN_RCVD] = "OPN-RCVD",
-		[PLINK_CNF_RCVD] = "CNF_RCVD",
-		[PLINK_ESTAB] = "ESTAB",
-		[PLINK_HOLDING] = "HOLDING",
-		[PLINK_BLOCKED] = "BLOCKED"
+		[NL80211_PLINK_LISTEN] = "LISTEN",
+		[NL80211_PLINK_OPN_SNT] = "OPN-SNT",
+		[NL80211_PLINK_OPN_RCVD] = "OPN-RCVD",
+		[NL80211_PLINK_CNF_RCVD] = "CNF_RCVD",
+		[NL80211_PLINK_ESTAB] = "ESTAB",
+		[NL80211_PLINK_HOLDING] = "HOLDING",
+		[NL80211_PLINK_BLOCKED] = "BLOCKED"
 	};
 #endif
 
@@ -502,7 +502,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		return;
 	}
 
-	if (sta && sta->plink_state == PLINK_BLOCKED) {
+	if (sta && sta->plink_state == NL80211_PLINK_BLOCKED) {
 		rcu_read_unlock();
 		return;
 	}
@@ -572,7 +572,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 				event = CNF_ACPT;
 			break;
 		case PLINK_CLOSE:
-			if (sta->plink_state == PLINK_ESTAB)
+			if (sta->plink_state == NL80211_PLINK_ESTAB)
 				/* Do not check for llid or plid. This does not
 				 * follow the standard but since multiple plinks
 				 * per sta are not supported, it is necessary in
@@ -607,14 +607,14 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	reason = 0;
 	switch (sta->plink_state) {
 		/* spin_unlock as soon as state is updated at each case */
-	case PLINK_LISTEN:
+	case NL80211_PLINK_LISTEN:
 		switch (event) {
 		case CLS_ACPT:
 			mesh_plink_fsm_restart(sta);
 			spin_unlock_bh(&sta->lock);
 			break;
 		case OPN_ACPT:
-			sta->plink_state = PLINK_OPN_RCVD;
+			sta->plink_state = NL80211_PLINK_OPN_RCVD;
 			sta->plid = plid;
 			get_random_bytes(&llid, 2);
 			sta->llid = llid;
@@ -631,7 +631,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		}
 		break;
 
-	case PLINK_OPN_SNT:
+	case NL80211_PLINK_OPN_SNT:
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
@@ -640,7 +640,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			if (!reason)
 				reason = cpu_to_le16(MESH_CLOSE_RCVD);
 			sta->reason = reason;
-			sta->plink_state = PLINK_HOLDING;
+			sta->plink_state = NL80211_PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
 					     dot11MeshHoldingTimeout(sdata)))
 				sta->ignore_plink_timer = true;
@@ -652,7 +652,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			break;
 		case OPN_ACPT:
 			/* retry timer is left untouched */
-			sta->plink_state = PLINK_OPN_RCVD;
+			sta->plink_state = NL80211_PLINK_OPN_RCVD;
 			sta->plid = plid;
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
@@ -660,7 +660,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 					    plid, 0);
 			break;
 		case CNF_ACPT:
-			sta->plink_state = PLINK_CNF_RCVD;
+			sta->plink_state = NL80211_PLINK_CNF_RCVD;
 			if (!mod_plink_timer(sta,
 					     dot11MeshConfirmTimeout(sdata)))
 				sta->ignore_plink_timer = true;
@@ -673,7 +673,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		}
 		break;
 
-	case PLINK_OPN_RCVD:
+	case NL80211_PLINK_OPN_RCVD:
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
@@ -682,7 +682,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			if (!reason)
 				reason = cpu_to_le16(MESH_CLOSE_RCVD);
 			sta->reason = reason;
-			sta->plink_state = PLINK_HOLDING;
+			sta->plink_state = NL80211_PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
 					     dot11MeshHoldingTimeout(sdata)))
 				sta->ignore_plink_timer = true;
@@ -700,7 +700,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			break;
 		case CNF_ACPT:
 			del_timer(&sta->plink_timer);
-			sta->plink_state = PLINK_ESTAB;
+			sta->plink_state = NL80211_PLINK_ESTAB;
 			spin_unlock_bh(&sta->lock);
 			mesh_plink_inc_estab_count(sdata);
 			ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
@@ -713,7 +713,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		}
 		break;
 
-	case PLINK_CNF_RCVD:
+	case NL80211_PLINK_CNF_RCVD:
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
@@ -722,7 +722,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			if (!reason)
 				reason = cpu_to_le16(MESH_CLOSE_RCVD);
 			sta->reason = reason;
-			sta->plink_state = PLINK_HOLDING;
+			sta->plink_state = NL80211_PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
 					     dot11MeshHoldingTimeout(sdata)))
 				sta->ignore_plink_timer = true;
@@ -734,7 +734,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			break;
 		case OPN_ACPT:
 			del_timer(&sta->plink_timer);
-			sta->plink_state = PLINK_ESTAB;
+			sta->plink_state = NL80211_PLINK_ESTAB;
 			spin_unlock_bh(&sta->lock);
 			mesh_plink_inc_estab_count(sdata);
 			ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
@@ -749,13 +749,13 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		}
 		break;
 
-	case PLINK_ESTAB:
+	case NL80211_PLINK_ESTAB:
 		switch (event) {
 		case CLS_ACPT:
 			reason = cpu_to_le16(MESH_CLOSE_RCVD);
 			sta->reason = reason;
 			deactivated = __mesh_plink_deactivate(sta);
-			sta->plink_state = PLINK_HOLDING;
+			sta->plink_state = NL80211_PLINK_HOLDING;
 			llid = sta->llid;
 			mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 			spin_unlock_bh(&sta->lock);
@@ -775,7 +775,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			break;
 		}
 		break;
-	case PLINK_HOLDING:
+	case NL80211_PLINK_HOLDING:
 		switch (event) {
 		case CLS_ACPT:
 			if (del_timer(&sta->plink_timer))
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b6bde2e..5b2d6f4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -490,7 +490,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 	 * establisment frame, beacon or probe, drop the frame.
 	 */
 
-	if (!rx->sta || sta_plink_state(rx->sta) != PLINK_ESTAB) {
+	if (!rx->sta || sta_plink_state(rx->sta) != NL80211_PLINK_ESTAB) {
 		struct ieee80211_mgmt *mgmt;
 
 		if (!ieee80211_is_mgmt(hdr->frame_control))
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9d04129..7f58220 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -274,7 +274,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 #ifdef CONFIG_MAC80211_MESH
-	sta->plink_state = PLINK_LISTEN;
+	sta->plink_state = NL80211_PLINK_LISTEN;
 	init_timer(&sta->plink_timer);
 #endif
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f00b4dc..b5fd9c5 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -316,7 +316,7 @@ struct sta_info {
 	u8 plink_retries;
 	bool ignore_plink_timer;
 	bool plink_timer_was_running;
-	enum plink_state plink_state;
+	enum nl80211_plink_state plink_state;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
 #endif
@@ -334,12 +334,12 @@ struct sta_info {
 	struct ieee80211_sta sta;
 };
 
-static inline enum plink_state sta_plink_state(struct sta_info *sta)
+static inline enum nl80211_plink_state sta_plink_state(struct sta_info *sta)
 {
 #ifdef CONFIG_MAC80211_MESH
 	return sta->plink_state;
 #endif
-	return PLINK_LISTEN;
+	return NL80211_PLINK_LISTEN;
 }
 
 static inline void set_sta_flags(struct sta_info *sta, const u32 flags)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9ef8e28..03f9a60 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2258,7 +2258,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	memset(&params, 0, sizeof(params));
 
 	params.listen_interval = -1;
-	params.plink_state = PLINK_INVALID;
+	params.plink_state = -1;
 
 	if (info->attrs[NL80211_ATTR_STA_AID])
 		return -EINVAL;
-- 
1.7.1

