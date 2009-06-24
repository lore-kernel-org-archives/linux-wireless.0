Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35397 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbZFXMKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 08:10:05 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MJRIk-00033y-Cj
	for linux-wireless@vger.kernel.org; Wed, 24 Jun 2009 14:10:07 +0200
Message-Id: <20090624120810.154140393@sipsolutions.net>
References: <20090624120745.239294066@sipsolutions.net>
Date: Wed, 24 Jun 2009 14:07:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 10/11] cfg80211: combine IWESSID handlers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we now have handlers IWESSID for all modes, we can
combine them into one.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |   20 ++++++--------------
 net/mac80211/wext.c        |   35 ++---------------------------------
 net/wireless/ibss.c        |    4 ----
 net/wireless/wext-compat.c |   34 ++++++++++++++++++++++++++++++++++
 net/wireless/wext-compat.h |   12 ++++++++++++
 net/wireless/wext-sme.c    |    4 ----
 6 files changed, 54 insertions(+), 55 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-06-24 13:54:10.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-24 13:54:10.000000000 +0200
@@ -1524,19 +1524,6 @@ int cfg80211_wext_siwmlme(struct net_dev
 int cfg80211_wext_giwrange(struct net_device *dev,
 			   struct iw_request_info *info,
 			   struct iw_point *data, char *extra);
-int cfg80211_ibss_wext_siwessid(struct net_device *dev,
-				struct iw_request_info *info,
-				struct iw_point *data, char *ssid);
-int cfg80211_ibss_wext_giwessid(struct net_device *dev,
-				struct iw_request_info *info,
-				struct iw_point *data, char *ssid);
-
-int cfg80211_mgd_wext_siwessid(struct net_device *dev,
-			       struct iw_request_info *info,
-			       struct iw_point *data, char *ssid);
-int cfg80211_mgd_wext_giwessid(struct net_device *dev,
-			       struct iw_request_info *info,
-			       struct iw_point *data, char *ssid);
 int cfg80211_wext_siwgenie(struct net_device *dev,
 			   struct iw_request_info *info,
 			   struct iw_point *data, char *extra);
@@ -1553,7 +1540,12 @@ int cfg80211_wext_siwfreq(struct net_dev
 int cfg80211_wext_giwfreq(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_freq *freq, char *extra);
-
+int cfg80211_wext_siwessid(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *ssid);
+int cfg80211_wext_giwessid(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *ssid);
 int cfg80211_wext_siwrate(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_param *rate, char *extra);
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-06-24 13:54:10.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-06-24 13:54:10.000000000 +0200
@@ -1141,3 +1141,37 @@ int cfg80211_wext_giwap(struct net_devic
 	}
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwap);
+
+int cfg80211_wext_siwessid(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *ssid)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_ADHOC:
+		return cfg80211_ibss_wext_siwessid(dev, info, data, ssid);
+	case NL80211_IFTYPE_STATION:
+		return cfg80211_mgd_wext_siwessid(dev, info, data, ssid);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwessid);
+
+int cfg80211_wext_giwessid(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *ssid)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_ADHOC:
+		return cfg80211_ibss_wext_giwessid(dev, info, data, ssid);
+	case NL80211_IFTYPE_STATION:
+		return cfg80211_mgd_wext_giwessid(dev, info, data, ssid);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_giwessid);
--- wireless-testing.orig/net/wireless/wext-compat.h	2009-06-24 13:54:10.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.h	2009-06-24 13:54:10.000000000 +0200
@@ -13,6 +13,12 @@ int cfg80211_ibss_wext_siwap(struct net_
 int cfg80211_ibss_wext_giwap(struct net_device *dev,
 			     struct iw_request_info *info,
 			     struct sockaddr *ap_addr, char *extra);
+int cfg80211_ibss_wext_siwessid(struct net_device *dev,
+				struct iw_request_info *info,
+				struct iw_point *data, char *ssid);
+int cfg80211_ibss_wext_giwessid(struct net_device *dev,
+				struct iw_request_info *info,
+				struct iw_point *data, char *ssid);
 
 int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 			      struct iw_request_info *info,
@@ -26,6 +32,12 @@ int cfg80211_mgd_wext_siwap(struct net_d
 int cfg80211_mgd_wext_giwap(struct net_device *dev,
 			    struct iw_request_info *info,
 			    struct sockaddr *ap_addr, char *extra);
+int cfg80211_mgd_wext_siwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *ssid);
+int cfg80211_mgd_wext_giwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *ssid);
 
 struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
 					     struct iw_freq *freq);
--- wireless-testing.orig/net/mac80211/wext.c	2009-06-24 13:54:10.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-06-24 13:54:10.000000000 +0200
@@ -27,37 +27,6 @@
 #include "aes_ccm.h"
 
 
-static int ieee80211_ioctl_siwessid(struct net_device *dev,
-				    struct iw_request_info *info,
-				    struct iw_point *data, char *ssid)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		return cfg80211_ibss_wext_siwessid(dev, info, data, ssid);
-	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		return cfg80211_mgd_wext_siwessid(dev, info, data, ssid);
-
-	return -EOPNOTSUPP;
-}
-
-
-static int ieee80211_ioctl_giwessid(struct net_device *dev,
-				    struct iw_request_info *info,
-				    struct iw_point *data, char *ssid)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		return cfg80211_ibss_wext_giwessid(dev, info, data, ssid);
-	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		return cfg80211_mgd_wext_giwessid(dev, info, data, ssid);
-
-	return -EOPNOTSUPP;
-}
-
 
 /* Structures to export the Wireless Handlers */
 
@@ -89,8 +58,8 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* SIOCGIWAPLIST */
 	(iw_handler) cfg80211_wext_siwscan,		/* SIOCSIWSCAN */
 	(iw_handler) cfg80211_wext_giwscan,		/* SIOCGIWSCAN */
-	(iw_handler) ieee80211_ioctl_siwessid,		/* SIOCSIWESSID */
-	(iw_handler) ieee80211_ioctl_giwessid,		/* SIOCGIWESSID */
+	(iw_handler) cfg80211_wext_siwessid,		/* SIOCSIWESSID */
+	(iw_handler) cfg80211_wext_giwessid,		/* SIOCGIWESSID */
 	(iw_handler) NULL,				/* SIOCSIWNICKN */
 	(iw_handler) NULL,				/* SIOCGIWNICKN */
 	(iw_handler) NULL,				/* -- hole -- */
--- wireless-testing.orig/net/wireless/wext-sme.c	2009-06-24 13:54:10.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-06-24 13:54:10.000000000 +0200
@@ -145,8 +145,6 @@ int cfg80211_mgd_wext_siwessid(struct ne
 
 	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwessid);
 
 int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 			       struct iw_request_info *info,
@@ -173,8 +171,6 @@ int cfg80211_mgd_wext_giwessid(struct ne
 
 	return 0;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_giwessid);
 
 int cfg80211_mgd_wext_siwap(struct net_device *dev,
 			    struct iw_request_info *info,
--- wireless-testing.orig/net/wireless/ibss.c	2009-06-24 13:54:10.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-06-24 13:54:10.000000000 +0200
@@ -257,8 +257,6 @@ int cfg80211_ibss_wext_siwessid(struct n
 
 	return cfg80211_ibss_wext_join(wiphy_to_dev(wdev->wiphy), wdev);
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_siwessid);
 
 int cfg80211_ibss_wext_giwessid(struct net_device *dev,
 				struct iw_request_info *info,
@@ -284,8 +282,6 @@ int cfg80211_ibss_wext_giwessid(struct n
 
 	return 0;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_giwessid);
 
 int cfg80211_ibss_wext_siwap(struct net_device *dev,
 			     struct iw_request_info *info,

-- 

