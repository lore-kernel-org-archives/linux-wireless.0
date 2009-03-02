Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52772 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZCBVaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 16:30:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rndis_wlan: initiate cfg80211 conversion
Date: Mon,  2 Mar 2009 16:24:24 -0500
Message-Id: <1236029064-3836-1-git-send-email-linville@tuxdriver.com> (sfid-20090302_223029_043831_D9E22337)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
I've been meaning to finish this up for a while...maybe I should just go
ahead and send it out instead...

 drivers/net/wireless/rndis_wlan.c |  114 +++++++++++++++++++++++++++---------
 1 files changed, 85 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 105f214..ebed802 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -42,6 +42,8 @@
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
 #include <net/iw_handler.h>
+#include <net/wireless.h>
+#include <net/cfg80211.h>
 #include <linux/usb/usbnet.h>
 #include <linux/usb/rndis_host.h>
 
@@ -316,12 +318,44 @@ enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
 
 #define COMMAND_BUFFER_SIZE	(CONTROL_BUFFER_SIZE + sizeof(struct rndis_set))
 
+static const struct ieee80211_channel rndis_channels[] = {
+	{ .center_freq = 2412 },
+	{ .center_freq = 2417 },
+	{ .center_freq = 2422 },
+	{ .center_freq = 2427 },
+	{ .center_freq = 2432 },
+	{ .center_freq = 2437 },
+	{ .center_freq = 2442 },
+	{ .center_freq = 2447 },
+	{ .center_freq = 2452 },
+	{ .center_freq = 2457 },
+	{ .center_freq = 2462 },
+	{ .center_freq = 2467 },
+	{ .center_freq = 2472 },
+	{ .center_freq = 2484 },
+};
+
+static const struct ieee80211_rate rndis_rates[] = {
+	{ .bitrate = 10 },
+	{ .bitrate = 20, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 55, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 110, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 60 },
+	{ .bitrate = 90 },
+	{ .bitrate = 120 },
+	{ .bitrate = 180 },
+	{ .bitrate = 240 },
+	{ .bitrate = 360 },
+	{ .bitrate = 480 },
+	{ .bitrate = 540 }
+};
+
 /* RNDIS device private data */
 struct rndis_wext_private {
-	char name[32];
-
 	struct usbnet *usbdev;
 
+	struct wireless_dev wdev;
+
 	struct workqueue_struct *workqueue;
 	struct delayed_work stats_work;
 	struct work_struct work;
@@ -329,6 +363,10 @@ struct rndis_wext_private {
 	spinlock_t stats_lock;
 	unsigned long work_pending;
 
+	struct ieee80211_supported_band band;
+	struct ieee80211_channel channels[ARRAY_SIZE(rndis_channels)];
+	struct ieee80211_rate rates[ARRAY_SIZE(rndis_rates)];
+
 	struct iw_statistics iwstats;
 	struct iw_statistics privstats;
 
@@ -369,7 +407,8 @@ struct rndis_wext_private {
 };
 
 
-static const int rates_80211g[8] = { 6, 9, 12, 18, 24, 36, 48, 54 };
+struct cfg80211_ops rndis_config_ops = { };
+void *rndis_wiphy_privid = &rndis_wiphy_privid;
 
 static const int bcm4320_power_output[4] = { 25, 50, 75, 100 };
 
@@ -1151,15 +1190,15 @@ static int rndis_iw_get_range(struct net_device *dev,
 	/* fill in 802.11g rates */
 	if (has_80211g_rates) {
 		num = range->num_bitrates;
-		for (i = 0; i < ARRAY_SIZE(rates_80211g); i++) {
+		for (i = 4; i < ARRAY_SIZE(rndis_rates); i++) {
 			for (j = 0; j < num; j++) {
 				if (range->bitrate[j] ==
-					rates_80211g[i] * 1000000)
+					rndis_rates[i].bitrate * 100000)
 					break;
 			}
 			if (j == num)
 				range->bitrate[range->num_bitrates++] =
-					rates_80211g[i] * 1000000;
+					rndis_rates[i].bitrate * 100000;
 			if (range->num_bitrates == IW_MAX_BITRATES)
 				break;
 		}
@@ -1204,17 +1243,6 @@ static int rndis_iw_get_range(struct net_device *dev,
 }
 
 
-static int rndis_iw_get_name(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
-
-	strcpy(wrqu->name, priv->name);
-	return 0;
-}
-
-
 static int rndis_iw_set_essid(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *essid)
 {
@@ -2165,7 +2193,7 @@ static struct iw_statistics *rndis_get_wireless_stats(struct net_device *dev)
 static const iw_handler rndis_iw_handler[] =
 {
 	IW_IOCTL(SIOCSIWCOMMIT)    = rndis_iw_commit,
-	IW_IOCTL(SIOCGIWNAME)      = rndis_iw_get_name,
+	IW_IOCTL(SIOCGIWNAME)      = (iw_handler) cfg80211_wext_giwname,
 	IW_IOCTL(SIOCSIWFREQ)      = rndis_iw_set_freq,
 	IW_IOCTL(SIOCGIWFREQ)      = rndis_iw_get_freq,
 	IW_IOCTL(SIOCSIWMODE)      = rndis_iw_set_mode,
@@ -2338,12 +2366,6 @@ static int rndis_wext_get_caps(struct usbnet *usbdev)
 				break;
 			}
 		}
-		if (priv->caps & CAP_MODE_80211A)
-			strcat(priv->name, "a");
-		if (priv->caps & CAP_MODE_80211B)
-			strcat(priv->name, "b");
-		if (priv->caps & CAP_MODE_80211G)
-			strcat(priv->name, "g");
 	}
 
 	return retval;
@@ -2527,20 +2549,28 @@ static int bcm4320_early_init(struct usbnet *usbdev)
 
 static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 {
+	struct wiphy *wiphy;
 	struct rndis_wext_private *priv;
 	int retval, len;
 	__le32 tmp;
 
-	/* allocate rndis private data */
-	priv = kzalloc(sizeof(struct rndis_wext_private), GFP_KERNEL);
-	if (!priv)
+	/* allocate wiphy and rndis private data
+	 * NOTE: We only support a single virtual interface, so wiphy
+	 * and wireless_dev are somewhat synonymous for this device.
+	 */
+	wiphy = wiphy_new(&rndis_config_ops, sizeof(struct rndis_wext_private));
+	if (!wiphy)
 		return -ENOMEM;
 
+	priv = wiphy_priv(wiphy);
+	usbdev->net->ieee80211_ptr = &priv->wdev;
+	priv->wdev.wiphy = wiphy;
+	priv->wdev.iftype = NL80211_IFTYPE_STATION;
+
 	/* These have to be initialized before calling generic_rndis_bind().
 	 * Otherwise we'll be in big trouble in rndis_wext_early_init().
 	 */
 	usbdev->driver_priv = priv;
-	strcpy(priv->name, "IEEE802.11");
 	usbdev->net->wireless_handlers = &rndis_iw_handlers;
 	priv->usbdev = usbdev;
 
@@ -2583,7 +2613,31 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 					| IW_QUAL_QUAL_INVALID
 					| IW_QUAL_LEVEL_INVALID;
 
+	/* fill-out wiphy structure and register w/ cfg80211 */
+	memcpy(wiphy->perm_addr, usbdev->net->dev_addr, ETH_ALEN);
+	wiphy->privid = rndis_wiphy_privid;
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION)
+					| BIT(NL80211_IFTYPE_ADHOC);
+	wiphy->max_scan_ssids = 1;
+
+	/* TODO: fill-out band information based on priv->caps */
 	rndis_wext_get_caps(usbdev);
+
+	memcpy(priv->channels, rndis_channels, sizeof(rndis_channels));
+	memcpy(priv->rates, rndis_rates, sizeof(rndis_rates));
+	priv->band.channels = priv->channels;
+	priv->band.n_channels = ARRAY_SIZE(rndis_channels);
+	priv->band.bitrates = priv->rates;
+	priv->band.n_bitrates = ARRAY_SIZE(rndis_rates);
+	wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+
+	set_wiphy_dev(wiphy, &usbdev->udev->dev);
+
+	if (wiphy_register(wiphy)) {
+		wiphy_free(wiphy);
+		return -ENODEV;
+	}
+
 	set_default_iw_params(usbdev);
 
 	/* turn radio on */
@@ -2620,9 +2674,11 @@ static void rndis_wext_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 
 	if (priv && priv->wpa_ie_len)
 		kfree(priv->wpa_ie);
-	kfree(priv);
 
 	rndis_unbind(usbdev, intf);
+
+	wiphy_unregister(priv->wdev.wiphy);
+	wiphy_free(priv->wdev.wiphy);
 }
 
 
-- 
1.6.0.6

