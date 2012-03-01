Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58328 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031010Ab2CAOWS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 09:22:18 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: use compare_ether_addr on MAC addresses instead of memcmp
Date: Thu,  1 Mar 2012 15:22:09 +0100
Message-Id: <1330611729-68484-2-git-send-email-nbd@openwrt.org> (sfid-20120301_152221_839044_3BB5D436)
In-Reply-To: <1330611729-68484-1-git-send-email-nbd@openwrt.org>
References: <1330611729-68484-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of the constant size and guaranteed 16 bit alignment, the inline
compare_ether_addr function is much cheaper than calling memcmp.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/ibss.c         |   10 +++++-----
 net/mac80211/mesh.c         |    2 +-
 net/mac80211/mesh_hwmp.c    |   19 +++++++++++--------
 net/mac80211/mesh_pathtbl.c |   14 ++++++++------
 net/mac80211/mlme.c         |   30 ++++++++++++++++--------------
 net/mac80211/rx.c           |    6 +++---
 net/mac80211/scan.c         |    3 ++-
 net/mac80211/sta_info.c     |    5 +++--
 net/mac80211/sta_info.h     |    3 ++-
 net/mac80211/status.c       |    3 ++-
 10 files changed, 53 insertions(+), 42 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 7f9ac57..33fd8d9 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -66,7 +66,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	skb_reset_tail_pointer(skb);
 	skb_reserve(skb, sdata->local->hw.extra_tx_headroom);
 
-	if (memcmp(ifibss->bssid, bssid, ETH_ALEN))
+	if (compare_ether_addr(ifibss->bssid, bssid))
 		sta_info_flush(sdata->local, sdata);
 
 	/* if merging, indicate to driver that we leave the old IBSS */
@@ -403,7 +403,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
-	    memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
+	    compare_ether_addr(mgmt->bssid, sdata->u.ibss.bssid) == 0) {
 
 		rcu_read_lock();
 		sta = sta_info_get(sdata, mgmt->sa);
@@ -508,7 +508,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		goto put_bss;
 
 	/* same BSSID */
-	if (memcmp(cbss->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0)
+	if (compare_ether_addr(cbss->bssid, sdata->u.ibss.bssid) == 0)
 		goto put_bss;
 
 	if (rx_status->flag & RX_FLAG_MACTIME_MPDU) {
@@ -831,8 +831,8 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 	if (!tx_last_beacon && is_multicast_ether_addr(mgmt->da))
 		return;
 
-	if (memcmp(mgmt->bssid, ifibss->bssid, ETH_ALEN) != 0 &&
-	    memcmp(mgmt->bssid, "\xff\xff\xff\xff\xff\xff", ETH_ALEN) != 0)
+	if (compare_ether_addr(mgmt->bssid, ifibss->bssid) != 0 &&
+	    !is_broadcast_ether_addr(mgmt->bssid))
 		return;
 
 	end = ((u8 *) mgmt) + len;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index c707c8b..e5fbb7c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -204,7 +204,7 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 			kmem_cache_free(rm_cache, p);
 			--entries;
 		} else if ((seqnum == p->seqnum) &&
-			   (memcmp(sa, p->sa, ETH_ALEN) == 0))
+			   (compare_ether_addr(sa, p->sa) == 0))
 			return -1;
 	}
 
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 31bc762..81f29f7 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/etherdevice.h>
 #include <asm/unaligned.h>
 #include "wme.h"
 #include "mesh.h"
@@ -419,7 +420,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 		new_metric = MAX_METRIC;
 	exp_time = TU_TO_EXP_TIME(orig_lifetime);
 
-	if (memcmp(orig_addr, sdata->vif.addr, ETH_ALEN) == 0) {
+	if (compare_ether_addr(orig_addr, sdata->vif.addr) == 0) {
 		/* This MP is the originator, we are not interested in this
 		 * frame, except for updating transmitter's path info.
 		 */
@@ -469,7 +470,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 
 	/* Update and check transmitter routing info */
 	ta = mgmt->sa;
-	if (memcmp(orig_addr, ta, ETH_ALEN) == 0)
+	if (compare_ether_addr(orig_addr, ta) == 0)
 		fresh_info = false;
 	else {
 		fresh_info = true;
@@ -529,7 +530,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	mhwmp_dbg("received PREQ from %pM", orig_addr);
 
-	if (memcmp(target_addr, sdata->vif.addr, ETH_ALEN) == 0) {
+	if (compare_ether_addr(target_addr, sdata->vif.addr) == 0) {
 		mhwmp_dbg("PREQ is for us");
 		forward = false;
 		reply = true;
@@ -624,7 +625,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	mhwmp_dbg("received PREP from %pM", PREP_IE_ORIG_ADDR(prep_elem));
 
 	orig_addr = PREP_IE_ORIG_ADDR(prep_elem);
-	if (memcmp(orig_addr, sdata->vif.addr, ETH_ALEN) == 0)
+	if (compare_ether_addr(orig_addr, sdata->vif.addr) == 0)
 		/* destination, no forwarding required */
 		return;
 
@@ -694,10 +695,12 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 	rcu_read_lock();
 	mpath = mesh_path_lookup(target_addr, sdata);
 	if (mpath) {
+		struct sta_info *sta;
+
 		spin_lock_bh(&mpath->state_lock);
+		sta = next_hop_deref_protected(mpath);
 		if (mpath->flags & MESH_PATH_ACTIVE &&
-		    memcmp(ta, next_hop_deref_protected(mpath)->sta.addr,
-							ETH_ALEN) == 0 &&
+		    compare_ether_addr(ta, sta->sta.addr) == 0 &&
 		    (!(mpath->flags & MESH_PATH_SN_VALID) ||
 		    SN_GT(target_sn, mpath->sn))) {
 			mpath->flags &= ~MESH_PATH_ACTIVE;
@@ -739,7 +742,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	metric = rann->rann_metric;
 
 	/*  Ignore our own RANNs */
-	if (memcmp(orig_addr, sdata->vif.addr, ETH_ALEN) == 0)
+	if (compare_ether_addr(orig_addr, sdata->vif.addr) == 0)
 		return;
 
 	mhwmp_dbg("received RANN from %pM (is_gate=%d)", orig_addr,
@@ -1064,7 +1067,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 	if (time_after(jiffies,
 		       mpath->exp_time -
 		       msecs_to_jiffies(sdata->u.mesh.mshcfg.path_refresh_time)) &&
-	    !memcmp(sdata->vif.addr, hdr->addr4, ETH_ALEN) &&
+	    !compare_ether_addr(sdata->vif.addr, hdr->addr4) &&
 	    !(mpath->flags & MESH_PATH_RESOLVING) &&
 	    !(mpath->flags & MESH_PATH_FIXED))
 		mesh_queue_preq(mpath, PREQ_Q_F_START | PREQ_Q_F_REFRESH);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index dc51669..157642f 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -348,7 +348,7 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, u8 *dst,
 	hlist_for_each_entry_rcu(node, n, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
-				memcmp(dst, mpath->dst, ETH_ALEN) == 0) {
+				compare_ether_addr(dst, mpath->dst) == 0) {
 			if (MPATH_EXPIRED(mpath)) {
 				spin_lock_bh(&mpath->state_lock);
 				mpath->flags &= ~MESH_PATH_ACTIVE;
@@ -523,7 +523,7 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	int err = 0;
 	u32 hash_idx;
 
-	if (memcmp(dst, sdata->vif.addr, ETH_ALEN) == 0)
+	if (compare_ether_addr(dst, sdata->vif.addr) == 0)
 		/* never add ourselves as neighbours */
 		return -ENOTSUPP;
 
@@ -564,7 +564,8 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	err = -EEXIST;
 	hlist_for_each_entry(node, n, bucket, list) {
 		mpath = node->mpath;
-		if (mpath->sdata == sdata && memcmp(dst, mpath->dst, ETH_ALEN) == 0)
+		if (mpath->sdata == sdata &&
+		    compare_ether_addr(dst, mpath->dst) == 0)
 			goto err_exists;
 	}
 
@@ -655,7 +656,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	int err = 0;
 	u32 hash_idx;
 
-	if (memcmp(dst, sdata->vif.addr, ETH_ALEN) == 0)
+	if (compare_ether_addr(dst, sdata->vif.addr) == 0)
 		/* never add ourselves as neighbours */
 		return -ENOTSUPP;
 
@@ -692,7 +693,8 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	err = -EEXIST;
 	hlist_for_each_entry(node, n, bucket, list) {
 		mpath = node->mpath;
-		if (mpath->sdata == sdata && memcmp(dst, mpath->dst, ETH_ALEN) == 0)
+		if (mpath->sdata == sdata &&
+		    compare_ether_addr(dst, mpath->dst) == 0)
 			goto err_exists;
 	}
 
@@ -886,7 +888,7 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 	hlist_for_each_entry(node, n, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
-		    memcmp(addr, mpath->dst, ETH_ALEN) == 0) {
+		    compare_ether_addr(addr, mpath->dst) == 0) {
 			__mesh_path_del(tbl, node);
 			goto enddel;
 		}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index caf97f5..05dd1bb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1822,7 +1822,7 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 
 	memcpy(bssid, ifmgd->auth_data->bss->bssid, ETH_ALEN);
 
-	if (memcmp(bssid, mgmt->bssid, ETH_ALEN))
+	if (compare_ether_addr(bssid, mgmt->bssid))
 		return RX_MGMT_NONE;
 
 	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
@@ -1903,7 +1903,7 @@ ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 		return RX_MGMT_NONE;
 
 	if (!ifmgd->associated ||
-	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN))
+	    compare_ether_addr(mgmt->bssid, ifmgd->associated->bssid))
 		return RX_MGMT_NONE;
 
 	bssid = ifmgd->associated->bssid;
@@ -1936,7 +1936,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 		return RX_MGMT_NONE;
 
 	if (!ifmgd->associated ||
-	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN))
+	    compare_ether_addr(mgmt->bssid, ifmgd->associated->bssid))
 		return RX_MGMT_NONE;
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
@@ -2203,7 +2203,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 
 	if (!assoc_data)
 		return RX_MGMT_NONE;
-	if (memcmp(assoc_data->bss->bssid, mgmt->bssid, ETH_ALEN))
+	if (compare_ether_addr(assoc_data->bss->bssid, mgmt->bssid))
 		return RX_MGMT_NONE;
 
 	/*
@@ -2291,8 +2291,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	bool need_ps = false;
 
 	if (sdata->u.mgd.associated &&
-	    memcmp(mgmt->bssid, sdata->u.mgd.associated->bssid,
-		   ETH_ALEN) == 0) {
+	    compare_ether_addr(mgmt->bssid, sdata->u.mgd.associated->bssid)
+	    == 0) {
 		bss = (void *)sdata->u.mgd.associated->priv;
 		/* not previously set so we may need to recalc */
 		need_ps = !bss->dtim_period;
@@ -2347,7 +2347,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 
 	ASSERT_MGD_MTX(ifmgd);
 
-	if (memcmp(mgmt->da, sdata->vif.addr, ETH_ALEN))
+	if (compare_ether_addr(mgmt->da, sdata->vif.addr))
 		return; /* ignore ProbeResp to foreign address */
 
 	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
@@ -2360,11 +2360,12 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, false);
 
 	if (ifmgd->associated &&
-	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN) == 0)
+	    compare_ether_addr(mgmt->bssid, ifmgd->associated->bssid) == 0)
 		ieee80211_reset_ap_probe(sdata);
 
 	if (ifmgd->auth_data && !ifmgd->auth_data->bss->proberesp_ies &&
-	    memcmp(mgmt->bssid, ifmgd->auth_data->bss->bssid, ETH_ALEN) == 0) {
+	    compare_ether_addr(mgmt->bssid, ifmgd->auth_data->bss->bssid)
+	    == 0) {
 		/* got probe response, continue with auth */
 		printk(KERN_DEBUG "%s: direct probe responded\n", sdata->name);
 		ifmgd->auth_data->tries = 0;
@@ -2421,7 +2422,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	if (ifmgd->assoc_data && !ifmgd->assoc_data->have_beacon &&
-	    memcmp(mgmt->bssid, ifmgd->assoc_data->bss->bssid, ETH_ALEN) == 0) {
+	    compare_ether_addr(mgmt->bssid, ifmgd->assoc_data->bss->bssid)
+	    == 0) {
 		ieee802_11_parse_elems(mgmt->u.beacon.variable,
 				       len - baselen, &elems);
 
@@ -2436,7 +2438,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (!ifmgd->associated ||
-	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN))
+	    compare_ether_addr(mgmt->bssid, ifmgd->associated->bssid))
 		return;
 	bssid = ifmgd->associated->bssid;
 
@@ -3299,7 +3301,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		bool match;
 
 		/* keep sta info, bssid if matching */
-		match = memcmp(ifmgd->bssid, req->bss->bssid, ETH_ALEN) == 0;
+		match = compare_ether_addr(ifmgd->bssid, req->bss->bssid) == 0;
 		ieee80211_destroy_auth_data(sdata, match);
 	}
 
@@ -3421,7 +3423,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			goto err_clear;
 		}
 	} else
-		WARN_ON_ONCE(memcmp(ifmgd->bssid, req->bss->bssid, ETH_ALEN));
+		WARN_ON_ONCE(compare_ether_addr(ifmgd->bssid, req->bss->bssid));
 
 	if (!bss->dtim_period &&
 	    sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD) {
@@ -3471,7 +3473,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	       sdata->name, req->bssid, req->reason_code);
 
 	if (ifmgd->associated &&
-	    memcmp(ifmgd->associated->bssid, req->bssid, ETH_ALEN) == 0)
+	    compare_ether_addr(ifmgd->associated->bssid, req->bssid) == 0) {
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       req->reason_code, true, frame_buf);
 	else
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7a4ff02..3cf011f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -489,12 +489,12 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 			if (ieee80211_has_tods(hdr->frame_control) ||
 				!ieee80211_has_fromds(hdr->frame_control))
 				return RX_DROP_MONITOR;
-			if (memcmp(hdr->addr3, dev_addr, ETH_ALEN) == 0)
+			if (compare_ether_addr(hdr->addr3, dev_addr) == 0)
 				return RX_DROP_MONITOR;
 		} else {
 			if (!ieee80211_has_a4(hdr->frame_control))
 				return RX_DROP_MONITOR;
-			if (memcmp(hdr->addr4, dev_addr, ETH_ALEN) == 0)
+			if (compare_ether_addr(hdr->addr4, dev_addr) == 0)
 				return RX_DROP_MONITOR;
 		}
 	}
@@ -2336,7 +2336,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				break;
 
-			if (memcmp(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN))
+			if (compare_ether_addr(mgmt->bssid, sdata->u.mgd.bssid))
 				break;
 
 			goto queue;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 9270771..a9d7235 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/if_arp.h>
+#include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/pm_qos.h>
 #include <net/sch_generic.h>
@@ -176,7 +177,7 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	presp = ieee80211_is_probe_resp(fc);
 	if (presp) {
 		/* ignore ProbeResp to foreign address */
-		if (memcmp(mgmt->da, sdata->vif.addr, ETH_ALEN))
+		if (compare_ether_addr(mgmt->da, sdata->vif.addr))
 			return RX_DROP_MONITOR;
 
 		presp = true;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index cd0f265..38137cb 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/etherdevice.h>
 #include <linux/netdevice.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -101,7 +102,7 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
 		if (sta->sdata == sdata &&
-		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
+		    compare_ether_addr(sta->sta.addr, addr) == 0)
 			break;
 		sta = rcu_dereference_check(sta->hnext,
 					    lockdep_is_held(&local->sta_mtx));
@@ -124,7 +125,7 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 	while (sta) {
 		if ((sta->sdata == sdata ||
 		     (sta->sdata->bss && sta->sdata->bss == sdata->bss)) &&
-		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
+		    compare_ether_addr(sta->sta.addr, addr) == 0)
 			break;
 		sta = rcu_dereference_check(sta->hnext,
 					    lockdep_is_held(&local->sta_mtx));
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 23a97c9..3336d54 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -14,6 +14,7 @@
 #include <linux/if_ether.h>
 #include <linux/workqueue.h>
 #include <linux/average.h>
+#include <linux/etherdevice.h>
 #include "key.h"
 
 /**
@@ -489,7 +490,7 @@ void for_each_sta_info_type_check(struct ieee80211_local *local,
 		nxt = _sta ? rcu_dereference(_sta->hnext) : NULL	\
 	     )								\
 	/* compare address and run code only if it matches */		\
-	if (memcmp(_sta->sta.addr, (_addr), ETH_ALEN) == 0)
+	if (compare_ether_addr(_sta->sta.addr, (_addr)) == 0)
 
 /*
  * Get STA info by index, BROKEN!
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index c928e4a..5f8f89e 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/etherdevice.h>
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
 #include "ieee80211_i.h"
@@ -377,7 +378,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	for_each_sta_info(local, hdr->addr1, sta, tmp) {
 		/* skip wrong virtual interface */
-		if (memcmp(hdr->addr2, sta->sdata->vif.addr, ETH_ALEN))
+		if (compare_ether_addr(hdr->addr2, sta->sdata->vif.addr))
 			continue;
 
 		if (info->flags & IEEE80211_TX_STATUS_EOSP)
-- 
1.7.3.2

