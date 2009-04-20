Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbZDTNRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 09:17:38 -0400
Subject: [PATCH] rndis_wlan: remove nickname support
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 15:17:01 +0200
Message-Id: <1240233421.9391.2.camel@johannes.local> (sfid-20090420_151741_513458_05ADABA9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Supporting wireless extension nickname is pointless
and no other modern driver supports this, so remove
it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/rndis_wlan.c |   38 --------------------------------------
 1 file changed, 38 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/rndis_wlan.c	2009-04-20 15:11:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rndis_wlan.c	2009-04-20 15:11:45.000000000 +0200
@@ -372,9 +372,6 @@ struct rndis_wext_private {
 	struct iw_statistics iwstats;
 	struct iw_statistics privstats;
 
-	int  nick_len;
-	char nick[32];
-
 	int caps;
 	int multicast_size;
 
@@ -1798,39 +1795,6 @@ static int rndis_iw_get_frag(struct net_
 }
 
 
-static int rndis_iw_set_nick(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
-
-	devdbg(usbdev, "SIOCSIWNICK");
-
-	priv->nick_len = wrqu->data.length;
-	if (priv->nick_len > 32)
-		priv->nick_len = 32;
-
-	memcpy(priv->nick, extra, priv->nick_len);
-	return 0;
-}
-
-
-static int rndis_iw_get_nick(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
-
-	wrqu->data.flags = 1;
-	wrqu->data.length = priv->nick_len;
-	memcpy(extra, priv->nick, priv->nick_len);
-
-	devdbg(usbdev, "SIOCGIWNICK: '%s'", priv->nick);
-
-	return 0;
-}
-
-
 static int rndis_iw_set_freq(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
@@ -2039,8 +2003,6 @@ static const iw_handler rndis_iw_handler
 	IW_IOCTL(SIOCGIWSCAN)      = (iw_handler) cfg80211_wext_giwscan,
 	IW_IOCTL(SIOCSIWESSID)     = rndis_iw_set_essid,
 	IW_IOCTL(SIOCGIWESSID)     = rndis_iw_get_essid,
-	IW_IOCTL(SIOCSIWNICKN)     = rndis_iw_set_nick,
-	IW_IOCTL(SIOCGIWNICKN)     = rndis_iw_get_nick,
 	IW_IOCTL(SIOCGIWRATE)      = rndis_iw_get_rate,
 	IW_IOCTL(SIOCSIWRTS)       = rndis_iw_set_rts,
 	IW_IOCTL(SIOCGIWRTS)       = rndis_iw_get_rts,


