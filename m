Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36012 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZGATg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:36:26 -0400
Message-Id: <20090701193421.796060337@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:27:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 19/20 v4] cfg80211: implement get_wireless_stats
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By dropping the noise reporting, we can implement
wireless stats in cfg80211. We also make the
handler return NULL if we have no information,
which is possible thanks to the recent wext change.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |    1 
 net/mac80211/wext.c        |   69 ---------------------------------------------
 net/wireless/wext-compat.c |   59 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 68 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-07-01 20:29:45.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-07-01 20:29:46.000000000 +0200
@@ -165,73 +165,6 @@ static int ieee80211_ioctl_giwap(struct 
 }
 
 
-/* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
-static struct iw_statistics *ieee80211_get_wireless_stats(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct iw_statistics *wstats = &local->wstats;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct sta_info *sta = NULL;
-
-	rcu_read_lock();
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		sta = sta_info_get(local, sdata->u.mgd.bssid);
-
-	if (!sta) {
-		wstats->discard.fragment = 0;
-		wstats->discard.misc = 0;
-		wstats->qual.qual = 0;
-		wstats->qual.level = 0;
-		wstats->qual.noise = 0;
-		wstats->qual.updated = IW_QUAL_ALL_INVALID;
-	} else {
-		wstats->qual.updated = 0;
-		/*
-		 * mirror what cfg80211 does for iwrange/scan results,
-		 * otherwise userspace gets confused.
-		 */
-		if (local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
-				       IEEE80211_HW_SIGNAL_DBM)) {
-			wstats->qual.updated |= IW_QUAL_LEVEL_UPDATED;
-			wstats->qual.updated |= IW_QUAL_QUAL_UPDATED;
-		} else {
-			wstats->qual.updated |= IW_QUAL_LEVEL_INVALID;
-			wstats->qual.updated |= IW_QUAL_QUAL_INVALID;
-		}
-
-		if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC) {
-			wstats->qual.level = sta->last_signal;
-			wstats->qual.qual = sta->last_signal;
-		} else if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
-			int sig = sta->last_signal;
-
-			wstats->qual.updated |= IW_QUAL_DBM;
-			wstats->qual.level = sig;
-			if (sig < -110)
-				sig = -110;
-			else if (sig > -40)
-				sig = -40;
-			wstats->qual.qual = sig + 110;
-		}
-
-		if (local->hw.flags & IEEE80211_HW_NOISE_DBM) {
-			/*
-			 * This assumes that if driver reports noise, it also
-			 * reports signal in dBm.
-			 */
-			wstats->qual.noise = sta->last_noise;
-			wstats->qual.updated |= IW_QUAL_NOISE_UPDATED;
-		} else {
-			wstats->qual.updated |= IW_QUAL_NOISE_INVALID;
-		}
-	}
-
-	rcu_read_unlock();
-
-	return wstats;
-}
-
 /* Structures to export the Wireless Handlers */
 
 static const iw_handler ieee80211_handler[] =
@@ -298,5 +231,5 @@ const struct iw_handler_def ieee80211_iw
 {
 	.num_standard	= ARRAY_SIZE(ieee80211_handler),
 	.standard	= (iw_handler *) ieee80211_handler,
-	.get_wireless_stats = ieee80211_get_wireless_stats,
+	.get_wireless_stats = cfg80211_wireless_stats,
 };
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-07-01 20:29:45.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-07-01 20:29:46.000000000 +0200
@@ -1157,3 +1157,62 @@ int cfg80211_wext_giwrate(struct net_dev
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwrate);
+
+/* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
+struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	/* we are under RTNL - globally locked - so can use static structs */
+	static struct iw_statistics wstats;
+	static struct station_info sinfo;
+	u8 *addr;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION)
+		return NULL;
+
+	if (!rdev->ops->get_station)
+		return NULL;
+
+	addr = wdev->wext.connect.bssid;
+	if (!addr)
+		return NULL;
+
+	if (rdev->ops->get_station(&rdev->wiphy, dev, addr, &sinfo))
+		return NULL;
+
+	memset(&wstats, 0, sizeof(wstats));
+
+	switch (rdev->wiphy.signal_type) {
+	case CFG80211_SIGNAL_TYPE_MBM:
+		if (sinfo.filled & STATION_INFO_SIGNAL) {
+			int sig = sinfo.signal;
+			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
+			wstats.qual.updated |= IW_QUAL_QUAL_UPDATED;
+			wstats.qual.updated |= IW_QUAL_DBM;
+			wstats.qual.level = sig;
+			if (sig < -110)
+				sig = -110;
+			else if (sig > -40)
+				sig = -40;
+			wstats.qual.qual = sig + 110;
+			break;
+		}
+	case CFG80211_SIGNAL_TYPE_UNSPEC:
+		if (sinfo.filled & STATION_INFO_SIGNAL) {
+			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
+			wstats.qual.updated |= IW_QUAL_QUAL_UPDATED;
+			wstats.qual.level = sinfo.signal;
+			wstats.qual.qual = sinfo.signal;
+			break;
+		}
+	default:
+		wstats.qual.updated |= IW_QUAL_LEVEL_INVALID;
+		wstats.qual.updated |= IW_QUAL_QUAL_INVALID;
+	}
+
+	wstats.qual.updated |= IW_QUAL_NOISE_INVALID;
+
+	return &wstats;
+}
+EXPORT_SYMBOL_GPL(cfg80211_wireless_stats);
--- wireless-testing.orig/include/net/cfg80211.h	2009-07-01 20:29:45.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-01 20:29:46.000000000 +0200
@@ -1646,6 +1646,7 @@ int cfg80211_wext_siwtxpower(struct net_
 int cfg80211_wext_giwtxpower(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *data, char *keybuf);
+struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev);
 
 int cfg80211_wext_siwpower(struct net_device *dev,
 			   struct iw_request_info *info,

-- 

