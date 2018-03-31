Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:52168 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752448AbeCaHFp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Mar 2018 03:05:45 -0400
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] net: mac80211: Use global ether_broadcast_addr
Date: Sat, 31 Mar 2018 00:05:18 -0700
Message-Id: <ed4a07fafa3349c0ea8eae8d049a66e8954eee47.1522479607.git.joe@perches.com> (sfid-20180331_090908_543456_6C7C3630)
In-Reply-To: <cover.1522479607.git.joe@perches.com>
References: <cover.1522479607.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove statics and use the new global ether_broadcast_addr instead
to save some overall object code size.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/mac80211/iface.c        |  5 +----
 net/mac80211/key.c          |  6 ++----
 net/mac80211/mesh_hwmp.c    | 19 ++++++++++---------
 net/mac80211/mesh_pathtbl.c |  8 ++++----
 4 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d13ba064951f..f203efc3c532 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1387,9 +1387,6 @@ static void ieee80211_recalc_smps_work(struct work_struct *work)
 static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 				  enum nl80211_iftype type)
 {
-	static const u8 bssid_wildcard[ETH_ALEN] = {0xff, 0xff, 0xff,
-						    0xff, 0xff, 0xff};
-
 	/* clear type-dependent union */
 	memset(&sdata->u, 0, sizeof(sdata->u));
 
@@ -1442,7 +1439,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		ieee80211_sta_setup_sdata(sdata);
 		break;
 	case NL80211_IFTYPE_OCB:
-		sdata->vif.bss_conf.bssid = bssid_wildcard;
+		sdata->vif.bss_conf.bssid = ether_broadcast_addr;
 		ieee80211_ocb_setup_sdata(sdata);
 		break;
 	case NL80211_IFTYPE_ADHOC:
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index aee05ec3f7ea..429f0f4bdc0d 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -53,8 +53,6 @@
  * remove the key which waits for an RCU grace period.
  */
 
-static const u8 bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
-
 static void assert_key_lock(struct ieee80211_local *local)
 {
 	lockdep_assert_held(&local->key_mtx);
@@ -196,7 +194,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		sdata_err(sdata,
 			  "failed to set key (%d, %pM) to hardware (%d)\n",
 			  key->conf.keyidx,
-			  sta ? sta->sta.addr : bcast_addr, ret);
+			  sta ? sta->sta.addr : ether_broadcast_addr, ret);
 
  out_unsupported:
 	switch (key->conf.cipher) {
@@ -253,7 +251,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 		sdata_err(sdata,
 			  "failed to remove key (%d, %pM) from hardware (%d)\n",
 			  key->conf.keyidx,
-			  sta ? sta->sta.addr : bcast_addr, ret);
+			  sta ? sta->sta.addr : ether_broadcast_addr, ret);
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 }
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 35ad3983ae4b..23027ea80593 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -97,8 +97,6 @@ enum mpath_frame_type {
 	MPATH_RANN
 };
 
-static const u8 broadcast_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 				  const u8 *orig_addr, u32 orig_sn,
 				  u8 target_flags, const u8 *target,
@@ -645,7 +643,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		preq_id = PREQ_IE_PREQ_ID(preq_elem);
 		hopcount = PREQ_IE_HOPCOUNT(preq_elem) + 1;
 		da = (mpath && mpath->is_root) ?
-			mpath->rann_snd_addr : broadcast_addr;
+			mpath->rann_snd_addr : ether_broadcast_addr;
 
 		if (flags & IEEE80211_PREQ_PROACTIVE_PREP_FLAG) {
 			target_addr = PREQ_IE_TARGET_ADDR(preq_elem);
@@ -779,7 +777,7 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 				goto endperr;
 			mesh_path_error_tx(sdata, ttl, target_addr,
 					   target_sn, target_rcode,
-					   broadcast_addr);
+					   ether_broadcast_addr);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
 	}
@@ -877,7 +875,8 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	if (ifmsh->mshcfg.dot11MeshForwarding) {
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
-				       orig_sn, 0, NULL, 0, broadcast_addr,
+				       orig_sn, 0, NULL, 0,
+				       ether_broadcast_addr,
 				       hopcount, ttl, interval,
 				       new_metric, 0, sdata);
 	}
@@ -1080,7 +1079,7 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 		target_flags &= ~IEEE80211_PREQ_TO_FLAG;
 
 	spin_unlock_bh(&mpath->state_lock);
-	da = (mpath->is_root) ? mpath->rann_snd_addr : broadcast_addr;
+	da = (mpath->is_root) ? mpath->rann_snd_addr : ether_broadcast_addr;
 	mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->vif.addr, ifmsh->sn,
 			       target_flags, mpath->dst, mpath->sn, da, 0,
 			       ttl, lifetime, 0, ifmsh->preq_id++, sdata);
@@ -1244,7 +1243,8 @@ void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 	switch (ifmsh->mshcfg.dot11MeshHWMPRootMode) {
 	case IEEE80211_PROACTIVE_RANN:
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, sdata->vif.addr,
-				       ++ifmsh->sn, 0, NULL, 0, broadcast_addr,
+				       ++ifmsh->sn, 0, NULL, 0,
+				       ether_broadcast_addr,
 				       0, ifmsh->mshcfg.element_ttl,
 				       interval, 0, 0, sdata);
 		break;
@@ -1257,8 +1257,9 @@ void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 				IEEE80211_PREQ_USN_FLAG;
 		mesh_path_sel_frame_tx(MPATH_PREQ, flags, sdata->vif.addr,
 				       ++ifmsh->sn, target_flags,
-				       (u8 *) broadcast_addr, 0, broadcast_addr,
-				       0, ifmsh->mshcfg.element_ttl, interval,
+				       ether_broadcast_addr, 0,
+				       ether_broadcast_addr, 0,
+				       ifmsh->mshcfg.element_ttl, interval,
 				       0, ifmsh->preq_id++, sdata);
 		break;
 	default:
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index a5125624a76d..8b16f7315fac 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -501,7 +501,6 @@ void mesh_plink_broken(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct mesh_table *tbl = sdata->u.mesh.mesh_paths;
-	static const u8 bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct mesh_path *mpath;
 	struct rhashtable_iter iter;
 	int ret;
@@ -525,9 +524,10 @@ void mesh_plink_broken(struct sta_info *sta)
 			++mpath->sn;
 			spin_unlock_bh(&mpath->state_lock);
 			mesh_path_error_tx(sdata,
-				sdata->u.mesh.mshcfg.element_ttl,
-				mpath->dst, mpath->sn,
-				WLAN_REASON_MESH_PATH_DEST_UNREACHABLE, bcast);
+					   sdata->u.mesh.mshcfg.element_ttl,
+					   mpath->dst, mpath->sn,
+					   WLAN_REASON_MESH_PATH_DEST_UNREACHABLE,
+					   ether_broadcast_addr);
 		}
 	}
 	rhashtable_walk_stop(&iter);
-- 
2.15.0
