Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39398 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab3KETWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:22:45 -0500
Received: by mail-pd0-f173.google.com with SMTP id r10so9027025pdi.32
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:22:45 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH 04/17] mac80211: mesh: factor out common plink close/estab code
Date: Tue,  5 Nov 2013 11:16:52 -0800
Message-Id: <1383679025-7150-4-git-send-email-thomas@cozybit.com> (sfid-20131105_202301_143196_6461F90B)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Reject and accepted close events always put the host in the
holding state and compute a reason code based only on the
current state.  Likewise on establish we always do the same
setup.  Put these in functions to save some duplicated code.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh_plink.c | 98 +++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 55 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index c3a3faf..3bab76f 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -655,6 +655,39 @@ u32 mesh_plink_block(struct sta_info *sta)
 	return changed;
 }
 
+static void mesh_plink_close(struct ieee80211_sub_if_data *sdata,
+			     struct sta_info *sta,
+			     enum plink_event event)
+{
+	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
+
+	__le16 reason = (event == CLS_ACPT) ?
+		cpu_to_le16(WLAN_REASON_MESH_CLOSE) :
+		cpu_to_le16(WLAN_REASON_MESH_CONFIG);
+
+	sta->reason = reason;
+	sta->plink_state = NL80211_PLINK_HOLDING;
+	if (!mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout))
+		sta->ignore_plink_timer = true;
+}
+
+static u32 mesh_plink_establish(struct ieee80211_sub_if_data *sdata,
+				struct sta_info *sta)
+{
+	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
+	u32 changed = 0;
+
+	del_timer(&sta->plink_timer);
+	sta->plink_state = NL80211_PLINK_ESTAB;
+	changed |= mesh_plink_inc_estab_count(sdata);
+	changed |= mesh_set_ht_prot_mode(sdata);
+	changed |= mesh_set_short_slot_time(sdata);
+	mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n", sta->sta.addr);
+	ieee80211_mps_sta_status_update(sta);
+	changed |= ieee80211_mps_set_sta_local_pm(sta, mshcfg->power_mode);
+	return changed;
+}
+
 
 void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len,
@@ -671,7 +704,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 	u8 ie_len;
 	u8 *baseaddr;
 	u32 changed = 0;
-	__le16 plid, llid, reason;
+	__le16 plid, llid;
 
 	/* need action_code, aux */
 	if (len < IEEE80211_MIN_ACTION_SIZE + 3)
@@ -782,10 +815,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 
 	if (!sta && !matches_local) {
 		rcu_read_unlock();
-		reason = cpu_to_le16(WLAN_REASON_MESH_CONFIG);
 		llid = 0;
 		mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
-				    mgmt->sa, llid, plid, reason);
+				    mgmt->sa, llid, plid,
+				    cpu_to_le16(WLAN_REASON_MESH_CONFIG));
 		return;
 	} else if (!sta) {
 		/* ftype == WLAN_SP_MESH_PEERING_OPEN */
@@ -850,7 +883,6 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 
 	mpl_dbg(sdata, "peer %pM in state %s got event %s\n", mgmt->sa,
 		       mplstates[sta->plink_state], mplevents[event]);
-	reason = 0;
 	spin_lock_bh(&sta->lock);
 	switch (sta->plink_state) {
 	case NL80211_PLINK_LISTEN:
@@ -880,18 +912,11 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
-			reason = cpu_to_le16(WLAN_REASON_MESH_CONFIG);
 		case CLS_ACPT:
-			if (!reason)
-				reason = cpu_to_le16(WLAN_REASON_MESH_CLOSE);
-			sta->reason = reason;
-			sta->plink_state = NL80211_PLINK_HOLDING;
-			if (!mod_plink_timer(sta,
-					     mshcfg->dot11MeshHoldingTimeout))
-				sta->ignore_plink_timer = true;
-
+			mesh_plink_close(sdata, sta, event);
 			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
+
 		case OPN_ACPT:
 			/* retry timer is left untouched */
 			sta->plink_state = NL80211_PLINK_OPN_RCVD;
@@ -914,32 +939,15 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
-			reason = cpu_to_le16(WLAN_REASON_MESH_CONFIG);
 		case CLS_ACPT:
-			if (!reason)
-				reason = cpu_to_le16(WLAN_REASON_MESH_CLOSE);
-			sta->reason = reason;
-			sta->plink_state = NL80211_PLINK_HOLDING;
-			if (!mod_plink_timer(sta,
-					     mshcfg->dot11MeshHoldingTimeout))
-				sta->ignore_plink_timer = true;
-
+			mesh_plink_close(sdata, sta, event);
 			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		case OPN_ACPT:
 			action = WLAN_SP_MESH_PEERING_CONFIRM;
 			break;
 		case CNF_ACPT:
-			del_timer(&sta->plink_timer);
-			sta->plink_state = NL80211_PLINK_ESTAB;
-			changed |= mesh_plink_inc_estab_count(sdata);
-			changed |= mesh_set_ht_prot_mode(sdata);
-			changed |= mesh_set_short_slot_time(sdata);
-			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
-				sta->sta.addr);
-			ieee80211_mps_sta_status_update(sta);
-			changed |= ieee80211_mps_set_sta_local_pm(sta,
-						       mshcfg->power_mode);
+			changed |= mesh_plink_establish(sdata, sta);
 			break;
 		default:
 			break;
@@ -950,30 +958,13 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		switch (event) {
 		case OPN_RJCT:
 		case CNF_RJCT:
-			reason = cpu_to_le16(WLAN_REASON_MESH_CONFIG);
 		case CLS_ACPT:
-			if (!reason)
-				reason = cpu_to_le16(WLAN_REASON_MESH_CLOSE);
-			sta->reason = reason;
-			sta->plink_state = NL80211_PLINK_HOLDING;
-			if (!mod_plink_timer(sta,
-					     mshcfg->dot11MeshHoldingTimeout))
-				sta->ignore_plink_timer = true;
-
+			mesh_plink_close(sdata, sta, event);
 			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		case OPN_ACPT:
-			del_timer(&sta->plink_timer);
-			sta->plink_state = NL80211_PLINK_ESTAB;
-			changed |= mesh_plink_inc_estab_count(sdata);
-			changed |= mesh_set_ht_prot_mode(sdata);
-			changed |= mesh_set_short_slot_time(sdata);
-			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
-				sta->sta.addr);
+			changed |= mesh_plink_establish(sdata, sta);
 			action = WLAN_SP_MESH_PEERING_CONFIRM;
-			ieee80211_mps_sta_status_update(sta);
-			changed |= ieee80211_mps_set_sta_local_pm(sta,
-							mshcfg->power_mode);
 			break;
 		default:
 			break;
@@ -983,13 +974,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 	case NL80211_PLINK_ESTAB:
 		switch (event) {
 		case CLS_ACPT:
-			reason = cpu_to_le16(WLAN_REASON_MESH_CLOSE);
-			sta->reason = reason;
 			changed |= __mesh_plink_deactivate(sta);
-			sta->plink_state = NL80211_PLINK_HOLDING;
-			mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
 			changed |= mesh_set_ht_prot_mode(sdata);
 			changed |= mesh_set_short_slot_time(sdata);
+			mesh_plink_close(sdata, sta, event);
 			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		case OPN_ACPT:
-- 
1.8.4.rc3

