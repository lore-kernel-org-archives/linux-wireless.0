Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbZFXMKC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 08:10:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MJRIh-00032K-HW
	for linux-wireless@vger.kernel.org; Wed, 24 Jun 2009 14:10:04 +0200
Message-Id: <20090624120809.995595314@sipsolutions.net>
References: <20090624120745.239294066@sipsolutions.net>
Date: Wed, 24 Jun 2009 14:07:54 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 09/11] cfg80211: combine IWAP handlers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we now have IWAP handlers for all modes, we can
combine them into one.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |   24 +++++----------------
 net/mac80211/wext.c        |   41 +-----------------------------------
 net/wireless/ibss.c        |    4 ---
 net/wireless/wext-compat.c |   51 ++++++++++++++++++++++++++++++++++++++-------
 net/wireless/wext-compat.h |   12 ++++++++++
 net/wireless/wext-sme.c    |    4 ---
 6 files changed, 64 insertions(+), 72 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-06-24 13:54:09.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-24 13:54:10.000000000 +0200
@@ -1530,12 +1530,6 @@ int cfg80211_ibss_wext_siwessid(struct n
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
@@ -1543,12 +1537,6 @@ int cfg80211_mgd_wext_siwessid(struct ne
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
@@ -1615,12 +1603,12 @@ int cfg80211_wext_giwpower(struct net_de
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
--- wireless-testing.orig/net/mac80211/wext.c	2009-06-24 13:54:09.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-06-24 13:54:10.000000000 +0200
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
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-06-24 13:54:09.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-06-24 13:54:10.000000000 +0200
@@ -961,9 +961,9 @@ int cfg80211_wext_giwpower(struct net_de
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
@@ -989,11 +989,10 @@ int cfg80211_wds_wext_siwap(struct net_d
 
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
 
@@ -1104,3 +1103,41 @@ struct iw_statistics *cfg80211_wireless_
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
--- wireless-testing.orig/net/wireless/wext-compat.h	2009-06-24 13:54:09.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.h	2009-06-24 13:54:10.000000000 +0200
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
--- wireless-testing.orig/net/wireless/ibss.c	2009-06-24 13:54:09.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-06-24 13:54:10.000000000 +0200
@@ -333,8 +333,6 @@ int cfg80211_ibss_wext_siwap(struct net_
 
 	return cfg80211_ibss_wext_join(wiphy_to_dev(wdev->wiphy), wdev);
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_siwap);
 
 int cfg80211_ibss_wext_giwap(struct net_device *dev,
 			     struct iw_request_info *info,
@@ -354,6 +352,4 @@ int cfg80211_ibss_wext_giwap(struct net_
 		memcpy(ap_addr->sa_data, wdev->wext.ibss.bssid, ETH_ALEN);
 	return 0;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_giwap);
 #endif
--- wireless-testing.orig/net/wireless/wext-sme.c	2009-06-24 13:54:09.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-06-24 13:54:10.000000000 +0200
@@ -220,8 +220,6 @@ int cfg80211_mgd_wext_siwap(struct net_d
 
 	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwap);
 
 int cfg80211_mgd_wext_giwap(struct net_device *dev,
 			    struct iw_request_info *info,
@@ -242,8 +240,6 @@ int cfg80211_mgd_wext_giwap(struct net_d
 
 	return 0;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_giwap);
 
 int cfg80211_wext_siwgenie(struct net_device *dev,
 			   struct iw_request_info *info,

-- 

