Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:37944 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab2JQBaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 21:30:17 -0400
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [PATCH] mac80211: close peer link after consecutive beacon misses
Date: Tue, 16 Oct 2012 18:30:06 -0700
Message-Id: <1350437406-3158-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121017_033026_005079_429D3DBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the mesh code relies on on a graceful peer link close with a
Mesh Peering Close frame. That causes peer links to stay in established
state after a node just silently disappeared.

This commit adds a timeout that is triggered when a defined number of beacons
from a peer have been missed. In this case the link is closed, just as it
would be in case of a received Mesh Peering Close frame.
To calculate the timeout the peer's beacon interval is used.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/mesh.c       |    2 +-
 net/mac80211/mesh.h       |    5 ++++-
 net/mac80211/mesh_plink.c |   19 +++++++++++++++++--
 net/mac80211/sta_info.h   |    2 ++
 4 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ff0296c..6d41e5d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -696,7 +696,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 
 	if (elems.mesh_id && elems.mesh_config &&
 	    mesh_matches_local(sdata, &elems))
-		mesh_neighbour_update(sdata, mgmt->sa, &elems);
+		mesh_neighbour_update(sdata, mgmt, &elems);
 
 	if (ifmsh->sync_ops)
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 25d0f17..7ce9203 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -209,6 +209,9 @@ struct mesh_rmc {
 
 #define MESH_PATH_EXPIRE (600 * HZ)
 
+/* maximum number of missed beacons before peer link is closed */
+#define MESH_MAX_BEACON_MISS	14
+
 /* Default maximum number of plinks per interface */
 #define MESH_MAX_PLINKS		256
 
@@ -282,7 +285,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath);
 int mesh_gate_num(struct ieee80211_sub_if_data *sdata);
 /* Mesh plinks */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
-			   u8 *hw_addr,
+			   struct ieee80211_mgmt *mgmt,
 			   struct ieee802_11_elems *ie);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 u32 mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 3ab34d8..3a12707 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -372,6 +372,8 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 	spin_lock_bh(&sta->lock);
 	sta->last_rx = jiffies;
 	if (sta->plink_state == NL80211_PLINK_ESTAB) {
+		mod_plink_timer(sta, TU_TO_JIFFIES(sta->beacon_interval *
+						   MESH_MAX_BEACON_MISS));
 		spin_unlock_bh(&sta->lock);
 		return sta;
 	}
@@ -404,13 +406,13 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 }
 
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
-			   u8 *hw_addr,
+			   struct ieee80211_mgmt *mgmt,
 			   struct ieee802_11_elems *elems)
 {
 	struct sta_info *sta;
 
 	rcu_read_lock();
-	sta = mesh_peer_init(sdata, hw_addr, elems);
+	sta = mesh_peer_init(sdata, mgmt->sa, elems);
 	if (!sta)
 		goto out;
 
@@ -421,6 +423,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 	    rssi_threshold_check(sta, sdata))
 		mesh_plink_open(sta);
 
+	sta->beacon_interval = le16_to_cpu(mgmt->u.beacon.beacon_int);
 out:
 	rcu_read_unlock();
 }
@@ -430,6 +433,7 @@ static void mesh_plink_timer(unsigned long data)
 	struct sta_info *sta;
 	__le16 llid, plid, reason;
 	struct ieee80211_sub_if_data *sdata;
+	u32 changed = 0;
 
 	/*
 	 * This STA is valid because sta_info_destroy() will
@@ -495,6 +499,17 @@ static void mesh_plink_timer(unsigned long data)
 		mesh_plink_fsm_restart(sta);
 		spin_unlock_bh(&sta->lock);
 		break;
+	case NL80211_PLINK_ESTAB:
+		/* beacon loss timer */
+		mpl_dbg(sta->sdata, "Mesh plink for %pM beacon loss\n",
+			sta->sta.addr);
+		changed |= __mesh_plink_deactivate(sta);
+		sta->plink_state = NL80211_PLINK_HOLDING;
+		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
+		spin_unlock_bh(&sta->lock);
+		changed |= mesh_set_ht_prot_mode(sdata);
+		ieee80211_bss_info_change_notify(sdata, changed);
+		break;
 	default:
 		spin_unlock_bh(&sta->lock);
 		break;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c88f161f..45eae7e 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -274,6 +274,7 @@ struct sta_ampdu_mlme {
  * @t_offset_setpoint: reference timing offset of this sta to be used when
  * 	calculating clockdrift
  * @ch_type: peer's channel type
+ * @beacon_interval: beacon interval of this station
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -370,6 +371,7 @@ struct sta_info {
 	s64 t_offset;
 	s64 t_offset_setpoint;
 	enum nl80211_channel_type ch_type;
+	u16 beacon_interval;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-- 
1.7.9.5

