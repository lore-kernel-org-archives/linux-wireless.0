Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [116.90.133.99] ([116.90.133.99]:38094 "EHLO mars.unix.geek.nz"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYHCAE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 20:04:29 -0400
Received: from [192.168.68.2] (unknown [202.6.117.130])
	(Authenticated sender: jasper)
	by mars.unix.geek.nz (Postfix) with ESMTPSA id 505EC13B83A
	for <linux-wireless@vger.kernel.org>; Sun,  3 Aug 2008 12:04:25 +1200 (NZST)
Subject: [PATCH] replace net_device arguments with
	ieee80211_{local,sub_if_data} as appropriate
From: Jasper Bryant-Greene <jasper@amiton.co.nz>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sun, 03 Aug 2008 12:04:37 +1200
Message-Id: <1217721877.14226.12.camel@luna.unix.geek.nz> (sfid-20080803_020445_938315_49AA8B69)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces net_device arguments to mac80211 internal functions
with ieee80211_{local,sub_if_data} as appropriate.

It also does the same for many 802.11s mesh functions, and changes the
mesh path table to be indexed on sub_if_data rather than net_device.

If the mesh part needs to be a separate patch let me know, but since
mesh uses a lot of mac80211 functions which were being converted anyway,
the changes go hand-in-hand somewhat.

This patch probably does not convert all the functions which could be
converted, but it is a large chunk and followup patches will be
provided.

Signed-off-by: Jasper Bryant-Greene <jasper@amiton.co.nz>
---

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 297c257..6d2ad2b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -66,13 +66,16 @@ static int ieee80211_add_iface(struct wiphy *wiphy,
char *name,
 static int ieee80211_del_iface(struct wiphy *wiphy, int ifindex)
 {
 	struct net_device *dev;
+	struct ieee80211_sub_if_data *sdata;
 
 	/* we're under RTNL */
 	dev = __dev_get_by_index(&init_net, ifindex);
 	if (!dev)
 		return -ENODEV;
 
-	ieee80211_if_remove(dev);
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	ieee80211_if_remove(sdata);
 
 	return 0;
 }
@@ -842,13 +845,13 @@ static int ieee80211_add_mpath(struct wiphy
*wiphy, struct net_device *dev,
 		return -ENOENT;
 	}
 
-	err = mesh_path_add(dst, dev);
+	err = mesh_path_add(dst, sdata);
 	if (err) {
 		rcu_read_unlock();
 		return err;
 	}
 
-	mpath = mesh_path_lookup(dst, dev);
+	mpath = mesh_path_lookup(dst, sdata);
 	if (!mpath) {
 		rcu_read_unlock();
 		return -ENXIO;
@@ -862,10 +865,12 @@ static int ieee80211_add_mpath(struct wiphy
*wiphy, struct net_device *dev,
 static int ieee80211_del_mpath(struct wiphy *wiphy, struct net_device
*dev,
 				 u8 *dst)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (dst)
-		return mesh_path_del(dst, dev);
+		return mesh_path_del(dst, sdata);
 
-	mesh_path_flush(dev);
+	mesh_path_flush(sdata);
 	return 0;
 }
 
@@ -897,7 +902,7 @@ static int ieee80211_change_mpath(struct wiphy
*wiphy,
 		return -ENOENT;
 	}
 
-	mpath = mesh_path_lookup(dst, dev);
+	mpath = mesh_path_lookup(dst, sdata);
 	if (!mpath) {
 		rcu_read_unlock();
 		return -ENOENT;
@@ -965,7 +970,7 @@ static int ieee80211_get_mpath(struct wiphy *wiphy,
struct net_device *dev,
 		return -ENOTSUPP;
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(dst, dev);
+	mpath = mesh_path_lookup(dst, sdata);
 	if (!mpath) {
 		rcu_read_unlock();
 		return -ENOENT;
@@ -993,7 +998,7 @@ static int ieee80211_dump_mpath(struct wiphy *wiphy,
struct net_device *dev,
 		return -ENOTSUPP;
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup_by_idx(idx, dev);
+	mpath = mesh_path_lookup_by_idx(idx, sdata);
 	if (!mpath) {
 		rcu_read_unlock();
 		return -ENOENT;
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 79a0627..6abe542 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -201,7 +201,7 @@ static ssize_t sta_agg_status_write(struct file
*file,
 		tid_num = tid_num - 100;
 		if (tid_static_rx[tid_num] == 1) {
 			strcpy(state, "off ");
-			ieee80211_sta_stop_rx_ba_session(dev, da, tid_num, 0,
+			ieee80211_sta_stop_rx_ba_session(sta->sdata, da, tid_num, 0,
 					WLAN_REASON_QSTA_REQUIRE_SETUP);
 			sta->ampdu_mlme.tid_state_rx[tid_num] |=
 					HT_AGG_STATE_DEBUGFS_CTL;
diff --git a/net/mac80211/event.c b/net/mac80211/event.c
index 2280f40..8de60de 100644
--- a/net/mac80211/event.c
+++ b/net/mac80211/event.c
@@ -8,7 +8,6 @@
  * mac80211 - events
  */
 
-#include <linux/netdevice.h>
 #include <net/iw_handler.h>
 #include "ieee80211_i.h"
 
@@ -17,7 +16,7 @@
  * (in the variable hdr) must be long enough to extract the TKIP
  * fields like TSC
  */
-void mac80211_ev_michael_mic_failure(struct net_device *dev, int
keyidx,
+void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data
*sdata, int keyidx,
 				     struct ieee80211_hdr *hdr)
 {
 	union iwreq_data wrqu;
@@ -32,7 +31,7 @@ void mac80211_ev_michael_mic_failure(struct net_device
*dev, int keyidx,
 			print_mac(mac, hdr->addr2));
 		memset(&wrqu, 0, sizeof(wrqu));
 		wrqu.data.length = strlen(buf);
-		wireless_send_event(dev, IWEVCUSTOM, &wrqu, buf);
+		wireless_send_event(sdata->dev, IWEVCUSTOM, &wrqu, buf);
 		kfree(buf);
 	}
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a4f9a83..1d0be3b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -857,65 +857,65 @@ u32 ieee80211_handle_ht(struct ieee80211_local
*local, int enable_ht,
 
 /* ieee80211_ioctl.c */
 extern const struct iw_handler_def ieee80211_iw_handler_def;
-int ieee80211_set_freq(struct net_device *dev, int freq);
+int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
 
 /* ieee80211_sta.c */
 void ieee80211_sta_timer(unsigned long data);
 void ieee80211_sta_work(struct work_struct *work);
 void ieee80211_sta_scan_work(struct work_struct *work);
-void ieee80211_sta_rx_mgmt(struct net_device *dev, struct sk_buff *skb,
+void ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct
sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status);
-int ieee80211_sta_set_ssid(struct net_device *dev, char *ssid, size_t
len);
-int ieee80211_sta_get_ssid(struct net_device *dev, char *ssid, size_t
*len);
-int ieee80211_sta_set_bssid(struct net_device *dev, u8 *bssid);
-int ieee80211_sta_req_scan(struct net_device *dev, u8 *ssid, size_t
ssid_len);
-void ieee80211_sta_req_auth(struct net_device *dev,
+int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char
*ssid, size_t len);
+int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char
*ssid, size_t *len);
+int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8
*bssid);
+int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8
*ssid, size_t ssid_len);
+void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_if_sta *ifsta);
-int ieee80211_sta_scan_results(struct net_device *dev,
+int ieee80211_sta_scan_results(struct ieee80211_local *local,
 			       struct iw_request_info *info,
 			       char *buf, size_t len);
 ieee80211_rx_result ieee80211_sta_rx_scan(
-	struct net_device *dev, struct sk_buff *skb,
+	struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 	struct ieee80211_rx_status *rx_status);
 void ieee80211_rx_bss_list_init(struct ieee80211_local *local);
 void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local);
-int ieee80211_sta_set_extra_ie(struct net_device *dev, char *ie, size_t
len);
-struct sta_info *ieee80211_ibss_add_sta(struct net_device *dev,
+int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata,
char *ie, size_t len);
+struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data
*sdata,
 					struct sk_buff *skb, u8 *bssid,
 					u8 *addr, u64 supp_rates);
-int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
-int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
+int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata,
u16 reason);
+int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16
reason);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data
*sdata,
 				      u32 changed);
-u32 ieee80211_reset_erp_info(struct net_device *dev);
+u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
 				   struct ieee80211_ht_info *ht_info);
 int ieee80211_ht_addt_info_ie_to_ht_bss_info(
 			struct ieee80211_ht_addt_info *ht_add_info_ie,
 			struct ieee80211_ht_bss_info *bss_info);
-void ieee80211_send_addba_request(struct net_device *dev, const u8 *da,
+void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
const u8 *da,
 				  u16 tid, u8 dialog_token, u16 start_seq_num,
 				  u16 agg_size, u16 timeout);
-void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16
tid,
+void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata, const u8
*da, u16 tid,
 				u16 initiator, u16 reason_code);
-void ieee80211_send_bar(struct net_device *dev, u8 *ra, u16 tid, u16
ssn);
+void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra,
u16 tid, u16 ssn);
 
-void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *da,
+void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data
*sdata, u8 *da,
 				u16 tid, u16 initiator, u16 reason);
 void sta_addba_resp_timer_expired(unsigned long data);
-void ieee80211_sta_tear_down_BA_sessions(struct net_device *dev, u8
*addr);
+void ieee80211_sta_tear_down_BA_sessions(struct ieee80211_sub_if_data
*sdata, u8 *addr);
 u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
-void ieee80211_sta_tx(struct net_device *dev, struct sk_buff *skb,
+void ieee80211_sta_tx(struct ieee80211_sub_if_data *sdata, struct
sk_buff *skb,
 		int encrypt);
 void ieee802_11_parse_elems(u8 *start, size_t len,
 				   struct ieee802_11_elems *elems);
 
 #ifdef CONFIG_MAC80211_MESH
-void ieee80211_start_mesh(struct net_device *dev);
+void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 #else
-static inline void ieee80211_start_mesh(struct net_device *dev)
+static inline void ieee80211_start_mesh(struct ieee80211_sub_if_data
*sdata)
 {}
 #endif
 
@@ -926,7 +926,7 @@ int ieee80211_if_add(struct ieee80211_local *local,
const char *name,
 		     struct vif_params *params);
 int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum ieee80211_if_types type);
-void ieee80211_if_remove(struct net_device *dev);
+void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
 void ieee80211_remove_interfaces(struct ieee80211_local *local);
 
 /* tx handling */
@@ -944,7 +944,7 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr,
size_t len,
 			enum ieee80211_if_types type);
 int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble);
-void mac80211_ev_michael_mic_failure(struct net_device *dev, int
keyidx,
+void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data
*sdata, int keyidx,
 				     struct ieee80211_hdr *hdr);
 
 #ifdef CONFIG_MAC80211_NOINLINE
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 610ed1d..4a623b8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -56,7 +56,7 @@ static void ieee80211_teardown_sdata(struct net_device
*dev)
 	case IEEE80211_IF_TYPE_MESH_POINT:
 		/* Allow compiler to elide mesh_rmc_free call. */
 		if (ieee80211_vif_is_mesh(&sdata->vif))
-			mesh_rmc_free(dev);
+			mesh_rmc_free(sdata);
 		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
@@ -241,15 +241,13 @@ int ieee80211_if_add(struct ieee80211_local
*local, const char *name,
 	return ret;
 }
 
-void ieee80211_if_remove(struct net_device *dev)
+void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
 	ASSERT_RTNL();
 
 	list_del_rcu(&sdata->list);
 	synchronize_rcu();
-	unregister_netdevice(dev);
+	unregister_netdevice(sdata->dev);
 }
 
 /*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a4c5b90..f259e41 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -308,8 +308,8 @@ static int ieee80211_open(struct net_device *dev)
 			goto err_stop;
 
 		if (ieee80211_vif_is_mesh(&sdata->vif))
-			ieee80211_start_mesh(sdata->dev);
-		changed |= ieee80211_reset_erp_info(dev);
+			ieee80211_start_mesh(sdata);
+		changed |= ieee80211_reset_erp_info(sdata);
 		ieee80211_bss_info_change_notify(sdata, changed);
 		ieee80211_enable_keys(sdata);
 
@@ -409,7 +409,7 @@ static int ieee80211_stop(struct net_device *dev)
 
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		if (sta->sdata == sdata)
-			ieee80211_sta_tear_down_BA_sessions(dev, sta->addr);
+			ieee80211_sta_tear_down_BA_sessions(sdata, sta->addr);
 	}
 
 	rcu_read_unlock();
@@ -664,7 +664,7 @@ int ieee80211_start_tx_ba_session(struct
ieee80211_hw *hw, u8 *ra, u16 tid)
 	sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
 
 
-	ieee80211_send_addba_request(sta->sdata->dev, ra, tid,
+	ieee80211_send_addba_request(sta->sdata, ra, tid,
 			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
 			 sta->ampdu_mlme.tid_tx[tid]->ssn,
 			 0x40, 5000);
@@ -847,7 +847,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw
*hw, u8 *ra, u8 tid)
 	}
 
 	if (*state & HT_AGG_STATE_INITIATOR_MSK)
-		ieee80211_send_delba(sta->sdata->dev, ra, tid,
+		ieee80211_send_delba(sta->sdata, ra, tid,
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
 
 	agg_queue = sta->tid_to_tx_q[tid];
@@ -1156,10 +1156,8 @@ void ieee80211_bss_info_change_notify(struct
ieee80211_sub_if_data *sdata,
 					     changed);
 }
 
-u32 ieee80211_reset_erp_info(struct net_device *dev)
+u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
 	sdata->bss_conf.use_cts_prot = 0;
 	sdata->bss_conf.use_short_preamble = 0;
 	return BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_ERP_PREAMBLE;
@@ -1397,7 +1395,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,
struct sk_buff *skb)
 			tid = qc[0] & 0xf;
 			ssn = ((le16_to_cpu(hdr->seq_ctrl) + 0x10)
 						& IEEE80211_SCTL_SEQ);
-			ieee80211_send_bar(sta->sdata->dev, hdr->addr1,
+			ieee80211_send_bar(sta->sdata, hdr->addr1,
 					   tid, ssn);
 		}
 	}
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b5933b2..b631703 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -39,14 +39,13 @@ void ieee80211s_stop(void)
  * mesh_matches_local - check if the config of a mesh point matches
ours
  *
  * @ie: information elements of a management frame from the mesh peer
- * @dev: local mesh interface
+ * @sdata: local mesh subif
  *
  * This function checks if the mesh configuration of a mesh point
matches the
  * local mesh configuration, i.e. if both nodes belong to the same mesh
network.
  */
-bool mesh_matches_local(struct ieee802_11_elems *ie, struct net_device
*dev)
+bool mesh_matches_local(struct ieee802_11_elems *ie, struct
ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *sta = &sdata->u.sta;
 
 	/*
@@ -73,10 +72,8 @@ bool mesh_matches_local(struct ieee802_11_elems *ie,
struct net_device *dev)
  * mesh_peer_accepts_plinks - check if an mp is willing to establish
peer links
  *
  * @ie: information elements of a management frame from the mesh peer
- * @dev: local mesh interface
  */
-bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie,
-			      struct net_device *dev)
+bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie)
 {
 	return (*(ie->mesh_config + CAPAB_OFFSET) & ACCEPT_PLINKS) != 0;
 }
@@ -111,9 +108,8 @@ void mesh_ids_set_default(struct ieee80211_if_sta
*sta)
 	memcpy(sta->mesh_cc_id, def_id, 4);
 }
 
-int mesh_rmc_init(struct net_device *dev)
+int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int i;
 
 	sdata->u.sta.rmc = kmalloc(sizeof(struct mesh_rmc), GFP_KERNEL);
@@ -125,9 +121,8 @@ int mesh_rmc_init(struct net_device *dev)
 	return 0;
 }
 
-void mesh_rmc_free(struct net_device *dev)
+void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mesh_rmc *rmc = sdata->u.sta.rmc;
 	struct rmc_entry *p, *n;
 	int i;
@@ -158,9 +153,8 @@ void mesh_rmc_free(struct net_device *dev)
  * it.
  */
 int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
-		   struct net_device *dev)
+		   struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mesh_rmc *rmc = sdata->u.sta.rmc;
 	u32 seqnum = 0;
 	int entries = 0;
@@ -194,10 +188,9 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr
*mesh_hdr,
 	return 0;
 }
 
-void mesh_mgmt_ies_add(struct sk_buff *skb, struct net_device *dev)
+void mesh_mgmt_ies_add(struct sk_buff *skb, struct
ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
 	int len, i, rate;
@@ -262,10 +255,10 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct
net_device *dev)
 	return;
 }
 
-u32 mesh_table_hash(u8 *addr, struct net_device *dev, struct mesh_table
*tbl)
+u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata,
struct mesh_table *tbl)
 {
 	/* Use last four bytes of hw addr and interface index as hash index */
-	return jhash_2words(*(u32 *)(addr+2), dev->ifindex, tbl->hash_rnd)
+	return jhash_2words(*(u32 *)(addr+2), sdata->dev->ifindex,
tbl->hash_rnd)
 		& tbl->hash_mask;
 }
 
@@ -434,7 +427,7 @@ void ieee80211_mesh_init_sdata(struct
ieee80211_sub_if_data *sdata)
 	ifsta->preq_id = 0;
 	ifsta->dsn = 0;
 	atomic_set(&ifsta->mpaths, 0);
-	mesh_rmc_init(sdata->dev);
+	mesh_rmc_init(sdata);
 	ifsta->last_preq = jiffies;
 	/* Allocate all mesh structures when creating the first mesh
interface. */
 	if (!mesh_allocated)
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 669eafa..bd95b1e 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -47,7 +47,7 @@ enum mesh_path_flags {
  * struct mesh_path - mac80211 mesh path structure
  *
  * @dst: mesh path destination mac address
- * @dev: mesh path device
+ * @sdata: mesh subif
  * @next_hop: mesh neighbor to which frames for this destination will
be
  * 	forwarded
  * @timer: mesh path discovery timer
@@ -64,14 +64,14 @@ enum mesh_path_flags {
  * @state_lock: mesh pat state lock
  *
  *
- * The combination of dst and dev is unique in the mesh path table.
Since the
+ * The combination of dst and sdata is unique in the mesh path table.
Since the
  * next_hop STA is only protected by RCU as well, deleting the STA must
also
  * remove/substitute the mesh_path structure and wait until that is no
longer
  * reachable before destroying the STA completely.
  */
 struct mesh_path {
 	u8 dst[ETH_ALEN];
-	struct net_device *dev;
+	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *next_hop;
 	struct timer_list timer;
 	struct sk_buff_head frame_queue;
@@ -203,40 +203,39 @@ int ieee80211_get_mesh_hdrlen(struct
ieee80211s_hdr *meshhdr);
 int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 		struct ieee80211_sub_if_data *sdata);
 int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
-		struct net_device *dev);
-bool mesh_matches_local(struct ieee802_11_elems *ie, struct net_device
*dev);
+		struct ieee80211_sub_if_data *sdata);
+bool mesh_matches_local(struct ieee802_11_elems *ie, struct
ieee80211_sub_if_data *sdata);
 void mesh_ids_set_default(struct ieee80211_if_sta *sta);
-void mesh_mgmt_ies_add(struct sk_buff *skb, struct net_device *dev);
-void mesh_rmc_free(struct net_device *dev);
-int mesh_rmc_init(struct net_device *dev);
+void mesh_mgmt_ies_add(struct sk_buff *skb, struct
ieee80211_sub_if_data *sdata);
+void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
+int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_init(void);
 void ieee80211s_stop(void);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(u8 *next_hop, struct sk_buff *skb,
-		struct net_device *dev);
-void mesh_path_start_discovery(struct net_device *dev);
-struct mesh_path *mesh_path_lookup(u8 *dst, struct net_device *dev);
-struct mesh_path *mesh_path_lookup_by_idx(int idx, struct net_device
*dev);
+		struct ieee80211_sub_if_data *sdata);
+void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
+struct mesh_path *mesh_path_lookup(u8 *dst, struct
ieee80211_sub_if_data *sdata);
+struct mesh_path *mesh_path_lookup_by_idx(int idx, struct
ieee80211_sub_if_data *sdata);
 void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info
*next_hop);
-void mesh_path_expire(struct net_device *dev);
-void mesh_path_flush(struct net_device *dev);
-void mesh_rx_path_sel_frame(struct net_device *dev, struct
ieee80211_mgmt *mgmt,
+void mesh_path_expire(struct ieee80211_sub_if_data *sdata);
+void mesh_path_flush(struct ieee80211_sub_if_data *sdata);
+void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata, struct
ieee80211_mgmt *mgmt,
 		size_t len);
-int mesh_path_add(u8 *dst, struct net_device *dev);
+int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata);
 /* Mesh plinks */
-void mesh_neighbour_update(u8 *hw_addr, u64 rates, struct net_device
*dev,
+void mesh_neighbour_update(u8 *hw_addr, u64 rates, struct
ieee80211_sub_if_data *sdata,
 		bool add);
-bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie,
-			      struct net_device *dev);
+bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
 void mesh_plink_deactivate(struct sta_info *sta);
 int mesh_plink_open(struct sta_info *sta);
 int mesh_plink_close(struct sta_info *sta);
 void mesh_plink_block(struct sta_info *sta);
-void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt
*mgmt,
+void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct
ieee80211_mgmt *mgmt,
 			 size_t len, struct ieee80211_rx_status *rx_status);
 
 /* Private interfaces */
@@ -244,19 +243,19 @@ void mesh_rx_plink_frame(struct net_device *dev,
struct ieee80211_mgmt *mgmt,
 struct mesh_table *mesh_table_alloc(int size_order);
 void mesh_table_free(struct mesh_table *tbl, bool free_leafs);
 struct mesh_table *mesh_table_grow(struct mesh_table *tbl);
-u32 mesh_table_hash(u8 *addr, struct net_device *dev, struct mesh_table
*tbl);
+u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata,
struct mesh_table *tbl);
 /* Mesh paths */
 int mesh_path_error_tx(u8 *dest, __le32 dest_dsn, u8 *ra,
-		struct net_device *dev);
+		struct ieee80211_sub_if_data *sdata);
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info
*sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
 int mesh_pathtbl_init(void);
 void mesh_pathtbl_unregister(void);
-int mesh_path_del(u8 *addr, struct net_device *dev);
+int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata);
 void mesh_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
-void mesh_path_discard_frame(struct sk_buff *skb, struct net_device
*dev);
+void mesh_path_discard_frame(struct sk_buff *skb, struct
ieee80211_sub_if_data *sdata);
 
 #ifdef CONFIG_MAC80211_MESH
 extern int mesh_allocated;
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 7fa149e..33a2fbd 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -82,9 +82,9 @@ enum mpath_frame_type {
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8
flags,
 		u8 *orig_addr, __le32 orig_dsn, u8 dst_flags, u8 *dst,
 		__le32 dst_dsn, u8 *da, u8 hop_count, u8 ttl, __le32 lifetime,
-		__le32 metric, __le32 preq_id, struct net_device *dev)
+		__le32 metric, __le32 preq_id, struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom +
400);
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
@@ -103,7 +103,7 @@ static int mesh_path_sel_frame_tx(enum
mpath_frame_type action, u8 flags,
 					   IEEE80211_STYPE_ACTION);
 
 	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
 	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
 	mgmt->u.action.u.mesh_action.action_code = action;
@@ -149,7 +149,7 @@ static int mesh_path_sel_frame_tx(enum
mpath_frame_type action, u8 flags,
 	pos += ETH_ALEN;
 	memcpy(pos, &dst_dsn, 4);
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 	return 0;
 }
 
@@ -161,9 +161,9 @@ static int mesh_path_sel_frame_tx(enum
mpath_frame_type action, u8 flags,
  * @ra: node this frame is addressed to
  */
 int mesh_path_error_tx(u8 *dst, __le32 dst_dsn, u8 *ra,
-		struct net_device *dev)
+		struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom +
400);
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
@@ -182,7 +182,7 @@ int mesh_path_error_tx(u8 *dst, __le32 dst_dsn, u8
*ra,
 					   IEEE80211_STYPE_ACTION);
 
 	memcpy(mgmt->da, ra, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
 	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
 	mgmt->u.action.u.mesh_action.action_code = MPATH_PERR;
@@ -198,7 +198,7 @@ int mesh_path_error_tx(u8 *dst, __le32 dst_dsn, u8
*ra,
 	pos += ETH_ALEN;
 	memcpy(pos, &dst_dsn, 4);
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 	return 0;
 }
 
@@ -233,7 +233,7 @@ static u32 airtime_link_metric_get(struct
ieee80211_local *local,
 /**
  * hwmp_route_info_get - Update routing info to originator and
transmitter
  *
- * @dev: local mesh interface
+ * @sdata: local mesh subif
  * @mgmt: mesh management frame
  * @hwmp_ie: hwmp information element (PREP or PREQ)
  *
@@ -246,11 +246,11 @@ static u32 airtime_link_metric_get(struct
ieee80211_local *local,
  * Notes: this function is the only place (besides user-provided info)
where
  * path routing information is updated.
  */
-static u32 hwmp_route_info_get(struct net_device *dev,
+static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_mgmt *mgmt,
 			    u8 *hwmp_ie)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 	bool fresh_info;
@@ -301,14 +301,14 @@ static u32 hwmp_route_info_get(struct net_device
*dev,
 		new_metric = MAX_METRIC;
 	exp_time = TU_TO_EXP_TIME(orig_lifetime);
 
-	if (memcmp(orig_addr, dev->dev_addr, ETH_ALEN) == 0) {
+	if (memcmp(orig_addr, sdata->dev->dev_addr, ETH_ALEN) == 0) {
 		/* This MP is the originator, we are not interested in this
 		 * frame, except for updating transmitter's path info.
 		 */
 		process = false;
 		fresh_info = false;
 	} else {
-		mpath = mesh_path_lookup(orig_addr, dev);
+		mpath = mesh_path_lookup(orig_addr, sdata);
 		if (mpath) {
 			spin_lock_bh(&mpath->state_lock);
 			if (mpath->flags & MESH_PATH_FIXED)
@@ -324,8 +324,8 @@ static u32 hwmp_route_info_get(struct net_device
*dev,
 				}
 			}
 		} else {
-			mesh_path_add(orig_addr, dev);
-			mpath = mesh_path_lookup(orig_addr, dev);
+			mesh_path_add(orig_addr, sdata);
+			mpath = mesh_path_lookup(orig_addr, sdata);
 			if (!mpath) {
 				rcu_read_unlock();
 				return 0;
@@ -357,7 +357,7 @@ static u32 hwmp_route_info_get(struct net_device
*dev,
 	else {
 		fresh_info = true;
 
-		mpath = mesh_path_lookup(ta, dev);
+		mpath = mesh_path_lookup(ta, sdata);
 		if (mpath) {
 			spin_lock_bh(&mpath->state_lock);
 			if ((mpath->flags & MESH_PATH_FIXED) ||
@@ -365,8 +365,8 @@ static u32 hwmp_route_info_get(struct net_device
*dev,
 					(last_hop_metric > mpath->metric)))
 				fresh_info = false;
 		} else {
-			mesh_path_add(ta, dev);
-			mpath = mesh_path_lookup(ta, dev);
+			mesh_path_add(ta, sdata);
+			mpath = mesh_path_lookup(ta, sdata);
 			if (!mpath) {
 				rcu_read_unlock();
 				return 0;
@@ -392,10 +392,9 @@ static u32 hwmp_route_info_get(struct net_device
*dev,
 	return process ? new_metric : 0;
 }
 
-static void hwmp_preq_frame_process(struct net_device *dev,
+static void hwmp_preq_frame_process(struct ieee80211_sub_if_data
*sdata,
 				    struct ieee80211_mgmt *mgmt,
 				    u8 *preq_elem, u32 metric) {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct mesh_path *mpath;
 	u8 *dst_addr, *orig_addr;
@@ -411,7 +410,7 @@ static void hwmp_preq_frame_process(struct
net_device *dev,
 	orig_dsn = PREQ_IE_ORIG_DSN(preq_elem);
 	dst_flags = PREQ_IE_DST_F(preq_elem);
 
-	if (memcmp(dst_addr, dev->dev_addr, ETH_ALEN) == 0) {
+	if (memcmp(dst_addr, sdata->dev->dev_addr, ETH_ALEN) == 0) {
 		forward = false;
 		reply = true;
 		metric = 0;
@@ -423,7 +422,7 @@ static void hwmp_preq_frame_process(struct
net_device *dev,
 		}
 	} else {
 		rcu_read_lock();
-		mpath = mesh_path_lookup(dst_addr, dev);
+		mpath = mesh_path_lookup(dst_addr, sdata);
 		if (mpath) {
 			if ((!(mpath->flags & MESH_PATH_DSN_VALID)) ||
 					DSN_LT(mpath->dsn, dst_dsn)) {
@@ -451,7 +450,7 @@ static void hwmp_preq_frame_process(struct
net_device *dev,
 				cpu_to_le32(dst_dsn), 0, orig_addr,
 				cpu_to_le32(orig_dsn), mgmt->sa, 0, ttl,
 				cpu_to_le32(lifetime), cpu_to_le32(metric),
-				0, dev);
+				0, sdata);
 		else
 			ifsta->mshstats.dropped_frames_ttl++;
 	}
@@ -472,20 +471,19 @@ static void hwmp_preq_frame_process(struct
net_device *dev,
 		hopcount = PREQ_IE_HOPCOUNT(preq_elem) + 1;
 		mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
 				cpu_to_le32(orig_dsn), dst_flags, dst_addr,
-				cpu_to_le32(dst_dsn), dev->broadcast,
+				cpu_to_le32(dst_dsn), sdata->dev->broadcast,
 				hopcount, ttl, cpu_to_le32(lifetime),
 				cpu_to_le32(metric), cpu_to_le32(preq_id),
-				dev);
+				sdata);
 		ifsta->mshstats.fwded_frames++;
 	}
 }
 
 
-static void hwmp_prep_frame_process(struct net_device *dev,
+static void hwmp_prep_frame_process(struct ieee80211_sub_if_data
*sdata,
 				    struct ieee80211_mgmt *mgmt,
 				    u8 *prep_elem, u32 metric)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mesh_path *mpath;
 	u8 *dst_addr, *orig_addr;
 	u8 ttl, hopcount, flags;
@@ -499,7 +497,7 @@ static void hwmp_prep_frame_process(struct
net_device *dev,
 	 * replies
 	 */
 	dst_addr = PREP_IE_DST_ADDR(prep_elem);
-	if (memcmp(dst_addr, dev->dev_addr, ETH_ALEN) == 0)
+	if (memcmp(dst_addr, sdata->dev->dev_addr, ETH_ALEN) == 0)
 		/* destination, no forwarding required */
 		return;
 
@@ -510,7 +508,7 @@ static void hwmp_prep_frame_process(struct
net_device *dev,
 	}
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(dst_addr, dev);
+	mpath = mesh_path_lookup(dst_addr, sdata);
 	if (mpath)
 		spin_lock_bh(&mpath->state_lock);
 	else
@@ -533,7 +531,7 @@ static void hwmp_prep_frame_process(struct
net_device *dev,
 		cpu_to_le32(orig_dsn), 0, dst_addr,
 		cpu_to_le32(dst_dsn), mpath->next_hop->addr, hopcount, ttl,
 		cpu_to_le32(lifetime), cpu_to_le32(metric),
-		0, dev);
+		0, sdata);
 	rcu_read_unlock();
 	sdata->u.sta.mshstats.fwded_frames++;
 	return;
@@ -544,7 +542,7 @@ fail:
 	return;
 }
 
-static void hwmp_perr_frame_process(struct net_device *dev,
+static void hwmp_perr_frame_process(struct ieee80211_sub_if_data
*sdata,
 			     struct ieee80211_mgmt *mgmt, u8 *perr_elem)
 {
 	struct mesh_path *mpath;
@@ -555,7 +553,7 @@ static void hwmp_perr_frame_process(struct
net_device *dev,
 	dst_addr = PERR_IE_DST_ADDR(perr_elem);
 	dst_dsn = PERR_IE_DST_DSN(perr_elem);
 	rcu_read_lock();
-	mpath = mesh_path_lookup(dst_addr, dev);
+	mpath = mesh_path_lookup(dst_addr, sdata);
 	if (mpath) {
 		spin_lock_bh(&mpath->state_lock);
 		if (mpath->flags & MESH_PATH_ACTIVE &&
@@ -566,7 +564,7 @@ static void hwmp_perr_frame_process(struct
net_device *dev,
 			mpath->dsn = dst_dsn;
 			spin_unlock_bh(&mpath->state_lock);
 			mesh_path_error_tx(dst_addr, cpu_to_le32(dst_dsn),
-					   dev->broadcast, dev);
+					   sdata->dev->broadcast, sdata);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
 	}
@@ -575,7 +573,7 @@ static void hwmp_perr_frame_process(struct
net_device *dev,
 
 
 
-void mesh_rx_path_sel_frame(struct net_device *dev,
+void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_mgmt *mgmt,
 			    size_t len)
 {
@@ -592,25 +590,25 @@ void mesh_rx_path_sel_frame(struct net_device
*dev,
 		if (!elems.preq || elems.preq_len != 37)
 			/* Right now we support just 1 destination and no AE */
 			return;
-		last_hop_metric = hwmp_route_info_get(dev, mgmt, elems.preq);
+		last_hop_metric = hwmp_route_info_get(sdata, mgmt, elems.preq);
 		if (!last_hop_metric)
 			return;
-		hwmp_preq_frame_process(dev, mgmt, elems.preq, last_hop_metric);
+		hwmp_preq_frame_process(sdata, mgmt, elems.preq, last_hop_metric);
 		break;
 	case MPATH_PREP:
 		if (!elems.prep || elems.prep_len != 31)
 			/* Right now we support no AE */
 			return;
-		last_hop_metric = hwmp_route_info_get(dev, mgmt, elems.prep);
+		last_hop_metric = hwmp_route_info_get(sdata, mgmt, elems.prep);
 		if (!last_hop_metric)
 			return;
-		hwmp_prep_frame_process(dev, mgmt, elems.prep, last_hop_metric);
+		hwmp_prep_frame_process(sdata, mgmt, elems.prep, last_hop_metric);
 		break;
 	case MPATH_PERR:
 		if (!elems.perr || elems.perr_len != 12)
 			/* Right now we support only one destination per PERR */
 			return;
-		hwmp_perr_frame_process(dev, mgmt, elems.perr);
+		hwmp_perr_frame_process(sdata, mgmt, elems.perr);
 	default:
 		return;
 	}
@@ -628,8 +626,7 @@ void mesh_rx_path_sel_frame(struct net_device *dev,
  */
 static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 {
-	struct ieee80211_sub_if_data *sdata =
-		IEEE80211_DEV_TO_SUB_IF(mpath->dev);
+	struct ieee80211_sub_if_data *sdata = mpath->sdata;
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct mesh_preq_queue *preq_node;
 
@@ -672,12 +669,10 @@ static void mesh_queue_preq(struct mesh_path
*mpath, u8 flags)
 /**
  * mesh_path_start_discovery - launch a path discovery from the PREQ
queue
  *
- * @dev: local mesh interface
+ * @sdata: local mesh subif
  */
-void mesh_path_start_discovery(struct net_device *dev)
+void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata =
-		IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct mesh_preq_queue *preq_node;
 	struct mesh_path *mpath;
@@ -699,7 +694,7 @@ void mesh_path_start_discovery(struct net_device
*dev)
 	spin_unlock(&ifsta->mesh_preq_queue_lock);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(preq_node->dst, dev);
+	mpath = mesh_path_lookup(preq_node->dst, sdata);
 	if (!mpath)
 		goto enddiscovery;
 
@@ -743,11 +738,11 @@ void mesh_path_start_discovery(struct net_device
*dev)
 		dst_flags = MP_F_RF;
 
 	spin_unlock_bh(&mpath->state_lock);
-	mesh_path_sel_frame_tx(MPATH_PREQ, 0, dev->dev_addr,
+	mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->dev->dev_addr,
 			cpu_to_le32(ifsta->dsn), dst_flags, mpath->dst,
-			cpu_to_le32(mpath->dsn), dev->broadcast, 0,
+			cpu_to_le32(mpath->dsn), sdata->dev->broadcast, 0,
 			ttl, cpu_to_le32(lifetime), 0,
-			cpu_to_le32(ifsta->preq_id++), dev);
+			cpu_to_le32(ifsta->preq_id++), sdata);
 	mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
 
 enddiscovery:
@@ -760,7 +755,7 @@ enddiscovery:
  *
  * @next_hop: output argument for next hop address
  * @skb: frame to be sent
- * @dev: network device the frame will be sent through
+ * @sdata: network subif the frame will be sent through
  *
  * Returns: 0 if the next hop was found. Nonzero otherwise. If no next
hop is
  * found, the function will start a path discovery and queue the frame
so it is
@@ -768,19 +763,18 @@ enddiscovery:
  * in this case.
  */
 int mesh_nexthop_lookup(u8 *next_hop, struct sk_buff *skb,
-		struct net_device *dev)
+		struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sk_buff *skb_to_free = NULL;
 	struct mesh_path *mpath;
 	int err = 0;
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(skb->data, dev);
+	mpath = mesh_path_lookup(skb->data, sdata);
 
 	if (!mpath) {
-		mesh_path_add(skb->data, dev);
-		mpath = mesh_path_lookup(skb->data, dev);
+		mesh_path_add(skb->data, sdata);
+		mpath = mesh_path_lookup(skb->data, sdata);
 		if (!mpath) {
 			dev_kfree_skb(skb);
 			sdata->u.sta.mshstats.dropped_frames_no_route++;
@@ -814,7 +808,7 @@ int mesh_nexthop_lookup(u8 *next_hop, struct sk_buff
*skb,
 
 		skb_queue_tail(&mpath->frame_queue, skb);
 		if (skb_to_free)
-			mesh_path_discard_frame(skb_to_free, dev);
+			mesh_path_discard_frame(skb_to_free, sdata);
 		err = -ENOENT;
 	}
 
@@ -834,7 +828,7 @@ void mesh_path_timer(unsigned long data)
 	if (!mpath)
 		goto endmpathtimer;
 	spin_lock_bh(&mpath->state_lock);
-	sdata = IEEE80211_DEV_TO_SUB_IF(mpath->dev);
+	sdata = mpath->sdata;
 	if (mpath->flags & MESH_PATH_RESOLVED ||
 			(!(mpath->flags & MESH_PATH_RESOLVING)))
 		mpath->flags &= ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 5f88a2e..defe342 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -9,7 +9,6 @@
 
 #include <linux/etherdevice.h>
 #include <linux/list.h>
-#include <linux/netdevice.h>
 #include <linux/random.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
@@ -62,13 +61,13 @@ void mesh_path_assign_nexthop(struct mesh_path
*mpath, struct sta_info *sta)
 /**
  * mesh_path_lookup - look up a path in the mesh path table
  * @dst: hardware address (ETH_ALEN length) of destination
- * @dev: local interface
+ * @sdata: local subif
  *
  * Returns: pointer to the mesh path structure, or NULL if not found
  *
  * Locking: must be called within a read rcu section.
  */
-struct mesh_path *mesh_path_lookup(u8 *dst, struct net_device *dev)
+struct mesh_path *mesh_path_lookup(u8 *dst, struct
ieee80211_sub_if_data *sdata)
 {
 	struct mesh_path *mpath;
 	struct hlist_node *n;
@@ -78,10 +77,10 @@ struct mesh_path *mesh_path_lookup(u8 *dst, struct
net_device *dev)
 
 	tbl = rcu_dereference(mesh_paths);
 
-	bucket = &tbl->hash_buckets[mesh_table_hash(dst, dev, tbl)];
+	bucket = &tbl->hash_buckets[mesh_table_hash(dst, sdata, tbl)];
 	hlist_for_each_entry_rcu(node, n, bucket, list) {
 		mpath = node->mpath;
-		if (mpath->dev == dev &&
+		if (mpath->sdata == sdata &&
 				memcmp(dst, mpath->dst, ETH_ALEN) == 0) {
 			if (MPATH_EXPIRED(mpath)) {
 				spin_lock_bh(&mpath->state_lock);
@@ -98,13 +97,13 @@ struct mesh_path *mesh_path_lookup(u8 *dst, struct
net_device *dev)
 /**
  * mesh_path_lookup_by_idx - look up a path in the mesh path table by
its index
  * @idx: index
- * @dev: local interface, or NULL for all entries
+ * @sdata: local subif, or NULL for all entries
  *
  * Returns: pointer to the mesh path structure, or NULL if not found.
  *
  * Locking: must be called within a read rcu section.
  */
-struct mesh_path *mesh_path_lookup_by_idx(int idx, struct net_device
*dev)
+struct mesh_path *mesh_path_lookup_by_idx(int idx, struct
ieee80211_sub_if_data *sdata)
 {
 	struct mpath_node *node;
 	struct hlist_node *p;
@@ -112,7 +111,7 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx,
struct net_device *dev)
 	int j = 0;
 
 	for_each_mesh_entry(mesh_paths, p, node, i) {
-		if (dev && node->mpath->dev != dev)
+		if (sdata && node->mpath->sdata != sdata)
 			continue;
 		if (j++ == idx) {
 			if (MPATH_EXPIRED(node->mpath)) {
@@ -131,15 +130,14 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx,
struct net_device *dev)
 /**
  * mesh_path_add - allocate and add a new path to the mesh path table
  * @addr: destination address of the path (ETH_ALEN length)
- * @dev: local interface
+ * @sdata: local subif
  *
  * Returns: 0 on sucess
  *
  * State: the initial state of the new path is set to 0
  */
-int mesh_path_add(u8 *dst, struct net_device *dev)
+int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mesh_path *mpath, *new_mpath;
 	struct mpath_node *node, *new_node;
 	struct hlist_head *bucket;
@@ -148,7 +146,7 @@ int mesh_path_add(u8 *dst, struct net_device *dev)
 	int err = 0;
 	u32 hash_idx;
 
-	if (memcmp(dst, dev->dev_addr, ETH_ALEN) == 0)
+	if (memcmp(dst, sdata->dev->dev_addr, ETH_ALEN) == 0)
 		/* never add ourselves as neighbours */
 		return -ENOTSUPP;
 
@@ -169,7 +167,7 @@ int mesh_path_add(u8 *dst, struct net_device *dev)
 
 	read_lock(&pathtbl_resize_lock);
 	memcpy(new_mpath->dst, dst, ETH_ALEN);
-	new_mpath->dev = dev;
+	new_mpath->sdata = sdata;
 	new_mpath->flags = 0;
 	skb_queue_head_init(&new_mpath->frame_queue);
 	new_node->mpath = new_mpath;
@@ -179,7 +177,7 @@ int mesh_path_add(u8 *dst, struct net_device *dev)
 	spin_lock_init(&new_mpath->state_lock);
 	init_timer(&new_mpath->timer);
 
-	hash_idx = mesh_table_hash(dst, dev, mesh_paths);
+	hash_idx = mesh_table_hash(dst, sdata, mesh_paths);
 	bucket = &mesh_paths->hash_buckets[hash_idx];
 
 	spin_lock(&mesh_paths->hashwlock[hash_idx]);
@@ -187,7 +185,7 @@ int mesh_path_add(u8 *dst, struct net_device *dev)
 	err = -EEXIST;
 	hlist_for_each_entry(node, n, bucket, list) {
 		mpath = node->mpath;
-		if (mpath->dev == dev && memcmp(dst, mpath->dst, ETH_ALEN) == 0)
+		if (mpath->sdata == sdata && memcmp(dst, mpath->dst, ETH_ALEN) == 0)
 			goto err_exists;
 	}
 
@@ -241,7 +239,7 @@ void mesh_plink_broken(struct sta_info *sta)
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	struct hlist_node *p;
-	struct net_device *dev = sta->sdata->dev;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	int i;
 
 	rcu_read_lock();
@@ -256,7 +254,7 @@ void mesh_plink_broken(struct sta_info *sta)
 			spin_unlock_bh(&mpath->state_lock);
 			mesh_path_error_tx(mpath->dst,
 					cpu_to_le32(mpath->dsn),
-					dev->broadcast, dev);
+					sdata->dev->broadcast, sdata);
 		} else
 		spin_unlock_bh(&mpath->state_lock);
 	}
@@ -284,11 +282,11 @@ void mesh_path_flush_by_nexthop(struct sta_info
*sta)
 	for_each_mesh_entry(mesh_paths, p, node, i) {
 		mpath = node->mpath;
 		if (mpath->next_hop == sta)
-			mesh_path_del(mpath->dst, mpath->dev);
+			mesh_path_del(mpath->dst, mpath->sdata);
 	}
 }
 
-void mesh_path_flush(struct net_device *dev)
+void mesh_path_flush(struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_path *mpath;
 	struct mpath_node *node;
@@ -297,16 +295,15 @@ void mesh_path_flush(struct net_device *dev)
 
 	for_each_mesh_entry(mesh_paths, p, node, i) {
 		mpath = node->mpath;
-		if (mpath->dev == dev)
-			mesh_path_del(mpath->dst, mpath->dev);
+		if (mpath->sdata == sdata)
+			mesh_path_del(mpath->dst, mpath->sdata);
 	}
 }
 
 static void mesh_path_node_reclaim(struct rcu_head *rp)
 {
 	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
-	struct ieee80211_sub_if_data *sdata =
-		IEEE80211_DEV_TO_SUB_IF(node->mpath->dev);
+	struct ieee80211_sub_if_data *sdata = node->mpath->sdata;
 
 	del_timer_sync(&node->mpath->timer);
 	atomic_dec(&sdata->u.sta.mpaths);
@@ -318,11 +315,11 @@ static void mesh_path_node_reclaim(struct rcu_head
*rp)
  * mesh_path_del - delete a mesh path from the table
  *
  * @addr: dst address (ETH_ALEN length)
- * @dev: local interface
+ * @sdata: local subif
  *
  * Returns: 0 if succesful
  */
-int mesh_path_del(u8 *addr, struct net_device *dev)
+int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_path *mpath;
 	struct mpath_node *node;
@@ -332,13 +329,13 @@ int mesh_path_del(u8 *addr, struct net_device
*dev)
 	int err = 0;
 
 	read_lock(&pathtbl_resize_lock);
-	hash_idx = mesh_table_hash(addr, dev, mesh_paths);
+	hash_idx = mesh_table_hash(addr, sdata, mesh_paths);
 	bucket = &mesh_paths->hash_buckets[hash_idx];
 
 	spin_lock(&mesh_paths->hashwlock[hash_idx]);
 	hlist_for_each_entry(node, n, bucket, list) {
 		mpath = node->mpath;
-		if (mpath->dev == dev &&
+		if (mpath->sdata == sdata &&
 				memcmp(addr, mpath->dst, ETH_ALEN) == 0) {
 			spin_lock_bh(&mpath->state_lock);
 			mpath->flags |= MESH_PATH_RESOLVING;
@@ -378,16 +375,15 @@ void mesh_path_tx_pending(struct mesh_path *mpath)
  * mesh_path_discard_frame - discard a frame whose path could not be
resolved
  *
  * @skb: frame to discard
- * @dev: network device the frame was to be sent through
+ * @sdata: network subif the frame was to be sent through
  *
  * If the frame was beign forwarded from another MP, a PERR frame will
be sent
  * to the precursor.
  *
  * Locking: the function must me called within a rcu_read_lock region
  */
-void mesh_path_discard_frame(struct sk_buff *skb, struct net_device
*dev)
+void mesh_path_discard_frame(struct sk_buff *skb, struct
ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mesh_path *mpath;
 	u32 dsn = 0;
 
@@ -400,10 +396,10 @@ void mesh_path_discard_frame(struct sk_buff *skb,
struct net_device *dev)
 		mshhdrlen = ieee80211_get_mesh_hdrlen(prev_meshhdr);
 		da = skb->data;
 		ra = MESH_PREQ(skb);
-		mpath = mesh_path_lookup(da, dev);
+		mpath = mesh_path_lookup(da, sdata);
 		if (mpath)
 			dsn = ++mpath->dsn;
-		mesh_path_error_tx(skb->data, cpu_to_le32(dsn), ra, dev);
+		mesh_path_error_tx(skb->data, cpu_to_le32(dsn), ra, sdata);
 	}
 
 	kfree_skb(skb);
@@ -419,14 +415,11 @@ void mesh_path_discard_frame(struct sk_buff *skb,
struct net_device *dev)
  */
 void mesh_path_flush_pending(struct mesh_path *mpath)
 {
-	struct ieee80211_sub_if_data *sdata;
 	struct sk_buff *skb;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(mpath->dev);
-
 	while ((skb = skb_dequeue(&mpath->frame_queue)) &&
 			(mpath->flags & MESH_PATH_ACTIVE))
-		mesh_path_discard_frame(skb, mpath->dev);
+		mesh_path_discard_frame(skb, mpath->sdata);
 }
 
 /**
@@ -475,7 +468,7 @@ static int mesh_path_node_copy(struct hlist_node *p,
struct mesh_table *newtbl)
 	node = hlist_entry(p, struct mpath_node, list);
 	mpath = node->mpath;
 	new_node->mpath = mpath;
-	hash_idx = mesh_table_hash(mpath->dst, mpath->dev, newtbl);
+	hash_idx = mesh_table_hash(mpath->dst, mpath->sdata, newtbl);
 	hlist_add_head(&new_node->list,
 			&newtbl->hash_buckets[hash_idx]);
 	return 0;
@@ -492,7 +485,7 @@ int mesh_pathtbl_init(void)
 	return 0;
 }
 
-void mesh_path_expire(struct net_device *dev)
+void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_path *mpath;
 	struct mpath_node *node;
@@ -501,7 +494,7 @@ void mesh_path_expire(struct net_device *dev)
 
 	read_lock(&pathtbl_resize_lock);
 	for_each_mesh_entry(mesh_paths, p, node, i) {
-		if (node->mpath->dev != dev)
+		if (node->mpath->sdata != sdata)
 			continue;
 		mpath = node->mpath;
 		spin_lock_bh(&mpath->state_lock);
@@ -510,7 +503,7 @@ void mesh_path_expire(struct net_device *dev)
 			time_after(jiffies,
 			 mpath->exp_time + MESH_PATH_EXPIRE)) {
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_del(mpath->dst, mpath->dev);
+			mesh_path_del(mpath->dst, mpath->sdata);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
 	}
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 9efeb1f..d400276 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -144,10 +144,10 @@ void mesh_plink_deactivate(struct sta_info *sta)
 	spin_unlock_bh(&sta->lock);
 }
 
-static int mesh_plink_frame_tx(struct net_device *dev,
+static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		enum plink_frame_type action, u8 *da, __le16 llid, __le16 plid,
 		__le16 reason) {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom +
400);
 	struct ieee80211_mgmt *mgmt;
 	bool include_plid = false;
@@ -166,7 +166,7 @@ static int mesh_plink_frame_tx(struct net_device
*dev,
 	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
 					   IEEE80211_STYPE_ACTION);
 	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
 	mgmt->u.action.category = PLINK_CATEGORY;
 	mgmt->u.action.u.plink_action.action_code = action;
@@ -180,7 +180,7 @@ static int mesh_plink_frame_tx(struct net_device
*dev,
 			/* two-byte status code followed by two-byte AID */
 			memset(pos, 0, 4);
 		}
-		mesh_mgmt_ies_add(skb, dev);
+		mesh_mgmt_ies_add(skb, sdata);
 	}
 
 	/* Add Peer Link Management element */
@@ -217,15 +217,14 @@ static int mesh_plink_frame_tx(struct net_device
*dev,
 		memcpy(pos, &reason, 2);
 	}
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 	return 0;
 }
 
-void mesh_neighbour_update(u8 *hw_addr, u64 rates, struct net_device
*dev,
+void mesh_neighbour_update(u8 *hw_addr, u64 rates, struct
ieee80211_sub_if_data *sdata,
 			   bool peer_accepting_plinks)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
 	rcu_read_lock();
@@ -257,7 +256,6 @@ static void mesh_plink_timer(unsigned long data)
 {
 	struct sta_info *sta;
 	__le16 llid, plid, reason;
-	struct net_device *dev = NULL;
 	struct ieee80211_sub_if_data *sdata;
 #ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
 	DECLARE_MAC_BUF(mac);
@@ -282,7 +280,6 @@ static void mesh_plink_timer(unsigned long data)
 	llid = sta->llid;
 	plid = sta->plid;
 	sdata = sta->sdata;
-	dev = sdata->dev;
 
 	switch (sta->plink_state) {
 	case PLINK_OPN_RCVD:
@@ -299,7 +296,7 @@ static void mesh_plink_timer(unsigned long data)
 			++sta->plink_retries;
 			mod_plink_timer(sta, sta->plink_timeout);
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(dev, PLINK_OPEN, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_OPEN, sta->addr, llid,
 					    0, 0);
 			break;
 		}
@@ -312,7 +309,7 @@ static void mesh_plink_timer(unsigned long data)
 		sta->plink_state = PLINK_HOLDING;
 		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 		spin_unlock_bh(&sta->lock);
-		mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid, plid,
+		mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid, plid,
 				    reason);
 		break;
 	case PLINK_HOLDING:
@@ -357,7 +354,7 @@ int mesh_plink_open(struct sta_info *sta)
 	mpl_dbg("Mesh plink: starting establishment with %s\n",
 		print_mac(mac, sta->addr));
 
-	return mesh_plink_frame_tx(sdata->dev, PLINK_OPEN,
+	return mesh_plink_frame_tx(sdata, PLINK_OPEN,
 				   sta->addr, llid, 0, 0);
 }
 
@@ -403,15 +400,14 @@ int mesh_plink_close(struct sta_info *sta)
 	llid = sta->llid;
 	plid = sta->plid;
 	spin_unlock_bh(&sta->lock);
-	mesh_plink_frame_tx(sta->sdata->dev, PLINK_CLOSE, sta->addr, llid,
+	mesh_plink_frame_tx(sta->sdata, PLINK_CLOSE, sta->addr, llid,
 			    plid, reason);
 	return 0;
 }
 
-void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt
*mgmt,
+void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct
ieee80211_mgmt *mgmt,
 			 size_t len, struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee802_11_elems elems;
 	struct sta_info *sta;
@@ -478,7 +474,7 @@ void mesh_rx_plink_frame(struct net_device *dev,
struct ieee80211_mgmt *mgmt,
 
 	/* Now we will figure out the appropriate event... */
 	event = PLINK_UNDEFINED;
-	if (ftype != PLINK_CLOSE && (!mesh_matches_local(&elems, dev))) {
+	if (ftype != PLINK_CLOSE && (!mesh_matches_local(&elems, sdata))) {
 		switch (ftype) {
 		case PLINK_OPEN:
 			event = OPN_RJCT;
@@ -577,9 +573,9 @@ void mesh_rx_plink_frame(struct net_device *dev,
struct ieee80211_mgmt *mgmt,
 			sta->llid = llid;
 			mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(dev, PLINK_OPEN, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_OPEN, sta->addr, llid,
 					    0, 0);
-			mesh_plink_frame_tx(dev, PLINK_CONFIRM, sta->addr,
+			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->addr,
 					    llid, plid, 0);
 			break;
 		default:
@@ -604,7 +600,7 @@ void mesh_rx_plink_frame(struct net_device *dev,
struct ieee80211_mgmt *mgmt,
 
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
 			break;
 		case OPN_ACPT:
@@ -613,7 +609,7 @@ void mesh_rx_plink_frame(struct net_device *dev,
struct ieee80211_mgmt *mgmt,
 			sta->plid = plid;
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(dev, PLINK_CONFIRM, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->addr, llid,
 					    plid, 0);
 			break;
 		case CNF_ACPT:
@@ -646,13 +642,13 @@ void mesh_rx_plink_frame(struct net_device *dev,
struct ieee80211_mgmt *mgmt,
 
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
 			break;
 		case OPN_ACPT:
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(dev, PLINK_CONFIRM, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->addr, llid,
 					    plid, 0);
 			break;
 		case CNF_ACPT:
@@ -685,7 +681,7 @@ void mesh_rx_plink_frame(struct net_device *dev,
struct ieee80211_mgmt *mgmt,
 
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
 			break;
 		case OPN_ACPT:
@@ -695,7 +691,7 @@ void mesh_rx_plink_frame(struct net_device *dev,
struct ieee80211_mgmt *mgmt,
 			spin_unlock_bh(&sta->lock);
 			mpl_dbg("Mesh plink with %s ESTABLISHED\n",
 					print_mac(mac, sta->addr));
-			mesh_plink_frame_tx(dev, PLINK_CONFIRM, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->addr, llid,
 					    plid, 0);
 			break;
 		default:
@@ -714,13 +710,13 @@ void mesh_rx_plink_frame(struct net_device *dev,
struct ieee80211_mgmt *mgmt,
 			llid = sta->llid;
 			mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
 			break;
 		case OPN_ACPT:
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(dev, PLINK_CONFIRM, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->addr, llid,
 					    plid, 0);
 			break;
 		default:
@@ -743,7 +739,7 @@ void mesh_rx_plink_frame(struct net_device *dev,
struct ieee80211_mgmt *mgmt,
 			llid = sta->llid;
 			reason = sta->reason;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
 			break;
 		default:
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index acb0413..1aee406 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -73,19 +73,19 @@
 #define IEEE80211_MIN_AMPDU_BUF 0x8
 #define IEEE80211_MAX_AMPDU_BUF 0x40
 
-static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
+static void ieee80211_send_probe_req(struct ieee80211_sub_if_data
*sdata, u8 *dst,
 				     u8 *ssid, size_t ssid_len);
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
+ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int
freq,
 		     u8 *ssid, u8 ssid_len);
 static void ieee80211_rx_bss_put(struct ieee80211_local *local,
 				 struct ieee80211_sta_bss *bss);
-static int ieee80211_sta_find_ibss(struct net_device *dev,
+static int ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_if_sta *ifsta);
-static int ieee80211_sta_wep_configured(struct net_device *dev);
-static int ieee80211_sta_start_scan(struct net_device *dev,
+static int ieee80211_sta_wep_configured(struct ieee80211_sub_if_data
*sdata);
+static int ieee80211_sta_start_scan(struct ieee80211_sub_if_data
*sdata,
 				    u8 *ssid, size_t ssid_len);
-static int ieee80211_sta_config_auth(struct net_device *dev,
+static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data
*sdata,
 				     struct ieee80211_if_sta *ifsta);
 static void sta_rx_agg_session_timer_expired(unsigned long data);
 
@@ -239,11 +239,10 @@ static int ecw2cw(int ecw)
 }
 
 
-static void ieee80211_sta_def_wmm_params(struct net_device *dev,
+static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data
*sdata,
 					 struct ieee80211_sta_bss *bss,
 					 int ibss)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	int i, have_higher_than_11mbit = 0;
 
@@ -281,11 +280,10 @@ static void ieee80211_sta_def_wmm_params(struct
net_device *dev,
 	}
 }
 
-static void ieee80211_sta_wmm_params(struct net_device *dev,
+static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				     struct ieee80211_if_sta *ifsta,
 				     u8 *wmm_param, size_t wmm_param_len)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_tx_queue_params params;
 	size_t left;
 	int count;
@@ -349,14 +347,14 @@ static void ieee80211_sta_wmm_params(struct
net_device *dev,
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		printk(KERN_DEBUG "%s: WMM queue=%d aci=%d acm=%d aifs=%d "
 		       "cWmin=%d cWmax=%d txop=%d\n",
-		       dev->name, queue, aci, acm, params.aifs, params.cw_min,
+		       local->mdev->name, queue, aci, acm, params.aifs,
params.cw_min,
 		       params.cw_max, params.txop);
 #endif
 		/* TODO: handle ACM (block TX, fallback to next lowest allowed
 		 * AC for now) */
 		if (local->ops->conf_tx(local_to_hw(local), queue, &params)) {
 			printk(KERN_DEBUG "%s: failed to set TX queue "
-			       "parameters for queue %d\n", dev->name, queue);
+			       "parameters for queue %d\n", local->mdev->name, queue);
 		}
 	}
 }
@@ -475,7 +473,7 @@ int ieee80211_ht_addt_info_ie_to_ht_bss_info(
 	return 0;
 }
 
-static void ieee80211_sta_send_associnfo(struct net_device *dev,
+static void ieee80211_sta_send_associnfo(struct ieee80211_sub_if_data
*sdata,
 					 struct ieee80211_if_sta *ifsta)
 {
 	char *buf;
@@ -520,17 +518,16 @@ static void ieee80211_sta_send_associnfo(struct
net_device *dev,
 
 	memset(&wrqu, 0, sizeof(wrqu));
 	wrqu.data.length = len;
-	wireless_send_event(dev, IWEVCUSTOM, &wrqu, buf);
+	wireless_send_event(sdata->dev, IWEVCUSTOM, &wrqu, buf);
 
 	kfree(buf);
 }
 
 
-static void ieee80211_set_associated(struct net_device *dev,
+static void ieee80211_set_associated(struct ieee80211_sub_if_data
*sdata,
 				     struct ieee80211_if_sta *ifsta,
 				     bool assoc)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local_to_hw(local)->conf;
 	union iwreq_data wrqu;
@@ -544,7 +541,7 @@ static void ieee80211_set_associated(struct
net_device *dev,
 		if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 			return;
 
-		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+		bss = ieee80211_rx_bss_get(local, ifsta->bssid,
 					   conf->channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
@@ -567,12 +564,12 @@ static void ieee80211_set_associated(struct
net_device *dev,
 		ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
 		memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
 		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
-		ieee80211_sta_send_associnfo(dev, ifsta);
+		ieee80211_sta_send_associnfo(sdata, ifsta);
 	} else {
-		netif_carrier_off(dev);
-		ieee80211_sta_tear_down_BA_sessions(dev, ifsta->bssid);
+		netif_carrier_off(sdata->dev);
+		ieee80211_sta_tear_down_BA_sessions(sdata, ifsta->bssid);
 		ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
-		changed |= ieee80211_reset_erp_info(dev);
+		changed |= ieee80211_reset_erp_info(sdata);
 
 		sdata->bss_conf.assoc_ht = 0;
 		sdata->bss_conf.ht_conf = NULL;
@@ -587,27 +584,24 @@ static void ieee80211_set_associated(struct
net_device *dev,
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	if (assoc)
-		netif_carrier_on(dev);
+		netif_carrier_on(sdata->dev);
 
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-static void ieee80211_set_disassoc(struct net_device *dev,
+static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_if_sta *ifsta, int deauth)
 {
 	if (deauth)
 		ifsta->auth_tries = 0;
 	ifsta->assoc_tries = 0;
-	ieee80211_set_associated(dev, ifsta, 0);
+	ieee80211_set_associated(sdata, ifsta, 0);
 }
 
-void ieee80211_sta_tx(struct net_device *dev, struct sk_buff *skb,
+void ieee80211_sta_tx(struct ieee80211_sub_if_data *sdata, struct
sk_buff *skb,
 		      int encrypt)
 {
-	struct ieee80211_sub_if_data *sdata;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	skb->dev = sdata->local->mdev;
 	skb_set_mac_header(skb, 0);
 	skb_set_network_header(skb, 0);
@@ -620,12 +614,12 @@ void ieee80211_sta_tx(struct net_device *dev,
struct sk_buff *skb,
 }
 
 
-static void ieee80211_send_auth(struct net_device *dev,
+static void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 				struct ieee80211_if_sta *ifsta,
 				int transaction, u8 *extra, size_t extra_len,
 				int encrypt)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 
@@ -633,7 +627,7 @@ static void ieee80211_send_auth(struct net_device
*dev,
 			    sizeof(*mgmt) + 6 + extra_len);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for auth "
-		       "frame\n", dev->name);
+		       "frame\n", sdata->dev->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -645,7 +639,7 @@ static void ieee80211_send_auth(struct net_device
*dev,
 	if (encrypt)
 		mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
 	mgmt->u.auth.auth_alg = cpu_to_le16(ifsta->auth_alg);
 	mgmt->u.auth.auth_transaction = cpu_to_le16(transaction);
@@ -654,11 +648,11 @@ static void ieee80211_send_auth(struct net_device
*dev,
 	if (extra)
 		memcpy(skb_put(skb, extra_len), extra, extra_len);
 
-	ieee80211_sta_tx(dev, skb, encrypt);
+	ieee80211_sta_tx(sdata, skb, encrypt);
 }
 
 
-static void ieee80211_authenticate(struct net_device *dev,
+static void ieee80211_authenticate(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_if_sta *ifsta)
 {
 	DECLARE_MAC_BUF(mac);
@@ -667,16 +661,16 @@ static void ieee80211_authenticate(struct
net_device *dev,
 	if (ifsta->auth_tries > IEEE80211_AUTH_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: authentication with AP %s"
 		       " timed out\n",
-		       dev->name, print_mac(mac, ifsta->bssid));
+		       sdata->dev->name, print_mac(mac, ifsta->bssid));
 		ifsta->state = IEEE80211_DISABLED;
 		return;
 	}
 
 	ifsta->state = IEEE80211_AUTHENTICATE;
 	printk(KERN_DEBUG "%s: authenticate with AP %s\n",
-	       dev->name, print_mac(mac, ifsta->bssid));
+	       sdata->dev->name, print_mac(mac, ifsta->bssid));
 
-	ieee80211_send_auth(dev, ifsta, 1, NULL, 0, 0);
+	ieee80211_send_auth(sdata, ifsta, 1, NULL, 0, 0);
 
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
 }
@@ -702,10 +696,10 @@ static int ieee80211_compatible_rates(struct
ieee80211_sta_bss *bss,
 	return count;
 }
 
-static void ieee80211_send_assoc(struct net_device *dev,
+static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 				 struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *ies;
@@ -721,7 +715,7 @@ static void ieee80211_send_assoc(struct net_device
*dev,
 			    ifsta->ssid_len);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for assoc "
-		       "frame\n", dev->name);
+		       "frame\n", sdata->dev->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -737,7 +731,7 @@ static void ieee80211_send_assoc(struct net_device
*dev,
 			capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
 
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+	bss = ieee80211_rx_bss_get(local, ifsta->bssid,
 				   local->hw.conf.channel->center_freq,
 				   ifsta->ssid, ifsta->ssid_len);
 	if (bss) {
@@ -765,7 +759,7 @@ static void ieee80211_send_assoc(struct net_device
*dev,
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
 
 	if (ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) {
@@ -904,21 +898,21 @@ static void ieee80211_send_assoc(struct net_device
*dev,
 	if (ifsta->assocreq_ies)
 		memcpy(ifsta->assocreq_ies, ies, ifsta->assocreq_ies_len);
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 }
 
 
-static void ieee80211_send_deauth(struct net_device *dev,
+static void ieee80211_send_deauth(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_if_sta *ifsta, u16 reason)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for deauth "
-		       "frame\n", dev->name);
+		       "frame\n", sdata->dev->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -926,28 +920,28 @@ static void ieee80211_send_deauth(struct
net_device *dev,
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
 	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
 					   IEEE80211_STYPE_DEAUTH);
 	skb_put(skb, 2);
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 }
 
 
-static void ieee80211_send_disassoc(struct net_device *dev,
+static void ieee80211_send_disassoc(struct ieee80211_sub_if_data
*sdata,
 				    struct ieee80211_if_sta *ifsta, u16 reason)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for disassoc "
-		       "frame\n", dev->name);
+		       "frame\n", sdata->dev->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -955,21 +949,21 @@ static void ieee80211_send_disassoc(struct
net_device *dev,
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
 	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
 					   IEEE80211_STYPE_DISASSOC);
 	skb_put(skb, 2);
 	mgmt->u.disassoc.reason_code = cpu_to_le16(reason);
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 }
 
 
-static int ieee80211_privacy_mismatch(struct net_device *dev,
+static int ieee80211_privacy_mismatch(struct ieee80211_sub_if_data
*sdata,
 				      struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sta_bss *bss;
 	int bss_privacy;
 	int wep_privacy;
@@ -978,14 +972,14 @@ static int ieee80211_privacy_mismatch(struct
net_device *dev,
 	if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL))
 		return 0;
 
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+	bss = ieee80211_rx_bss_get(local, ifsta->bssid,
 				   local->hw.conf.channel->center_freq,
 				   ifsta->ssid, ifsta->ssid_len);
 	if (!bss)
 		return 0;
 
 	bss_privacy = !!(bss->capability & WLAN_CAPABILITY_PRIVACY);
-	wep_privacy = !!ieee80211_sta_wep_configured(dev);
+	wep_privacy = !!ieee80211_sta_wep_configured(sdata);
 	privacy_invoked = !!(ifsta->flags & IEEE80211_STA_PRIVACY_INVOKED);
 
 	ieee80211_rx_bss_put(local, bss);
@@ -997,7 +991,7 @@ static int ieee80211_privacy_mismatch(struct
net_device *dev,
 }
 
 
-static void ieee80211_associate(struct net_device *dev,
+static void ieee80211_associate(struct ieee80211_sub_if_data *sdata,
 				struct ieee80211_if_sta *ifsta)
 {
 	DECLARE_MAC_BUF(mac);
@@ -1006,31 +1000,31 @@ static void ieee80211_associate(struct
net_device *dev,
 	if (ifsta->assoc_tries > IEEE80211_ASSOC_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: association with AP %s"
 		       " timed out\n",
-		       dev->name, print_mac(mac, ifsta->bssid));
+		       sdata->dev->name, print_mac(mac, ifsta->bssid));
 		ifsta->state = IEEE80211_DISABLED;
 		return;
 	}
 
 	ifsta->state = IEEE80211_ASSOCIATE;
 	printk(KERN_DEBUG "%s: associate with AP %s\n",
-	       dev->name, print_mac(mac, ifsta->bssid));
-	if (ieee80211_privacy_mismatch(dev, ifsta)) {
+	       sdata->dev->name, print_mac(mac, ifsta->bssid));
+	if (ieee80211_privacy_mismatch(sdata, ifsta)) {
 		printk(KERN_DEBUG "%s: mismatch in privacy configuration and "
-		       "mixed-cell disabled - abort association\n", dev->name);
+		       "mixed-cell disabled - abort association\n",
sdata->dev->name);
 		ifsta->state = IEEE80211_DISABLED;
 		return;
 	}
 
-	ieee80211_send_assoc(dev, ifsta);
+	ieee80211_send_assoc(sdata, ifsta);
 
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_ASSOC_TIMEOUT);
 }
 
 
-static void ieee80211_associated(struct net_device *dev,
+static void ieee80211_associated(struct ieee80211_sub_if_data *sdata,
 				 struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int disassoc;
 	DECLARE_MAC_BUF(mac);
@@ -1047,7 +1041,7 @@ static void ieee80211_associated(struct net_device
*dev,
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
 		printk(KERN_DEBUG "%s: No STA entry for own AP %s\n",
-		       dev->name, print_mac(mac, ifsta->bssid));
+		       sdata->dev->name, print_mac(mac, ifsta->bssid));
 		disassoc = 1;
 	} else {
 		disassoc = 0;
@@ -1057,11 +1051,11 @@ static void ieee80211_associated(struct
net_device *dev,
 				printk(KERN_DEBUG "%s: No ProbeResp from "
 				       "current AP %s - assume out of "
 				       "range\n",
-				       dev->name, print_mac(mac, ifsta->bssid));
+				       sdata->dev->name, print_mac(mac, ifsta->bssid));
 				disassoc = 1;
 				sta_info_unlink(&sta);
 			} else
-				ieee80211_send_probe_req(dev, ifsta->bssid,
+				ieee80211_send_probe_req(sdata, ifsta->bssid,
 							 local->scan_ssid,
 							 local->scan_ssid_len);
 			ifsta->flags ^= IEEE80211_STA_PROBEREQ_POLL;
@@ -1070,7 +1064,7 @@ static void ieee80211_associated(struct net_device
*dev,
 			if (time_after(jiffies, ifsta->last_probe +
 				       IEEE80211_PROBE_INTERVAL)) {
 				ifsta->last_probe = jiffies;
-				ieee80211_send_probe_req(dev, ifsta->bssid,
+				ieee80211_send_probe_req(sdata, ifsta->bssid,
 							 ifsta->ssid,
 							 ifsta->ssid_len);
 			}
@@ -1084,7 +1078,7 @@ static void ieee80211_associated(struct net_device
*dev,
 
 	if (disassoc) {
 		ifsta->state = IEEE80211_DISABLED;
-		ieee80211_set_associated(dev, ifsta, 0);
+		ieee80211_set_associated(sdata, ifsta, 0);
 	} else {
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_MONITORING_INTERVAL);
@@ -1092,10 +1086,10 @@ static void ieee80211_associated(struct
net_device *dev,
 }
 
 
-static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
+static void ieee80211_send_probe_req(struct ieee80211_sub_if_data
*sdata, u8 *dst,
 				     u8 *ssid, size_t ssid_len)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
@@ -1105,7 +1099,7 @@ static void ieee80211_send_probe_req(struct
net_device *dev, u8 *dst,
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt) +
200);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
-		       "request\n", dev->name);
+		       "request\n", sdata->dev->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -1114,7 +1108,7 @@ static void ieee80211_send_probe_req(struct
net_device *dev, u8 *dst,
 	memset(mgmt, 0, 24);
 	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
 					   IEEE80211_STYPE_PROBE_REQ);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	if (dst) {
 		memcpy(mgmt->da, dst, ETH_ALEN);
 		memcpy(mgmt->bssid, dst, ETH_ALEN);
@@ -1149,13 +1143,12 @@ static void ieee80211_send_probe_req(struct
net_device *dev, u8 *dst,
 		*pos = rate->bitrate / 5;
 	}
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 }
 
 
-static int ieee80211_sta_wep_configured(struct net_device *dev)
+static int ieee80211_sta_wep_configured(struct ieee80211_sub_if_data
*sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (!sdata || !sdata->default_key ||
 	    sdata->default_key->conf.alg != ALG_WEP)
 		return 0;
@@ -1163,16 +1156,16 @@ static int ieee80211_sta_wep_configured(struct
net_device *dev)
 }
 
 
-static void ieee80211_auth_completed(struct net_device *dev,
+static void ieee80211_auth_completed(struct ieee80211_sub_if_data
*sdata,
 				     struct ieee80211_if_sta *ifsta)
 {
-	printk(KERN_DEBUG "%s: authenticated\n", dev->name);
+	printk(KERN_DEBUG "%s: authenticated\n", sdata->dev->name);
 	ifsta->flags |= IEEE80211_STA_AUTHENTICATED;
-	ieee80211_associate(dev, ifsta);
+	ieee80211_associate(sdata, ifsta);
 }
 
 
-static void ieee80211_auth_challenge(struct net_device *dev,
+static void ieee80211_auth_challenge(struct ieee80211_sub_if_data
*sdata,
 				     struct ieee80211_if_sta *ifsta,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
@@ -1184,17 +1177,16 @@ static void ieee80211_auth_challenge(struct
net_device *dev,
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
 	if (!elems.challenge)
 		return;
-	ieee80211_send_auth(dev, ifsta, 3, elems.challenge - 2,
+	ieee80211_send_auth(sdata, ifsta, 3, elems.challenge - 2,
 			    elems.challenge_len + 2, 1);
 }
 
-static void ieee80211_send_addba_resp(struct net_device *dev, u8 *da,
u16 tid,
+static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data
*sdata, u8 *da, u16 tid,
 					u8 dialog_token, u16 status, u16 policy,
 					u16 buf_size, u16 timeout)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u16 capab;
@@ -1203,7 +1195,7 @@ static void ieee80211_send_addba_resp(struct
net_device *dev, u8 *da, u16 tid,
 
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer "
-		       "for addba resp frame\n", dev->name);
+		       "for addba resp frame\n", sdata->dev->name);
 		return;
 	}
 
@@ -1211,9 +1203,9 @@ static void ieee80211_send_addba_resp(struct
net_device *dev, u8 *da, u16 tid,
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
-		memcpy(mgmt->bssid, dev->dev_addr, ETH_ALEN);
+		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
 	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
@@ -1232,17 +1224,16 @@ static void ieee80211_send_addba_resp(struct
net_device *dev, u8 *da, u16 tid,
 	mgmt->u.action.u.addba_resp.timeout = cpu_to_le16(timeout);
 	mgmt->u.action.u.addba_resp.status = cpu_to_le16(status);
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 
 	return;
 }
 
-void ieee80211_send_addba_request(struct net_device *dev, const u8 *da,
+void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
const u8 *da,
 				u16 tid, u8 dialog_token, u16 start_seq_num,
 				u16 agg_size, u16 timeout)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
@@ -1252,16 +1243,16 @@ void ieee80211_send_addba_request(struct
net_device *dev, const u8 *da,
 
 	if (!skb) {
 		printk(KERN_ERR "%s: failed to allocate buffer "
-				"for addba request frame\n", dev->name);
+				"for addba request frame\n", sdata->dev->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
-		memcpy(mgmt->bssid, dev->dev_addr, ETH_ALEN);
+		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
 
@@ -1284,14 +1275,13 @@ void ieee80211_send_addba_request(struct
net_device *dev, const u8 *da,
 	mgmt->u.action.u.addba_req.start_seq_num =
 					cpu_to_le16(start_seq_num << 4);
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 }
 
-static void ieee80211_sta_process_addba_request(struct net_device *dev,
+static void ieee80211_sta_process_addba_request(struct ieee80211_local
*local,
 						struct ieee80211_mgmt *mgmt,
 						size_t len)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_conf *conf = &hw->conf;
 	struct sta_info *sta;
@@ -1423,16 +1413,15 @@ end:
 	spin_unlock_bh(&sta->lock);
 
 end_no_lock:
-	ieee80211_send_addba_resp(sta->sdata->dev, sta->addr, tid,
+	ieee80211_send_addba_resp(sta->sdata, sta->addr, tid,
 				  dialog_token, status, 1, buf_size, timeout);
 	rcu_read_unlock();
 }
 
-static void ieee80211_sta_process_addba_resp(struct net_device *dev,
+static void ieee80211_sta_process_addba_resp(struct ieee80211_local
*local,
 					     struct ieee80211_mgmt *mgmt,
 					     size_t len)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 	struct sta_info *sta;
 	u16 capab;
@@ -1494,11 +1483,10 @@ addba_resp_exit:
 	rcu_read_unlock();
 }
 
-void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16
tid,
+void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata, const u8
*da, u16 tid,
 			  u16 initiator, u16 reason_code)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
@@ -1508,7 +1496,7 @@ void ieee80211_send_delba(struct net_device *dev,
const u8 *da, u16 tid,
 
 	if (!skb) {
 		printk(KERN_ERR "%s: failed to allocate buffer "
-					"for delba frame\n", dev->name);
+					"for delba frame\n", sdata->dev->name);
 		return;
 	}
 
@@ -1516,9 +1504,9 @@ void ieee80211_send_delba(struct net_device *dev,
const u8 *da, u16 tid,
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
-		memcpy(mgmt->bssid, dev->dev_addr, ETH_ALEN);
+		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
 	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
@@ -1534,12 +1522,12 @@ void ieee80211_send_delba(struct net_device
*dev, const u8 *da, u16 tid,
 	mgmt->u.action.u.delba.params = cpu_to_le16(params);
 	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 }
 
-void ieee80211_send_bar(struct net_device *dev, u8 *ra, u16 tid, u16
ssn)
+void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra,
u16 tid, u16 ssn)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_bar *bar;
 	u16 bar_control = 0;
@@ -1547,7 +1535,7 @@ void ieee80211_send_bar(struct net_device *dev, u8
*ra, u16 tid, u16 ssn)
 	skb = dev_alloc_skb(sizeof(*bar) + local->hw.extra_tx_headroom);
 	if (!skb) {
 		printk(KERN_ERR "%s: failed to allocate buffer for "
-			"bar frame\n", dev->name);
+			"bar frame\n", sdata->dev->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -1556,20 +1544,20 @@ void ieee80211_send_bar(struct net_device *dev,
u8 *ra, u16 tid, u16 ssn)
 	bar->frame_control = IEEE80211_FC(IEEE80211_FTYPE_CTL,
 					IEEE80211_STYPE_BACK_REQ);
 	memcpy(bar->ra, ra, ETH_ALEN);
-	memcpy(bar->ta, dev->dev_addr, ETH_ALEN);
+	memcpy(bar->ta, sdata->dev->dev_addr, ETH_ALEN);
 	bar_control |= (u16)IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL;
 	bar_control |= (u16)IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA;
 	bar_control |= (u16)(tid << 12);
 	bar->control = cpu_to_le16(bar_control);
 	bar->start_seq_num = cpu_to_le16(ssn);
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 }
 
-void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *ra,
u16 tid,
+void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data
*sdata, u8 *ra, u16 tid,
 					u16 initiator, u16 reason)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_hw *hw = &local->hw;
 	struct sta_info *sta;
 	int ret, i;
@@ -1617,7 +1605,7 @@ void ieee80211_sta_stop_rx_ba_session(struct
net_device *dev, u8 *ra, u16 tid,
 
 	/* check if this is a self generated aggregation halt */
 	if (initiator == WLAN_BACK_RECIPIENT || initiator == WLAN_BACK_TIMER)
-		ieee80211_send_delba(dev, ra, tid, 0, reason);
+		ieee80211_send_delba(sdata, ra, tid, 0, reason);
 
 	/* free the reordering buffer */
 	for (i = 0; i < sta->ampdu_mlme.tid_rx[tid]->buf_size; i++) {
@@ -1638,10 +1626,10 @@ void ieee80211_sta_stop_rx_ba_session(struct
net_device *dev, u8 *ra, u16 tid,
 }
 
 
-static void ieee80211_sta_process_delba(struct net_device *dev,
+static void ieee80211_sta_process_delba(struct ieee80211_sub_if_data
*sdata,
 			struct ieee80211_mgmt *mgmt, size_t len)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u16 tid, params;
 	u16 initiator;
@@ -1668,7 +1656,7 @@ static void ieee80211_sta_process_delba(struct
net_device *dev,
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (initiator == WLAN_BACK_INITIATOR)
-		ieee80211_sta_stop_rx_ba_session(dev, sta->addr, tid,
+		ieee80211_sta_stop_rx_ba_session(sdata, sta->addr, tid,
 						 WLAN_BACK_INITIATOR, 0);
 	else { /* WLAN_BACK_RECIPIENT */
 		spin_lock_bh(&sta->lock);
@@ -1755,31 +1743,31 @@ static void
sta_rx_agg_session_timer_expired(unsigned long data)
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
 #endif
-	ieee80211_sta_stop_rx_ba_session(sta->sdata->dev, sta->addr,
+	ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->addr,
 					 (u16)*ptid, WLAN_BACK_TIMER,
 					 WLAN_REASON_QSTA_TIMEOUT);
 }
 
-void ieee80211_sta_tear_down_BA_sessions(struct net_device *dev, u8
*addr)
+void ieee80211_sta_tear_down_BA_sessions(struct ieee80211_sub_if_data
*sdata, u8 *addr)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	int i;
 
 	for (i = 0; i <  STA_TID_NUM; i++) {
 		ieee80211_stop_tx_ba_session(&local->hw, addr, i,
 					     WLAN_BACK_INITIATOR);
-		ieee80211_sta_stop_rx_ba_session(dev, addr, i,
+		ieee80211_sta_stop_rx_ba_session(sdata, addr, i,
 						 WLAN_BACK_RECIPIENT,
 						 WLAN_REASON_QSTA_LEAVE_QBSS);
 	}
 }
 
-static void ieee80211_send_refuse_measurement_request(struct net_device
*dev,
+static void ieee80211_send_refuse_measurement_request(struct
ieee80211_sub_if_data *sdata,
 					struct ieee80211_msrment_ie *request_ie,
 					const u8 *da, const u8 *bssid,
 					u8 dialog_token)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *msr_report;
 
@@ -1788,7 +1776,7 @@ static void
ieee80211_send_refuse_measurement_request(struct net_device *dev,
 
 	if (!skb) {
 		printk(KERN_ERR "%s: failed to allocate buffer for "
-				"measurement report frame\n", dev->name);
+				"measurement report frame\n", sdata->dev->name);
 		return;
 	}
 
@@ -1796,7 +1784,7 @@ static void
ieee80211_send_refuse_measurement_request(struct net_device *dev,
 	msr_report = (struct ieee80211_mgmt *)skb_put(skb, 24);
 	memset(msr_report, 0, 24);
 	memcpy(msr_report->da, da, ETH_ALEN);
-	memcpy(msr_report->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(msr_report->sa, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(msr_report->bssid, bssid, ETH_ALEN);
 	msr_report->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
 						IEEE80211_STYPE_ACTION);
@@ -1818,10 +1806,10 @@ static void
ieee80211_send_refuse_measurement_request(struct net_device *dev,
 			IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED;
 	msr_report->u.action.u.measurement.msr_elem.type = request_ie->type;
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 }
 
-static void ieee80211_sta_process_measurement_req(struct net_device
*dev,
+static void ieee80211_sta_process_measurement_req(struct
ieee80211_sub_if_data *sdata,
 						struct ieee80211_mgmt *mgmt,
 						size_t len)
 {
@@ -1832,19 +1820,18 @@ static void
ieee80211_sta_process_measurement_req(struct net_device *dev,
 	 * For now just refuse
 	 * TODO: Answer basic measurement as unmeasured
 	 */
-	ieee80211_send_refuse_measurement_request(dev,
+	ieee80211_send_refuse_measurement_request(sdata,
 			&mgmt->u.action.u.measurement.msr_elem,
 			mgmt->sa, mgmt->bssid,
 			mgmt->u.action.u.measurement.dialog_token);
 }
 
 
-static void ieee80211_rx_mgmt_auth(struct net_device *dev,
+static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_mgmt *mgmt,
 				   size_t len)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	u16 auth_alg, auth_transaction, status_code;
 	DECLARE_MAC_BUF(mac);
 
@@ -1876,7 +1863,7 @@ static void ieee80211_rx_mgmt_auth(struct
net_device *dev,
 		 */
 		if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1)
 			return;
-		ieee80211_send_auth(dev, ifsta, 2, NULL, 0, 0);
+		ieee80211_send_auth(sdata, ifsta, 2, NULL, 0, 0);
 	}
 
 	if (auth_alg != ifsta->auth_alg ||
@@ -1909,7 +1896,7 @@ static void ieee80211_rx_mgmt_auth(struct
net_device *dev,
 				    algs[pos] == 0xff)
 					continue;
 				if (algs[pos] == WLAN_AUTH_SHARED_KEY &&
-				    !ieee80211_sta_wep_configured(dev))
+				    !ieee80211_sta_wep_configured(sdata))
 					continue;
 				ifsta->auth_alg = algs[pos];
 				break;
@@ -1921,19 +1908,19 @@ static void ieee80211_rx_mgmt_auth(struct
net_device *dev,
 	switch (ifsta->auth_alg) {
 	case WLAN_AUTH_OPEN:
 	case WLAN_AUTH_LEAP:
-		ieee80211_auth_completed(dev, ifsta);
+		ieee80211_auth_completed(sdata, ifsta);
 		break;
 	case WLAN_AUTH_SHARED_KEY:
 		if (ifsta->auth_transaction == 4)
-			ieee80211_auth_completed(dev, ifsta);
+			ieee80211_auth_completed(sdata, ifsta);
 		else
-			ieee80211_auth_challenge(dev, ifsta, mgmt, len);
+			ieee80211_auth_challenge(sdata, ifsta, mgmt, len);
 		break;
 	}
 }
 
 
-static void ieee80211_rx_mgmt_deauth(struct net_device *dev,
+static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data
*sdata,
 				     struct ieee80211_if_sta *ifsta,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
@@ -1950,7 +1937,7 @@ static void ieee80211_rx_mgmt_deauth(struct
net_device *dev,
 	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
 	if (ifsta->flags & IEEE80211_STA_AUTHENTICATED)
-		printk(KERN_DEBUG "%s: deauthenticated\n", dev->name);
+		printk(KERN_DEBUG "%s: deauthenticated\n", sdata->dev->name);
 
 	if (ifsta->state == IEEE80211_AUTHENTICATE ||
 	    ifsta->state == IEEE80211_ASSOCIATE ||
@@ -1960,12 +1947,12 @@ static void ieee80211_rx_mgmt_deauth(struct
net_device *dev,
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
-	ieee80211_set_disassoc(dev, ifsta, 1);
+	ieee80211_set_disassoc(sdata, ifsta, 1);
 	ifsta->flags &= ~IEEE80211_STA_AUTHENTICATED;
 }
 
 
-static void ieee80211_rx_mgmt_disassoc(struct net_device *dev,
+static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data
*sdata,
 				       struct ieee80211_if_sta *ifsta,
 				       struct ieee80211_mgmt *mgmt,
 				       size_t len)
@@ -1982,7 +1969,7 @@ static void ieee80211_rx_mgmt_disassoc(struct
net_device *dev,
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
 	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
-		printk(KERN_DEBUG "%s: disassociated\n", dev->name);
+		printk(KERN_DEBUG "%s: disassociated\n", sdata->dev->name);
 
 	if (ifsta->state == IEEE80211_ASSOCIATED) {
 		ifsta->state = IEEE80211_ASSOCIATE;
@@ -1990,7 +1977,7 @@ static void ieee80211_rx_mgmt_disassoc(struct
net_device *dev,
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
-	ieee80211_set_disassoc(dev, ifsta, 0);
+	ieee80211_set_disassoc(sdata, ifsta, 0);
 }
 
 
@@ -2001,7 +1988,6 @@ static void ieee80211_rx_mgmt_assoc_resp(struct
ieee80211_sub_if_data *sdata,
 					 int reassoc)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct net_device *dev = sdata->dev;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 	u64 rates, basic_rates;
@@ -2031,12 +2017,12 @@ static void ieee80211_rx_mgmt_assoc_resp(struct
ieee80211_sub_if_data *sdata,
 
 	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=0x%x "
 	       "status=%d aid=%d)\n",
-	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
+	       sdata->dev->name, reassoc ? "Rea" : "A", print_mac(mac,
mgmt->sa),
 	       capab_info, status_code, (u16)(aid & ~(BIT(15) | BIT(14))));
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
-		       dev->name, status_code);
+		       sdata->dev->name, status_code);
 		/* if this was a reassociation, ensure we try a "full"
 		 * association next time. This works around some broken APs
 		 * which do not correctly reject reassociation requests. */
@@ -2046,7 +2032,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct
ieee80211_sub_if_data *sdata,
 
 	if ((aid & (BIT(15) | BIT(14))) != (BIT(15) | BIT(14)))
 		printk(KERN_DEBUG "%s: invalid aid value %d; bits 15:14 not "
-		       "set\n", dev->name, aid);
+		       "set\n", sdata->dev->name, aid);
 	aid &= ~(BIT(15) | BIT(14));
 
 	pos = mgmt->u.assoc_resp.variable;
@@ -2054,11 +2040,11 @@ static void ieee80211_rx_mgmt_assoc_resp(struct
ieee80211_sub_if_data *sdata,
 
 	if (!elems.supp_rates) {
 		printk(KERN_DEBUG "%s: no SuppRates element in AssocResp\n",
-		       dev->name);
+		       sdata->dev->name);
 		return;
 	}
 
-	printk(KERN_DEBUG "%s: associated\n", dev->name);
+	printk(KERN_DEBUG "%s: associated\n", sdata->dev->name);
 	ifsta->aid = aid;
 	ifsta->ap_capab = capab_info;
 
@@ -2079,11 +2065,11 @@ static void ieee80211_rx_mgmt_assoc_resp(struct
ieee80211_sub_if_data *sdata,
 		sta = sta_info_alloc(sdata, ifsta->bssid, GFP_ATOMIC);
 		if (!sta) {
 			printk(KERN_DEBUG "%s: failed to alloc STA entry for"
-			       " the AP\n", dev->name);
+			       " the AP\n", sdata->dev->name);
 			rcu_read_unlock();
 			return;
 		}
-		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+		bss = ieee80211_rx_bss_get(local, ifsta->bssid,
 					   local->hw.conf.channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
@@ -2096,7 +2082,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct
ieee80211_sub_if_data *sdata,
 		err = sta_info_insert(sta);
 		if (err) {
 			printk(KERN_DEBUG "%s: failed to insert STA entry for"
-			       " the AP (error %d)\n", dev->name, err);
+			       " the AP (error %d)\n", sdata->dev->name, err);
 			rcu_read_unlock();
 			return;
 		}
@@ -2174,7 +2160,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct
ieee80211_sub_if_data *sdata,
 	if (elems.wmm_param) {
 		set_sta_flags(sta, WLAN_STA_WME);
 		rcu_read_unlock();
-		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
+		ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
 					 elems.wmm_param_len);
 	} else
 		rcu_read_unlock();
@@ -2183,17 +2169,16 @@ static void ieee80211_rx_mgmt_assoc_resp(struct
ieee80211_sub_if_data *sdata,
 	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
 	bss_conf->assoc_capability = capab_info;
-	ieee80211_set_associated(dev, ifsta, 1);
+	ieee80211_set_associated(sdata, ifsta, 1);
 
-	ieee80211_associated(dev, ifsta);
+	ieee80211_associated(sdata, ifsta);
 }
 
 
 /* Caller must hold local->sta_bss_lock */
-static void __ieee80211_rx_bss_hash_add(struct net_device *dev,
+static void __ieee80211_rx_bss_hash_add(struct ieee80211_local *local,
 					struct ieee80211_sta_bss *bss)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	u8 hash_idx;
 
 	if (bss_mesh_cfg(bss))
@@ -2229,10 +2214,10 @@ static void __ieee80211_rx_bss_hash_del(struct
ieee80211_local *local,
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int freq,
+ieee80211_rx_bss_add(struct ieee80211_sub_if_data *sdata, u8 *bssid,
int freq,
 		     u8 *ssid, u8 ssid_len)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sta_bss *bss;
 
 	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
@@ -2250,16 +2235,15 @@ ieee80211_rx_bss_add(struct net_device *dev, u8
*bssid, int freq,
 	spin_lock_bh(&local->sta_bss_lock);
 	/* TODO: order by RSSI? */
 	list_add_tail(&bss->list, &local->sta_bss_list);
-	__ieee80211_rx_bss_hash_add(dev, bss);
+	__ieee80211_rx_bss_hash_add(local, bss);
 	spin_unlock_bh(&local->sta_bss_lock);
 	return bss;
 }
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
+ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int
freq,
 		     u8 *ssid, u8 ssid_len)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 
 	spin_lock_bh(&local->sta_bss_lock);
@@ -2281,10 +2265,9 @@ ieee80211_rx_bss_get(struct net_device *dev, u8
*bssid, int freq,
 
 #ifdef CONFIG_MAC80211_MESH
 static struct ieee80211_sta_bss *
-ieee80211_rx_mesh_bss_get(struct net_device *dev, u8 *mesh_id, int
mesh_id_len,
+ieee80211_rx_mesh_bss_get(struct ieee80211_local *local, u8 *mesh_id,
int mesh_id_len,
 			  u8 *mesh_cfg, int freq)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 
 	spin_lock_bh(&local->sta_bss_lock);
@@ -2306,10 +2289,9 @@ ieee80211_rx_mesh_bss_get(struct net_device *dev,
u8 *mesh_id, int mesh_id_len,
 }
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_mesh_bss_add(struct net_device *dev, u8 *mesh_id, int
mesh_id_len,
+ieee80211_rx_mesh_bss_add(struct ieee80211_local *local, u8 *mesh_id,
int mesh_id_len,
 			  u8 *mesh_cfg, int mesh_config_len, int freq)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 
 	if (mesh_config_len != MESH_CFG_LEN)
@@ -2343,7 +2325,7 @@ ieee80211_rx_mesh_bss_add(struct net_device *dev,
u8 *mesh_id, int mesh_id_len,
 	spin_lock_bh(&local->sta_bss_lock);
 	/* TODO: order by RSSI? */
 	list_add_tail(&bss->list, &local->sta_bss_list);
-	__ieee80211_rx_bss_hash_add(dev, bss);
+	__ieee80211_rx_bss_hash_add(local, bss);
 	spin_unlock_bh(&local->sta_bss_lock);
 	return bss;
 }
@@ -2394,23 +2376,20 @@ void ieee80211_rx_bss_list_deinit(struct
ieee80211_local *local)
 }
 
 
-static int ieee80211_sta_join_ibss(struct net_device *dev,
+static int ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_sta_bss *bss)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	int res, rates, i, j;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
-	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_supported_band *sband;
 	union iwreq_data wrqu;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
 	/* Remove possible STA entries from other IBSS networks. */
 	sta_info_flush_delayed(sdata);
 
@@ -2428,7 +2407,7 @@ static int ieee80211_sta_join_ibss(struct
net_device *dev,
 	sdata->drop_unencrypted = bss->capability &
 		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	res = ieee80211_set_freq(dev, bss->freq);
+	res = ieee80211_set_freq(sdata, bss->freq);
 
 	if (res)
 		return res;
@@ -2444,7 +2423,7 @@ static int ieee80211_sta_join_ibss(struct
net_device *dev,
 		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
 						   IEEE80211_STYPE_PROBE_RESP);
 		memset(mgmt->da, 0xff, ETH_ALEN);
-		memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+		memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
 		mgmt->u.beacon.beacon_int =
 			cpu_to_le16(local->hw.conf.beacon_int);
@@ -2501,14 +2480,14 @@ static int ieee80211_sta_join_ibss(struct
net_device *dev,
 	}
 	ifsta->supp_rates_bits[local->hw.conf.channel->band] = rates;
 
-	ieee80211_sta_def_wmm_params(dev, bss, 1);
+	ieee80211_sta_def_wmm_params(sdata, bss, 1);
 
 	ifsta->state = IEEE80211_IBSS_JOINED;
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
 
 	memset(&wrqu, 0, sizeof(wrqu));
 	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
-	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
 
 	return res;
 }
@@ -2550,35 +2529,34 @@ u64 ieee80211_sta_get_rates(struct
ieee80211_local *local,
 }
 
 
-static void ieee80211_rx_bss_info(struct net_device *dev,
+static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
 				  struct ieee80211_rx_status *rx_status,
 				  struct ieee802_11_elems *elems,
 				  int beacon)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	int freq, clen;
 	struct ieee80211_sta_bss *bss;
 	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	u64 beacon_timestamp, rx_timestamp;
 	struct ieee80211_channel *channel;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
-	if (!beacon && memcmp(mgmt->da, dev->dev_addr, ETH_ALEN))
+	if (!beacon && memcmp(mgmt->da, sdata->dev->dev_addr, ETH_ALEN))
 		return; /* ignore ProbeResp to foreign address */
 
 	beacon_timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) && elems->mesh_id &&
-	    elems->mesh_config && mesh_matches_local(elems, dev)) {
+	    elems->mesh_config && mesh_matches_local(elems, sdata)) {
 		u64 rates = ieee80211_sta_get_rates(local, elems,
 						rx_status->band);
 
-		mesh_neighbour_update(mgmt->sa, rates, dev,
-				      mesh_peer_accepts_plinks(elems, dev));
+		mesh_neighbour_update(mgmt->sa, rates, sdata,
+				      mesh_peer_accepts_plinks(elems));
 	}
 
 	rcu_read_lock();
@@ -2615,21 +2593,21 @@ static void ieee80211_rx_bss_info(struct
net_device *dev,
 
 #ifdef CONFIG_MAC80211_MESH
 	if (elems->mesh_config)
-		bss = ieee80211_rx_mesh_bss_get(dev, elems->mesh_id,
+		bss = ieee80211_rx_mesh_bss_get(local, elems->mesh_id,
 				elems->mesh_id_len, elems->mesh_config, freq);
 	else
 #endif
-		bss = ieee80211_rx_bss_get(dev, mgmt->bssid, freq,
+		bss = ieee80211_rx_bss_get(local, mgmt->bssid, freq,
 					   elems->ssid, elems->ssid_len);
 	if (!bss) {
 #ifdef CONFIG_MAC80211_MESH
 		if (elems->mesh_config)
-			bss = ieee80211_rx_mesh_bss_add(dev, elems->mesh_id,
+			bss = ieee80211_rx_mesh_bss_add(local, elems->mesh_id,
 				elems->mesh_id_len, elems->mesh_config,
 				elems->mesh_config_len, freq);
 		else
 #endif
-			bss = ieee80211_rx_bss_add(dev, mgmt->bssid, freq,
+			bss = ieee80211_rx_bss_add(sdata, mgmt->bssid, freq,
 						  elems->ssid, elems->ssid_len);
 		if (!bss)
 			return;
@@ -2856,10 +2834,10 @@ static void ieee80211_rx_bss_info(struct
net_device *dev,
 #ifndef CONFIG_MAC80211_IBSS_DEBUG
 			printk(KERN_DEBUG "%s: beacon TSF higher than "
 			       "local TSF - IBSS merge with BSSID %s\n",
-			       dev->name, print_mac(mac, mgmt->bssid));
+			       sdata->dev->name, print_mac(mac, mgmt->bssid));
 #endif
-			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
-			ieee80211_ibss_add_sta(dev, NULL,
+			ieee80211_sta_join_ibss(sdata, &sdata->u.sta, bss);
+			ieee80211_ibss_add_sta(sdata, NULL,
 					       mgmt->bssid, mgmt->sa,
 					       BIT(rx_status->rate_idx));
 		}
@@ -2869,7 +2847,7 @@ static void ieee80211_rx_bss_info(struct
net_device *dev,
 }
 
 
-static void ieee80211_rx_mgmt_probe_resp(struct net_device *dev,
+static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data
*sdata,
 					 struct ieee80211_mgmt *mgmt,
 					 size_t len,
 					 struct ieee80211_rx_status *rx_status)
@@ -2884,20 +2862,19 @@ static void ieee80211_rx_mgmt_probe_resp(struct
net_device *dev,
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
 				&elems);
 
-	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, &elems, 0);
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, 0);
 }
 
 
-static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
+static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data
*sdata,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len,
 				     struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_sta *ifsta;
 	size_t baselen;
 	struct ieee802_11_elems elems;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local->hw.conf;
 	u32 changed = 0;
 
@@ -2908,9 +2885,8 @@ static void ieee80211_rx_mgmt_beacon(struct
net_device *dev,
 
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen,
&elems);
 
-	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, &elems, 1);
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, 1);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 		return;
 	ifsta = &sdata->u.sta;
@@ -2919,7 +2895,7 @@ static void ieee80211_rx_mgmt_beacon(struct
net_device *dev,
 	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
-	ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
+	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
 				 elems.wmm_param_len);
 
 	/* Do not send changes to driver if we are scanning. This removes
@@ -2951,14 +2927,13 @@ static void ieee80211_rx_mgmt_beacon(struct
net_device *dev,
 }
 
 
-static void ieee80211_rx_mgmt_probe_req(struct net_device *dev,
+static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data
*sdata,
 					struct ieee80211_if_sta *ifsta,
 					struct ieee80211_mgmt *mgmt,
 					size_t len,
 					struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	int tx_last_beacon;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *resp;
@@ -2982,7 +2957,7 @@ static void ieee80211_rx_mgmt_probe_req(struct
net_device *dev,
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "%s: RX ProbeReq SA=%s DA=%s BSSID="
 	       "%s (tx_last_beacon=%d)\n",
-	       dev->name, print_mac(mac, mgmt->sa), print_mac(mac2, mgmt->da),
+	       sdata->dev->name, print_mac(mac, mgmt->sa), print_mac(mac2,
mgmt->da),
 	       print_mac(mac3, mgmt->bssid), tx_last_beacon);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
@@ -3000,7 +2975,7 @@ static void ieee80211_rx_mgmt_probe_req(struct
net_device *dev,
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 		printk(KERN_DEBUG "%s: Invalid SSID IE in ProbeReq "
 		       "from %s\n",
-		       dev->name, print_mac(mac, mgmt->sa));
+		       sdata->dev->name, print_mac(mac, mgmt->sa));
 #endif
 		return;
 	}
@@ -3020,19 +2995,18 @@ static void ieee80211_rx_mgmt_probe_req(struct
net_device *dev,
 	memcpy(resp->da, mgmt->sa, ETH_ALEN);
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "%s: Sending ProbeResp to %s\n",
-	       dev->name, print_mac(mac, resp->da));
+	       sdata->dev->name, print_mac(mac, resp->da));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 }
 
-static void ieee80211_rx_mgmt_action(struct net_device *dev,
+static void ieee80211_rx_mgmt_action(struct ieee80211_sub_if_data
*sdata,
 				     struct ieee80211_if_sta *ifsta,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len,
 				     struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 
 	if (len < IEEE80211_MIN_ACTION_SIZE)
 		return;
@@ -3046,7 +3020,7 @@ static void ieee80211_rx_mgmt_action(struct
net_device *dev,
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.measurement)))
 				break;
-			ieee80211_sta_process_measurement_req(dev, mgmt, len);
+			ieee80211_sta_process_measurement_req(sdata, mgmt, len);
 			break;
 		}
 		break;
@@ -3056,38 +3030,37 @@ static void ieee80211_rx_mgmt_action(struct
net_device *dev,
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.addba_req)))
 				break;
-			ieee80211_sta_process_addba_request(dev, mgmt, len);
+			ieee80211_sta_process_addba_request(local, mgmt, len);
 			break;
 		case WLAN_ACTION_ADDBA_RESP:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.addba_resp)))
 				break;
-			ieee80211_sta_process_addba_resp(dev, mgmt, len);
+			ieee80211_sta_process_addba_resp(local, mgmt, len);
 			break;
 		case WLAN_ACTION_DELBA:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.delba)))
 				break;
-			ieee80211_sta_process_delba(dev, mgmt, len);
+			ieee80211_sta_process_delba(sdata, mgmt, len);
 			break;
 		}
 		break;
 	case PLINK_CATEGORY:
 		if (ieee80211_vif_is_mesh(&sdata->vif))
-			mesh_rx_plink_frame(dev, mgmt, len, rx_status);
+			mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
 		break;
 	case MESH_PATH_SEL_CATEGORY:
 		if (ieee80211_vif_is_mesh(&sdata->vif))
-			mesh_rx_path_sel_frame(dev, mgmt, len);
+			mesh_rx_path_sel_frame(sdata, mgmt, len);
 		break;
 	}
 }
 
-void ieee80211_sta_rx_mgmt(struct net_device *dev, struct sk_buff *skb,
+void ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct
sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_sta *ifsta;
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
@@ -3095,7 +3068,6 @@ void ieee80211_sta_rx_mgmt(struct net_device *dev,
struct sk_buff *skb,
 	if (skb->len < 24)
 		goto fail;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ifsta = &sdata->u.sta;
 
 	mgmt = (struct ieee80211_mgmt *) skb->data;
@@ -3122,16 +3094,14 @@ void ieee80211_sta_rx_mgmt(struct net_device
*dev, struct sk_buff *skb,
 }
 
 
-static void ieee80211_sta_rx_queued_mgmt(struct net_device *dev,
+static void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data
*sdata,
 					 struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status;
-	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_sta *ifsta;
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ifsta = &sdata->u.sta;
 
 	rx_status = (struct ieee80211_rx_status *) skb->cb;
@@ -3140,17 +3110,17 @@ static void ieee80211_sta_rx_queued_mgmt(struct
net_device *dev,
 
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_PROBE_REQ:
-		ieee80211_rx_mgmt_probe_req(dev, ifsta, mgmt, skb->len,
+		ieee80211_rx_mgmt_probe_req(sdata, ifsta, mgmt, skb->len,
 					    rx_status);
 		break;
 	case IEEE80211_STYPE_PROBE_RESP:
-		ieee80211_rx_mgmt_probe_resp(dev, mgmt, skb->len, rx_status);
+		ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len, rx_status);
 		break;
 	case IEEE80211_STYPE_BEACON:
-		ieee80211_rx_mgmt_beacon(dev, mgmt, skb->len, rx_status);
+		ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len, rx_status);
 		break;
 	case IEEE80211_STYPE_AUTH:
-		ieee80211_rx_mgmt_auth(dev, ifsta, mgmt, skb->len);
+		ieee80211_rx_mgmt_auth(sdata, ifsta, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_ASSOC_RESP:
 		ieee80211_rx_mgmt_assoc_resp(sdata, ifsta, mgmt, skb->len, 0);
@@ -3159,13 +3129,13 @@ static void ieee80211_sta_rx_queued_mgmt(struct
net_device *dev,
 		ieee80211_rx_mgmt_assoc_resp(sdata, ifsta, mgmt, skb->len, 1);
 		break;
 	case IEEE80211_STYPE_DEAUTH:
-		ieee80211_rx_mgmt_deauth(dev, ifsta, mgmt, skb->len);
+		ieee80211_rx_mgmt_deauth(sdata, ifsta, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_DISASSOC:
-		ieee80211_rx_mgmt_disassoc(dev, ifsta, mgmt, skb->len);
+		ieee80211_rx_mgmt_disassoc(sdata, ifsta, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_ACTION:
-		ieee80211_rx_mgmt_action(dev, ifsta, mgmt, skb->len, rx_status);
+		ieee80211_rx_mgmt_action(sdata, ifsta, mgmt, skb->len, rx_status);
 		break;
 	}
 
@@ -3174,7 +3144,7 @@ static void ieee80211_sta_rx_queued_mgmt(struct
net_device *dev,
 
 
 ieee80211_rx_result
-ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
+ieee80211_sta_rx_scan(struct ieee80211_sub_if_data *sdata, struct
sk_buff *skb,
 		      struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_mgmt *mgmt;
@@ -3193,13 +3163,13 @@ ieee80211_sta_rx_scan(struct net_device *dev,
struct sk_buff *skb,
 		return RX_DROP_MONITOR;
 
 	if (ieee80211_is_probe_resp(fc)) {
-		ieee80211_rx_mgmt_probe_resp(dev, mgmt, skb->len, rx_status);
+		ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len, rx_status);
 		dev_kfree_skb(skb);
 		return RX_QUEUED;
 	}
 
 	if (ieee80211_is_beacon(fc)) {
-		ieee80211_rx_mgmt_beacon(dev, mgmt, skb->len, rx_status);
+		ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len, rx_status);
 		dev_kfree_skb(skb);
 		return RX_QUEUED;
 	}
@@ -3208,12 +3178,11 @@ ieee80211_sta_rx_scan(struct net_device *dev,
struct sk_buff *skb,
 }
 
 
-static int ieee80211_sta_active_ibss(struct net_device *dev)
+static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data
*sdata)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	int active = 0;
 	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	rcu_read_lock();
 
@@ -3232,9 +3201,9 @@ static int ieee80211_sta_active_ibss(struct
net_device *dev)
 }
 
 
-static void ieee80211_sta_expire(struct net_device *dev, unsigned long
exp_time)
+static void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
unsigned long exp_time)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta, *tmp;
 	LIST_HEAD(tmp_list);
 	DECLARE_MAC_BUF(mac);
@@ -3245,7 +3214,7 @@ static void ieee80211_sta_expire(struct net_device
*dev, unsigned long exp_time)
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 			printk(KERN_DEBUG "%s: expiring inactive STA %s\n",
-			       dev->name, print_mac(mac, sta->addr));
+			       sdata->dev->name, print_mac(mac, sta->addr));
 #endif
 			__sta_info_unlink(&sta);
 			if (sta)
@@ -3258,30 +3227,29 @@ static void ieee80211_sta_expire(struct
net_device *dev, unsigned long exp_time)
 }
 
 
-static void ieee80211_sta_merge_ibss(struct net_device *dev,
+static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data
*sdata,
 				     struct ieee80211_if_sta *ifsta)
 {
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
 
-	ieee80211_sta_expire(dev, IEEE80211_IBSS_INACTIVITY_LIMIT);
-	if (ieee80211_sta_active_ibss(dev))
+	ieee80211_sta_expire(sdata, IEEE80211_IBSS_INACTIVITY_LIMIT);
+	if (ieee80211_sta_active_ibss(sdata))
 		return;
 
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other
"
-	       "IBSS networks with same SSID (merge)\n", dev->name);
-	ieee80211_sta_req_scan(dev, ifsta->ssid, ifsta->ssid_len);
+	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
+	ieee80211_sta_req_scan(sdata, ifsta->ssid, ifsta->ssid_len);
 }
 
 
 #ifdef CONFIG_MAC80211_MESH
-static void ieee80211_mesh_housekeeping(struct net_device *dev,
+static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data
*sdata,
 			   struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	bool free_plinks;
 
-	ieee80211_sta_expire(dev, IEEE80211_MESH_PEER_INACTIVITY_LIMIT);
-	mesh_path_expire(dev);
+	ieee80211_sta_expire(sdata, IEEE80211_MESH_PEER_INACTIVITY_LIMIT);
+	mesh_path_expire(sdata);
 
 	free_plinks = mesh_plink_availables(sdata);
 	if (free_plinks != sdata->u.sta.accepting_plinks)
@@ -3292,10 +3260,9 @@ static void ieee80211_mesh_housekeeping(struct
net_device *dev,
 }
 
 
-void ieee80211_start_mesh(struct net_device *dev)
+void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_sta *ifsta;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ifsta = &sdata->u.sta;
 	ifsta->state = IEEE80211_MESH_UP;
 	ieee80211_sta_timer((unsigned long)sdata);
@@ -3309,7 +3276,7 @@ void ieee80211_sta_timer(unsigned long data)
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct ieee80211_local *local = wdev_priv(&sdata->wdev);
+	struct ieee80211_local *local = sdata->local;
 
 	set_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
 	queue_work(local->hw.workqueue, &ifsta->work);
@@ -3319,12 +3286,11 @@ void ieee80211_sta_work(struct work_struct
*work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data, u.sta.work);
-	struct net_device *dev = sdata->dev;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_sta *ifsta;
 	struct sk_buff *skb;
 
-	if (!netif_running(dev))
+	if (!netif_running(sdata->dev))
 		return;
 
 	if (local->sta_sw_scanning || local->sta_hw_scanning)
@@ -3337,27 +3303,27 @@ void ieee80211_sta_work(struct work_struct
*work)
 	ifsta = &sdata->u.sta;
 
 	while ((skb = skb_dequeue(&ifsta->skb_queue)))
-		ieee80211_sta_rx_queued_mgmt(dev, skb);
+		ieee80211_sta_rx_queued_mgmt(sdata, skb);
 
 #ifdef CONFIG_MAC80211_MESH
 	if (ifsta->preq_queue_len &&
 	    time_after(jiffies,
 		       ifsta->last_preq +
msecs_to_jiffies(ifsta->mshcfg.dot11MeshHWMPpreqMinInterval)))
-		mesh_path_start_discovery(dev);
+		mesh_path_start_discovery(sdata);
 #endif
 
 	if (ifsta->state != IEEE80211_AUTHENTICATE &&
 	    ifsta->state != IEEE80211_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
 		if (ifsta->scan_ssid_len)
-			ieee80211_sta_start_scan(dev, ifsta->scan_ssid,
ifsta->scan_ssid_len);
+			ieee80211_sta_start_scan(sdata, ifsta->scan_ssid,
ifsta->scan_ssid_len);
 		else
-			ieee80211_sta_start_scan(dev, NULL, 0);
+			ieee80211_sta_start_scan(sdata, NULL, 0);
 		return;
 	}
 
 	if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request)) {
-		if (ieee80211_sta_config_auth(dev, ifsta))
+		if (ieee80211_sta_config_auth(sdata, ifsta))
 			return;
 		clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
 	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN,
&ifsta->request))
@@ -3367,23 +3333,23 @@ void ieee80211_sta_work(struct work_struct
*work)
 	case IEEE80211_DISABLED:
 		break;
 	case IEEE80211_AUTHENTICATE:
-		ieee80211_authenticate(dev, ifsta);
+		ieee80211_authenticate(sdata, ifsta);
 		break;
 	case IEEE80211_ASSOCIATE:
-		ieee80211_associate(dev, ifsta);
+		ieee80211_associate(sdata, ifsta);
 		break;
 	case IEEE80211_ASSOCIATED:
-		ieee80211_associated(dev, ifsta);
+		ieee80211_associated(sdata, ifsta);
 		break;
 	case IEEE80211_IBSS_SEARCH:
-		ieee80211_sta_find_ibss(dev, ifsta);
+		ieee80211_sta_find_ibss(sdata, ifsta);
 		break;
 	case IEEE80211_IBSS_JOINED:
-		ieee80211_sta_merge_ibss(dev, ifsta);
+		ieee80211_sta_merge_ibss(sdata, ifsta);
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case IEEE80211_MESH_UP:
-		ieee80211_mesh_housekeeping(dev, ifsta);
+		ieee80211_mesh_housekeeping(sdata, ifsta);
 		break;
 #endif
 	default:
@@ -3391,20 +3357,20 @@ void ieee80211_sta_work(struct work_struct
*work)
 		break;
 	}
 
-	if (ieee80211_privacy_mismatch(dev, ifsta)) {
+	if (ieee80211_privacy_mismatch(sdata, ifsta)) {
 		printk(KERN_DEBUG "%s: privacy configuration mismatch and "
-		       "mixed-cell disabled - disassociate\n", dev->name);
+		       "mixed-cell disabled - disassociate\n", sdata->dev->name);
 
-		ieee80211_send_disassoc(dev, ifsta, WLAN_REASON_UNSPECIFIED);
-		ieee80211_set_disassoc(dev, ifsta, 0);
+		ieee80211_send_disassoc(sdata, ifsta, WLAN_REASON_UNSPECIFIED);
+		ieee80211_set_disassoc(sdata, ifsta, 0);
 	}
 }
 
 
-static void ieee80211_sta_reset_auth(struct net_device *dev,
+static void ieee80211_sta_reset_auth(struct ieee80211_sub_if_data
*sdata,
 				     struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 
 	if (local->ops->reset_tsf) {
 		/* Reset own TSF to allow time synchronization work. */
@@ -3425,15 +3391,14 @@ static void ieee80211_sta_reset_auth(struct
net_device *dev,
 	ifsta->auth_transaction = -1;
 	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
 	ifsta->auth_tries = ifsta->assoc_tries = 0;
-	netif_carrier_off(dev);
+	netif_carrier_off(sdata->dev);
 }
 
 
-void ieee80211_sta_req_auth(struct net_device *dev,
+void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 		return;
@@ -3477,11 +3442,10 @@ static int ieee80211_sta_match_ssid(struct
ieee80211_if_sta *ifsta,
 	return 0;
 }
 
-static int ieee80211_sta_config_auth(struct net_device *dev,
+static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data
*sdata,
 				     struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sta_bss *bss, *selected = NULL;
 	int top_rssi = 0, freq;
 
@@ -3520,22 +3484,22 @@ static int ieee80211_sta_config_auth(struct
net_device *dev,
 	spin_unlock_bh(&local->sta_bss_lock);
 
 	if (selected) {
-		ieee80211_set_freq(dev, selected->freq);
+		ieee80211_set_freq(sdata, selected->freq);
 		if (!(ifsta->flags & IEEE80211_STA_SSID_SET))
-			ieee80211_sta_set_ssid(dev, selected->ssid,
+			ieee80211_sta_set_ssid(sdata, selected->ssid,
 					       selected->ssid_len);
-		ieee80211_sta_set_bssid(dev, selected->bssid);
-		ieee80211_sta_def_wmm_params(dev, selected, 0);
+		ieee80211_sta_set_bssid(sdata, selected->bssid);
+		ieee80211_sta_def_wmm_params(sdata, selected, 0);
 		ieee80211_rx_bss_put(local, selected);
 		ifsta->state = IEEE80211_AUTHENTICATE;
-		ieee80211_sta_reset_auth(dev, ifsta);
+		ieee80211_sta_reset_auth(sdata, ifsta);
 		return 0;
 	} else {
 		if (ifsta->state != IEEE80211_AUTHENTICATE) {
 			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
-				ieee80211_sta_start_scan(dev, NULL, 0);
+				ieee80211_sta_start_scan(sdata, NULL, 0);
 			else
-				ieee80211_sta_start_scan(dev, ifsta->ssid,
+				ieee80211_sta_start_scan(sdata, ifsta->ssid,
 							 ifsta->ssid_len);
 			ifsta->state = IEEE80211_AUTHENTICATE;
 			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
@@ -3546,12 +3510,11 @@ static int ieee80211_sta_config_auth(struct
net_device *dev,
 }
 
 
-static int ieee80211_sta_create_ibss(struct net_device *dev,
+static int ieee80211_sta_create_ibss(struct ieee80211_sub_if_data
*sdata,
 				     struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sta_bss *bss;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_supported_band *sband;
 	u8 bssid[ETH_ALEN], *pos;
 	int i;
@@ -3567,15 +3530,15 @@ static int ieee80211_sta_create_ibss(struct
net_device *dev,
 	 * random number generator get different BSSID. */
 	get_random_bytes(bssid, ETH_ALEN);
 	for (i = 0; i < ETH_ALEN; i++)
-		bssid[i] ^= dev->dev_addr[i];
+		bssid[i] ^= sdata->dev->dev_addr[i];
 	bssid[0] &= ~0x01;
 	bssid[0] |= 0x02;
 #endif
 
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %s\n",
-	       dev->name, print_mac(mac, bssid));
+	       sdata->dev->name, print_mac(mac, bssid));
 
-	bss = ieee80211_rx_bss_add(dev, bssid,
+	bss = ieee80211_rx_bss_add(sdata, bssid,
 				   local->hw.conf.channel->center_freq,
 				   sdata->u.sta.ssid, sdata->u.sta.ssid_len);
 	if (!bss)
@@ -3602,16 +3565,16 @@ static int ieee80211_sta_create_ibss(struct
net_device *dev,
 		*pos++ = (u8) (rate / 5);
 	}
 
-	ret = ieee80211_sta_join_ibss(dev, ifsta, bss);
+	ret = ieee80211_sta_join_ibss(sdata, ifsta, bss);
 	ieee80211_rx_bss_put(local, bss);
 	return ret;
 }
 
 
-static int ieee80211_sta_find_ibss(struct net_device *dev,
+static int ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sta_bss *bss;
 	int found = 0;
 	u8 bssid[ETH_ALEN];
@@ -3622,10 +3585,10 @@ static int ieee80211_sta_find_ibss(struct
net_device *dev,
 	if (ifsta->ssid_len == 0)
 		return -EINVAL;
 
-	active_ibss = ieee80211_sta_active_ibss(dev);
+	active_ibss = ieee80211_sta_active_ibss(sdata);
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "%s: sta_find_ibss (active_ibss=%d)\n",
-	       dev->name, active_ibss);
+	       sdata->dev->name, active_ibss);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	spin_lock_bh(&local->sta_bss_lock);
 	list_for_each_entry(bss, &local->sta_bss_list, list) {
@@ -3651,14 +3614,14 @@ static int ieee80211_sta_find_ibss(struct
net_device *dev,
 		       print_mac(mac2, ifsta->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
-	    (bss = ieee80211_rx_bss_get(dev, bssid,
+	    (bss = ieee80211_rx_bss_get(local, bssid,
 					local->hw.conf.channel->center_freq,
 					ifsta->ssid, ifsta->ssid_len))) {
 		int ret;
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %s"
 		       " based on configured SSID\n",
-		       dev->name, print_mac(mac, bssid));
-		ret = ieee80211_sta_join_ibss(dev, ifsta, bss);
+		       sdata->dev->name, print_mac(mac, bssid));
+		ret = ieee80211_sta_join_ibss(sdata, ifsta, bss);
 		ieee80211_rx_bss_put(local, bss);
 		return ret;
 	}
@@ -3668,14 +3631,14 @@ static int ieee80211_sta_find_ibss(struct
net_device *dev,
 
 	/* Selected IBSS not found in current scan results - try to scan */
 	if (ifsta->state == IEEE80211_IBSS_JOINED &&
-	    !ieee80211_sta_active_ibss(dev)) {
+	    !ieee80211_sta_active_ibss(sdata)) {
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_IBSS_MERGE_INTERVAL);
 	} else if (time_after(jiffies, local->last_scan_completed +
 			      IEEE80211_SCAN_INTERVAL)) {
 		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
-		       "join\n", dev->name);
-		return ieee80211_sta_req_scan(dev, ifsta->ssid,
+		       "join\n", sdata->dev->name);
+		return ieee80211_sta_req_scan(sdata, ifsta->ssid,
 					      ifsta->ssid_len);
 	} else if (ifsta->state != IEEE80211_IBSS_JOINED) {
 		int interval = IEEE80211_SCAN_INTERVAL;
@@ -3685,10 +3648,10 @@ static int ieee80211_sta_find_ibss(struct
net_device *dev,
 			if ((ifsta->flags & IEEE80211_STA_CREATE_IBSS) &&
 			    (!(local->oper_channel->flags &
 					IEEE80211_CHAN_NO_IBSS)))
-				return ieee80211_sta_create_ibss(dev, ifsta);
+				return ieee80211_sta_create_ibss(sdata, ifsta);
 			if (ifsta->flags & IEEE80211_STA_CREATE_IBSS) {
 				printk(KERN_DEBUG "%s: IBSS not allowed on"
-				       " %d MHz\n", dev->name,
+				       " %d MHz\n", sdata->dev->name,
 				       local->hw.conf.channel->center_freq);
 			}
 
@@ -3706,9 +3669,8 @@ static int ieee80211_sta_find_ibss(struct
net_device *dev,
 }
 
 
-int ieee80211_sta_set_ssid(struct net_device *dev, char *ssid, size_t
len)
+int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char
*ssid, size_t len)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta;
 	int res;
 
@@ -3732,7 +3694,7 @@ int ieee80211_sta_set_ssid(struct net_device *dev,
char *ssid, size_t len)
 			res = ieee80211_if_config(sdata, IEEE80211_IFCC_SSID);
 		if (res) {
 			printk(KERN_DEBUG "%s: Failed to config new SSID to "
-			       "the low-level driver\n", dev->name);
+			       "the low-level driver\n", sdata->dev->name);
 			return res;
 		}
 	}
@@ -3746,16 +3708,15 @@ int ieee80211_sta_set_ssid(struct net_device
*dev, char *ssid, size_t len)
 	    !(ifsta->flags & IEEE80211_STA_BSSID_SET)) {
 		ifsta->ibss_join_req = jiffies;
 		ifsta->state = IEEE80211_IBSS_SEARCH;
-		return ieee80211_sta_find_ibss(dev, ifsta);
+		return ieee80211_sta_find_ibss(sdata, ifsta);
 	}
 
 	return 0;
 }
 
 
-int ieee80211_sta_get_ssid(struct net_device *dev, char *ssid, size_t
*len)
+int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char
*ssid, size_t *len)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	memcpy(ssid, ifsta->ssid, ifsta->ssid_len);
 	*len = ifsta->ssid_len;
@@ -3763,13 +3724,11 @@ int ieee80211_sta_get_ssid(struct net_device
*dev, char *ssid, size_t *len)
 }
 
 
-int ieee80211_sta_set_bssid(struct net_device *dev, u8 *bssid)
+int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8
*bssid)
 {
-	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_sta *ifsta;
 	int res;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ifsta = &sdata->u.sta;
 
 	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
@@ -3782,7 +3741,7 @@ int ieee80211_sta_set_bssid(struct net_device
*dev, u8 *bssid)
 			res = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
 		if (res) {
 			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
-			       "the low-level driver\n", dev->name);
+			       "the low-level driver\n", sdata->dev->name);
 			return res;
 		}
 	}
@@ -3823,7 +3782,7 @@ static void ieee80211_send_nullfunc(struct
ieee80211_local *local,
 	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->u.sta.bssid, ETH_ALEN);
 
-	ieee80211_sta_tx(sdata->dev, skb, 0);
+	ieee80211_sta_tx(sdata, skb, 0);
 }
 
 
@@ -3896,8 +3855,8 @@ done:
 		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
 		    (!ifsta->state == IEEE80211_IBSS_JOINED &&
-		    !ieee80211_sta_active_ibss(dev)))
-			ieee80211_sta_find_ibss(dev, ifsta);
+		    !ieee80211_sta_active_ibss(sdata)))
+			ieee80211_sta_find_ibss(sdata, ifsta);
 	}
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
@@ -3986,7 +3945,7 @@ void ieee80211_sta_scan_work(struct work_struct
*work)
 
 		if (local->scan_channel->flags & IEEE80211_CHAN_PASSIVE_SCAN)
 			break;
-		ieee80211_send_probe_req(dev, NULL, local->scan_ssid,
+		ieee80211_send_probe_req(sdata, NULL, local->scan_ssid,
 					 local->scan_ssid_len);
 		next_delay = IEEE80211_CHANNEL_TIME;
 		break;
@@ -3998,10 +3957,10 @@ void ieee80211_sta_scan_work(struct work_struct
*work)
 }
 
 
-static int ieee80211_sta_start_scan(struct net_device *dev,
+static int ieee80211_sta_start_scan(struct ieee80211_sub_if_data
*scan_sdata,
 				    u8 *ssid, size_t ssid_len)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = scan_sdata->local;
 	struct ieee80211_sub_if_data *sdata;
 
 	if (ssid_len > IEEE80211_MAX_SSID_LEN)
@@ -4025,7 +3984,7 @@ static int ieee80211_sta_start_scan(struct
net_device *dev,
 	 */
 
 	if (local->sta_sw_scanning || local->sta_hw_scanning) {
-		if (local->scan_dev == dev)
+		if (local->scan_dev == scan_sdata->dev)
 			return 0;
 		return -EBUSY;
 	}
@@ -4035,7 +3994,7 @@ static int ieee80211_sta_start_scan(struct
net_device *dev,
 					     ssid, ssid_len);
 		if (!rc) {
 			local->sta_hw_scanning = 1;
-			local->scan_dev = dev;
+			local->scan_dev = scan_sdata->dev;
 		}
 		return rc;
 	}
@@ -4059,7 +4018,7 @@ static int ieee80211_sta_start_scan(struct
net_device *dev,
 	local->scan_state = SCAN_SET_CHANNEL;
 	local->scan_channel_idx = 0;
 	local->scan_band = IEEE80211_BAND_2GHZ;
-	local->scan_dev = dev;
+	local->scan_dev = scan_sdata->dev;
 
 	netif_addr_lock_bh(local->mdev);
 	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
@@ -4078,17 +4037,16 @@ static int ieee80211_sta_start_scan(struct
net_device *dev,
 }
 
 
-int ieee80211_sta_req_scan(struct net_device *dev, u8 *ssid, size_t
ssid_len)
+int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8
*ssid, size_t ssid_len)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
-		return ieee80211_sta_start_scan(dev, ssid, ssid_len);
+		return ieee80211_sta_start_scan(sdata, ssid, ssid_len);
 
 	if (local->sta_sw_scanning || local->sta_hw_scanning) {
-		if (local->scan_dev == dev)
+		if (local->scan_dev == sdata->dev)
 			return 0;
 		return -EBUSY;
 	}
@@ -4102,12 +4060,11 @@ int ieee80211_sta_req_scan(struct net_device
*dev, u8 *ssid, size_t ssid_len)
 }
 
 static char *
-ieee80211_sta_scan_result(struct net_device *dev,
+ieee80211_sta_scan_result(struct ieee80211_local *local,
 			  struct iw_request_info *info,
 			  struct ieee80211_sta_bss *bss,
 			  char *current_ev, char *end_buf)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct iw_event iwe;
 
 	if (time_after(jiffies,
@@ -4294,11 +4251,10 @@ ieee80211_sta_scan_result(struct net_device
*dev,
 }
 
 
-int ieee80211_sta_scan_results(struct net_device *dev,
+int ieee80211_sta_scan_results(struct ieee80211_local *local,
 			       struct iw_request_info *info,
 			       char *buf, size_t len)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	char *current_ev = buf;
 	char *end_buf = buf + len;
 	struct ieee80211_sta_bss *bss;
@@ -4309,7 +4265,7 @@ int ieee80211_sta_scan_results(struct net_device
*dev,
 			spin_unlock_bh(&local->sta_bss_lock);
 			return -E2BIG;
 		}
-		current_ev = ieee80211_sta_scan_result(dev, info, bss,
+		current_ev = ieee80211_sta_scan_result(local, info, bss,
 						       current_ev, end_buf);
 	}
 	spin_unlock_bh(&local->sta_bss_lock);
@@ -4317,9 +4273,8 @@ int ieee80211_sta_scan_results(struct net_device
*dev,
 }
 
 
-int ieee80211_sta_set_extra_ie(struct net_device *dev, char *ie, size_t
len)
+int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata,
char *ie, size_t len)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 
 	kfree(ifsta->extra_ie);
@@ -4339,13 +4294,12 @@ int ieee80211_sta_set_extra_ie(struct net_device
*dev, char *ie, size_t len)
 }
 
 
-struct sta_info *ieee80211_ibss_add_sta(struct net_device *dev,
+struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data
*sdata,
 					struct sk_buff *skb, u8 *bssid,
 					u8 *addr, u64 supp_rates)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	DECLARE_MAC_BUF(mac);
 	int band = local->hw.conf.channel->band;
 
@@ -4354,7 +4308,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct
net_device *dev,
 	if (local->num_sta >= IEEE80211_IBSS_MAX_STA_ENTRIES) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: No room for a new IBSS STA "
-			       "entry %s\n", dev->name, print_mac(mac, addr));
+			       "entry %s\n", sdata->dev->name, print_mac(mac, addr));
 		}
 		return NULL;
 	}
@@ -4364,7 +4318,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct
net_device *dev,
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Adding new IBSS station %s (dev=%s)\n",
-	       wiphy_name(local->hw.wiphy), print_mac(mac, addr), dev->name);
+	       wiphy_name(local->hw.wiphy), print_mac(mac, addr),
sdata->dev->name);
 #endif
 
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
@@ -4387,31 +4341,29 @@ struct sta_info *ieee80211_ibss_add_sta(struct
net_device *dev,
 }
 
 
-int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason)
+int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata,
u16 reason)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 
 	printk(KERN_DEBUG "%s: deauthenticating by local choice (reason=%
d)\n",
-	       dev->name, reason);
+	       sdata->dev->name, reason);
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
 	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 		return -EINVAL;
 
-	ieee80211_send_deauth(dev, ifsta, reason);
-	ieee80211_set_disassoc(dev, ifsta, 1);
+	ieee80211_send_deauth(sdata, ifsta, reason);
+	ieee80211_set_disassoc(sdata, ifsta, 1);
 	return 0;
 }
 
 
-int ieee80211_sta_disassociate(struct net_device *dev, u16 reason)
+int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16
reason)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 
 	printk(KERN_DEBUG "%s: disassociating by local choice (reason=%d)\n",
-	       dev->name, reason);
+	       sdata->dev->name, reason);
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 		return -EINVAL;
@@ -4419,8 +4371,8 @@ int ieee80211_sta_disassociate(struct net_device
*dev, u16 reason)
 	if (!(ifsta->flags & IEEE80211_STA_ASSOCIATED))
 		return -1;
 
-	ieee80211_send_disassoc(dev, ifsta, reason);
-	ieee80211_set_disassoc(dev, ifsta, 0);
+	ieee80211_send_disassoc(sdata, ifsta, reason);
+	ieee80211_set_disassoc(sdata, ifsta, 0);
 	return 0;
 }
 
@@ -4437,7 +4389,7 @@ void ieee80211_notify_mac(struct ieee80211_hw *hw,
 			if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 				continue;
 
-			ieee80211_sta_req_auth(sdata->dev, &sdata->u.sta);
+			ieee80211_sta_req_auth(sdata, &sdata->u.sta);
 		}
 		rcu_read_unlock();
 		break;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6d9ae67..1520e46 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -399,11 +399,11 @@ ieee80211_rx_h_passive_scan(struct
ieee80211_rx_data *rx)
 	struct sk_buff *skb = rx->skb;
 
 	if (unlikely(local->sta_hw_scanning))
-		return ieee80211_sta_rx_scan(rx->dev, skb, rx->status);
+		return ieee80211_sta_rx_scan(rx->sdata, skb, rx->status);
 
 	if (unlikely(local->sta_sw_scanning)) {
 		/* drop all the other packets during a software scan anyway */
-		if (ieee80211_sta_rx_scan(rx->dev, skb, rx->status)
+		if (ieee80211_sta_rx_scan(rx->sdata, skb, rx->status)
 		    != RX_QUEUED)
 			dev_kfree_skb(skb);
 		return RX_QUEUED;
@@ -461,7 +461,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data
*rx)
 
 	if (ieee80211_is_data(hdr->frame_control) &&
 	    is_multicast_ether_addr(hdr->addr1) &&
-	    mesh_rmc_check(hdr->addr4, msh_h_get(hdr, hdrlen), rx->dev))
+	    mesh_rmc_check(hdr->addr4, msh_h_get(hdr, hdrlen), rx->sdata))
 		return RX_DROP_MONITOR;
 #undef msh_h_get
 
@@ -1518,7 +1518,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 	     sdata->vif.type == IEEE80211_IF_TYPE_IBSS ||
 	     sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) &&
 	    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
-		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->status);
+		ieee80211_sta_rx_mgmt(sdata, rx->skb, rx->status);
 	else
 		return RX_DROP_MONITOR;
 
@@ -1565,7 +1565,7 @@ static void ieee80211_rx_michael_mic_report(struct
net_device *dev,
 	    !ieee80211_is_auth(hdr->frame_control))
 		goto ignore;
 
-	mac80211_ev_michael_mic_failure(rx->dev, keyidx, hdr);
+	mac80211_ev_michael_mic_failure(rx->sdata, keyidx, hdr);
  ignore:
 	dev_kfree_skb(rx->skb);
 	rx->skb = NULL;
@@ -1735,7 +1735,7 @@ static int prepare_for_handlers(struct
ieee80211_sub_if_data *sdata,
 			return 0;
 		if (ieee80211_is_beacon(hdr->frame_control)) {
 			if (!rx->sta)
-				rx->sta = ieee80211_ibss_add_sta(sdata->dev,
+				rx->sta = ieee80211_ibss_add_sta(sdata,
 						rx->skb, bssid, hdr->addr2,
 						BIT(rx->status->rate_idx));
 			return 1;
@@ -1751,7 +1751,7 @@ static int prepare_for_handlers(struct
ieee80211_sub_if_data *sdata,
 				return 0;
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!rx->sta)
-			rx->sta = ieee80211_ibss_add_sta(sdata->dev, rx->skb,
+			rx->sta = ieee80211_ibss_add_sta(sdata, rx->skb,
 						bssid, hdr->addr2,
 						BIT(rx->status->rate_idx));
 		break;
@@ -2062,7 +2062,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct
ieee80211_local *local,
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	if (sc & IEEE80211_SCTL_FRAG) {
-		ieee80211_sta_stop_rx_ba_session(sta->sdata->dev, sta->addr,
+		ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->addr,
 			tid, 0, WLAN_REASON_QSTA_REQUIRE_SETUP);
 		ret = 1;
 		goto end_reorder;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 69019e9..0b66294 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1472,7 +1472,7 @@ int ieee80211_subif_start_xmit(struct sk_buff
*skb,
 		/* RA TA DA SA */
 		if (is_multicast_ether_addr(skb->data))
 			memcpy(hdr.addr1, skb->data, ETH_ALEN);
-		else if (mesh_nexthop_lookup(hdr.addr1, skb, dev))
+		else if (mesh_nexthop_lookup(hdr.addr1, skb, sdata))
 				return 0;
 		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
 		memcpy(hdr.addr3, skb->data, ETH_ALEN);
@@ -1906,7 +1906,7 @@ struct sk_buff *ieee80211_beacon_get(struct
ieee80211_hw *hw,
 		*pos++ = WLAN_EID_SSID;
 		*pos++ = 0x0;
 
-		mesh_mgmt_ies_add(skb, sdata->dev);
+		mesh_mgmt_ies_add(skb, sdata);
 
 		num_beacons = &sdata->u.sta.num_beacons;
 	} else {
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 34fa8ed..d942948 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -27,22 +27,19 @@
 #include "aes_ccm.h"
 
 
-static int ieee80211_set_encryption(struct net_device *dev, u8
*sta_addr,
+static int ieee80211_set_encryption(struct ieee80211_sub_if_data
*sdata, u8 *sta_addr,
 				    int idx, int alg, int remove,
 				    int set_tx_key, const u8 *_key,
 				    size_t key_len)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct ieee80211_key *key;
-	struct ieee80211_sub_if_data *sdata;
 	int err;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
 	if (idx < 0 || idx >= NUM_DEFAULT_KEYS) {
 		printk(KERN_DEBUG "%s: set_encrypt - invalid idx=%d\n",
-		       dev->name, idx);
+		       sdata->dev->name, idx);
 		return -EINVAL;
 	}
 
@@ -127,11 +124,11 @@ static int ieee80211_ioctl_siwgenie(struct
net_device *dev,
 
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
 	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
-		int ret = ieee80211_sta_set_extra_ie(dev, extra, data->length);
+		int ret = ieee80211_sta_set_extra_ie(sdata, extra, data->length);
 		if (ret)
 			return ret;
 		sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
-		ieee80211_sta_req_auth(dev, &sdata->u.sta);
+		ieee80211_sta_req_auth(sdata, &sdata->u.sta);
 		return 0;
 	}
 
@@ -333,12 +330,11 @@ static int ieee80211_ioctl_giwmode(struct
net_device *dev,
 	return 0;
 }
 
-int ieee80211_set_freq(struct net_device *dev, int freqMHz)
+int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int
freqMHz)
 {
 	int ret = -EINVAL;
 	struct ieee80211_channel *chan;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 
 	chan = ieee80211_get_channel(local->hw.wiphy, freqMHz);
 
@@ -346,7 +342,7 @@ int ieee80211_set_freq(struct net_device *dev, int
freqMHz)
 		if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
 		    chan->flags & IEEE80211_CHAN_NO_IBSS) {
 			printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
-				"%d MHz\n", dev->name, chan->center_freq);
+				"%d MHz\n", sdata->dev->name, chan->center_freq);
 			return ret;
 		}
 		local->oper_channel = chan;
@@ -379,14 +375,14 @@ static int ieee80211_ioctl_siwfreq(struct
net_device *dev,
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
 			return 0;
 		} else
-			return ieee80211_set_freq(dev,
+			return ieee80211_set_freq(sdata,
 				ieee80211_channel_to_frequency(freq->m));
 	} else {
 		int i, div = 1000000;
 		for (i = 0; i < freq->e; i++)
 			div /= 10;
 		if (div > 0)
-			return ieee80211_set_freq(dev, freq->m / div);
+			return ieee80211_set_freq(sdata, freq->m / div);
 		else
 			return -EINVAL;
 	}
@@ -432,10 +428,10 @@ static int ieee80211_ioctl_siwessid(struct
net_device *dev,
 			sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
 		else
 			sdata->u.sta.flags |= IEEE80211_STA_AUTO_SSID_SEL;
-		ret = ieee80211_sta_set_ssid(dev, ssid, len);
+		ret = ieee80211_sta_set_ssid(sdata, ssid, len);
 		if (ret)
 			return ret;
-		ieee80211_sta_req_auth(dev, &sdata->u.sta);
+		ieee80211_sta_req_auth(sdata, &sdata->u.sta);
 		return 0;
 	}
 
@@ -460,7 +456,7 @@ static int ieee80211_ioctl_giwessid(struct
net_device *dev,
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
 	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
-		int res = ieee80211_sta_get_ssid(dev, ssid, &len);
+		int res = ieee80211_sta_get_ssid(sdata, ssid, &len);
 		if (res == 0) {
 			data->length = len;
 			data->flags = 1;
@@ -504,10 +500,10 @@ static int ieee80211_ioctl_siwap(struct net_device
*dev,
 			sdata->u.sta.flags |= IEEE80211_STA_AUTO_BSSID_SEL;
 		else
 			sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
-		ret = ieee80211_sta_set_bssid(dev, (u8 *) &ap_addr->sa_data);
+		ret = ieee80211_sta_set_bssid(sdata, (u8 *) &ap_addr->sa_data);
 		if (ret)
 			return ret;
-		ieee80211_sta_req_auth(dev, &sdata->u.sta);
+		ieee80211_sta_req_auth(sdata, &sdata->u.sta);
 		return 0;
 	} else if (sdata->vif.type == IEEE80211_IF_TYPE_WDS) {
 		/*
@@ -584,7 +580,7 @@ static int ieee80211_ioctl_siwscan(struct net_device
*dev,
 		ssid_len = req->essid_len;
 	}
 
-	return ieee80211_sta_req_scan(dev, ssid, ssid_len);
+	return ieee80211_sta_req_scan(sdata, ssid, ssid_len);
 }
 
 
@@ -594,11 +590,14 @@ static int ieee80211_ioctl_giwscan(struct
net_device *dev,
 {
 	int res;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (local->sta_sw_scanning || local->sta_hw_scanning)
 		return -EAGAIN;
 
-	res = ieee80211_sta_scan_results(dev, info, extra, data->length);
+	res = ieee80211_sta_scan_results(local, info, extra, data->length);
 	if (res >= 0) {
 		data->length = res;
 		return 0;
@@ -894,10 +893,10 @@ static int ieee80211_ioctl_siwmlme(struct
net_device *dev,
 	switch (mlme->cmd) {
 	case IW_MLME_DEAUTH:
 		/* TODO: mlme->addr.sa_data */
-		return ieee80211_sta_deauthenticate(dev, mlme->reason_code);
+		return ieee80211_sta_deauthenticate(sdata, mlme->reason_code);
 	case IW_MLME_DISASSOC:
 		/* TODO: mlme->addr.sa_data */
-		return ieee80211_sta_disassociate(dev, mlme->reason_code);
+		return ieee80211_sta_disassociate(sdata, mlme->reason_code);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -938,7 +937,7 @@ static int ieee80211_ioctl_siwencode(struct
net_device *dev,
 	}
 
 	return ieee80211_set_encryption(
-		dev, bcaddr,
+		sdata, bcaddr,
 		idx, alg, remove,
 		!sdata->default_key,
 		keybuf, erq->length);
@@ -1184,7 +1183,7 @@ static int ieee80211_ioctl_siwencodeext(struct
net_device *dev,
 	} else
 		idx--;
 
-	return ieee80211_set_encryption(dev, ext->addr.sa_data, idx, alg,
+	return ieee80211_set_encryption(sdata, ext->addr.sa_data, idx, alg,
 					remove,
 					ext->ext_flags &
 					IW_ENCODE_EXT_SET_TX_KEY,
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 2f33df0..7802178 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -127,7 +127,7 @@ ieee80211_rx_h_michael_mic_verify(struct
ieee80211_rx_data *rx)
 		if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 			return RX_DROP_UNUSABLE;
 
-		mac80211_ev_michael_mic_failure(rx->dev, rx->key->conf.keyidx,
+		mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
 						(void *) skb->data);
 		return RX_DROP_UNUSABLE;
 	}


