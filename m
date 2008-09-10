Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYIJWO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:14:29 -0400
Message-Id: <20080910220419.567819000@sipsolutions.net> (sfid-20080911_001434_821935_4B3CDF05)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/18] mac80211: clean up scan namespace
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of the scan functions are called ieee80211_sta_scan_*
or similar, make clean it up so they are all just called
ieee80211_scan_*.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |   53 ++++++++-------
 net/mac80211/main.c        |    6 -
 net/mac80211/mesh.c        |    2 
 net/mac80211/mlme.c        |   51 +++++++--------
 net/mac80211/rx.c          |   10 +-
 net/mac80211/scan.c        |  153 ++++++++++++++++++++++-----------------------
 net/mac80211/tx.c          |    2 
 net/mac80211/util.c        |    2 
 net/mac80211/wext.c        |    6 -
 9 files changed, 145 insertions(+), 140 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-10 23:58:01.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-10 23:58:02.000000000 +0200
@@ -71,9 +71,9 @@ struct ieee80211_fragment_entry {
 };
 
 
-struct ieee80211_sta_bss {
+struct ieee80211_bss {
 	struct list_head list;
-	struct ieee80211_sta_bss *hnext;
+	struct ieee80211_bss *hnext;
 	size_t ssid_len;
 
 	atomic_t users;
@@ -112,7 +112,7 @@ struct ieee80211_sta_bss {
 	u8 erp_value;
 };
 
-static inline u8 *bss_mesh_cfg(struct ieee80211_sta_bss *bss)
+static inline u8 *bss_mesh_cfg(struct ieee80211_bss *bss)
 {
 #ifdef CONFIG_MAC80211_MESH
 	return bss->mesh_cfg;
@@ -120,7 +120,7 @@ static inline u8 *bss_mesh_cfg(struct ie
 	return NULL;
 }
 
-static inline u8 *bss_mesh_id(struct ieee80211_sta_bss *bss)
+static inline u8 *bss_mesh_id(struct ieee80211_bss *bss)
 {
 #ifdef CONFIG_MAC80211_MESH
 	return bss->mesh_id;
@@ -128,7 +128,7 @@ static inline u8 *bss_mesh_id(struct iee
 	return NULL;
 }
 
-static inline u8 bss_mesh_id_len(struct ieee80211_sta_bss *bss)
+static inline u8 bss_mesh_id_len(struct ieee80211_bss *bss)
 {
 #ifdef CONFIG_MAC80211_MESH
 	return bss->mesh_id_len;
@@ -658,8 +658,8 @@ struct ieee80211_local {
 	spinlock_t key_lock;
 
 
-	bool sta_sw_scanning;
-	bool sta_hw_scanning;
+	/* Scanning and BSS list */
+	bool sw_scanning, hw_scanning;
 	int scan_channel_idx;
 	enum ieee80211_band scan_band;
 
@@ -670,9 +670,9 @@ struct ieee80211_local {
 	struct ieee80211_channel *oper_channel, *scan_channel;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
-	struct list_head sta_bss_list;
-	struct ieee80211_sta_bss *sta_bss_hash[STA_HASH_SIZE];
-	spinlock_t sta_bss_lock;
+	struct list_head bss_list;
+	struct ieee80211_bss *bss_hash[STA_HASH_SIZE];
+	spinlock_t bss_lock;
 
 	/* SNMP counters */
 	/* dot11CountersTable */
@@ -905,7 +905,7 @@ extern const struct iw_handler_def ieee8
 
 /* STA/IBSS code */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
-void ieee80211_sta_scan_work(struct work_struct *work);
+void ieee80211_scan_work(struct work_struct *work);
 void ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status);
 int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len);
@@ -926,35 +926,38 @@ void ieee80211_send_probe_req(struct iee
 			      u8 *ssid, size_t ssid_len);
 
 /* scan/BSS handling */
-int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8 *ssid, size_t ssid_len);
-int ieee80211_sta_scan_results(struct ieee80211_local *local,
-			       struct iw_request_info *info,
-			       char *buf, size_t len);
-ieee80211_rx_result ieee80211_sta_rx_scan(
-	struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-	struct ieee80211_rx_status *rx_status);
+int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
+			   u8 *ssid, size_t ssid_len);
+int ieee80211_scan_results(struct ieee80211_local *local,
+			   struct iw_request_info *info,
+			   char *buf, size_t len);
+ieee80211_rx_result
+ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata,
+		  struct sk_buff *skb,
+		  struct ieee80211_rx_status *rx_status);
 void ieee80211_rx_bss_list_init(struct ieee80211_local *local);
 void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local);
-int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, char *ie, size_t len);
+int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata,
+			       char *ie, size_t len);
 
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local);
-int ieee80211_sta_start_scan(struct ieee80211_sub_if_data *scan_sdata,
-			     u8 *ssid, size_t ssid_len);
-struct ieee80211_sta_bss *
+int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
+			 u8 *ssid, size_t ssid_len);
+struct ieee80211_bss *
 ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
 			  struct ieee80211_mgmt *mgmt,
 			  size_t len,
 			  struct ieee802_11_elems *elems,
 			  int freq, bool beacon);
-struct ieee80211_sta_bss *
+struct ieee80211_bss *
 ieee80211_rx_bss_add(struct ieee80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len);
-struct ieee80211_sta_bss *
+struct ieee80211_bss *
 ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len);
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
-			  struct ieee80211_sta_bss *bss);
+			  struct ieee80211_bss *bss);
 
 /* interface handling */
 void ieee80211_if_setup(struct net_device *dev);
--- everything.orig/net/mac80211/main.c	2008-09-10 23:58:01.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-10 23:58:02.000000000 +0200
@@ -598,7 +598,7 @@ static int ieee80211_stop(struct net_dev
 			 * the scan_sdata is NULL already don't send out a
 			 * scan event to userspace -- the scan is incomplete.
 			 */
-			if (local->sta_sw_scanning)
+			if (local->sw_scanning)
 				ieee80211_scan_completed(&local->hw);
 		}
 
@@ -732,7 +732,7 @@ int ieee80211_hw_config(struct ieee80211
 	struct ieee80211_channel *chan;
 	int ret = 0;
 
-	if (local->sta_sw_scanning)
+	if (local->sw_scanning)
 		chan = local->scan_channel;
 	else
 		chan = local->oper_channel;
@@ -1290,7 +1290,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	spin_lock_init(&local->key_lock);
 
-	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
+	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 
 	sta_info_init(local);
 
--- everything.orig/net/mac80211/mesh.c	2008-09-10 23:57:57.000000000 +0200
+++ everything/net/mac80211/mesh.c	2008-09-10 23:58:02.000000000 +0200
@@ -566,7 +566,7 @@ static void ieee80211_mesh_work(struct w
 	if (!netif_running(sdata->dev))
 		return;
 
-	if (local->sta_sw_scanning || local->sta_hw_scanning)
+	if (local->sw_scanning || local->hw_scanning)
 		return;
 
 	while ((skb = skb_dequeue(&ifmsh->skb_queue)))
--- everything.orig/net/mac80211/mlme.c	2008-09-10 23:57:59.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-10 23:58:02.000000000 +0200
@@ -52,7 +52,7 @@ static int ecw2cw(int ecw)
 	return (1 << ecw) - 1;
 }
 
-static u8 *ieee80211_bss_get_ie(struct ieee80211_sta_bss *bss, u8 ie)
+static u8 *ieee80211_bss_get_ie(struct ieee80211_bss *bss, u8 ie)
 {
 	u8 *end, *pos;
 
@@ -72,7 +72,7 @@ static u8 *ieee80211_bss_get_ie(struct i
 	return NULL;
 }
 
-static int ieee80211_compatible_rates(struct ieee80211_sta_bss *bss,
+static int ieee80211_compatible_rates(struct ieee80211_bss *bss,
 				      struct ieee80211_supported_band *sband,
 				      u64 *rates)
 {
@@ -239,7 +239,7 @@ static void ieee80211_send_assoc(struct 
 	u8 *pos, *ies, *ht_add_ie;
 	int i, len, count, rates_len, supp_rates_len;
 	u16 capab;
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 	int wmm = 0;
 	struct ieee80211_supported_band *sband;
 	u64 rates = 0;
@@ -470,7 +470,7 @@ static void ieee80211_send_deauth_disass
 
 /* MLME */
 static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_sta_bss *bss)
+					 struct ieee80211_bss *bss)
 {
 	struct ieee80211_local *local = sdata->local;
 	int i, have_higher_than_11mbit = 0;
@@ -621,7 +621,7 @@ static u32 ieee80211_handle_erp_ie(struc
 }
 
 static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
-					   struct ieee80211_sta_bss *bss)
+					   struct ieee80211_bss *bss)
 {
 	u32 changed = 0;
 
@@ -705,7 +705,7 @@ static void ieee80211_set_associated(str
 	struct ieee80211_conf *conf = &local_to_hw(local)->conf;
 	u32 changed = BSS_CHANGED_ASSOC;
 
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 
 	ifsta->flags |= IEEE80211_STA_ASSOCIATED;
 
@@ -877,7 +877,7 @@ static int ieee80211_privacy_mismatch(st
 				      struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 	int bss_privacy;
 	int wep_privacy;
 	int privacy_invoked;
@@ -1250,7 +1250,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	/* Add STA entry for the AP */
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
-		struct ieee80211_sta_bss *bss;
+		struct ieee80211_bss *bss;
 		int err;
 
 		sta = sta_info_alloc(sdata, ifsta->bssid, GFP_ATOMIC);
@@ -1370,7 +1370,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 static int ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_if_sta *ifsta,
-				   struct ieee80211_sta_bss *bss)
+				   struct ieee80211_bss *bss)
 {
 	struct ieee80211_local *local = sdata->local;
 	int res, rates, i, j;
@@ -1521,7 +1521,7 @@ static void ieee80211_rx_bss_info(struct
 {
 	struct ieee80211_local *local = sdata->local;
 	int freq;
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 	struct sta_info *sta;
 	struct ieee80211_channel *channel;
 	u64 beacon_timestamp, rx_timestamp;
@@ -1924,7 +1924,7 @@ static void ieee80211_sta_merge_ibss(str
 
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
-	ieee80211_sta_req_scan(sdata, ifsta->ssid, ifsta->ssid_len);
+	ieee80211_request_scan(sdata, ifsta->ssid, ifsta->ssid_len);
 }
 
 
@@ -2005,7 +2005,7 @@ static int ieee80211_sta_create_ibss(str
 				     struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 	struct ieee80211_supported_band *sband;
 	u8 bssid[ETH_ALEN], *pos;
 	int i;
@@ -2066,7 +2066,7 @@ static int ieee80211_sta_find_ibss(struc
 				   struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 	int found = 0;
 	u8 bssid[ETH_ALEN];
 	int active_ibss;
@@ -2081,8 +2081,8 @@ static int ieee80211_sta_find_ibss(struc
 	printk(KERN_DEBUG "%s: sta_find_ibss (active_ibss=%d)\n",
 	       sdata->dev->name, active_ibss);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
-	spin_lock_bh(&local->sta_bss_lock);
-	list_for_each_entry(bss, &local->sta_bss_list, list) {
+	spin_lock_bh(&local->bss_lock);
+	list_for_each_entry(bss, &local->bss_list, list) {
 		if (ifsta->ssid_len != bss->ssid_len ||
 		    memcmp(ifsta->ssid, bss->ssid, bss->ssid_len) != 0
 		    || !(bss->capability & WLAN_CAPABILITY_IBSS))
@@ -2096,7 +2096,7 @@ static int ieee80211_sta_find_ibss(struc
 		if (active_ibss || memcmp(bssid, ifsta->bssid, ETH_ALEN) != 0)
 			break;
 	}
-	spin_unlock_bh(&local->sta_bss_lock);
+	spin_unlock_bh(&local->bss_lock);
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	if (found)
@@ -2141,7 +2141,7 @@ dont_join:
 			      IEEE80211_SCAN_INTERVAL)) {
 		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
 		       "join\n", sdata->dev->name);
-		return ieee80211_sta_req_scan(sdata, ifsta->ssid,
+		return ieee80211_request_scan(sdata, ifsta->ssid,
 					      ifsta->ssid_len);
 	} else if (ifsta->state != IEEE80211_STA_MLME_IBSS_JOINED) {
 		int interval = IEEE80211_SCAN_INTERVAL;
@@ -2176,12 +2176,12 @@ static int ieee80211_sta_config_auth(str
 				     struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sta_bss *bss, *selected = NULL;
+	struct ieee80211_bss *bss, *selected = NULL;
 	int top_rssi = 0, freq;
 
-	spin_lock_bh(&local->sta_bss_lock);
+	spin_lock_bh(&local->bss_lock);
 	freq = local->oper_channel->center_freq;
-	list_for_each_entry(bss, &local->sta_bss_list, list) {
+	list_for_each_entry(bss, &local->bss_list, list) {
 		if (!(bss->capability & WLAN_CAPABILITY_ESS))
 			continue;
 
@@ -2211,7 +2211,7 @@ static int ieee80211_sta_config_auth(str
 	}
 	if (selected)
 		atomic_inc(&selected->users);
-	spin_unlock_bh(&local->sta_bss_lock);
+	spin_unlock_bh(&local->bss_lock);
 
 	if (selected) {
 		ieee80211_set_freq(sdata, selected->freq);
@@ -2238,9 +2238,9 @@ static int ieee80211_sta_config_auth(str
 		if (ifsta->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
 			ifsta->assoc_scan_tries++;
 			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
-				ieee80211_sta_start_scan(sdata, NULL, 0);
+				ieee80211_start_scan(sdata, NULL, 0);
 			else
-				ieee80211_sta_start_scan(sdata, ifsta->ssid,
+				ieee80211_start_scan(sdata, ifsta->ssid,
 							 ifsta->ssid_len);
 			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
 			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
@@ -2262,7 +2262,7 @@ static void ieee80211_sta_work(struct wo
 	if (!netif_running(sdata->dev))
 		return;
 
-	if (local->sta_sw_scanning || local->sta_hw_scanning)
+	if (local->sw_scanning || local->hw_scanning)
 		return;
 
 	if (WARN_ON(sdata->vif.type != IEEE80211_IF_TYPE_STA &&
@@ -2277,7 +2277,8 @@ static void ieee80211_sta_work(struct wo
 	    ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
 	    ifsta->state != IEEE80211_STA_MLME_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
-		ieee80211_sta_start_scan(sdata, ifsta->scan_ssid, ifsta->scan_ssid_len);
+		ieee80211_start_scan(sdata, ifsta->scan_ssid,
+				     ifsta->scan_ssid_len);
 		return;
 	}
 
--- everything.orig/net/mac80211/rx.c	2008-09-10 23:58:01.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-09-10 23:58:02.000000000 +0200
@@ -403,12 +403,12 @@ ieee80211_rx_h_passive_scan(struct ieee8
 	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb = rx->skb;
 
-	if (unlikely(local->sta_hw_scanning))
-		return ieee80211_sta_rx_scan(rx->sdata, skb, rx->status);
+	if (unlikely(local->hw_scanning))
+		return ieee80211_scan_rx(rx->sdata, skb, rx->status);
 
-	if (unlikely(local->sta_sw_scanning)) {
+	if (unlikely(local->sw_scanning)) {
 		/* drop all the other packets during a software scan anyway */
-		if (ieee80211_sta_rx_scan(rx->sdata, skb, rx->status)
+		if (ieee80211_scan_rx(rx->sdata, skb, rx->status)
 		    != RX_QUEUED)
 			dev_kfree_skb(skb);
 		return RX_QUEUED;
@@ -1918,7 +1918,7 @@ static void __ieee80211_rx_handle_packet
 		return;
 	}
 
-	if (unlikely(local->sta_sw_scanning || local->sta_hw_scanning))
+	if (unlikely(local->sw_scanning || local->hw_scanning))
 		rx.flags |= IEEE80211_RX_IN_SCAN;
 
 	ieee80211_parse_qos(&rx);
--- everything.orig/net/mac80211/scan.c	2008-09-10 23:57:58.000000000 +0200
+++ everything/net/mac80211/scan.c	2008-09-10 23:58:02.000000000 +0200
@@ -32,26 +32,26 @@
 
 void ieee80211_rx_bss_list_init(struct ieee80211_local *local)
 {
-	spin_lock_init(&local->sta_bss_lock);
-	INIT_LIST_HEAD(&local->sta_bss_list);
+	spin_lock_init(&local->bss_lock);
+	INIT_LIST_HEAD(&local->bss_list);
 }
 
 void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local)
 {
-	struct ieee80211_sta_bss *bss, *tmp;
+	struct ieee80211_bss *bss, *tmp;
 
-	list_for_each_entry_safe(bss, tmp, &local->sta_bss_list, list)
+	list_for_each_entry_safe(bss, tmp, &local->bss_list, list)
 		ieee80211_rx_bss_put(local, bss);
 }
 
-struct ieee80211_sta_bss *
+struct ieee80211_bss *
 ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 
-	spin_lock_bh(&local->sta_bss_lock);
-	bss = local->sta_bss_hash[STA_HASH(bssid)];
+	spin_lock_bh(&local->bss_lock);
+	bss = local->bss_hash[STA_HASH(bssid)];
 	while (bss) {
 		if (!bss_mesh_cfg(bss) &&
 		    !memcmp(bss->bssid, bssid, ETH_ALEN) &&
@@ -63,13 +63,13 @@ ieee80211_rx_bss_get(struct ieee80211_lo
 		}
 		bss = bss->hnext;
 	}
-	spin_unlock_bh(&local->sta_bss_lock);
+	spin_unlock_bh(&local->bss_lock);
 	return bss;
 }
 
-/* Caller must hold local->sta_bss_lock */
+/* Caller must hold local->bss_lock */
 static void __ieee80211_rx_bss_hash_add(struct ieee80211_local *local,
-					struct ieee80211_sta_bss *bss)
+					struct ieee80211_bss *bss)
 {
 	u8 hash_idx;
 
@@ -79,20 +79,20 @@ static void __ieee80211_rx_bss_hash_add(
 	else
 		hash_idx = STA_HASH(bss->bssid);
 
-	bss->hnext = local->sta_bss_hash[hash_idx];
-	local->sta_bss_hash[hash_idx] = bss;
+	bss->hnext = local->bss_hash[hash_idx];
+	local->bss_hash[hash_idx] = bss;
 }
 
-/* Caller must hold local->sta_bss_lock */
+/* Caller must hold local->bss_lock */
 static void __ieee80211_rx_bss_hash_del(struct ieee80211_local *local,
-					struct ieee80211_sta_bss *bss)
+					struct ieee80211_bss *bss)
 {
-	struct ieee80211_sta_bss *b, *prev = NULL;
-	b = local->sta_bss_hash[STA_HASH(bss->bssid)];
+	struct ieee80211_bss *b, *prev = NULL;
+	b = local->bss_hash[STA_HASH(bss->bssid)];
 	while (b) {
 		if (b == bss) {
 			if (!prev)
-				local->sta_bss_hash[STA_HASH(bss->bssid)] =
+				local->bss_hash[STA_HASH(bss->bssid)] =
 					bss->hnext;
 			else
 				prev->hnext = bss->hnext;
@@ -103,11 +103,11 @@ static void __ieee80211_rx_bss_hash_del(
 	}
 }
 
-struct ieee80211_sta_bss *
+struct ieee80211_bss *
 ieee80211_rx_bss_add(struct ieee80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 
 	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
 	if (!bss)
@@ -120,23 +120,23 @@ ieee80211_rx_bss_add(struct ieee80211_lo
 		bss->ssid_len = ssid_len;
 	}
 
-	spin_lock_bh(&local->sta_bss_lock);
+	spin_lock_bh(&local->bss_lock);
 	/* TODO: order by RSSI? */
-	list_add_tail(&bss->list, &local->sta_bss_list);
+	list_add_tail(&bss->list, &local->bss_list);
 	__ieee80211_rx_bss_hash_add(local, bss);
-	spin_unlock_bh(&local->sta_bss_lock);
+	spin_unlock_bh(&local->bss_lock);
 	return bss;
 }
 
 #ifdef CONFIG_MAC80211_MESH
-static struct ieee80211_sta_bss *
+static struct ieee80211_bss *
 ieee80211_rx_mesh_bss_get(struct ieee80211_local *local, u8 *mesh_id, int mesh_id_len,
 			  u8 *mesh_cfg, int freq)
 {
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 
-	spin_lock_bh(&local->sta_bss_lock);
-	bss = local->sta_bss_hash[mesh_id_hash(mesh_id, mesh_id_len)];
+	spin_lock_bh(&local->bss_lock);
+	bss = local->bss_hash[mesh_id_hash(mesh_id, mesh_id_len)];
 	while (bss) {
 		if (bss_mesh_cfg(bss) &&
 		    !memcmp(bss_mesh_cfg(bss), mesh_cfg, MESH_CFG_CMP_LEN) &&
@@ -149,15 +149,15 @@ ieee80211_rx_mesh_bss_get(struct ieee802
 		}
 		bss = bss->hnext;
 	}
-	spin_unlock_bh(&local->sta_bss_lock);
+	spin_unlock_bh(&local->bss_lock);
 	return bss;
 }
 
-static struct ieee80211_sta_bss *
+static struct ieee80211_bss *
 ieee80211_rx_mesh_bss_add(struct ieee80211_local *local, u8 *mesh_id, int mesh_id_len,
 			  u8 *mesh_cfg, int mesh_config_len, int freq)
 {
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 
 	if (mesh_config_len != MESH_CFG_LEN)
 		return NULL;
@@ -186,16 +186,16 @@ ieee80211_rx_mesh_bss_add(struct ieee802
 	memcpy(bss->mesh_cfg, mesh_cfg, MESH_CFG_CMP_LEN);
 	bss->mesh_id_len = mesh_id_len;
 	bss->freq = freq;
-	spin_lock_bh(&local->sta_bss_lock);
+	spin_lock_bh(&local->bss_lock);
 	/* TODO: order by RSSI? */
-	list_add_tail(&bss->list, &local->sta_bss_list);
+	list_add_tail(&bss->list, &local->bss_list);
 	__ieee80211_rx_bss_hash_add(local, bss);
-	spin_unlock_bh(&local->sta_bss_lock);
+	spin_unlock_bh(&local->bss_lock);
 	return bss;
 }
 #endif
 
-static void ieee80211_rx_bss_free(struct ieee80211_sta_bss *bss)
+static void ieee80211_rx_bss_free(struct ieee80211_bss *bss)
 {
 	kfree(bss->ies);
 	kfree(bss_mesh_id(bss));
@@ -204,21 +204,21 @@ static void ieee80211_rx_bss_free(struct
 }
 
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
-			  struct ieee80211_sta_bss *bss)
+			  struct ieee80211_bss *bss)
 {
 	local_bh_disable();
-	if (!atomic_dec_and_lock(&bss->users, &local->sta_bss_lock)) {
+	if (!atomic_dec_and_lock(&bss->users, &local->bss_lock)) {
 		local_bh_enable();
 		return;
 	}
 
 	__ieee80211_rx_bss_hash_del(local, bss);
 	list_del(&bss->list);
-	spin_unlock_bh(&local->sta_bss_lock);
+	spin_unlock_bh(&local->bss_lock);
 	ieee80211_rx_bss_free(bss);
 }
 
-struct ieee80211_sta_bss *
+struct ieee80211_bss *
 ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
 			  struct ieee80211_mgmt *mgmt,
@@ -226,7 +226,7 @@ ieee80211_bss_info_update(struct ieee802
 			  struct ieee802_11_elems *elems,
 			  int freq, bool beacon)
 {
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 	int clen;
 
 #ifdef CONFIG_MAC80211_MESH
@@ -252,9 +252,9 @@ ieee80211_bss_info_update(struct ieee802
 	} else {
 #if 0
 		/* TODO: order by RSSI? */
-		spin_lock_bh(&local->sta_bss_lock);
-		list_move_tail(&bss->list, &local->sta_bss_list);
-		spin_unlock_bh(&local->sta_bss_lock);
+		spin_lock_bh(&local->bss_lock);
+		list_move_tail(&bss->list, &local->bss_list);
+		spin_unlock_bh(&local->bss_lock);
 #endif
 	}
 
@@ -327,11 +327,11 @@ ieee80211_bss_info_update(struct ieee802
 }
 
 ieee80211_rx_result
-ieee80211_sta_rx_scan(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		      struct ieee80211_rx_status *rx_status)
+ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		  struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 	u8 *elements;
 	struct ieee80211_channel *channel;
 	size_t baselen;
@@ -430,7 +430,7 @@ void ieee80211_scan_completed(struct iee
 	struct ieee80211_sub_if_data *sdata;
 	union iwreq_data wrqu;
 
-	if (WARN_ON(!local->sta_hw_scanning && !local->sta_sw_scanning))
+	if (WARN_ON(!local->hw_scanning && !local->sw_scanning))
 		return;
 
 	local->last_scan_completed = jiffies;
@@ -445,8 +445,8 @@ void ieee80211_scan_completed(struct iee
 	if (sdata)
 		wireless_send_event(sdata->dev, SIOCGIWSCAN, &wrqu, NULL);
 
-	if (local->sta_hw_scanning) {
-		local->sta_hw_scanning = 0;
+	if (local->hw_scanning) {
+		local->hw_scanning = false;
 		if (ieee80211_hw_config(local))
 			printk(KERN_DEBUG "%s: failed to restore operational "
 			       "channel after scan\n", wiphy_name(local->hw.wiphy));
@@ -454,7 +454,7 @@ void ieee80211_scan_completed(struct iee
 		goto done;
 	}
 
-	local->sta_sw_scanning = 0;
+	local->sw_scanning = false;
 	if (ieee80211_hw_config(local))
 		printk(KERN_DEBUG "%s: failed to restore operational "
 		       "channel after scan\n", wiphy_name(local->hw.wiphy));
@@ -492,7 +492,7 @@ void ieee80211_scan_completed(struct iee
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
 
-void ieee80211_sta_scan_work(struct work_struct *work)
+void ieee80211_scan_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, scan_work.work);
@@ -589,8 +589,8 @@ void ieee80211_sta_scan_work(struct work
 }
 
 
-int ieee80211_sta_start_scan(struct ieee80211_sub_if_data *scan_sdata,
-			     u8 *ssid, size_t ssid_len)
+int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
+			 u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local = scan_sdata->local;
 	struct ieee80211_sub_if_data *sdata;
@@ -615,7 +615,7 @@ int ieee80211_sta_start_scan(struct ieee
 	  * ResultCode: SUCCESS, INVALID_PARAMETERS
 	 */
 
-	if (local->sta_sw_scanning || local->sta_hw_scanning) {
+	if (local->sw_scanning || local->hw_scanning) {
 		if (local->scan_sdata == scan_sdata)
 			return 0;
 		return -EBUSY;
@@ -624,17 +624,17 @@ int ieee80211_sta_start_scan(struct ieee
 	if (local->ops->hw_scan) {
 		int rc;
 
-		local->sta_hw_scanning = 1;
+		local->hw_scanning = true;
 		rc = local->ops->hw_scan(local_to_hw(local), ssid, ssid_len);
 		if (rc) {
-			local->sta_hw_scanning = 0;
+			local->hw_scanning = false;
 			return rc;
 		}
 		local->scan_sdata = scan_sdata;
 		return 0;
 	}
 
-	local->sta_sw_scanning = 1;
+	local->sw_scanning = true;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
@@ -675,13 +675,14 @@ int ieee80211_sta_start_scan(struct ieee
 }
 
 
-int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8 *ssid, size_t ssid_len)
+int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
+			   u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_sta *ifsta;
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
-		return ieee80211_sta_start_scan(sdata, ssid, ssid_len);
+		return ieee80211_start_scan(sdata, ssid, ssid_len);
 
 	/*
 	 * STA has a state machine that might need to defer scanning
@@ -689,7 +690,7 @@ int ieee80211_sta_req_scan(struct ieee80
 	 * queue it up to the state machine in that case.
 	 */
 
-	if (local->sta_sw_scanning || local->sta_hw_scanning) {
+	if (local->sw_scanning || local->hw_scanning) {
 		if (local->scan_sdata == sdata)
 			return 0;
 		return -EBUSY;
@@ -707,9 +708,9 @@ int ieee80211_sta_req_scan(struct ieee80
 }
 
 
-static void ieee80211_sta_add_scan_ies(struct iw_request_info *info,
-				       struct ieee80211_sta_bss *bss,
-				       char **current_ev, char *end_buf)
+static void ieee80211_scan_add_ies(struct iw_request_info *info,
+				   struct ieee80211_bss *bss,
+				   char **current_ev, char *end_buf)
 {
 	u8 *pos, *end, *next;
 	struct iw_event iwe;
@@ -749,10 +750,10 @@ static void ieee80211_sta_add_scan_ies(s
 
 
 static char *
-ieee80211_sta_scan_result(struct ieee80211_local *local,
-			  struct iw_request_info *info,
-			  struct ieee80211_sta_bss *bss,
-			  char *current_ev, char *end_buf)
+ieee80211_scan_result(struct ieee80211_local *local,
+		      struct iw_request_info *info,
+		      struct ieee80211_bss *bss,
+		      char *current_ev, char *end_buf)
 {
 	struct iw_event iwe;
 	char *buf;
@@ -828,7 +829,7 @@ ieee80211_sta_scan_result(struct ieee802
 	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
 					  &iwe, "");
 
-	ieee80211_sta_add_scan_ies(info, bss, &current_ev, end_buf);
+	ieee80211_scan_add_ies(info, bss, &current_ev, end_buf);
 
 	if (bss->supp_rates_len > 0) {
 		/* display all supported rates in readable format */
@@ -914,23 +915,23 @@ ieee80211_sta_scan_result(struct ieee802
 }
 
 
-int ieee80211_sta_scan_results(struct ieee80211_local *local,
-			       struct iw_request_info *info,
-			       char *buf, size_t len)
+int ieee80211_scan_results(struct ieee80211_local *local,
+			   struct iw_request_info *info,
+			   char *buf, size_t len)
 {
 	char *current_ev = buf;
 	char *end_buf = buf + len;
-	struct ieee80211_sta_bss *bss;
+	struct ieee80211_bss *bss;
 
-	spin_lock_bh(&local->sta_bss_lock);
-	list_for_each_entry(bss, &local->sta_bss_list, list) {
+	spin_lock_bh(&local->bss_lock);
+	list_for_each_entry(bss, &local->bss_list, list) {
 		if (buf + len - current_ev <= IW_EV_ADDR_LEN) {
-			spin_unlock_bh(&local->sta_bss_lock);
+			spin_unlock_bh(&local->bss_lock);
 			return -E2BIG;
 		}
-		current_ev = ieee80211_sta_scan_result(local, info, bss,
+		current_ev = ieee80211_scan_result(local, info, bss,
 						       current_ev, end_buf);
 	}
-	spin_unlock_bh(&local->sta_bss_lock);
+	spin_unlock_bh(&local->bss_lock);
 	return current_ev - buf;
 }
--- everything.orig/net/mac80211/tx.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-10 23:58:02.000000000 +0200
@@ -222,7 +222,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
 		return TX_CONTINUE;
 
-	if (unlikely(tx->local->sta_sw_scanning) &&
+	if (unlikely(tx->local->sw_scanning) &&
 	    !ieee80211_is_probe_req(hdr->frame_control))
 		return TX_DROP;
 
--- everything.orig/net/mac80211/util.c	2008-09-10 23:58:00.000000000 +0200
+++ everything/net/mac80211/util.c	2008-09-10 23:58:02.000000000 +0200
@@ -630,7 +630,7 @@ int ieee80211_set_freq(struct ieee80211_
 		}
 		local->oper_channel = chan;
 
-		if (local->sta_sw_scanning || local->sta_hw_scanning)
+		if (local->sw_scanning || local->hw_scanning)
 			ret = 0;
 		else
 			ret = ieee80211_hw_config(local);
--- everything.orig/net/mac80211/wext.c	2008-09-10 23:58:00.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-09-10 23:58:02.000000000 +0200
@@ -552,7 +552,7 @@ static int ieee80211_ioctl_siwscan(struc
 		ssid_len = req->essid_len;
 	}
 
-	return ieee80211_sta_req_scan(sdata, ssid, ssid_len);
+	return ieee80211_request_scan(sdata, ssid, ssid_len);
 }
 
 
@@ -566,10 +566,10 @@ static int ieee80211_ioctl_giwscan(struc
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (local->sta_sw_scanning || local->sta_hw_scanning)
+	if (local->sw_scanning || local->hw_scanning)
 		return -EAGAIN;
 
-	res = ieee80211_sta_scan_results(local, info, extra, data->length);
+	res = ieee80211_scan_results(local, info, extra, data->length);
 	if (res >= 0) {
 		data->length = res;
 		return 0;

-- 

