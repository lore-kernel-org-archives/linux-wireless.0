Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZF3KyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 06:54:00 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MLayQ-0002Uv-9z
	for linux-wireless@vger.kernel.org; Tue, 30 Jun 2009 12:54:03 +0200
Message-Id: <20090630105100.222024675@sipsolutions.net>
References: <20090630104952.857270082@sipsolutions.net>
Date: Tue, 30 Jun 2009 12:49:57 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] cfg80211: implement IWAP for WDS
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements siocsiwap/giwap for WDS mode.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |   10 +++++++++
 net/mac80211/cfg.c         |   11 ++++++++++
 net/mac80211/wext.c        |   26 +++----------------------
 net/wireless/wext-compat.c |   46 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 71 insertions(+), 22 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-06-30 12:43:43.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-30 12:43:47.000000000 +0200
@@ -1018,6 +1018,9 @@ struct cfg80211_ops {
 				enum tx_power_setting type, int dbm);
 	int	(*get_tx_power)(struct wiphy *wiphy, int *dbm);
 
+	int	(*set_wds_peer)(struct wiphy *wiphy, struct net_device *dev,
+				u8 *addr);
+
 	void	(*rfkill_poll)(struct wiphy *wiphy);
 
 #ifdef CONFIG_NL80211_TESTMODE
@@ -1631,6 +1634,13 @@ int cfg80211_wext_giwpower(struct net_de
 			   struct iw_request_info *info,
 			   struct iw_param *wrq, char *extra);
 
+int cfg80211_wds_wext_siwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *addr, char *extra);
+int cfg80211_wds_wext_giwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *addr, char *extra);
+
 /*
  * callbacks for asynchronous cfg80211 methods, notification
  * functions and BSS handling helpers
--- wireless-testing.orig/net/mac80211/wext.c	2009-06-30 12:43:43.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-06-30 12:43:47.000000000 +0200
@@ -140,23 +140,8 @@ static int ieee80211_ioctl_siwap(struct 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		return cfg80211_mgd_wext_siwap(dev, info, ap_addr, extra);
 
-	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
-		/*
-		 * If it is necessary to update the WDS peer address
-		 * while the interface is running, then we need to do
-		 * more work here, namely if it is running we need to
-		 * add a new and remove the old STA entry, this is
-		 * normally handled by _open() and _stop().
-		 */
-		if (netif_running(dev))
-			return -EBUSY;
-
-		memcpy(&sdata->u.wds.remote_addr, (u8 *) &ap_addr->sa_data,
-		       ETH_ALEN);
-
-		return 0;
-	}
-
+	if (sdata->vif.type == NL80211_IFTYPE_WDS)
+		return cfg80211_wds_wext_siwap(dev, info, ap_addr, extra);
 	return -EOPNOTSUPP;
 }
 
@@ -173,11 +158,8 @@ static int ieee80211_ioctl_giwap(struct 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		return cfg80211_mgd_wext_giwap(dev, info, ap_addr, extra);
 
-	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
-		ap_addr->sa_family = ARPHRD_ETHER;
-		memcpy(&ap_addr->sa_data, sdata->u.wds.remote_addr, ETH_ALEN);
-		return 0;
-	}
+	if (sdata->vif.type == NL80211_IFTYPE_WDS)
+		return cfg80211_wds_wext_giwap(dev, info, ap_addr, extra);
 
 	return -EOPNOTSUPP;
 }
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-06-30 12:43:43.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-06-30 12:43:47.000000000 +0200
@@ -1048,3 +1048,49 @@ int cfg80211_wext_giwpower(struct net_de
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwpower);
+
+int cfg80211_wds_wext_siwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *addr, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	int err;
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_WDS))
+		return -EINVAL;
+
+	if (addr->sa_family != ARPHRD_ETHER)
+		return -EINVAL;
+
+	if (netif_running(dev))
+		return -EBUSY;
+
+	if (!rdev->ops->set_wds_peer)
+		return -EOPNOTSUPP;
+
+	err = rdev->ops->set_wds_peer(wdev->wiphy, dev, (u8 *) &addr->sa_data);
+	if (err)
+		return err;
+
+	memcpy(&wdev->wext.bssid, (u8 *) &addr->sa_data, ETH_ALEN);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cfg80211_wds_wext_siwap);
+
+int cfg80211_wds_wext_giwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *addr, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_WDS))
+		return -EINVAL;
+
+	addr->sa_family = ARPHRD_ETHER;
+	memcpy(&addr->sa_data, wdev->wext.bssid, ETH_ALEN);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cfg80211_wds_wext_giwap);
--- wireless-testing.orig/net/mac80211/cfg.c	2009-06-30 12:43:43.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-06-30 12:43:47.000000000 +0200
@@ -1369,6 +1369,16 @@ static int ieee80211_get_tx_power(struct
 	return 0;
 }
 
+static int ieee80211_set_wds_peer(struct wiphy *wiphy, struct net_device *dev,
+				  u8 *addr)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	memcpy(&sdata->u.wds.remote_addr, addr, ETH_ALEN);
+
+	return 0;
+}
+
 static void ieee80211_rfkill_poll(struct wiphy *wiphy)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
@@ -1454,6 +1464,7 @@ struct cfg80211_ops mac80211_config_ops 
 	.set_wiphy_params = ieee80211_set_wiphy_params,
 	.set_tx_power = ieee80211_set_tx_power,
 	.get_tx_power = ieee80211_get_tx_power,
+	.set_wds_peer = ieee80211_set_wds_peer,
 	.rfkill_poll = ieee80211_rfkill_poll,
 	CFG80211_TESTMODE_CMD(ieee80211_testmode_cmd)
 	.set_power_mgmt = ieee80211_set_power_mgmt,

-- 

