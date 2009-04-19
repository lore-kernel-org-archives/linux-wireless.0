Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZDSR5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 13:57:53 -0400
Subject: [PATCH] cfg80211/mac80211: move wext SIWMLME into cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 19:57:45 +0200
Message-Id: <1240163865.28138.8.camel@johannes.local> (sfid-20090419_195756_910883_50FC6400)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we have ->deauth and ->disassoc we can support the
wext SIWMLME call directly without driver wext handlers.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |    3 ++
 net/mac80211/cfg.c         |   12 +++--------
 net/mac80211/mlme.c        |    6 -----
 net/mac80211/wext.c        |   25 ------------------------
 net/wireless/wext-compat.c |   46 ++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 53 insertions(+), 39 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-04-19 19:47:00.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-04-19 19:47:11.000000000 +0200
@@ -612,29 +612,6 @@ static int ieee80211_ioctl_giwretry(stru
 	return 0;
 }
 
-static int ieee80211_ioctl_siwmlme(struct net_device *dev,
-				   struct iw_request_info *info,
-				   struct iw_point *data, char *extra)
-{
-	struct ieee80211_sub_if_data *sdata;
-	struct iw_mlme *mlme = (struct iw_mlme *) extra;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (!(sdata->vif.type == NL80211_IFTYPE_STATION))
-		return -EINVAL;
-
-	switch (mlme->cmd) {
-	case IW_MLME_DEAUTH:
-		/* TODO: mlme->addr.sa_data */
-		return ieee80211_sta_deauthenticate(sdata, mlme->reason_code);
-	case IW_MLME_DISASSOC:
-		/* TODO: mlme->addr.sa_data */
-		return ieee80211_sta_disassociate(sdata, mlme->reason_code);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 
 static int ieee80211_ioctl_siwencode(struct net_device *dev,
 				     struct iw_request_info *info,
@@ -1076,7 +1053,7 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* SIOCGIWTHRSPY */
 	(iw_handler) ieee80211_ioctl_siwap,		/* SIOCSIWAP */
 	(iw_handler) ieee80211_ioctl_giwap,		/* SIOCGIWAP */
-	(iw_handler) ieee80211_ioctl_siwmlme,		/* SIOCSIWMLME */
+	(iw_handler) cfg80211_wext_siwmlme,		/* SIOCSIWMLME */
 	(iw_handler) NULL,				/* SIOCGIWAPLIST */
 	(iw_handler) cfg80211_wext_siwscan,		/* SIOCSIWSCAN */
 	(iw_handler) cfg80211_wext_giwscan,		/* SIOCGIWSCAN */
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-04-19 19:47:06.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-04-19 19:47:58.000000000 +0200
@@ -10,6 +10,7 @@
 
 #include <linux/wireless.h>
 #include <linux/nl80211.h>
+#include <linux/if_arp.h>
 #include <net/iw_handler.h>
 #include <net/wireless.h>
 #include <net/cfg80211.h>
@@ -206,7 +207,6 @@ int cfg80211_wext_giwrange(struct net_de
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
-
 	for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
 		int i;
 		struct ieee80211_supported_band *sband;
@@ -241,3 +241,47 @@ int cfg80211_wext_giwrange(struct net_de
 	return 0;
 }
 EXPORT_SYMBOL(cfg80211_wext_giwrange);
+
+int cfg80211_wext_siwmlme(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_point *data, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct iw_mlme *mlme = (struct iw_mlme *)extra;
+	struct cfg80211_registered_device *rdev;
+	union {
+		struct cfg80211_disassoc_request disassoc;
+		struct cfg80211_deauth_request deauth;
+	} cmd;
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
+	memset(&cmd, 0, sizeof(cmd));
+
+	switch (mlme->cmd) {
+	case IW_MLME_DEAUTH:
+		if (!rdev->ops->deauth)
+			return -EOPNOTSUPP;
+		cmd.deauth.peer_addr = mlme->addr.sa_data;
+		cmd.deauth.reason_code = mlme->reason_code;
+		return rdev->ops->deauth(wdev->wiphy, dev, &cmd.deauth);
+	case IW_MLME_DISASSOC:
+		if (!rdev->ops->disassoc)
+			return -EOPNOTSUPP;
+		cmd.disassoc.peer_addr = mlme->addr.sa_data;
+		cmd.disassoc.reason_code = mlme->reason_code;
+		return rdev->ops->disassoc(wdev->wiphy, dev, &cmd.disassoc);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL(cfg80211_wext_siwmlme);
--- wireless-testing.orig/include/net/cfg80211.h	2009-04-19 19:47:07.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-04-19 19:47:11.000000000 +0200
@@ -833,6 +833,9 @@ int cfg80211_wext_siwscan(struct net_dev
 int cfg80211_wext_giwscan(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_point *data, char *extra);
+int cfg80211_wext_siwmlme(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_point *data, char *extra);
 int cfg80211_wext_giwrange(struct net_device *dev,
 			   struct iw_request_info *info,
 			   struct iw_point *data, char *extra);
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-19 19:47:00.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-19 19:47:11.000000000 +0200
@@ -2307,9 +2307,6 @@ int ieee80211_sta_deauthenticate(struct 
 	printk(KERN_DEBUG "%s: deauthenticating by local choice (reason=%d)\n",
 	       sdata->dev->name, reason);
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return -EINVAL;
-
 	ieee80211_set_disassoc(sdata, true, true, reason);
 	return 0;
 }
@@ -2321,9 +2318,6 @@ int ieee80211_sta_disassociate(struct ie
 	printk(KERN_DEBUG "%s: disassociating by local choice (reason=%d)\n",
 	       sdata->dev->name, reason);
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return -EINVAL;
-
 	if (!(ifmgd->flags & IEEE80211_STA_ASSOCIATED))
 		return -ENOLINK;
 
--- wireless-testing.orig/net/mac80211/cfg.c	2009-04-19 19:47:00.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-04-19 19:47:11.000000000 +0200
@@ -1267,22 +1267,18 @@ static int ieee80211_assoc(struct wiphy 
 static int ieee80211_deauth(struct wiphy *wiphy, struct net_device *dev,
 			    struct cfg80211_deauth_request *req)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	/* TODO: req->ie */
+	/* TODO: req->ie, req->peer_addr */
 	return ieee80211_sta_deauthenticate(sdata, req->reason_code);
 }
 
 static int ieee80211_disassoc(struct wiphy *wiphy, struct net_device *dev,
 			      struct cfg80211_disassoc_request *req)
 {
-	struct ieee80211_sub_if_data *sdata;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	/* TODO: req->ie */
+	/* TODO: req->ie, req->peer_addr */
 	return ieee80211_sta_disassociate(sdata, req->reason_code);
 }
 


