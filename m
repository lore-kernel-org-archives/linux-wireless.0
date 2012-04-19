Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50297 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2DSCXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 22:23:50 -0400
Received: by pbcun15 with SMTP id un15so9656149pbc.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 19:23:49 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 1/2] mac80211: refactor mesh peer initialization
Date: Wed, 18 Apr 2012 19:23:42 -0700
Message-Id: <1334802223-4603-1-git-send-email-thomas@cozybit.com> (sfid-20120419_042424_730717_1326424D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch unifies the previous two paths toward mesh peer creation a
bit. It also fixes a bug where a peer's changing rates or HT mode
wouldn't register on leaving and then returning to the mesh with a sta
entry still present.

Also clean up locking and clear possibly stale ht cap.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |  126 +++++++++++++++++++++++++-------------------
 1 files changed, 72 insertions(+), 54 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 9c836e7..c3a0b0a 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -82,20 +82,14 @@ static inline void mesh_plink_fsm_restart(struct sta_info *sta)
 }
 
 /*
- * NOTE: This is just an alias for sta_info_alloc(), see notes
- *       on it in the lifecycle management section!
+ * Allocate mesh sta entry and insert into station table
  */
 static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
-					 u8 *hw_addr, u32 rates,
-					 struct ieee802_11_elems *elems)
+					 u8 *hw_addr)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
-
-	if (local->num_sta >= MESH_MAX_PLINKS)
+	if (sdata->local->num_sta >= MESH_MAX_PLINKS)
 		return NULL;
 
 	sta = sta_info_alloc(sdata, hw_addr, GFP_KERNEL);
@@ -108,12 +102,8 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 
 	set_sta_flag(sta, WLAN_STA_WME);
 
-	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
-	if (elems->ht_cap_elem)
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-						  elems->ht_cap_elem,
-						  &sta->sta.ht_cap);
-	rate_control_rate_init(sta);
+	if (sta_info_insert(sta))
+		return NULL;
 
 	return sta;
 }
@@ -274,43 +264,76 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void mesh_neighbour_update(u8 *hw_addr, u32 rates,
-		struct ieee80211_sub_if_data *sdata,
-		struct ieee802_11_elems *elems)
+/* mesh_peer_init - initialize new mesh peer and return resulting sta_info
+ *
+ * @sdata: local meshif
+ * @addr: peer's address
+ * @rates: station's supported rates
+ * @elems: IEs from beacon or mesh peering frame
+ *
+ * call under RCU
+ */
+static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
+				       u8 *addr, u32 rates,
+				       struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 
-	rcu_read_lock();
+	sband = local->hw.wiphy->bands[local->oper_channel->band];
 
-	sta = sta_info_get(sdata, hw_addr);
+	sta = sta_info_get(sdata, addr);
 	if (!sta) {
-		rcu_read_unlock();
-		/* Userspace handles peer allocation when security is enabled
-		 * */
-		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED)
-			cfg80211_notify_new_peer_candidate(sdata->dev, hw_addr,
-					elems->ie_start, elems->total_len,
-					GFP_KERNEL);
-		else
-			sta = mesh_plink_alloc(sdata, hw_addr, rates, elems);
+		sta = mesh_plink_alloc(sdata, addr);
 		if (!sta)
-			return;
-		if (sta_info_insert_rcu(sta)) {
-			rcu_read_unlock();
-			return;
-		}
+			return NULL;
 	}
 
+	spin_lock_bh(&sta->lock);
 	sta->last_rx = jiffies;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	if (elems->ht_cap_elem)
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
+						  elems->ht_cap_elem,
+						  &sta->sta.ht_cap);
+	else
+		memset(&sta->sta.ht_cap, 0, sizeof(sta->sta.ht_cap));
+
+	rate_control_rate_init(sta);
+	spin_unlock_bh(&sta->lock);
+
+	return sta;
+}
+
+void mesh_neighbour_update(u8 *hw_addr, u32 rates,
+			   struct ieee80211_sub_if_data *sdata,
+			   struct ieee802_11_elems *elems)
+{
+	struct sta_info *sta;
+
+	/* Userspace handles peer allocation when security is enabled */
+	if (sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED) {
+		cfg80211_notify_new_peer_candidate(sdata->dev, hw_addr,
+						   elems->ie_start,
+						   elems->total_len,
+						   GFP_KERNEL);
+		return;
+	}
+
+	rcu_read_lock();
+	sta = mesh_peer_init(sdata, hw_addr, rates, elems);
+	if (!sta)
+		goto out;
+
 	if (mesh_peer_accepts_plinks(elems) &&
-			sta->plink_state == NL80211_PLINK_LISTEN &&
-			sdata->u.mesh.accepting_plinks &&
-			sdata->u.mesh.mshcfg.auto_open_plinks &&
-			rssi_threshold_check(sta, sdata))
+	    sta->plink_state == NL80211_PLINK_LISTEN &&
+	    sdata->u.mesh.accepting_plinks &&
+	    sdata->u.mesh.mshcfg.auto_open_plinks &&
+	    rssi_threshold_check(sta, sdata))
 		mesh_plink_open(sta);
 
+out:
 	rcu_read_unlock();
 }
 
@@ -587,26 +610,13 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		return;
 	} else if (!sta) {
 		/* ftype == WLAN_SP_MESH_PEERING_OPEN */
-
-		rcu_read_unlock();
-
 		if (!mesh_plink_free_count(sdata)) {
 			mpl_dbg("Mesh plink error: no more free plinks\n");
-			return;
-		}
-		sta = mesh_plink_alloc(sdata, mgmt->sa, rates, &elems);
-		if (!sta) {
-			mpl_dbg("Mesh plink error: plink table full\n");
-			return;
-		}
-		if (sta_info_insert_rcu(sta)) {
 			rcu_read_unlock();
 			return;
 		}
 		event = OPN_ACPT;
-		spin_lock_bh(&sta->lock);
 	} else if (matches_local) {
-		spin_lock_bh(&sta->lock);
 		switch (ftype) {
 		case WLAN_SP_MESH_PEERING_OPEN:
 			if (!mesh_plink_free_count(sdata) ||
@@ -643,12 +653,19 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			break;
 		default:
 			mpl_dbg("Mesh plink: unknown frame subtype\n");
-			spin_unlock_bh(&sta->lock);
 			rcu_read_unlock();
 			return;
 		}
-	} else {
-		spin_lock_bh(&sta->lock);
+	}
+
+	if (event == OPN_ACPT) {
+		/* allocate sta entry if necessary and update info */
+		sta = mesh_peer_init(sdata, mgmt->sa, rates, &elems);
+		if (!sta) {
+			mpl_dbg("Mesh plink: failed to init peer!\n");
+			rcu_read_unlock();
+			return;
+		}
 	}
 
 	mpl_dbg("Mesh plink (peer, state, llid, plid, event): %pM %s %d %d %d\n",
@@ -656,6 +673,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		le16_to_cpu(sta->llid), le16_to_cpu(sta->plid),
 		event);
 	reason = 0;
+	spin_lock_bh(&sta->lock);
 	switch (sta->plink_state) {
 		/* spin_unlock as soon as state is updated at each case */
 	case NL80211_PLINK_LISTEN:
-- 
1.7.5.4

