Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbZG0KD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 06:03:28 -0400
Message-Id: <20090727100243.825519433@sipsolutions.net>
References: <20090727100149.839649874@sipsolutions.net>
Date: Mon, 27 Jul 2009 12:01:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] cfg80211: combine IWAP handlers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we now have IWAP handlers for all modes, we can
combine them into one.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwmc3200wifi/wext.c |   34 +-------------------
 include/net/cfg80211.h                   |   24 +++-----------
 net/mac80211/wext.c                      |   41 +-----------------------
 net/wireless/ibss.c                      |    4 --
 net/wireless/wext-compat.c               |   52 ++++++++++++++++++++++++++-----
 net/wireless/wext-compat.h               |   12 +++++++
 net/wireless/wext-sme.c                  |    4 --
 7 files changed, 66 insertions(+), 105 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-07-25 10:44:27.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-25 10:44:27.000000000 +0200
@@ -1601,12 +1601,6 @@ int cfg80211_ibss_wext_siwessid(struct n
 int cfg80211_ibss_wext_giwessid(struct net_device *dev,
 				struct iw_request_info *info,
 				struct iw_point *data, char *ssid);
-int cfg80211_ibss_wext_siwap(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct sockaddr *ap_addr, char *extra);
-int cfg80211_ibss_wext_giwap(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct sockaddr *ap_addr, char *extra);
 
 int cfg80211_mgd_wext_siwessid(struct net_device *dev,
 			       struct iw_request_info *info,
@@ -1614,12 +1608,6 @@ int cfg80211_mgd_wext_siwessid(struct ne
 int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 			       struct iw_request_info *info,
 			       struct iw_point *data, char *ssid);
-int cfg80211_mgd_wext_siwap(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct sockaddr *ap_addr, char *extra);
-int cfg80211_mgd_wext_giwap(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct sockaddr *ap_addr, char *extra);
 int cfg80211_wext_siwgenie(struct net_device *dev,
 			   struct iw_request_info *info,
 			   struct iw_point *data, char *extra);
@@ -1686,12 +1674,12 @@ int cfg80211_wext_giwpower(struct net_de
 			   struct iw_request_info *info,
 			   struct iw_param *wrq, char *extra);
 
-int cfg80211_wds_wext_siwap(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct sockaddr *addr, char *extra);
-int cfg80211_wds_wext_giwap(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct sockaddr *addr, char *extra);
+int cfg80211_wext_siwap(struct net_device *dev,
+			struct iw_request_info *info,
+			struct sockaddr *ap_addr, char *extra);
+int cfg80211_wext_giwap(struct net_device *dev,
+			struct iw_request_info *info,
+			struct sockaddr *ap_addr, char *extra);
 
 /*
  * callbacks for asynchronous cfg80211 methods, notification
--- wireless-testing.orig/net/mac80211/wext.c	2009-07-25 10:44:27.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-07-25 10:44:27.000000000 +0200
@@ -59,43 +59,6 @@ static int ieee80211_ioctl_giwessid(stru
 }
 
 
-static int ieee80211_ioctl_siwap(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct sockaddr *ap_addr, char *extra)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		return cfg80211_ibss_wext_siwap(dev, info, ap_addr, extra);
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		return cfg80211_mgd_wext_siwap(dev, info, ap_addr, extra);
-
-	if (sdata->vif.type == NL80211_IFTYPE_WDS)
-		return cfg80211_wds_wext_siwap(dev, info, ap_addr, extra);
-	return -EOPNOTSUPP;
-}
-
-
-static int ieee80211_ioctl_giwap(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct sockaddr *ap_addr, char *extra)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		return cfg80211_ibss_wext_giwap(dev, info, ap_addr, extra);
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		return cfg80211_mgd_wext_giwap(dev, info, ap_addr, extra);
-
-	if (sdata->vif.type == NL80211_IFTYPE_WDS)
-		return cfg80211_wds_wext_giwap(dev, info, ap_addr, extra);
-
-	return -EOPNOTSUPP;
-}
-
-
 /* Structures to export the Wireless Handlers */
 
 static const iw_handler ieee80211_handler[] =
@@ -120,8 +83,8 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* SIOCGIWSPY */
 	(iw_handler) NULL,				/* SIOCSIWTHRSPY */
 	(iw_handler) NULL,				/* SIOCGIWTHRSPY */
-	(iw_handler) ieee80211_ioctl_siwap,		/* SIOCSIWAP */
-	(iw_handler) ieee80211_ioctl_giwap,		/* SIOCGIWAP */
+	(iw_handler) cfg80211_wext_siwap,		/* SIOCSIWAP */
+	(iw_handler) cfg80211_wext_giwap,		/* SIOCGIWAP */
 	(iw_handler) cfg80211_wext_siwmlme,		/* SIOCSIWMLME */
 	(iw_handler) NULL,				/* SIOCGIWAPLIST */
 	(iw_handler) cfg80211_wext_siwscan,		/* SIOCSIWSCAN */
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-07-25 10:44:27.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-07-25 10:44:27.000000000 +0200
@@ -1149,9 +1149,9 @@ int cfg80211_wext_giwpower(struct net_de
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwpower);
 
-int cfg80211_wds_wext_siwap(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct sockaddr *addr, char *extra)
+static int cfg80211_wds_wext_siwap(struct net_device *dev,
+				   struct iw_request_info *info,
+				   struct sockaddr *addr, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -1177,11 +1177,10 @@ int cfg80211_wds_wext_siwap(struct net_d
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wds_wext_siwap);
 
-int cfg80211_wds_wext_giwap(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct sockaddr *addr, char *extra)
+static int cfg80211_wds_wext_giwap(struct net_device *dev,
+				   struct iw_request_info *info,
+				   struct sockaddr *addr, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -1193,7 +1192,6 @@ int cfg80211_wds_wext_giwap(struct net_d
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wds_wext_giwap);
 
 int cfg80211_wext_siwrate(struct net_device *dev,
 			  struct iw_request_info *info,
@@ -1327,3 +1325,41 @@ struct iw_statistics *cfg80211_wireless_
 	return &wstats;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wireless_stats);
+
+int cfg80211_wext_siwap(struct net_device *dev,
+			struct iw_request_info *info,
+			struct sockaddr *ap_addr, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_ADHOC:
+		return cfg80211_ibss_wext_siwap(dev, info, ap_addr, extra);
+	case NL80211_IFTYPE_STATION:
+		return cfg80211_mgd_wext_siwap(dev, info, ap_addr, extra);
+	case NL80211_IFTYPE_WDS:
+		return cfg80211_wds_wext_siwap(dev, info, ap_addr, extra);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwap);
+
+int cfg80211_wext_giwap(struct net_device *dev,
+			struct iw_request_info *info,
+			struct sockaddr *ap_addr, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_ADHOC:
+		return cfg80211_ibss_wext_giwap(dev, info, ap_addr, extra);
+	case NL80211_IFTYPE_STATION:
+		return cfg80211_mgd_wext_giwap(dev, info, ap_addr, extra);
+	case NL80211_IFTYPE_WDS:
+		return cfg80211_wds_wext_giwap(dev, info, ap_addr, extra);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_giwap);
--- wireless-testing.orig/net/wireless/wext-compat.h	2009-07-25 10:44:27.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.h	2009-07-25 10:44:27.000000000 +0200
@@ -7,6 +7,12 @@ int cfg80211_ibss_wext_siwfreq(struct ne
 int cfg80211_ibss_wext_giwfreq(struct net_device *dev,
 			       struct iw_request_info *info,
 			       struct iw_freq *freq, char *extra);
+int cfg80211_ibss_wext_siwap(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct sockaddr *ap_addr, char *extra);
+int cfg80211_ibss_wext_giwap(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct sockaddr *ap_addr, char *extra);
 
 int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 			      struct iw_request_info *info,
@@ -14,6 +20,12 @@ int cfg80211_mgd_wext_siwfreq(struct net
 int cfg80211_mgd_wext_giwfreq(struct net_device *dev,
 			      struct iw_request_info *info,
 			      struct iw_freq *freq, char *extra);
+int cfg80211_mgd_wext_siwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *ap_addr, char *extra);
+int cfg80211_mgd_wext_giwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *ap_addr, char *extra);
 
 struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
 					     struct iw_freq *freq);
--- wireless-testing.orig/net/wireless/ibss.c	2009-07-25 10:44:27.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-07-25 10:44:27.000000000 +0200
@@ -466,8 +466,6 @@ int cfg80211_ibss_wext_siwap(struct net_
 
 	return err;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_siwap);
 
 int cfg80211_ibss_wext_giwap(struct net_device *dev,
 			     struct iw_request_info *info,
@@ -493,6 +491,4 @@ int cfg80211_ibss_wext_giwap(struct net_
 
 	return 0;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_giwap);
 #endif
--- wireless-testing.orig/net/wireless/wext-sme.c	2009-07-25 10:44:27.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-07-25 10:44:27.000000000 +0200
@@ -273,8 +273,6 @@ int cfg80211_mgd_wext_siwap(struct net_d
 	cfg80211_unlock_rdev(wiphy_to_dev(wdev->wiphy));
 	return err;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwap);
 
 int cfg80211_mgd_wext_giwap(struct net_device *dev,
 			    struct iw_request_info *info,
@@ -299,8 +297,6 @@ int cfg80211_mgd_wext_giwap(struct net_d
 
 	return 0;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_giwap);
 
 int cfg80211_wext_siwgenie(struct net_device *dev,
 			   struct iw_request_info *info,
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/wext.c	2009-07-25 10:44:27.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/wext.c	2009-07-25 10:44:27.000000000 +0200
@@ -27,36 +27,6 @@
 #include "iwm.h"
 #include "commands.h"
 
-static int iwm_wext_siwap(struct net_device *dev, struct iw_request_info *info,
-			  struct sockaddr *ap_addr, char *extra)
-{
-	struct iwm_priv *iwm = ndev_to_iwm(dev);
-
-	switch (iwm->conf.mode) {
-	case UMAC_MODE_IBSS:
-		return cfg80211_ibss_wext_siwap(dev, info, ap_addr, extra);
-	case UMAC_MODE_BSS:
-		return cfg80211_mgd_wext_siwap(dev, info, ap_addr, extra);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static int iwm_wext_giwap(struct net_device *dev, struct iw_request_info *info,
-			  struct sockaddr *ap_addr, char *extra)
-{
-	struct iwm_priv *iwm = ndev_to_iwm(dev);
-
-	switch (iwm->conf.mode) {
-	case UMAC_MODE_IBSS:
-		return cfg80211_ibss_wext_giwap(dev, info, ap_addr, extra);
-	case UMAC_MODE_BSS:
-		return cfg80211_mgd_wext_giwap(dev, info, ap_addr, extra);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int iwm_wext_siwessid(struct net_device *dev,
 			     struct iw_request_info *info,
 			     struct iw_point *data, char *ssid)
@@ -111,8 +81,8 @@ static const iw_handler iwm_handlers[] =
 	(iw_handler) NULL,				/* SIOCGIWSPY */
 	(iw_handler) NULL,				/* SIOCSIWTHRSPY */
 	(iw_handler) NULL,				/* SIOCGIWTHRSPY */
-	(iw_handler) iwm_wext_siwap,	                /* SIOCSIWAP */
-	(iw_handler) iwm_wext_giwap,			/* SIOCGIWAP */
+	(iw_handler) cfg80211_wext_siwap,		/* SIOCSIWAP */
+	(iw_handler) cfg80211_wext_giwap,		/* SIOCGIWAP */
 	(iw_handler) NULL,			        /* SIOCSIWMLME */
 	(iw_handler) NULL,				/* SIOCGIWAPLIST */
 	(iw_handler) cfg80211_wext_siwscan,		/* SIOCSIWSCAN */

-- 

