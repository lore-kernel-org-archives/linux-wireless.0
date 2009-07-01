Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbZGATgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:36:15 -0400
Message-Id: <20090701193421.155074452@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:56 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 15/20 v4] cfg80211: managed mode wext compatibility
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds code to make it possible to use the cfg80211
connect() API with wireless extensions, and because the
previous patch added emulation of that API with auth()
and assoc(), by extension also supports wext on that.
At the same time, removes code from mac80211 for wext,
but doesn't yet clean up mac80211's mlme code more.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |   36 ++++
 net/mac80211/mlme.c        |   69 ---------
 net/mac80211/wext.c        |  215 ++---------------------------
 net/wireless/Makefile      |    2 
 net/wireless/core.c        |   23 ++-
 net/wireless/core.h        |    3 
 net/wireless/nl80211.c     |    2 
 net/wireless/sme.c         |   55 ++++---
 net/wireless/wext-compat.c |  229 +++++++++++++++++++++++++------
 net/wireless/wext-sme.c    |  329 +++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 625 insertions(+), 338 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-07-01 20:58:27.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-01 21:15:12.000000000 +0200
@@ -1253,8 +1253,14 @@ struct wireless_dev {
 #ifdef CONFIG_WIRELESS_EXT
 	/* wext data */
 	struct {
-		struct cfg80211_ibss_params ibss;
+		union {
+			struct cfg80211_ibss_params ibss;
+			struct cfg80211_connect_params connect;
+		};
+		u8 *ie;
+		size_t ie_len;
 		u8 bssid[ETH_ALEN];
+		u8 ssid[IEEE80211_MAX_SSID_LEN];
 		s8 default_key, default_mgmt_key;
 	} wext;
 #endif
@@ -1535,6 +1541,34 @@ int cfg80211_ibss_wext_giwap(struct net_
 			     struct iw_request_info *info,
 			     struct sockaddr *ap_addr, char *extra);
 
+int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra);
+int cfg80211_mgd_wext_giwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra);
+int cfg80211_mgd_wext_siwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *ssid);
+int cfg80211_mgd_wext_giwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *ssid);
+int cfg80211_mgd_wext_siwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *ap_addr, char *extra);
+int cfg80211_mgd_wext_giwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *ap_addr, char *extra);
+int cfg80211_wext_siwgenie(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *extra);
+int cfg80211_wext_siwauth(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *data, char *extra);
+int cfg80211_wext_giwauth(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *data, char *extra);
+
 struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
 					     struct iw_freq *freq);
 
--- wireless-testing.orig/net/wireless/Makefile	2009-07-01 20:58:26.000000000 +0200
+++ wireless-testing/net/wireless/Makefile	2009-07-01 21:15:12.000000000 +0200
@@ -7,6 +7,6 @@ obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o ibss.o sme.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
-cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
+cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o wext-sme.o
 
 ccflags-y += -D__CHECK_ENDIAN__
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/wireless/wext-sme.c	2009-07-01 21:15:12.000000000 +0200
@@ -0,0 +1,329 @@
+/*
+ * cfg80211 wext compat for managed mode.
+ *
+ * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright (C) 2009   Intel Corporation. All rights reserved.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/if_arp.h>
+#include <net/cfg80211.h>
+#include "nl80211.h"
+
+static int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
+				     struct wireless_dev *wdev)
+{
+	int err;
+
+	if (!netif_running(wdev->netdev))
+		return 0;
+
+	wdev->wext.connect.ie = wdev->wext.ie;
+	wdev->wext.connect.ie_len = wdev->wext.ie_len;
+	wdev->wext.connect.privacy = wdev->wext.default_key != -1;
+
+	err = 0;
+	if (wdev->wext.connect.ssid_len != 0)
+		err = cfg80211_connect(rdev, wdev->netdev,
+					&wdev->wext.connect);
+
+	return err;
+}
+
+int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct ieee80211_channel *chan;
+	int err;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	chan = cfg80211_wext_freq(wdev->wiphy, freq);
+	if (chan && IS_ERR(chan))
+		return PTR_ERR(chan);
+
+	if (chan && (chan->flags & IEEE80211_CHAN_DISABLED))
+		return -EINVAL;
+
+	if (wdev->wext.connect.channel == chan)
+		return 0;
+
+	if (wdev->sme_state != CFG80211_SME_IDLE) {
+		bool event = true;
+		/* if SSID set, we'll try right again, avoid event */
+		if (wdev->wext.connect.ssid_len)
+			event = false;
+		err = cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
+					  dev, WLAN_REASON_DEAUTH_LEAVING,
+					  event);
+		if (err)
+			return err;
+	}
+
+	wdev->wext.connect.channel = chan;
+
+	/* SSID is not set, we just want to switch channel */
+	if (wdev->wext.connect.ssid_len && chan) {
+		if (!rdev->ops->set_channel)
+			return -EOPNOTSUPP;
+
+		return rdev->ops->set_channel(wdev->wiphy, chan,
+					      NL80211_CHAN_NO_HT);
+	}
+
+	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwfreq);
+
+int cfg80211_mgd_wext_giwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct ieee80211_channel *chan = NULL;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	if (wdev->current_bss)
+		chan = wdev->current_bss->channel;
+	else if (wdev->wext.connect.channel)
+		chan = wdev->wext.connect.channel;
+
+	if (chan) {
+		freq->m = chan->center_freq;
+		freq->e = 6;
+		return 0;
+	}
+
+	/* no channel if not joining */
+	return -EINVAL;
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_giwfreq);
+
+int cfg80211_mgd_wext_siwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *ssid)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	size_t len = data->length;
+	int err;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	if (!data->flags)
+		len = 0;
+
+	/* iwconfig uses nul termination in SSID.. */
+	if (len > 0 && ssid[len - 1] == '\0')
+		len--;
+
+	if (wdev->wext.connect.ssid && len &&
+	    len == wdev->wext.connect.ssid_len &&
+	    memcmp(wdev->wext.connect.ssid, ssid, len))
+		return 0;
+
+	if (wdev->sme_state != CFG80211_SME_IDLE) {
+		bool event = true;
+		/* if SSID set now, we'll try to connect, avoid event */
+		if (len)
+			event = false;
+		err = cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
+					  dev, WLAN_REASON_DEAUTH_LEAVING,
+					  event);
+		if (err)
+			return err;
+	}
+
+	wdev->wext.connect.ssid = wdev->wext.ssid;
+	memcpy(wdev->wext.ssid, ssid, len);
+	wdev->wext.connect.ssid_len = len;
+
+	wdev->wext.connect.crypto.control_port = false;
+
+	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwessid);
+
+int cfg80211_mgd_wext_giwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *ssid)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	data->flags = 0;
+
+	if (wdev->ssid_len) {
+		data->flags = 1;
+		data->length = wdev->ssid_len;
+		memcpy(ssid, wdev->ssid, data->length);
+	} else if (wdev->wext.connect.ssid && wdev->wext.connect.ssid_len) {
+		data->flags = 1;
+		data->length = wdev->wext.connect.ssid_len;
+		memcpy(ssid, wdev->wext.connect.ssid, data->length);
+	} else
+		data->flags = 0;
+
+	return 0;
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_giwessid);
+
+int cfg80211_mgd_wext_siwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *ap_addr, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	u8 *bssid = ap_addr->sa_data;
+	int err;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	if (ap_addr->sa_family != ARPHRD_ETHER)
+		return -EINVAL;
+
+	/* automatic mode */
+	if (is_zero_ether_addr(bssid) || is_broadcast_ether_addr(bssid))
+		bssid = NULL;
+
+	/* both automatic */
+	if (!bssid && !wdev->wext.connect.bssid)
+		return 0;
+
+	/* fixed already - and no change */
+	if (wdev->wext.connect.bssid && bssid &&
+	    compare_ether_addr(bssid, wdev->wext.connect.bssid) == 0)
+		return 0;
+
+	if (wdev->sme_state != CFG80211_SME_IDLE) {
+		err = cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
+					  dev, WLAN_REASON_DEAUTH_LEAVING,
+					  false);
+		if (err)
+			return err;
+	}
+
+	if (bssid) {
+		memcpy(wdev->wext.bssid, bssid, ETH_ALEN);
+		wdev->wext.connect.bssid = wdev->wext.bssid;
+	} else
+		wdev->wext.connect.bssid = NULL;
+
+	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwap);
+
+int cfg80211_mgd_wext_giwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *ap_addr, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	ap_addr->sa_family = ARPHRD_ETHER;
+
+	if (wdev->current_bss)
+		memcpy(ap_addr->sa_data, wdev->current_bss->bssid, ETH_ALEN);
+	else if (wdev->wext.connect.bssid)
+		memcpy(ap_addr->sa_data, wdev->wext.connect.bssid, ETH_ALEN);
+	else
+		memset(ap_addr->sa_data, 0, ETH_ALEN);
+
+	return 0;
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_giwap);
+
+int cfg80211_wext_siwgenie(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	u8 *ie = extra;
+	int ie_len = data->length, err;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	if (!ie_len)
+		ie = NULL;
+
+	/* no change */
+	if (wdev->wext.ie_len == ie_len &&
+	    memcmp(wdev->wext.ie, ie, ie_len) == 0)
+		return 0;
+
+	if (ie_len) {
+		ie = kmemdup(extra, ie_len, GFP_KERNEL);
+		if (!ie)
+			return -ENOMEM;
+	} else
+		ie = NULL;
+
+	kfree(wdev->wext.ie);
+	wdev->wext.ie = ie;
+	wdev->wext.ie_len = ie_len;
+
+	if (wdev->sme_state != CFG80211_SME_IDLE) {
+		err = cfg80211_disconnect(rdev, dev,
+					  WLAN_REASON_DEAUTH_LEAVING, false);
+		if (err)
+			return err;
+	}
+
+	/* userspace better not think we'll reconnect */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwgenie);
+
+int cfg80211_wext_siwmlme(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_point *data, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct iw_mlme *mlme = (struct iw_mlme *)extra;
+	struct cfg80211_registered_device *rdev;
+
+	if (!wdev)
+		return -EOPNOTSUPP;
+
+	rdev = wiphy_to_dev(wdev->wiphy);
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION)
+		return -EINVAL;
+
+	if (mlme->addr.sa_family != ARPHRD_ETHER)
+		return -EINVAL;
+
+	switch (mlme->cmd) {
+	case IW_MLME_DEAUTH:
+	case IW_MLME_DISASSOC:
+		return cfg80211_disconnect(rdev, dev, mlme->reason_code,
+					   true);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwmlme);
--- wireless-testing.orig/net/wireless/core.c	2009-07-01 20:58:27.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-01 21:15:12.000000000 +0200
@@ -553,6 +553,7 @@ static int cfg80211_netdev_notifier_call
 #ifdef CONFIG_WIRELESS_EXT
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
+		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
 #endif
 		mutex_unlock(&rdev->devlist_mtx);
 		break;
@@ -565,8 +566,13 @@ static int cfg80211_netdev_notifier_call
 			cfg80211_leave_ibss(rdev, dev, true);
 			break;
 		case NL80211_IFTYPE_STATION:
+#ifdef CONFIG_WIRELESS_EXT
+			kfree(wdev->wext.ie);
+			wdev->wext.ie = NULL;
+			wdev->wext.ie_len = 0;
+#endif
 			cfg80211_disconnect(rdev, dev,
-					    WLAN_REASON_DEAUTH_LEAVING);
+					    WLAN_REASON_DEAUTH_LEAVING, true);
 			break;
 		default:
 			break;
@@ -578,11 +584,20 @@ static int cfg80211_netdev_notifier_call
 		break;
 	case NETDEV_UP:
 #ifdef CONFIG_WIRELESS_EXT
-		if (wdev->iftype != NL80211_IFTYPE_ADHOC)
+		switch (wdev->iftype) {
+		case NL80211_IFTYPE_ADHOC:
+			if (wdev->wext.ibss.ssid_len)
+				cfg80211_join_ibss(rdev, dev,
+						   &wdev->wext.ibss);
 			break;
-		if (!wdev->wext.ibss.ssid_len)
+		case NL80211_IFTYPE_STATION:
+			if (wdev->wext.connect.ssid_len)
+				cfg80211_connect(rdev, dev,
+						 &wdev->wext.connect);
+			break;
+		default:
 			break;
-		cfg80211_join_ibss(rdev, dev, &wdev->wext.ibss);
+		}
 #endif
 		break;
 	case NETDEV_UNREGISTER:
--- wireless-testing.orig/net/mac80211/wext.c	2009-07-01 20:50:38.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-07-01 21:15:12.000000000 +0200
@@ -27,29 +27,6 @@
 #include "aes_ccm.h"
 
 
-static int ieee80211_ioctl_siwgenie(struct net_device *dev,
-				    struct iw_request_info *info,
-				    struct iw_point *data, char *extra)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		int ret = ieee80211_sta_set_extra_ie(sdata, extra, data->length);
-		if (ret && ret != -EALREADY)
-			return ret;
-		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
-		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
-		sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
-		if (ret != -EALREADY)
-			ieee80211_sta_req_auth(sdata);
-		return 0;
-	}
-
-	return -EOPNOTSUPP;
-}
-
 static int ieee80211_ioctl_siwfreq(struct net_device *dev,
 				   struct iw_request_info *info,
 				   struct iw_freq *freq, char *extra)
@@ -61,16 +38,13 @@ static int ieee80211_ioctl_siwfreq(struc
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_siwfreq(dev, info, freq, extra);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_CHANNEL_SEL;
+		return cfg80211_mgd_wext_siwfreq(dev, info, freq, extra);
 
 	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
 	if (freq->e == 0) {
-		if (freq->m < 0) {
-			if (sdata->vif.type == NL80211_IFTYPE_STATION)
-				sdata->u.mgd.flags |=
-					IEEE80211_STA_AUTO_CHANNEL_SEL;
-			return 0;
-		} else
+		if (freq->m < 0)
+			return -EINVAL;
+		else
 			chan = ieee80211_get_channel(local->hw.wiphy,
 				ieee80211_channel_to_frequency(freq->m));
 	} else {
@@ -95,9 +69,6 @@ static int ieee80211_ioctl_siwfreq(struc
 	if (local->oper_channel == chan)
 		return 0;
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		ieee80211_sta_req_auth(sdata);
-
 	local->oper_channel = chan;
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 	ieee80211_hw_config(local, 0);
@@ -115,6 +86,8 @@ static int ieee80211_ioctl_giwfreq(struc
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
+	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return cfg80211_mgd_wext_giwfreq(dev, info, freq, extra);
 
 	freq->m = local->oper_channel->center_freq;
 	freq->e = 6;
@@ -128,31 +101,11 @@ static int ieee80211_ioctl_siwessid(stru
 				    struct iw_point *data, char *ssid)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	size_t len = data->length;
-	int ret;
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_siwessid(dev, info, data, ssid);
-
-	/* iwconfig uses nul termination in SSID.. */
-	if (len > 0 && ssid[len - 1] == '\0')
-		len--;
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		if (data->flags)
-			sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
-		else
-			sdata->u.mgd.flags |= IEEE80211_STA_AUTO_SSID_SEL;
-
-		ret = ieee80211_sta_set_ssid(sdata, ssid, len);
-		if (ret)
-			return ret;
-
-		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
-		sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
-		ieee80211_sta_req_auth(sdata);
-		return 0;
-	}
+	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return cfg80211_mgd_wext_siwessid(dev, info, data, ssid);
 
 	return -EOPNOTSUPP;
 }
@@ -162,23 +115,14 @@ static int ieee80211_ioctl_giwessid(stru
 				    struct iw_request_info *info,
 				    struct iw_point *data, char *ssid)
 {
-	size_t len;
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_giwessid(dev, info, data, ssid);
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		int res = ieee80211_sta_get_ssid(sdata, ssid, &len);
-		if (res == 0) {
-			data->length = len;
-			data->flags = 1;
-		} else
-			data->flags = 0;
-		return res;
-	}
+	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return cfg80211_mgd_wext_giwessid(dev, info, data, ssid);
 
 	return -EOPNOTSUPP;
 }
@@ -193,24 +137,10 @@ static int ieee80211_ioctl_siwap(struct 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_siwap(dev, info, ap_addr, extra);
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		int ret;
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return cfg80211_mgd_wext_siwap(dev, info, ap_addr, extra);
 
-		if (is_zero_ether_addr((u8 *) &ap_addr->sa_data))
-			sdata->u.mgd.flags |= IEEE80211_STA_AUTO_BSSID_SEL |
-				IEEE80211_STA_AUTO_CHANNEL_SEL;
-		else if (is_broadcast_ether_addr((u8 *) &ap_addr->sa_data))
-			sdata->u.mgd.flags |= IEEE80211_STA_AUTO_BSSID_SEL;
-		else
-			sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
-		ret = ieee80211_sta_set_bssid(sdata, (u8 *) &ap_addr->sa_data);
-		if (ret)
-			return ret;
-		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
-		sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
-		ieee80211_sta_req_auth(sdata);
-		return 0;
-	} else if (sdata->vif.type == NL80211_IFTYPE_WDS) {
+	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		/*
 		 * If it is necessary to update the WDS peer address
 		 * while the interface is running, then we need to do
@@ -240,14 +170,10 @@ static int ieee80211_ioctl_giwap(struct 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_giwap(dev, info, ap_addr, extra);
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		if (sdata->u.mgd.state == IEEE80211_STA_MLME_ASSOCIATED) {
-			ap_addr->sa_family = ARPHRD_ETHER;
-			memcpy(&ap_addr->sa_data, sdata->u.mgd.bssid, ETH_ALEN);
-		} else
-			memset(&ap_addr->sa_data, 0, ETH_ALEN);
-		return 0;
-	} else if (sdata->vif.type == NL80211_IFTYPE_WDS) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return cfg80211_mgd_wext_giwap(dev, info, ap_addr, extra);
+
+	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		ap_addr->sa_family = ARPHRD_ETHER;
 		memcpy(&ap_addr->sa_data, sdata->u.wds.remote_addr, ETH_ALEN);
 		return 0;
@@ -395,85 +321,6 @@ static int ieee80211_ioctl_giwpower(stru
 	return 0;
 }
 
-static int ieee80211_ioctl_siwauth(struct net_device *dev,
-				   struct iw_request_info *info,
-				   struct iw_param *data, char *extra)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	int ret = 0;
-
-	switch (data->flags & IW_AUTH_INDEX) {
-	case IW_AUTH_WPA_VERSION:
-	case IW_AUTH_CIPHER_GROUP:
-	case IW_AUTH_WPA_ENABLED:
-	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
-	case IW_AUTH_KEY_MGMT:
-	case IW_AUTH_CIPHER_GROUP_MGMT:
-		break;
-	case IW_AUTH_CIPHER_PAIRWISE:
-		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			if (data->value & (IW_AUTH_CIPHER_WEP40 |
-			    IW_AUTH_CIPHER_WEP104 | IW_AUTH_CIPHER_TKIP))
-				sdata->u.mgd.flags |=
-					IEEE80211_STA_TKIP_WEP_USED;
-			else
-				sdata->u.mgd.flags &=
-					~IEEE80211_STA_TKIP_WEP_USED;
-		}
-		break;
-	case IW_AUTH_DROP_UNENCRYPTED:
-		sdata->drop_unencrypted = !!data->value;
-		break;
-	case IW_AUTH_PRIVACY_INVOKED:
-		if (sdata->vif.type != NL80211_IFTYPE_STATION)
-			ret = -EINVAL;
-		else {
-			sdata->u.mgd.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
-			/*
-			 * Privacy invoked by wpa_supplicant, store the
-			 * value and allow associating to a protected
-			 * network without having a key up front.
-			 */
-			if (data->value)
-				sdata->u.mgd.flags |=
-					IEEE80211_STA_PRIVACY_INVOKED;
-		}
-		break;
-	case IW_AUTH_80211_AUTH_ALG:
-		if (sdata->vif.type == NL80211_IFTYPE_STATION)
-			sdata->u.mgd.auth_algs = data->value;
-		else
-			ret = -EOPNOTSUPP;
-		break;
-	case IW_AUTH_MFP:
-		if (!(sdata->local->hw.flags & IEEE80211_HW_MFP_CAPABLE)) {
-			ret = -EOPNOTSUPP;
-			break;
-		}
-		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			switch (data->value) {
-			case IW_AUTH_MFP_DISABLED:
-				sdata->u.mgd.mfp = IEEE80211_MFP_DISABLED;
-				break;
-			case IW_AUTH_MFP_OPTIONAL:
-				sdata->u.mgd.mfp = IEEE80211_MFP_OPTIONAL;
-				break;
-			case IW_AUTH_MFP_REQUIRED:
-				sdata->u.mgd.mfp = IEEE80211_MFP_REQUIRED;
-				break;
-			default:
-				ret = -EINVAL;
-			}
-		} else
-			ret = -EOPNOTSUPP;
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-	return ret;
-}
-
 /* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
 static struct iw_statistics *ieee80211_get_wireless_stats(struct net_device *dev)
 {
@@ -541,28 +388,6 @@ static struct iw_statistics *ieee80211_g
 	return wstats;
 }
 
-static int ieee80211_ioctl_giwauth(struct net_device *dev,
-				   struct iw_request_info *info,
-				   struct iw_param *data, char *extra)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	int ret = 0;
-
-	switch (data->flags & IW_AUTH_INDEX) {
-	case IW_AUTH_80211_AUTH_ALG:
-		if (sdata->vif.type == NL80211_IFTYPE_STATION)
-			data->value = sdata->u.mgd.auth_algs;
-		else
-			ret = -EOPNOTSUPP;
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-	return ret;
-}
-
-
 /* Structures to export the Wireless Handlers */
 
 static const iw_handler ieee80211_handler[] =
@@ -615,10 +440,10 @@ static const iw_handler ieee80211_handle
 	(iw_handler) ieee80211_ioctl_giwpower,		/* SIOCGIWPOWER */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) ieee80211_ioctl_siwgenie,		/* SIOCSIWGENIE */
+	(iw_handler) cfg80211_wext_siwgenie,		/* SIOCSIWGENIE */
 	(iw_handler) NULL,				/* SIOCGIWGENIE */
-	(iw_handler) ieee80211_ioctl_siwauth,		/* SIOCSIWAUTH */
-	(iw_handler) ieee80211_ioctl_giwauth,		/* SIOCGIWAUTH */
+	(iw_handler) cfg80211_wext_siwauth,		/* SIOCSIWAUTH */
+	(iw_handler) cfg80211_wext_giwauth,		/* SIOCGIWAUTH */
 	(iw_handler) cfg80211_wext_siwencodeext,	/* SIOCSIWENCODEEXT */
 	(iw_handler) NULL,				/* SIOCGIWENCODEEXT */
 	(iw_handler) NULL,				/* SIOCSIWPMKSA */
--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-01 20:50:38.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-01 21:15:12.000000000 +0200
@@ -870,70 +870,6 @@ static u32 ieee80211_handle_bss_capabili
 	return changed;
 }
 
-static void ieee80211_sta_send_apinfo(struct ieee80211_sub_if_data *sdata)
-{
-	union iwreq_data wrqu;
-
-	memset(&wrqu, 0, sizeof(wrqu));
-	if (sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED)
-		memcpy(wrqu.ap_addr.sa_data, sdata->u.mgd.bssid, ETH_ALEN);
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
-}
-
-static void ieee80211_sta_send_associnfo(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	char *buf;
-	size_t len;
-	int i;
-	union iwreq_data wrqu;
-
-	if (!ifmgd->assocreq_ies && !ifmgd->assocresp_ies)
-		return;
-
-	buf = kmalloc(50 + 2 * (ifmgd->assocreq_ies_len +
-				ifmgd->assocresp_ies_len), GFP_KERNEL);
-	if (!buf)
-		return;
-
-	len = sprintf(buf, "ASSOCINFO(");
-	if (ifmgd->assocreq_ies) {
-		len += sprintf(buf + len, "ReqIEs=");
-		for (i = 0; i < ifmgd->assocreq_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifmgd->assocreq_ies[i]);
-		}
-	}
-	if (ifmgd->assocresp_ies) {
-		if (ifmgd->assocreq_ies)
-			len += sprintf(buf + len, " ");
-		len += sprintf(buf + len, "RespIEs=");
-		for (i = 0; i < ifmgd->assocresp_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifmgd->assocresp_ies[i]);
-		}
-	}
-	len += sprintf(buf + len, ")");
-
-	if (len > IW_CUSTOM_MAX) {
-		len = sprintf(buf, "ASSOCRESPIE=");
-		for (i = 0; i < ifmgd->assocresp_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifmgd->assocresp_ies[i]);
-		}
-	}
-
-	if (len <= IW_CUSTOM_MAX) {
-		memset(&wrqu, 0, sizeof(wrqu));
-		wrqu.data.length = len;
-		wireless_send_event(sdata->dev, IWEVCUSTOM, &wrqu, buf);
-	}
-
-	kfree(buf);
-}
-
-
 static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 				     u32 bss_info_changed)
 {
@@ -966,7 +902,6 @@ static void ieee80211_set_associated(str
 
 	ifmgd->flags |= IEEE80211_STA_PREV_BSSID_SET;
 	memcpy(ifmgd->prev_bssid, sdata->u.mgd.bssid, ETH_ALEN);
-	ieee80211_sta_send_associnfo(sdata);
 
 	ifmgd->last_probe = jiffies;
 	ieee80211_led_assoc(local, 1);
@@ -993,8 +928,6 @@ static void ieee80211_set_associated(str
 
 	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
-
-	ieee80211_sta_send_apinfo(sdata);
 }
 
 static void ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata)
@@ -1147,8 +1080,6 @@ static void ieee80211_set_disassoc(struc
 	changed |= BSS_CHANGED_ASSOC;
 	sdata->vif.bss_conf.assoc = false;
 
-	ieee80211_sta_send_apinfo(sdata);
-
 	if (self_disconnected || reason == WLAN_REASON_DISASSOC_STA_HAS_LEFT) {
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-07-01 20:50:38.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-07-01 21:15:45.000000000 +0200
@@ -261,50 +261,6 @@ int cfg80211_wext_giwrange(struct net_de
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwrange);
 
-int cfg80211_wext_siwmlme(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_point *data, char *extra)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-	struct cfg80211_registered_device *rdev;
-	union {
-		struct cfg80211_disassoc_request disassoc;
-		struct cfg80211_deauth_request deauth;
-	} cmd;
-
-	if (!wdev)
-		return -EOPNOTSUPP;
-
-	rdev = wiphy_to_dev(wdev->wiphy);
-
-	if (wdev->iftype != NL80211_IFTYPE_STATION)
-		return -EINVAL;
-
-	if (mlme->addr.sa_family != ARPHRD_ETHER)
-		return -EINVAL;
-
-	memset(&cmd, 0, sizeof(cmd));
-
-	switch (mlme->cmd) {
-	case IW_MLME_DEAUTH:
-		if (!rdev->ops->deauth)
-			return -EOPNOTSUPP;
-		cmd.deauth.peer_addr = mlme->addr.sa_data;
-		cmd.deauth.reason_code = mlme->reason_code;
-		return rdev->ops->deauth(wdev->wiphy, dev, &cmd.deauth);
-	case IW_MLME_DISASSOC:
-		if (!rdev->ops->disassoc)
-			return -EOPNOTSUPP;
-		cmd.disassoc.peer_addr = mlme->addr.sa_data;
-		cmd.disassoc.reason_code = mlme->reason_code;
-		return rdev->ops->disassoc(wdev->wiphy, dev, &cmd.disassoc);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwmlme);
-
 
 /**
  * cfg80211_wext_freq - get wext frequency for non-"auto"
@@ -846,3 +802,188 @@ int cfg80211_wext_giwtxpower(struct net_
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwtxpower);
+
+static int cfg80211_set_auth_alg(struct wireless_dev *wdev,
+				 s32 auth_alg)
+{
+	int nr_alg = 0;
+
+	if (!auth_alg)
+		return -EINVAL;
+
+	if (auth_alg & ~(IW_AUTH_ALG_OPEN_SYSTEM |
+			 IW_AUTH_ALG_SHARED_KEY |
+			 IW_AUTH_ALG_LEAP))
+		return -EINVAL;
+
+	if (auth_alg & IW_AUTH_ALG_OPEN_SYSTEM) {
+		nr_alg++;
+		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_OPEN_SYSTEM;
+	}
+
+	if (auth_alg & IW_AUTH_ALG_SHARED_KEY) {
+		nr_alg++;
+		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_SHARED_KEY;
+	}
+
+	if (auth_alg & IW_AUTH_ALG_LEAP) {
+		nr_alg++;
+		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_NETWORK_EAP;
+	}
+
+	if (nr_alg > 1)
+		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
+
+	return 0;
+}
+
+static int cfg80211_set_wpa_version(struct wireless_dev *wdev, u32 wpa_versions)
+{
+	wdev->wext.connect.crypto.wpa_versions = 0;
+
+	if (wpa_versions & ~(IW_AUTH_WPA_VERSION_WPA |
+			     IW_AUTH_WPA_VERSION_WPA2))
+		return -EINVAL;
+
+	if (wpa_versions & IW_AUTH_WPA_VERSION_WPA)
+		wdev->wext.connect.crypto.wpa_versions |=
+			NL80211_WPA_VERSION_1;
+
+	if (wpa_versions & IW_AUTH_WPA_VERSION_WPA2)
+		wdev->wext.connect.crypto.wpa_versions |=
+			NL80211_WPA_VERSION_2;
+
+	return 0;
+}
+
+int cfg80211_set_cipher_group(struct wireless_dev *wdev, u32 cipher)
+{
+	wdev->wext.connect.crypto.cipher_group = 0;
+
+	if (cipher & IW_AUTH_CIPHER_WEP40)
+		wdev->wext.connect.crypto.cipher_group =
+			WLAN_CIPHER_SUITE_WEP40;
+	else if (cipher & IW_AUTH_CIPHER_WEP104)
+		wdev->wext.connect.crypto.cipher_group =
+			WLAN_CIPHER_SUITE_WEP104;
+	else if (cipher & IW_AUTH_CIPHER_TKIP)
+		wdev->wext.connect.crypto.cipher_group =
+			WLAN_CIPHER_SUITE_TKIP;
+	else if (cipher & IW_AUTH_CIPHER_CCMP)
+		wdev->wext.connect.crypto.cipher_group =
+			WLAN_CIPHER_SUITE_CCMP;
+	else if (cipher & IW_AUTH_CIPHER_AES_CMAC)
+		wdev->wext.connect.crypto.cipher_group =
+			WLAN_CIPHER_SUITE_AES_CMAC;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+int cfg80211_set_cipher_pairwise(struct wireless_dev *wdev, u32 cipher)
+{
+	int nr_ciphers = 0;
+	u32 *ciphers_pairwise = wdev->wext.connect.crypto.ciphers_pairwise;
+
+	if (cipher & IW_AUTH_CIPHER_WEP40) {
+		ciphers_pairwise[nr_ciphers] = WLAN_CIPHER_SUITE_WEP40;
+		nr_ciphers++;
+	}
+
+	if (cipher & IW_AUTH_CIPHER_WEP104) {
+		ciphers_pairwise[nr_ciphers] = WLAN_CIPHER_SUITE_WEP104;
+		nr_ciphers++;
+	}
+
+	if (cipher & IW_AUTH_CIPHER_TKIP) {
+		ciphers_pairwise[nr_ciphers] = WLAN_CIPHER_SUITE_TKIP;
+		nr_ciphers++;
+	}
+
+	if (cipher & IW_AUTH_CIPHER_CCMP) {
+		ciphers_pairwise[nr_ciphers] = WLAN_CIPHER_SUITE_CCMP;
+		nr_ciphers++;
+	}
+
+	if (cipher & IW_AUTH_CIPHER_AES_CMAC) {
+		ciphers_pairwise[nr_ciphers] = WLAN_CIPHER_SUITE_AES_CMAC;
+		nr_ciphers++;
+	}
+
+	BUILD_BUG_ON(NL80211_MAX_NR_CIPHER_SUITES < 5);
+
+	wdev->wext.connect.crypto.n_ciphers_pairwise = nr_ciphers;
+
+	return 0;
+}
+
+
+int cfg80211_set_key_mgt(struct wireless_dev *wdev, u32 key_mgt)
+{
+	int nr_akm_suites = 0;
+
+	if (key_mgt & ~(IW_AUTH_KEY_MGMT_802_1X |
+			IW_AUTH_KEY_MGMT_PSK))
+		return -EINVAL;
+
+	if (key_mgt & IW_AUTH_KEY_MGMT_802_1X) {
+		wdev->wext.connect.crypto.akm_suites[nr_akm_suites] =
+			WLAN_AKM_SUITE_8021X;
+		nr_akm_suites++;
+	}
+
+	if (key_mgt & IW_AUTH_KEY_MGMT_PSK) {
+		wdev->wext.connect.crypto.akm_suites[nr_akm_suites] =
+			WLAN_AKM_SUITE_PSK;
+		nr_akm_suites++;
+	}
+
+	wdev->wext.connect.crypto.n_akm_suites = nr_akm_suites;
+
+	return 0;
+}
+
+int cfg80211_wext_siwauth(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *data, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	switch (data->flags & IW_AUTH_INDEX) {
+	case IW_AUTH_PRIVACY_INVOKED:
+		wdev->wext.connect.privacy = data->value;
+		return 0;
+	case IW_AUTH_WPA_VERSION:
+		return cfg80211_set_wpa_version(wdev, data->value);
+	case IW_AUTH_CIPHER_GROUP:
+		return cfg80211_set_cipher_group(wdev, data->value);
+	case IW_AUTH_KEY_MGMT:
+		return cfg80211_set_key_mgt(wdev, data->value);
+	case IW_AUTH_CIPHER_PAIRWISE:
+		return cfg80211_set_cipher_pairwise(wdev, data->value);
+	case IW_AUTH_80211_AUTH_ALG:
+		return cfg80211_set_auth_alg(wdev, data->value);
+	case IW_AUTH_WPA_ENABLED:
+	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
+	case IW_AUTH_DROP_UNENCRYPTED:
+	case IW_AUTH_MFP:
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwauth);
+
+int cfg80211_wext_giwauth(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *data, char *extra)
+{
+	/* XXX: what do we need? */
+
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_giwauth);
--- wireless-testing.orig/net/wireless/core.h	2009-07-01 20:58:27.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-07-01 21:15:12.000000000 +0200
@@ -181,7 +181,8 @@ int cfg80211_connect(struct cfg80211_reg
 		     struct net_device *dev,
 		     struct cfg80211_connect_params *connect);
 int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
-			struct net_device *dev, u16 reason);
+			struct net_device *dev, u16 reason,
+			bool wextev);
 
 void cfg80211_conn_work(struct work_struct *work);
 
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-01 20:58:27.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-01 21:15:12.000000000 +0200
@@ -3746,7 +3746,7 @@ static int nl80211_disconnect(struct sk_
 		goto out;
 	}
 
-	err = cfg80211_disconnect(drv, dev, reason);
+	err = cfg80211_disconnect(drv, dev, reason, true);
 
 out:
 	cfg80211_put_dev(drv);
--- wireless-testing.orig/net/wireless/sme.c	2009-07-01 20:58:27.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-07-01 21:15:12.000000000 +0200
@@ -270,10 +270,10 @@ void cfg80211_sme_rx_auth(struct net_dev
 	}
 }
 
-void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
-			     const u8 *req_ie, size_t req_ie_len,
-			     const u8 *resp_ie, size_t resp_ie_len,
-			     u16 status, gfp_t gfp)
+static void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
+				      const u8 *req_ie, size_t req_ie_len,
+				      const u8 *resp_ie, size_t resp_ie_len,
+				      u16 status, bool wextev, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_bss *bss;
@@ -318,25 +318,36 @@ void cfg80211_connect_result(struct net_
 				    status, gfp);
 
 #ifdef CONFIG_WIRELESS_EXT
-	if (req_ie && status == WLAN_STATUS_SUCCESS) {
-		memset(&wrqu, 0, sizeof(wrqu));
-		wrqu.data.length = req_ie_len;
-		wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, req_ie);
-	}
+	if (wextev) {
+		if (req_ie && status == WLAN_STATUS_SUCCESS) {
+			memset(&wrqu, 0, sizeof(wrqu));
+			wrqu.data.length = req_ie_len;
+			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, req_ie);
+		}
+
+		if (resp_ie && status == WLAN_STATUS_SUCCESS) {
+			memset(&wrqu, 0, sizeof(wrqu));
+			wrqu.data.length = resp_ie_len;
+			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, resp_ie);
+		}
 
-	if (resp_ie && status == WLAN_STATUS_SUCCESS) {
 		memset(&wrqu, 0, sizeof(wrqu));
-		wrqu.data.length = resp_ie_len;
-		wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, resp_ie);
+		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+		if (bssid && status == WLAN_STATUS_SUCCESS)
+			memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+		wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 	}
-
-	memset(&wrqu, 0, sizeof(wrqu));
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	if (bssid && status == WLAN_STATUS_SUCCESS)
-		memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
-	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 #endif
 }
+
+void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
+			     const u8 *req_ie, size_t req_ie_len,
+			     const u8 *resp_ie, size_t resp_ie_len,
+			     u16 status, gfp_t gfp)
+{
+	bool wextev = status == WLAN_STATUS_SUCCESS;
+	__cfg80211_connect_result(dev, bssid, req_ie, req_ie_len, resp_ie, resp_ie_len, status, wextev, gfp);
+}
 EXPORT_SYMBOL(cfg80211_connect_result);
 
 void cfg80211_roamed(struct net_device *dev, const u8 *bssid,
@@ -537,7 +548,7 @@ int cfg80211_connect(struct cfg80211_reg
 }
 
 int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
-			struct net_device *dev, u16 reason)
+			struct net_device *dev, u16 reason, bool wextev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
@@ -582,9 +593,9 @@ int cfg80211_disconnect(struct cfg80211_
 	if (wdev->sme_state == CFG80211_SME_CONNECTED)
 		__cfg80211_disconnected(dev, GFP_KERNEL, NULL, 0, 0, false);
 	else if (wdev->sme_state == CFG80211_SME_CONNECTING)
-		cfg80211_connect_result(dev, NULL, NULL, 0, NULL, 0,
-					WLAN_STATUS_UNSPECIFIED_FAILURE,
-					GFP_KERNEL);
+		__cfg80211_connect_result(dev, NULL, NULL, 0, NULL, 0,
+					  WLAN_STATUS_UNSPECIFIED_FAILURE,
+					  wextev, GFP_KERNEL);
 
 	return 0;
 }

-- 

