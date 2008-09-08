Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbYIHPp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:45:59 -0400
Message-Id: <20080908154443.414884000@sipsolutions.net> (sfid-20080908_174605_368069_3C87026E)
References: <20080908154421.216772000@sipsolutions.net>
Date: Mon, 08 Sep 2008 17:44:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] mac80211: move BSS handling to scan code
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves all the BSS list handling out of mlme.c to scan.c,
no further changes except fixing kzalloc/atomic_inc/atomic_inc
to kzalloc/atomic_set(2).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
mlme.c is on a diet!

 net/mac80211/ieee80211_i.h |    6 
 net/mac80211/mlme.c        |  310 ---------------------------------------------
 net/mac80211/scan.c        |  305 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 313 insertions(+), 308 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-08 15:42:45.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-08 15:42:47.000000000 +0200
@@ -944,6 +944,12 @@ ieee80211_bss_info_update(struct ieee802
 			  size_t len,
 			  struct ieee802_11_elems *elems,
 			  int freq, bool beacon);
+struct ieee80211_sta_bss *
+ieee80211_rx_bss_add(struct ieee80211_local *local, u8 *bssid, int freq,
+		     u8 *ssid, u8 ssid_len);
+struct ieee80211_sta_bss *
+ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
+		     u8 *ssid, u8 ssid_len);
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_sta_bss *bss);
 
--- everything.orig/net/mac80211/mlme.c	2008-09-08 15:42:45.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 15:42:47.000000000 +0200
@@ -11,11 +11,6 @@
  * published by the Free Software Foundation.
  */
 
-/* TODO:
- * order BSS list by RSSI(?) ("quality of AP")
- * scan result table filtering (by capability (privacy, IBSS/BSS, WPA/RSN IE,
- *    SSID)
- */
 #include <linux/delay.h>
 #include <linux/if_ether.h>
 #include <linux/skbuff.h>
@@ -67,195 +62,10 @@
 #define IEEE80211_MIN_AMPDU_BUF 0x8
 #define IEEE80211_MAX_AMPDU_BUF 0x40
 
-/* BSS handling */
-static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
-		     u8 *ssid, u8 ssid_len)
-{
-	struct ieee80211_sta_bss *bss;
-
-	spin_lock_bh(&local->sta_bss_lock);
-	bss = local->sta_bss_hash[STA_HASH(bssid)];
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
-	spin_unlock_bh(&local->sta_bss_lock);
-	return bss;
-}
-
-/* Caller must hold local->sta_bss_lock */
-static void __ieee80211_rx_bss_hash_add(struct ieee80211_local *local,
-					struct ieee80211_sta_bss *bss)
-{
-	u8 hash_idx;
-
-	if (bss_mesh_cfg(bss))
-		hash_idx = mesh_id_hash(bss_mesh_id(bss),
-					bss_mesh_id_len(bss));
-	else
-		hash_idx = STA_HASH(bss->bssid);
-
-	bss->hnext = local->sta_bss_hash[hash_idx];
-	local->sta_bss_hash[hash_idx] = bss;
-}
-
-/* Caller must hold local->sta_bss_lock */
-static void __ieee80211_rx_bss_hash_del(struct ieee80211_local *local,
-					struct ieee80211_sta_bss *bss)
-{
-	struct ieee80211_sta_bss *b, *prev = NULL;
-	b = local->sta_bss_hash[STA_HASH(bss->bssid)];
-	while (b) {
-		if (b == bss) {
-			if (!prev)
-				local->sta_bss_hash[STA_HASH(bss->bssid)] =
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
-static struct ieee80211_sta_bss *
-ieee80211_rx_bss_add(struct ieee80211_local *local, u8 *bssid, int freq,
-		     u8 *ssid, u8 ssid_len)
-{
-	struct ieee80211_sta_bss *bss;
-
-	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
-	if (!bss)
-		return NULL;
-	atomic_inc(&bss->users);
-	atomic_inc(&bss->users);
-	memcpy(bss->bssid, bssid, ETH_ALEN);
-	bss->freq = freq;
-	if (ssid && ssid_len <= IEEE80211_MAX_SSID_LEN) {
-		memcpy(bss->ssid, ssid, ssid_len);
-		bss->ssid_len = ssid_len;
-	}
-
-	spin_lock_bh(&local->sta_bss_lock);
-	/* TODO: order by RSSI? */
-	list_add_tail(&bss->list, &local->sta_bss_list);
-	__ieee80211_rx_bss_hash_add(local, bss);
-	spin_unlock_bh(&local->sta_bss_lock);
-	return bss;
-}
-
-#ifdef CONFIG_MAC80211_MESH
-static struct ieee80211_sta_bss *
-ieee80211_rx_mesh_bss_get(struct ieee80211_local *local, u8 *mesh_id, int mesh_id_len,
-			  u8 *mesh_cfg, int freq)
-{
-	struct ieee80211_sta_bss *bss;
-
-	spin_lock_bh(&local->sta_bss_lock);
-	bss = local->sta_bss_hash[mesh_id_hash(mesh_id, mesh_id_len)];
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
-	spin_unlock_bh(&local->sta_bss_lock);
-	return bss;
-}
-
-static struct ieee80211_sta_bss *
-ieee80211_rx_mesh_bss_add(struct ieee80211_local *local, u8 *mesh_id, int mesh_id_len,
-			  u8 *mesh_cfg, int mesh_config_len, int freq)
-{
-	struct ieee80211_sta_bss *bss;
-
-	if (mesh_config_len != MESH_CFG_LEN)
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
-	atomic_inc(&bss->users);
-	atomic_inc(&bss->users);
-	memcpy(bss->mesh_cfg, mesh_cfg, MESH_CFG_CMP_LEN);
-	bss->mesh_id_len = mesh_id_len;
-	bss->freq = freq;
-	spin_lock_bh(&local->sta_bss_lock);
-	/* TODO: order by RSSI? */
-	list_add_tail(&bss->list, &local->sta_bss_list);
-	__ieee80211_rx_bss_hash_add(local, bss);
-	spin_unlock_bh(&local->sta_bss_lock);
-	return bss;
-}
-#endif
-
-static void ieee80211_rx_bss_free(struct ieee80211_sta_bss *bss)
-{
-	kfree(bss->ies);
-	kfree(bss_mesh_id(bss));
-	kfree(bss_mesh_cfg(bss));
-	kfree(bss);
-}
-
-void ieee80211_rx_bss_put(struct ieee80211_local *local,
-			  struct ieee80211_sta_bss *bss)
-{
-	local_bh_disable();
-	if (!atomic_dec_and_lock(&bss->users, &local->sta_bss_lock)) {
-		local_bh_enable();
-		return;
-	}
-
-	__ieee80211_rx_bss_hash_del(local, bss);
-	list_del(&bss->list);
-	spin_unlock_bh(&local->sta_bss_lock);
-	ieee80211_rx_bss_free(bss);
-}
-
-void ieee80211_rx_bss_list_init(struct ieee80211_local *local)
-{
-	spin_lock_init(&local->sta_bss_lock);
-	INIT_LIST_HEAD(&local->sta_bss_list);
-}
-
-void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local)
+/* utils */
+static int ecw2cw(int ecw)
 {
-	struct ieee80211_sta_bss *bss, *tmp;
-
-	list_for_each_entry_safe(bss, tmp, &local->sta_bss_list, list)
-		ieee80211_rx_bss_put(local, bss);
+	return (1 << ecw) - 1;
 }
 
 static u8 *ieee80211_bss_get_ie(struct ieee80211_sta_bss *bss, u8 ie)
@@ -278,12 +88,6 @@ static u8 *ieee80211_bss_get_ie(struct i
 	return NULL;
 }
 
-/* utils */
-static int ecw2cw(int ecw)
-{
-	return (1 << ecw) - 1;
-}
-
 /* frame sending functions */
 void ieee80211_sta_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		      int encrypt)
@@ -2443,114 +2247,6 @@ static u64 ieee80211_sta_get_mandatory_r
 	return mandatory_rates;
 }
 
-struct ieee80211_sta_bss *
-ieee80211_bss_info_update(struct ieee80211_local *local,
-			  struct ieee80211_rx_status *rx_status,
-			  struct ieee80211_mgmt *mgmt,
-			  size_t len,
-			  struct ieee802_11_elems *elems,
-			  int freq, bool beacon)
-{
-	struct ieee80211_sta_bss *bss;
-	int clen;
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
-		spin_lock_bh(&local->sta_bss_lock);
-		list_move_tail(&bss->list, &local->sta_bss_list);
-		spin_unlock_bh(&local->sta_bss_lock);
-#endif
-	}
-
-	/* save the ERP value so that it is available at association time */
-	if (elems->erp_info && elems->erp_info_len >= 1) {
-		bss->erp_value = elems->erp_info[0];
-		bss->has_erp_value = 1;
-	}
-
-	bss->beacon_int = le16_to_cpu(mgmt->u.beacon.beacon_int);
-	bss->capability = le16_to_cpu(mgmt->u.beacon.capab_info);
-
-	if (elems->tim) {
-		struct ieee80211_tim_ie *tim_ie =
-			(struct ieee80211_tim_ie *)elems->tim;
-		bss->dtim_period = tim_ie->dtim_period;
-	}
-
-	/* set default value for buggy APs */
-	if (!elems->tim || bss->dtim_period == 0)
-		bss->dtim_period = 1;
-
-	bss->supp_rates_len = 0;
-	if (elems->supp_rates) {
-		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
-		if (clen > elems->supp_rates_len)
-			clen = elems->supp_rates_len;
-		memcpy(&bss->supp_rates[bss->supp_rates_len], elems->supp_rates,
-		       clen);
-		bss->supp_rates_len += clen;
-	}
-	if (elems->ext_supp_rates) {
-		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
-		if (clen > elems->ext_supp_rates_len)
-			clen = elems->ext_supp_rates_len;
-		memcpy(&bss->supp_rates[bss->supp_rates_len],
-		       elems->ext_supp_rates, clen);
-		bss->supp_rates_len += clen;
-	}
-
-	bss->band = rx_status->band;
-
-	bss->timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
-	bss->last_update = jiffies;
-	bss->signal = rx_status->signal;
-	bss->noise = rx_status->noise;
-	bss->qual = rx_status->qual;
-	bss->wmm_used = elems->wmm_param || elems->wmm_info;
-
-	if (!beacon)
-		bss->last_probe_resp = jiffies;
-
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
-	return bss;
-}
-
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
--- everything.orig/net/mac80211/scan.c	2008-09-08 15:42:45.000000000 +0200
+++ everything/net/mac80211/scan.c	2008-09-08 15:42:47.000000000 +0200
@@ -1,5 +1,6 @@
 /*
- * BSS client mode implementation
+ * Scanning implementation
+ *
  * Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>
  * Copyright 2004, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
@@ -11,17 +12,319 @@
  * published by the Free Software Foundation.
  */
 
+/* TODO:
+ * order BSS list by RSSI(?) ("quality of AP")
+ * scan result table filtering (by capability (privacy, IBSS/BSS, WPA/RSN IE,
+ *    SSID)
+ */
+
 #include <linux/wireless.h>
 #include <linux/if_arp.h>
 #include <net/mac80211.h>
 #include <net/iw_handler.h>
 
 #include "ieee80211_i.h"
+#include "mesh.h"
 
 #define IEEE80211_PROBE_DELAY (HZ / 33)
 #define IEEE80211_CHANNEL_TIME (HZ / 33)
 #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 5)
 
+void ieee80211_rx_bss_list_init(struct ieee80211_local *local)
+{
+	spin_lock_init(&local->sta_bss_lock);
+	INIT_LIST_HEAD(&local->sta_bss_list);
+}
+
+void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local)
+{
+	struct ieee80211_sta_bss *bss, *tmp;
+
+	list_for_each_entry_safe(bss, tmp, &local->sta_bss_list, list)
+		ieee80211_rx_bss_put(local, bss);
+}
+
+struct ieee80211_sta_bss *
+ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
+		     u8 *ssid, u8 ssid_len)
+{
+	struct ieee80211_sta_bss *bss;
+
+	spin_lock_bh(&local->sta_bss_lock);
+	bss = local->sta_bss_hash[STA_HASH(bssid)];
+	while (bss) {
+		if (!bss_mesh_cfg(bss) &&
+		    !memcmp(bss->bssid, bssid, ETH_ALEN) &&
+		    bss->freq == freq &&
+		    bss->ssid_len == ssid_len &&
+		    (ssid_len == 0 || !memcmp(bss->ssid, ssid, ssid_len))) {
+			atomic_inc(&bss->users);
+			break;
+		}
+		bss = bss->hnext;
+	}
+	spin_unlock_bh(&local->sta_bss_lock);
+	return bss;
+}
+
+/* Caller must hold local->sta_bss_lock */
+static void __ieee80211_rx_bss_hash_add(struct ieee80211_local *local,
+					struct ieee80211_sta_bss *bss)
+{
+	u8 hash_idx;
+
+	if (bss_mesh_cfg(bss))
+		hash_idx = mesh_id_hash(bss_mesh_id(bss),
+					bss_mesh_id_len(bss));
+	else
+		hash_idx = STA_HASH(bss->bssid);
+
+	bss->hnext = local->sta_bss_hash[hash_idx];
+	local->sta_bss_hash[hash_idx] = bss;
+}
+
+/* Caller must hold local->sta_bss_lock */
+static void __ieee80211_rx_bss_hash_del(struct ieee80211_local *local,
+					struct ieee80211_sta_bss *bss)
+{
+	struct ieee80211_sta_bss *b, *prev = NULL;
+	b = local->sta_bss_hash[STA_HASH(bss->bssid)];
+	while (b) {
+		if (b == bss) {
+			if (!prev)
+				local->sta_bss_hash[STA_HASH(bss->bssid)] =
+					bss->hnext;
+			else
+				prev->hnext = bss->hnext;
+			break;
+		}
+		prev = b;
+		b = b->hnext;
+	}
+}
+
+struct ieee80211_sta_bss *
+ieee80211_rx_bss_add(struct ieee80211_local *local, u8 *bssid, int freq,
+		     u8 *ssid, u8 ssid_len)
+{
+	struct ieee80211_sta_bss *bss;
+
+	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
+	if (!bss)
+		return NULL;
+	atomic_set(&bss->users, 2);
+	memcpy(bss->bssid, bssid, ETH_ALEN);
+	bss->freq = freq;
+	if (ssid && ssid_len <= IEEE80211_MAX_SSID_LEN) {
+		memcpy(bss->ssid, ssid, ssid_len);
+		bss->ssid_len = ssid_len;
+	}
+
+	spin_lock_bh(&local->sta_bss_lock);
+	/* TODO: order by RSSI? */
+	list_add_tail(&bss->list, &local->sta_bss_list);
+	__ieee80211_rx_bss_hash_add(local, bss);
+	spin_unlock_bh(&local->sta_bss_lock);
+	return bss;
+}
+
+#ifdef CONFIG_MAC80211_MESH
+static struct ieee80211_sta_bss *
+ieee80211_rx_mesh_bss_get(struct ieee80211_local *local, u8 *mesh_id, int mesh_id_len,
+			  u8 *mesh_cfg, int freq)
+{
+	struct ieee80211_sta_bss *bss;
+
+	spin_lock_bh(&local->sta_bss_lock);
+	bss = local->sta_bss_hash[mesh_id_hash(mesh_id, mesh_id_len)];
+	while (bss) {
+		if (bss_mesh_cfg(bss) &&
+		    !memcmp(bss_mesh_cfg(bss), mesh_cfg, MESH_CFG_CMP_LEN) &&
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
+ieee80211_rx_mesh_bss_add(struct ieee80211_local *local, u8 *mesh_id, int mesh_id_len,
+			  u8 *mesh_cfg, int mesh_config_len, int freq)
+{
+	struct ieee80211_sta_bss *bss;
+
+	if (mesh_config_len != MESH_CFG_LEN)
+		return NULL;
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
+	atomic_set(&bss->users, 2);
+	memcpy(bss->mesh_cfg, mesh_cfg, MESH_CFG_CMP_LEN);
+	bss->mesh_id_len = mesh_id_len;
+	bss->freq = freq;
+	spin_lock_bh(&local->sta_bss_lock);
+	/* TODO: order by RSSI? */
+	list_add_tail(&bss->list, &local->sta_bss_list);
+	__ieee80211_rx_bss_hash_add(local, bss);
+	spin_unlock_bh(&local->sta_bss_lock);
+	return bss;
+}
+#endif
+
+static void ieee80211_rx_bss_free(struct ieee80211_sta_bss *bss)
+{
+	kfree(bss->ies);
+	kfree(bss_mesh_id(bss));
+	kfree(bss_mesh_cfg(bss));
+	kfree(bss);
+}
+
+void ieee80211_rx_bss_put(struct ieee80211_local *local,
+			  struct ieee80211_sta_bss *bss)
+{
+	local_bh_disable();
+	if (!atomic_dec_and_lock(&bss->users, &local->sta_bss_lock)) {
+		local_bh_enable();
+		return;
+	}
+
+	__ieee80211_rx_bss_hash_del(local, bss);
+	list_del(&bss->list);
+	spin_unlock_bh(&local->sta_bss_lock);
+	ieee80211_rx_bss_free(bss);
+}
+
+struct ieee80211_sta_bss *
+ieee80211_bss_info_update(struct ieee80211_local *local,
+			  struct ieee80211_rx_status *rx_status,
+			  struct ieee80211_mgmt *mgmt,
+			  size_t len,
+			  struct ieee802_11_elems *elems,
+			  int freq, bool beacon)
+{
+	struct ieee80211_sta_bss *bss;
+	int clen;
+
+#ifdef CONFIG_MAC80211_MESH
+	if (elems->mesh_config)
+		bss = ieee80211_rx_mesh_bss_get(local, elems->mesh_id,
+				elems->mesh_id_len, elems->mesh_config, freq);
+	else
+#endif
+		bss = ieee80211_rx_bss_get(local, mgmt->bssid, freq,
+					   elems->ssid, elems->ssid_len);
+	if (!bss) {
+#ifdef CONFIG_MAC80211_MESH
+		if (elems->mesh_config)
+			bss = ieee80211_rx_mesh_bss_add(local, elems->mesh_id,
+				elems->mesh_id_len, elems->mesh_config,
+				elems->mesh_config_len, freq);
+		else
+#endif
+			bss = ieee80211_rx_bss_add(local, mgmt->bssid, freq,
+						  elems->ssid, elems->ssid_len);
+		if (!bss)
+			return NULL;
+	} else {
+#if 0
+		/* TODO: order by RSSI? */
+		spin_lock_bh(&local->sta_bss_lock);
+		list_move_tail(&bss->list, &local->sta_bss_list);
+		spin_unlock_bh(&local->sta_bss_lock);
+#endif
+	}
+
+	/* save the ERP value so that it is available at association time */
+	if (elems->erp_info && elems->erp_info_len >= 1) {
+		bss->erp_value = elems->erp_info[0];
+		bss->has_erp_value = 1;
+	}
+
+	bss->beacon_int = le16_to_cpu(mgmt->u.beacon.beacon_int);
+	bss->capability = le16_to_cpu(mgmt->u.beacon.capab_info);
+
+	if (elems->tim) {
+		struct ieee80211_tim_ie *tim_ie =
+			(struct ieee80211_tim_ie *)elems->tim;
+		bss->dtim_period = tim_ie->dtim_period;
+	}
+
+	/* set default value for buggy APs */
+	if (!elems->tim || bss->dtim_period == 0)
+		bss->dtim_period = 1;
+
+	bss->supp_rates_len = 0;
+	if (elems->supp_rates) {
+		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
+		if (clen > elems->supp_rates_len)
+			clen = elems->supp_rates_len;
+		memcpy(&bss->supp_rates[bss->supp_rates_len], elems->supp_rates,
+		       clen);
+		bss->supp_rates_len += clen;
+	}
+	if (elems->ext_supp_rates) {
+		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
+		if (clen > elems->ext_supp_rates_len)
+			clen = elems->ext_supp_rates_len;
+		memcpy(&bss->supp_rates[bss->supp_rates_len],
+		       elems->ext_supp_rates, clen);
+		bss->supp_rates_len += clen;
+	}
+
+	bss->band = rx_status->band;
+
+	bss->timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
+	bss->last_update = jiffies;
+	bss->signal = rx_status->signal;
+	bss->noise = rx_status->noise;
+	bss->qual = rx_status->qual;
+	bss->wmm_used = elems->wmm_param || elems->wmm_info;
+
+	if (!beacon)
+		bss->last_probe_resp = jiffies;
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
 
 ieee80211_rx_result
 ieee80211_sta_rx_scan(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,

-- 

