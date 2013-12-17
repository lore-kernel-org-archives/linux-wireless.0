Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:35198 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535Ab3LQHFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 02:05:40 -0500
Date: Mon, 16 Dec 2013 23:04:43 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Kyeyoon Park <kyeyoonp@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCHv2 2/2] mac80211: Add support for QoS mapping
Message-ID: <20131217070443.GA9818@w1.fi> (sfid-20131217_080543_604795_67C94804)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>

Implement set_qos_map() handler for mac80211 to enable QoS mapping
functionality.

Signed-off-by: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/cfg.c         | 26 ++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  6 ++++++
 net/mac80211/wme.c         |  7 ++++++-
 3 files changed, 38 insertions(+), 1 deletion(-)

v2:
- update to match patch 1/2 changes
- use dynamic memory allocation with RCU to replace the static qosmap
  buffer within sdata


diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f80e8c4..99b7997 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3829,6 +3829,31 @@ static void ieee80211_set_wakeup(struct wiphy *wiphy, bool enabled)
 }
 #endif
 
+static int ieee80211_set_qos_map(struct wiphy *wiphy,
+				 struct net_device *dev,
+				 struct cfg80211_qos_map *qos_map)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_qos_map *new_qos_map, *old_qos_map;
+
+	if (qos_map) {
+		new_qos_map = kzalloc(sizeof(*new_qos_map), GFP_KERNEL);
+		if (!new_qos_map)
+			return -ENOMEM;
+		memcpy(&new_qos_map->qos_map, qos_map, sizeof(*qos_map));
+	} else {
+		/* A NULL qos_map was passed to disable QoS mapping */
+		new_qos_map = NULL;
+	}
+
+	old_qos_map = rtnl_dereference(sdata->qos_map);
+	rcu_assign_pointer(sdata->qos_map, new_qos_map);
+	if (old_qos_map)
+		kfree_rcu(old_qos_map, rcu_head);
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3908,4 +3933,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
 	.channel_switch = ieee80211_channel_switch,
+	.set_qos_map = ieee80211_set_qos_map,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ed5bf8b..4e47c34 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -686,6 +686,11 @@ struct ieee80211_chanctx {
 	struct ieee80211_chanctx_conf conf;
 };
 
+struct mac80211_qos_map {
+	struct cfg80211_qos_map qos_map;
+	struct rcu_head rcu_head;
+};
+
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -731,6 +736,7 @@ struct ieee80211_sub_if_data {
 	int encrypt_headroom;
 
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
+	struct mac80211_qos_map __rcu *qos_map;
 
 	struct work_struct csa_finalize_work;
 	int csa_counter_offset_beacon;
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index faa9d8e..21211c6 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -106,6 +106,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta = NULL;
 	const u8 *ra = NULL;
 	bool qos = false;
+	struct mac80211_qos_map *qos_map;
 
 	if (local->hw.queues < IEEE80211_NUM_ACS || skb->len < 6) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
@@ -155,7 +156,11 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 
 	/* use the data classifier to determine what 802.1d tag the
 	 * data frame has */
-	skb->priority = cfg80211_classify8021d(skb, NULL);
+	rcu_read_lock();
+	qos_map = rcu_dereference(sdata->qos_map);
+	skb->priority = cfg80211_classify8021d(skb, qos_map ?
+					       &qos_map->qos_map : NULL);
+	rcu_read_unlock();
 
 	return ieee80211_downgrade_queue(sdata, skb);
 }
-- 
1.8.3.2


-- 
Jouni Malinen                                            PGP id EFC895FA
