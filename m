Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36010 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbZGATgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:36:24 -0400
Message-Id: <20090701193421.667409530@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 18/20 v4] cfg80211: implement IWRATE
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For now, let's implement that using a very hackish way:
simply mirror the wext API in the cfg80211 API. This
will have to be changed later when we implement proper
bitrate API.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |   32 ++++++++++++++++++
 net/mac80211/cfg.c         |   43 +++++++++++++++++++++++++
 net/mac80211/wext.c        |   76 +--------------------------------------------
 net/wireless/wext-compat.c |   63 +++++++++++++++++++++++++++++++++++++
 4 files changed, 140 insertions(+), 74 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-07-01 20:29:40.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-01 20:29:45.000000000 +0200
@@ -815,6 +815,26 @@ enum tx_power_setting {
 	TX_POWER_FIXED,
 };
 
+/*
+ * cfg80211_bitrate_mask - masks for bitrate control
+ */
+struct cfg80211_bitrate_mask {
+/*
+ * As discussed in Berlin, this struct really
+ * should look like this:
+
+	struct {
+		u32 legacy;
+		u8 mcs[IEEE80211_HT_MCS_MASK_LEN];
+	} control[IEEE80211_NUM_BANDS];
+
+ * Since we can always fix in-kernel users, let's keep
+ * it simpler for now:
+ */
+	u32 fixed;   /* fixed bitrate, 0 == not fixed */
+	u32 maxrate; /* in kbps, 0 == no limit */
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -1027,6 +1047,11 @@ struct cfg80211_ops {
 	int	(*testmode_cmd)(struct wiphy *wiphy, void *data, int len);
 #endif
 
+	int	(*set_bitrate_mask)(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    const u8 *peer,
+				    const struct cfg80211_bitrate_mask *mask);
+
 	/* some temporary stuff to finish wext */
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 				  bool enabled, int timeout);
@@ -1581,6 +1606,13 @@ int cfg80211_wext_giwauth(struct net_dev
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
--- wireless-testing.orig/net/mac80211/cfg.c	2009-07-01 20:29:40.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-07-01 20:29:45.000000000 +0200
@@ -1423,6 +1423,48 @@ static int ieee80211_set_power_mgmt(stru
 	return 0;
 }
 
+static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
+				      struct net_device *dev,
+				      const u8 *addr,
+				      const struct cfg80211_bitrate_mask *mask)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	int i, err = -EINVAL;
+	u32 target_rate;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	/* target_rate = -1, rate->fixed = 0 means auto only, so use all rates
+	 * target_rate = X, rate->fixed = 1 means only rate X
+	 * target_rate = X, rate->fixed = 0 means all rates <= X */
+	sdata->max_ratectrl_rateidx = -1;
+	sdata->force_unicast_rateidx = -1;
+
+	if (mask->fixed)
+		target_rate = mask->fixed / 100;
+	else if (mask->maxrate)
+		target_rate = mask->maxrate / 100;
+	else
+		return 0;
+
+	for (i=0; i< sband->n_bitrates; i++) {
+		struct ieee80211_rate *brate = &sband->bitrates[i];
+		int this_rate = brate->bitrate;
+
+		if (target_rate == this_rate) {
+			sdata->max_ratectrl_rateidx = i;
+			if (mask->fixed)
+				sdata->force_unicast_rateidx = i;
+			err = 0;
+			break;
+		}
+	}
+
+	return err;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1468,4 +1510,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.rfkill_poll = ieee80211_rfkill_poll,
 	CFG80211_TESTMODE_CMD(ieee80211_testmode_cmd)
 	.set_power_mgmt = ieee80211_set_power_mgmt,
+	.set_bitrate_mask = ieee80211_set_bitrate_mask,
 };
--- wireless-testing.orig/net/mac80211/wext.c	2009-07-01 20:29:40.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-07-01 20:29:45.000000000 +0200
@@ -165,78 +165,6 @@ static int ieee80211_ioctl_giwap(struct 
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
@@ -340,8 +268,8 @@ static const iw_handler ieee80211_handle
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
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-07-01 20:29:40.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-07-01 20:29:45.000000000 +0200
@@ -1094,3 +1094,66 @@ int cfg80211_wds_wext_giwap(struct net_d
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
+	struct cfg80211_bitrate_mask mask;
+
+	if (!rdev->ops->set_bitrate_mask)
+		return -EOPNOTSUPP;
+
+	mask.fixed = 0;
+	mask.maxrate = 0;
+
+	if (rate->value < 0) {
+		/* nothing */
+	} else if (rate->fixed) {
+		mask.fixed = rate->value / 1000; /* kbps */
+	} else {
+		mask.maxrate = rate->value / 1000; /* kbps */
+	}
+
+	return rdev->ops->set_bitrate_mask(wdev->wiphy, dev, NULL, &mask);
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwrate);
+
+int cfg80211_wext_giwrate(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *rate, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	/* we are under RTNL - globally locked - so can use a static struct */
+	static struct station_info sinfo;
+	u8 *addr;
+	int err;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->get_station)
+		return -EOPNOTSUPP;
+
+	addr = wdev->wext.connect.bssid;
+	if (!addr)
+		return -EOPNOTSUPP;
+
+	err = rdev->ops->get_station(&rdev->wiphy, dev, addr, &sinfo);
+	if (err)
+		return err;
+
+	if (!(sinfo.filled & STATION_INFO_TX_BITRATE))
+		return -EOPNOTSUPP;
+
+	rate->value = 0;
+
+	if (!(sinfo.txrate.flags & RATE_INFO_FLAGS_MCS))
+		rate->value = 100000 * sinfo.txrate.legacy;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_giwrate);

-- 

