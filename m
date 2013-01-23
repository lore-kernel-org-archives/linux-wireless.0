Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:53863 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab3AWUS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 15:18:57 -0500
Received: by mail-bk0-f50.google.com with SMTP id jf3so4741767bkc.37
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 12:18:55 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/2] mac80211: clean up mesh sta allocation warning
Date: Wed, 23 Jan 2013 12:18:12 -0800
Message-Id: <1358972293-2884-1-git-send-email-thomas@cozybit.com> (sfid-20130123_211909_933477_59ED6359)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This refactoring fixes a "scheduling while atomic" warning
when allocating a mesh station entry while holding the RCU
read lock. Fix this by creating a new function
mesh_sta_info_get(), which correctly handles the locking
and returns under RCU.

Also move some unnecessarily #ifdefed mesh station init
code from sta_info_alloc() to __mesh_sta_info_alloc().

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |  158 +++++++++++++++++++++++++++------------------
 net/mac80211/sta_info.c   |    5 --
 2 files changed, 95 insertions(+), 68 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 9e04166..fd280a6 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -55,30 +55,6 @@ static inline void mesh_plink_fsm_restart(struct sta_info *sta)
 	sta->plink_retries = 0;
 }
 
-/*
- * Allocate mesh sta entry and insert into station table
- */
-static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
-					 u8 *hw_addr)
-{
-	struct sta_info *sta;
-
-	if (sdata->local->num_sta >= MESH_MAX_PLINKS)
-		return NULL;
-
-	sta = sta_info_alloc(sdata, hw_addr, GFP_KERNEL);
-	if (!sta)
-		return NULL;
-
-	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
-	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
-	sta_info_pre_move_state(sta, IEEE80211_STA_AUTHORIZED);
-
-	set_sta_flag(sta, WLAN_STA_WME);
-
-	return sta;
-}
-
 /**
  * mesh_set_ht_prot_mode - set correct HT protection mode
  *
@@ -309,52 +285,24 @@ free:
 	return err;
 }
 
-/**
- * mesh_peer_init - initialize new mesh peer and return resulting sta_info
- *
- * @sdata: local meshif
- * @addr: peer's address
- * @elems: IEs from beacon or mesh peering frame
- *
- * call under RCU
- */
-static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
-				       u8 *addr,
-				       struct ieee802_11_elems *elems)
+static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
+			       struct sta_info *sta,
+			       struct ieee802_11_elems *elems, bool insert)
 {
 	struct ieee80211_local *local = sdata->local;
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband;
 	u32 rates, basic_rates = 0;
-	struct sta_info *sta;
-	bool insert = false;
 
 	sband = local->hw.wiphy->bands[band];
 	rates = ieee80211_sta_get_rates(local, elems, band, &basic_rates);
 
-	sta = sta_info_get(sdata, addr);
-	if (!sta) {
-		/* Userspace handles peer allocation when security is enabled */
-		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED) {
-			cfg80211_notify_new_peer_candidate(sdata->dev, addr,
-							   elems->ie_start,
-							   elems->total_len,
-							   GFP_ATOMIC);
-			return NULL;
-		}
-
-		sta = mesh_plink_alloc(sdata, addr);
-		if (!sta)
-			return NULL;
-		insert = true;
-	}
-
 	spin_lock_bh(&sta->lock);
 	sta->last_rx = jiffies;
-	if (sta->plink_state == NL80211_PLINK_ESTAB) {
-		spin_unlock_bh(&sta->lock);
-		return sta;
-	}
+
+	/* rates and capabilities don't change during peering */
+	if (sta->plink_state == NL80211_PLINK_ESTAB)
+		goto out;
 
 	sta->sta.supp_rates[band] = rates;
 	if (elems->ht_cap_elem &&
@@ -379,22 +327,105 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 
 	if (insert)
 		rate_control_rate_init(sta);
+out:
 	spin_unlock_bh(&sta->lock);
+}
+
+static struct sta_info *
+__mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *hw_addr)
+{
+	struct sta_info *sta;
+
+	if (sdata->local->num_sta >= MESH_MAX_PLINKS)
+		return NULL;
 
-	if (insert && sta_info_insert(sta))
+	sta = sta_info_alloc(sdata, hw_addr, GFP_KERNEL);
+	if (!sta)
 		return NULL;
 
+	sta->plink_state = NL80211_PLINK_LISTEN;
+	init_timer(&sta->plink_timer);
+
+	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
+	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
+	sta_info_pre_move_state(sta, IEEE80211_STA_AUTHORIZED);
+
+	set_sta_flag(sta, WLAN_STA_WME);
+
 	return sta;
 }
 
+static struct sta_info *
+mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *addr,
+		    struct ieee802_11_elems *elems)
+{
+	struct sta_info *sta = NULL;
+
+	/* Userspace handles peer allocation when security is enabled */
+	if (sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED)
+		cfg80211_notify_new_peer_candidate(sdata->dev, addr,
+						   elems->ie_start,
+						   elems->total_len,
+						   GFP_KERNEL);
+	else
+		sta = __mesh_sta_info_alloc(sdata, addr);
+
+	return sta;
+}
+
+/*
+ * mesh_sta_info_get - return mesh sta info entry for @addr.
+ *
+ * @sdata: local meshif
+ * @addr: peer's address
+ * @elems: IEs from beacon or mesh peering frame.
+ *
+ * Return existing or newly allocated sta_info under RCU read lock.
+ * (re)initialize with given IEs.
+ */
+static struct sta_info *
+mesh_sta_info_get(struct ieee80211_sub_if_data *sdata,
+		  u8 *addr, struct ieee802_11_elems *elems) __acquires(RCU)
+{
+	struct sta_info *sta = NULL;
+	bool insert = false;
+
+	rcu_read_lock();
+	sta = sta_info_get(sdata, addr);
+	if (!sta) {
+		rcu_read_unlock();
+		/* can't run atomic */
+		sta = mesh_sta_info_alloc(sdata, addr, elems);
+		if (!sta) {
+			rcu_read_lock();
+			return sta;
+		}
+		insert = true;
+	}
+
+	mesh_sta_info_init(sdata, sta, elems, insert);
+
+	if (insert && sta_info_insert_rcu(sta))
+		return NULL;
+	return sta;
+}
+
+/*
+ * mesh_neighbour_update - update or initialize new mesh neighbor.
+ *
+ * @sdata: local meshif
+ * @addr: peer's address
+ * @elems: IEs from beacon or mesh peering frame
+ *
+ * Initiates peering if appropriate.
+ */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 			   u8 *hw_addr,
 			   struct ieee802_11_elems *elems)
 {
 	struct sta_info *sta;
 
-	rcu_read_lock();
-	sta = mesh_peer_init(sdata, hw_addr, elems);
+	sta = mesh_sta_info_get(sdata, hw_addr, elems);
 	if (!sta)
 		goto out;
 
@@ -735,8 +766,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	}
 
 	if (event == OPN_ACPT) {
+		rcu_read_unlock();
 		/* allocate sta entry if necessary and update info */
-		sta = mesh_peer_init(sdata, mgmt->sa, &elems);
+		sta = mesh_sta_info_get(sdata, mgmt->sa, &elems);
 		if (!sta) {
 			mpl_dbg(sdata, "Mesh plink: failed to init peer!\n");
 			rcu_read_unlock();
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9d864ed..227233c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -380,11 +380,6 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
-#ifdef CONFIG_MAC80211_MESH
-	sta->plink_state = NL80211_PLINK_LISTEN;
-	init_timer(&sta->plink_timer);
-#endif
-
 	return sta;
 }
 
-- 
1.7.10.4

