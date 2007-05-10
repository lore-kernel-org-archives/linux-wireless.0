Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:51242 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbXEJSzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 14:55:12 -0400
Date: Thu, 10 May 2007 13:54:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V5] mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
Message-ID: <46436a83.ryrsLlZyRAF/iwC6%Larry.Finger@lwfinger.net>
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
@@ -2013,6 +2013,30 @@ static int ieee80211_ioctl_giwscan(struc
 }
 
 
+static int ieee80211_ioctl_giwrate(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_param *rate, char *extra)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
+	struct ieee80211_sub_if_data *sdata;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->type == IEEE80211_IF_TYPE_STA ||
+	    sdata->type == IEEE80211_IF_TYPE_IBSS)
+		sta = sta_info_get(local, sdata->u.sta.bssid);
+	else
+		return -EOPNOTSUPP;
+	if (!sta)
+		return -ENODEV;
+	if (sta->txrate < local->oper_hw_mode->num_rates)
+		rate->value = local->oper_hw_mode->rates[sta->txrate].rate * 100000;
+	else
+		rate->value = 0;
+	sta_info_put(sta);
+	return 0;
+}
+
 static int ieee80211_ioctl_siwrts(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_param *rts, char *extra)
@@ -3137,7 +3161,7 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* SIOCSIWRATE */
-	(iw_handler) NULL,				/* SIOCGIWRATE */
+	(iw_handler) ieee80211_ioctl_giwrate,		/* SIOCGIWRATE */
 	(iw_handler) ieee80211_ioctl_siwrts,		/* SIOCSIWRTS */
 	(iw_handler) ieee80211_ioctl_giwrts,		/* SIOCGIWRTS */
 	(iw_handler) ieee80211_ioctl_siwfrag,		/* SIOCSIWFRAG */
