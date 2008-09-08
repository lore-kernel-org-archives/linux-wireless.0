Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbYIHPqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:46:11 -0400
Message-Id: <20080908154439.958222000@sipsolutions.net> (sfid-20080908_174627_788429_F5ECB55A)
References: <20080908154421.216772000@sipsolutions.net>
Date: Mon, 08 Sep 2008 17:44:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/8] mac80211: reorder mlme code
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reorders the mlme code a bit so we don't need all the forward
function declarations. It also removes the ERP_INFO_USE_PROTECTION
define that is unused, but otherwise contains no real changes.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c | 1224 +++++++++++++++++++++++++---------------------------
 1 file changed, 597 insertions(+), 627 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-08 16:40:03.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 16:43:02.000000000 +0200
@@ -26,9 +26,8 @@
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <net/iw_handler.h>
-#include <asm/types.h>
-
 #include <net/mac80211.h>
+
 #include "ieee80211_i.h"
 #include "rate.h"
 #include "led.h"
@@ -58,8 +57,6 @@
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
 
-#define ERP_INFO_USE_PROTECTION BIT(1)
-
 /* mgmt header + 1 byte category code */
 #define IEEE80211_MIN_ACTION_SIZE (24 + 1)
 
@@ -74,24 +71,199 @@
 #define IEEE80211_MIN_AMPDU_BUF 0x8
 #define IEEE80211_MAX_AMPDU_BUF 0x40
 
-static void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
-				     u8 *ssid, size_t ssid_len);
+/* BSS handling */
 static struct ieee80211_sta_bss *
 ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
-		     u8 *ssid, u8 ssid_len);
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
+static struct ieee80211_sta_bss *
+ieee80211_rx_bss_add(struct ieee80211_sub_if_data *sdata, u8 *bssid, int freq,
+		     u8 *ssid, u8 ssid_len)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sta_bss *bss;
+
+	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
+	if (!bss)
+		return NULL;
+	atomic_inc(&bss->users);
+	atomic_inc(&bss->users);
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
+	atomic_inc(&bss->users);
+	atomic_inc(&bss->users);
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
 static void ieee80211_rx_bss_put(struct ieee80211_local *local,
-				 struct ieee80211_sta_bss *bss);
-static int ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_if_sta *ifsta);
-static int ieee80211_sta_wep_configured(struct ieee80211_sub_if_data *sdata);
-static int ieee80211_sta_start_scan(struct ieee80211_sub_if_data *sdata,
-				    u8 *ssid, size_t ssid_len);
-static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta);
-static void sta_rx_agg_session_timer_expired(unsigned long data);
+				 struct ieee80211_sta_bss *bss)
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
 
+void ieee80211_rx_bss_list_init(struct ieee80211_local *local)
+{
+	spin_lock_init(&local->sta_bss_lock);
+	INIT_LIST_HEAD(&local->sta_bss_list);
+}
+
+void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local)
+{
+	struct ieee80211_sta_bss *bss, *tmp;
 
-static u8 * ieee80211_bss_get_ie(struct ieee80211_sta_bss *bss, u8 ie)
+	list_for_each_entry_safe(bss, tmp, &local->sta_bss_list, list)
+		ieee80211_rx_bss_put(local, bss);
+}
+
+static u8 *ieee80211_bss_get_ie(struct ieee80211_sta_bss *bss, u8 ie)
 {
 	u8 *end, *pos;
 
@@ -111,13 +283,125 @@ static u8 * ieee80211_bss_get_ie(struct 
 	return NULL;
 }
 
-
+/* utils */
 static int ecw2cw(int ecw)
 {
 	return (1 << ecw) - 1;
 }
 
+/* frame sending functions */
+void ieee80211_sta_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		      int encrypt)
+{
+	skb->dev = sdata->local->mdev;
+	skb_set_mac_header(skb, 0);
+	skb_set_network_header(skb, 0);
+	skb_set_transport_header(skb, 0);
 
+	skb->iif = sdata->dev->ifindex;
+	skb->do_not_encrypt = !encrypt;
+
+	dev_queue_xmit(skb);
+}
+
+static void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
+				struct ieee80211_if_sta *ifsta,
+				int transaction, u8 *extra, size_t extra_len,
+				int encrypt)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    sizeof(*mgmt) + 6 + extra_len);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for auth "
+		       "frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24 + 6);
+	memset(mgmt, 0, 24 + 6);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_AUTH);
+	if (encrypt)
+		mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->u.auth.auth_alg = cpu_to_le16(ifsta->auth_alg);
+	mgmt->u.auth.auth_transaction = cpu_to_le16(transaction);
+	ifsta->auth_transaction = transaction + 1;
+	mgmt->u.auth.status_code = cpu_to_le16(0);
+	if (extra)
+		memcpy(skb_put(skb, extra_len), extra, extra_len);
+
+	ieee80211_sta_tx(sdata, skb, encrypt);
+}
+
+static void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+				     u8 *ssid, size_t ssid_len)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u8 *pos, *supp_rates, *esupp_rates = NULL;
+	int i;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt) + 200);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
+		       "request\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_PROBE_REQ);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	if (dst) {
+		memcpy(mgmt->da, dst, ETH_ALEN);
+		memcpy(mgmt->bssid, dst, ETH_ALEN);
+	} else {
+		memset(mgmt->da, 0xff, ETH_ALEN);
+		memset(mgmt->bssid, 0xff, ETH_ALEN);
+	}
+	pos = skb_put(skb, 2 + ssid_len);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = ssid_len;
+	memcpy(pos, ssid, ssid_len);
+
+	supp_rates = skb_put(skb, 2);
+	supp_rates[0] = WLAN_EID_SUPP_RATES;
+	supp_rates[1] = 0;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		struct ieee80211_rate *rate = &sband->bitrates[i];
+		if (esupp_rates) {
+			pos = skb_put(skb, 1);
+			esupp_rates[1]++;
+		} else if (supp_rates[1] == 8) {
+			esupp_rates = skb_put(skb, 3);
+			esupp_rates[0] = WLAN_EID_EXT_SUPP_RATES;
+			esupp_rates[1] = 1;
+			pos = &esupp_rates[2];
+		} else {
+			pos = skb_put(skb, 1);
+			supp_rates[1]++;
+		}
+		*pos = rate->bitrate / 5;
+	}
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
+/* MLME */
 static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_sta_bss *bss,
 					 int ibss)
@@ -435,58 +719,6 @@ static void ieee80211_set_associated(str
 	ieee80211_sta_send_apinfo(sdata, ifsta);
 }
 
-void ieee80211_sta_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		      int encrypt)
-{
-	skb->dev = sdata->local->mdev;
-	skb_set_mac_header(skb, 0);
-	skb_set_network_header(skb, 0);
-	skb_set_transport_header(skb, 0);
-
-	skb->iif = sdata->dev->ifindex;
-	skb->do_not_encrypt = !encrypt;
-
-	dev_queue_xmit(skb);
-}
-
-
-static void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
-				struct ieee80211_if_sta *ifsta,
-				int transaction, u8 *extra, size_t extra_len,
-				int encrypt)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-			    sizeof(*mgmt) + 6 + extra_len);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for auth "
-		       "frame\n", sdata->dev->name);
-		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24 + 6);
-	memset(mgmt, 0, 24 + 6);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_AUTH);
-	if (encrypt)
-		mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->u.auth.auth_alg = cpu_to_le16(ifsta->auth_alg);
-	mgmt->u.auth.auth_transaction = cpu_to_le16(transaction);
-	ifsta->auth_transaction = transaction + 1;
-	mgmt->u.auth.status_code = cpu_to_le16(0);
-	if (extra)
-		memcpy(skb_put(skb, extra_len), extra, extra_len);
-
-	ieee80211_sta_tx(sdata, skb, encrypt);
-}
-
 static void ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_if_sta *ifsta)
 {
@@ -799,6 +1031,13 @@ static void ieee80211_send_deauth(struct
 	ieee80211_sta_tx(sdata, skb, 0);
 }
 
+static int ieee80211_sta_wep_configured(struct ieee80211_sub_if_data *sdata)
+{
+	if (!sdata || !sdata->default_key ||
+	    sdata->default_key->conf.alg != ALG_WEP)
+		return 0;
+	return 1;
+}
 
 static void ieee80211_send_disassoc(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_if_sta *ifsta, u16 reason)
@@ -918,7 +1157,6 @@ static int ieee80211_privacy_mismatch(st
 	return 1;
 }
 
-
 static void ieee80211_associate(struct ieee80211_sub_if_data *sdata,
 				struct ieee80211_if_sta *ifsta)
 {
@@ -1000,82 +1238,12 @@ static void ieee80211_associated(struct 
 
 	rcu_read_unlock();
 
-	if (disassoc)
-		ieee80211_set_disassoc(sdata, ifsta, true, true,
-					WLAN_REASON_PREV_AUTH_NOT_VALID);
-	else
-		mod_timer(&ifsta->timer, jiffies +
-				      IEEE80211_MONITORING_INTERVAL);
-}
-
-
-static void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
-				     u8 *ssid, size_t ssid_len)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	u8 *pos, *supp_rates, *esupp_rates = NULL;
-	int i;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt) + 200);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
-		       "request\n", sdata->dev->name);
-		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_PROBE_REQ);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (dst) {
-		memcpy(mgmt->da, dst, ETH_ALEN);
-		memcpy(mgmt->bssid, dst, ETH_ALEN);
-	} else {
-		memset(mgmt->da, 0xff, ETH_ALEN);
-		memset(mgmt->bssid, 0xff, ETH_ALEN);
-	}
-	pos = skb_put(skb, 2 + ssid_len);
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = ssid_len;
-	memcpy(pos, ssid, ssid_len);
-
-	supp_rates = skb_put(skb, 2);
-	supp_rates[0] = WLAN_EID_SUPP_RATES;
-	supp_rates[1] = 0;
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		struct ieee80211_rate *rate = &sband->bitrates[i];
-		if (esupp_rates) {
-			pos = skb_put(skb, 1);
-			esupp_rates[1]++;
-		} else if (supp_rates[1] == 8) {
-			esupp_rates = skb_put(skb, 3);
-			esupp_rates[0] = WLAN_EID_EXT_SUPP_RATES;
-			esupp_rates[1] = 1;
-			pos = &esupp_rates[2];
-		} else {
-			pos = skb_put(skb, 1);
-			supp_rates[1]++;
-		}
-		*pos = rate->bitrate / 5;
-	}
-
-	ieee80211_sta_tx(sdata, skb, 0);
-}
-
-
-static int ieee80211_sta_wep_configured(struct ieee80211_sub_if_data *sdata)
-{
-	if (!sdata || !sdata->default_key ||
-	    sdata->default_key->conf.alg != ALG_WEP)
-		return 0;
-	return 1;
+	if (disassoc)
+		ieee80211_set_disassoc(sdata, ifsta, true, true,
+					WLAN_REASON_PREV_AUTH_NOT_VALID);
+	else
+		mod_timer(&ifsta->timer, jiffies +
+				      IEEE80211_MONITORING_INTERVAL);
 }
 
 
@@ -1201,6 +1369,30 @@ void ieee80211_send_addba_request(struct
 	ieee80211_sta_tx(sdata, skb, 0);
 }
 
+/*
+ * After accepting the AddBA Request we activated a timer,
+ * resetting it after each frame that arrives from the originator.
+ * if this timer expires ieee80211_sta_stop_rx_ba_session will be executed.
+ */
+static void sta_rx_agg_session_timer_expired(unsigned long data)
+{
+	/* not an elegant detour, but there is no choice as the timer passes
+	 * only one argument, and various sta_info are needed here, so init
+	 * flow in sta_info_create gives the TID as data, while the timer_to_id
+	 * array gives the sta through container_of */
+	u8 *ptid = (u8 *)data;
+	u8 *timer_to_id = ptid - *ptid;
+	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
+					 timer_to_tid[0]);
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
+#endif
+	ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->addr,
+					 (u16)*ptid, WLAN_BACK_TIMER,
+					 WLAN_REASON_QSTA_TIMEOUT);
+}
+
 static void ieee80211_sta_process_addba_request(struct ieee80211_local *local,
 						struct ieee80211_mgmt *mgmt,
 						size_t len)
@@ -1647,30 +1839,6 @@ timer_expired_exit:
 	rcu_read_unlock();
 }
 
-/*
- * After accepting the AddBA Request we activated a timer,
- * resetting it after each frame that arrives from the originator.
- * if this timer expires ieee80211_sta_stop_rx_ba_session will be executed.
- */
-static void sta_rx_agg_session_timer_expired(unsigned long data)
-{
-	/* not an elegant detour, but there is no choice as the timer passes
-	 * only one argument, and various sta_info are needed here, so init
-	 * flow in sta_info_create gives the TID as data, while the timer_to_id
-	 * array gives the sta through container_of */
-	u8 *ptid = (u8 *)data;
-	u8 *timer_to_id = ptid - *ptid;
-	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
-					 timer_to_tid[0]);
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
-#endif
-	ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->addr,
-					 (u16)*ptid, WLAN_BACK_TIMER,
-					 WLAN_REASON_QSTA_TIMEOUT);
-}
-
 void ieee80211_sta_tear_down_BA_sessions(struct ieee80211_sub_if_data *sdata, u8 *addr)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -1992,308 +2160,111 @@ static void ieee80211_rx_mgmt_assoc_resp
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
-
-		err = sta_info_insert(sta);
-		if (err) {
-			printk(KERN_DEBUG "%s: failed to insert STA entry for"
-			       " the AP (error %d)\n", sdata->dev->name, err);
-			rcu_read_unlock();
-			return;
-		}
-		/* update new sta with its last rx activity */
-		sta->last_rx = jiffies;
-	}
-
-	/*
-	 * FIXME: Do we really need to update the sta_info's information here?
-	 *	  We already know about the AP (we found it in our list) so it
-	 *	  should already be filled with the right info, no?
-	 *	  As is stands, all this is racy because typically we assume
-	 *	  the information that is filled in here (except flags) doesn't
-	 *	  change while a STA structure is alive. As such, it should move
-	 *	  to between the sta_info_alloc() and sta_info_insert() above.
-	 */
-
-	set_sta_flags(sta, WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP |
-			   WLAN_STA_AUTHORIZED);
-
-	rates = 0;
-	basic_rates = 0;
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	for (i = 0; i < elems.supp_rates_len; i++) {
-		int rate = (elems.supp_rates[i] & 0x7f) * 5;
-
-		if (rate > 110)
-			have_higher_than_11mbit = true;
-
-		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate)
-				rates |= BIT(j);
-			if (elems.supp_rates[i] & 0x80)
-				basic_rates |= BIT(j);
-		}
-	}
-
-	for (i = 0; i < elems.ext_supp_rates_len; i++) {
-		int rate = (elems.ext_supp_rates[i] & 0x7f) * 5;
-
-		if (rate > 110)
-			have_higher_than_11mbit = true;
-
-		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate)
-				rates |= BIT(j);
-			if (elems.ext_supp_rates[i] & 0x80)
-				basic_rates |= BIT(j);
-		}
-	}
-
-	sta->supp_rates[local->hw.conf.channel->band] = rates;
-	sdata->basic_rates = basic_rates;
-
-	/* cf. IEEE 802.11 9.2.12 */
-	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
-	    have_higher_than_11mbit)
-		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
-	else
-		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
-
-	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
-	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
-		struct ieee80211_ht_bss_info bss_info;
-		ieee80211_ht_cap_ie_to_ht_info(
-				(struct ieee80211_ht_cap *)
-				elems.ht_cap_elem, &sta->ht_info);
-		ieee80211_ht_addt_info_ie_to_ht_bss_info(
-				(struct ieee80211_ht_addt_info *)
-				elems.ht_info_elem, &bss_info);
-		ieee80211_handle_ht(local, 1, &sta->ht_info, &bss_info);
-	}
-
-	rate_control_rate_init(sta, local);
-
-	if (elems.wmm_param) {
-		set_sta_flags(sta, WLAN_STA_WME);
-		rcu_read_unlock();
-		ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
-					 elems.wmm_param_len);
-	} else
-		rcu_read_unlock();
-
-	/* set AID and assoc capability,
-	 * ieee80211_set_associated() will tell the driver */
-	bss_conf->aid = aid;
-	bss_conf->assoc_capability = capab_info;
-	ieee80211_set_associated(sdata, ifsta);
-
-	ieee80211_associated(sdata, ifsta);
-}
-
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
-
-static struct ieee80211_sta_bss *
-ieee80211_rx_bss_add(struct ieee80211_sub_if_data *sdata, u8 *bssid, int freq,
-		     u8 *ssid, u8 ssid_len)
-{
-	struct ieee80211_local *local = sdata->local;
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
-#ifdef CONFIG_MAC80211_MESH
-static struct ieee80211_sta_bss *
-ieee80211_rx_mesh_bss_get(struct ieee80211_local *local, u8 *mesh_id, int mesh_id_len,
-			  u8 *mesh_cfg, int freq)
-{
-	struct ieee80211_sta_bss *bss;
+		bss = ieee80211_rx_bss_get(local, ifsta->bssid,
+					   local->hw.conf.channel->center_freq,
+					   ifsta->ssid, ifsta->ssid_len);
+		if (bss) {
+			sta->last_signal = bss->signal;
+			sta->last_qual = bss->qual;
+			sta->last_noise = bss->noise;
+			ieee80211_rx_bss_put(local, bss);
+		}
 
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
+		err = sta_info_insert(sta);
+		if (err) {
+			printk(KERN_DEBUG "%s: failed to insert STA entry for"
+			       " the AP (error %d)\n", sdata->dev->name, err);
+			rcu_read_unlock();
+			return;
 		}
-		bss = bss->hnext;
+		/* update new sta with its last rx activity */
+		sta->last_rx = jiffies;
 	}
-	spin_unlock_bh(&local->sta_bss_lock);
-	return bss;
-}
 
-static struct ieee80211_sta_bss *
-ieee80211_rx_mesh_bss_add(struct ieee80211_local *local, u8 *mesh_id, int mesh_id_len,
-			  u8 *mesh_cfg, int mesh_config_len, int freq)
-{
-	struct ieee80211_sta_bss *bss;
+	/*
+	 * FIXME: Do we really need to update the sta_info's information here?
+	 *	  We already know about the AP (we found it in our list) so it
+	 *	  should already be filled with the right info, no?
+	 *	  As is stands, all this is racy because typically we assume
+	 *	  the information that is filled in here (except flags) doesn't
+	 *	  change while a STA structure is alive. As such, it should move
+	 *	  to between the sta_info_alloc() and sta_info_insert() above.
+	 */
 
-	if (mesh_config_len != MESH_CFG_LEN)
-		return NULL;
+	set_sta_flags(sta, WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP |
+			   WLAN_STA_AUTHORIZED);
 
-	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
-	if (!bss)
-		return NULL;
+	rates = 0;
+	basic_rates = 0;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-	bss->mesh_cfg = kmalloc(MESH_CFG_CMP_LEN, GFP_ATOMIC);
-	if (!bss->mesh_cfg) {
-		kfree(bss);
-		return NULL;
-	}
+	for (i = 0; i < elems.supp_rates_len; i++) {
+		int rate = (elems.supp_rates[i] & 0x7f) * 5;
 
-	if (mesh_id_len && mesh_id_len <= IEEE80211_MAX_MESH_ID_LEN) {
-		bss->mesh_id = kmalloc(mesh_id_len, GFP_ATOMIC);
-		if (!bss->mesh_id) {
-			kfree(bss->mesh_cfg);
-			kfree(bss);
-			return NULL;
+		if (rate > 110)
+			have_higher_than_11mbit = true;
+
+		for (j = 0; j < sband->n_bitrates; j++) {
+			if (sband->bitrates[j].bitrate == rate)
+				rates |= BIT(j);
+			if (elems.supp_rates[i] & 0x80)
+				basic_rates |= BIT(j);
 		}
-		memcpy(bss->mesh_id, mesh_id, mesh_id_len);
 	}
 
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
+	for (i = 0; i < elems.ext_supp_rates_len; i++) {
+		int rate = (elems.ext_supp_rates[i] & 0x7f) * 5;
 
+		if (rate > 110)
+			have_higher_than_11mbit = true;
 
-static void ieee80211_rx_bss_put(struct ieee80211_local *local,
-				 struct ieee80211_sta_bss *bss)
-{
-	local_bh_disable();
-	if (!atomic_dec_and_lock(&bss->users, &local->sta_bss_lock)) {
-		local_bh_enable();
-		return;
+		for (j = 0; j < sband->n_bitrates; j++) {
+			if (sband->bitrates[j].bitrate == rate)
+				rates |= BIT(j);
+			if (elems.ext_supp_rates[i] & 0x80)
+				basic_rates |= BIT(j);
+		}
 	}
 
-	__ieee80211_rx_bss_hash_del(local, bss);
-	list_del(&bss->list);
-	spin_unlock_bh(&local->sta_bss_lock);
-	ieee80211_rx_bss_free(bss);
-}
+	sta->supp_rates[local->hw.conf.channel->band] = rates;
+	sdata->basic_rates = basic_rates;
+
+	/* cf. IEEE 802.11 9.2.12 */
+	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
+	    have_higher_than_11mbit)
+		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+	else
+		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
+	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
+	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
+		struct ieee80211_ht_bss_info bss_info;
+		ieee80211_ht_cap_ie_to_ht_info(
+				(struct ieee80211_ht_cap *)
+				elems.ht_cap_elem, &sta->ht_info);
+		ieee80211_ht_addt_info_ie_to_ht_bss_info(
+				(struct ieee80211_ht_addt_info *)
+				elems.ht_info_elem, &bss_info);
+		ieee80211_handle_ht(local, 1, &sta->ht_info, &bss_info);
+	}
 
-void ieee80211_rx_bss_list_init(struct ieee80211_local *local)
-{
-	spin_lock_init(&local->sta_bss_lock);
-	INIT_LIST_HEAD(&local->sta_bss_list);
-}
+	rate_control_rate_init(sta, local);
 
+	if (elems.wmm_param) {
+		set_sta_flags(sta, WLAN_STA_WME);
+		rcu_read_unlock();
+		ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
+					 elems.wmm_param_len);
+	} else
+		rcu_read_unlock();
 
-void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local)
-{
-	struct ieee80211_sta_bss *bss, *tmp;
+	/* set AID and assoc capability,
+	 * ieee80211_set_associated() will tell the driver */
+	bss_conf->aid = aid;
+	bss_conf->assoc_capability = capab_info;
+	ieee80211_set_associated(sdata, ifsta);
 
-	list_for_each_entry_safe(bss, tmp, &local->sta_bss_list, list)
-		ieee80211_rx_bss_put(local, bss);
+	ieee80211_associated(sdata, ifsta);
 }
 
 
@@ -3146,104 +3117,15 @@ void ieee80211_start_mesh(struct ieee802
 
 void ieee80211_sta_timer(unsigned long data)
 {
-	struct ieee80211_sub_if_data *sdata =
-		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct ieee80211_local *local = sdata->local;
-
-	set_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
-	queue_work(local->hw.workqueue, &ifsta->work);
-}
-
-void ieee80211_sta_work(struct work_struct *work)
-{
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.sta.work);
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_sta *ifsta;
-	struct sk_buff *skb;
-
-	if (!netif_running(sdata->dev))
-		return;
-
-	if (local->sta_sw_scanning || local->sta_hw_scanning)
-		return;
-
-	if (WARN_ON(sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-		    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
-		    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT))
-		return;
-	ifsta = &sdata->u.sta;
-
-	while ((skb = skb_dequeue(&ifsta->skb_queue)))
-		ieee80211_sta_rx_queued_mgmt(sdata, skb);
-
-#ifdef CONFIG_MAC80211_MESH
-	if (ifsta->preq_queue_len &&
-	    time_after(jiffies,
-		       ifsta->last_preq + msecs_to_jiffies(ifsta->mshcfg.dot11MeshHWMPpreqMinInterval)))
-		mesh_path_start_discovery(sdata);
-#endif
-
-	if (ifsta->state != IEEE80211_STA_MLME_DIRECT_PROBE &&
-	    ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
-	    ifsta->state != IEEE80211_STA_MLME_ASSOCIATE &&
-	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
-		if (ifsta->scan_ssid_len)
-			ieee80211_sta_start_scan(sdata, ifsta->scan_ssid, ifsta->scan_ssid_len);
-		else
-			ieee80211_sta_start_scan(sdata, NULL, 0);
-		return;
-	}
-
-	if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request)) {
-		if (ieee80211_sta_config_auth(sdata, ifsta))
-			return;
-		clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
-	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request))
-		return;
-
-	switch (ifsta->state) {
-	case IEEE80211_STA_MLME_DISABLED:
-		break;
-	case IEEE80211_STA_MLME_DIRECT_PROBE:
-		ieee80211_direct_probe(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_AUTHENTICATE:
-		ieee80211_authenticate(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_ASSOCIATE:
-		ieee80211_associate(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_ASSOCIATED:
-		ieee80211_associated(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_IBSS_SEARCH:
-		ieee80211_sta_find_ibss(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_IBSS_JOINED:
-		ieee80211_sta_merge_ibss(sdata, ifsta);
-		break;
-#ifdef CONFIG_MAC80211_MESH
-	case IEEE80211_STA_MLME_MESH_UP:
-		ieee80211_mesh_housekeeping(sdata, ifsta);
-		break;
-#endif
-	default:
-		WARN_ON(1);
-		break;
-	}
-
-	if (ieee80211_privacy_mismatch(sdata, ifsta)) {
-		printk(KERN_DEBUG "%s: privacy configuration mismatch and "
-		       "mixed-cell disabled - disassociate\n", sdata->dev->name);
+	struct ieee80211_sub_if_data *sdata =
+		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_local *local = sdata->local;
 
-		ieee80211_set_disassoc(sdata, ifsta, false, true,
-					WLAN_REASON_UNSPECIFIED);
-	}
+	set_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
+	queue_work(local->hw.workqueue, &ifsta->work);
 }
 
-
 static void ieee80211_sta_reset_auth(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_if_sta *ifsta)
 {
@@ -3328,85 +3210,6 @@ static int ieee80211_sta_match_ssid(stru
 	return 0;
 }
 
-static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sta_bss *bss, *selected = NULL;
-	int top_rssi = 0, freq;
-
-	spin_lock_bh(&local->sta_bss_lock);
-	freq = local->oper_channel->center_freq;
-	list_for_each_entry(bss, &local->sta_bss_list, list) {
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
-	spin_unlock_bh(&local->sta_bss_lock);
-
-	if (selected) {
-		ieee80211_set_freq(sdata, selected->freq);
-		if (!(ifsta->flags & IEEE80211_STA_SSID_SET))
-			ieee80211_sta_set_ssid(sdata, selected->ssid,
-					       selected->ssid_len);
-		ieee80211_sta_set_bssid(sdata, selected->bssid);
-		ieee80211_sta_def_wmm_params(sdata, selected, 0);
-
-		/* Send out direct probe if no probe resp was received or
-		 * the one we have is outdated
-		 */
-		if (!selected->last_probe_resp ||
-		    time_after(jiffies, selected->last_probe_resp
-					+ IEEE80211_SCAN_RESULT_EXPIRE))
-			ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
-		else
-			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
-
-		ieee80211_rx_bss_put(local, selected);
-		ieee80211_sta_reset_auth(sdata, ifsta);
-		return 0;
-	} else {
-		if (ifsta->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
-			ifsta->assoc_scan_tries++;
-			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
-				ieee80211_sta_start_scan(sdata, NULL, 0);
-			else
-				ieee80211_sta_start_scan(sdata, ifsta->ssid,
-							 ifsta->ssid_len);
-			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
-			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
-		} else
-			ifsta->state = IEEE80211_STA_MLME_DISABLED;
-	}
-	return -1;
-}
-
-
 static int ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_if_sta *ifsta)
 {
@@ -4274,6 +4077,85 @@ struct sta_info *ieee80211_ibss_add_sta(
 }
 
 
+static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_if_sta *ifsta)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sta_bss *bss, *selected = NULL;
+	int top_rssi = 0, freq;
+
+	spin_lock_bh(&local->sta_bss_lock);
+	freq = local->oper_channel->center_freq;
+	list_for_each_entry(bss, &local->sta_bss_list, list) {
+		if (!(bss->capability & WLAN_CAPABILITY_ESS))
+			continue;
+
+		if ((ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
+			IEEE80211_STA_AUTO_BSSID_SEL |
+			IEEE80211_STA_AUTO_CHANNEL_SEL)) &&
+		    (!!(bss->capability & WLAN_CAPABILITY_PRIVACY) ^
+		     !!sdata->default_key))
+			continue;
+
+		if (!(ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL) &&
+		    bss->freq != freq)
+			continue;
+
+		if (!(ifsta->flags & IEEE80211_STA_AUTO_BSSID_SEL) &&
+		    memcmp(bss->bssid, ifsta->bssid, ETH_ALEN))
+			continue;
+
+		if (!(ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL) &&
+		    !ieee80211_sta_match_ssid(ifsta, bss->ssid, bss->ssid_len))
+			continue;
+
+		if (!selected || top_rssi < bss->signal) {
+			selected = bss;
+			top_rssi = bss->signal;
+		}
+	}
+	if (selected)
+		atomic_inc(&selected->users);
+	spin_unlock_bh(&local->sta_bss_lock);
+
+	if (selected) {
+		ieee80211_set_freq(sdata, selected->freq);
+		if (!(ifsta->flags & IEEE80211_STA_SSID_SET))
+			ieee80211_sta_set_ssid(sdata, selected->ssid,
+					       selected->ssid_len);
+		ieee80211_sta_set_bssid(sdata, selected->bssid);
+		ieee80211_sta_def_wmm_params(sdata, selected, 0);
+
+		/* Send out direct probe if no probe resp was received or
+		 * the one we have is outdated
+		 */
+		if (!selected->last_probe_resp ||
+		    time_after(jiffies, selected->last_probe_resp
+					+ IEEE80211_SCAN_RESULT_EXPIRE))
+			ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
+		else
+			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
+
+		ieee80211_rx_bss_put(local, selected);
+		ieee80211_sta_reset_auth(sdata, ifsta);
+		return 0;
+	} else {
+		if (ifsta->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
+			ifsta->assoc_scan_tries++;
+			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
+				ieee80211_sta_start_scan(sdata, NULL, 0);
+			else
+				ieee80211_sta_start_scan(sdata, ifsta->ssid,
+							 ifsta->ssid_len);
+			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
+			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
+		} else
+			ifsta->state = IEEE80211_STA_MLME_DISABLED;
+	}
+	return -1;
+}
+
+
 int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata, u16 reason)
 {
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
@@ -4327,3 +4209,91 @@ void ieee80211_notify_mac(struct ieee802
 	}
 }
 EXPORT_SYMBOL(ieee80211_notify_mac);
+
+void ieee80211_sta_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data, u.sta.work);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_sta *ifsta;
+	struct sk_buff *skb;
+
+	if (!netif_running(sdata->dev))
+		return;
+
+	if (local->sta_sw_scanning || local->sta_hw_scanning)
+		return;
+
+	if (WARN_ON(sdata->vif.type != IEEE80211_IF_TYPE_STA &&
+		    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+		    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT))
+		return;
+	ifsta = &sdata->u.sta;
+
+	while ((skb = skb_dequeue(&ifsta->skb_queue)))
+		ieee80211_sta_rx_queued_mgmt(sdata, skb);
+
+#ifdef CONFIG_MAC80211_MESH
+	if (ifsta->preq_queue_len &&
+	    time_after(jiffies,
+		       ifsta->last_preq + msecs_to_jiffies(ifsta->mshcfg.dot11MeshHWMPpreqMinInterval)))
+		mesh_path_start_discovery(sdata);
+#endif
+
+	if (ifsta->state != IEEE80211_STA_MLME_DIRECT_PROBE &&
+	    ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
+	    ifsta->state != IEEE80211_STA_MLME_ASSOCIATE &&
+	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
+		if (ifsta->scan_ssid_len)
+			ieee80211_sta_start_scan(sdata, ifsta->scan_ssid, ifsta->scan_ssid_len);
+		else
+			ieee80211_sta_start_scan(sdata, NULL, 0);
+		return;
+	}
+
+	if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request)) {
+		if (ieee80211_sta_config_auth(sdata, ifsta))
+			return;
+		clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
+	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request))
+		return;
+
+	switch (ifsta->state) {
+	case IEEE80211_STA_MLME_DISABLED:
+		break;
+	case IEEE80211_STA_MLME_DIRECT_PROBE:
+		ieee80211_direct_probe(sdata, ifsta);
+		break;
+	case IEEE80211_STA_MLME_AUTHENTICATE:
+		ieee80211_authenticate(sdata, ifsta);
+		break;
+	case IEEE80211_STA_MLME_ASSOCIATE:
+		ieee80211_associate(sdata, ifsta);
+		break;
+	case IEEE80211_STA_MLME_ASSOCIATED:
+		ieee80211_associated(sdata, ifsta);
+		break;
+	case IEEE80211_STA_MLME_IBSS_SEARCH:
+		ieee80211_sta_find_ibss(sdata, ifsta);
+		break;
+	case IEEE80211_STA_MLME_IBSS_JOINED:
+		ieee80211_sta_merge_ibss(sdata, ifsta);
+		break;
+#ifdef CONFIG_MAC80211_MESH
+	case IEEE80211_STA_MLME_MESH_UP:
+		ieee80211_mesh_housekeeping(sdata, ifsta);
+		break;
+#endif
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	if (ieee80211_privacy_mismatch(sdata, ifsta)) {
+		printk(KERN_DEBUG "%s: privacy configuration mismatch and "
+		       "mixed-cell disabled - disassociate\n", sdata->dev->name);
+
+		ieee80211_set_disassoc(sdata, ifsta, false, true,
+					WLAN_REASON_UNSPECIFIED);
+	}
+}

-- 

