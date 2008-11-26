Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbYKZWcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 17:32:15 -0500
Subject: [PATCH v4] cfg80211: handle SIOCGIWMODE/SIOCSIWMODE
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1227736054.14269.4.camel@johannes.berg> (sfid-20081126_224813_585370_776CC57B)
References: <1227735421.14269.2.camel@johannes.berg>
	 (sfid-20081126_223837_375323_61A2AED2)  <1227736054.14269.4.camel@johannes.berg>
	 (sfid-20081126_224813_585370_776CC57B)
Content-Type: text/plain
Date: Wed, 26 Nov 2008 23:31:40 +0100
Message-Id: <1227738701.14269.12.camel@johannes.berg> (sfid-20081126_233228_519046_7FE409AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject: cfg80211: handle SIOCGIWMODE/SIOCSIWMODE

further reducing wext code in mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v4: d'oh

 include/net/cfg80211.h     |    4 ++
 net/mac80211/iface.c       |    4 ++
 net/mac80211/wext.c        |   76 +------------------------------------------
 net/wireless/wext-compat.c |   79 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 74 deletions(-)

--- everything.orig/include/net/cfg80211.h	2008-11-26 22:41:09.000000000 +0100
+++ everything/include/net/cfg80211.h	2008-11-26 23:30:43.000000000 +0100
@@ -521,5 +521,9 @@ struct cfg80211_ops {
 int cfg80211_wext_giwname(struct net_device *dev,
 			  struct iw_request_info *info,
 			  char *name, char *extra);
+int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
+			  u32 *mode, char *extra);
+int cfg80211_wext_giwmode(struct net_device *dev, struct iw_request_info *info,
+			  u32 *mode, char *extra);
 
 #endif /* __NET_CFG80211_H */
--- everything.orig/net/mac80211/wext.c	2008-11-26 22:41:09.000000000 +0100
+++ everything/net/mac80211/wext.c	2008-11-26 23:30:44.000000000 +0100
@@ -224,78 +224,6 @@ static int ieee80211_ioctl_giwrange(stru
 }
 
 
-static int ieee80211_ioctl_siwmode(struct net_device *dev,
-				   struct iw_request_info *info,
-				   __u32 *mode, char *extra)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
-	int type;
-
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		return -EOPNOTSUPP;
-
-	switch (*mode) {
-	case IW_MODE_INFRA:
-		type = NL80211_IFTYPE_STATION;
-		break;
-	case IW_MODE_ADHOC:
-		/* Setting ad-hoc mode on non ibss channel is not
-		 * supported.
-		 */
-		if (local->oper_channel &&
-		    (local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS))
-			return -EOPNOTSUPP;
-
-		type = NL80211_IFTYPE_ADHOC;
-		break;
-	case IW_MODE_REPEAT:
-		type = NL80211_IFTYPE_WDS;
-		break;
-	case IW_MODE_MONITOR:
-		type = NL80211_IFTYPE_MONITOR;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return ieee80211_if_change_type(sdata, type);
-}
-
-
-static int ieee80211_ioctl_giwmode(struct net_device *dev,
-				   struct iw_request_info *info,
-				   __u32 *mode, char *extra)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_AP:
-		*mode = IW_MODE_MASTER;
-		break;
-	case NL80211_IFTYPE_STATION:
-		*mode = IW_MODE_INFRA;
-		break;
-	case NL80211_IFTYPE_ADHOC:
-		*mode = IW_MODE_ADHOC;
-		break;
-	case NL80211_IFTYPE_MONITOR:
-		*mode = IW_MODE_MONITOR;
-		break;
-	case NL80211_IFTYPE_WDS:
-		*mode = IW_MODE_REPEAT;
-		break;
-	case NL80211_IFTYPE_AP_VLAN:
-		*mode = IW_MODE_SECOND;		/* FIXME */
-		break;
-	default:
-		*mode = IW_MODE_AUTO;
-		break;
-	}
-	return 0;
-}
-
 static int ieee80211_ioctl_siwfreq(struct net_device *dev,
 				   struct iw_request_info *info,
 				   struct iw_freq *freq, char *extra)
@@ -1109,8 +1037,8 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* SIOCGIWNWID */
 	(iw_handler) ieee80211_ioctl_siwfreq,		/* SIOCSIWFREQ */
 	(iw_handler) ieee80211_ioctl_giwfreq,		/* SIOCGIWFREQ */
-	(iw_handler) ieee80211_ioctl_siwmode,		/* SIOCSIWMODE */
-	(iw_handler) ieee80211_ioctl_giwmode,		/* SIOCGIWMODE */
+	(iw_handler) cfg80211_wext_siwmode,		/* SIOCSIWMODE */
+	(iw_handler) cfg80211_wext_giwmode,		/* SIOCGIWMODE */
 	(iw_handler) NULL,				/* SIOCSIWSENS */
 	(iw_handler) NULL,				/* SIOCGIWSENS */
 	(iw_handler) NULL /* not used */,		/* SIOCSIWRANGE */
--- everything.orig/net/wireless/wext-compat.c	2008-11-26 22:41:09.000000000 +0100
+++ everything/net/wireless/wext-compat.c	2008-11-26 22:43:29.000000000 +0100
@@ -58,3 +58,82 @@ int cfg80211_wext_giwname(struct net_dev
 	return 0;
 }
 EXPORT_SYMBOL(cfg80211_wext_giwname);
+
+int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
+			  u32 *mode, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev;
+	struct vif_params vifparams;
+	enum nl80211_iftype type;
+
+	if (!wdev)
+		return -EOPNOTSUPP;
+
+	rdev = wiphy_to_dev(wdev->wiphy);
+
+	if (!rdev->ops->change_virtual_intf)
+		return -EOPNOTSUPP;
+
+	/* don't support changing VLANs, you just re-create them */
+	if (wdev->iftype == NL80211_IFTYPE_AP_VLAN)
+		return -EOPNOTSUPP;
+
+	switch (*mode) {
+	case IW_MODE_INFRA:
+		type = NL80211_IFTYPE_STATION;
+		break;
+	case IW_MODE_ADHOC:
+		type = NL80211_IFTYPE_ADHOC;
+		break;
+	case IW_MODE_REPEAT:
+		type = NL80211_IFTYPE_WDS;
+		break;
+	case IW_MODE_MONITOR:
+		type = NL80211_IFTYPE_MONITOR;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	memset(&vifparams, 0, sizeof(vifparams));
+
+	return rdev->ops->change_virtual_intf(wdev->wiphy, dev->ifindex, type,
+					      NULL, &vifparams);
+}
+EXPORT_SYMBOL(cfg80211_wext_siwmode);
+
+int cfg80211_wext_giwmode(struct net_device *dev, struct iw_request_info *info,
+			  u32 *mode, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (!wdev)
+		return -EOPNOTSUPP;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_AP:
+		*mode = IW_MODE_MASTER;
+		break;
+	case NL80211_IFTYPE_STATION:
+		*mode = IW_MODE_INFRA;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		*mode = IW_MODE_ADHOC;
+		break;
+	case NL80211_IFTYPE_MONITOR:
+		*mode = IW_MODE_MONITOR;
+		break;
+	case NL80211_IFTYPE_WDS:
+		*mode = IW_MODE_REPEAT;
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		*mode = IW_MODE_SECOND;		/* FIXME */
+		break;
+	default:
+		*mode = IW_MODE_AUTO;
+		break;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_wext_giwmode);
--- everything.orig/net/mac80211/iface.c	2008-11-26 22:44:38.000000000 +0100
+++ everything/net/mac80211/iface.c	2008-11-26 23:30:53.000000000 +0100
@@ -694,6 +694,10 @@ int ieee80211_if_change_type(struct ieee
 	if (type == sdata->vif.type)
 		return 0;
 
+	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
+	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)
+		return -EOPNOTSUPP;
+
 	/*
 	 * We could, here, on changes between IBSS/STA/MESH modes,
 	 * invoke an MLME function instead that disassociates etc.


