Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40726 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933154AbcH2NkJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 09:40:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Aug 2016 16:39:55 +0300
Message-Id: <1472477998-25972-2-git-send-email-luca@coelho.fi> (sfid-20160829_154017_080039_531C81E3)
Subject: [PATCH 2/5] mac80211: add support for MU-MIMO air sniffer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aviya Erenfeld <aviya.erenfeld@intel.com>

add support to MU-MIMO air sniffer according groupID:
in monitor mode, use a given MU-MIMO groupID to monitor stations
that belongs to that group using MU-MIMO.

add support for following a station according to its MAC address
using VHT MU-MIMO sniffer:
the monitors wait until they get an action MU-MIMO notification
frame, then parses it in order to find the groupID that corresponds
to the given MAC address and monitors packets destined to that
groupID using VHT MU-MIMO.

Signed-off-by: Aviya Erenfeld <aviya.erenfeld@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c         | 23 ++++++++++++++++++++++-
 net/mac80211/driver-ops.h  |  3 ++-
 net/mac80211/ieee80211_i.h |  7 ++++++-
 net/mac80211/iface.c       |  5 +++++
 net/mac80211/rx.c          | 21 +++++++++++++++++++++
 5 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 543b1d4..c498f6c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -73,8 +73,29 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		sdata->u.mgd.use_4addr = params->use_4addr;
 	}
 
-	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags) {
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
 		struct ieee80211_local *local = sdata->local;
+		struct ieee80211_sub_if_data *monitor_sdata;
+		u32 mu_mntr_cap_flag = NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER;
+
+		monitor_sdata = rtnl_dereference(local->monitor_sdata);
+		if (monitor_sdata &&
+		    wiphy_ext_feature_isset(wiphy, mu_mntr_cap_flag)) {
+			memcpy(monitor_sdata->vif.bss_conf.mu_group.membership,
+			       params->vht_mumimo_groups, WLAN_MEMBERSHIP_LEN);
+			memcpy(monitor_sdata->vif.bss_conf.mu_group.position,
+			       params->vht_mumimo_groups + WLAN_MEMBERSHIP_LEN,
+			       WLAN_USER_POSITION_LEN);
+			monitor_sdata->vif.mu_mimo_owner = true;
+			ieee80211_bss_info_change_notify(monitor_sdata,
+							 BSS_CHANGED_MU_GROUPS);
+
+			ether_addr_copy(monitor_sdata->u.mntr.mu_follow_addr,
+					params->macaddr);
+		}
+
+		if (!flags)
+			return 0;
 
 		if (ieee80211_sdata_running(sdata)) {
 			u32 mask = MONITOR_FLAG_COOK_FRAMES |
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 42a41ae..c39f93b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -162,7 +162,8 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 		return;
 
 	if (WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE ||
-			 sdata->vif.type == NL80211_IFTYPE_MONITOR))
+			 (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
+			  !sdata->vif.mu_mimo_owner)))
 		return;
 
 	if (!check_sdata_in_driver(sdata))
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f56d342..5b4aef2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -3,7 +3,7 @@
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
- * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2013-2015  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -824,6 +824,11 @@ struct txq_info {
 	struct ieee80211_txq txq;
 };
 
+struct ieee80211_if_mntr {
+	u32 flags;
+	u8 mu_follow_addr[ETH_ALEN] __aligned(2);
+};
+
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b123a9e..c6d156f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -43,6 +43,8 @@
  * by either the RTNL, the iflist_mtx or RCU.
  */
 
+static void ieee80211_iface_work(struct work_struct *work);
+
 bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_chanctx_conf *chanctx_conf;
@@ -448,6 +450,9 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 		return ret;
 	}
 
+	skb_queue_head_init(&sdata->skb_queue);
+	INIT_WORK(&sdata->work, ieee80211_iface_work);
+
 	return 0;
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9dce3b1..d922a01 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -485,6 +485,9 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	struct net_device *prev_dev = NULL;
 	int present_fcs_len = 0;
 	unsigned int rtap_vendor_space = 0;
+	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_sub_if_data *monitor_sdata =
+		rcu_dereference(local->monitor_sdata);
 
 	if (unlikely(status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA)) {
 		struct ieee80211_vendor_radiotap *rtap = (void *)origskb->data;
@@ -585,6 +588,24 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		ieee80211_rx_stats(sdata->dev, skb->len);
 	}
 
+	mgmt = (void *)skb->data;
+	if (monitor_sdata && ieee80211_is_action(mgmt->frame_control) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 +
+		VHT_MUMIMO_GROUPS_DATA_LEN &&
+	    mgmt->u.action.category == WLAN_CATEGORY_VHT &&
+	    mgmt->u.action.u.vht_group_notif.action_code ==
+		WLAN_VHT_ACTION_GROUPID_MGMT &&
+	    is_valid_ether_addr(monitor_sdata->u.mntr.mu_follow_addr) &&
+	    ether_addr_equal(mgmt->da, monitor_sdata->u.mntr.mu_follow_addr)) {
+		struct sk_buff *mu_skb = skb_copy(skb, GFP_ATOMIC);
+
+		if (mu_skb) {
+			mu_skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
+			skb_queue_tail(&monitor_sdata->skb_queue, mu_skb);
+			ieee80211_queue_work(&local->hw, &monitor_sdata->work);
+		}
+	}
+
 	if (prev_dev) {
 		skb->dev = prev_dev;
 		netif_receive_skb(skb);
-- 
2.8.1
