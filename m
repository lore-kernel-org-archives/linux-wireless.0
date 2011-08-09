Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:34596 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1HITv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 15:51:28 -0400
Received: by yie30 with SMTP id 30so247622yie.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 12:51:27 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 3/6] mac80211: update mesh peering frame codes
Date: Tue,  9 Aug 2011 12:50:15 -0700
Message-Id: <1312919418-32196-4-git-send-email-thomas@cozybit.com> (sfid-20110809_215131_287712_68B0A2A6)
In-Reply-To: <1312919418-32196-1-git-send-email-thomas@cozybit.com>
References: <1312919418-32196-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have the mesh peering frames use the self-protected action and reason codes
specified in 802.11s and defined in ieee80211.h. Remove the local enums.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |  154 +++++++++++++++++++++------------------------
 1 files changed, 73 insertions(+), 81 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index d582059..a598a08 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -25,29 +25,12 @@
 #define mod_plink_timer(s, t) (mod_timer(&s->plink_timer, \
 				jiffies + HZ * t / 1000))
 
-/* Peer link cancel reasons, all subject to ANA approval */
-#define MESH_LINK_CANCELLED			2
-#define MESH_MAX_NEIGHBORS			3
-#define MESH_CAPABILITY_POLICY_VIOLATION	4
-#define MESH_CLOSE_RCVD				5
-#define MESH_MAX_RETRIES			6
-#define MESH_CONFIRM_TIMEOUT			7
-#define MESH_SECURITY_ROLE_NEGOTIATION_DIFFERS	8
-#define MESH_SECURITY_AUTHENTICATION_IMPOSSIBLE	9
-#define MESH_SECURITY_FAILED_VERIFICATION	10
-
 #define dot11MeshMaxRetries(s) (s->u.mesh.mshcfg.dot11MeshMaxRetries)
 #define dot11MeshRetryTimeout(s) (s->u.mesh.mshcfg.dot11MeshRetryTimeout)
 #define dot11MeshConfirmTimeout(s) (s->u.mesh.mshcfg.dot11MeshConfirmTimeout)
 #define dot11MeshHoldingTimeout(s) (s->u.mesh.mshcfg.dot11MeshHoldingTimeout)
 #define dot11MeshMaxPeerLinks(s) (s->u.mesh.mshcfg.dot11MeshMaxPeerLinks)
 
-enum plink_frame_type {
-	PLINK_OPEN = 1,
-	PLINK_CONFIRM,
-	PLINK_CLOSE
-};
-
 enum plink_event {
 	PLINK_UNDEFINED,
 	OPN_ACPT,
@@ -157,8 +140,8 @@ void mesh_plink_deactivate(struct sta_info *sta)
 }
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
-		enum plink_frame_type action, u8 *da, __le16 llid, __le16 plid,
-		__le16 reason) {
+		enum ieee80211_self_protected_actioncode action,
+		u8 *da, __le16 llid, __le16 plid, __le16 reason) {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400 +
 			sdata->u.mesh.ie_len);
@@ -185,11 +168,11 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.category = WLAN_CATEGORY_MESH_ACTION;
 	mgmt->u.action.u.plink_action.action_code = action;
 
-	if (action == PLINK_CLOSE)
+	if (action == WLAN_SP_MESH_PEERING_CLOSE)
 		mgmt->u.action.u.plink_action.aux = reason;
 	else {
 		mgmt->u.action.u.plink_action.aux = cpu_to_le16(0x0);
-		if (action == PLINK_CONFIRM) {
+		if (action == WLAN_SP_MESH_PEERING_CONFIRM) {
 			pos = skb_put(skb, 4);
 			/* two-byte status code followed by two-byte AID */
 			memset(pos, 0, 2);
@@ -205,14 +188,14 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 
 	/* Add Peer Link Management element */
 	switch (action) {
-	case PLINK_OPEN:
+	case WLAN_SP_MESH_PEERING_OPEN:
 		ie_len = 6;
 		break;
-	case PLINK_CONFIRM:
+	case WLAN_SP_MESH_PEERING_CONFIRM:
 		ie_len = 8;
 		include_plid = true;
 		break;
-	case PLINK_CLOSE:
+	case WLAN_SP_MESH_PEERING_CLOSE:
 	default:
 		if (!plid)
 			ie_len = 8;
@@ -233,7 +216,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		pos += 2;
 		memcpy(pos, &plid, 2);
 	}
-	if (action == PLINK_CLOSE) {
+	if (action == WLAN_SP_MESH_PEERING_CLOSE) {
 		pos += 2;
 		memcpy(pos, &reason, 2);
 	}
@@ -327,21 +310,21 @@ static void mesh_plink_timer(unsigned long data)
 			++sta->plink_retries;
 			mod_plink_timer(sta, sta->plink_timeout);
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_OPEN, sta->sta.addr, llid,
-					    0, 0);
+			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
+					    sta->sta.addr, llid, 0, 0);
 			break;
 		}
-		reason = cpu_to_le16(MESH_MAX_RETRIES);
+		reason = cpu_to_le16(WLAN_REASON_MESH_MAX_RETRIES);
 		/* fall through on else */
 	case NL80211_PLINK_CNF_RCVD:
 		/* confirm timer */
 		if (!reason)
-			reason = cpu_to_le16(MESH_CONFIRM_TIMEOUT);
+			reason = cpu_to_le16(WLAN_REASON_MESH_CONFIRM_TIMEOUT);
 		sta->plink_state = NL80211_PLINK_HOLDING;
 		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 		spin_unlock_bh(&sta->lock);
-		mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid, plid,
-				    reason);
+		mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+				    sta->sta.addr, llid, plid, reason);
 		break;
 	case NL80211_PLINK_HOLDING:
 		/* holding timer */
@@ -401,7 +384,7 @@ int mesh_plink_open(struct sta_info *sta)
 	mpl_dbg("Mesh plink: starting establishment with %pM\n",
 		sta->sta.addr);
 
-	return mesh_plink_frame_tx(sdata, PLINK_OPEN,
+	return mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
 				   sta->sta.addr, llid, 0, 0);
 }
 
@@ -427,7 +410,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	struct ieee802_11_elems elems;
 	struct sta_info *sta;
 	enum plink_event event;
-	enum plink_frame_type ftype;
+	enum ieee80211_self_protected_actioncode ftype;
 	size_t baselen;
 	bool deactivated, matches_local = true;
 	u8 ie_len;
@@ -456,7 +439,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 
 	baseaddr = mgmt->u.action.u.plink_action.variable;
 	baselen = (u8 *) mgmt->u.action.u.plink_action.variable - (u8 *) mgmt;
-	if (mgmt->u.action.u.plink_action.action_code == PLINK_CONFIRM) {
+	if (mgmt->u.action.u.plink_action.action_code == WLAN_SP_MESH_PEERING_CONFIRM) {
 		baseaddr += 4;
 		baselen += 4;
 	}
@@ -473,15 +456,15 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 
 	ftype = mgmt->u.action.u.plink_action.action_code;
 	ie_len = elems.peer_link_len;
-	if ((ftype == PLINK_OPEN && ie_len != 6) ||
-	    (ftype == PLINK_CONFIRM && ie_len != 8) ||
-	    (ftype == PLINK_CLOSE && ie_len != 8 && ie_len != 10)) {
+	if ((ftype == WLAN_SP_MESH_PEERING_OPEN && ie_len != 6) ||
+	    (ftype == WLAN_SP_MESH_PEERING_CONFIRM && ie_len != 8) ||
+	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len != 8 && ie_len != 10)) {
 		mpl_dbg("Mesh plink: incorrect plink ie length %d %d\n",
 		    ftype, ie_len);
 		return;
 	}
 
-	if (ftype != PLINK_CLOSE && (!elems.mesh_id || !elems.mesh_config)) {
+	if (ftype != WLAN_SP_MESH_PEERING_CLOSE && (!elems.mesh_id || !elems.mesh_config)) {
 		mpl_dbg("Mesh plink: missing necessary ie\n");
 		return;
 	}
@@ -489,13 +472,14 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	 * from the point of view of this host.
 	 */
 	memcpy(&plid, PLINK_GET_LLID(elems.peer_link), 2);
-	if (ftype == PLINK_CONFIRM || (ftype == PLINK_CLOSE && ie_len == 10))
+	if (ftype == WLAN_SP_MESH_PEERING_CONFIRM ||
+	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len == 10))
 		memcpy(&llid, PLINK_GET_PLID(elems.peer_link), 2);
 
 	rcu_read_lock();
 
 	sta = sta_info_get(sdata, mgmt->sa);
-	if (!sta && ftype != PLINK_OPEN) {
+	if (!sta && ftype != WLAN_SP_MESH_PEERING_OPEN) {
 		mpl_dbg("Mesh plink: cls or cnf from unknown peer\n");
 		rcu_read_unlock();
 		return;
@@ -514,30 +498,30 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 
 	/* Now we will figure out the appropriate event... */
 	event = PLINK_UNDEFINED;
-	if (ftype != PLINK_CLOSE && (!mesh_matches_local(&elems, sdata))) {
+	if (ftype != WLAN_SP_MESH_PEERING_CLOSE &&
+	    (!mesh_matches_local(&elems, sdata))) {
 		matches_local = false;
 		switch (ftype) {
-		case PLINK_OPEN:
+		case WLAN_SP_MESH_PEERING_OPEN:
 			event = OPN_RJCT;
 			break;
-		case PLINK_CONFIRM:
+		case WLAN_SP_MESH_PEERING_CONFIRM:
 			event = CNF_RJCT;
 			break;
-		case PLINK_CLOSE:
-			/* avoid warning */
+		default:
 			break;
 		}
 	}
 
 	if (!sta && !matches_local) {
 		rcu_read_unlock();
-		reason = cpu_to_le16(MESH_CAPABILITY_POLICY_VIOLATION);
+		reason = cpu_to_le16(WLAN_REASON_MESH_CONFIG);
 		llid = 0;
-		mesh_plink_frame_tx(sdata, PLINK_CLOSE, mgmt->sa, llid,
-				    plid, reason);
+		mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+				    mgmt->sa, llid, plid, reason);
 		return;
 	} else if (!sta) {
-		/* ftype == PLINK_OPEN */
+		/* ftype == WLAN_SP_MESH_PEERING_OPEN */
 		u32 rates;
 
 		rcu_read_unlock();
@@ -562,21 +546,21 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	} else if (matches_local) {
 		spin_lock_bh(&sta->lock);
 		switch (ftype) {
-		case PLINK_OPEN:
+		case WLAN_SP_MESH_PEERING_OPEN:
 			if (!mesh_plink_free_count(sdata) ||
 			    (sta->plid && sta->plid != plid))
 				event = OPN_IGNR;
 			else
 				event = OPN_ACPT;
 			break;
-		case PLINK_CONFIRM:
+		case WLAN_SP_MESH_PEERING_CONFIRM:
 			if (!mesh_plink_free_count(sdata) ||
 			    (sta->llid != llid || sta->plid != plid))
 				event = CNF_IGNR;
 			else
 				event = CNF_ACPT;
 			break;
-		case PLINK_CLOSE:
+		case WLAN_SP_MESH_PEERING_CLOSE:
 			if (sta->plink_state == NL80211_PLINK_ESTAB)
 				/* Do not check for llid or plid. This does not
 				 * follow the standard but since multiple plinks
@@ -625,10 +609,12 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			sta->llid = llid;
 			mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_OPEN, sta->sta.addr, llid,
-					    0, 0);
-			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr,
-					    llid, plid, 0);
+			mesh_plink_frame_tx(sdata,
+					    WLAN_SP_MESH_PEERING_OPEN,
+					    sta->sta.addr, llid, 0, 0);
+			mesh_plink_frame_tx(sdata,
+					    WLAN_SP_MESH_PEERING_CONFIRM,
+					    sta->sta.addr, llid, plid, 0);
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
@@ -640,10 +626,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
-			reason = cpu_to_le16(MESH_CAPABILITY_POLICY_VIOLATION);
+			reason = cpu_to_le16(WLAN_REASON_MESH_CONFIG);
 		case CLS_ACPT:
 			if (!reason)
-				reason = cpu_to_le16(MESH_CLOSE_RCVD);
+				reason = cpu_to_le16(WLAN_REASON_MESH_CLOSE);
 			sta->reason = reason;
 			sta->plink_state = NL80211_PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
@@ -652,8 +638,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid,
-					    plid, reason);
+			mesh_plink_frame_tx(sdata,
+					    WLAN_SP_MESH_PEERING_CLOSE,
+					    sta->sta.addr, llid, plid, reason);
 			break;
 		case OPN_ACPT:
 			/* retry timer is left untouched */
@@ -661,8 +648,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			sta->plid = plid;
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr, llid,
-					    plid, 0);
+			mesh_plink_frame_tx(sdata,
+					    WLAN_SP_MESH_PEERING_CONFIRM,
+					    sta->sta.addr, llid, plid, 0);
 			break;
 		case CNF_ACPT:
 			sta->plink_state = NL80211_PLINK_CNF_RCVD;
@@ -682,10 +670,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
-			reason = cpu_to_le16(MESH_CAPABILITY_POLICY_VIOLATION);
+			reason = cpu_to_le16(WLAN_REASON_MESH_CONFIG);
 		case CLS_ACPT:
 			if (!reason)
-				reason = cpu_to_le16(MESH_CLOSE_RCVD);
+				reason = cpu_to_le16(WLAN_REASON_MESH_CLOSE);
 			sta->reason = reason;
 			sta->plink_state = NL80211_PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
@@ -694,14 +682,15 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid,
-					    plid, reason);
+			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+					    sta->sta.addr, llid, plid, reason);
 			break;
 		case OPN_ACPT:
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr, llid,
-					    plid, 0);
+			mesh_plink_frame_tx(sdata,
+					    WLAN_SP_MESH_PEERING_CONFIRM,
+					    sta->sta.addr, llid, plid, 0);
 			break;
 		case CNF_ACPT:
 			del_timer(&sta->plink_timer);
@@ -722,10 +711,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
-			reason = cpu_to_le16(MESH_CAPABILITY_POLICY_VIOLATION);
+			reason = cpu_to_le16(WLAN_REASON_MESH_CONFIG);
 		case CLS_ACPT:
 			if (!reason)
-				reason = cpu_to_le16(MESH_CLOSE_RCVD);
+				reason = cpu_to_le16(WLAN_REASON_MESH_CLOSE);
 			sta->reason = reason;
 			sta->plink_state = NL80211_PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
@@ -734,8 +723,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid,
-					    plid, reason);
+			mesh_plink_frame_tx(sdata,
+					    WLAN_SP_MESH_PEERING_CLOSE,
+					    sta->sta.addr, llid, plid, reason);
 			break;
 		case OPN_ACPT:
 			del_timer(&sta->plink_timer);
@@ -745,8 +735,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 			mpl_dbg("Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
-			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr, llid,
-					    plid, 0);
+			mesh_plink_frame_tx(sdata,
+					    WLAN_SP_MESH_PEERING_CONFIRM,
+					    sta->sta.addr, llid, plid, 0);
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
@@ -757,7 +748,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	case NL80211_PLINK_ESTAB:
 		switch (event) {
 		case CLS_ACPT:
-			reason = cpu_to_le16(MESH_CLOSE_RCVD);
+			reason = cpu_to_le16(WLAN_REASON_MESH_CLOSE);
 			sta->reason = reason;
 			deactivated = __mesh_plink_deactivate(sta);
 			sta->plink_state = NL80211_PLINK_HOLDING;
@@ -766,14 +757,15 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			spin_unlock_bh(&sta->lock);
 			if (deactivated)
 				ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
-			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid,
-					    plid, reason);
+			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+					    sta->sta.addr, llid, plid, reason);
 			break;
 		case OPN_ACPT:
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr, llid,
-					    plid, 0);
+			mesh_plink_frame_tx(sdata,
+					    WLAN_SP_MESH_PEERING_CONFIRM,
+					    sta->sta.addr, llid, plid, 0);
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
@@ -795,8 +787,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			llid = sta->llid;
 			reason = sta->reason;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr,
-					    llid, plid, reason);
+			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+					    sta->sta.addr, llid, plid, reason);
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
-- 
1.7.6

