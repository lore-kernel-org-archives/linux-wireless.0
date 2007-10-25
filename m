Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbXJYNW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:22:28 -0400
Received: from [131.234.198.68]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Il2fK-0000cl-Ql
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2007 14:22:27 +0100
Message-Id: <20071025093718.092951000@sipsolutions.net> (sfid-20071025_142237_720069_4F85B6EC)
References: <20071025093618.440937000@sipsolutions.net>
Date: Thu, 25 Oct 2007 11:36:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [patch 9/9] mac80211: implement station stats retrieval
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements the required cfg80211 callback in mac80211
to allow userspace to get station statistics.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/cfg.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- linux-2.6.orig/net/mac80211/cfg.c	2007-10-24 11:35:58.552690568 +0200
+++ linux-2.6/net/mac80211/cfg.c	2007-10-24 11:36:00.982690568 +0200
@@ -571,6 +571,31 @@ static int ieee80211_change_station(stru
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
@@ -583,4 +608,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.add_station = ieee80211_add_station,
 	.del_station = ieee80211_del_station,
 	.change_station = ieee80211_change_station,
+	.get_station = ieee80211_get_station,
 };

-- 

