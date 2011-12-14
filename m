Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab1LNNIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 08:08:14 -0500
Message-Id: <20111214130549.059007128@sipsolutions.net> (sfid-20111214_140820_296437_25E7EB08)
Date: Wed, 14 Dec 2011 14:03:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: delay IBSS station insertion
References: <20111214130338.347106528@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to notify drivers and simplify the station
management code, defer IBSS station insertion to a
work item and don't do it directly while receiving
a frame.

This increases the complexity in IBSS a little bit,
but it's pretty straight forward and it allows us
to reduce the station management complexity (next
patch) considerably.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        |  154 +++++++++++++++++++++++++++++++++++----------
 net/mac80211/ieee80211_i.h |    8 +-
 net/mac80211/rx.c          |    4 -
 net/mac80211/sta_info.c    |    2 
 4 files changed, 130 insertions(+), 38 deletions(-)

--- a/net/mac80211/ibss.c	2011-12-14 13:29:08.000000000 +0100
+++ b/net/mac80211/ibss.c	2011-12-14 13:57:18.000000000 +0100
@@ -275,6 +275,80 @@ static void ieee80211_sta_join_ibss(stru
 				  cbss->tsf);
 }
 
+static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
+	__acquires(RCU)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u8 addr[ETH_ALEN];
+
+	memcpy(addr, sta->sta.addr, ETH_ALEN);
+
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	wiphy_debug(sdata->local->hw.wiphy,
+		    "Adding new IBSS station %pM (dev=%s)\n",
+		    addr, sdata->name);
+#endif
+
+	sta_info_move_state(sta, IEEE80211_STA_AUTH);
+	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+	sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
+
+	rate_control_rate_init(sta);
+
+	/* If it fails, maybe we raced another insertion? */
+	if (sta_info_insert_rcu(sta))
+		return sta_info_get(sdata, addr);
+	return sta;
+}
+
+static struct sta_info *
+ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
+		       const u8 *bssid, const u8 *addr,
+		       u32 supp_rates)
+	__acquires(RCU)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	int band = local->hw.conf.channel->band;
+
+	/*
+	 * XXX: Consider removing the least recently used entry and
+	 * 	allow new one to be added.
+	 */
+	if (local->num_sta >= IEEE80211_IBSS_MAX_STA_ENTRIES) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: No room for a new IBSS STA entry %pM\n",
+			       sdata->name, addr);
+		rcu_read_lock();
+		return NULL;
+	}
+
+	if (ifibss->state == IEEE80211_IBSS_MLME_SEARCH) {
+		rcu_read_lock();
+		return NULL;
+	}
+
+	if (compare_ether_addr(bssid, sdata->u.ibss.bssid)) {
+		rcu_read_lock();
+		return NULL;
+	}
+
+	sta = sta_info_alloc(sdata, addr, GFP_KERNEL);
+	if (!sta) {
+		rcu_read_lock();
+		return NULL;
+	}
+
+	sta->last_rx = jiffies;
+
+	/* make sure mandatory rates are always added */
+	sta->sta.supp_rates[band] = supp_rates |
+			ieee80211_mandatory_rates(local, band);
+
+	return ieee80211_ibss_finish_sta(sta);
+}
+
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
@@ -334,10 +408,11 @@ static void ieee80211_rx_bss_info(struct
 #endif
 					rates_updated = true;
 				}
-			} else
+			} else {
+				rcu_read_unlock();
 				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
-						mgmt->sa, supp_rates,
-						GFP_ATOMIC);
+						mgmt->sa, supp_rates);
+			}
 		}
 
 		if (sta && elems->wmm_info)
@@ -464,21 +539,17 @@ static void ieee80211_rx_bss_info(struct
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-				       supp_rates, GFP_KERNEL);
+				       supp_rates);
+		rcu_read_unlock();
 	}
 
  put_bss:
 	ieee80211_rx_bss_put(local, bss);
 }
 
-/*
- * Add a new IBSS station, will also be called by the RX code when,
- * in IBSS mode, receiving a frame from a yet-unknown station, hence
- * must be callable in atomic context.
- */
-struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid, u8 *addr, u32 supp_rates,
-					gfp_t gfp)
+void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
+			      const u8 *bssid, const u8 *addr,
+			      u32 supp_rates)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
@@ -493,40 +564,29 @@ struct sta_info *ieee80211_ibss_add_sta(
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: No room for a new IBSS STA entry %pM\n",
 			       sdata->name, addr);
-		return NULL;
+		return;
 	}
 
 	if (ifibss->state == IEEE80211_IBSS_MLME_SEARCH)
-		return NULL;
+		return;
 
 	if (compare_ether_addr(bssid, sdata->u.ibss.bssid))
-		return NULL;
-
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	wiphy_debug(local->hw.wiphy, "Adding new IBSS station %pM (dev=%s)\n",
-		    addr, sdata->name);
-#endif
+		return;
 
-	sta = sta_info_alloc(sdata, addr, gfp);
+	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
 	if (!sta)
-		return NULL;
+		return;
 
 	sta->last_rx = jiffies;
 
-	sta_info_move_state(sta, IEEE80211_STA_AUTH);
-	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
-	sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
-
 	/* make sure mandatory rates are always added */
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
-	rate_control_rate_init(sta);
-
-	/* If it fails, maybe we raced another insertion? */
-	if (sta_info_insert(sta))
-		return sta_info_get(sdata, addr);
-	return sta;
+	spin_lock(&ifibss->incomplete_lock);
+	list_add(&sta->list, &ifibss->incomplete_stations);
+	spin_unlock(&ifibss->incomplete_lock);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
 static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
@@ -865,6 +925,7 @@ void ieee80211_ibss_rx_queued_mgmt(struc
 void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct sta_info *sta;
 
 	mutex_lock(&ifibss->mtx);
 
@@ -876,6 +937,19 @@ void ieee80211_ibss_work(struct ieee8021
 	if (!ifibss->ssid_len)
 		goto out;
 
+	spin_lock_bh(&ifibss->incomplete_lock);
+	while (!list_empty(&ifibss->incomplete_stations)) {
+		sta = list_first_entry(&ifibss->incomplete_stations,
+				       struct sta_info, list);
+		list_del(&sta->list);
+		spin_unlock_bh(&ifibss->incomplete_lock);
+
+		ieee80211_ibss_finish_sta(sta);
+		rcu_read_unlock();
+		spin_lock_bh(&ifibss->incomplete_lock);
+	}
+	spin_unlock_bh(&ifibss->incomplete_lock);
+
 	switch (ifibss->state) {
 	case IEEE80211_IBSS_MLME_SEARCH:
 		ieee80211_sta_find_ibss(sdata);
@@ -934,6 +1008,8 @@ void ieee80211_ibss_setup_sdata(struct i
 	setup_timer(&ifibss->timer, ieee80211_ibss_timer,
 		    (unsigned long) sdata);
 	mutex_init(&ifibss->mtx);
+	INIT_LIST_HEAD(&ifibss->incomplete_stations);
+	spin_lock_init(&ifibss->incomplete_lock);
 }
 
 /* scan finished notification */
@@ -1050,6 +1126,7 @@ int ieee80211_ibss_leave(struct ieee8021
 	struct cfg80211_bss *cbss;
 	u16 capability;
 	int active_ibss;
+	struct sta_info *sta;
 
 	mutex_lock(&sdata->u.ibss.mtx);
 
@@ -1078,6 +1155,19 @@ int ieee80211_ibss_leave(struct ieee8021
 	}
 
 	sta_info_flush(sdata->local, sdata);
+
+	spin_lock_bh(&ifibss->incomplete_lock);
+	while (!list_empty(&ifibss->incomplete_stations)) {
+		sta = list_first_entry(&ifibss->incomplete_stations,
+				       struct sta_info, list);
+		list_del(&sta->list);
+		spin_unlock_bh(&ifibss->incomplete_lock);
+
+		sta_info_free(local, sta);
+		spin_lock_bh(&ifibss->incomplete_lock);
+	}
+	spin_unlock_bh(&ifibss->incomplete_lock);
+
 	netif_carrier_off(sdata->dev);
 
 	/* remove beacon */
--- a/net/mac80211/ieee80211_i.h	2011-12-14 13:29:08.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2011-12-14 13:57:54.000000000 +0100
@@ -482,6 +482,9 @@ struct ieee80211_if_ibss {
 	struct sk_buff __rcu *presp;
 	struct sk_buff *skb;
 
+	spinlock_t incomplete_lock;
+	struct list_head incomplete_stations;
+
 	enum {
 		IEEE80211_IBSS_MLME_SEARCH,
 		IEEE80211_IBSS_MLME_JOINED,
@@ -1172,9 +1175,8 @@ void ieee80211_sta_reset_conn_monitor(st
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
-struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid, u8 *addr, u32 supp_rates,
-					gfp_t gfp);
+void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
+			      const u8 *bssid, const u8 *addr, u32 supp_rates);
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
--- a/net/mac80211/rx.c	2011-12-14 13:29:08.000000000 +0100
+++ b/net/mac80211/rx.c	2011-12-14 13:29:12.000000000 +0100
@@ -2775,8 +2775,8 @@ static int prepare_for_handlers(struct i
 				rate_idx = 0; /* TODO: HT rates */
 			else
 				rate_idx = status->rate_idx;
-			rx->sta = ieee80211_ibss_add_sta(sdata, bssid,
-					hdr->addr2, BIT(rate_idx), GFP_ATOMIC);
+			ieee80211_ibss_rx_no_sta(sdata, bssid, hdr->addr2,
+						 BIT(rate_idx));
 		}
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
--- a/net/mac80211/sta_info.c	2011-12-14 13:33:13.000000000 +0100
+++ b/net/mac80211/sta_info.c	2011-12-14 13:58:04.000000000 +0100
@@ -1521,7 +1521,7 @@ EXPORT_SYMBOL(ieee80211_sta_set_buffered
 int sta_info_move_state_checked(struct sta_info *sta,
 				enum ieee80211_sta_state new_state)
 {
-	/* might_sleep(); -- for driver notify later, fix IBSS first */
+	might_sleep();
 
 	if (sta->sta_state == new_state)
 		return 0;


