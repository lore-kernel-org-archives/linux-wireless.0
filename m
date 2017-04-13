Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54596 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbdDMMiE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 08:38:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: keep a separate list of monitor interfaces that are up
Date: Thu, 13 Apr 2017 14:38:00 +0200
Message-Id: <20170413123800.19552-1-johannes@sipsolutions.net> (sfid-20170413_143807_269744_8673AC24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In addition to keeping monitor interfaces on the regular list of
interfaces, keep those that are up and not in cooked mode on a
separate list. This saves having to iterate all interfaces when
delivering to monitor interfaces.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/iface.c       | 19 +++++++++++++++++--
 net/mac80211/main.c        |  1 +
 net/mac80211/rx.c          | 11 +----------
 4 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0e718437d080..cf6d5abb65a3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -839,6 +839,8 @@ struct txq_info {
 struct ieee80211_if_mntr {
 	u32 flags;
 	u8 mu_follow_addr[ETH_ALEN] __aligned(2);
+
+	struct list_head list;
 };
 
 /**
@@ -1259,6 +1261,7 @@ struct ieee80211_local {
 
 	/* see iface.c */
 	struct list_head interfaces;
+	struct list_head mon_list; /* only that are IFF_UP && !cooked */
 	struct mutex iflist_mtx;
 
 	/*
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5bb0c5012819..3bd5b81f5d81 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -676,7 +676,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 
 	set_bit(SDATA_STATE_RUNNING, &sdata->state);
 
-	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_WDS:
 		/* Create STA entry for the WDS peer */
 		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
 				     GFP_KERNEL);
@@ -697,8 +698,17 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 
 		rate_control_rate_init(sta);
 		netif_carrier_on(dev);
-	} else if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE) {
+		break;
+	case NL80211_IFTYPE_P2P_DEVICE:
 		rcu_assign_pointer(local->p2p_sdata, sdata);
+		break;
+	case NL80211_IFTYPE_MONITOR:
+		if (sdata->u.mntr.flags & MONITOR_FLAG_COOK_FRAMES)
+			break;
+		list_add_tail_rcu(&sdata->u.mntr.list, &local->mon_list);
+		break;
+	default:
+		break;
 	}
 
 	/*
@@ -817,6 +827,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 		cancel_work_sync(&sdata->u.ap.request_smps_work);
 		break;
+	case NL80211_IFTYPE_MONITOR:
+		if (sdata->u.mntr.flags & MONITOR_FLAG_COOK_FRAMES)
+			break;
+		list_del_rcu(&sdata->u.mntr.list);
+		break;
 	default:
 		break;
 	}
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 56fb47953b72..ae408a96c407 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -603,6 +603,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 		ARRAY_SIZE(local->ext_capa);
 
 	INIT_LIST_HEAD(&local->interfaces);
+	INIT_LIST_HEAD(&local->mon_list);
 
 	__hw_addr_init(&local->mc_list);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e35c42ebb7a5..8be24f8c73d6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -593,16 +593,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	skb->pkt_type = PACKET_OTHERHOST;
 	skb->protocol = htons(ETH_P_802_2);
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
-			continue;
-
-		if (sdata->u.mntr.flags & MONITOR_FLAG_COOK_FRAMES)
-			continue;
-
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
+	list_for_each_entry_rcu(sdata, &local->mon_list, list) {
 		if (prev_dev) {
 			skb2 = skb_clone(skb, GFP_ATOMIC);
 			if (skb2) {
-- 
2.11.0
