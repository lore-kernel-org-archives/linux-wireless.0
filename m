Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbZFXMJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 08:09:53 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MJRIX-0002yv-Tg
	for linux-wireless@vger.kernel.org; Wed, 24 Jun 2009 14:09:55 +0200
Message-Id: <20090624120809.431227350@sipsolutions.net>
References: <20090624120745.239294066@sipsolutions.net>
Date: Wed, 24 Jun 2009 14:07:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 06/11] cfg80211: implement IWRATE
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For now, let's implement that using a very hackish way:
simply mirror the wext API in the cfg80211 API. This
will have to be changed later when we implement proper
bitrate API.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |   11 ++++++
 net/mac80211/cfg.c         |   73 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/wext.c        |   76 +--------------------------------------------
 net/wireless/wext-compat.c |   28 ++++++++++++++++
 4 files changed, 114 insertions(+), 74 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-06-24 13:54:08.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-24 13:54:08.000000000 +0200
@@ -1006,6 +1006,10 @@ struct cfg80211_ops {
 	/* some temporary stuff to finish wext */
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 				  bool enabled, int timeout);
+	int	(*set_bitrate)(struct wiphy *wiphy, struct net_device *dev,
+			       struct iw_param *rate);
+	int	(*get_bitrate)(struct wiphy *wiphy, struct net_device *dev,
+			       struct iw_param *rate);
 };
 
 /*
@@ -1568,6 +1572,13 @@ int cfg80211_wext_giwauth(struct net_dev
 struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
 					     struct iw_freq *freq);
 
+int cfg80211_wext_siwrate(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *rate, char *extra);
+int cfg80211_wext_giwrate(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *rate, char *extra);
+
 int cfg80211_wext_siwrts(struct net_device *dev,
 			 struct iw_request_info *info,
 			 struct iw_param *rts, char *extra);
--- wireless-testing.orig/net/mac80211/cfg.c	2009-06-24 13:54:08.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-06-24 13:54:08.000000000 +0200
@@ -1411,6 +1411,77 @@ static int ieee80211_set_power_mgmt(stru
 	return 0;
 }
 
+static int ieee80211_set_bitrate(struct wiphy *wiphy,
+				 struct net_device *dev,
+				 struct iw_param *rate)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	int i, err = -EINVAL;
+	u32 target_rate = rate->value / 100000;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	/* target_rate = -1, rate->fixed = 0 means auto only, so use all rates
+	 * target_rate = X, rate->fixed = 1 means only rate X
+	 * target_rate = X, rate->fixed = 0 means all rates <= X */
+	sdata->max_ratectrl_rateidx = -1;
+	sdata->force_unicast_rateidx = -1;
+	if (rate->value < 0)
+		return 0;
+
+	for (i=0; i< sband->n_bitrates; i++) {
+		struct ieee80211_rate *brate = &sband->bitrates[i];
+		int this_rate = brate->bitrate;
+
+		if (target_rate == this_rate) {
+			sdata->max_ratectrl_rateidx = i;
+			if (rate->fixed)
+				sdata->force_unicast_rateidx = i;
+			err = 0;
+			break;
+		}
+	}
+
+	return err;
+}
+
+static int ieee80211_get_bitrate(struct wiphy *wiphy,
+				 struct net_device *dev,
+				 struct iw_param *rate)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
+	struct ieee80211_supported_band *sband;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	rcu_read_lock();
+
+	sta = sta_info_get(local, sdata->u.mgd.bssid);
+
+	if (sta && !(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS))
+		rate->value = sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	else
+		rate->value = 0;
+
+	rcu_read_unlock();
+
+	if (!sta)
+		return -ENODEV;
+
+	rate->value *= 100000;
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1455,4 +1526,6 @@ struct cfg80211_ops mac80211_config_ops 
 	.set_wds_peer = ieee80211_set_wds_peer,
 	.rfkill_poll = ieee80211_rfkill_poll,
 	.set_power_mgmt = ieee80211_set_power_mgmt,
+	.set_bitrate = ieee80211_set_bitrate,
+	.get_bitrate = ieee80211_get_bitrate,
 };
--- wireless-testing.orig/net/mac80211/wext.c	2009-06-24 13:54:08.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-06-24 13:54:08.000000000 +0200
@@ -168,78 +168,6 @@ static int ieee80211_ioctl_giwap(struct 
 }
 
 
-static int ieee80211_ioctl_siwrate(struct net_device *dev,
-				  struct iw_request_info *info,
-				  struct iw_param *rate, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	int i, err = -EINVAL;
-	u32 target_rate = rate->value / 100000;
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_supported_band *sband;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	/* target_rate = -1, rate->fixed = 0 means auto only, so use all rates
-	 * target_rate = X, rate->fixed = 1 means only rate X
-	 * target_rate = X, rate->fixed = 0 means all rates <= X */
-	sdata->max_ratectrl_rateidx = -1;
-	sdata->force_unicast_rateidx = -1;
-	if (rate->value < 0)
-		return 0;
-
-	for (i=0; i< sband->n_bitrates; i++) {
-		struct ieee80211_rate *brate = &sband->bitrates[i];
-		int this_rate = brate->bitrate;
-
-		if (target_rate == this_rate) {
-			sdata->max_ratectrl_rateidx = i;
-			if (rate->fixed)
-				sdata->force_unicast_rateidx = i;
-			err = 0;
-			break;
-		}
-	}
-	return err;
-}
-
-static int ieee80211_ioctl_giwrate(struct net_device *dev,
-				  struct iw_request_info *info,
-				  struct iw_param *rate, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_supported_band *sband;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return -EOPNOTSUPP;
-
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, sdata->u.mgd.bssid);
-
-	if (sta && !(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS))
-		rate->value = sband->bitrates[sta->last_tx_rate.idx].bitrate;
-	else
-		rate->value = 0;
-
-	rcu_read_unlock();
-
-	if (!sta)
-		return -ENODEV;
-
-	rate->value *= 100000;
-
-	return 0;
-}
-
 /* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
 static struct iw_statistics *ieee80211_get_wireless_stats(struct net_device *dev)
 {
@@ -343,8 +271,8 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* SIOCGIWNICKN */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) ieee80211_ioctl_siwrate,		/* SIOCSIWRATE */
-	(iw_handler) ieee80211_ioctl_giwrate,		/* SIOCGIWRATE */
+	(iw_handler) cfg80211_wext_siwrate,		/* SIOCSIWRATE */
+	(iw_handler) cfg80211_wext_giwrate,		/* SIOCGIWRATE */
 	(iw_handler) cfg80211_wext_siwrts,		/* SIOCSIWRTS */
 	(iw_handler) cfg80211_wext_giwrts,		/* SIOCGIWRTS */
 	(iw_handler) cfg80211_wext_siwfrag,		/* SIOCSIWFRAG */
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-06-24 13:54:08.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-06-24 13:54:08.000000000 +0200
@@ -954,3 +954,31 @@ int cfg80211_wds_wext_giwap(struct net_d
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wds_wext_giwap);
+
+int cfg80211_wext_siwrate(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *rate, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+
+	if (!rdev->ops->set_bitrate)
+		return -EOPNOTSUPP;
+
+	return rdev->ops->set_bitrate(wdev->wiphy, dev, rate);
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwrate);
+
+int cfg80211_wext_giwrate(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *rate, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+
+	if (!rdev->ops->get_bitrate)
+		return -EOPNOTSUPP;
+
+	return rdev->ops->get_bitrate(wdev->wiphy, dev, rate);
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_giwrate);

-- 

