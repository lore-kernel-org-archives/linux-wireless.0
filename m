Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbZFXMJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 08:09:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MJRIb-0002zO-8s
	for linux-wireless@vger.kernel.org; Wed, 24 Jun 2009 14:09:58 +0200
Message-Id: <20090624120809.621443153@sipsolutions.net>
References: <20090624120745.239294066@sipsolutions.net>
Date: Wed, 24 Jun 2009 14:07:52 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 07/11] cfg80211: implement get_wireless_stats
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With just a new method to get the current channel noise,
we can implement wireless stats in cfg80211. We also
make the handler return NULL if we have no information,
which is possible thanks to the recent wext change.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |    3 +
 net/mac80211/cfg.c         |   27 +++++++++++++++++
 net/mac80211/wext.c        |   69 --------------------------------------------
 net/wireless/wext-compat.c |   70 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 101 insertions(+), 68 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-06-24 13:54:08.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-06-24 13:54:09.000000000 +0200
@@ -168,73 +168,6 @@ static int ieee80211_ioctl_giwap(struct 
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
@@ -301,5 +234,5 @@ const struct iw_handler_def ieee80211_iw
 {
 	.num_standard	= ARRAY_SIZE(ieee80211_handler),
 	.standard	= (iw_handler *) ieee80211_handler,
-	.get_wireless_stats = ieee80211_get_wireless_stats,
+	.get_wireless_stats = cfg80211_wireless_stats,
 };
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-06-24 13:54:08.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-06-24 13:54:09.000000000 +0200
@@ -982,3 +982,73 @@ int cfg80211_wext_giwrate(struct net_dev
 	return rdev->ops->get_bitrate(wdev->wiphy, dev, rate);
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
+	/*
+	 * This assumes that if the driver does dBm, it also
+	 * reports the noise in dBm...
+	 */
+	if (rdev->ops->get_noise) {
+		int noise;
+		if (rdev->ops->get_noise(wdev->wiphy, dev, &noise)) {
+			wstats.qual.noise = noise;
+			wstats.qual.updated |= IW_QUAL_NOISE_INVALID;
+		} else
+			wstats.qual.updated |= IW_QUAL_NOISE_UPDATED;
+	}
+
+	return &wstats;
+}
+EXPORT_SYMBOL_GPL(cfg80211_wireless_stats);
--- wireless-testing.orig/include/net/cfg80211.h	2009-06-24 13:54:08.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-24 13:54:09.000000000 +0200
@@ -1010,6 +1010,8 @@ struct cfg80211_ops {
 			       struct iw_param *rate);
 	int	(*get_bitrate)(struct wiphy *wiphy, struct net_device *dev,
 			       struct iw_param *rate);
+	int	(*get_noise)(struct wiphy *wiphy, struct net_device *dev,
+			     int *noise);
 };
 
 /*
@@ -1612,6 +1614,7 @@ int cfg80211_wext_siwtxpower(struct net_
 int cfg80211_wext_giwtxpower(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *data, char *keybuf);
+struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev);
 
 int cfg80211_wext_siwpower(struct net_device *dev,
 			   struct iw_request_info *info,
--- wireless-testing.orig/net/mac80211/cfg.c	2009-06-24 13:54:08.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-06-24 13:54:09.000000000 +0200
@@ -381,6 +381,32 @@ static void sta_set_sinfo(struct sta_inf
 	}
 }
 
+static int ieee80211_get_noise(struct wiphy *wiphy, struct net_device *dev,
+			       int *noise)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
+	int err = -EINVAL;
+
+	/* XXX: this is all wrong */
+
+	if (!(local->hw.flags & IEEE80211_HW_NOISE_DBM))
+		return -EOPNOTSUPP;
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	rcu_read_lock();
+	sta = sta_info_get(local, sdata->u.mgd.bssid);
+	if (sta) {
+		*noise = sta->last_noise;
+		err = 0;
+	}
+	rcu_read_unlock();
+
+	return err;
+}
 
 static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 				 int idx, u8 *mac, struct station_info *sinfo)
@@ -1528,4 +1554,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.set_power_mgmt = ieee80211_set_power_mgmt,
 	.set_bitrate = ieee80211_set_bitrate,
 	.get_bitrate = ieee80211_get_bitrate,
+	.get_noise = ieee80211_get_noise,
 };

-- 

