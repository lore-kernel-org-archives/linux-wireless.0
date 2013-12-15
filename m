Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:41825 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3LOVPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 16:15:22 -0500
Received: by mail-pb0-f49.google.com with SMTP id jt11so4646989pbb.36
        for <linux-wireless@vger.kernel.org>; Sun, 15 Dec 2013 13:15:21 -0800 (PST)
From: Thomas Pedersen <twpedersen@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/3] mac80211: update adjusting TBTT bit in beacon
Date: Sun, 15 Dec 2013 13:14:16 -0800
Message-Id: <1387142056-21850-3-git-send-email-twpedersen@gmail.com> (sfid-20131215_221525_817598_994B80A9)
In-Reply-To: <1387142056-21850-1-git-send-email-twpedersen@gmail.com>
References: <1387142056-21850-1-git-send-email-twpedersen@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Pedersen <thomas@cozybit.com>

This regression was introduced in "mac80211: cache mesh
beacon".

mesh_sync_offset_adjust_tbtt()  was assuming that the
beacon would be rebuilt in every single pre-tbtt
interrupt, but now the beacon update happens on the
workqueue, and it must be ready for immediate delivery to
the driver.

Save a pointer to the meshconf IE in the beacon_data (this
works because both the IE pointer and beacon buffer are
protected by the same rcu_{dereference,assign_pointer}())
for quick updates during pre-tbtt. This is faster and a
little prettier than iterating over the elements to find
the meshconf IE every time.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/ieee80211_i.h |    9 ++++++++-
 net/mac80211/mesh.c        |    5 +++++
 net/mac80211/mesh_sync.c   |    9 ++++++++-
 net/mac80211/tx.c          |    3 +--
 4 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 32bae21..ec1d4a6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -232,6 +232,7 @@ struct ieee80211_rx_data {
 struct beacon_data {
 	u8 *head, *tail;
 	int head_len, tail_len;
+	struct ieee80211_meshconf_ie *meshconf;
 	struct rcu_head rcu_head;
 };
 
@@ -540,7 +541,10 @@ struct ieee80211_mesh_sync_ops {
 			     struct ieee80211_mgmt *mgmt,
 			     struct ieee802_11_elems *elems,
 			     struct ieee80211_rx_status *rx_status);
-	void (*adjust_tbtt)(struct ieee80211_sub_if_data *sdata);
+
+	/* should be called with beacon_data under RCU read lock */
+	void (*adjust_tbtt)(struct ieee80211_sub_if_data *sdata,
+			    struct beacon_data *beacon);
 	/* add other framework functions here */
 };
 
@@ -614,6 +618,9 @@ struct ieee80211_if_mesh {
 	bool chsw_init;
 	u8 chsw_ttl;
 	u16 pre_value;
+
+	/* offset from skb->data while building IE */
+	int meshconf_offset;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1174157..86c2d41 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -259,6 +259,9 @@ int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
 	*pos++ = WLAN_EID_MESH_CONFIG;
 	*pos++ = meshconf_len;
 
+	/* save a pointer for quick updates in pre-tbtt */
+	ifmsh->meshconf_offset = pos - skb->data;
+
 	/* Active path selection protocol ID */
 	*pos++ = ifmsh->mesh_pp_id;
 	/* Active path selection metric ID   */
@@ -723,6 +726,8 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 
 	bcn->tail_len = skb->len;
 	memcpy(bcn->tail, skb->data, bcn->tail_len);
+	bcn->meshconf = (struct ieee80211_meshconf_ie *)
+					(bcn->tail + ifmsh->meshconf_offset);
 
 	dev_kfree_skb(skb);
 	rcu_assign_pointer(ifmsh->beacon, bcn);
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index d1cf2d5..2bc5dc2 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -164,12 +164,15 @@ no_sync:
 	rcu_read_unlock();
 }
 
-static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
+static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata,
+					 struct beacon_data *beacon)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u8 cap;
 
 	WARN_ON(ifmsh->mesh_sp_id != IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
 	BUG_ON(!rcu_read_lock_held());
+	cap = beacon->meshconf->meshconf_cap;
 
 	spin_lock_bh(&ifmsh->sync_offset_lock);
 
@@ -194,6 +197,10 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 		ifmsh->adjusting_tbtt = false;
 	}
 	spin_unlock_bh(&ifmsh->sync_offset_lock);
+
+	beacon->meshconf->meshconf_cap = ifmsh->adjusting_tbtt ?
+			IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING | cap :
+			~IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING & cap;
 }
 
 static const struct sync_method sync_methods[] = {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6d59e21..d758509 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2602,8 +2602,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 			ieee80211_update_csa(sdata, bcn);
 
 		if (ifmsh->sync_ops)
-			ifmsh->sync_ops->adjust_tbtt(
-						sdata);
+			ifmsh->sync_ops->adjust_tbtt(sdata, bcn);
 
 		skb = dev_alloc_skb(local->tx_headroom +
 				    bcn->head_len +
-- 
1.7.10.4

