Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:34514 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966390AbcIYQkF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Sep 2016 12:40:05 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211: cache the only AP_VLAN station
Date: Sun, 25 Sep 2016 18:39:56 +0200
Message-Id: <1474821596-12155-4-git-send-email-michael-dev@fami-braun.de> (sfid-20160925_184018_382239_271E290A)
In-Reply-To: <1474821596-12155-1-git-send-email-michael-dev@fami-braun.de>
References: <1474821596-12155-1-git-send-email-michael-dev@fami-braun.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If an AP_VLAN is only used with one station, cache a pointer to this station to
avoid lookup. This should speed up station lookup when there is only one
station assigned to the AP_VLAN interface, e.g. when using hostapd with
per_sta_vif.

Assigning only one station per AP_VLAN interfaces enables bridge IGMP snooping
to track multicast subscriptions by station to selectively forward to only
those stations that subscribed.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/cfg.c         | 10 ++++++++--
 net/mac80211/ieee80211_i.h | 14 ++++++++++----
 net/mac80211/sta_info.c    | 33 +++++++++++++++++++++++++++++++--
 net/mac80211/tx.c          |  5 +++++
 4 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 078e837..a69e6f2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -67,6 +67,7 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 	if (type == NL80211_IFTYPE_AP_VLAN &&
 	    params && params->use_4addr == 0) {
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
+		RCU_INIT_POINTER(sdata->u.vlan.sta0, NULL);
 		ieee80211_check_fast_rx_iface(sdata);
 	} else if (type == NL80211_IFTYPE_STATION &&
 		   params && params->use_4addr >= 0) {
@@ -1379,8 +1380,13 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		sta->sdata = vlansdata;
 		ieee80211_check_fast_xmit(sta);
 
-		if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
-			ieee80211_vif_inc_num_mcast(sta->sdata);
+		if (test_sta_flag(sta, WLAN_STA_AUTHORIZED) &&
+		    ieee80211_vif_inc_num_mcast(sta->sdata) == 1 &&
+		    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			rcu_assign_pointer(vlansdata->u.vlan.sta0, sta);
+		else if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+			 test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+			RCU_INIT_POINTER(vlansdata->u.vlan.sta0, NULL);
 
 		ieee80211_send_layer2_update(sta);
 	}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7b3de28..48a141f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -307,6 +307,8 @@ struct ieee80211_if_vlan {
 
 	/* used for all tx if the VLAN is configured to 4-addr mode */
 	struct sta_info __rcu *sta;
+	/* the one and only authenticated station in non 4-addr mode if set */
+	struct sta_info __rcu *sta0;
 	atomic_t num_mcast_sta_if; /* number of stations receiving multicast */
 };
 
@@ -1499,21 +1501,25 @@ ieee80211_have_rx_timestamp(struct ieee80211_rx_status *status)
 	return false;
 }
 
-static inline void
+static inline int
 ieee80211_vif_inc_num_mcast(struct ieee80211_sub_if_data *sdata)
 {
+	int ret;
+
 	if (sdata->vif.type != NL80211_IFTYPE_AP &&
 	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
-		return;
+		return -1;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP)
-		atomic_inc(&sdata->u.ap.num_mcast_sta_if);
+		ret = atomic_inc_return(&sdata->u.ap.num_mcast_sta_if);
 	else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		atomic_inc(&sdata->u.vlan.num_mcast_sta_if);
+		ret = atomic_inc_return(&sdata->u.vlan.num_mcast_sta_if);
 
 	if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN ||
 	    !sdata->u.vlan.sta) /* except 4addr mode */
 		atomic_inc(&sdata->bss->num_mcast_sta);
+
+	return ret;
 }
 
 static inline void
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 216ef65..d1c5d96 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -162,11 +162,28 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
+	struct sta_info *sta = NULL;
 	struct rhash_head *tmp;
 	const struct bucket_table *tbl;
 
 	rcu_read_lock();
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+	    !sdata->u.vlan.sta)
+		sta = rcu_dereference(sdata->u.vlan.sta0);
+
+	WARN_ONCE((sta && sta->sdata != sdata),
+		  "sdata->u.vlan.sta0->sdata != sdata");
+
+	if (sta && sta->sdata == sdata &&
+	    ether_addr_equal(sta->sta.addr, addr)) {
+		rcu_read_unlock();
+		/* this is safe as the caller must already hold
+		 * another rcu read section or the mutex
+		 */
+		return sta;
+	}
+
 	tbl = rht_dereference_rcu(local->sta_hash.tbl, &local->sta_hash);
 
 	for_each_sta_info(local, tbl, addr, sta, tmp) {
@@ -920,6 +937,10 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+	    rcu_access_pointer(sdata->u.vlan.sta0) == sta)
+		RCU_INIT_POINTER(sdata->u.vlan.sta0, NULL);
+
 	return 0;
 }
 
@@ -1883,6 +1904,9 @@ int sta_info_move_state(struct sta_info *sta,
 				ieee80211_recalc_p2p_go_ps_allowed(sta->sdata);
 		} else if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
 			ieee80211_vif_dec_num_mcast(sta->sdata);
+			if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+			    rcu_access_pointer(sta->sdata->u.vlan.sta0) == sta)
+				RCU_INIT_POINTER(sta->sdata->u.vlan.sta0, NULL);
 			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 			ieee80211_clear_fast_xmit(sta);
 			ieee80211_clear_fast_rx(sta);
@@ -1890,7 +1914,12 @@ int sta_info_move_state(struct sta_info *sta,
 		break;
 	case IEEE80211_STA_AUTHORIZED:
 		if (sta->sta_state == IEEE80211_STA_ASSOC) {
-			ieee80211_vif_inc_num_mcast(sta->sdata);
+			if (ieee80211_vif_inc_num_mcast(sta->sdata) == 1 &&
+			    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+				rcu_assign_pointer(sta->sdata->u.vlan.sta0,
+						   sta);
+			else if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+				RCU_INIT_POINTER(sta->sdata->u.vlan.sta0, NULL);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 			ieee80211_check_fast_xmit(sta);
 			ieee80211_check_fast_rx(sta);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9c82fd8..c06d5f9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1808,6 +1808,7 @@ ieee80211_tx_multicast_to_unicast(struct ieee80211_sub_if_data *sdata,
 		sta = rcu_dereference(sdata->u.vlan.sta);
 		if (sta) /* 4addr */
 			return 0;
+		prev = rcu_dereference(sdata->u.vlan.sta0);
 	case NL80211_IFTYPE_AP:
 		break;
 	default:
@@ -1839,6 +1840,9 @@ ieee80211_tx_multicast_to_unicast(struct ieee80211_sub_if_data *sdata,
 		return 0;
 	}
 
+	if (prev)
+		goto skip_lookup;
+
 	/* clone packets and update destination mac */
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		if (sdata != sta->sdata)
@@ -1862,6 +1866,7 @@ ieee80211_tx_multicast_to_unicast(struct ieee80211_sub_if_data *sdata,
 		prev = sta;
 	}
 
+skip_lookup:
 	if (likely(prev)) {
 		ieee80211_tx_dnat(skb, prev);
 		return 0;
-- 
2.1.4
