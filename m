Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:47319 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993227AbXEBOvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 10:51:02 -0400
Date: Wed, 02 May 2007 09:50:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
Message-ID: <4638a51c.ohaY83u2vcHGHvr4%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At present, transmission rate information for mac80211 is available only
if verbose debugging is turned on, and then only in the logs. This patch
implements the SIOCGIWRATE ioctl, which adds the current transmission rate to
the output of iwconfig.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/net/mac80211/ieee80211_ioctl.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c
@@ -2013,6 +2013,23 @@ static int ieee80211_ioctl_giwscan(struc
 }
 
 
+static int ieee80211_ioctl_giwrate(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_param *rate, char *extra)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info * sta;
+	struct ieee80211_sub_if_data * sdata;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	sta = sta_info_get(local, sdata->u.sta.bssid);
+	if (!sta)
+		return -ENODEV;
+	rate->value = local->oper_hw_mode->rates[sta->txrate].rate * 100000;
+	sta_info_put(sta);
+	return 0;
+}
+
 static int ieee80211_ioctl_siwrts(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_param *rts, char *extra)
@@ -3137,7 +3154,7 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* SIOCSIWRATE */
-	(iw_handler) NULL,				/* SIOCGIWRATE */
+	(iw_handler) ieee80211_ioctl_giwrate,		/* SIOCGIWRATE */
 	(iw_handler) ieee80211_ioctl_siwrts,		/* SIOCSIWRTS */
 	(iw_handler) ieee80211_ioctl_giwrts,		/* SIOCGIWRTS */
 	(iw_handler) ieee80211_ioctl_siwfrag,		/* SIOCSIWFRAG */
