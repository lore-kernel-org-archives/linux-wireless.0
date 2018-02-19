Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59708 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752899AbeBSMs5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:48:57 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Feb 2018 14:48:36 +0200
Message-Id: <20180219124847.27169-3-luca@coelho.fi> (sfid-20180219_134934_675575_C8DEBA1A)
In-Reply-To: <20180219124847.27169-1-luca@coelho.fi>
References: <20180219124847.27169-1-luca@coelho.fi>
Subject: [PATCH v2 02/13] mac80211: ibss: send a probe request instead of allocating station
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When we hear frames from IBSS that we don't have a station
for, we allocate the station in the RX path with incomplete
data.

Instead, send a probe request to the station.

This helps to solve an issue with iwlwifi, which cannot allocate
stations in atomic paths, and has the added values of having full
data of the station and getting rid from some code.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ibss.c        | 54 +++++-----------------------------------------
 net/mac80211/ieee80211_i.h |  3 ---
 2 files changed, 5 insertions(+), 52 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index db07e0de9a03..a89384904c94 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -691,7 +691,6 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct cfg80211_bss *cbss;
 	struct beacon_data *presp;
-	struct sta_info *sta;
 
 	if (!is_zero_ether_addr(ifibss->bssid)) {
 		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->chandef.chan,
@@ -710,18 +709,6 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 
 	sta_info_flush(sdata);
 
-	spin_lock_bh(&ifibss->incomplete_lock);
-	while (!list_empty(&ifibss->incomplete_stations)) {
-		sta = list_first_entry(&ifibss->incomplete_stations,
-				       struct sta_info, list);
-		list_del(&sta->list);
-		spin_unlock_bh(&ifibss->incomplete_lock);
-
-		sta_info_free(local, sta);
-		spin_lock_bh(&ifibss->incomplete_lock);
-	}
-	spin_unlock_bh(&ifibss->incomplete_lock);
-
 	netif_carrier_off(sdata->dev);
 
 	sdata->vif.bss_conf.ibss_joined = false;
@@ -1204,11 +1191,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
 	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_supported_band *sband;
-	enum nl80211_bss_scan_width scan_width;
-	int band;
 
 	/*
 	 * XXX: Consider removing the least recently used entry and
@@ -1232,23 +1215,12 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 		return;
 	}
-	band = chanctx_conf->def.chan->band;
-	scan_width = cfg80211_chandef_to_scan_width(&chanctx_conf->def);
-	rcu_read_unlock();
-
-	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
-	if (!sta)
-		return;
 
-	/* make sure mandatory rates are always added */
-	sband = local->hw.wiphy->bands[band];
-	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(sband, scan_width);
-
-	spin_lock(&ifibss->incomplete_lock);
-	list_add(&sta->list, &ifibss->incomplete_stations);
-	spin_unlock(&ifibss->incomplete_lock);
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	ieee80211_send_probe_req(sdata, sdata->vif.addr, addr,
+				 sdata->u.ibss.ssid, sdata->u.ibss.ssid_len,
+				 NULL, 0, (u32)-1, true, 0,
+				 chanctx_conf->def.chan, false);
+	rcu_read_unlock();
 }
 
 static void ieee80211_ibss_sta_expire(struct ieee80211_sub_if_data *sdata)
@@ -1670,7 +1642,6 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct sta_info *sta;
 
 	sdata_lock(sdata);
 
@@ -1682,19 +1653,6 @@ void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 	if (!ifibss->ssid_len)
 		goto out;
 
-	spin_lock_bh(&ifibss->incomplete_lock);
-	while (!list_empty(&ifibss->incomplete_stations)) {
-		sta = list_first_entry(&ifibss->incomplete_stations,
-				       struct sta_info, list);
-		list_del(&sta->list);
-		spin_unlock_bh(&ifibss->incomplete_lock);
-
-		ieee80211_ibss_finish_sta(sta);
-		rcu_read_unlock();
-		spin_lock_bh(&ifibss->incomplete_lock);
-	}
-	spin_unlock_bh(&ifibss->incomplete_lock);
-
 	switch (ifibss->state) {
 	case IEEE80211_IBSS_MLME_SEARCH:
 		ieee80211_sta_find_ibss(sdata);
@@ -1724,8 +1682,6 @@ void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
 	timer_setup(&ifibss->timer, ieee80211_ibss_timer, 0);
-	INIT_LIST_HEAD(&ifibss->incomplete_stations);
-	spin_lock_init(&ifibss->incomplete_lock);
 	INIT_WORK(&ifibss->csa_connection_drop_work,
 		  ieee80211_csa_connection_drop_work);
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 26900025de2f..536f04d14592 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -581,9 +581,6 @@ struct ieee80211_if_ibss {
 	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
 	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
 
-	spinlock_t incomplete_lock;
-	struct list_head incomplete_stations;
-
 	enum {
 		IEEE80211_IBSS_MLME_SEARCH,
 		IEEE80211_IBSS_MLME_JOINED,
-- 
2.15.1
