Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36784 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3KTK32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 05:29:28 -0500
Date: Wed, 20 Nov 2013 12:29:22 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: Add support for QoS mapping
Message-ID: <20131120102922.GA26188@jouni.qca.qualcomm.com> (sfid-20131120_112932_755307_6859FFC6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>

Implement set_qos_map() handler for mac80211 to enable QoS mapping
functionality.

Signed-off-by: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/cfg.c         |   12 ++++++++++++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/iface.c       |    2 ++
 net/mac80211/wme.c         |    3 ++-
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 95667b0..37fc6ff 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3785,6 +3785,17 @@ static void ieee80211_set_wakeup(struct wiphy *wiphy, bool enabled)
 }
 #endif
 
+static int ieee80211_set_qos_map(struct wiphy *wiphy,
+				 struct net_device *dev,
+				 struct cfg80211_qos_map *qos_map)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	memcpy(&sdata->qos_map, qos_map, sizeof(struct cfg80211_qos_map));
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3864,4 +3875,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
 	.channel_switch = ieee80211_channel_switch,
+	.set_qos_map = ieee80211_set_qos_map,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 29dc505..7bb5914 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -730,6 +730,7 @@ struct ieee80211_sub_if_data {
 	bool control_port_no_encrypt;
 
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
+	struct cfg80211_qos_map qos_map;
 
 	struct work_struct csa_finalize_work;
 	int csa_counter_offset_beacon;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ff101ea..bd43217 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -636,6 +636,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		ieee80211_set_wmm_default(sdata, true);
 	}
 
+	sdata->qos_map.valid = false;
+
 	set_bit(SDATA_STATE_RUNNING, &sdata->state);
 
 	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index faa9d8e..eb87ec5 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -103,6 +103,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct cfg80211_qos_map *qos_map = &sdata->qos_map;
 	struct sta_info *sta = NULL;
 	const u8 *ra = NULL;
 	bool qos = false;
@@ -155,7 +156,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 
 	/* use the data classifier to determine what 802.1d tag the
 	 * data frame has */
-	skb->priority = cfg80211_classify8021d(skb, NULL);
+	skb->priority = cfg80211_classify8021d(skb, qos_map);
 
 	return ieee80211_downgrade_queue(sdata, skb);
 }
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
