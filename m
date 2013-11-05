Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47985 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab3KETXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:23:06 -0500
Received: by mail-pd0-f181.google.com with SMTP id x10so9115764pdj.12
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:23:05 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 14/17] mac80211: factor out peering FSM
Date: Tue,  5 Nov 2013 11:17:02 -0800
Message-Id: <1383679025-7150-14-git-send-email-thomas@cozybit.com> (sfid-20131105_202314_161324_068E6E04)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c | 296 ++++++++++++++++++++++++----------------------
 1 file changed, 154 insertions(+), 142 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index fa86d35..e5d5c69 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -691,14 +691,165 @@ static u32 mesh_plink_establish(struct ieee80211_sub_if_data *sdata,
 	return changed;
 }
 
+/**
+ * mesh_plink_fsm - step @sta MPM based on @event
+ *
+ * @sdata: interface
+ * @sta: mesh neighbor
+ * @event: peering event
+ *
+ * Return: changed MBSS flags
+ */
+static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
+			  struct sta_info *sta, enum plink_event event)
+{
+	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
+	enum ieee80211_self_protected_actioncode action = 0;
+	u32 changed = 0;
+
+	mpl_dbg(sdata, "peer %pM in state %s got event %s\n", sta->sta.addr,
+		       mplstates[sta->plink_state], mplevents[event]);
+
+	spin_lock_bh(&sta->lock);
+	switch (sta->plink_state) {
+	case NL80211_PLINK_LISTEN:
+		switch (event) {
+		case CLS_ACPT:
+			mesh_plink_fsm_restart(sta);
+			break;
+		case OPN_ACPT:
+			sta->plink_state = NL80211_PLINK_OPN_RCVD;
+			get_random_bytes(&sta->llid, 2);
+			mesh_plink_timer_set(sta,
+					     mshcfg->dot11MeshRetryTimeout);
+
+			/* set the non-peer mode to active during peering */
+			changed |= ieee80211_mps_local_status_update(sdata);
+			action = WLAN_SP_MESH_PEERING_OPEN;
+			break;
+		default:
+			break;
+		}
+		break;
+	case NL80211_PLINK_OPN_SNT:
+		switch (event) {
+		case OPN_RJCT:
+		case CNF_RJCT:
+		case CLS_ACPT:
+			mesh_plink_close(sdata, sta, event);
+			action = WLAN_SP_MESH_PEERING_CLOSE;
+			break;
+		case OPN_ACPT:
+			/* retry timer is left untouched */
+			sta->plink_state = NL80211_PLINK_OPN_RCVD;
+			action = WLAN_SP_MESH_PEERING_CONFIRM;
+			break;
+		case CNF_ACPT:
+			sta->plink_state = NL80211_PLINK_CNF_RCVD;
+			if (!mod_plink_timer(sta,
+					     mshcfg->dot11MeshConfirmTimeout))
+				sta->ignore_plink_timer = true;
+			break;
+		default:
+			break;
+		}
+		break;
+	case NL80211_PLINK_OPN_RCVD:
+		switch (event) {
+		case OPN_RJCT:
+		case CNF_RJCT:
+		case CLS_ACPT:
+			mesh_plink_close(sdata, sta, event);
+			action = WLAN_SP_MESH_PEERING_CLOSE;
+			break;
+		case OPN_ACPT:
+			action = WLAN_SP_MESH_PEERING_CONFIRM;
+			break;
+		case CNF_ACPT:
+			changed |= mesh_plink_establish(sdata, sta);
+			break;
+		default:
+			break;
+		}
+		break;
+	case NL80211_PLINK_CNF_RCVD:
+		switch (event) {
+		case OPN_RJCT:
+		case CNF_RJCT:
+		case CLS_ACPT:
+			mesh_plink_close(sdata, sta, event);
+			action = WLAN_SP_MESH_PEERING_CLOSE;
+			break;
+		case OPN_ACPT:
+			changed |= mesh_plink_establish(sdata, sta);
+			action = WLAN_SP_MESH_PEERING_CONFIRM;
+			break;
+		default:
+			break;
+		}
+		break;
+	case NL80211_PLINK_ESTAB:
+		switch (event) {
+		case CLS_ACPT:
+			changed |= __mesh_plink_deactivate(sta);
+			changed |= mesh_set_ht_prot_mode(sdata);
+			changed |= mesh_set_short_slot_time(sdata);
+			mesh_plink_close(sdata, sta, event);
+			action = WLAN_SP_MESH_PEERING_CLOSE;
+			break;
+		case OPN_ACPT:
+			action = WLAN_SP_MESH_PEERING_CONFIRM;
+			break;
+		default:
+			break;
+		}
+		break;
+	case NL80211_PLINK_HOLDING:
+		switch (event) {
+		case CLS_ACPT:
+			if (del_timer(&sta->plink_timer))
+				sta->ignore_plink_timer = 1;
+			mesh_plink_fsm_restart(sta);
+			break;
+		case OPN_ACPT:
+		case CNF_ACPT:
+		case OPN_RJCT:
+		case CNF_RJCT:
+			action = WLAN_SP_MESH_PEERING_CLOSE;
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		/* should not get here, PLINK_BLOCKED is dealt with at the
+		 * beginning of the function
+		 */
+		break;
+	}
+	spin_unlock_bh(&sta->lock);
+	if (action) {
+		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
+				    sta->llid, sta->plid, sta->reason);
+
+		/* also send confirm in open case */
+		if (action == WLAN_SP_MESH_PEERING_OPEN) {
+			mesh_plink_frame_tx(sdata,
+					    WLAN_SP_MESH_PEERING_CONFIRM,
+					    sta->sta.addr, sta->llid,
+					    sta->plid, 0);
+		}
+	}
+
+	return changed;
+}
+
 static void
 mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt,
 			 struct ieee802_11_elems *elems)
 {
 
-	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
-	enum ieee80211_self_protected_actioncode action = 0;
 	struct sta_info *sta;
 	enum plink_event event;
 	enum ieee80211_self_protected_actioncode ftype;
@@ -847,146 +998,7 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 		sta->plid = plid;
 	}
 
-	mpl_dbg(sdata, "peer %pM in state %s got event %s\n", mgmt->sa,
-		       mplstates[sta->plink_state], mplevents[event]);
-	spin_lock_bh(&sta->lock);
-	switch (sta->plink_state) {
-	case NL80211_PLINK_LISTEN:
-		switch (event) {
-		case CLS_ACPT:
-			mesh_plink_fsm_restart(sta);
-			break;
-		case OPN_ACPT:
-			sta->plink_state = NL80211_PLINK_OPN_RCVD;
-			get_random_bytes(&llid, 2);
-			sta->llid = llid;
-			mesh_plink_timer_set(sta,
-					     mshcfg->dot11MeshRetryTimeout);
-
-			/* set the non-peer mode to active during peering */
-			changed |= ieee80211_mps_local_status_update(sdata);
-
-			action = WLAN_SP_MESH_PEERING_OPEN;
-			break;
-		default:
-			break;
-		}
-		break;
-
-	case NL80211_PLINK_OPN_SNT:
-		switch (event) {
-		case OPN_RJCT:
-		case CNF_RJCT:
-		case CLS_ACPT:
-			mesh_plink_close(sdata, sta, event);
-			action = WLAN_SP_MESH_PEERING_CLOSE;
-			break;
-
-		case OPN_ACPT:
-			/* retry timer is left untouched */
-			sta->plink_state = NL80211_PLINK_OPN_RCVD;
-			action = WLAN_SP_MESH_PEERING_CONFIRM;
-			break;
-		case CNF_ACPT:
-			sta->plink_state = NL80211_PLINK_CNF_RCVD;
-			if (!mod_plink_timer(sta,
-					     mshcfg->dot11MeshConfirmTimeout))
-				sta->ignore_plink_timer = true;
-
-			break;
-		default:
-			break;
-		}
-		break;
-
-	case NL80211_PLINK_OPN_RCVD:
-		switch (event) {
-		case OPN_RJCT:
-		case CNF_RJCT:
-		case CLS_ACPT:
-			mesh_plink_close(sdata, sta, event);
-			action = WLAN_SP_MESH_PEERING_CLOSE;
-			break;
-		case OPN_ACPT:
-			action = WLAN_SP_MESH_PEERING_CONFIRM;
-			break;
-		case CNF_ACPT:
-			changed |= mesh_plink_establish(sdata, sta);
-			break;
-		default:
-			break;
-		}
-		break;
-
-	case NL80211_PLINK_CNF_RCVD:
-		switch (event) {
-		case OPN_RJCT:
-		case CNF_RJCT:
-		case CLS_ACPT:
-			mesh_plink_close(sdata, sta, event);
-			action = WLAN_SP_MESH_PEERING_CLOSE;
-			break;
-		case OPN_ACPT:
-			changed |= mesh_plink_establish(sdata, sta);
-			action = WLAN_SP_MESH_PEERING_CONFIRM;
-			break;
-		default:
-			break;
-		}
-		break;
-
-	case NL80211_PLINK_ESTAB:
-		switch (event) {
-		case CLS_ACPT:
-			changed |= __mesh_plink_deactivate(sta);
-			changed |= mesh_set_ht_prot_mode(sdata);
-			changed |= mesh_set_short_slot_time(sdata);
-			mesh_plink_close(sdata, sta, event);
-			action = WLAN_SP_MESH_PEERING_CLOSE;
-			break;
-		case OPN_ACPT:
-			action = WLAN_SP_MESH_PEERING_CONFIRM;
-			break;
-		default:
-			break;
-		}
-		break;
-	case NL80211_PLINK_HOLDING:
-		switch (event) {
-		case CLS_ACPT:
-			if (del_timer(&sta->plink_timer))
-				sta->ignore_plink_timer = 1;
-			mesh_plink_fsm_restart(sta);
-			break;
-		case OPN_ACPT:
-		case CNF_ACPT:
-		case OPN_RJCT:
-		case CNF_RJCT:
-			action = WLAN_SP_MESH_PEERING_CLOSE;
-			break;
-		default:
-			break;
-		}
-		break;
-	default:
-		/* should not get here, PLINK_BLOCKED is dealt with at the
-		 * beginning of the function
-		 */
-		break;
-	}
-	spin_unlock_bh(&sta->lock);
-	if (action) {
-		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
-				    sta->llid, sta->plid, sta->reason);
-
-		/* also send confirm in open case */
-		if (action == WLAN_SP_MESH_PEERING_OPEN) {
-			mesh_plink_frame_tx(sdata,
-					    WLAN_SP_MESH_PEERING_CONFIRM,
-					    sta->sta.addr, sta->llid,
-					    sta->plid, 0);
-		}
-	}
+	changed |= mesh_plink_fsm(sdata, sta, event);
 
 unlock_rcu:
 	rcu_read_unlock();
-- 
1.8.4.rc3

