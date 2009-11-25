Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934772AbZKYNlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 08:41:31 -0500
Message-Id: <20091125133346.467272115@sipsolutions.net>
Date: Wed, 25 Nov 2009 14:32:48 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] mac80211: reduce reliance on netdev
References: <20091125133243.163478670@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For bluetooth 3, we will most likely not have
a netdev for a virtual interface (sdata), so
prepare for that by reducing the reliance on
having a netdev. This patch moves the name
and address fields into the sdata struct and
uses them from there all over. Some work is
needed to keep them sync'ed, but that's not
a lot of work and in slow paths anyway.

In doing so, this also reduces the number of
pointer dereferences in many places, because
of things like sdata->dev->dev_addr becoming
sdata->vif.addr.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h        |    2 +
 net/mac80211/agg-rx.c         |    6 ++--
 net/mac80211/agg-tx.c         |   14 ++++-----
 net/mac80211/cfg.c            |    2 -
 net/mac80211/debugfs_key.c    |    2 -
 net/mac80211/debugfs_netdev.c |   55 +++----------------------------------
 net/mac80211/debugfs_netdev.h |    9 ++----
 net/mac80211/debugfs_sta.c    |    2 -
 net/mac80211/driver-ops.h     |    4 +-
 net/mac80211/driver-trace.h   |   12 +++-----
 net/mac80211/ht.c             |    6 ++--
 net/mac80211/ibss.c           |   32 ++++++++++-----------
 net/mac80211/ieee80211_i.h    |    5 ++-
 net/mac80211/iface.c          |   62 +++++++++++++++++++++++++++++++++++++++---
 net/mac80211/main.c           |   17 ++++++++---
 net/mac80211/mesh.c           |    4 +-
 net/mac80211/mesh_hwmp.c      |   18 ++++++------
 net/mac80211/mesh_pathtbl.c   |    6 ++--
 net/mac80211/mesh_plink.c     |    2 -
 net/mac80211/mlme.c           |   62 +++++++++++++++++++++---------------------
 net/mac80211/pm.c             |    2 -
 net/mac80211/rx.c             |   43 ++++++++++++++---------------
 net/mac80211/scan.c           |    2 -
 net/mac80211/spectmgmt.c      |    4 +-
 net/mac80211/sta_info.c       |    8 ++---
 net/mac80211/status.c         |    2 -
 net/mac80211/tx.c             |   33 ++++++++++------------
 net/mac80211/util.c           |   14 ++++-----
 28 files changed, 223 insertions(+), 207 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-11-20 11:43:00.000000000 +0100
@@ -135,7 +135,7 @@ static void ieee80211_send_addba_resp(st
 
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer "
-		       "for addba resp frame\n", sdata->dev->name);
+		       "for addba resp frame\n", sdata->name);
 		return;
 	}
 
@@ -143,10 +143,10 @@ static void ieee80211_send_addba_resp(st
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
+		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
 
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-11-20 11:43:00.000000000 +0100
@@ -58,17 +58,17 @@ static void ieee80211_send_addba_request
 
 	if (!skb) {
 		printk(KERN_ERR "%s: failed to allocate buffer "
-				"for addba request frame\n", sdata->dev->name);
+				"for addba request frame\n", sdata->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
+		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
 
@@ -104,7 +104,7 @@ void ieee80211_send_bar(struct ieee80211
 	skb = dev_alloc_skb(sizeof(*bar) + local->hw.extra_tx_headroom);
 	if (!skb) {
 		printk(KERN_ERR "%s: failed to allocate buffer for "
-			"bar frame\n", sdata->dev->name);
+			"bar frame\n", sdata->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -113,7 +113,7 @@ void ieee80211_send_bar(struct ieee80211
 	bar->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
 					 IEEE80211_STYPE_BACK_REQ);
 	memcpy(bar->ra, ra, ETH_ALEN);
-	memcpy(bar->ta, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(bar->ta, sdata->vif.addr, ETH_ALEN);
 	bar_control |= (u16)IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL;
 	bar_control |= (u16)IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA;
 	bar_control |= (u16)(tid << 12);
@@ -489,7 +489,7 @@ void ieee80211_start_tx_ba_cb_irqsafe(st
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_WARNING "%s: Not enough memory, "
-			       "dropping start BA session", skb->dev->name);
+			       "dropping start BA session", sdata->name);
 #endif
 		return;
 	}
@@ -621,7 +621,7 @@ void ieee80211_stop_tx_ba_cb_irqsafe(str
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_WARNING "%s: Not enough memory, "
-			       "dropping stop BA session", skb->dev->name);
+			       "dropping stop BA session", sdata->name);
 #endif
 		return;
 	}
--- wireless-testing.orig/net/mac80211/ht.c	2009-11-20 11:42:17.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2009-11-20 11:43:00.000000000 +0100
@@ -106,7 +106,7 @@ void ieee80211_send_delba(struct ieee802
 
 	if (!skb) {
 		printk(KERN_ERR "%s: failed to allocate buffer "
-					"for delba frame\n", sdata->dev->name);
+					"for delba frame\n", sdata->name);
 		return;
 	}
 
@@ -114,10 +114,10 @@ void ieee80211_send_delba(struct ieee802
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
+		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
 
--- wireless-testing.orig/net/mac80211/ibss.c	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2009-11-20 11:43:00.000000000 +0100
@@ -117,7 +117,7 @@ static void __ieee80211_sta_join_ibss(st
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_PROBE_RESP);
 	memset(mgmt->da, 0xff, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifibss->bssid, ETH_ALEN);
 	mgmt->u.beacon.beacon_int = cpu_to_le16(beacon_int);
 	mgmt->u.beacon.timestamp = cpu_to_le64(tsf);
@@ -266,7 +266,7 @@ static void ieee80211_rx_bss_info(struct
 				printk(KERN_DEBUG "%s: updated supp_rates set "
 				    "for %pM based on beacon info (0x%llx | "
 				    "0x%llx -> 0x%llx)\n",
-				    sdata->dev->name,
+				    sdata->name,
 				    sta->sta.addr,
 				    (unsigned long long) prev_rates,
 				    (unsigned long long) supp_rates,
@@ -364,7 +364,7 @@ static void ieee80211_rx_bss_info(struct
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 		printk(KERN_DEBUG "%s: beacon TSF higher than "
 		       "local TSF - IBSS merge with BSSID %pM\n",
-		       sdata->dev->name, mgmt->bssid);
+		       sdata->name, mgmt->bssid);
 #endif
 		ieee80211_sta_join_ibss(sdata, bss);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
@@ -393,7 +393,7 @@ struct sta_info *ieee80211_ibss_add_sta(
 	if (local->num_sta >= IEEE80211_IBSS_MAX_STA_ENTRIES) {
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: No room for a new IBSS STA entry %pM\n",
-			       sdata->dev->name, addr);
+			       sdata->name, addr);
 		return NULL;
 	}
 
@@ -402,7 +402,7 @@ struct sta_info *ieee80211_ibss_add_sta(
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Adding new IBSS station %pM (dev=%s)\n",
-	       wiphy_name(local->hw.wiphy), addr, sdata->dev->name);
+	       wiphy_name(local->hw.wiphy), addr, sdata->name);
 #endif
 
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
@@ -466,7 +466,7 @@ static void ieee80211_sta_merge_ibss(str
 		return;
 
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
-	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
+	       "IBSS networks with same SSID (merge)\n", sdata->name);
 
 	ieee80211_request_internal_scan(sdata, ifibss->ssid, ifibss->ssid_len);
 }
@@ -488,13 +488,13 @@ static void ieee80211_sta_create_ibss(st
 		 * random number generator get different BSSID. */
 		get_random_bytes(bssid, ETH_ALEN);
 		for (i = 0; i < ETH_ALEN; i++)
-			bssid[i] ^= sdata->dev->dev_addr[i];
+			bssid[i] ^= sdata->vif.addr[i];
 		bssid[0] &= ~0x01;
 		bssid[0] |= 0x02;
 	}
 
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %pM\n",
-	       sdata->dev->name, bssid);
+	       sdata->name, bssid);
 
 	sband = local->hw.wiphy->bands[ifibss->channel->band];
 
@@ -523,7 +523,7 @@ static void ieee80211_sta_find_ibss(stru
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "%s: sta_find_ibss (active_ibss=%d)\n",
-	       sdata->dev->name, active_ibss);
+	       sdata->name, active_ibss);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
 	if (active_ibss)
@@ -552,7 +552,7 @@ static void ieee80211_sta_find_ibss(stru
 
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %pM"
 		       " based on configured SSID\n",
-		       sdata->dev->name, bss->cbss.bssid);
+		       sdata->name, bss->cbss.bssid);
 
 		ieee80211_sta_join_ibss(sdata, bss);
 		ieee80211_rx_bss_put(local, bss);
@@ -571,7 +571,7 @@ static void ieee80211_sta_find_ibss(stru
 	} else if (time_after(jiffies, ifibss->last_scan_completed +
 					IEEE80211_SCAN_INTERVAL)) {
 		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
-		       "join\n", sdata->dev->name);
+		       "join\n", sdata->name);
 
 		ieee80211_request_internal_scan(sdata, ifibss->ssid,
 						ifibss->ssid_len);
@@ -585,7 +585,7 @@ static void ieee80211_sta_find_ibss(stru
 				return;
 			}
 			printk(KERN_DEBUG "%s: IBSS not allowed on"
-			       " %d MHz\n", sdata->dev->name,
+			       " %d MHz\n", sdata->name,
 			       local->hw.conf.channel->center_freq);
 
 			/* No IBSS found - decrease scan interval and continue
@@ -619,7 +619,7 @@ static void ieee80211_rx_mgmt_probe_req(
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "%s: RX ProbeReq SA=%pM DA=%pM BSSID=%pM"
 	       " (tx_last_beacon=%d)\n",
-	       sdata->dev->name, mgmt->sa, mgmt->da,
+	       sdata->name, mgmt->sa, mgmt->da,
 	       mgmt->bssid, tx_last_beacon);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
@@ -637,7 +637,7 @@ static void ieee80211_rx_mgmt_probe_req(
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 		printk(KERN_DEBUG "%s: Invalid SSID IE in ProbeReq "
 		       "from %pM\n",
-		       sdata->dev->name, mgmt->sa);
+		       sdata->name, mgmt->sa);
 #endif
 		return;
 	}
@@ -657,7 +657,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	memcpy(resp->da, mgmt->sa, ETH_ALEN);
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "%s: Sending ProbeResp to %pM\n",
-	       sdata->dev->name, resp->da);
+	       sdata->name, resp->da);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);
@@ -671,7 +671,7 @@ static void ieee80211_rx_mgmt_probe_resp
 	size_t baselen;
 	struct ieee802_11_elems elems;
 
-	if (memcmp(mgmt->da, sdata->dev->dev_addr, ETH_ALEN))
+	if (memcmp(mgmt->da, sdata->vif.addr, ETH_ALEN))
 		return; /* ignore ProbeResp to foreign address */
 
 	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
--- wireless-testing.orig/net/mac80211/status.c	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2009-11-20 11:43:00.000000000 +0100
@@ -167,7 +167,7 @@ void ieee80211_tx_status(struct ieee8021
 
 	for_each_sta_info(local, hdr->addr1, sta, tmp) {
 		/* skip wrong virtual interface */
-		if (memcmp(hdr->addr2, sta->sdata->dev->dev_addr, ETH_ALEN))
+		if (memcmp(hdr->addr2, sta->sdata->vif.addr, ETH_ALEN))
 			continue;
 
 		if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
--- wireless-testing.orig/net/mac80211/main.c	2009-11-20 11:41:40.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-11-20 11:43:00.000000000 +0100
@@ -32,7 +32,6 @@
 #include "led.h"
 #include "cfg.h"
 #include "debugfs.h"
-#include "debugfs_netdev.h"
 
 void ieee80211_configure_filter(struct ieee80211_local *local)
 {
@@ -173,7 +172,7 @@ void ieee80211_bss_info_change_notify(st
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 	else if (sdata->vif.type == NL80211_IFTYPE_AP)
-		sdata->vif.bss_conf.bssid = sdata->dev->dev_addr;
+		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		sdata->vif.bss_conf.bssid = zero;
 	} else {
@@ -672,11 +671,19 @@ static int __init ieee80211_init(void)
 
 	ret = rc80211_pid_init();
 	if (ret)
-		return ret;
+		goto err_pid;
 
-	ieee80211_debugfs_netdev_init();
+	ret = ieee80211_iface_init();
+	if (ret)
+		goto err_netdev;
 
 	return 0;
+ err_netdev:
+	rc80211_pid_exit();
+ err_pid:
+	rc80211_minstrel_exit();
+
+	return ret;
 }
 
 static void __exit ieee80211_exit(void)
@@ -693,7 +700,7 @@ static void __exit ieee80211_exit(void)
 	if (mesh_allocated)
 		ieee80211s_stop();
 
-	ieee80211_debugfs_netdev_exit();
+	ieee80211_iface_exit();
 }
 
 
--- wireless-testing.orig/net/mac80211/mesh.c	2009-11-20 11:41:40.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.c	2009-11-20 11:43:00.000000000 +0100
@@ -457,7 +457,7 @@ static void ieee80211_mesh_housekeeping(
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: running mesh housekeeping\n",
-	       sdata->dev->name);
+	       sdata->name);
 #endif
 
 	ieee80211_sta_expire(sdata, IEEE80211_MESH_PEER_INACTIVITY_LIMIT);
@@ -565,7 +565,7 @@ static void ieee80211_mesh_rx_bcn_presp(
 
 	/* ignore ProbeResp to foreign address */
 	if (stype == IEEE80211_STYPE_PROBE_RESP &&
-	    compare_ether_addr(mgmt->da, sdata->dev->dev_addr))
+	    compare_ether_addr(mgmt->da, sdata->vif.addr))
 		return;
 
 	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2009-11-20 11:43:00.000000000 +0100
@@ -128,9 +128,9 @@ static int mesh_path_sel_frame_tx(enum m
 					  IEEE80211_STYPE_ACTION);
 
 	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	/* BSSID == SA */
-	memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
 	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
 
@@ -222,7 +222,7 @@ int mesh_path_error_tx(u8 ttl, u8 *targe
 					  IEEE80211_STYPE_ACTION);
 
 	memcpy(mgmt->da, ra, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
 	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
 	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
@@ -374,7 +374,7 @@ static u32 hwmp_route_info_get(struct ie
 		new_metric = MAX_METRIC;
 	exp_time = TU_TO_EXP_TIME(orig_lifetime);
 
-	if (memcmp(orig_addr, sdata->dev->dev_addr, ETH_ALEN) == 0) {
+	if (memcmp(orig_addr, sdata->vif.addr, ETH_ALEN) == 0) {
 		/* This MP is the originator, we are not interested in this
 		 * frame, except for updating transmitter's path info.
 		 */
@@ -486,7 +486,7 @@ static void hwmp_preq_frame_process(stru
 
 	mhwmp_dbg("received PREQ from %pM\n", orig_addr);
 
-	if (memcmp(target_addr, sdata->dev->dev_addr, ETH_ALEN) == 0) {
+	if (memcmp(target_addr, sdata->vif.addr, ETH_ALEN) == 0) {
 		mhwmp_dbg("PREQ is for us\n");
 		forward = false;
 		reply = true;
@@ -579,7 +579,7 @@ static void hwmp_prep_frame_process(stru
 	 * replies
 	 */
 	target_addr = PREP_IE_TARGET_ADDR(prep_elem);
-	if (memcmp(target_addr, sdata->dev->dev_addr, ETH_ALEN) == 0)
+	if (memcmp(target_addr, sdata->vif.addr, ETH_ALEN) == 0)
 		/* destination, no forwarding required */
 		return;
 
@@ -890,7 +890,7 @@ void mesh_path_start_discovery(struct ie
 		target_flags = MP_F_RF;
 
 	spin_unlock_bh(&mpath->state_lock);
-	mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->dev->dev_addr,
+	mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->vif.addr,
 			cpu_to_le32(ifmsh->sn), target_flags, mpath->dst,
 			cpu_to_le32(mpath->sn), broadcast_addr, 0,
 			ttl, cpu_to_le32(lifetime), 0,
@@ -938,7 +938,7 @@ int mesh_nexthop_lookup(struct sk_buff *
 	if (mpath->flags & MESH_PATH_ACTIVE) {
 		if (time_after(jiffies, mpath->exp_time +
 			msecs_to_jiffies(sdata->u.mesh.mshcfg.path_refresh_time))
-				&& !memcmp(sdata->dev->dev_addr, hdr->addr4,
+				&& !memcmp(sdata->vif.addr, hdr->addr4,
 					   ETH_ALEN)
 				&& !(mpath->flags & MESH_PATH_RESOLVING)
 				&& !(mpath->flags & MESH_PATH_FIXED)) {
@@ -1011,7 +1011,7 @@ mesh_path_tx_root_frame(struct ieee80211
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-	mesh_path_sel_frame_tx(MPATH_RANN, 0, sdata->dev->dev_addr,
+	mesh_path_sel_frame_tx(MPATH_RANN, 0, sdata->vif.addr,
 			       cpu_to_le32(++ifmsh->sn),
 			       0, NULL, 0, broadcast_addr,
 			       0, MESH_TTL, 0, 0, 0, sdata);
--- wireless-testing.orig/net/mac80211/mesh_pathtbl.c	2009-11-20 11:41:40.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_pathtbl.c	2009-11-20 11:43:00.000000000 +0100
@@ -260,7 +260,7 @@ int mesh_path_add(u8 *dst, struct ieee80
 	int err = 0;
 	u32 hash_idx;
 
-	if (memcmp(dst, sdata->dev->dev_addr, ETH_ALEN) == 0)
+	if (memcmp(dst, sdata->vif.addr, ETH_ALEN) == 0)
 		/* never add ourselves as neighbours */
 		return -ENOTSUPP;
 
@@ -377,7 +377,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struc
 	int err = 0;
 	u32 hash_idx;
 
-	if (memcmp(dst, sdata->dev->dev_addr, ETH_ALEN) == 0)
+	if (memcmp(dst, sdata->vif.addr, ETH_ALEN) == 0)
 		/* never add ourselves as neighbours */
 		return -ENOTSUPP;
 
@@ -605,7 +605,7 @@ void mesh_path_discard_frame(struct sk_b
 	struct mesh_path *mpath;
 	u32 sn = 0;
 
-	if (memcmp(hdr->addr4, sdata->dev->dev_addr, ETH_ALEN) != 0) {
+	if (memcmp(hdr->addr4, sdata->vif.addr, ETH_ALEN) != 0) {
 		u8 *ra, *da;
 
 		da = hdr->addr3;
--- wireless-testing.orig/net/mac80211/mesh_plink.c	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_plink.c	2009-11-20 11:43:00.000000000 +0100
@@ -169,7 +169,7 @@ static int mesh_plink_frame_tx(struct ie
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
 	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
 	mgmt->u.action.category = MESH_PLINK_CATEGORY;
 	mgmt->u.action.u.plink_action.action_code = action;
--- wireless-testing.orig/net/mac80211/mlme.c	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-11-20 11:43:00.000000000 +0100
@@ -248,7 +248,7 @@ static void ieee80211_send_assoc(struct 
 			    wk->ssid_len);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for assoc "
-		       "frame\n", sdata->dev->name);
+		       "frame\n", sdata->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -282,7 +282,7 @@ static void ieee80211_send_assoc(struct 
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, wk->bss->cbss.bssid, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	memcpy(mgmt->bssid, wk->bss->cbss.bssid, ETH_ALEN);
 
 	if (!is_zero_ether_addr(wk->prev_bssid)) {
@@ -443,7 +443,7 @@ static void ieee80211_send_deauth_disass
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for "
-		       "deauth/disassoc frame\n", sdata->dev->name);
+		       "deauth/disassoc frame\n", sdata->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -451,7 +451,7 @@ static void ieee80211_send_deauth_disass
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, bssid, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	memcpy(mgmt->bssid, bssid, ETH_ALEN);
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | stype);
 	skb_put(skb, 2);
@@ -484,7 +484,7 @@ void ieee80211_send_pspoll(struct ieee80
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*pspoll));
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for "
-		       "pspoll frame\n", sdata->dev->name);
+		       "pspoll frame\n", sdata->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -499,7 +499,7 @@ void ieee80211_send_pspoll(struct ieee80
 	pspoll->aid |= cpu_to_le16(1 << 15 | 1 << 14);
 
 	memcpy(pspoll->bssid, ifmgd->bssid, ETH_ALEN);
-	memcpy(pspoll->ta, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(pspoll->ta, sdata->vif.addr, ETH_ALEN);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);
@@ -519,7 +519,7 @@ void ieee80211_send_nullfunc(struct ieee
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 24);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for nullfunc "
-		       "frame\n", sdata->dev->name);
+		       "frame\n", sdata->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -532,7 +532,7 @@ void ieee80211_send_nullfunc(struct ieee
 		fc |= cpu_to_le16(IEEE80211_FCTL_PM);
 	nullfunc->frame_control = fc;
 	memcpy(nullfunc->addr1, sdata->u.mgd.bssid, ETH_ALEN);
-	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->u.mgd.bssid, ETH_ALEN);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
@@ -948,7 +948,7 @@ ieee80211_direct_probe(struct ieee80211_
 	wk->tries++;
 	if (wk->tries > IEEE80211_AUTH_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: direct probe to AP %pM timed out\n",
-		       sdata->dev->name, wk->bss->cbss.bssid);
+		       sdata->name, wk->bss->cbss.bssid);
 
 		/*
 		 * Most likely AP is not in the range so remove the
@@ -966,7 +966,7 @@ ieee80211_direct_probe(struct ieee80211_
 	}
 
 	printk(KERN_DEBUG "%s: direct probe to AP %pM (try %d)\n",
-			sdata->dev->name, wk->bss->cbss.bssid,
+			sdata->name, wk->bss->cbss.bssid,
 			wk->tries);
 
 	/*
@@ -993,7 +993,7 @@ ieee80211_authenticate(struct ieee80211_
 	if (wk->tries > IEEE80211_AUTH_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: authentication with AP %pM"
 		       " timed out\n",
-		       sdata->dev->name, wk->bss->cbss.bssid);
+		       sdata->name, wk->bss->cbss.bssid);
 
 		/*
 		 * Most likely AP is not in the range so remove the
@@ -1011,7 +1011,7 @@ ieee80211_authenticate(struct ieee80211_
 	}
 
 	printk(KERN_DEBUG "%s: authenticate with AP %pM (try %d)\n",
-	       sdata->dev->name, wk->bss->cbss.bssid, wk->tries);
+	       sdata->name, wk->bss->cbss.bssid, wk->tries);
 
 	ieee80211_send_auth(sdata, 1, wk->auth_alg, wk->ie, wk->ie_len,
 			    wk->bss->cbss.bssid, NULL, 0, 0);
@@ -1133,7 +1133,7 @@ ieee80211_associate(struct ieee80211_sub
 	if (wk->tries > IEEE80211_ASSOC_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: association with AP %pM"
 		       " timed out\n",
-		       sdata->dev->name, wk->bss->cbss.bssid);
+		       sdata->name, wk->bss->cbss.bssid);
 
 		/*
 		 * Most likely AP is not in the range so remove the
@@ -1151,7 +1151,7 @@ ieee80211_associate(struct ieee80211_sub
 	}
 
 	printk(KERN_DEBUG "%s: associate with AP %pM (try %d)\n",
-	       sdata->dev->name, wk->bss->cbss.bssid, wk->tries);
+	       sdata->name, wk->bss->cbss.bssid, wk->tries);
 	ieee80211_send_assoc(sdata, wk);
 
 	wk->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
@@ -1212,7 +1212,7 @@ static void ieee80211_mgd_probe_ap(struc
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	if (beacon && net_ratelimit())
 		printk(KERN_DEBUG "%s: detected beacon loss from AP "
-		       "- sending probe request\n", sdata->dev->name);
+		       "- sending probe request\n", sdata->name);
 #endif
 
 	/*
@@ -1269,7 +1269,7 @@ static void ieee80211_auth_completed(str
 				     struct ieee80211_mgd_work *wk)
 {
 	wk->state = IEEE80211_MGD_STATE_IDLE;
-	printk(KERN_DEBUG "%s: authenticated\n", sdata->dev->name);
+	printk(KERN_DEBUG "%s: authenticated\n", sdata->name);
 }
 
 
@@ -1366,7 +1366,7 @@ ieee80211_rx_mgmt_deauth(struct ieee8021
 	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
 	printk(KERN_DEBUG "%s: deauthenticated from %pM (Reason: %u)\n",
-			sdata->dev->name, bssid, reason_code);
+			sdata->name, bssid, reason_code);
 
 	if (!wk) {
 		ieee80211_set_disassoc(sdata, true);
@@ -1400,7 +1400,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
 	printk(KERN_DEBUG "%s: disassociated from %pM (Reason: %u)\n",
-			sdata->dev->name, mgmt->sa, reason_code);
+			sdata->name, mgmt->sa, reason_code);
 
 	ieee80211_set_disassoc(sdata, false);
 	return RX_MGMT_CFG80211_DISASSOC;
@@ -1444,7 +1444,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 
 	printk(KERN_DEBUG "%s: RX %sssocResp from %pM (capab=0x%x "
 	       "status=%d aid=%d)\n",
-	       sdata->dev->name, reassoc ? "Rea" : "A", mgmt->sa,
+	       sdata->name, reassoc ? "Rea" : "A", mgmt->sa,
 	       capab_info, status_code, (u16)(aid & ~(BIT(15) | BIT(14))));
 
 	pos = mgmt->u.assoc_resp.variable;
@@ -1458,7 +1458,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 		ms = tu * 1024 / 1000;
 		printk(KERN_DEBUG "%s: AP rejected association temporarily; "
 		       "comeback duration %u TU (%u ms)\n",
-		       sdata->dev->name, tu, ms);
+		       sdata->name, tu, ms);
 		wk->timeout = jiffies + msecs_to_jiffies(ms);
 		if (ms > IEEE80211_ASSOC_TIMEOUT)
 			run_again(ifmgd, jiffies + msecs_to_jiffies(ms));
@@ -1467,23 +1467,23 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
-		       sdata->dev->name, status_code);
+		       sdata->name, status_code);
 		wk->state = IEEE80211_MGD_STATE_IDLE;
 		return RX_MGMT_CFG80211_ASSOC;
 	}
 
 	if ((aid & (BIT(15) | BIT(14))) != (BIT(15) | BIT(14)))
 		printk(KERN_DEBUG "%s: invalid aid value %d; bits 15:14 not "
-		       "set\n", sdata->dev->name, aid);
+		       "set\n", sdata->name, aid);
 	aid &= ~(BIT(15) | BIT(14));
 
 	if (!elems.supp_rates) {
 		printk(KERN_DEBUG "%s: no SuppRates element in AssocResp\n",
-		       sdata->dev->name);
+		       sdata->name);
 		return RX_MGMT_NONE;
 	}
 
-	printk(KERN_DEBUG "%s: associated\n", sdata->dev->name);
+	printk(KERN_DEBUG "%s: associated\n", sdata->name);
 	ifmgd->aid = aid;
 
 	rcu_read_lock();
@@ -1498,7 +1498,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 		sta = sta_info_alloc(sdata, wk->bss->cbss.bssid, GFP_KERNEL);
 		if (!sta) {
 			printk(KERN_DEBUG "%s: failed to alloc STA entry for"
-			       " the AP\n", sdata->dev->name);
+			       " the AP\n", sdata->name);
 			return RX_MGMT_NONE;
 		}
 
@@ -1576,7 +1576,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 		int err = sta_info_insert(sta);
 		if (err) {
 			printk(KERN_DEBUG "%s: failed to insert STA entry for"
-			       " the AP (error %d)\n", sdata->dev->name, err);
+			       " the AP (error %d)\n", sdata->name, err);
 			rcu_read_unlock();
 			return RX_MGMT_NONE;
 		}
@@ -1671,7 +1671,7 @@ static void ieee80211_rx_mgmt_probe_resp
 
 	ASSERT_MGD_MTX(ifmgd);
 
-	if (memcmp(mgmt->da, sdata->dev->dev_addr, ETH_ALEN))
+	if (memcmp(mgmt->da, sdata->vif.addr, ETH_ALEN))
 		return; /* ignore ProbeResp to foreign address */
 
 	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
@@ -1686,7 +1686,7 @@ static void ieee80211_rx_mgmt_probe_resp
 	/* direct probe may be part of the association flow */
 	if (wk && wk->state == IEEE80211_MGD_STATE_PROBE) {
 		printk(KERN_DEBUG "%s: direct probe responded\n",
-		       sdata->dev->name);
+		       sdata->name);
 		wk->tries = 0;
 		wk->state = IEEE80211_MGD_STATE_AUTH;
 		WARN_ON(ieee80211_authenticate(sdata, wk) != RX_MGMT_NONE);
@@ -1779,7 +1779,7 @@ static void ieee80211_rx_mgmt_beacon(str
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: cancelling probereq poll due "
-			       "to a received beacon\n", sdata->dev->name);
+			       "to a received beacon\n", sdata->name);
 		}
 #endif
 		ifmgd->flags &= ~IEEE80211_STA_BEACON_POLL;
@@ -2554,7 +2554,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 	mutex_unlock(&ifmgd->mtx);
 
 	printk(KERN_DEBUG "%s: deauthenticating from %pM by local choice (reason=%d)\n",
-	       sdata->dev->name, bssid, req->reason_code);
+	       sdata->name, bssid, req->reason_code);
 
 	ieee80211_send_deauth_disassoc(sdata, bssid,
 			IEEE80211_STYPE_DEAUTH, req->reason_code,
@@ -2583,7 +2583,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 	}
 
 	printk(KERN_DEBUG "%s: disassociating from %pM by local choice (reason=%d)\n",
-	       sdata->dev->name, req->bss->bssid, req->reason_code);
+	       sdata->name, req->bss->bssid, req->reason_code);
 
 	ieee80211_set_disassoc(sdata, false);
 
--- wireless-testing.orig/net/mac80211/rx.c	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-20 11:43:00.000000000 +0100
@@ -287,15 +287,15 @@ ieee80211_rx_monitor(struct ieee80211_lo
 	skb->protocol = htons(ETH_P_802_2);
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
-			continue;
-
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
 			continue;
 
 		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES)
 			continue;
 
+		if (!netif_running(sdata->dev))
+			continue;
+
 		if (prev_dev) {
 			skb2 = skb_clone(skb, GFP_ATOMIC);
 			if (skb2) {
@@ -480,7 +480,7 @@ ieee80211_rx_mesh_check(struct ieee80211
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	char *dev_addr = rx->sdata->dev->dev_addr;
+	char *dev_addr = rx->sdata->vif.addr;
 
 	if (ieee80211_is_data(hdr->frame_control)) {
 		if (is_multicast_ether_addr(hdr->addr1)) {
@@ -1028,7 +1028,7 @@ static void ap_sta_ps_start(struct sta_i
 	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_SLEEP, &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d enters power save mode\n",
-	       sdata->dev->name, sta->sta.addr, sta->sta.aid);
+	       sdata->name, sta->sta.addr, sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 }
 
@@ -1042,13 +1042,13 @@ static void ap_sta_ps_end(struct sta_inf
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d exits power save mode\n",
-	       sdata->dev->name, sta->sta.addr, sta->sta.aid);
+	       sdata->name, sta->sta.addr, sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
 	if (test_sta_flags(sta, WLAN_STA_PS_DRIVER)) {
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "%s: STA %pM aid %d driver-ps-blocked\n",
-		       sdata->dev->name, sta->sta.addr, sta->sta.aid);
+		       sdata->name, sta->sta.addr, sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 		return;
 	}
@@ -1160,7 +1160,7 @@ ieee80211_reassemble_add(struct ieee8021
 		printk(KERN_DEBUG "%s: RX reassembly removed oldest "
 		       "fragment entry (idx=%d age=%lu seq=%d last_frag=%d "
 		       "addr1=%pM addr2=%pM\n",
-		       sdata->dev->name, idx,
+		       sdata->name, idx,
 		       jiffies - entry->first_frag_time, entry->seq,
 		       entry->last_frag, hdr->addr1, hdr->addr2);
 #endif
@@ -1428,7 +1428,6 @@ static int
 __ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
-	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 
 	if (ieee80211_has_a4(hdr->frame_control) &&
@@ -1440,7 +1439,7 @@ __ieee80211_data_to_8023(struct ieee8021
 	     (sdata->vif.type == NL80211_IFTYPE_STATION && sdata->u.mgd.use_4addr)))
 		return -1;
 
-	return ieee80211_data_to_8023(rx->skb, dev->dev_addr, sdata->vif.type);
+	return ieee80211_data_to_8023(rx->skb, sdata->vif.addr, sdata->vif.type);
 }
 
 /*
@@ -1457,7 +1456,7 @@ static bool ieee80211_frame_allowed(stru
 	 * of whether the frame was encrypted or not.
 	 */
 	if (ehdr->h_proto == htons(ETH_P_PAE) &&
-	    (compare_ether_addr(ehdr->h_dest, rx->sdata->dev->dev_addr) == 0 ||
+	    (compare_ether_addr(ehdr->h_dest, rx->sdata->vif.addr) == 0 ||
 	     compare_ether_addr(ehdr->h_dest, pae_group_addr) == 0))
 		return true;
 
@@ -1725,7 +1724,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 	/* Frame has reached destination.  Don't forward */
 	if (!is_multicast_ether_addr(hdr->addr1) &&
-	    compare_ether_addr(sdata->dev->dev_addr, hdr->addr3) == 0)
+	    compare_ether_addr(sdata->vif.addr, hdr->addr3) == 0)
 		return RX_CONTINUE;
 
 	mesh_hdr->ttl--;
@@ -1742,10 +1741,10 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 			if (!fwd_skb && net_ratelimit())
 				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
-						   sdata->dev->name);
+						   sdata->name);
 
 			fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
-			memcpy(fwd_hdr->addr2, sdata->dev->dev_addr, ETH_ALEN);
+			memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
 			info = IEEE80211_SKB_CB(fwd_skb);
 			memset(info, 0, sizeof(*info));
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
@@ -1874,7 +1873,7 @@ static void ieee80211_process_sa_query_r
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *resp;
 
-	if (compare_ether_addr(mgmt->da, sdata->dev->dev_addr) != 0) {
+	if (compare_ether_addr(mgmt->da, sdata->vif.addr) != 0) {
 		/* Not to own unicast address */
 		return;
 	}
@@ -1898,7 +1897,7 @@ static void ieee80211_process_sa_query_r
 	resp = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(resp, 0, 24);
 	memcpy(resp->da, mgmt->sa, ETH_ALEN);
-	memcpy(resp->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(resp->sa, sdata->vif.addr, ETH_ALEN);
 	memcpy(resp->bssid, sdata->u.mgd.bssid, ETH_ALEN);
 	resp->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
@@ -2278,7 +2277,7 @@ static int prepare_for_handlers(struct i
 		if (!bssid && !sdata->u.mgd.use_4addr)
 			return 0;
 		if (!multicast &&
-		    compare_ether_addr(sdata->dev->dev_addr, hdr->addr1) != 0) {
+		    compare_ether_addr(sdata->vif.addr, hdr->addr1) != 0) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
@@ -2295,7 +2294,7 @@ static int prepare_for_handlers(struct i
 				return 0;
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!multicast &&
-			   compare_ether_addr(sdata->dev->dev_addr,
+			   compare_ether_addr(sdata->vif.addr,
 					      hdr->addr1) != 0) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
@@ -2312,7 +2311,7 @@ static int prepare_for_handlers(struct i
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		if (!multicast &&
-		    compare_ether_addr(sdata->dev->dev_addr,
+		    compare_ether_addr(sdata->vif.addr,
 				       hdr->addr1) != 0) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
@@ -2323,11 +2322,11 @@ static int prepare_for_handlers(struct i
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_AP:
 		if (!bssid) {
-			if (compare_ether_addr(sdata->dev->dev_addr,
+			if (compare_ether_addr(sdata->vif.addr,
 					       hdr->addr1))
 				return 0;
 		} else if (!ieee80211_bssid_match(bssid,
-					sdata->dev->dev_addr)) {
+					sdata->vif.addr)) {
 			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
 				return 0;
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
@@ -2446,7 +2445,7 @@ static void __ieee80211_rx_handle_packet
 					printk(KERN_DEBUG "%s: failed to copy "
 					       "multicast frame for %s\n",
 					       wiphy_name(local->hw.wiphy),
-					       prev->dev->name);
+					       prev->name);
 				continue;
 			}
 			ieee80211_invoke_rx_handlers(prev, &rx, skb_new, rate);
--- wireless-testing.orig/net/mac80211/scan.c	2009-11-20 11:41:40.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-11-20 11:43:00.000000000 +0100
@@ -147,7 +147,7 @@ ieee80211_scan_rx(struct ieee80211_sub_i
 	presp = ieee80211_is_probe_resp(fc);
 	if (presp) {
 		/* ignore ProbeResp to foreign address */
-		if (memcmp(mgmt->da, sdata->dev->dev_addr, ETH_ALEN))
+		if (memcmp(mgmt->da, sdata->vif.addr, ETH_ALEN))
 			return RX_DROP_MONITOR;
 
 		presp = true;
--- wireless-testing.orig/net/mac80211/spectmgmt.c	2009-11-20 11:41:40.000000000 +0100
+++ wireless-testing/net/mac80211/spectmgmt.c	2009-11-20 11:43:00.000000000 +0100
@@ -35,7 +35,7 @@ static void ieee80211_send_refuse_measur
 
 	if (!skb) {
 		printk(KERN_ERR "%s: failed to allocate buffer for "
-				"measurement report frame\n", sdata->dev->name);
+				"measurement report frame\n", sdata->name);
 		return;
 	}
 
@@ -43,7 +43,7 @@ static void ieee80211_send_refuse_measur
 	msr_report = (struct ieee80211_mgmt *)skb_put(skb, 24);
 	memset(msr_report, 0, 24);
 	memcpy(msr_report->da, da, ETH_ALEN);
-	memcpy(msr_report->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(msr_report->sa, sdata->vif.addr, ETH_ALEN);
 	memcpy(msr_report->bssid, bssid, ETH_ALEN);
 	msr_report->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						IEEE80211_STYPE_ACTION);
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-11-20 11:43:00.000000000 +0100
@@ -372,7 +372,7 @@ int sta_info_insert(struct sta_info *sta
 		goto out_free;
 	}
 
-	if (WARN_ON(compare_ether_addr(sta->sta.addr, sdata->dev->dev_addr) == 0 ||
+	if (WARN_ON(compare_ether_addr(sta->sta.addr, sdata->vif.addr) == 0 ||
 		    is_multicast_ether_addr(sta->sta.addr))) {
 		err = -EINVAL;
 		goto out_free;
@@ -831,7 +831,7 @@ void ieee80211_sta_expire(struct ieee802
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 			printk(KERN_DEBUG "%s: expiring inactive STA %pM\n",
-			       sdata->dev->name, sta->sta.addr);
+			       sdata->name, sta->sta.addr);
 #endif
 			__sta_info_unlink(&sta);
 			if (sta)
@@ -889,7 +889,7 @@ void ieee80211_sta_ps_deliver_wakeup(str
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d sending %d filtered/%d PS frames "
-	       "since STA not sleeping anymore\n", sdata->dev->name,
+	       "since STA not sleeping anymore\n", sdata->name,
 	       sta->sta.addr, sta->sta.aid, sent - buffered, buffered);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 }
@@ -948,7 +948,7 @@ void ieee80211_sta_ps_deliver_poll_respo
 		 */
 		printk(KERN_DEBUG "%s: STA %pM sent PS Poll even "
 		       "though there are no buffered frames for it\n",
-		       sdata->dev->name, sta->sta.addr);
+		       sdata->name, sta->sta.addr);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 	}
 }
--- wireless-testing.orig/net/mac80211/tx.c	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-11-20 11:43:00.000000000 +0100
@@ -223,7 +223,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			printk(KERN_DEBUG "%s: dropped data frame to not "
 			       "associated station %pM\n",
-			       tx->dev->name, hdr->addr1);
+			       tx->sdata->name, hdr->addr1);
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 			I802_DEBUG_INC(tx->local->tx_handlers_drop_not_assoc);
 			return TX_DROP;
@@ -331,7 +331,7 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: BC TX buffer full - dropping the oldest frame\n",
-			       tx->dev->name);
+			       tx->sdata->name);
 #endif
 		dev_kfree_skb(skb_dequeue(&tx->sdata->bss->ps_bc_buf));
 	} else
@@ -390,7 +390,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 			if (net_ratelimit()) {
 				printk(KERN_DEBUG "%s: STA %pM TX "
 				       "buffer full - dropping oldest frame\n",
-				       tx->dev->name, sta->sta.addr);
+				       tx->sdata->name, sta->sta.addr);
 			}
 #endif
 			dev_kfree_skb(old);
@@ -415,7 +415,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	else if (unlikely(staflags & WLAN_STA_PS_STA)) {
 		printk(KERN_DEBUG "%s: STA %pM in PS mode, but pspoll "
-		       "set -> send frame\n", tx->dev->name,
+		       "set -> send frame\n", tx->sdata->name,
 		       sta->sta.addr);
 	}
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
@@ -548,7 +548,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 		 "%s: Dropped data frame as no usable bitrate found while "
 		 "scanning and associated. Target station: "
 		 "%pM on %d GHz band\n",
-		 tx->dev->name, hdr->addr1,
+		 tx->sdata->name, hdr->addr1,
 		 tx->channel->band ? 5 : 2))
 		return TX_DROP;
 
@@ -1020,7 +1020,6 @@ ieee80211_tx_prepare(struct ieee80211_su
 
 	memset(tx, 0, sizeof(*tx));
 	tx->skb = skb;
-	tx->dev = sdata->dev; /* use original interface */
 	tx->local = local;
 	tx->sdata = sdata;
 	tx->channel = local->hw.conf.channel;
@@ -1473,7 +1472,7 @@ static void ieee80211_xmit(struct ieee80
 					continue;
 				if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
 					continue;
-				if (compare_ether_addr(tmp_sdata->dev->dev_addr,
+				if (compare_ether_addr(tmp_sdata->vif.addr,
 						       hdr->addr2) == 0) {
 					sdata = tmp_sdata;
 					break;
@@ -1637,7 +1636,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
 			memcpy(hdr.addr1, sta->sta.addr, ETH_ALEN);
-			memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
+			memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 			hdrlen = 30;
@@ -1651,7 +1650,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA BSSID SA */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
-		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
+		memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 		memcpy(hdr.addr3, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 24;
 		break;
@@ -1659,7 +1658,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 		/* RA TA DA SA */
 		memcpy(hdr.addr1, sdata->u.wds.remote_addr, ETH_ALEN);
-		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
+		memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 		memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 30;
@@ -1673,8 +1672,8 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 			goto fail;
 		}
 
-		if (compare_ether_addr(dev->dev_addr,
-					  skb->data + ETH_ALEN) == 0) {
+		if (compare_ether_addr(sdata->vif.addr,
+				       skb->data + ETH_ALEN) == 0) {
 			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
 					skb->data, skb->data + ETH_ALEN);
 			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
@@ -1704,7 +1703,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 				}
 			}
 			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
-					mesh_da, dev->dev_addr);
+					mesh_da, sdata->vif.addr);
 			rcu_read_unlock();
 			if (is_mesh_mcast)
 				meshhdrlen =
@@ -1729,7 +1728,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 		if (sdata->u.mgd.use_4addr && ethertype != ETH_P_PAE) {
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
-			memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
+			memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 			hdrlen = 30;
@@ -1780,7 +1779,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 		unlikely(!is_multicast_ether_addr(hdr.addr1) &&
 		      !(sta_flags & WLAN_STA_AUTHORIZED) &&
 		      !(ethertype == ETH_P_PAE &&
-		       compare_ether_addr(dev->dev_addr,
+		       compare_ether_addr(sdata->vif.addr,
 					  skb->data + ETH_ALEN) == 0))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit())
@@ -2144,8 +2143,8 @@ struct sk_buff *ieee80211_beacon_get_tim
 		mgmt->frame_control =
 		    cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
 		memset(mgmt->da, 0xff, ETH_ALEN);
-		memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
+		memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
+		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 		mgmt->u.beacon.beacon_int =
 			cpu_to_le16(sdata->vif.bss_conf.beacon_int);
 		mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
--- wireless-testing.orig/net/mac80211/util.c	2009-11-20 11:41:41.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-11-20 11:43:00.000000000 +0100
@@ -469,7 +469,7 @@ void ieee80211_iterate_active_interfaces
 			break;
 		}
 		if (netif_running(sdata->dev))
-			iterator(data, sdata->dev->dev_addr,
+			iterator(data, sdata->vif.addr,
 				 &sdata->vif);
 	}
 
@@ -503,7 +503,7 @@ void ieee80211_iterate_active_interfaces
 			break;
 		}
 		if (netif_running(sdata->dev))
-			iterator(data, sdata->dev->dev_addr,
+			iterator(data, sdata->vif.addr,
 				 &sdata->vif);
 	}
 
@@ -848,7 +848,7 @@ void ieee80211_send_auth(struct ieee8021
 			    sizeof(*mgmt) + 6 + extra_len);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for auth "
-		       "frame\n", sdata->dev->name);
+		       "frame\n", sdata->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -858,7 +858,7 @@ void ieee80211_send_auth(struct ieee8021
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_AUTH);
 	memcpy(mgmt->da, bssid, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	memcpy(mgmt->bssid, bssid, ETH_ALEN);
 	mgmt->u.auth.auth_alg = cpu_to_le16(auth_alg);
 	mgmt->u.auth.auth_transaction = cpu_to_le16(transaction);
@@ -949,7 +949,7 @@ void ieee80211_send_probe_req(struct iee
 			    ie_len);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
-		       "request\n", sdata->dev->name);
+		       "request\n", sdata->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -958,7 +958,7 @@ void ieee80211_send_probe_req(struct iee
 	memset(mgmt, 0, 24);
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_PROBE_REQ);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	if (dst) {
 		memcpy(mgmt->da, dst, ETH_ALEN);
 		memcpy(mgmt->bssid, dst, ETH_ALEN);
@@ -1051,7 +1051,7 @@ int ieee80211_reconfig(struct ieee80211_
 		    netif_running(sdata->dev)) {
 			conf.vif = &sdata->vif;
 			conf.type = sdata->vif.type;
-			conf.mac_addr = sdata->dev->dev_addr;
+			conf.mac_addr = sdata->vif.addr;
 			res = drv_add_interface(local, &conf);
 		}
 	}
--- wireless-testing.orig/include/net/mac80211.h	2009-11-20 11:42:54.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-11-20 11:43:00.000000000 +0100
@@ -659,12 +659,14 @@ struct ieee80211_conf {
  * @type: type of this virtual interface
  * @bss_conf: BSS configuration for this interface, either our own
  *	or the BSS we're associated to
+ * @addr: address of this interface
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  */
 struct ieee80211_vif {
 	enum nl80211_iftype type;
 	struct ieee80211_bss_conf bss_conf;
+	u8 addr[ETH_ALEN];
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
--- wireless-testing.orig/net/mac80211/driver-ops.h	2009-11-20 11:41:40.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2009-11-20 11:43:00.000000000 +0100
@@ -39,7 +39,7 @@ static inline int drv_add_interface(stru
 				    struct ieee80211_if_init_conf *conf)
 {
 	int ret = local->ops->add_interface(&local->hw, conf);
-	trace_drv_add_interface(local, conf->mac_addr, conf->vif, ret);
+	trace_drv_add_interface(local, conf->vif, ret);
 	return ret;
 }
 
@@ -47,7 +47,7 @@ static inline void drv_remove_interface(
 					struct ieee80211_if_init_conf *conf)
 {
 	local->ops->remove_interface(&local->hw, conf);
-	trace_drv_remove_interface(local, conf->mac_addr, conf->vif);
+	trace_drv_remove_interface(local, conf->vif);
 }
 
 static inline int drv_config(struct ieee80211_local *local, u32 changed)
--- wireless-testing.orig/net/mac80211/driver-trace.h	2009-11-20 11:41:40.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2009-11-20 11:43:00.000000000 +0100
@@ -70,11 +70,10 @@ TRACE_EVENT(drv_stop,
 
 TRACE_EVENT(drv_add_interface,
 	TP_PROTO(struct ieee80211_local *local,
-		 const u8 *addr,
 		 struct ieee80211_vif *vif,
 		 int ret),
 
-	TP_ARGS(local, addr, vif, ret),
+	TP_ARGS(local, vif, ret),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -86,7 +85,7 @@ TRACE_EVENT(drv_add_interface,
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
-		memcpy(__entry->addr, addr, 6);
+		memcpy(__entry->addr, vif->addr, 6);
 		__entry->ret = ret;
 	),
 
@@ -97,10 +96,9 @@ TRACE_EVENT(drv_add_interface,
 );
 
 TRACE_EVENT(drv_remove_interface,
-	TP_PROTO(struct ieee80211_local *local,
-		 const u8 *addr, struct ieee80211_vif *vif),
+	TP_PROTO(struct ieee80211_local *local, struct ieee80211_vif *vif),
 
-	TP_ARGS(local, addr, vif),
+	TP_ARGS(local, vif),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -111,7 +109,7 @@ TRACE_EVENT(drv_remove_interface,
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
-		memcpy(__entry->addr, addr, 6);
+		memcpy(__entry->addr, vif->addr, 6);
 	),
 
 	TP_printk(
--- wireless-testing.orig/net/mac80211/iface.c	2009-11-20 11:41:40.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-11-20 11:43:00.000000000 +0100
@@ -60,6 +60,22 @@ static int ieee80211_change_mtu(struct n
 	return 0;
 }
 
+static int ieee80211_change_mac(struct net_device *dev, void *addr)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	int ret;
+
+	if (netif_running(dev))
+		return -EBUSY;
+
+	ret = eth_mac_addr(dev, addr);
+
+	if (ret == 0)
+		memcpy(sdata->vif.addr, addr, ETH_ALEN);
+
+	return ret;
+}
+
 static inline int identical_mac_addr_allowed(int type1, int type2)
 {
 	return type1 == NL80211_IFTYPE_MONITOR ||
@@ -234,7 +250,7 @@ static int ieee80211_open(struct net_dev
 	default:
 		conf.vif = &sdata->vif;
 		conf.type = sdata->vif.type;
-		conf.mac_addr = dev->dev_addr;
+		conf.mac_addr = sdata->vif.addr;
 		res = drv_add_interface(local, &conf);
 		if (res)
 			goto err_stop;
@@ -514,7 +530,7 @@ static int ieee80211_stop(struct net_dev
 
 		conf.vif = &sdata->vif;
 		conf.type = sdata->vif.type;
-		conf.mac_addr = dev->dev_addr;
+		conf.mac_addr = sdata->vif.addr;
 		/* disable all keys for as long as this netdev is down */
 		ieee80211_disable_keys(sdata);
 		drv_remove_interface(local, &conf);
@@ -651,7 +667,7 @@ static const struct net_device_ops ieee8
 	.ndo_start_xmit		= ieee80211_subif_start_xmit,
 	.ndo_set_multicast_list = ieee80211_set_multicast_list,
 	.ndo_change_mtu 	= ieee80211_change_mtu,
-	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_set_mac_address 	= ieee80211_change_mac,
 };
 
 static const struct net_device_ops ieee80211_monitorif_ops = {
@@ -799,6 +815,8 @@ int ieee80211_if_add(struct ieee80211_lo
 	/* don't use IEEE80211_DEV_TO_SUB_IF because it checks too much */
 	sdata = netdev_priv(ndev);
 	ndev->ieee80211_ptr = &sdata->wdev;
+	memcpy(sdata->vif.addr, ndev->dev_addr, ETH_ALEN);
+	memcpy(sdata->name, ndev->name, IFNAMSIZ);
 
 	/* initialise type-independent data */
 	sdata->wdev.wiphy = local->hw.wiphy;
@@ -954,3 +972,41 @@ void ieee80211_recalc_idle(struct ieee80
 	if (chg)
 		ieee80211_hw_config(local, chg);
 }
+
+static int netdev_notify(struct notifier_block *nb,
+			 unsigned long state,
+			 void *ndev)
+{
+	struct net_device *dev = ndev;
+	struct ieee80211_sub_if_data *sdata;
+
+	if (state != NETDEV_CHANGENAME)
+		return 0;
+
+	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
+		return 0;
+
+	if (dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
+		return 0;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	memcpy(sdata->name, sdata->name, IFNAMSIZ);
+
+	ieee80211_debugfs_rename_netdev(sdata);
+	return 0;
+}
+
+static struct notifier_block mac80211_netdev_notifier = {
+	.notifier_call = netdev_notify,
+};
+
+int ieee80211_iface_init(void)
+{
+	return register_netdevice_notifier(&mac80211_netdev_notifier);
+}
+
+void ieee80211_iface_exit(void)
+{
+	unregister_netdevice_notifier(&mac80211_netdev_notifier);
+}
--- wireless-testing.orig/net/mac80211/debugfs_netdev.c	2009-11-20 11:41:40.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_netdev.c	2009-11-20 11:43:00.000000000 +0100
@@ -280,16 +280,11 @@ static void add_files(struct ieee80211_s
 	}
 }
 
-static int notif_registered;
-
 void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata)
 {
 	char buf[10+IFNAMSIZ];
 
-	if (!notif_registered)
-		return;
-
-	sprintf(buf, "netdev:%s", sdata->dev->name);
+	sprintf(buf, "netdev:%s", sdata->name);
 	sdata->debugfs.dir = debugfs_create_dir(buf,
 		sdata->local->hw.wiphy->debugfsdir);
 	add_files(sdata);
@@ -304,58 +299,18 @@ void ieee80211_debugfs_remove_netdev(str
 	sdata->debugfs.dir = NULL;
 }
 
-static int netdev_notify(struct notifier_block *nb,
-			 unsigned long state,
-			 void *ndev)
+void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata)
 {
-	struct net_device *dev = ndev;
 	struct dentry *dir;
-	struct ieee80211_sub_if_data *sdata;
-	char buf[10+IFNAMSIZ];
-
-	if (state != NETDEV_CHANGENAME)
-		return 0;
-
-	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
-		return 0;
-
-	if (dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
-		return 0;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	char buf[10 + IFNAMSIZ];
 
 	dir = sdata->debugfs.dir;
 
 	if (!dir)
-		return 0;
+		return;
 
-	sprintf(buf, "netdev:%s", dev->name);
+	sprintf(buf, "netdev:%s", sdata->name);
 	if (!debugfs_rename(dir->d_parent, dir, dir->d_parent, buf))
 		printk(KERN_ERR "mac80211: debugfs: failed to rename debugfs "
 		       "dir to %s\n", buf);
-
-	return 0;
-}
-
-static struct notifier_block mac80211_debugfs_netdev_notifier = {
-	.notifier_call = netdev_notify,
-};
-
-void ieee80211_debugfs_netdev_init(void)
-{
-	int err;
-
-	err = register_netdevice_notifier(&mac80211_debugfs_netdev_notifier);
-	if (err) {
-		printk(KERN_ERR
-		       "mac80211: failed to install netdev notifier,"
-		       " disabling per-netdev debugfs!\n");
-	} else
-		notif_registered = 1;
-}
-
-void ieee80211_debugfs_netdev_exit(void)
-{
-	unregister_netdevice_notifier(&mac80211_debugfs_netdev_notifier);
-	notif_registered = 0;
 }
--- wireless-testing.orig/net/mac80211/debugfs_netdev.h	2009-11-20 11:41:41.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_netdev.h	2009-11-20 11:43:00.000000000 +0100
@@ -6,8 +6,7 @@
 #ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata);
-void ieee80211_debugfs_netdev_init(void);
-void ieee80211_debugfs_netdev_exit(void);
+void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata);
 #else
 static inline void ieee80211_debugfs_add_netdev(
 	struct ieee80211_sub_if_data *sdata)
@@ -15,10 +14,8 @@ static inline void ieee80211_debugfs_add
 static inline void ieee80211_debugfs_remove_netdev(
 	struct ieee80211_sub_if_data *sdata)
 {}
-static inline void ieee80211_debugfs_netdev_init(void)
-{}
-
-static inline void ieee80211_debugfs_netdev_exit(void)
+static inline void ieee80211_debugfs_rename_netdev(
+	struct ieee80211_sub_if_data *sdata)
 {}
 #endif
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-20 11:43:00.000000000 +0100
@@ -140,7 +140,6 @@ typedef unsigned __bitwise__ ieee80211_t
 
 struct ieee80211_tx_data {
 	struct sk_buff *skb;
-	struct net_device *dev;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
@@ -433,6 +432,8 @@ struct ieee80211_sub_if_data {
 
 	int drop_unencrypted;
 
+	char name[IFNAMSIZ];
+
 	/*
 	 * keep track of whether the HT opmode (stored in
 	 * vif.bss_info.ht_operation_mode) is valid.
@@ -937,6 +938,8 @@ void ieee80211_rx_bss_put(struct ieee802
 			  struct ieee80211_bss *bss);
 
 /* interface handling */
+int ieee80211_iface_init(void);
+void ieee80211_iface_exit(void);
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct net_device **new_dev, enum nl80211_iftype type,
 		     struct vif_params *params);
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2009-11-20 11:41:40.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_sta.c	2009-11-20 11:43:00.000000000 +0100
@@ -44,7 +44,7 @@ static const struct file_operations sta_
 		STA_OPS(name)
 
 STA_FILE(aid, sta.aid, D);
-STA_FILE(dev, sdata->dev->name, S);
+STA_FILE(dev, sdata->name, S);
 STA_FILE(rx_packets, rx_packets, LU);
 STA_FILE(tx_packets, tx_packets, LU);
 STA_FILE(rx_bytes, rx_bytes, LU);
--- wireless-testing.orig/net/mac80211/debugfs_key.c	2009-11-20 11:41:40.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_key.c	2009-11-20 11:43:00.000000000 +0100
@@ -56,7 +56,7 @@ KEY_CONF_FILE(keyidx, D);
 KEY_CONF_FILE(hw_key_idx, D);
 KEY_FILE(flags, X);
 KEY_FILE(tx_rx_count, D);
-KEY_READ(ifindex, sdata->dev->ifindex, 20, "%d\n");
+KEY_READ(ifindex, sdata->name, IFNAMSIZ + 2, "%s\n");
 KEY_OPS(ifindex);
 
 static ssize_t key_algorithm_read(struct file *file,
--- wireless-testing.orig/net/mac80211/cfg.c	2009-11-20 11:42:57.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-11-20 11:43:00.000000000 +0100
@@ -729,7 +729,7 @@ static int ieee80211_add_station(struct 
 	} else
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (compare_ether_addr(mac, dev->dev_addr) == 0)
+	if (compare_ether_addr(mac, sdata->vif.addr) == 0)
 		return -EINVAL;
 
 	if (is_multicast_ether_addr(mac))
--- wireless-testing.orig/net/mac80211/pm.c	2009-11-20 11:41:41.000000000 +0100
+++ wireless-testing/net/mac80211/pm.c	2009-11-20 11:43:00.000000000 +0100
@@ -102,7 +102,7 @@ int __ieee80211_suspend(struct ieee80211
 
 		conf.vif = &sdata->vif;
 		conf.type = sdata->vif.type;
-		conf.mac_addr = sdata->dev->dev_addr;
+		conf.mac_addr = sdata->vif.addr;
 		drv_remove_interface(local, &conf);
 	}
 


