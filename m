Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZBGPKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 10:10:18 -0500
Message-Id: <20090207150935.414951410@sipsolutions.net> (sfid-20090207_161025_288455_1758B5B1)
References: <20090207150846.951229208@sipsolutions.net>
Date: Sat, 07 Feb 2009 16:08:50 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mac80211: use cfg80211s BSS infrastructure
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove all the code from mac80211 to keep track of BSSes
and use the cfg80211-provided code completely.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |   42 ++-----
 net/mac80211/main.c        |    6 -
 net/mac80211/mesh.c        |   10 -
 net/mac80211/mesh.h        |    1 
 net/mac80211/mlme.c        |  211 ++++++++++++-------------------------
 net/mac80211/scan.c        |  255 +++------------------------------------------
 net/mac80211/spectmgmt.c   |    7 -
 7 files changed, 114 insertions(+), 418 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-02-06 10:34:00.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-02-06 14:24:58.000000000 +0100
@@ -72,43 +72,36 @@ struct ieee80211_fragment_entry {
 
 
 struct ieee80211_bss {
-	struct list_head list;
-	struct ieee80211_bss *hnext;
-	size_t ssid_len;
+	/* Yes, this is a hack */
+	struct cfg80211_bss cbss;
 
-	atomic_t users;
-
-	u8 bssid[ETH_ALEN];
+	/* don't want to look up all the time */
+	size_t ssid_len;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
+
 	u8 dtim_period;
-	u16 capability; /* host byte order */
-	enum ieee80211_band band;
-	int freq;
-	int signal, noise, qual;
-	u8 *ies; /* all information elements from the last Beacon or Probe
-		  * Response frames; note Beacon frame is not allowed to
-		  * override values from Probe Response */
-	size_t ies_len;
+
 	bool wmm_used;
+
+	unsigned long last_probe_resp;
+
 #ifdef CONFIG_MAC80211_MESH
 	u8 *mesh_id;
 	size_t mesh_id_len;
 	u8 *mesh_cfg;
 #endif
+
 #define IEEE80211_MAX_SUPP_RATES 32
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	size_t supp_rates_len;
-	u64 timestamp;
-	int beacon_int;
 
-	unsigned long last_probe_resp;
-	unsigned long last_update;
-
-	/* during assocation, we save an ERP value from a probe response so
+	/*
+	 * During assocation, we save an ERP value from a probe response so
 	 * that we can feed ERP info to the driver when handling the
 	 * association completes. these fields probably won't be up-to-date
-	 * otherwise, you probably don't want to use them. */
-	int has_erp_value;
+	 * otherwise, you probably don't want to use them.
+	 */
+	bool has_erp_value;
 	u8 erp_value;
 };
 
@@ -672,9 +665,6 @@ struct ieee80211_local {
 	struct ieee80211_sub_if_data *scan_sdata;
 	enum nl80211_channel_type oper_channel_type;
 	struct ieee80211_channel *oper_channel, *csa_channel;
-	struct list_head bss_list;
-	struct ieee80211_bss *bss_hash[STA_HASH_SIZE];
-	spinlock_t bss_lock;
 
 	/* SNMP counters */
 	/* dot11CountersTable */
@@ -937,8 +927,6 @@ ieee80211_rx_result
 ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata,
 		  struct sk_buff *skb,
 		  struct ieee80211_rx_status *rx_status);
-void ieee80211_rx_bss_list_init(struct ieee80211_local *local);
-void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local);
 int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata,
 			       char *ie, size_t len);
 
--- wireless-testing.orig/net/mac80211/main.c	2009-02-06 10:35:14.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-02-06 23:35:16.000000000 +0100
@@ -732,6 +732,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	wiphy->privid = mac80211_wiphy_privid;
 	wiphy->max_scan_ssids = 4;
+	/* Yes, putting cfg80211_bss into ieee80211_bss is a hack */
+	wiphy->bss_priv_size = sizeof(struct ieee80211_bss) -
+			       sizeof(struct cfg80211_bss);
 
 	local = wiphy_priv(wiphy);
 	local->hw.wiphy = wiphy;
@@ -880,8 +883,6 @@ int ieee80211_register_hw(struct ieee802
 	mpriv->local = local;
 	local->mdev = mdev;
 
-	ieee80211_rx_bss_list_init(local);
-
 	local->hw.workqueue =
 		create_singlethread_workqueue(wiphy_name(local->hw.wiphy));
 	if (!local->hw.workqueue) {
@@ -1021,7 +1022,6 @@ void ieee80211_unregister_hw(struct ieee
 
 	rtnl_unlock();
 
-	ieee80211_rx_bss_list_deinit(local);
 	ieee80211_clear_tx_pending(local);
 	sta_info_stop(local);
 	rate_control_deinitialize(local);
--- wireless-testing.orig/net/mac80211/scan.c	2009-02-06 10:35:27.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-02-06 13:14:51.000000000 +0100
@@ -12,10 +12,7 @@
  * published by the Free Software Foundation.
  */
 
-/* TODO:
- * figure out how to avoid that the "current BSS" expires
- * use cfg80211's BSS handling
- */
+/* TODO: figure out how to avoid that the "current BSS" expires */
 
 #include <linux/wireless.h>
 #include <linux/if_arp.h>
@@ -30,192 +27,29 @@
 #define IEEE80211_CHANNEL_TIME (HZ / 33)
 #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 5)
 
-void ieee80211_rx_bss_list_init(struct ieee80211_local *local)
-{
-	spin_lock_init(&local->bss_lock);
-	INIT_LIST_HEAD(&local->bss_list);
-}
-
-void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local)
-{
-	struct ieee80211_bss *bss, *tmp;
-
-	list_for_each_entry_safe(bss, tmp, &local->bss_list, list)
-		ieee80211_rx_bss_put(local, bss);
-}
-
 struct ieee80211_bss *
 ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
-	struct ieee80211_bss *bss;
-
-	spin_lock_bh(&local->bss_lock);
-	bss = local->bss_hash[STA_HASH(bssid)];
-	while (bss) {
-		if (!bss_mesh_cfg(bss) &&
-		    !memcmp(bss->bssid, bssid, ETH_ALEN) &&
-		    bss->freq == freq &&
-		    bss->ssid_len == ssid_len &&
-		    (ssid_len == 0 || !memcmp(bss->ssid, ssid, ssid_len))) {
-			atomic_inc(&bss->users);
-			break;
-		}
-		bss = bss->hnext;
-	}
-	spin_unlock_bh(&local->bss_lock);
-	return bss;
-}
-
-/* Caller must hold local->bss_lock */
-static void __ieee80211_rx_bss_hash_add(struct ieee80211_local *local,
-					struct ieee80211_bss *bss)
-{
-	u8 hash_idx;
-
-	if (bss_mesh_cfg(bss))
-		hash_idx = mesh_id_hash(bss_mesh_id(bss),
-					bss_mesh_id_len(bss));
-	else
-		hash_idx = STA_HASH(bss->bssid);
-
-	bss->hnext = local->bss_hash[hash_idx];
-	local->bss_hash[hash_idx] = bss;
-}
-
-/* Caller must hold local->bss_lock */
-static void __ieee80211_rx_bss_hash_del(struct ieee80211_local *local,
-					struct ieee80211_bss *bss)
-{
-	struct ieee80211_bss *b, *prev = NULL;
-	b = local->bss_hash[STA_HASH(bss->bssid)];
-	while (b) {
-		if (b == bss) {
-			if (!prev)
-				local->bss_hash[STA_HASH(bss->bssid)] =
-					bss->hnext;
-			else
-				prev->hnext = bss->hnext;
-			break;
-		}
-		prev = b;
-		b = b->hnext;
-	}
-}
-
-static struct ieee80211_bss *
-ieee80211_rx_bss_add(struct ieee80211_local *local, u8 *bssid, int freq,
-		     u8 *ssid, u8 ssid_len)
-{
-	struct ieee80211_bss *bss;
-
-	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
-	if (!bss)
-		return NULL;
-	atomic_set(&bss->users, 2);
-	memcpy(bss->bssid, bssid, ETH_ALEN);
-	bss->freq = freq;
-	if (ssid && ssid_len <= IEEE80211_MAX_SSID_LEN) {
-		memcpy(bss->ssid, ssid, ssid_len);
-		bss->ssid_len = ssid_len;
-	}
-
-	spin_lock_bh(&local->bss_lock);
-	/* TODO: order by RSSI? */
-	list_add_tail(&bss->list, &local->bss_list);
-	__ieee80211_rx_bss_hash_add(local, bss);
-	spin_unlock_bh(&local->bss_lock);
-	return bss;
+	return (void *)cfg80211_get_bss(local->hw.wiphy,
+					ieee80211_get_channel(local->hw.wiphy,
+							      freq),
+					bssid, ssid, ssid_len,
+					0, 0);
 }
 
-#ifdef CONFIG_MAC80211_MESH
-static struct ieee80211_bss *
-ieee80211_rx_mesh_bss_get(struct ieee80211_local *local, u8 *mesh_id, int mesh_id_len,
-			  u8 *mesh_cfg, int freq)
+static void ieee80211_rx_bss_free(struct cfg80211_bss *cbss)
 {
-	struct ieee80211_bss *bss;
+	struct ieee80211_bss *bss = (void *)cbss;
 
-	spin_lock_bh(&local->bss_lock);
-	bss = local->bss_hash[mesh_id_hash(mesh_id, mesh_id_len)];
-	while (bss) {
-		if (bss_mesh_cfg(bss) &&
-		    !memcmp(bss_mesh_cfg(bss), mesh_cfg, MESH_CFG_CMP_LEN) &&
-		    bss->freq == freq &&
-		    mesh_id_len == bss->mesh_id_len &&
-		    (mesh_id_len == 0 || !memcmp(bss->mesh_id, mesh_id,
-						 mesh_id_len))) {
-			atomic_inc(&bss->users);
-			break;
-		}
-		bss = bss->hnext;
-	}
-	spin_unlock_bh(&local->bss_lock);
-	return bss;
-}
-
-static struct ieee80211_bss *
-ieee80211_rx_mesh_bss_add(struct ieee80211_local *local, u8 *mesh_id, int mesh_id_len,
-			  u8 *mesh_cfg, int mesh_config_len, int freq)
-{
-	struct ieee80211_bss *bss;
-
-	if (mesh_config_len != IEEE80211_MESH_CONFIG_LEN)
-		return NULL;
-
-	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
-	if (!bss)
-		return NULL;
-
-	bss->mesh_cfg = kmalloc(MESH_CFG_CMP_LEN, GFP_ATOMIC);
-	if (!bss->mesh_cfg) {
-		kfree(bss);
-		return NULL;
-	}
-
-	if (mesh_id_len && mesh_id_len <= IEEE80211_MAX_MESH_ID_LEN) {
-		bss->mesh_id = kmalloc(mesh_id_len, GFP_ATOMIC);
-		if (!bss->mesh_id) {
-			kfree(bss->mesh_cfg);
-			kfree(bss);
-			return NULL;
-		}
-		memcpy(bss->mesh_id, mesh_id, mesh_id_len);
-	}
-
-	atomic_set(&bss->users, 2);
-	memcpy(bss->mesh_cfg, mesh_cfg, MESH_CFG_CMP_LEN);
-	bss->mesh_id_len = mesh_id_len;
-	bss->freq = freq;
-	spin_lock_bh(&local->bss_lock);
-	/* TODO: order by RSSI? */
-	list_add_tail(&bss->list, &local->bss_list);
-	__ieee80211_rx_bss_hash_add(local, bss);
-	spin_unlock_bh(&local->bss_lock);
-	return bss;
-}
-#endif
-
-static void ieee80211_rx_bss_free(struct ieee80211_bss *bss)
-{
-	kfree(bss->ies);
 	kfree(bss_mesh_id(bss));
 	kfree(bss_mesh_cfg(bss));
-	kfree(bss);
 }
 
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss)
 {
-	local_bh_disable();
-	if (!atomic_dec_and_lock(&bss->users, &local->bss_lock)) {
-		local_bh_enable();
-		return;
-	}
-
-	__ieee80211_rx_bss_hash_del(local, bss);
-	list_del(&bss->list);
-	spin_unlock_bh(&local->bss_lock);
-	ieee80211_rx_bss_free(bss);
+	cfg80211_put_bss((struct cfg80211_bss *)bss);
 }
 
 struct ieee80211_bss *
@@ -228,7 +62,7 @@ ieee80211_bss_info_update(struct ieee802
 			  bool beacon)
 {
 	struct ieee80211_bss *bss;
-	int clen, freq = channel->center_freq;
+	int clen;
 	enum cfg80211_signal_type sigtype = CFG80211_SIGNAL_TYPE_NONE;
 	s32 signal = 0;
 
@@ -240,39 +74,14 @@ ieee80211_bss_info_update(struct ieee802
 		signal = (rx_status->signal * 100) / local->hw.max_signal;
 	}
 
-	cfg80211_put_bss(
-		cfg80211_inform_bss_frame(local->hw.wiphy, channel,
-					  mgmt, len, signal, sigtype,
-					  GFP_ATOMIC));
-
-#ifdef CONFIG_MAC80211_MESH
-	if (elems->mesh_config)
-		bss = ieee80211_rx_mesh_bss_get(local, elems->mesh_id,
-				elems->mesh_id_len, elems->mesh_config, freq);
-	else
-#endif
-		bss = ieee80211_rx_bss_get(local, mgmt->bssid, freq,
-					   elems->ssid, elems->ssid_len);
-	if (!bss) {
-#ifdef CONFIG_MAC80211_MESH
-		if (elems->mesh_config)
-			bss = ieee80211_rx_mesh_bss_add(local, elems->mesh_id,
-				elems->mesh_id_len, elems->mesh_config,
-				elems->mesh_config_len, freq);
-		else
-#endif
-			bss = ieee80211_rx_bss_add(local, mgmt->bssid, freq,
-						  elems->ssid, elems->ssid_len);
-		if (!bss)
-			return NULL;
-	} else {
-#if 0
-		/* TODO: order by RSSI? */
-		spin_lock_bh(&local->bss_lock);
-		list_move_tail(&bss->list, &local->bss_list);
-		spin_unlock_bh(&local->bss_lock);
-#endif
-	}
+	bss = (void *)cfg80211_inform_bss_frame(local->hw.wiphy, channel,
+						mgmt, len, signal, sigtype,
+						GFP_ATOMIC);
+
+	if (!bss)
+		return NULL;
+
+	bss->cbss.free_priv = ieee80211_rx_bss_free;
 
 	/* save the ERP value so that it is available at association time */
 	if (elems->erp_info && elems->erp_info_len >= 1) {
@@ -280,9 +89,6 @@ ieee80211_bss_info_update(struct ieee802
 		bss->has_erp_value = 1;
 	}
 
-	bss->beacon_int = le16_to_cpu(mgmt->u.beacon.beacon_int);
-	bss->capability = le16_to_cpu(mgmt->u.beacon.capab_info);
-
 	if (elems->tim) {
 		struct ieee80211_tim_ie *tim_ie =
 			(struct ieee80211_tim_ie *)elems->tim;
@@ -311,34 +117,11 @@ ieee80211_bss_info_update(struct ieee802
 		bss->supp_rates_len += clen;
 	}
 
-	bss->band = rx_status->band;
-
-	bss->timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
-	bss->last_update = jiffies;
-	bss->signal = rx_status->signal;
-	bss->noise = rx_status->noise;
-	bss->qual = rx_status->qual;
 	bss->wmm_used = elems->wmm_param || elems->wmm_info;
 
 	if (!beacon)
 		bss->last_probe_resp = jiffies;
 
-	/*
-	 * For probe responses, or if we don't have any information yet,
-	 * use the IEs from the beacon.
-	 */
-	if (!bss->ies || !beacon) {
-		if (bss->ies == NULL || bss->ies_len < elems->total_len) {
-			kfree(bss->ies);
-			bss->ies = kmalloc(elems->total_len, GFP_ATOMIC);
-		}
-		if (bss->ies) {
-			memcpy(bss->ies, elems->ie_start, elems->total_len);
-			bss->ies_len = elems->total_len;
-		} else
-			bss->ies_len = 0;
-	}
-
 	return bss;
 }
 
@@ -350,7 +133,7 @@ void ieee80211_rx_bss_remove(struct ieee
 
 	bss = ieee80211_rx_bss_get(local, bssid, freq, ssid, ssid_len);
 	if (bss) {
-		atomic_dec(&bss->users);
+		ieee80211_rx_bss_put(local, bss);
 		ieee80211_rx_bss_put(local, bss);
 	}
 }
--- wireless-testing.orig/net/mac80211/mlme.c	2009-02-06 10:53:03.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-02-06 23:35:16.000000000 +0100
@@ -55,10 +55,10 @@ static u8 *ieee80211_bss_get_ie(struct i
 {
 	u8 *end, *pos;
 
-	pos = bss->ies;
+	pos = bss->cbss.information_elements;
 	if (pos == NULL)
 		return NULL;
-	end = pos + bss->ies_len;
+	end = pos + bss->cbss.len_information_elements;
 
 	while (pos + 1 < end) {
 		if (pos + 2 + pos[1] > end)
@@ -289,7 +289,7 @@ static void ieee80211_send_assoc(struct 
 				   local->hw.conf.channel->center_freq,
 				   ifsta->ssid, ifsta->ssid_len);
 	if (bss) {
-		if (bss->capability & WLAN_CAPABILITY_PRIVACY)
+		if (bss->cbss.capability & WLAN_CAPABILITY_PRIVACY)
 			capab |= WLAN_CAPABILITY_PRIVACY;
 		if (bss->wmm_used)
 			wmm = 1;
@@ -300,7 +300,7 @@ static void ieee80211_send_assoc(struct 
 		 * b-only mode) */
 		rates_len = ieee80211_compatible_rates(bss, sband, &rates);
 
-		if ((bss->capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
+		if ((bss->cbss.capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
 		    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
 			capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
 
@@ -786,12 +786,12 @@ static void ieee80211_set_associated(str
 				   ifsta->ssid, ifsta->ssid_len);
 	if (bss) {
 		/* set timing information */
-		sdata->vif.bss_conf.beacon_int = bss->beacon_int;
-		sdata->vif.bss_conf.timestamp = bss->timestamp;
+		sdata->vif.bss_conf.beacon_int = bss->cbss.beacon_interval;
+		sdata->vif.bss_conf.timestamp = bss->cbss.tsf;
 		sdata->vif.bss_conf.dtim_period = bss->dtim_period;
 
 		bss_info_changed |= ieee80211_handle_bss_capability(sdata,
-			bss->capability, bss->has_erp_value, bss->erp_value);
+			bss->cbss.capability, bss->has_erp_value, bss->erp_value);
 
 		ieee80211_rx_bss_put(local, bss);
 	}
@@ -1011,7 +1011,7 @@ static int ieee80211_privacy_mismatch(st
 	if (!bss)
 		return 0;
 
-	bss_privacy = !!(bss->capability & WLAN_CAPABILITY_PRIVACY);
+	bss_privacy = !!(bss->cbss.capability & WLAN_CAPABILITY_PRIVACY);
 	wep_privacy = !!ieee80211_sta_wep_configured(sdata);
 	privacy_invoked = !!(ifsta->flags & IEEE80211_STA_PRIVACY_INVOKED);
 
@@ -1386,8 +1386,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 	/* Add STA entry for the AP */
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
-		struct ieee80211_bss *bss;
-
 		newsta = true;
 
 		sta = sta_info_alloc(sdata, ifsta->bssid, GFP_ATOMIC);
@@ -1397,15 +1395,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 			rcu_read_unlock();
 			return;
 		}
-		bss = ieee80211_rx_bss_get(local, ifsta->bssid,
-					   local->hw.conf.channel->center_freq,
-					   ifsta->ssid, ifsta->ssid_len);
-		if (bss) {
-			sta->last_signal = bss->signal;
-			sta->last_qual = bss->qual;
-			sta->last_noise = bss->noise;
-			ieee80211_rx_bss_put(local, bss);
-		}
 
 		/* update new sta with its last rx activity */
 		sta->last_rx = jiffies;
@@ -1661,10 +1650,11 @@ static int ieee80211_sta_join_ibss(struc
 				   struct ieee80211_bss *bss)
 {
 	return __ieee80211_sta_join_ibss(sdata, ifsta,
-					 bss->bssid, bss->beacon_int,
-					 bss->freq,
+					 bss->cbss.bssid,
+					 bss->cbss.beacon_interval,
+					 bss->cbss.channel->center_freq,
 					 bss->supp_rates_len, bss->supp_rates,
-					 bss->capability);
+					 bss->cbss.capability);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
@@ -1739,7 +1729,7 @@ static void ieee80211_rx_bss_info(struct
 	}
 
 	/* was just updated in ieee80211_bss_info_update */
-	beacon_timestamp = bss->timestamp;
+	beacon_timestamp = bss->cbss.tsf;
 
 	/*
 	 * In STA mode, the remaining parameters should not be overridden
@@ -1754,8 +1744,8 @@ static void ieee80211_rx_bss_info(struct
 	/* check if we need to merge IBSS */
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && beacon &&
 	    (!(sdata->u.sta.flags & IEEE80211_STA_BSSID_SET)) &&
-	    bss->capability & WLAN_CAPABILITY_IBSS &&
-	    bss->freq == local->oper_channel->center_freq &&
+	    bss->cbss.capability & WLAN_CAPABILITY_IBSS &&
+	    bss->cbss.channel == local->oper_channel &&
 	    elems->ssid_len == sdata->u.sta.ssid_len &&
 	    memcmp(elems->ssid, sdata->u.sta.ssid,
 				sdata->u.sta.ssid_len) == 0) {
@@ -2185,37 +2175,6 @@ static void ieee80211_sta_reset_auth(str
 	netif_carrier_off(sdata->dev);
 }
 
-
-static int ieee80211_sta_match_ssid(struct ieee80211_if_sta *ifsta,
-				    const char *ssid, int ssid_len)
-{
-	int tmp, hidden_ssid;
-
-	if (ssid_len == ifsta->ssid_len &&
-	    !memcmp(ifsta->ssid, ssid, ssid_len))
-		return 1;
-
-	if (ifsta->flags & IEEE80211_STA_AUTO_BSSID_SEL)
-		return 0;
-
-	hidden_ssid = 1;
-	tmp = ssid_len;
-	while (tmp--) {
-		if (ssid[tmp] != '\0') {
-			hidden_ssid = 0;
-			break;
-		}
-	}
-
-	if (hidden_ssid && (ifsta->ssid_len == ssid_len || ssid_len == 0))
-		return 1;
-
-	if (ssid_len == 1 && ssid[0] == ' ')
-		return 1;
-
-	return 0;
-}
-
 static int ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_if_sta *ifsta)
 {
@@ -2274,8 +2233,6 @@ static int ieee80211_sta_find_ibss(struc
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_bss *bss;
-	int found = 0;
-	u8 bssid[ETH_ALEN];
 	int active_ibss;
 
 	if (ifsta->ssid_len == 0)
@@ -2286,56 +2243,39 @@ static int ieee80211_sta_find_ibss(struc
 	printk(KERN_DEBUG "%s: sta_find_ibss (active_ibss=%d)\n",
 	       sdata->dev->name, active_ibss);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
-	spin_lock_bh(&local->bss_lock);
-	list_for_each_entry(bss, &local->bss_list, list) {
-		if (ifsta->ssid_len != bss->ssid_len ||
-		    memcmp(ifsta->ssid, bss->ssid, bss->ssid_len) != 0
-		    || !(bss->capability & WLAN_CAPABILITY_IBSS))
-			continue;
-		if ((ifsta->flags & IEEE80211_STA_BSSID_SET) &&
-		    memcmp(ifsta->bssid, bss->bssid, ETH_ALEN) != 0)
-			continue;
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-		printk(KERN_DEBUG "   bssid=%pM found\n", bss->bssid);
-#endif /* CONFIG_MAC80211_IBSS_DEBUG */
-		memcpy(bssid, bss->bssid, ETH_ALEN);
-		found = 1;
-		if (active_ibss || memcmp(bssid, ifsta->bssid, ETH_ALEN) != 0)
-			break;
-	}
-	spin_unlock_bh(&local->bss_lock);
+
+	if (active_ibss)
+		return 0;
+
+	if (ifsta->flags & IEEE80211_STA_BSSID_SET)
+		bss = ieee80211_rx_bss_get(local, ifsta->bssid, 0,
+					   ifsta->ssid, ifsta->ssid_len);
+	else
+		bss = (void *)cfg80211_get_ibss(local->hw.wiphy,
+						NULL,
+						ifsta->ssid, ifsta->ssid_len);
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	if (found)
 		printk(KERN_DEBUG "   sta_find_ibss: selected %pM current "
-		       "%pM\n", bssid, ifsta->bssid);
+		       "%pM\n", bss->cbss.bssid, ifsta->bssid);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
-	if (found &&
-	    ((!(ifsta->flags & IEEE80211_STA_PREV_BSSID_SET)) ||
-	     memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0)) {
+	if (bss &&
+	    (!(ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) ||
+	     memcmp(ifsta->bssid, bss->cbss.bssid, ETH_ALEN))) {
 		int ret;
-		int search_freq;
-
-		if (ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL)
-			search_freq = bss->freq;
-		else
-			search_freq = local->hw.conf.channel->center_freq;
-
-		bss = ieee80211_rx_bss_get(local, bssid, search_freq,
-					   ifsta->ssid, ifsta->ssid_len);
-		if (!bss)
-			goto dont_join;
 
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %pM"
 		       " based on configured SSID\n",
-		       sdata->dev->name, bssid);
+		       sdata->dev->name, bss->cbss.bssid);
+
 		ret = ieee80211_sta_join_ibss(sdata, ifsta, bss);
 		ieee80211_rx_bss_put(local, bss);
 		return ret;
-	}
+	} else if (bss)
+		ieee80211_rx_bss_put(local, bss);
 
-dont_join:
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "   did not try to join ibss\n");
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
@@ -2391,51 +2331,44 @@ static int ieee80211_sta_config_auth(str
 				     struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_bss *bss, *selected = NULL;
-	int top_rssi = 0, freq;
+	struct ieee80211_bss *bss;
+	u8 *bssid = ifsta->bssid, *ssid = ifsta->ssid;
+	u8 ssid_len = ifsta->ssid_len;
+	u16 capa_mask = WLAN_CAPABILITY_ESS;
+	u16 capa_val = WLAN_CAPABILITY_ESS;
+	struct ieee80211_channel *chan = local->oper_channel;
+
+	if (ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
+			    IEEE80211_STA_AUTO_BSSID_SEL |
+			    IEEE80211_STA_AUTO_CHANNEL_SEL)) {
+		capa_mask |= WLAN_CAPABILITY_PRIVACY;
+		if (sdata->default_key)
+			capa_val |= WLAN_CAPABILITY_PRIVACY;
+	}
+
+	if (ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL)
+		chan = NULL;
 
-	spin_lock_bh(&local->bss_lock);
-	freq = local->oper_channel->center_freq;
-	list_for_each_entry(bss, &local->bss_list, list) {
-		if (!(bss->capability & WLAN_CAPABILITY_ESS))
-			continue;
-
-		if ((ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
-			IEEE80211_STA_AUTO_BSSID_SEL |
-			IEEE80211_STA_AUTO_CHANNEL_SEL)) &&
-		    (!!(bss->capability & WLAN_CAPABILITY_PRIVACY) ^
-		     !!sdata->default_key))
-			continue;
-
-		if (!(ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL) &&
-		    bss->freq != freq)
-			continue;
-
-		if (!(ifsta->flags & IEEE80211_STA_AUTO_BSSID_SEL) &&
-		    memcmp(bss->bssid, ifsta->bssid, ETH_ALEN))
-			continue;
-
-		if (!(ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL) &&
-		    !ieee80211_sta_match_ssid(ifsta, bss->ssid, bss->ssid_len))
-			continue;
-
-		if (!selected || top_rssi < bss->signal) {
-			selected = bss;
-			top_rssi = bss->signal;
-		}
-	}
-	if (selected)
-		atomic_inc(&selected->users);
-	spin_unlock_bh(&local->bss_lock);
+	if (ifsta->flags & IEEE80211_STA_AUTO_BSSID_SEL)
+		bssid = NULL;
 
-	if (selected) {
-		ieee80211_set_freq(sdata, selected->freq);
+	if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL) {
+		ssid = NULL;
+		ssid_len = 0;
+	}
+
+	bss = (void *)cfg80211_get_bss(local->hw.wiphy, chan,
+				       bssid, ssid, ssid_len,
+				       capa_mask, capa_val);
+
+	if (bss) {
+		ieee80211_set_freq(sdata, bss->cbss.channel->center_freq);
 		if (!(ifsta->flags & IEEE80211_STA_SSID_SET))
-			ieee80211_sta_set_ssid(sdata, selected->ssid,
-					       selected->ssid_len);
-		ieee80211_sta_set_bssid(sdata, selected->bssid);
-		ieee80211_sta_def_wmm_params(sdata, selected->supp_rates_len,
-						    selected->supp_rates);
+			ieee80211_sta_set_ssid(sdata, bss->ssid,
+					       bss->ssid_len);
+		ieee80211_sta_set_bssid(sdata, bss->cbss.bssid);
+		ieee80211_sta_def_wmm_params(sdata, bss->supp_rates_len,
+						    bss->supp_rates);
 		if (sdata->u.sta.mfp == IEEE80211_MFP_REQUIRED)
 			sdata->u.sta.flags |= IEEE80211_STA_MFP_ENABLED;
 		else
@@ -2444,14 +2377,14 @@ static int ieee80211_sta_config_auth(str
 		/* Send out direct probe if no probe resp was received or
 		 * the one we have is outdated
 		 */
-		if (!selected->last_probe_resp ||
-		    time_after(jiffies, selected->last_probe_resp
+		if (!bss->last_probe_resp ||
+		    time_after(jiffies, bss->last_probe_resp
 					+ IEEE80211_SCAN_RESULT_EXPIRE))
 			ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
 		else
 			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
 
-		ieee80211_rx_bss_put(local, selected);
+		ieee80211_rx_bss_put(local, bss);
 		ieee80211_sta_reset_auth(sdata, ifsta);
 		return 0;
 	} else {
--- wireless-testing.orig/net/mac80211/spectmgmt.c	2009-02-06 11:27:03.000000000 +0100
+++ wireless-testing/net/mac80211/spectmgmt.c	2009-02-06 23:36:09.000000000 +0100
@@ -102,8 +102,9 @@ void ieee80211_chswitch_work(struct work
 		goto exit;
 
 	sdata->local->oper_channel = sdata->local->csa_channel;
+	/* XXX: shouldn't really modify cfg80211-owned data! */
 	if (!ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL))
-		bss->freq = sdata->local->oper_channel->center_freq;
+		bss->cbss.channel = sdata->local->oper_channel;
 
 	ieee80211_rx_bss_put(sdata->local, bss);
 exit:
@@ -158,7 +159,9 @@ void ieee80211_process_chanswitch(struct
 						IEEE80211_QUEUE_STOP_REASON_CSA);
 		ifsta->flags |= IEEE80211_STA_CSA_RECEIVED;
 		mod_timer(&ifsta->chswitch_timer,
-			  jiffies + msecs_to_jiffies(sw_elem->count * bss->beacon_int));
+			  jiffies +
+			  msecs_to_jiffies(sw_elem->count *
+					   bss->cbss.beacon_interval));
 	}
 }
 
--- wireless-testing.orig/net/mac80211/mesh.c	2009-02-06 11:37:52.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.c	2009-02-06 11:38:03.000000000 +0100
@@ -275,16 +275,6 @@ u32 mesh_table_hash(u8 *addr, struct iee
 		& tbl->hash_mask;
 }
 
-u8 mesh_id_hash(u8 *mesh_id, int mesh_id_len)
-{
-	if (!mesh_id_len)
-		return 1;
-	else if (mesh_id_len == 1)
-		return (u8) mesh_id[0];
-	else
-		return (u8) (mesh_id[0] + 2 * mesh_id[1]);
-}
-
 struct mesh_table *mesh_table_alloc(int size_order)
 {
 	int i;
--- wireless-testing.orig/net/mac80211/mesh.h	2009-02-06 11:38:05.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.h	2009-02-06 11:38:10.000000000 +0100
@@ -196,7 +196,6 @@ struct mesh_rmc {
 
 /* Public interfaces */
 /* Various */
-u8 mesh_id_hash(u8 *mesh_id, int mesh_id_len);
 int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr);
 int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 		struct ieee80211_sub_if_data *sdata);

-- 

