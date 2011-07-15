Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964787Ab1GOLBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 07:01:43 -0400
Subject: [PATCH] cfg80211: remove unused wext handler exports
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 13:01:38 +0200
Message-ID: <1310727698.4164.23.camel@jlt3.sipsolutions.net> (sfid-20110715_130147_009705_1479008E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A lot of code is dedicated to giving drivers the
ability to use cfg80211's wext handlers without
completely converting. However, only orinoco is
currently using this, and it is only partially
using it.

We reduce the size of both the source and binary
by removing those that nobody needs. If a driver
shows up that needs it during conversion, we can
add back those that are needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211-wext.h |   69 ----------------------
 net/wireless/wext-compat.c  |  136 ++++++++++++++++++--------------------------
 net/wireless/wext-compat.h  |    8 ++
 net/wireless/wext-sme.c     |    2 
 4 files changed, 66 insertions(+), 149 deletions(-)

--- a/include/net/cfg80211-wext.h	2011-07-15 12:41:56.000000000 +0200
+++ b/include/net/cfg80211-wext.h	2011-07-15 12:45:09.000000000 +0200
@@ -33,41 +33,9 @@ int cfg80211_wext_siwscan(struct net_dev
 int cfg80211_wext_giwscan(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_point *data, char *extra);
-int cfg80211_wext_siwmlme(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_point *data, char *extra);
 int cfg80211_wext_giwrange(struct net_device *dev,
 			   struct iw_request_info *info,
 			   struct iw_point *data, char *extra);
-int cfg80211_wext_siwgenie(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *extra);
-int cfg80211_wext_siwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *data, char *extra);
-int cfg80211_wext_giwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *data, char *extra);
-
-int cfg80211_wext_siwfreq(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_freq *freq, char *extra);
-int cfg80211_wext_giwfreq(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_freq *freq, char *extra);
-int cfg80211_wext_siwessid(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *ssid);
-int cfg80211_wext_giwessid(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *ssid);
-int cfg80211_wext_siwrate(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *rate, char *extra);
-int cfg80211_wext_giwrate(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *rate, char *extra);
-
 int cfg80211_wext_siwrts(struct net_device *dev,
 			 struct iw_request_info *info,
 			 struct iw_param *rts, char *extra);
@@ -80,45 +48,8 @@ int cfg80211_wext_siwfrag(struct net_dev
 int cfg80211_wext_giwfrag(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_param *frag, char *extra);
-int cfg80211_wext_siwretry(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *retry, char *extra);
 int cfg80211_wext_giwretry(struct net_device *dev,
 			   struct iw_request_info *info,
 			   struct iw_param *retry, char *extra);
-int cfg80211_wext_siwencodeext(struct net_device *dev,
-			       struct iw_request_info *info,
-			       struct iw_point *erq, char *extra);
-int cfg80211_wext_siwencode(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct iw_point *erq, char *keybuf);
-int cfg80211_wext_giwencode(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct iw_point *erq, char *keybuf);
-int cfg80211_wext_siwtxpower(struct net_device *dev,
-			     struct iw_request_info *info,
-			     union iwreq_data *data, char *keybuf);
-int cfg80211_wext_giwtxpower(struct net_device *dev,
-			     struct iw_request_info *info,
-			     union iwreq_data *data, char *keybuf);
-struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev);
-
-int cfg80211_wext_siwpower(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *wrq, char *extra);
-int cfg80211_wext_giwpower(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *wrq, char *extra);
-
-int cfg80211_wext_siwap(struct net_device *dev,
-			struct iw_request_info *info,
-			struct sockaddr *ap_addr, char *extra);
-int cfg80211_wext_giwap(struct net_device *dev,
-			struct iw_request_info *info,
-			struct sockaddr *ap_addr, char *extra);
-
-int cfg80211_wext_siwpmksa(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *extra);
 
 #endif /* __NET_CFG80211_WEXT_H */
--- a/net/wireless/wext-compat.c	2011-07-15 12:42:06.000000000 +0200
+++ b/net/wireless/wext-compat.c	2011-07-15 12:50:57.000000000 +0200
@@ -364,9 +364,9 @@ int cfg80211_wext_giwfrag(struct net_dev
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwfrag);
 
-int cfg80211_wext_siwretry(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *retry, char *extra)
+static int cfg80211_wext_siwretry(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_param *retry, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -403,7 +403,6 @@ int cfg80211_wext_siwretry(struct net_de
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwretry);
 
 int cfg80211_wext_giwretry(struct net_device *dev,
 			   struct iw_request_info *info,
@@ -594,9 +593,9 @@ static int cfg80211_set_encryption(struc
 	return err;
 }
 
-int cfg80211_wext_siwencode(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct iw_point *erq, char *keybuf)
+static int cfg80211_wext_siwencode(struct net_device *dev,
+				   struct iw_request_info *info,
+				   struct iw_point *erq, char *keybuf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -653,11 +652,10 @@ int cfg80211_wext_siwencode(struct net_d
 				       wdev->wext.default_key == -1,
 				       idx, &params);
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwencode);
 
-int cfg80211_wext_siwencodeext(struct net_device *dev,
-			       struct iw_request_info *info,
-			       struct iw_point *erq, char *extra)
+static int cfg80211_wext_siwencodeext(struct net_device *dev,
+				      struct iw_request_info *info,
+				      struct iw_point *erq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -745,11 +743,10 @@ int cfg80211_wext_siwencodeext(struct ne
 			ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY,
 			idx, &params);
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwencodeext);
 
-int cfg80211_wext_giwencode(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct iw_point *erq, char *keybuf)
+static int cfg80211_wext_giwencode(struct net_device *dev,
+				   struct iw_request_info *info,
+				   struct iw_point *erq, char *keybuf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int idx;
@@ -783,11 +780,10 @@ int cfg80211_wext_giwencode(struct net_d
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwencode);
 
-int cfg80211_wext_siwfreq(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_freq *wextfreq, char *extra)
+static int cfg80211_wext_siwfreq(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_freq *wextfreq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -816,11 +812,10 @@ int cfg80211_wext_siwfreq(struct net_dev
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwfreq);
 
-int cfg80211_wext_giwfreq(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_freq *freq, char *extra)
+static int cfg80211_wext_giwfreq(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_freq *freq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -837,11 +832,10 @@ int cfg80211_wext_giwfreq(struct net_dev
 		return 0;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwfreq);
 
-int cfg80211_wext_siwtxpower(struct net_device *dev,
-			     struct iw_request_info *info,
-			     union iwreq_data *data, char *extra)
+static int cfg80211_wext_siwtxpower(struct net_device *dev,
+				    struct iw_request_info *info,
+				    union iwreq_data *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -890,11 +884,10 @@ int cfg80211_wext_siwtxpower(struct net_
 
 	return rdev->ops->set_tx_power(wdev->wiphy, type, DBM_TO_MBM(dbm));
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwtxpower);
 
-int cfg80211_wext_giwtxpower(struct net_device *dev,
-			     struct iw_request_info *info,
-			     union iwreq_data *data, char *extra)
+static int cfg80211_wext_giwtxpower(struct net_device *dev,
+				    struct iw_request_info *info,
+				    union iwreq_data *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -920,7 +913,6 @@ int cfg80211_wext_giwtxpower(struct net_
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwtxpower);
 
 static int cfg80211_set_auth_alg(struct wireless_dev *wdev,
 				 s32 auth_alg)
@@ -1071,9 +1063,9 @@ static int cfg80211_set_key_mgt(struct w
 	return 0;
 }
 
-int cfg80211_wext_siwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *data, char *extra)
+static int cfg80211_wext_siwauth(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -1103,21 +1095,19 @@ int cfg80211_wext_siwauth(struct net_dev
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwauth);
 
-int cfg80211_wext_giwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *data, char *extra)
+static int cfg80211_wext_giwauth(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *data, char *extra)
 {
 	/* XXX: what do we need? */
 
 	return -EOPNOTSUPP;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwauth);
 
-int cfg80211_wext_siwpower(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *wrq, char *extra)
+static int cfg80211_wext_siwpower(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_param *wrq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -1161,11 +1151,10 @@ int cfg80211_wext_siwpower(struct net_de
 	return 0;
 
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwpower);
 
-int cfg80211_wext_giwpower(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *wrq, char *extra)
+static int cfg80211_wext_giwpower(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_param *wrq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -1173,7 +1162,6 @@ int cfg80211_wext_giwpower(struct net_de
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwpower);
 
 static int cfg80211_wds_wext_siwap(struct net_device *dev,
 				   struct iw_request_info *info,
@@ -1219,9 +1207,9 @@ static int cfg80211_wds_wext_giwap(struc
 	return 0;
 }
 
-int cfg80211_wext_siwrate(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *rate, char *extra)
+static int cfg80211_wext_siwrate(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *rate, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -1269,11 +1257,10 @@ int cfg80211_wext_siwrate(struct net_dev
 
 	return rdev->ops->set_bitrate_mask(wdev->wiphy, dev, NULL, &mask);
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwrate);
 
-int cfg80211_wext_giwrate(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *rate, char *extra)
+static int cfg80211_wext_giwrate(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *rate, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -1309,10 +1296,9 @@ int cfg80211_wext_giwrate(struct net_dev
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwrate);
 
 /* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
-struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
+static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -1377,11 +1363,10 @@ struct iw_statistics *cfg80211_wireless_
 
 	return &wstats;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wireless_stats);
 
-int cfg80211_wext_siwap(struct net_device *dev,
-			struct iw_request_info *info,
-			struct sockaddr *ap_addr, char *extra)
+static int cfg80211_wext_siwap(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct sockaddr *ap_addr, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -1396,11 +1381,10 @@ int cfg80211_wext_siwap(struct net_devic
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwap);
 
-int cfg80211_wext_giwap(struct net_device *dev,
-			struct iw_request_info *info,
-			struct sockaddr *ap_addr, char *extra)
+static int cfg80211_wext_giwap(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct sockaddr *ap_addr, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -1415,11 +1399,10 @@ int cfg80211_wext_giwap(struct net_devic
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwap);
 
-int cfg80211_wext_siwessid(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *ssid)
+static int cfg80211_wext_siwessid(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_point *data, char *ssid)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -1432,11 +1415,10 @@ int cfg80211_wext_siwessid(struct net_de
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwessid);
 
-int cfg80211_wext_giwessid(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *ssid)
+static int cfg80211_wext_giwessid(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_point *data, char *ssid)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -1452,11 +1434,10 @@ int cfg80211_wext_giwessid(struct net_de
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwessid);
 
-int cfg80211_wext_siwpmksa(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *extra)
+static int cfg80211_wext_siwpmksa(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_point *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -1494,7 +1475,6 @@ int cfg80211_wext_siwpmksa(struct net_de
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwpmksa);
 
 static const iw_handler cfg80211_handlers[] = {
 	[IW_IOCTL_IDX(SIOCGIWNAME)]	= (iw_handler) cfg80211_wext_giwname,
--- a/net/wireless/wext-compat.h	2011-07-15 12:45:41.000000000 +0200
+++ b/net/wireless/wext-compat.h	2011-07-15 12:55:11.000000000 +0200
@@ -42,6 +42,14 @@ int cfg80211_mgd_wext_giwessid(struct ne
 			       struct iw_request_info *info,
 			       struct iw_point *data, char *ssid);
 
+int cfg80211_wext_siwmlme(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_point *data, char *extra);
+int cfg80211_wext_siwgenie(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *extra);
+
+
 int cfg80211_wext_freq(struct wiphy *wiphy, struct iw_freq *freq);
 
 
--- a/net/wireless/wext-sme.c	2011-07-15 12:45:34.000000000 +0200
+++ b/net/wireless/wext-sme.c	2011-07-15 12:46:59.000000000 +0200
@@ -366,7 +366,6 @@ int cfg80211_wext_siwgenie(struct net_de
 	wdev_unlock(wdev);
 	return err;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwgenie);
 
 int cfg80211_wext_siwmlme(struct net_device *dev,
 			  struct iw_request_info *info,
@@ -403,4 +402,3 @@ int cfg80211_wext_siwmlme(struct net_dev
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwmlme);


