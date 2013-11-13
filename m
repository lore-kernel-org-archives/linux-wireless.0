Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43211 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410Ab3KMHq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 02:46:26 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so40684pbc.15
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 23:46:26 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: use put_unaligned_le16 in mesh_plink_frame_tx
Date: Wed, 13 Nov 2013 15:43:03 +0800
Message-Id: <1384328583-24639-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131113_084630_477448_12AB402C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use put_unaligned_le16 in mesh_plink_frame_tx.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/cfg.c        |    4 ++--
 net/mac80211/mesh_plink.c |   54 ++++++++++++++++++++++-----------------------
 net/mac80211/mesh_ps.c    |    2 +-
 net/mac80211/sta_info.c   |    2 +-
 net/mac80211/sta_info.h   |    6 ++---
 5 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 30cbeaf..e50857b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -532,8 +532,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 				 STATION_INFO_PEER_PM |
 				 STATION_INFO_NONPEER_PM;
 
-		sinfo->llid = le16_to_cpu(sta->llid);
-		sinfo->plid = le16_to_cpu(sta->plid);
+		sinfo->llid = sta->llid;
+		sinfo->plid = sta->plid;
 		sinfo->plink_state = sta->plink_state;
 		if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
 			sinfo->filled |= STATION_INFO_T_OFFSET;
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index fadc3e1..cf83217 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -55,7 +55,7 @@ static const char * const mplevents[] = {
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			       enum ieee80211_self_protected_actioncode action,
-			       u8 *da, __le16 llid, __le16 plid, __le16 reason);
+			       u8 *da, u16 llid, u16 plid, u16 reason);
 
 
 /* We only need a valid sta if user configured a minimum rssi_threshold. */
@@ -246,7 +246,7 @@ u32 mesh_plink_deactivate(struct sta_info *sta)
 
 	spin_lock_bh(&sta->lock);
 	changed = __mesh_plink_deactivate(sta);
-	sta->reason = cpu_to_le16(WLAN_REASON_MESH_PEER_CANCELED);
+	sta->reason = WLAN_REASON_MESH_PEER_CANCELED;
 	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
 			    sta->sta.addr, sta->llid, sta->plid,
 			    sta->reason);
@@ -257,7 +257,7 @@ u32 mesh_plink_deactivate(struct sta_info *sta)
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			       enum ieee80211_self_protected_actioncode action,
-			       u8 *da, __le16 llid, __le16 plid, __le16 reason)
+			       u8 *da, u16 llid, u16 plid, u16 reason)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -305,7 +305,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		if (action == WLAN_SP_MESH_PEERING_CONFIRM) {
 			/* AID */
 			pos = skb_put(skb, 2);
-			memcpy(pos + 2, &plid, 2);
+			put_unaligned_le16(plid, pos + 2);
 		}
 		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
@@ -347,14 +347,14 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	*pos++ = ie_len;
 	memcpy(pos, &peering_proto, 2);
 	pos += 2;
-	memcpy(pos, &llid, 2);
+	put_unaligned_le16(llid, pos);
 	pos += 2;
 	if (include_plid) {
-		memcpy(pos, &plid, 2);
+		put_unaligned_le16(plid, pos);
 		pos += 2;
 	}
 	if (action == WLAN_SP_MESH_PEERING_CLOSE) {
-		memcpy(pos, &reason, 2);
+		put_unaligned_le16(reason, pos);
 		pos += 2;
 	}
 
@@ -534,7 +534,7 @@ out:
 static void mesh_plink_timer(unsigned long data)
 {
 	struct sta_info *sta;
-	__le16 llid, plid, reason;
+	u16 reason = 0;
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_config *mshcfg;
 	enum ieee80211_self_protected_actioncode action = 0;
@@ -558,9 +558,6 @@ static void mesh_plink_timer(unsigned long data)
 	mpl_dbg(sta->sdata,
 		"Mesh plink timer for %pM fired on state %s\n",
 		sta->sta.addr, mplstates[sta->plink_state]);
-	reason = 0;
-	llid = sta->llid;
-	plid = sta->plid;
 	sdata = sta->sdata;
 	mshcfg = &sdata->u.mesh.mshcfg;
 
@@ -582,12 +579,12 @@ static void mesh_plink_timer(unsigned long data)
 			action = WLAN_SP_MESH_PEERING_OPEN;
 			break;
 		}
-		reason = cpu_to_le16(WLAN_REASON_MESH_MAX_RETRIES);
+		reason = WLAN_REASON_MESH_MAX_RETRIES;
 		/* fall through on else */
 	case NL80211_PLINK_CNF_RCVD:
 		/* confirm timer */
 		if (!reason)
-			reason = cpu_to_le16(WLAN_REASON_MESH_CONFIRM_TIMEOUT);
+			reason = WLAN_REASON_MESH_CONFIRM_TIMEOUT;
 		sta->plink_state = NL80211_PLINK_HOLDING;
 		mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
 		action = WLAN_SP_MESH_PEERING_CLOSE;
@@ -603,7 +600,7 @@ static void mesh_plink_timer(unsigned long data)
 	spin_unlock_bh(&sta->lock);
 	if (action)
 		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
-				    llid, plid, reason);
+				    sta->llid, sta->plid, reason);
 }
 
 static inline void mesh_plink_timer_set(struct sta_info *sta, int timeout)
@@ -616,7 +613,7 @@ static inline void mesh_plink_timer_set(struct sta_info *sta, int timeout)
 }
 
 static bool llid_in_use(struct ieee80211_sub_if_data *sdata,
-			__le16 llid)
+			u16 llid)
 {
 	struct ieee80211_local *local = sdata->local;
 	bool in_use = false;
@@ -634,7 +631,7 @@ static bool llid_in_use(struct ieee80211_sub_if_data *sdata,
 	return in_use;
 }
 
-static __le16 mesh_get_new_llid(struct ieee80211_sub_if_data *sdata)
+static u16 mesh_get_new_llid(struct ieee80211_sub_if_data *sdata)
 {
 	u16 llid;
 
@@ -642,9 +639,9 @@ static __le16 mesh_get_new_llid(struct ieee80211_sub_if_data *sdata)
 		get_random_bytes(&llid, sizeof(llid));
 		/* for mesh PS we still only have the AID range for TIM bits */
 		llid = (llid % IEEE80211_MAX_AID) + 1;
-	} while (llid_in_use(sdata, cpu_to_le16(llid)));
+	} while (llid_in_use(sdata, llid));
 
-	return cpu_to_le16(llid);
+	return llid;
 }
 
 u32 mesh_plink_open(struct sta_info *sta)
@@ -695,9 +692,8 @@ static void mesh_plink_close(struct ieee80211_sub_if_data *sdata,
 {
 	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
 
-	__le16 reason = (event == CLS_ACPT) ?
-		cpu_to_le16(WLAN_REASON_MESH_CLOSE) :
-		cpu_to_le16(WLAN_REASON_MESH_CONFIG);
+	u16 reason = (event == CLS_ACPT) ?
+		     WLAN_REASON_MESH_CLOSE : WLAN_REASON_MESH_CONFIG;
 
 	sta->reason = reason;
 	sta->plink_state = NL80211_PLINK_HOLDING;
@@ -892,7 +888,7 @@ mesh_plink_get_event(struct ieee80211_sub_if_data *sdata,
 		     struct sta_info *sta,
 		     struct ieee802_11_elems *elems,
 		     enum ieee80211_self_protected_actioncode ftype,
-		     __le16 llid, __le16 plid)
+		     u16 llid, u16 plid)
 {
 	enum plink_event event = PLINK_UNDEFINED;
 	u8 ie_len = elems->peering_len;
@@ -990,7 +986,8 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_self_protected_actioncode ftype;
 	u32 changed = 0;
 	u8 ie_len = elems->peering_len;
-	__le16 plid, llid = 0;
+	__le16 _plid, _llid;
+	u16 plid, llid = 0;
 
 	if (!elems->peering) {
 		mpl_dbg(sdata,
@@ -1024,10 +1021,13 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 	/* Note the lines below are correct, the llid in the frame is the plid
 	 * from the point of view of this host.
 	 */
-	memcpy(&plid, PLINK_GET_LLID(elems->peering), 2);
+	memcpy(&_plid, PLINK_GET_LLID(elems->peering), sizeof(__le16));
+	plid = le16_to_cpu(_plid);
 	if (ftype == WLAN_SP_MESH_PEERING_CONFIRM ||
-	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len == 8))
-		memcpy(&llid, PLINK_GET_PLID(elems->peering), 2);
+	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len == 8)) {
+		memcpy(&_llid, PLINK_GET_PLID(elems->peering), sizeof(__le16));
+		llid = le16_to_cpu(_llid);
+	}
 
 	/* WARNING: Only for sta pointer, is dropped & re-acquired */
 	rcu_read_lock();
@@ -1056,7 +1056,7 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 	} else if (!sta && event == OPN_RJCT) {
 		mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
 				    mgmt->sa, 0, plid,
-				    cpu_to_le16(WLAN_REASON_MESH_CONFIG));
+				    WLAN_REASON_MESH_CONFIG);
 		goto unlock_rcu;
 	} else if (!sta || event == PLINK_UNDEFINED) {
 		/* something went wrong */
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 9493868..2802f9d 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -578,7 +578,7 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 
 	if (sta->plink_state == NL80211_PLINK_ESTAB)
 		has_buffered = ieee80211_check_tim(elems->tim, elems->tim_len,
-						   le16_to_cpu(sta->llid));
+						   sta->llid);
 
 	if (has_buffered)
 		mps_dbg(sta->sdata, "%pM indicates buffered frames\n",
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7a91515..45b5f61 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -631,7 +631,7 @@ void sta_info_recalc_tim(struct sta_info *sta)
 	} else if (ieee80211_vif_is_mesh(&sta->sdata->vif)) {
 		ps = &sta->sdata->u.mesh.ps;
 		/* TIM map only for 1 <= PLID <= IEEE80211_MAX_AID */
-		id = le16_to_cpu(sta->plid) % (IEEE80211_MAX_AID + 1);
+		id = sta->plid % (IEEE80211_MAX_AID + 1);
 #endif
 	} else {
 		return;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 6b0d6c2..a2c9a4c 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -390,9 +390,9 @@ struct sta_info {
 	 * Mesh peer link attributes
 	 * TODO: move to a sub-structure that is referenced with pointer?
 	 */
-	__le16 llid;
-	__le16 plid;
-	__le16 reason;
+	u16 llid;
+	u16 plid;
+	u16 reason;
 	u8 plink_retries;
 	bool ignore_plink_timer;
 	enum nl80211_plink_state plink_state;
-- 
1.7.9.5

