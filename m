Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:57768 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbZH1K1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 06:27:52 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [RFC PATCH 02/10] rndis_wlan: add cfg80211 set_channel
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Aug 2009 13:27:53 +0300
Message-ID: <20090828102753.15684.40187.stgit@fate.lan>
In-Reply-To: <20090828102742.15684.10566.stgit@fate.lan>
References: <20090828102742.15684.10566.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add cfg80211 set_channel and convert wext to use it.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  105 +++++--------------------------------
 1 files changed, 15 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index c2af5be..ffb195d 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -517,6 +517,9 @@ static int rndis_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
 static int rndis_leave_ibss(struct wiphy *wiphy, struct net_device *dev);
 
+static int rndis_set_channel(struct wiphy *wiphy,
+	struct ieee80211_channel *chan, enum nl80211_channel_type channel_type);
+
 static struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
 	.scan = rndis_scan,
@@ -527,6 +530,7 @@ static struct cfg80211_ops rndis_config_ops = {
 	.disconnect = rndis_disconnect,
 	.join_ibss = rndis_join_ibss,
 	.leave_ibss = rndis_leave_ibss,
+	.set_channel = rndis_set_channel,
 };
 
 static void *rndis_wiphy_privid = &rndis_wiphy_privid;
@@ -924,46 +928,6 @@ static int level_to_qual(int level)
 }
 
 
-static void dsconfig_to_freq(unsigned int dsconfig, struct iw_freq *freq)
-{
-	freq->e = 0;
-	freq->i = 0;
-	freq->flags = 0;
-
-	/* see comment in wireless.h above the "struct iw_freq"
-	 * definition for an explanation of this if
-	 * NOTE: 1000000 is due to the kHz
-	 */
-	if (dsconfig > 1000000) {
-		freq->m = dsconfig / 10;
-		freq->e = 1;
-	} else
-		freq->m = dsconfig;
-
-	/* convert from kHz to Hz */
-	freq->e += 3;
-}
-
-
-static int freq_to_dsconfig(struct iw_freq *freq, unsigned int *dsconfig)
-{
-	if (freq->m < 1000 && freq->e == 0) {
-		if (freq->m >= 1 && freq->m <= 14)
-			*dsconfig = ieee80211_dsss_chan_to_freq(freq->m) * 1000;
-		else
-			return -1;
-	} else {
-		int i;
-		*dsconfig = freq->m;
-		for (i = freq->e; i > 0; i--)
-			*dsconfig *= 10;
-		*dsconfig /= 1000;
-	}
-
-	return 0;
-}
-
-
 /*
  * common functions
  */
@@ -2067,6 +2031,15 @@ static int rndis_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	return deauthenticate(usbdev);
 }
 
+static int rndis_set_channel(struct wiphy *wiphy,
+	struct ieee80211_channel *chan, enum nl80211_channel_type channel_type)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+
+	return set_channel(usbdev,
+			ieee80211_frequency_to_channel(chan->center_freq));
+}
 
 /*
  * wireless extension handlers
@@ -2416,54 +2389,6 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 }
 
 
-static int rndis_iw_set_freq(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct ndis_80211_conf config;
-	unsigned int dsconfig;
-	int len, ret;
-
-	/* this OID is valid only when not associated */
-	if (is_associated(usbdev))
-		return 0;
-
-	dsconfig = 0;
-	if (freq_to_dsconfig(&wrqu->freq, &dsconfig))
-		return -EINVAL;
-
-	len = sizeof(config);
-	ret = rndis_query_oid(usbdev, OID_802_11_CONFIGURATION, &config, &len);
-	if (ret != 0) {
-		devdbg(usbdev, "SIOCSIWFREQ: querying configuration failed");
-		return 0;
-	}
-
-	config.ds_config = cpu_to_le32(dsconfig);
-
-	devdbg(usbdev, "SIOCSIWFREQ: %d * 10^%d", wrqu->freq.m, wrqu->freq.e);
-	return rndis_set_oid(usbdev, OID_802_11_CONFIGURATION, &config,
-								sizeof(config));
-}
-
-
-static int rndis_iw_get_freq(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct ndis_80211_conf config;
-	int len, ret;
-
-	len = sizeof(config);
-	ret = rndis_query_oid(usbdev, OID_802_11_CONFIGURATION, &config, &len);
-	if (ret == 0)
-		dsconfig_to_freq(le32_to_cpu(config.ds_config), &wrqu->freq);
-
-	devdbg(usbdev, "SIOCGIWFREQ: %d", wrqu->freq.m);
-	return ret;
-}
-
-
 static int rndis_iw_get_rate(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
@@ -2501,8 +2426,8 @@ static const iw_handler rndis_iw_handler[] =
 {
 	IW_IOCTL(SIOCSIWCOMMIT)    = rndis_iw_commit,
 	IW_IOCTL(SIOCGIWNAME)      = (iw_handler) cfg80211_wext_giwname,
-	IW_IOCTL(SIOCSIWFREQ)      = rndis_iw_set_freq,
-	IW_IOCTL(SIOCGIWFREQ)      = rndis_iw_get_freq,
+	IW_IOCTL(SIOCSIWFREQ)      = (iw_handler) cfg80211_wext_siwfreq,
+	IW_IOCTL(SIOCGIWFREQ)      = (iw_handler) cfg80211_wext_giwfreq,
 	IW_IOCTL(SIOCSIWMODE)      = (iw_handler) cfg80211_wext_siwmode,
 	IW_IOCTL(SIOCGIWMODE)      = (iw_handler) cfg80211_wext_giwmode,
 	IW_IOCTL(SIOCGIWRANGE)     = (iw_handler) cfg80211_wext_giwrange,

