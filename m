Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:52724 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858AbZHZMxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 08:53:01 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] rndis_wlan: set cipher suites for cfg80211
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 26 Aug 2009 15:53:02 +0300
Message-ID: <20090826125302.25900.98016.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_wlan does not set cipher suites list for cfg80211 which causes
wext-compat-range to report rndis_wlan not supporting WPA. Patch adds
cipher suites list and fixes NetworkManager not being able to connect to
WPA encrypted APs.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index c5b921b..f181b00 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -413,6 +413,13 @@ static const struct ieee80211_rate rndis_rates[] = {
 	{ .bitrate = 540 }
 };
 
+static const u32 rndis_cipher_suites[] = {
+	WLAN_CIPHER_SUITE_WEP40,
+	WLAN_CIPHER_SUITE_WEP104,
+	WLAN_CIPHER_SUITE_TKIP,
+	WLAN_CIPHER_SUITE_CCMP,
+};
+
 struct rndis_wlan_encr_key {
 	int len;
 	int cipher;
@@ -441,6 +448,7 @@ struct rndis_wlan_private {
 	struct ieee80211_supported_band band;
 	struct ieee80211_channel channels[ARRAY_SIZE(rndis_channels)];
 	struct ieee80211_rate rates[ARRAY_SIZE(rndis_rates)];
+	u32 cipher_suites[ARRAY_SIZE(rndis_cipher_suites)];
 
 	struct iw_statistics iwstats;
 	struct iw_statistics privstats;
@@ -2892,7 +2900,7 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 					| BIT(NL80211_IFTYPE_ADHOC);
 	wiphy->max_scan_ssids = 1;
 
-	/* TODO: fill-out band information based on priv->caps */
+	/* TODO: fill-out band/encr information based on priv->caps */
 	rndis_wlan_get_caps(usbdev);
 
 	memcpy(priv->channels, rndis_channels, sizeof(rndis_channels));
@@ -2904,6 +2912,11 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
 
+	memcpy(priv->cipher_suites, rndis_cipher_suites,
+						sizeof(rndis_cipher_suites));
+	wiphy->cipher_suites = priv->cipher_suites;
+	wiphy->n_cipher_suites = ARRAY_SIZE(rndis_cipher_suites);
+
 	set_wiphy_dev(wiphy, &usbdev->udev->dev);
 
 	if (wiphy_register(wiphy)) {

