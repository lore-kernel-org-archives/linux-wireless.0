Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:54861 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0LQBiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 20:38:14 -0500
Received: by mail-gx0-f180.google.com with SMTP id 19so101619gxk.11
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 17:38:13 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/3 v3] mac80211: Send mesh non-HWMP path selection frames to userspace
Date: Thu, 16 Dec 2010 17:37:50 -0800
Message-Id: <1292549870-1743-3-git-send-email-javier@cozybit.com>
In-Reply-To: <1292525513.3612.26.camel@jlt3.sipsolutions.net>
References: <1292525513.3612.26.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let path selection frames for protocols other than HWMP be sent to
userspace via NL80211_CMD_REGISTER_FRAME.  Also allow userspace to send
and receive mesh path selection frames.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
v2: - update patch description (Johannes)
    - remove mesh_ids_set_default and initialize ids in start_mesh (Johannes)
    - more elegant check for mesh_path_sel_is_hwmp (Johannes)
v3: - no change, just rebased

 net/mac80211/cfg.c     |    1 +
 net/mac80211/main.c    |    4 ++++
 net/mac80211/mesh.c    |   13 +++----------
 net/mac80211/mesh.h    |    7 +++++++
 net/mac80211/rx.c      |    5 ++++-
 net/wireless/nl80211.c |    2 ++
 6 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ae2c712..5892b03 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1670,6 +1670,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_MESH_POINT:
 		if (!ieee80211_is_action(mgmt->frame_control) ||
 		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)
 			break;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a9454cb..bbe8e0a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -484,6 +484,10 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
 			BIT(IEEE80211_STYPE_ACTION >> 4),
 	},
+	[NL80211_IFTYPE_MESH_POINT] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4),
+	},
 };
 
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index c326e00..8b5906c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -124,15 +124,6 @@ void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 		ieee80211_mesh_housekeeping_timer((unsigned long) sdata);
 }
 
-void mesh_ids_set_default(struct ieee80211_if_mesh *sta)
-{
-	sta->mesh_pp_id = 0;	/* HWMP */
-	sta->mesh_pm_id = 0;	/* Airtime */
-	sta->mesh_cc_id = 0;	/* Disabled */
-	sta->mesh_sp_id = 0;	/* Neighbor Offset */
-	sta->mesh_auth_id = 0;	/* Disabled */
-}
-
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
 {
 	int i;
@@ -525,6 +516,9 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	atomic_inc(&local->iff_allmultis);
 	ieee80211_configure_filter(local);
 
+	ifmsh->mesh_cc_id = 0;	/* Disabled */
+	ifmsh->mesh_sp_id = 0;	/* Neighbor Offset */
+	ifmsh->mesh_auth_id = 0;	/* Disabled */
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 	ieee80211_mesh_root_setup(ifmsh);
 	ieee80211_queue_work(&local->hw, &sdata->work);
@@ -695,7 +689,6 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
-	mesh_ids_set_default(ifmsh);
 	setup_timer(&ifmsh->mesh_path_timer,
 		    ieee80211_mesh_path_timer,
 		    (unsigned long) sdata);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 5b828fa..890dd19 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -284,6 +284,11 @@ static inline void mesh_path_activate(struct mesh_path *mpath)
 	mpath->flags |= MESH_PATH_ACTIVE | MESH_PATH_RESOLVED;
 }
 
+static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
+{
+	return sdata->u.mesh.mesh_pp_id == IEEE80211_PATH_PROTOCOL_HWMP;
+}
+
 #define for_each_mesh_entry(x, p, node, i) \
 	for (i = 0; i <= x->hash_mask; i++) \
 		hlist_for_each_entry_rcu(node, p, &x->hash_buckets[i], list)
@@ -304,6 +309,8 @@ static inline void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
 {}
 static inline void mesh_plink_quiesce(struct sta_info *sta) {}
 static inline void mesh_plink_restart(struct sta_info *sta) {}
+static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
+{ return false; }
 #endif
 
 #endif /* IEEE80211S_H */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f39524b..cdbc824 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2143,10 +2143,13 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		}
 		break;
 	case WLAN_CATEGORY_MESH_PLINK:
-	case WLAN_CATEGORY_MESH_PATH_SEL:
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
 		goto queue;
+	case WLAN_CATEGORY_MESH_PATH_SEL:
+		if (!mesh_path_sel_is_hwmp(sdata))
+			break;
+		goto queue;
 	}
 
 	return RX_CONTINUE;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 356c33e..177ea21 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4445,6 +4445,7 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EOPNOTSUPP;
 
@@ -4485,6 +4486,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EOPNOTSUPP;
 
-- 
1.7.1

