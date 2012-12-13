Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2LMW7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:59:20 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
	Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/5] mac80211: remove final sta_info_flush()
Date: Thu, 13 Dec 2012 23:59:31 +0100
Message-Id: <1355439573-13206-4-git-send-email-johannes@sipsolutions.net> (sfid-20121213_235930_404393_23399751)
In-Reply-To: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When all interfaces have been removed, there can't
be any stations left over, so there's no need to
flush again. Remove this, and all code associated
with it, which also simplifies the function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c      |  7 +++----
 net/mac80211/ibss.c     |  4 ++--
 net/mac80211/iface.c    |  5 ++---
 net/mac80211/mesh.c     |  2 +-
 net/mac80211/mlme.c     |  2 +-
 net/mac80211/sta_info.c | 23 ++++++-----------------
 net/mac80211/sta_info.h |  3 +--
 7 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a813735..58a4362 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1010,8 +1010,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		kfree_rcu(old_probe_resp, rcu_head);
 
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
-		sta_info_flush(local, vlan);
-	sta_info_flush(local, sdata);
+		sta_info_flush(vlan);
+	sta_info_flush(sdata);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
 	drv_stop_ap(sdata->local, sdata);
@@ -1301,7 +1301,6 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1309,7 +1308,7 @@ static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 	if (mac)
 		return sta_info_destroy_addr_bss(sdata, mac);
 
-	sta_info_flush(local, sdata);
+	sta_info_flush(sdata);
 	return 0;
 }
 
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5e54c15..6cd6979 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -67,7 +67,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	skb_reserve(skb, sdata->local->hw.extra_tx_headroom);
 
 	if (!ether_addr_equal(ifibss->bssid, bssid))
-		sta_info_flush(sdata->local, sdata);
+		sta_info_flush(sdata);
 
 	/* if merging, indicate to driver that we leave the old IBSS */
 	if (sdata->vif.bss_conf.ibss_joined) {
@@ -1182,7 +1182,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
-	sta_info_flush(sdata->local, sdata);
+	sta_info_flush(sdata);
 
 	spin_lock_bh(&ifibss->incomplete_lock);
 	while (!list_empty(&ifibss->incomplete_stations)) {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0f2a9f9..36109eb 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -785,7 +785,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	 * all other modes we've already removed all stations when
 	 * disconnecting etc.
 	 */
-	sta_info_flush(local, sdata);
+	sta_info_flush(sdata);
 
 	/*
 	 * Don't count this interface for promisc/allmulti while it
@@ -970,7 +970,6 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
  */
 static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
 	int flushed;
 	int i;
 
@@ -986,7 +985,7 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_rmc_free(sdata);
 
-	flushed = sta_info_flush(local, sdata);
+	flushed = sta_info_flush(sdata);
 	WARN_ON(flushed);
 }
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 9b00c2c..f5f01e0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -656,7 +656,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
 	/* flush STAs and mpaths on this iface */
-	sta_info_flush(sdata->local, sdata);
+	sta_info_flush(sdata);
 	mesh_path_flush_by_iface(sdata);
 
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7753a9c..7cbb4cb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1518,7 +1518,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	memset(ifmgd->bssid, 0, ETH_ALEN);
 
 	/* remove AP and TDLS peers */
-	sta_info_flush(local, sdata);
+	sta_info_flush(sdata);
 
 	/* finally reset all BSS / config parameters */
 	changed |= ieee80211_reset_erp_info(sdata);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 527453d..1a84a52 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -885,7 +885,6 @@ void sta_info_init(struct ieee80211_local *local)
 void sta_info_stop(struct ieee80211_local *local)
 {
 	del_timer_sync(&local->sta_cleanup);
-	sta_info_flush(local, NULL);
 }
 
 /**
@@ -893,12 +892,11 @@ void sta_info_stop(struct ieee80211_local *local)
  *
  * Returns the number of removed STA entries.
  *
- * @local: local interface data
- * @sdata: matching rule for the net device (sta->dev) or %NULL to match all STAs
+ * @sdata: sdata to remove all stations from
  */
-int sta_info_flush(struct ieee80211_local *local,
-		   struct ieee80211_sub_if_data *sdata)
+int sta_info_flush(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta, *tmp;
 	int ret = 0;
 
@@ -906,7 +904,7 @@ int sta_info_flush(struct ieee80211_local *local,
 
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
-		if (!sdata || sdata == sta->sdata) {
+		if (sdata == sta->sdata) {
 			WARN_ON(__sta_info_destroy(sta));
 			ret++;
 		}
@@ -915,17 +913,8 @@ int sta_info_flush(struct ieee80211_local *local,
 
 	rcu_barrier();
 
-	if (sdata) {
-		ieee80211_cleanup_sdata_stas(sdata);
-		cancel_work_sync(&sdata->cleanup_stations_wk);
-	} else {
-		mutex_lock(&local->iflist_mtx);
-		list_for_each_entry(sdata, &local->interfaces, list) {
-			ieee80211_cleanup_sdata_stas(sdata);
-			cancel_work_sync(&sdata->cleanup_stations_wk);
-		}
-		mutex_unlock(&local->iflist_mtx);
-	}
+	ieee80211_cleanup_sdata_stas(sdata);
+	cancel_work_sync(&sdata->cleanup_stations_wk);
 
 	return ret;
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 37c1889..13698da 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -548,8 +548,7 @@ void sta_info_recalc_tim(struct sta_info *sta);
 
 void sta_info_init(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
-int sta_info_flush(struct ieee80211_local *local,
-		   struct ieee80211_sub_if_data *sdata);
+int sta_info_flush(struct ieee80211_sub_if_data *sdata);
 void sta_set_rate_info_tx(struct sta_info *sta,
 			  const struct ieee80211_tx_rate *rate,
 			  struct rate_info *rinfo);
-- 
1.8.0

