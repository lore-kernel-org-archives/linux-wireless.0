Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lvs00-fl-n19.ftl.affinity.com ([216.219.253.57]:57925 "EHLO
	lvs00-fl-n19.ftl.affinity.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755120AbXEWDVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 23:21:20 -0400
Received: from [72.129.173.253] ([72.129.173.253]:28897 "HELO larrylap.site")
	by ams019.ftl.affinity.com with SMTP id S958375AbXEWDOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 23:14:20 -0400
Date: Tue, 22 May 2007 22:14:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V6] mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
Message-ID: <4653b189.dPwlgw4JKvpc7kFq%Larry.Finger@lwfinger.net>
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
@@ -2013,6 +2013,29 @@ static int ieee80211_ioctl_giwscan(struc
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
+	if (sdata->type == IEEE80211_IF_TYPE_STA)
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
@@ -3137,7 +3160,7 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* SIOCSIWRATE */
-	(iw_handler) NULL,				/* SIOCGIWRATE */
+	(iw_handler) ieee80211_ioctl_giwrate,		/* SIOCGIWRATE */
 	(iw_handler) ieee80211_ioctl_siwrts,		/* SIOCSIWRTS */
 	(iw_handler) ieee80211_ioctl_giwrts,		/* SIOCGIWRTS */
 	(iw_handler) ieee80211_ioctl_siwfrag,		/* SIOCSIWFRAG */
