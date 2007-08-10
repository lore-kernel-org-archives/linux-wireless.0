Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:57859 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762135AbXHJQYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 12:24:22 -0400
Date: Fri, 10 Aug 2007 11:23:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V2] mac80211: Add SIOCGIWTXPOWER routine
Message-ID: <46bc90f8.XZeVSt6DkZIYh9fX%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wireless extensions ioctl's implemented in mac80211 do not include
SIOCGIWTXPOWER. This patch adds the necessary code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This version incorporates the change suggested by Tomas Winkler.

Larry

 ieee80211_ioctl.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

Index: wireless-dev/net/mac80211/ieee80211_ioctl.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c
@@ -1932,6 +1932,20 @@ static int ieee80211_ioctl_giwrate(struc
 	return 0;
 }
 
+static int ieee80211_ioctl_giwtxpower(struct net_device *dev,
+				   struct iw_request_info *info,
+				   union iwreq_data *data, char *extra)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+
+	data->txpower.fixed = 1;
+	data->txpower.disabled = !(local->hw.conf.radio_enabled);
+	data->txpower.value = local->hw.conf.power_level;
+	data->txpower.flags = IW_TXPOW_DBM;
+
+	return 0;
+}
+
 static int ieee80211_ioctl_siwrts(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_param *rts, char *extra)
@@ -2888,7 +2902,7 @@ static const iw_handler ieee80211_handle
 	(iw_handler) ieee80211_ioctl_siwfrag,		/* SIOCSIWFRAG */
 	(iw_handler) ieee80211_ioctl_giwfrag,		/* SIOCGIWFRAG */
 	(iw_handler) NULL,				/* SIOCSIWTXPOW */
-	(iw_handler) NULL,				/* SIOCGIWTXPOW */
+	(iw_handler) ieee80211_ioctl_giwtxpower,	/* SIOCGIWTXPOW */
 	(iw_handler) ieee80211_ioctl_siwretry,		/* SIOCSIWRETRY */
 	(iw_handler) ieee80211_ioctl_giwretry,		/* SIOCGIWRETRY */
 	(iw_handler) ieee80211_ioctl_siwencode,		/* SIOCSIWENCODE */
