Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.dnainternet.fi ([87.94.96.71]:21666 "EHLO
	smtp3.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123AbZCZVto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 17:49:44 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 5/6] rndis_wlan: convert get range to cfg80211
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 26 Mar 2009 23:40:23 +0200
Message-ID: <20090326214023.19238.70605.stgit@fate.lan> (sfid-20090326_224950_967163_415C50B0)
In-Reply-To: <20090326213953.19238.59497.stgit@fate.lan>
References: <20090326213953.19238.59497.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  110 +------------------------------------
 1 files changed, 2 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 6e482ab..3674c67 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1176,113 +1176,6 @@ static int rndis_iw_commit(struct net_device *dev,
 }
 
 
-static int rndis_iw_get_range(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct iw_range *range = (struct iw_range *)extra;
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
-	int len, ret, i, j, num, has_80211g_rates;
-	u8 rates[8];
-	__le32 tx_power;
-
-	devdbg(usbdev, "SIOCGIWRANGE");
-
-	/* clear iw_range struct */
-	memset(range, 0, sizeof(*range));
-	wrqu->data.length = sizeof(*range);
-
-	range->txpower_capa = IW_TXPOW_MWATT;
-	range->num_txpower = 1;
-	if (priv->caps & CAP_SUPPORT_TXPOWER) {
-		len = sizeof(tx_power);
-		ret = rndis_query_oid(usbdev, OID_802_11_TX_POWER_LEVEL,
-						&tx_power, &len);
-		if (ret == 0 && le32_to_cpu(tx_power) != 0xFF)
-			range->txpower[0] = le32_to_cpu(tx_power);
-		else
-			range->txpower[0] = get_bcm4320_power(priv);
-	} else
-		range->txpower[0] = get_bcm4320_power(priv);
-
-	len = sizeof(rates);
-	ret = rndis_query_oid(usbdev, OID_802_11_SUPPORTED_RATES, &rates,
-								&len);
-	has_80211g_rates = 0;
-	if (ret == 0) {
-		j = 0;
-		for (i = 0; i < len; i++) {
-			if (rates[i] == 0)
-				break;
-			range->bitrate[j] = (rates[i] & 0x7f) * 500000;
-			/* check for non 802.11b rates */
-			if (range->bitrate[j] == 6000000 ||
-				range->bitrate[j] == 9000000 ||
-				(range->bitrate[j] >= 12000000 &&
-				range->bitrate[j] != 22000000))
-				has_80211g_rates = 1;
-			j++;
-		}
-		range->num_bitrates = j;
-	} else
-		range->num_bitrates = 0;
-
-	/* fill in 802.11g rates */
-	if (has_80211g_rates) {
-		num = range->num_bitrates;
-		for (i = 4; i < ARRAY_SIZE(rndis_rates); i++) {
-			for (j = 0; j < num; j++) {
-				if (range->bitrate[j] ==
-					rndis_rates[i].bitrate * 100000)
-					break;
-			}
-			if (j == num)
-				range->bitrate[range->num_bitrates++] =
-					rndis_rates[i].bitrate * 100000;
-			if (range->num_bitrates == IW_MAX_BITRATES)
-				break;
-		}
-
-		/* estimated max real througput in bps */
-		range->throughput = 54 * 1000 * 1000 / 2;
-
-		/* ~35%	more with afterburner */
-		if (priv->param_afterburner)
-			range->throughput = range->throughput / 100 * 135;
-	} else {
-		/* estimated max real througput in bps */
-		range->throughput = 11 * 1000 * 1000 / 2;
-	}
-
-	range->num_channels = 14;
-
-	for (i = 0; (i < 14) && (i < IW_MAX_FREQUENCIES); i++) {
-		range->freq[i].i = i + 1;
-		range->freq[i].m = ieee80211_dsss_chan_to_freq(i + 1) * 100000;
-		range->freq[i].e = 1;
-	}
-	range->num_frequency = i;
-
-	range->min_rts = 0;
-	range->max_rts = 2347;
-	range->min_frag = 256;
-	range->max_frag = 2346;
-
-	range->max_qual.qual = 100;
-	range->max_qual.level = 100;
-	range->max_qual.updated = IW_QUAL_QUAL_UPDATED
-				| IW_QUAL_LEVEL_UPDATED
-				| IW_QUAL_NOISE_INVALID;
-
-	range->we_version_compiled = WIRELESS_EXT;
-	range->we_version_source = WIRELESS_EXT;
-
-	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
-			IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
-	return 0;
-}
-
-
 static int rndis_iw_set_essid(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *essid)
 {
@@ -2189,7 +2082,7 @@ static const iw_handler rndis_iw_handler[] =
 	IW_IOCTL(SIOCGIWFREQ)      = rndis_iw_get_freq,
 	IW_IOCTL(SIOCSIWMODE)      = (iw_handler) cfg80211_wext_siwmode,
 	IW_IOCTL(SIOCGIWMODE)      = (iw_handler) cfg80211_wext_giwmode,
-	IW_IOCTL(SIOCGIWRANGE)     = rndis_iw_get_range,
+	IW_IOCTL(SIOCGIWRANGE)     = (iw_handler) cfg80211_wext_giwrange,
 	IW_IOCTL(SIOCSIWAP)        = rndis_iw_set_bssid,
 	IW_IOCTL(SIOCGIWAP)        = rndis_iw_get_bssid,
 	IW_IOCTL(SIOCSIWSCAN)      = rndis_iw_set_scan,
@@ -2621,6 +2514,7 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	priv->band.bitrates = priv->rates;
 	priv->band.n_bitrates = ARRAY_SIZE(rndis_rates);
 	wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
 
 	set_wiphy_dev(wiphy, &usbdev->udev->dev);
 

