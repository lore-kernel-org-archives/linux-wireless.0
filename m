Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46459 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbbIYMUW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2015 08:20:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 1/2] mac80211: make sta_info_alloc() return value an ERR_PTR
Date: Fri, 25 Sep 2015 14:20:16 +0200
Message-Id: <1443183617-23181-1-git-send-email-johannes@sipsolutions.net> (sfid-20150925_142026_652022_36E1A121)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to return more accurate error numbers instead of assuming
that all errors are actually -ENOMEM, return an ERR_PTR() from the
function instead of NULL for errors.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c        |  4 ++--
 net/mac80211/ibss.c       |  4 ++--
 net/mac80211/iface.c      |  4 ++--
 net/mac80211/mesh_plink.c |  2 +-
 net/mac80211/mlme.c       |  4 ++--
 net/mac80211/ocb.c        |  2 +-
 net/mac80211/sta_info.c   | 17 +++++++++++------
 7 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1b91fcd0aa11..453bac0c0953 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1252,8 +1252,8 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 
 	sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
-	if (!sta)
-		return -ENOMEM;
+	if (IS_ERR(sta))
+		return PTR_ERR(sta);
 
 	/*
 	 * defaults -- if userspace wants something else we'll
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 7f72bc9bae2e..f2f7d3f456e1 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -641,7 +641,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata, const u8 *bssid,
 	rcu_read_unlock();
 
 	sta = sta_info_alloc(sdata, addr, GFP_KERNEL);
-	if (!sta) {
+	if (IS_ERR(sta)) {
 		rcu_read_lock();
 		return NULL;
 	}
@@ -1231,7 +1231,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
-	if (!sta)
+	if (IS_ERR(sta))
 		return;
 
 	sta->last_rx = jiffies;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 42d7f0f65bd6..7e3a04bccffe 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -674,8 +674,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		/* Create STA entry for the WDS peer */
 		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
 				     GFP_KERNEL);
-		if (!sta) {
-			res = -ENOMEM;
+		if (IS_ERR(sta)) {
+			res = PTR_ERR(sta);
 			goto err_del_interface;
 		}
 
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index a360b24b7df8..abc184a8298f 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -471,7 +471,7 @@ __mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *hw_addr)
 		return NULL;
 
 	sta = sta_info_alloc(sdata, hw_addr, GFP_KERNEL);
-	if (!sta)
+	if (IS_ERR(sta))
 		return NULL;
 
 	sta->mesh->plink_state = NL80211_PLINK_LISTEN;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 88047bf6c0e0..5a13e27e4ea3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4330,8 +4330,8 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 
 	if (!have_sta) {
 		new_sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
-		if (!new_sta)
-			return -ENOMEM;
+		if (IS_ERR(new_sta))
+			return PTR_ERR(new_sta);
 	}
 
 	if (new_sta || override) {
diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
index 573b81a1fb2d..470da635eec4 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -72,7 +72,7 @@ void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
-	if (!sta)
+	if (IS_ERR(sta))
 		return;
 
 	sta->last_rx = jiffies;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 64f1936350c6..c54dbcaa97b6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -304,11 +304,11 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_hw *hw = &local->hw;
 	struct sta_info *sta;
 	struct timespec uptime;
-	int i;
+	int i, ret;
 
 	sta = kzalloc(sizeof(*sta) + hw->sta_data_size, gfp);
 	if (!sta)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	spin_lock_init(&sta->lock);
 	spin_lock_init(&sta->ps_lock);
@@ -318,8 +318,10 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 #ifdef CONFIG_MAC80211_MESH
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		sta->mesh = kzalloc(sizeof(*sta->mesh), gfp);
-		if (!sta->mesh)
+		if (!sta->mesh) {
+			ret = -ENOMEM;
 			goto free;
+		}
 		spin_lock_init(&sta->mesh->plink_lock);
 		if (ieee80211_vif_is_mesh(&sdata->vif) &&
 		    !sdata->u.mesh.user_mpm)
@@ -351,8 +353,10 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 			   ALIGN(hw->txq_data_size, sizeof(void *));
 
 		txq_data = kcalloc(ARRAY_SIZE(sta->sta.txq), size, gfp);
-		if (!txq_data)
+		if (!txq_data) {
+			ret = -ENOMEM;
 			goto free;
+		}
 
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct txq_info *txq = txq_data + i * size;
@@ -361,7 +365,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (sta_prepare_rate_control(local, sta, gfp))
+	ret = sta_prepare_rate_control(local, sta, gfp);
+	if (ret)
 		goto free_txq;
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
@@ -418,7 +423,7 @@ free:
 	kfree(sta->mesh);
 #endif
 	kfree(sta);
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static int sta_info_insert_check(struct sta_info *sta)
-- 
2.5.1

