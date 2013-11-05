Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44879 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3KETWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:22:48 -0500
Received: by mail-pa0-f53.google.com with SMTP id kx10so9314301pab.40
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:22:47 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH 05/17] mac80211: mesh_plink: group basic fitness checks
Date: Tue,  5 Nov 2013 11:16:53 -0800
Message-Id: <1383679025-7150-5-git-send-email-thomas@cozybit.com> (sfid-20131105_202302_411879_2A81C703)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

The initial frame checks differ depending on whether this is
a new peer or not, but they were all intermixed with sta checks
as necessary.  Group them together so the two cases are clearer.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh_plink.c | 70 +++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 3bab76f..5048658 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -700,7 +700,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 	enum plink_event event;
 	enum ieee80211_self_protected_actioncode ftype;
 	size_t baselen;
-	bool matches_local = true;
+	bool matches_local;
 	u8 ie_len;
 	u8 *baseaddr;
 	u32 changed = 0;
@@ -771,11 +771,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 	rcu_read_lock();
 
 	sta = sta_info_get(sdata, mgmt->sa);
-	if (!sta && ftype != WLAN_SP_MESH_PEERING_OPEN) {
-		mpl_dbg(sdata, "Mesh plink: cls or cnf from unknown peer\n");
-		rcu_read_unlock();
-		return;
-	}
+
+	matches_local = ftype == WLAN_SP_MESH_PEERING_CLOSE ||
+			mesh_matches_local(sdata, &elems);
 
 	if (ftype == WLAN_SP_MESH_PEERING_OPEN &&
 	    !rssi_threshold_check(sta, sdata)) {
@@ -785,22 +783,41 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	if (sta && !test_sta_flag(sta, WLAN_STA_AUTH)) {
-		mpl_dbg(sdata, "Mesh plink: Action frame from non-authed peer\n");
-		rcu_read_unlock();
-		return;
-	}
-
-	if (sta && sta->plink_state == NL80211_PLINK_BLOCKED) {
-		rcu_read_unlock();
-		return;
+	if (!sta) {
+		if (ftype != WLAN_SP_MESH_PEERING_OPEN) {
+			mpl_dbg(sdata, "Mesh plink: cls or cnf from unknown peer\n");
+			rcu_read_unlock();
+			return;
+		}
+		/* ftype == WLAN_SP_MESH_PEERING_OPEN */
+		if (!mesh_plink_free_count(sdata)) {
+			mpl_dbg(sdata, "Mesh plink error: no more free plinks\n");
+			rcu_read_unlock();
+			return;
+		}
+		/* deny open request from non-matching peer */
+		if (!matches_local) {
+			rcu_read_unlock();
+			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+					    mgmt->sa, 0, plid,
+					    cpu_to_le16(WLAN_REASON_MESH_CONFIG));
+			return;
+		}
+	} else {
+		if (!test_sta_flag(sta, WLAN_STA_AUTH)) {
+			mpl_dbg(sdata, "Mesh plink: Action frame from non-authed peer\n");
+			rcu_read_unlock();
+			return;
+		}
+		if (sta->plink_state == NL80211_PLINK_BLOCKED) {
+			rcu_read_unlock();
+			return;
+		}
 	}
 
 	/* Now we will figure out the appropriate event... */
 	event = PLINK_UNDEFINED;
-	if (ftype != WLAN_SP_MESH_PEERING_CLOSE &&
-	    !mesh_matches_local(sdata, &elems)) {
-		matches_local = false;
+	if (!matches_local) {
 		switch (ftype) {
 		case WLAN_SP_MESH_PEERING_OPEN:
 			event = OPN_RJCT;
@@ -813,22 +830,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (!sta && !matches_local) {
-		rcu_read_unlock();
-		llid = 0;
-		mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
-				    mgmt->sa, llid, plid,
-				    cpu_to_le16(WLAN_REASON_MESH_CONFIG));
-		return;
-	} else if (!sta) {
-		/* ftype == WLAN_SP_MESH_PEERING_OPEN */
-		if (!mesh_plink_free_count(sdata)) {
-			mpl_dbg(sdata, "Mesh plink error: no more free plinks\n");
-			rcu_read_unlock();
-			return;
-		}
+	if (!sta)
 		event = OPN_ACPT;
-	} else if (matches_local) {
+	else if (matches_local) {
 		switch (ftype) {
 		case WLAN_SP_MESH_PEERING_OPEN:
 			if (!mesh_plink_free_count(sdata) ||
-- 
1.8.4.rc3

