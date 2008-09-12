Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYILJGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 05:06:36 -0400
Subject: [PATCH] mac80211: remove beacon counters
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 11:05:39 +0200
Message-Id: <1221210339.11204.19.camel@johannes.berg> (sfid-20080912_110653_195295_B983A6B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon counters mac80211 keeps are only used for debugfs,
unfortunately, they are incorrect for many hardware designs,
namely any design that has a beacon template. Hence, remove the
counters so we don't create the impression they are usable.

This also allows removing the beacon MESH #ifdef again.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_netdev.c |    6 ------
 net/mac80211/ieee80211_i.h    |    5 -----
 net/mac80211/tx.c             |    9 ---------
 3 files changed, 20 deletions(-)

--- everything.orig/net/mac80211/tx.c	2008-09-12 11:01:48.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-12 11:02:31.000000000 +0200
@@ -1808,7 +1808,6 @@ struct sk_buff *ieee80211_beacon_get(str
 	struct rate_selection rsel;
 	struct beacon_data *beacon;
 	struct ieee80211_supported_band *sband;
-	int *num_beacons;
 	enum ieee80211_band band = local->hw.conf.channel->band;
 
 	sband = local->hw.wiphy->bands[band];
@@ -1856,8 +1855,6 @@ struct sk_buff *ieee80211_beacon_get(str
 			if (beacon->tail)
 				memcpy(skb_put(skb, beacon->tail_len),
 				       beacon->tail, beacon->tail_len);
-
-			num_beacons = &ap->num_beacons;
 		} else
 			goto out;
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
@@ -1875,8 +1872,6 @@ struct sk_buff *ieee80211_beacon_get(str
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_BEACON);
 
-		num_beacons = &ifsta->num_beacons;
-#ifdef CONFIG_MAC80211_MESH
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		struct ieee80211_mgmt *mgmt;
 		u8 *pos;
@@ -1904,9 +1899,6 @@ struct sk_buff *ieee80211_beacon_get(str
 		*pos++ = 0x0;
 
 		mesh_mgmt_ies_add(skb, sdata);
-
-		num_beacons = &sdata->u.mesh.num_beacons;
-#endif
 	} else {
 		WARN_ON(1);
 		goto out;
@@ -1943,7 +1935,6 @@ struct sk_buff *ieee80211_beacon_get(str
 	info->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
 	info->control.retry_limit = 1;
 
-	(*num_beacons)++;
 out:
 	rcu_read_unlock();
 	return skb;
--- everything.orig/net/mac80211/debugfs_netdev.c	2008-09-12 11:01:44.000000000 +0200
+++ everything/net/mac80211/debugfs_netdev.c	2008-09-12 11:01:59.000000000 +0200
@@ -173,7 +173,6 @@ IEEE80211_IF_FILE(assoc_tries, u.sta.ass
 IEEE80211_IF_FILE(auth_algs, u.sta.auth_algs, HEX);
 IEEE80211_IF_FILE(auth_alg, u.sta.auth_alg, DEC);
 IEEE80211_IF_FILE(auth_transaction, u.sta.auth_transaction, DEC);
-IEEE80211_IF_FILE(num_beacons_sta, u.sta.num_beacons, DEC);
 
 static ssize_t ieee80211_if_fmt_flags(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
@@ -192,7 +191,6 @@ __IEEE80211_IF_FILE(flags);
 /* AP attributes */
 IEEE80211_IF_FILE(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
 IEEE80211_IF_FILE(dtim_count, u.ap.dtim_count, DEC);
-IEEE80211_IF_FILE(num_beacons, u.ap.num_beacons, DEC);
 
 static ssize_t ieee80211_if_fmt_num_buffered_multicast(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
@@ -265,7 +263,6 @@ static void add_sta_files(struct ieee802
 	DEBUGFS_ADD(auth_alg, sta);
 	DEBUGFS_ADD(auth_transaction, sta);
 	DEBUGFS_ADD(flags, sta);
-	DEBUGFS_ADD(num_beacons_sta, sta);
 }
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
@@ -276,7 +273,6 @@ static void add_ap_files(struct ieee8021
 
 	DEBUGFS_ADD(num_sta_ps, ap);
 	DEBUGFS_ADD(dtim_count, ap);
-	DEBUGFS_ADD(num_beacons, ap);
 	DEBUGFS_ADD(num_buffered_multicast, ap);
 }
 
@@ -398,7 +394,6 @@ static void del_sta_files(struct ieee802
 	DEBUGFS_DEL(auth_alg, sta);
 	DEBUGFS_DEL(auth_transaction, sta);
 	DEBUGFS_DEL(flags, sta);
-	DEBUGFS_DEL(num_beacons_sta, sta);
 }
 
 static void del_ap_files(struct ieee80211_sub_if_data *sdata)
@@ -409,7 +404,6 @@ static void del_ap_files(struct ieee8021
 
 	DEBUGFS_DEL(num_sta_ps, ap);
 	DEBUGFS_DEL(dtim_count, ap);
-	DEBUGFS_DEL(num_beacons, ap);
 	DEBUGFS_DEL(num_buffered_multicast, ap);
 }
 
--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-12 11:01:44.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-12 11:01:59.000000000 +0200
@@ -229,7 +229,6 @@ struct ieee80211_if_ap {
 	struct sk_buff_head ps_bc_buf;
 	atomic_t num_sta_ps; /* number of stations in PS mode */
 	int dtim_count;
-	int num_beacons; /* number of TXed beacon frames for this BSS */
 };
 
 struct ieee80211_if_wds {
@@ -352,7 +351,6 @@ struct ieee80211_if_sta {
 	u32 supp_rates_bits[IEEE80211_NUM_BANDS];
 
 	int wmm_last_param_set;
-	int num_beacons; /* number of TXed beacon frames by this STA */
 };
 
 struct ieee80211_if_mesh {
@@ -388,7 +386,6 @@ struct ieee80211_if_mesh {
 	struct mesh_config mshcfg;
 	u32 mesh_seqnum;
 	bool accepting_plinks;
-	int num_beacons;
 };
 
 #ifdef CONFIG_MAC80211_MESH
@@ -484,7 +481,6 @@ struct ieee80211_sub_if_data {
 			struct dentry *auth_alg;
 			struct dentry *auth_transaction;
 			struct dentry *flags;
-			struct dentry *num_beacons_sta;
 			struct dentry *force_unicast_rateidx;
 			struct dentry *max_ratectrl_rateidx;
 		} sta;
@@ -492,7 +488,6 @@ struct ieee80211_sub_if_data {
 			struct dentry *drop_unencrypted;
 			struct dentry *num_sta_ps;
 			struct dentry *dtim_count;
-			struct dentry *num_beacons;
 			struct dentry *force_unicast_rateidx;
 			struct dentry *max_ratectrl_rateidx;
 			struct dentry *num_buffered_multicast;


