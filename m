Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYIFXE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 19:04:28 -0400
Subject: [PATCH] mac80211: refactor and move scan RX code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Vladimir Koutny <vlado@ksp.sk>, bruno randolf <br1@einfach.org>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 01:04:23 +0200
Message-Id: <1220742263.21016.21.camel@johannes.berg> (sfid-20080907_010433_431596_FB82188E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch refactors some code and moves the scan RX function
to scan.c. More importantly, however, it changes it so that the
MLME's beacon/probe_resp functions aren't invoked when scanning
so that we can remove a "if (scanning)" conditions from two
places.

There's a very slight behavioural change in this patch: now,
when scanning, IBSS and mesh aren't updated even on the same
channel.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    9 +
 net/mac80211/mlme.c        |  253 ++++++++++++++++++++-------------------------
 net/mac80211/scan.c        |   68 ++++++++++++
 3 files changed, 194 insertions(+), 136 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-07 01:01:20.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-07 01:01:43.000000000 +0200
@@ -128,10 +128,9 @@ static void __ieee80211_rx_bss_hash_del(
 }
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_add(struct ieee80211_sub_if_data *sdata, u8 *bssid, int freq,
+ieee80211_rx_bss_add(struct ieee80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sta_bss *bss;
 
 	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
@@ -230,8 +229,8 @@ static void ieee80211_rx_bss_free(struct
 	kfree(bss);
 }
 
-static void ieee80211_rx_bss_put(struct ieee80211_local *local,
-				 struct ieee80211_sta_bss *bss)
+void ieee80211_rx_bss_put(struct ieee80211_local *local,
+			  struct ieee80211_sta_bss *bss)
 {
 	local_bh_disable();
 	if (!atomic_dec_and_lock(&bss->users, &local->sta_bss_lock)) {
@@ -2408,74 +2407,16 @@ static u64 ieee80211_sta_get_mandatory_r
 	return mandatory_rates;
 }
 
-static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
-				  struct ieee80211_mgmt *mgmt,
-				  size_t len,
-				  struct ieee80211_rx_status *rx_status,
-				  struct ieee802_11_elems *elems)
+struct ieee80211_sta_bss *
+ieee80211_bss_info_update(struct ieee80211_local *local,
+			  struct ieee80211_rx_status *rx_status,
+			  struct ieee80211_mgmt *mgmt,
+			  size_t len,
+			  struct ieee802_11_elems *elems,
+			  int freq, bool beacon)
 {
-	struct ieee80211_local *local = sdata->local;
-	int freq, clen;
 	struct ieee80211_sta_bss *bss;
-	struct sta_info *sta;
-	struct ieee80211_channel *channel;
-	u64 beacon_timestamp, rx_timestamp;
-	u64 supp_rates = 0;
-	bool beacon = ieee80211_is_beacon(mgmt->frame_control);
-	enum ieee80211_band band = rx_status->band;
-	DECLARE_MAC_BUF(mac);
-	DECLARE_MAC_BUF(mac2);
-
-	if (elems->ds_params && elems->ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
-	else
-		freq = rx_status->freq;
-
-	channel = ieee80211_get_channel(local->hw.wiphy, freq);
-
-	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
-		return;
-
-	if (ieee80211_vif_is_mesh(&sdata->vif) && elems->mesh_id &&
-	    elems->mesh_config && mesh_matches_local(elems, sdata)) {
-		supp_rates = ieee80211_sta_get_rates(local, elems, band);
-
-		mesh_neighbour_update(mgmt->sa, supp_rates, sdata,
-				      mesh_peer_accepts_plinks(elems));
-	}
-
-	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems->supp_rates &&
-	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0) {
-		supp_rates = ieee80211_sta_get_rates(local, elems, band);
-
-		rcu_read_lock();
-
-		sta = sta_info_get(local, mgmt->sa);
-		if (sta) {
-			u64 prev_rates;
-
-			prev_rates = sta->supp_rates[band];
-			/* make sure mandatory rates are always added */
-			sta->supp_rates[band] = supp_rates |
-				ieee80211_sta_get_mandatory_rates(local, band);
-
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-			if (sta->supp_rates[band] != prev_rates)
-				printk(KERN_DEBUG "%s: updated supp_rates set "
-				    "for %s based on beacon info (0x%llx | "
-				    "0x%llx -> 0x%llx)\n",
-				    sdata->dev->name, print_mac(mac, sta->addr),
-				    (unsigned long long) prev_rates,
-				    (unsigned long long) supp_rates,
-				    (unsigned long long) sta->supp_rates[band]);
-#endif
-		} else {
-			ieee80211_ibss_add_sta(sdata, NULL, mgmt->bssid,
-					       mgmt->sa, supp_rates);
-		}
-
-		rcu_read_unlock();
-	}
+	int clen;
 
 #ifdef CONFIG_MAC80211_MESH
 	if (elems->mesh_config)
@@ -2493,10 +2434,10 @@ static void ieee80211_rx_bss_info(struct
 				elems->mesh_config_len, freq);
 		else
 #endif
-			bss = ieee80211_rx_bss_add(sdata, mgmt->bssid, freq,
+			bss = ieee80211_rx_bss_add(local, mgmt->bssid, freq,
 						  elems->ssid, elems->ssid_len);
 		if (!bss)
-			return;
+			return NULL;
 	} else {
 #if 0
 		/* TODO: order by RSSI? */
@@ -2543,17 +2484,114 @@ static void ieee80211_rx_bss_info(struct
 		bss->supp_rates_len += clen;
 	}
 
-	bss->band = band;
+	bss->band = rx_status->band;
 
-	beacon_timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
-
-	bss->timestamp = beacon_timestamp;
+	bss->timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
 	bss->last_update = jiffies;
 	bss->signal = rx_status->signal;
 	bss->noise = rx_status->noise;
 	bss->qual = rx_status->qual;
+	bss->wmm_used = elems->wmm_param || elems->wmm_info;
+
 	if (!beacon)
 		bss->last_probe_resp = jiffies;
+
+	/*
+	 * For probe responses, or if we don't have any information yet,
+	 * use the IEs from the beacon.
+	 */
+	if (!bss->ies || !beacon) {
+		if (bss->ies == NULL || bss->ies_len < elems->total_len) {
+			kfree(bss->ies);
+			bss->ies = kmalloc(elems->total_len, GFP_ATOMIC);
+		}
+		if (bss->ies) {
+			memcpy(bss->ies, elems->ie_start, elems->total_len);
+			bss->ies_len = elems->total_len;
+		} else
+			bss->ies_len = 0;
+	}
+
+	return bss;
+}
+
+static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_mgmt *mgmt,
+				  size_t len,
+				  struct ieee80211_rx_status *rx_status,
+				  struct ieee802_11_elems *elems,
+				  bool beacon)
+{
+	struct ieee80211_local *local = sdata->local;
+	int freq;
+	struct ieee80211_sta_bss *bss;
+	struct sta_info *sta;
+	struct ieee80211_channel *channel;
+	u64 beacon_timestamp, rx_timestamp;
+	u64 supp_rates = 0;
+	enum ieee80211_band band = rx_status->band;
+	DECLARE_MAC_BUF(mac);
+	DECLARE_MAC_BUF(mac2);
+
+	if (elems->ds_params && elems->ds_params_len == 1)
+		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
+	else
+		freq = rx_status->freq;
+
+	channel = ieee80211_get_channel(local->hw.wiphy, freq);
+
+	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
+		return;
+
+	if (ieee80211_vif_is_mesh(&sdata->vif) && elems->mesh_id &&
+	    elems->mesh_config && mesh_matches_local(elems, sdata)) {
+		supp_rates = ieee80211_sta_get_rates(local, elems, band);
+
+		mesh_neighbour_update(mgmt->sa, supp_rates, sdata,
+				      mesh_peer_accepts_plinks(elems));
+	}
+
+	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems->supp_rates &&
+	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0) {
+		supp_rates = ieee80211_sta_get_rates(local, elems, band);
+
+		rcu_read_lock();
+
+		sta = sta_info_get(local, mgmt->sa);
+		if (sta) {
+			u64 prev_rates;
+
+			prev_rates = sta->supp_rates[band];
+			/* make sure mandatory rates are always added */
+			sta->supp_rates[band] = supp_rates |
+				ieee80211_sta_get_mandatory_rates(local, band);
+
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+			if (sta->supp_rates[band] != prev_rates)
+				printk(KERN_DEBUG "%s: updated supp_rates set "
+				    "for %s based on beacon info (0x%llx | "
+				    "0x%llx -> 0x%llx)\n",
+				    sdata->dev->name, print_mac(mac, sta->addr),
+				    (unsigned long long) prev_rates,
+				    (unsigned long long) supp_rates,
+				    (unsigned long long) sta->supp_rates[band]);
+#endif
+		} else {
+			ieee80211_ibss_add_sta(sdata, NULL, mgmt->bssid,
+					       mgmt->sa, supp_rates);
+		}
+
+		rcu_read_unlock();
+	}
+
+	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
+					freq, beacon);
+	if (!bss)
+		return;
+
+	/* was just updated in ieee80211_bss_info_update */
+	beacon_timestamp = bss->timestamp;
+
 	/*
 	 * In STA mode, the remaining parameters should not be overridden
 	 * by beacons because they're not necessarily accurate there.
@@ -2564,21 +2602,8 @@ static void ieee80211_rx_bss_info(struct
 		return;
 	}
 
-	if (bss->ies == NULL || bss->ies_len < elems->total_len) {
-		kfree(bss->ies);
-		bss->ies = kmalloc(elems->total_len, GFP_ATOMIC);
-	}
-	if (bss->ies) {
-		memcpy(bss->ies, elems->ie_start, elems->total_len);
-		bss->ies_len = elems->total_len;
-	} else
-		bss->ies_len = 0;
-
-	bss->wmm_used = elems->wmm_param || elems->wmm_info;
-
 	/* check if we need to merge IBSS */
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
-	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
 	    bss->capability & WLAN_CAPABILITY_IBSS &&
 	    bss->freq == local->oper_channel->center_freq &&
 	    elems->ssid_len == sdata->u.sta.ssid_len &&
@@ -2655,7 +2680,7 @@ static void ieee80211_rx_mgmt_probe_resp
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
 				&elems);
 
-	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, false);
 
 	/* direct probe may be part of the association flow */
 	if (test_and_clear_bit(IEEE80211_STA_REQ_DIRECT_PROBE,
@@ -2686,7 +2711,7 @@ static void ieee80211_rx_mgmt_beacon(str
 
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
-	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, true);
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 		return;
@@ -2696,15 +2721,6 @@ static void ieee80211_rx_mgmt_beacon(str
 	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
-	/* Do not send changes to driver if we are scanning. This removes
-	 * requirement that a driver's bss_info_changed/conf_tx functions
-	 * need to be atomic.
-	 * This is really ugly code, we should rewrite scanning and make
-	 * all this more understandable for humans.
-	 */
-	if (local->sta_sw_scanning || local->sta_hw_scanning)
-		return;
-
 	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
 				 elems.wmm_param_len);
 
@@ -2946,41 +2962,6 @@ static void ieee80211_sta_rx_queued_mgmt
 }
 
 
-ieee80211_rx_result
-ieee80211_sta_rx_scan(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		      struct ieee80211_rx_status *rx_status)
-{
-	struct ieee80211_mgmt *mgmt;
-	__le16 fc;
-
-	if (skb->len < 2)
-		return RX_DROP_UNUSABLE;
-
-	mgmt = (struct ieee80211_mgmt *) skb->data;
-	fc = mgmt->frame_control;
-
-	if (ieee80211_is_ctl(fc))
-		return RX_CONTINUE;
-
-	if (skb->len < 24)
-		return RX_DROP_MONITOR;
-
-	if (ieee80211_is_probe_resp(fc)) {
-		ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len, rx_status);
-		dev_kfree_skb(skb);
-		return RX_QUEUED;
-	}
-
-	if (ieee80211_is_beacon(fc)) {
-		ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len, rx_status);
-		dev_kfree_skb(skb);
-		return RX_QUEUED;
-	}
-
-	return RX_CONTINUE;
-}
-
-
 static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -3191,7 +3172,7 @@ static int ieee80211_sta_create_ibss(str
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %s\n",
 	       sdata->dev->name, print_mac(mac, bssid));
 
-	bss = ieee80211_rx_bss_add(sdata, bssid,
+	bss = ieee80211_rx_bss_add(local, bssid,
 				   local->hw.conf.channel->center_freq,
 				   sdata->u.sta.ssid, sdata->u.sta.ssid_len);
 	if (!bss)
--- everything.orig/net/mac80211/scan.c	2008-09-07 01:01:20.000000000 +0200
+++ everything/net/mac80211/scan.c	2008-09-07 01:01:43.000000000 +0200
@@ -23,6 +23,74 @@
 #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 5)
 
 
+ieee80211_rx_result
+ieee80211_sta_rx_scan(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		      struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_sta_bss *bss;
+	u8 *elements;
+	struct ieee80211_channel *channel;
+	size_t baselen;
+	int freq;
+	__le16 fc;
+	bool presp, beacon = false;
+	struct ieee802_11_elems elems;
+
+	if (skb->len < 2)
+		return RX_DROP_UNUSABLE;
+
+	mgmt = (struct ieee80211_mgmt *) skb->data;
+	fc = mgmt->frame_control;
+
+	if (ieee80211_is_ctl(fc))
+		return RX_CONTINUE;
+
+	if (skb->len < 24)
+		return RX_DROP_MONITOR;
+
+	presp = ieee80211_is_probe_resp(fc);
+	if (presp) {
+		/* ignore ProbeResp to foreign address */
+		if (memcmp(mgmt->da, sdata->dev->dev_addr, ETH_ALEN))
+			return RX_DROP_MONITOR;
+
+		presp = true;
+		elements = mgmt->u.probe_resp.variable;
+		baselen = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+	} else {
+		beacon = ieee80211_is_beacon(fc);
+		baselen = offsetof(struct ieee80211_mgmt, u.beacon.variable);
+		elements = mgmt->u.beacon.variable;
+	}
+
+	if (!presp && !beacon)
+		return RX_CONTINUE;
+
+	if (baselen > skb->len)
+		return RX_DROP_MONITOR;
+
+	ieee802_11_parse_elems(elements, skb->len - baselen, &elems);
+
+	if (elems.ds_params && elems.ds_params_len == 1)
+		freq = ieee80211_channel_to_frequency(elems.ds_params[0]);
+	else
+		freq = rx_status->freq;
+
+	channel = ieee80211_get_channel(sdata->local->hw.wiphy, freq);
+
+	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
+		return RX_DROP_MONITOR;
+
+	bss = ieee80211_bss_info_update(sdata->local, rx_status,
+					mgmt, skb->len, &elems,
+					freq, beacon);
+	ieee80211_rx_bss_put(sdata->local, bss);
+
+	dev_kfree_skb(skb);
+	return RX_QUEUED;
+}
+
 static void ieee80211_send_nullfunc(struct ieee80211_local *local,
 				    struct ieee80211_sub_if_data *sdata,
 				    int powersave)
--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-07 01:01:20.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-07 01:01:43.000000000 +0200
@@ -937,6 +937,15 @@ void ieee802_11_parse_elems(u8 *start, s
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local);
 int ieee80211_sta_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 			     u8 *ssid, size_t ssid_len);
+struct ieee80211_sta_bss *
+ieee80211_bss_info_update(struct ieee80211_local *local,
+			  struct ieee80211_rx_status *rx_status,
+			  struct ieee80211_mgmt *mgmt,
+			  size_t len,
+			  struct ieee802_11_elems *elems,
+			  int freq, bool beacon);
+void ieee80211_rx_bss_put(struct ieee80211_local *local,
+			  struct ieee80211_sta_bss *bss);
 
 #ifdef CONFIG_MAC80211_MESH
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);


