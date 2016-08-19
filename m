Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.aperture-lab.de ([138.201.29.205]:50655 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755643AbcHSUKR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 16:10:17 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc: "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Antonio Quartulli <a@unstable.cc>,
        b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [PATCH] cfg80211: Add stub for cfg80211_get_station()
Date: Fri, 19 Aug 2016 22:02:48 +0200
Message-Id: <20160819200248.8202-1-linus.luessing@c0d3.blue> (sfid-20160819_221044_723886_6B99A9E9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows modules using this function (currently: batman-adv) to
compile even if cfg80211 is not built at all, thus relaxing
dependencies.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 include/net/cfg80211.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9c23f4d3..beb7610 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1102,6 +1102,7 @@ struct station_info {
 	struct cfg80211_tid_stats pertid[IEEE80211_NUM_TIDS + 1];
 };
 
+#if IS_ENABLED(CONFIG_CFG80211)
 /**
  * cfg80211_get_station - retrieve information about a given station
  * @dev: the device where the station is supposed to be connected to
@@ -1114,6 +1115,14 @@ struct station_info {
  */
 int cfg80211_get_station(struct net_device *dev, const u8 *mac_addr,
 			 struct station_info *sinfo);
+#else
+static inline int cfg80211_get_station(struct net_device *dev,
+				       const u8 *mac_addr,
+				       struct station_info *sinfo)
+{
+	return -ENOENT;
+}
+#endif
 
 /**
  * enum monitor_flags - monitor flags
-- 
2.1.4
