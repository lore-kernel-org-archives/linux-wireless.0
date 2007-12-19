Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbXLSPsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:48:08 -0500
Message-Id: <20071219010343.497175000@sipsolutions.net> (sfid-20071219_154812_081105_D71FFC9A)
References: <20071219010328.762470000@sipsolutions.net>
Date: Wed, 19 Dec 2007 02:03:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 9/9] mac80211: implement station stats retrieval
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements the required cfg80211 callback in mac80211
to allow userspace to get station statistics.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- everything.orig/net/mac80211/cfg.c	2007-12-19 00:50:23.043022894 +0100
+++ everything/net/mac80211/cfg.c	2007-12-19 00:50:26.723022188 +0100
@@ -611,6 +611,31 @@ static int ieee80211_change_station(stru
 	return 0;
 }
 
+static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
+				 u8 *mac, struct station_stats *stats)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
+
+	sta = sta_info_get(local, mac);
+	if (!sta)
+		return -ENOENT;
+
+	/* XXX: verify sta->dev == dev */
+
+	stats->filled = STATION_STAT_INACTIVE_TIME |
+			STATION_STAT_RX_BYTES |
+			STATION_STAT_TX_BYTES;
+
+	stats->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
+	stats->rx_bytes = sta->rx_bytes;
+	stats->tx_bytes = sta->tx_bytes;
+
+	sta_info_put(sta);
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -625,4 +650,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.add_station = ieee80211_add_station,
 	.del_station = ieee80211_del_station,
 	.change_station = ieee80211_change_station,
+	.get_station = ieee80211_get_station,
 };

-- 

