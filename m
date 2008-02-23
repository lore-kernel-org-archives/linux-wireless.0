Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbYBWOWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:22:10 -0500
Message-Id: <20080223142012.805513000@sipsolutions.net> (sfid-20080223_142216_020351_34B88BEF)
References: <20080223141703.194775000@sipsolutions.net>
Date: Sat, 23 Feb 2008 15:17:12 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 09/18] mac80211: mesh changes to the MLME
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis Carlos Cobo <luisca@cozybit.com>

This includes support for mesh network scanning. The ugly code in
ieee80211_sta_scan_result() is my approach to work around wext. This has been
tested with wireless tools version 29 and works as expected (the new interface
mode is just not shown).

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_sta.c |  322 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 263 insertions(+), 59 deletions(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2008-02-23 14:49:09.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-02-23 14:50:13.000000000 +0100
@@ -31,12 +31,16 @@
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "ieee80211_led.h"
+#ifdef CONFIG_MAC80211_MESH
+#include "mesh.h"
+#endif
 
 #define IEEE80211_AUTH_TIMEOUT (HZ / 5)
 #define IEEE80211_AUTH_MAX_TRIES 3
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
 #define IEEE80211_MONITORING_INTERVAL (2 * HZ)
+#define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
 #define IEEE80211_PROBE_INTERVAL (60 * HZ)
 #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
 #define IEEE80211_SCAN_INTERVAL (2 * HZ)
@@ -49,6 +53,7 @@
 #define IEEE80211_SCAN_RESULT_EXPIRE (10 * HZ)
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
 #define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
+#define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
@@ -1890,8 +1895,15 @@ static void __ieee80211_rx_bss_hash_add(
 					struct ieee80211_sta_bss *bss)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	bss->hnext = local->sta_bss_hash[STA_HASH(bss->bssid)];
-	local->sta_bss_hash[STA_HASH(bss->bssid)] = bss;
+	u8 hash_idx;
+#ifdef CONFIG_MAC80211_MESH
+	if (bss->mesh_cfg)
+		hash_idx = mesh_id_hash(bss->mesh_id, bss->mesh_id_len);
+	else
+#endif
+		hash_idx = STA_HASH(bss->bssid);
+	bss->hnext = local->sta_bss_hash[hash_idx];
+	local->sta_bss_hash[hash_idx] = bss;
 }
 
 
@@ -1944,7 +1956,6 @@ ieee80211_rx_bss_add(struct net_device *
 	return bss;
 }
 
-
 static struct ieee80211_sta_bss *
 ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
@@ -1955,7 +1966,7 @@ ieee80211_rx_bss_get(struct net_device *
 	spin_lock_bh(&local->sta_bss_lock);
 	bss = local->sta_bss_hash[STA_HASH(bssid)];
 	while (bss) {
-		if (!memcmp(bss->bssid, bssid, ETH_ALEN) &&
+		if (!bss->mesh_cfg && !memcmp(bss->bssid, bssid, ETH_ALEN) &&
 		    bss->freq == freq &&
 		    bss->ssid_len == ssid_len &&
 		    (ssid_len == 0 || !memcmp(bss->ssid, ssid, ssid_len))) {
@@ -1968,6 +1979,72 @@ ieee80211_rx_bss_get(struct net_device *
 	return bss;
 }
 
+#ifdef CONFIG_MAC80211_MESH
+static struct ieee80211_sta_bss *
+ieee80211_rx_mesh_bss_get(struct net_device *dev, u8 *mesh_id, int mesh_id_len,
+			  u8 *mesh_cfg, int freq)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sta_bss *bss;
+
+	spin_lock_bh(&local->sta_bss_lock);
+	bss = local->sta_bss_hash[mesh_id_hash(mesh_id, mesh_id_len)];
+	while (bss) {
+		if (bss->mesh_cfg &&
+		    !memcmp(bss->mesh_cfg, mesh_cfg, MESH_CFG_CMP_LEN) &&
+		    bss->freq == freq &&
+		    mesh_id_len == bss->mesh_id_len &&
+		    (mesh_id_len == 0 || !memcmp(bss->mesh_id, mesh_id,
+						 mesh_id_len))) {
+			atomic_inc(&bss->users);
+			break;
+		}
+		bss = bss->hnext;
+	}
+	spin_unlock_bh(&local->sta_bss_lock);
+	return bss;
+}
+
+static struct ieee80211_sta_bss *
+ieee80211_rx_mesh_bss_add(struct net_device *dev, u8 *mesh_id, int mesh_id_len,
+			  u8 *mesh_cfg, int freq)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sta_bss *bss;
+
+	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
+	if (!bss)
+		return NULL;
+
+	bss->mesh_cfg = kmalloc(MESH_CFG_CMP_LEN, GFP_ATOMIC);
+	if (!bss->mesh_cfg) {
+		kfree(bss);
+		return NULL;
+	}
+
+	if (mesh_id_len && mesh_id_len <= IEEE80211_MAX_MESH_ID_LEN) {
+		bss->mesh_id = kmalloc(mesh_id_len, GFP_ATOMIC);
+		if (!bss->mesh_id) {
+			kfree(bss->mesh_cfg);
+			kfree(bss);
+			return NULL;
+		}
+		memcpy(bss->mesh_id, mesh_id, mesh_id_len);
+	}
+
+	atomic_inc(&bss->users);
+	atomic_inc(&bss->users);
+	memcpy(bss->mesh_cfg, mesh_cfg, MESH_CFG_CMP_LEN);
+	bss->mesh_id_len = mesh_id_len;
+	bss->freq = freq;
+	spin_lock_bh(&local->sta_bss_lock);
+	/* TODO: order by RSSI? */
+	list_add_tail(&bss->list, &local->sta_bss_list);
+	__ieee80211_rx_bss_hash_add(dev, bss);
+	spin_unlock_bh(&local->sta_bss_lock);
+	return bss;
+}
+#endif
 
 static void ieee80211_rx_bss_free(struct ieee80211_sta_bss *bss)
 {
@@ -1975,6 +2052,10 @@ static void ieee80211_rx_bss_free(struct
 	kfree(bss->rsn_ie);
 	kfree(bss->wmm_ie);
 	kfree(bss->ht_ie);
+#ifdef CONFIG_MAC80211_MESH
+	kfree(bss->mesh_id);
+	kfree(bss->mesh_cfg);
+#endif
 	kfree(bss);
 }
 
@@ -2170,6 +2251,42 @@ static int ieee80211_sta_join_ibss(struc
 	return res;
 }
 
+u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
+			    struct ieee802_11_elems *elems,
+			    enum ieee80211_band band)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
+	size_t num_rates;
+	u64 supp_rates;
+	int i, j;
+	sband = local->hw.wiphy->bands[band];
+
+	if (!sband) {
+		WARN_ON(1);
+		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	}
+
+	bitrates = sband->bitrates;
+	num_rates = sband->n_bitrates;
+	supp_rates = 0;
+	for (i = 0; i < elems->supp_rates_len +
+		     elems->ext_supp_rates_len; i++) {
+		u8 rate = 0;
+		int own_rate;
+		if (i < elems->supp_rates_len)
+			rate = elems->supp_rates[i];
+		else if (elems->ext_supp_rates)
+			rate = elems->ext_supp_rates
+				[i - elems->supp_rates_len];
+		own_rate = 5 * (rate & 0x7f);
+		for (j = 0; j < num_rates; j++)
+			if (bitrates[j].bitrate == own_rate)
+				supp_rates |= BIT(j);
+	}
+	return supp_rates;
+}
+
 
 static void ieee80211_rx_bss_info(struct net_device *dev,
 				  struct ieee80211_mgmt *mgmt,
@@ -2204,41 +2321,23 @@ static void ieee80211_rx_bss_info(struct
 	beacon_timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
+#ifdef CONFIG_MAC80211_MESH
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT && elems.mesh_id
+			&& elems.mesh_config)
+		if (mesh_matches_local(&elems, dev)) {
+			u64 rates = ieee80211_sta_get_rates(local, &elems,
+							rx_status->band);
+			mesh_neighbour_update(mgmt->sa, rates, dev,
+				mesh_peer_accepts_plinks(&elems, dev));
+		}
+#endif
+
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
 	    (sta = sta_info_get(local, mgmt->sa))) {
-		struct ieee80211_supported_band *sband;
-		struct ieee80211_rate *bitrates;
-		size_t num_rates;
-		u64 supp_rates, prev_rates;
-		int i, j;
-
-		sband = local->hw.wiphy->bands[rx_status->band];
-
-		if (!sband) {
-			WARN_ON(1);
-			sband = local->hw.wiphy->bands[
-					local->hw.conf.channel->band];
-		}
-
-		bitrates = sband->bitrates;
-		num_rates = sband->n_bitrates;
-
-		supp_rates = 0;
-		for (i = 0; i < elems.supp_rates_len +
-			     elems.ext_supp_rates_len; i++) {
-			u8 rate = 0;
-			int own_rate;
-			if (i < elems.supp_rates_len)
-				rate = elems.supp_rates[i];
-			else if (elems.ext_supp_rates)
-				rate = elems.ext_supp_rates
-					[i - elems.supp_rates_len];
-			own_rate = 5 * (rate & 0x7f);
-			for (j = 0; j < num_rates; j++)
-				if (bitrates[j].bitrate == own_rate)
-					supp_rates |= BIT(j);
-		}
+		u64 prev_rates;
+		u64 supp_rates = ieee80211_sta_get_rates(local, &elems,
+							rx_status->band);
 
 		prev_rates = sta->supp_rates[rx_status->band];
 		sta->supp_rates[rx_status->band] &= supp_rates;
@@ -2261,19 +2360,28 @@ static void ieee80211_rx_bss_info(struct
 		sta_info_put(sta);
 	}
 
-	if (!elems.ssid)
-		return;
-
 	if (elems.ds_params && elems.ds_params_len == 1)
 		freq = ieee80211_channel_to_frequency(elems.ds_params[0]);
 	else
 		freq = rx_status->freq;
 
-	bss = ieee80211_rx_bss_get(dev, mgmt->bssid, freq,
-				   elems.ssid, elems.ssid_len);
-	if (!bss) {
-		bss = ieee80211_rx_bss_add(dev, mgmt->bssid, freq,
+#ifdef CONFIG_MAC80211_MESH
+	if (elems.mesh_config)
+		bss = ieee80211_rx_mesh_bss_get(dev, elems.mesh_id,
+				elems.mesh_id_len, elems.mesh_config, freq);
+	else
+#endif
+		bss = ieee80211_rx_bss_get(dev, mgmt->bssid, freq,
 					   elems.ssid, elems.ssid_len);
+	if (!bss) {
+#ifdef CONFIG_MAC80211_MESH
+		if (elems.mesh_config)
+			bss = ieee80211_rx_mesh_bss_add(dev, elems.mesh_id,
+				elems.mesh_id_len, elems.mesh_config, freq);
+		else
+#endif
+			bss = ieee80211_rx_bss_add(dev, mgmt->bssid, freq,
+						   elems.ssid, elems.ssid_len);
 		if (!bss)
 			return;
 	} else {
@@ -2600,8 +2708,13 @@ static void ieee80211_rx_mgmt_probe_req(
 static void ieee80211_rx_mgmt_action(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta,
 				     struct ieee80211_mgmt *mgmt,
-				     size_t len)
+				     size_t len,
+				     struct ieee80211_rx_status *rx_status)
 {
+#ifdef CONFIG_MAC80211_MESH
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+#endif
+
 	if (len < IEEE80211_MIN_ACTION_SIZE)
 		return;
 
@@ -2633,7 +2746,21 @@ static void ieee80211_rx_mgmt_action(str
 			break;
 		}
 		break;
+#ifdef CONFIG_MAC80211_MESH
+	case PLINK_CATEGORY:
+		if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+			mesh_rx_plink_frame(dev, mgmt, len, rx_status);
+		break;
+
+	case MESH_PATH_SEL_CATEGORY:
+		if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+			mesh_rx_path_sel_frame(dev, mgmt, len);
+		break;
+#endif
 	default:
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: Rx unknown action frame - "
+			"category=%d\n", dev->name, mgmt->u.action.category);
 		break;
 	}
 }
@@ -2660,13 +2787,13 @@ void ieee80211_sta_rx_mgmt(struct net_de
 	case IEEE80211_STYPE_PROBE_REQ:
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
+	case IEEE80211_STYPE_ACTION:
 		memcpy(skb->cb, rx_status, sizeof(*rx_status));
 	case IEEE80211_STYPE_AUTH:
 	case IEEE80211_STYPE_ASSOC_RESP:
 	case IEEE80211_STYPE_REASSOC_RESP:
 	case IEEE80211_STYPE_DEAUTH:
 	case IEEE80211_STYPE_DISASSOC:
-	case IEEE80211_STYPE_ACTION:
 		skb_queue_tail(&ifsta->skb_queue, skb);
 		queue_work(local->hw.workqueue, &ifsta->work);
 		return;
@@ -2725,7 +2852,7 @@ static void ieee80211_sta_rx_queued_mgmt
 		ieee80211_rx_mgmt_disassoc(dev, ifsta, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_ACTION:
-		ieee80211_rx_mgmt_action(dev, ifsta, mgmt, skb->len);
+		ieee80211_rx_mgmt_action(dev, ifsta, mgmt, skb->len, rx_status);
 		break;
 	}
 
@@ -2790,7 +2917,7 @@ static int ieee80211_sta_active_ibss(str
 }
 
 
-static void ieee80211_sta_expire(struct net_device *dev)
+static void ieee80211_sta_expire(struct net_device *dev, unsigned long exp_time)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta, *tmp;
@@ -2799,8 +2926,7 @@ static void ieee80211_sta_expire(struct 
 
 	write_lock_bh(&local->sta_lock);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
-		if (time_after(jiffies, sta->last_rx +
-			       IEEE80211_IBSS_INACTIVITY_LIMIT)) {
+		if (time_after(jiffies, sta->last_rx + exp_time)) {
 			printk(KERN_DEBUG "%s: expiring inactive STA %s\n",
 			       dev->name, print_mac(mac, sta->addr));
 			__sta_info_get(sta);
@@ -2821,7 +2947,7 @@ static void ieee80211_sta_merge_ibss(str
 {
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
 
-	ieee80211_sta_expire(dev);
+	ieee80211_sta_expire(dev, IEEE80211_IBSS_INACTIVITY_LIMIT);
 	if (ieee80211_sta_active_ibss(dev))
 		return;
 
@@ -2831,6 +2957,36 @@ static void ieee80211_sta_merge_ibss(str
 }
 
 
+#ifdef CONFIG_MAC80211_MESH
+static void ieee80211_mesh_housekeeping(struct net_device *dev,
+			   struct ieee80211_if_sta *ifsta)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	bool free_plinks;
+
+	ieee80211_sta_expire(dev, IEEE80211_MESH_PEER_INACTIVITY_LIMIT);
+	mesh_path_expire(dev);
+
+	free_plinks = mesh_plink_availables(sdata);
+	if (free_plinks != sdata->u.sta.accepting_plinks)
+		ieee80211_if_config_beacon(dev);
+
+	mod_timer(&ifsta->timer, jiffies +
+			IEEE80211_MESH_HOUSEKEEPING_INTERVAL);
+}
+
+
+void ieee80211_start_mesh(struct net_device *dev)
+{
+	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	ifsta = &sdata->u.sta;
+	ifsta->state = IEEE80211_MESH_UP;
+	ieee80211_sta_timer((unsigned long)sdata);
+}
+#endif
+
+
 void ieee80211_sta_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -2842,7 +2998,6 @@ void ieee80211_sta_timer(unsigned long d
 	queue_work(local->hw.workqueue, &ifsta->work);
 }
 
-
 void ieee80211_sta_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -2859,7 +3014,8 @@ void ieee80211_sta_work(struct work_stru
 		return;
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS) {
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+	    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT) {
 		printk(KERN_DEBUG "%s: ieee80211_sta_work: non-STA interface "
 		       "(type=%d)\n", dev->name, sdata->vif.type);
 		return;
@@ -2869,6 +3025,12 @@ void ieee80211_sta_work(struct work_stru
 	while ((skb = skb_dequeue(&ifsta->skb_queue)))
 		ieee80211_sta_rx_queued_mgmt(dev, skb);
 
+#ifdef CONFIG_MAC80211_MESH
+	if (ifsta->preq_queue_len && time_after(jiffies, ifsta->last_preq +
+		msecs_to_jiffies(ifsta->mshcfg.dot11MeshHWMPpreqMinInterval)))
+		mesh_path_start_discovery(dev);
+#endif
+
 	if (ifsta->state != IEEE80211_AUTHENTICATE &&
 	    ifsta->state != IEEE80211_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
@@ -2904,6 +3066,11 @@ void ieee80211_sta_work(struct work_stru
 	case IEEE80211_IBSS_JOINED:
 		ieee80211_sta_merge_ibss(dev, ifsta);
 		break;
+#ifdef CONFIG_MAC80211_MESH
+	case IEEE80211_MESH_UP:
+		ieee80211_mesh_housekeeping(dev, ifsta);
+		break;
+#endif
 	default:
 		printk(KERN_DEBUG "ieee80211_sta_work: Unknown state %d\n",
 		       ifsta->state);
@@ -3108,7 +3275,7 @@ static int ieee80211_sta_create_ibss(str
 	sband = local->hw.wiphy->bands[bss->band];
 
 	if (local->hw.conf.beacon_int == 0)
-		local->hw.conf.beacon_int = 100;
+		local->hw.conf.beacon_int = 10000;
 	bss->beacon_int = local->hw.conf.beacon_int;
 	bss->last_update = jiffies;
 	bss->capability = WLAN_CAPABILITY_IBSS;
@@ -3397,6 +3564,9 @@ void ieee80211_scan_completed(struct iee
 			ieee80211_sta_timer((unsigned long)sdata);
 		}
 
+		if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+			ieee80211_sta_timer((unsigned long)sdata);
+
 		netif_wake_queue(sdata->dev);
 	}
 	rcu_read_unlock();
@@ -3639,15 +3809,27 @@ ieee80211_sta_scan_result(struct net_dev
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWESSID;
-	iwe.u.data.length = bss->ssid_len;
-	iwe.u.data.flags = 1;
-	current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
-					  bss->ssid);
+	if (bss->mesh_cfg) {
+#ifdef CONFIG_MAC80211_MESH
+		iwe.u.data.length = bss->mesh_id_len;
+		iwe.u.data.flags = 1;
+		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
+						  bss->mesh_id);
+#endif
+	} else {
+		iwe.u.data.length = bss->ssid_len;
+		iwe.u.data.flags = 1;
+		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
+						  bss->ssid);
+	}
 
-	if (bss->capability & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)) {
+	if (bss->capability & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS
+	    || bss->mesh_cfg)) {
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = SIOCGIWMODE;
-		if (bss->capability & WLAN_CAPABILITY_ESS)
+		if (bss->mesh_cfg)
+			iwe.u.mode = IW_MODE_MESH;
+		else if (bss->capability & WLAN_CAPABILITY_ESS)
 			iwe.u.mode = IW_MODE_MASTER;
 		else
 			iwe.u.mode = IW_MODE_ADHOC;
@@ -3736,6 +3918,28 @@ ieee80211_sta_scan_result(struct net_dev
 		}
 	}
 
+	if (bss->mesh_cfg) {
+		char *buf;
+		u8 *cfg = bss->mesh_cfg;
+		buf = kmalloc(200, GFP_ATOMIC);
+		if (buf) {
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = IWEVCUSTOM;
+			sprintf(buf, "Mesh network (version %d)\n"
+			"\t\t\tPath Selection Protocol ID: 0x%02X%02X%02X%02X\n"
+			"\t\t\tPath Selection Metric ID: 0x%02X%02X%02X%02X\n"
+			"\t\t\tCongestion Control Mode ID: 0x%02X%02X%02X%02X\n"
+			"\t\t\tChannel Precedence: 0x%02X%02X%02X%02X",
+			cfg[0], cfg[1], cfg[2], cfg[3], cfg[4], cfg[5], cfg[6],
+			cfg[7], cfg[8], cfg[9], cfg[10], cfg[11], cfg[12],
+			cfg[13], cfg[14], cfg[15], cfg[16]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(current_ev, end_buf,
+							  &iwe, buf);
+			kfree(buf);
+		}
+	}
+
 	return current_ev;
 }
 

-- 

