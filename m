Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2I3PP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 11:15:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove unimplemented mesh vendor sync
Date: Sun, 30 Sep 2012 17:15:58 +0200
Message-Id: <1349018158-22781-1-git-send-email-johannes@sipsolutions.net> (sfid-20120930_171531_154854_E0D97EA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no vendor-specific mesh sync implemented
and there don't need to be dummy handlers that
only print messages, so remove that code. While
at it, also constify the mesh sync ops.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/mesh.h        |    2 +-
 net/mac80211/mesh_sync.c   |   55 +++-----------------------------------------
 3 files changed, 6 insertions(+), 55 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8c80455..f13798e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -610,7 +610,7 @@ struct ieee80211_if_mesh {
 		IEEE80211_MESH_SEC_SECURED = 0x2,
 	} security;
 	/* Extensible Synchronization Framework */
-	struct ieee80211_mesh_sync_ops *sync_ops;
+	const struct ieee80211_mesh_sync_ops *sync_ops;
 	s64 sync_offset_clockdrift_max;
 	spinlock_t sync_offset_lock;
 	bool adjusting_tbtt;
@@ -1397,7 +1397,7 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 
 void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 			  struct sk_buff *skb, int tid);
-static void inline ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
+static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
 				    struct sk_buff *skb)
 {
 	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 25d0f17..c08d1c9 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -256,7 +256,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
-struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method);
+const struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index accfa00..d0245ea 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -235,49 +235,7 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 	spin_unlock_bh(&ifmsh->sync_offset_lock);
 }
 
-static const u8 *mesh_get_vendor_oui(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	u8 offset;
-
-	if (!ifmsh->ie || !ifmsh->ie_len)
-		return NULL;
-
-	offset = ieee80211_ie_split_vendor(ifmsh->ie,
-					ifmsh->ie_len, 0);
-
-	if (!offset)
-		return NULL;
-
-	return ifmsh->ie + offset + 2;
-}
-
-static void mesh_sync_vendor_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
-				   u16 stype,
-				   struct ieee80211_mgmt *mgmt,
-				   struct ieee802_11_elems *elems,
-				   struct ieee80211_rx_status *rx_status)
-{
-	const u8 *oui;
-
-	WARN_ON(sdata->u.mesh.mesh_sp_id != IEEE80211_SYNC_METHOD_VENDOR);
-	msync_dbg(sdata, "called mesh_sync_vendor_rx_bcn_presp\n");
-	oui = mesh_get_vendor_oui(sdata);
-	/*  here you would implement the vendor offset tracking for this oui */
-}
-
-static void mesh_sync_vendor_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
-{
-	const u8 *oui;
-
-	WARN_ON(sdata->u.mesh.mesh_sp_id != IEEE80211_SYNC_METHOD_VENDOR);
-	msync_dbg(sdata, "called mesh_sync_vendor_adjust_tbtt\n");
-	oui = mesh_get_vendor_oui(sdata);
-	/*  here you would implement the vendor tsf adjustment for this oui */
-}
-
-/* global variable */
-static struct sync_method sync_methods[] = {
+static const struct sync_method sync_methods[] = {
 	{
 		.method = IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET,
 		.ops = {
@@ -285,18 +243,11 @@ static struct sync_method sync_methods[] = {
 			.adjust_tbtt = &mesh_sync_offset_adjust_tbtt,
 		}
 	},
-	{
-		.method = IEEE80211_SYNC_METHOD_VENDOR,
-		.ops = {
-			.rx_bcn_presp = &mesh_sync_vendor_rx_bcn_presp,
-			.adjust_tbtt = &mesh_sync_vendor_adjust_tbtt,
-		}
-	},
 };
 
-struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method)
+const struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method)
 {
-	struct ieee80211_mesh_sync_ops *ops = NULL;
+	const struct ieee80211_mesh_sync_ops *ops = NULL;
 	u8 i;
 
 	for (i = 0 ; i < ARRAY_SIZE(sync_methods); ++i) {
-- 
1.7.10.4

