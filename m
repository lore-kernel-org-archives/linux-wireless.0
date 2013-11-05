Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35985 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3KETXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:23:08 -0500
Received: by mail-pd0-f182.google.com with SMTP id q10so9037553pdj.41
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:23:07 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 15/17] mac80211: factor out plink event gathering
Date: Tue,  5 Nov 2013 11:17:03 -0800
Message-Id: <1383679025-7150-15-git-send-email-thomas@cozybit.com> (sfid-20131105_202316_534387_DB82ECAD)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c | 195 +++++++++++++++++++++++++++-------------------
 1 file changed, 115 insertions(+), 80 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index e5d5c69..c6d0917 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -844,6 +844,111 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 	return changed;
 }
 
+/*
+ * mesh_plink_get_event - get correct MPM event
+ *
+ * @sdata: interface
+ * @sta: peer, leave NULL if processing a frame from a new suitable peer
+ * @elems: peering management IEs
+ * @ftype: frame type
+ * @llid: peer's peer link ID
+ * @plid: peer's local link ID
+ *
+ * Return: new peering event for @sta, but PLINK_UNDEFINED should be treated as
+ * an error.
+ */
+static enum plink_event
+mesh_plink_get_event(struct ieee80211_sub_if_data *sdata,
+		     struct sta_info *sta,
+		     struct ieee802_11_elems *elems,
+		     enum ieee80211_self_protected_actioncode ftype,
+		     __le16 llid, __le16 plid)
+{
+	enum plink_event event = PLINK_UNDEFINED;
+	u8 ie_len = elems->peering_len;
+	bool matches_local;
+
+	matches_local = (ftype == WLAN_SP_MESH_PEERING_CLOSE ||
+			 mesh_matches_local(sdata, elems));
+
+	/* deny open request from non-matching peer */
+	if (!matches_local && !sta) {
+		event = OPN_RJCT;
+		goto out;
+	}
+
+	if (!sta) {
+		if (ftype != WLAN_SP_MESH_PEERING_OPEN) {
+			mpl_dbg(sdata, "Mesh plink: cls or cnf from unknown peer\n");
+			goto out;
+		}
+		/* ftype == WLAN_SP_MESH_PEERING_OPEN */
+		if (!mesh_plink_free_count(sdata)) {
+			mpl_dbg(sdata, "Mesh plink error: no more free plinks\n");
+			goto out;
+		}
+	} else {
+		if (!test_sta_flag(sta, WLAN_STA_AUTH)) {
+			mpl_dbg(sdata, "Mesh plink: Action frame from non-authed peer\n");
+			goto out;
+		}
+		if (sta->plink_state == NL80211_PLINK_BLOCKED)
+			goto out;
+	}
+
+	/* new matching peer */
+	if (!sta) {
+		event = OPN_ACPT;
+		goto out;
+	}
+
+	switch (ftype) {
+	case WLAN_SP_MESH_PEERING_OPEN:
+		if (!matches_local)
+			event = OPN_RJCT;
+		if (!mesh_plink_free_count(sdata) ||
+		    (sta->plid && sta->plid != plid))
+			event = OPN_IGNR;
+		else
+			event = OPN_ACPT;
+		break;
+	case WLAN_SP_MESH_PEERING_CONFIRM:
+		if (!matches_local)
+			event = CNF_RJCT;
+		if (!mesh_plink_free_count(sdata) ||
+		    (sta->llid != llid || sta->plid != plid))
+			event = CNF_IGNR;
+		else
+			event = CNF_ACPT;
+		break;
+	case WLAN_SP_MESH_PEERING_CLOSE:
+		if (sta->plink_state == NL80211_PLINK_ESTAB)
+			/* Do not check for llid or plid. This does not
+			 * follow the standard but since multiple plinks
+			 * per sta are not supported, it is necessary in
+			 * order to avoid a livelock when MP A sees an
+			 * establish peer link to MP B but MP B does not
+			 * see it. This can be caused by a timeout in
+			 * B's peer link establishment or B beign
+			 * restarted.
+			 */
+			event = CLS_ACPT;
+		else if (sta->plid != plid)
+			event = CLS_IGNR;
+		else if (ie_len == 8 && sta->llid != llid)
+			event = CLS_IGNR;
+		else
+			event = CLS_ACPT;
+		break;
+	default:
+		mpl_dbg(sdata, "Mesh plink: unknown frame subtype\n");
+		break;
+	}
+
+out:
+	return event;
+}
+
 static void
 mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt,
@@ -853,9 +958,8 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	enum plink_event event;
 	enum ieee80211_self_protected_actioncode ftype;
-	bool matches_local;
 	u32 changed = 0;
-	u8 ie_len;
+	u8 ie_len = elems->peering_len;
 	__le16 plid, llid;
 
 	if (!elems->peering) {
@@ -872,7 +976,6 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ftype = mgmt->u.action.u.self_prot.action_code;
-	ie_len = elems->peering_len;
 	if ((ftype == WLAN_SP_MESH_PEERING_OPEN && ie_len != 4) ||
 	    (ftype == WLAN_SP_MESH_PEERING_CONFIRM && ie_len != 6) ||
 	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len != 6
@@ -901,9 +1004,6 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 
 	sta = sta_info_get(sdata, mgmt->sa);
 
-	matches_local = (ftype == WLAN_SP_MESH_PEERING_CLOSE ||
-			 mesh_matches_local(sdata, elems));
-
 	if (ftype == WLAN_SP_MESH_PEERING_OPEN &&
 	    !rssi_threshold_check(sdata, sta)) {
 		mpl_dbg(sdata, "Mesh plink: %pM does not meet rssi threshold\n",
@@ -911,81 +1011,8 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 		goto unlock_rcu;
 	}
 
-	if (!sta) {
-		if (ftype != WLAN_SP_MESH_PEERING_OPEN) {
-			mpl_dbg(sdata, "Mesh plink: cls or cnf from unknown peer\n");
-			goto unlock_rcu;
-		}
-		/* ftype == WLAN_SP_MESH_PEERING_OPEN */
-		if (!mesh_plink_free_count(sdata)) {
-			mpl_dbg(sdata, "Mesh plink error: no more free plinks\n");
-			goto unlock_rcu;
-		}
-		/* deny open request from non-matching peer */
-		if (!matches_local) {
-			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
-					    mgmt->sa, 0, plid,
-					    cpu_to_le16(WLAN_REASON_MESH_CONFIG));
-			goto unlock_rcu;
-		}
-	} else {
-		if (!test_sta_flag(sta, WLAN_STA_AUTH)) {
-			mpl_dbg(sdata, "Mesh plink: Action frame from non-authed peer\n");
-			goto unlock_rcu;
-		}
-		if (sta->plink_state == NL80211_PLINK_BLOCKED)
-			goto unlock_rcu;
-	}
-
 	/* Now we will figure out the appropriate event... */
-	event = PLINK_UNDEFINED;
-
-	if (!sta)
-		event = OPN_ACPT;
-	else {
-		switch (ftype) {
-		case WLAN_SP_MESH_PEERING_OPEN:
-			if (!matches_local)
-				event = OPN_RJCT;
-			else if (!mesh_plink_free_count(sdata) ||
-				 (sta->plid && sta->plid != plid))
-				event = OPN_IGNR;
-			else
-				event = OPN_ACPT;
-			break;
-		case WLAN_SP_MESH_PEERING_CONFIRM:
-			if (!matches_local)
-				event = CNF_RJCT;
-			else if (!mesh_plink_free_count(sdata) ||
-				 (sta->llid != llid || sta->plid != plid))
-				event = CNF_IGNR;
-			else
-				event = CNF_ACPT;
-			break;
-		case WLAN_SP_MESH_PEERING_CLOSE:
-			if (sta->plink_state == NL80211_PLINK_ESTAB)
-				/* Do not check for llid or plid. This does not
-				 * follow the standard but since multiple plinks
-				 * per sta are not supported, it is necessary in
-				 * order to avoid a livelock when MP A sees an
-				 * establish peer link to MP B but MP B does not
-				 * see it. This can be caused by a timeout in
-				 * B's peer link establishment or B beign
-				 * restarted.
-				 */
-				event = CLS_ACPT;
-			else if (sta->plid != plid)
-				event = CLS_IGNR;
-			else if (ie_len == 8 && sta->llid != llid)
-				event = CLS_IGNR;
-			else
-				event = CLS_ACPT;
-			break;
-		default:
-			mpl_dbg(sdata, "Mesh plink: unknown frame subtype\n");
-			goto unlock_rcu;
-		}
-	}
+	event = mesh_plink_get_event(sdata, sta, elems, ftype, llid, plid);
 
 	if (event == OPN_ACPT) {
 		rcu_read_unlock();
@@ -996,6 +1023,14 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 			goto unlock_rcu;
 		}
 		sta->plid = plid;
+	} else if (!sta && event == OPN_RJCT) {
+		mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+				    mgmt->sa, 0, plid,
+				    cpu_to_le16(WLAN_REASON_MESH_CONFIG));
+		goto unlock_rcu;
+	} else if (!sta || event == PLINK_UNDEFINED) {
+		/* something went wrong */
+		goto unlock_rcu;
 	}
 
 	changed |= mesh_plink_fsm(sdata, sta, event);
-- 
1.8.4.rc3

