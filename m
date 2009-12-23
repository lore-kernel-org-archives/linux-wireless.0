Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbZLWMWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:22:10 -0500
Message-Id: <20091223121615.058285960@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:15:31 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH next 02/18] mac80211: add ieee80211_sdata_running
References: <20091223121529.289129599@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of always using netif_running(sdata->dev)
use ieee80211_sdata_running(sdata) now which is
just an inline containing netif_running() for now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c         |    6 ++----
 net/mac80211/ibss.c        |    4 ++--
 net/mac80211/ieee80211_i.h |    5 +++++
 net/mac80211/iface.c       |   10 +++++-----
 net/mac80211/key.c         |    4 ++--
 net/mac80211/main.c        |    2 +-
 net/mac80211/mesh.c        |    2 +-
 net/mac80211/mlme.c        |    8 ++++----
 net/mac80211/pm.c          |    2 +-
 net/mac80211/rx.c          |    6 +++---
 net/mac80211/scan.c        |   12 ++++++------
 net/mac80211/sta_info.c    |    2 +-
 net/mac80211/status.c      |    2 +-
 net/mac80211/tx.c          |    2 +-
 net/mac80211/util.c        |   10 +++++-----
 15 files changed, 40 insertions(+), 37 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-12-23 13:10:17.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-12-23 13:11:13.000000000 +0100
@@ -960,6 +960,11 @@ void ieee80211_remove_interfaces(struct 
 u32 __ieee80211_recalc_idle(struct ieee80211_local *local);
 void ieee80211_recalc_idle(struct ieee80211_local *local);
 
+static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
+{
+	return netif_running(sdata->dev);
+}
+
 /* tx handling */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
 void ieee80211_tx_pending(unsigned long data);
--- wireless-testing.orig/net/mac80211/ibss.c	2009-12-23 13:10:17.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2009-12-23 13:11:13.000000000 +0100
@@ -744,7 +744,7 @@ static void ieee80211_ibss_work(struct w
 	if (WARN_ON(local->suspended))
 		return;
 
-	if (!netif_running(sdata->dev))
+	if (!ieee80211_sdata_running(sdata))
 		return;
 
 	if (local->scanning)
@@ -827,7 +827,7 @@ void ieee80211_ibss_notify_scan_complete
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			continue;
--- wireless-testing.orig/net/mac80211/iface.c	2009-12-23 13:10:17.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-12-23 13:11:13.000000000 +0100
@@ -65,7 +65,7 @@ static int ieee80211_change_mac(struct n
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int ret;
 
-	if (netif_running(dev))
+	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
 	ret = eth_mac_addr(dev, addr);
@@ -111,7 +111,7 @@ static int ieee80211_open(struct net_dev
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		struct net_device *ndev = nsdata->dev;
 
-		if (ndev != dev && netif_running(ndev)) {
+		if (ndev != dev && ieee80211_sdata_running(nsdata)) {
 			/*
 			 * Allow only a single IBSS interface to be up at any
 			 * time. This is restricted because beacon distribution
@@ -197,7 +197,7 @@ static int ieee80211_open(struct net_dev
 		struct net_device *ndev = nsdata->dev;
 
 		/*
-		 * No need to check netif_running since we do not allow
+		 * No need to check running since we do not allow
 		 * it to start up with this invalid address.
 		 */
 		if (compare_ether_addr(null_addr, ndev->dev_addr) == 0) {
@@ -756,7 +756,7 @@ int ieee80211_if_change_type(struct ieee
 	 * and goes into the requested mode.
 	 */
 
-	if (netif_running(sdata->dev))
+	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
 	/* Purge and reset type-dependent state. */
@@ -930,7 +930,7 @@ u32 __ieee80211_recalc_idle(struct ieee8
 		return ieee80211_idle_off(local, "scanning");
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 		/* do not count disabled managed interfaces */
 		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
--- wireless-testing.orig/net/mac80211/key.c	2009-12-23 13:10:17.000000000 +0100
+++ wireless-testing/net/mac80211/key.c	2009-12-23 13:11:13.000000000 +0100
@@ -443,7 +443,7 @@ void ieee80211_key_link(struct ieee80211
 	add_todo(old_key, KEY_FLAG_TODO_DELETE);
 
 	add_todo(key, KEY_FLAG_TODO_ADD_DEBUGFS);
-	if (netif_running(sdata->dev))
+	if (ieee80211_sdata_running(sdata))
 		add_todo(key, KEY_FLAG_TODO_HWACCEL_ADD);
 
 	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
@@ -509,7 +509,7 @@ void ieee80211_enable_keys(struct ieee80
 {
 	ASSERT_RTNL();
 
-	if (WARN_ON(!netif_running(sdata->dev)))
+	if (WARN_ON(!ieee80211_sdata_running(sdata)))
 		return;
 
 	ieee80211_todo_for_each_key(sdata, KEY_FLAG_TODO_HWACCEL_ADD);
--- wireless-testing.orig/net/mac80211/main.c	2009-12-23 13:10:17.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-12-23 13:11:13.000000000 +0100
@@ -212,7 +212,7 @@ void ieee80211_bss_info_change_notify(st
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		if (local->quiescing || !netif_running(sdata->dev) ||
+		if (local->quiescing || !ieee80211_sdata_running(sdata) ||
 		    test_bit(SCAN_SW_SCANNING, &local->scanning)) {
 			sdata->vif.bss_conf.enable_beacon = false;
 		} else {
--- wireless-testing.orig/net/mac80211/status.c	2009-12-23 13:10:16.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2009-12-23 13:11:13.000000000 +0100
@@ -351,7 +351,7 @@ void ieee80211_tx_status(struct ieee8021
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
-			if (!netif_running(sdata->dev))
+			if (!ieee80211_sdata_running(sdata))
 				continue;
 
 			if ((sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) &&
--- wireless-testing.orig/net/mac80211/mesh.c	2009-12-23 13:10:17.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.c	2009-12-23 13:11:13.000000000 +0100
@@ -645,7 +645,7 @@ static void ieee80211_mesh_work(struct w
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct sk_buff *skb;
 
-	if (!netif_running(sdata->dev))
+	if (!ieee80211_sdata_running(sdata))
 		return;
 
 	if (local->scanning)
--- wireless-testing.orig/net/mac80211/mlme.c	2009-12-23 13:11:05.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-12-23 13:11:13.000000000 +0100
@@ -604,7 +604,7 @@ static void ieee80211_chswitch_work(stru
 		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	if (!netif_running(sdata->dev))
+	if (!ieee80211_sdata_running(sdata))
 		return;
 
 	mutex_lock(&ifmgd->mtx);
@@ -750,7 +750,7 @@ void ieee80211_recalc_ps(struct ieee8021
 	}
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			continue;
@@ -1271,7 +1271,7 @@ static void ieee80211_mgd_probe_ap(struc
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	bool already = false;
 
-	if (!netif_running(sdata->dev))
+	if (!ieee80211_sdata_running(sdata))
 		return;
 
 	if (sdata->local->scanning)
@@ -2126,7 +2126,7 @@ static void ieee80211_sta_work(struct wo
 	enum rx_mgmt_action rma;
 	bool anybusy = false;
 
-	if (!netif_running(sdata->dev))
+	if (!ieee80211_sdata_running(sdata))
 		return;
 
 	if (local->scanning)
--- wireless-testing.orig/net/mac80211/pm.c	2009-12-23 13:10:17.000000000 +0100
+++ wireless-testing/net/mac80211/pm.c	2009-12-23 13:11:13.000000000 +0100
@@ -93,7 +93,7 @@ int __ieee80211_suspend(struct ieee80211
 			break;
 		}
 
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 
 		/* disable beaconing */
--- wireless-testing.orig/net/mac80211/rx.c	2009-12-23 13:10:16.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-12-23 13:11:13.000000000 +0100
@@ -289,7 +289,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES)
 			continue;
 
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 
 		if (prev_dev) {
@@ -2056,7 +2056,7 @@ static void ieee80211_rx_cooked_monitor(
 	skb->protocol = htons(ETH_P_802_2);
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR ||
@@ -2318,7 +2318,7 @@ static void __ieee80211_rx_handle_packet
 	}
 	if (!found_sta) {
 		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-			if (!netif_running(sdata->dev))
+			if (!ieee80211_sdata_running(sdata))
 				continue;
 
 			if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
--- wireless-testing.orig/net/mac80211/scan.c	2009-12-23 13:10:16.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-12-23 13:11:13.000000000 +0100
@@ -346,7 +346,7 @@ void ieee80211_scan_completed(struct iee
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 
 		/* Tell AP we're back */
@@ -396,7 +396,7 @@ static int ieee80211_start_sw_scan(struc
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 
 		/* disable beaconing */
@@ -526,7 +526,7 @@ static int ieee80211_scan_state_decision
 	/* check if at least one STA interface is associated */
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
@@ -571,7 +571,7 @@ static void ieee80211_scan_state_leave_o
 	 */
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
@@ -603,7 +603,7 @@ static void ieee80211_scan_state_enter_o
 	 */
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 
 		/* Tell AP we're back */
@@ -727,7 +727,7 @@ void ieee80211_scan_work(struct work_str
 	/*
 	 * Avoid re-scheduling when the sdata is going away.
 	 */
-	if (!netif_running(sdata->dev)) {
+	if (!ieee80211_sdata_running(sdata)) {
 		ieee80211_scan_completed(&local->hw, true);
 		return;
 	}
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-12-23 13:10:17.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-12-23 13:11:13.000000000 +0100
@@ -367,7 +367,7 @@ int sta_info_insert(struct sta_info *sta
 	 * something inserts a STA (on one CPU) without holding the RTNL
 	 * and another CPU turns off the net device.
 	 */
-	if (unlikely(!netif_running(sdata->dev))) {
+	if (unlikely(!ieee80211_sdata_running(sdata))) {
 		err = -ENETDOWN;
 		goto out_free;
 	}
--- wireless-testing.orig/net/mac80211/util.c	2009-12-23 13:10:17.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-12-23 13:11:13.000000000 +0100
@@ -468,7 +468,7 @@ void ieee80211_iterate_active_interfaces
 		case NL80211_IFTYPE_MESH_POINT:
 			break;
 		}
-		if (netif_running(sdata->dev))
+		if (ieee80211_sdata_running(sdata))
 			iterator(data, sdata->vif.addr,
 				 &sdata->vif);
 	}
@@ -502,7 +502,7 @@ void ieee80211_iterate_active_interfaces
 		case NL80211_IFTYPE_MESH_POINT:
 			break;
 		}
-		if (netif_running(sdata->dev))
+		if (ieee80211_sdata_running(sdata))
 			iterator(data, sdata->vif.addr,
 				 &sdata->vif);
 	}
@@ -1056,7 +1056,7 @@ int ieee80211_reconfig(struct ieee80211_
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
-		    netif_running(sdata->dev)) {
+		    ieee80211_sdata_running(sdata)) {
 			conf.vif = &sdata->vif;
 			conf.type = sdata->vif.type;
 			conf.mac_addr = sdata->vif.addr;
@@ -1103,7 +1103,7 @@ int ieee80211_reconfig(struct ieee80211_
 	/* Finally also reconfigure all the BSS information */
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		u32 changed = ~0;
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
@@ -1131,7 +1131,7 @@ int ieee80211_reconfig(struct ieee80211_
 
 	/* add back keys */
 	list_for_each_entry(sdata, &local->interfaces, list)
-		if (netif_running(sdata->dev))
+		if (ieee80211_sdata_running(sdata))
 			ieee80211_enable_keys(sdata);
 
 	ieee80211_wake_queues_by_reason(hw,
--- wireless-testing.orig/net/mac80211/cfg.c	2009-12-23 13:10:17.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-12-23 13:11:13.000000000 +0100
@@ -78,17 +78,15 @@ static int ieee80211_change_iface(struct
 				  enum nl80211_iftype type, u32 *flags,
 				  struct vif_params *params)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int ret;
 
-	if (netif_running(dev))
+	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
 	if (!nl80211_params_check(type, params))
 		return -EINVAL;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
 	ret = ieee80211_if_change_type(sdata, type);
 	if (ret)
 		return ret;
--- wireless-testing.orig/net/mac80211/tx.c	2009-12-23 13:10:16.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-12-23 13:11:13.000000000 +0100
@@ -1469,7 +1469,7 @@ static void ieee80211_xmit(struct ieee80
 
 			list_for_each_entry_rcu(tmp_sdata, &local->interfaces,
 						list) {
-				if (!netif_running(tmp_sdata->dev))
+				if (!ieee80211_sdata_running(tmp_sdata))
 					continue;
 				if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
 					continue;


