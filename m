Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:65140 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab3KETXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:23:12 -0500
Received: by mail-pd0-f169.google.com with SMTP id q10so9113400pdj.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:23:11 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 17/17] mac80211: clean up mesh local link ID generation
Date: Tue,  5 Nov 2013 11:17:05 -0800
Message-Id: <1383679025-7150-17-git-send-email-thomas@cozybit.com> (sfid-20131105_202318_551048_4B9D6083)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11-2012 13.3.1 implicitly limits the mesh local link
ID range to that of AID, since for mesh PS the local link
ID must be indicated in the TIM IE, which only holds
IEEE80211_MAX_AID bits.

Also the code was allowing a local link ID of 0, but this
is not correct since that TIM bit is used for indicating
buffered mcast frames.

Generate a random, unique, link ID from 1 - 2007, and drop
a modulo conversion for the local link ID, but keep it for
the peer link ID in case he chose something > MAX_AID.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c | 40 +++++++++++++++++++++++++++++++++++-----
 net/mac80211/mesh_ps.c    |  3 +--
 net/mac80211/sta_info.c   |  4 ++--
 3 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index e0528b9..4ea2f21 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -615,9 +615,40 @@ static inline void mesh_plink_timer_set(struct sta_info *sta, int timeout)
 	add_timer(&sta->plink_timer);
 }
 
+static bool llid_in_use(struct ieee80211_sub_if_data *sdata,
+			__le16 llid)
+{
+	struct ieee80211_local *local = sdata->local;
+	bool in_use = false;
+	struct sta_info *sta;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (!memcmp(&sta->llid, &llid, sizeof(llid))) {
+			in_use = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return in_use;
+}
+
+static __le16 mesh_get_new_llid(struct ieee80211_sub_if_data *sdata)
+{
+	u16 llid;
+
+	do {
+		get_random_bytes(&llid, sizeof(llid));
+		/* for mesh PS we still only have the AID range for TIM bits */
+		llid = (llid % IEEE80211_MAX_AID) + 1;
+	} while (llid_in_use(sdata, cpu_to_le16(llid)));
+
+	return cpu_to_le16(llid);
+}
+
 u32 mesh_plink_open(struct sta_info *sta)
 {
-	__le16 llid;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 changed;
 
@@ -625,8 +656,7 @@ u32 mesh_plink_open(struct sta_info *sta)
 		return 0;
 
 	spin_lock_bh(&sta->lock);
-	get_random_bytes(&llid, 2);
-	sta->llid = llid;
+	sta->llid = mesh_get_new_llid(sdata);
 	if (sta->plink_state != NL80211_PLINK_LISTEN &&
 	    sta->plink_state != NL80211_PLINK_BLOCKED) {
 		spin_unlock_bh(&sta->lock);
@@ -643,7 +673,7 @@ u32 mesh_plink_open(struct sta_info *sta)
 	changed = ieee80211_mps_local_status_update(sdata);
 
 	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
-			    sta->sta.addr, llid, 0, 0);
+			    sta->sta.addr, sta->llid, 0, 0);
 	return changed;
 }
 
@@ -719,7 +749,7 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 			break;
 		case OPN_ACPT:
 			sta->plink_state = NL80211_PLINK_OPN_RCVD;
-			get_random_bytes(&sta->llid, 2);
+			sta->llid = mesh_get_new_llid(sdata);
 			mesh_plink_timer_set(sta,
 					     mshcfg->dot11MeshRetryTimeout);
 
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 0f79b78..9493868 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -576,10 +576,9 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 	int ac, buffer_local = 0;
 	bool has_buffered = false;
 
-	/* TIM map only for LLID <= IEEE80211_MAX_AID */
 	if (sta->plink_state == NL80211_PLINK_ESTAB)
 		has_buffered = ieee80211_check_tim(elems->tim, elems->tim_len,
-				le16_to_cpu(sta->llid) % IEEE80211_MAX_AID);
+						   le16_to_cpu(sta->llid));
 
 	if (has_buffered)
 		mps_dbg(sta->sdata, "%pM indicates buffered frames\n",
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 1eb66e2..7a91515 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -630,8 +630,8 @@ void sta_info_recalc_tim(struct sta_info *sta)
 #ifdef CONFIG_MAC80211_MESH
 	} else if (ieee80211_vif_is_mesh(&sta->sdata->vif)) {
 		ps = &sta->sdata->u.mesh.ps;
-		/* TIM map only for PLID <= IEEE80211_MAX_AID */
-		id = le16_to_cpu(sta->plid) % IEEE80211_MAX_AID;
+		/* TIM map only for 1 <= PLID <= IEEE80211_MAX_AID */
+		id = le16_to_cpu(sta->plid) % (IEEE80211_MAX_AID + 1);
 #endif
 	} else {
 		return;
-- 
1.8.4.rc3

