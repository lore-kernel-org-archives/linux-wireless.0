Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.dnainternet.fi ([87.94.96.71]:21657 "EHLO
	smtp3.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbZCZVto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 17:49:44 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/6] rndis_wlan: convert get/set mode to cfg80211
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 26 Mar 2009 23:40:01 +0200
Message-ID: <20090326214001.19238.77471.stgit@fate.lan> (sfid-20090326_224947_461435_9A0219D1)
In-Reply-To: <20090326213953.19238.59497.stgit@fate.lan>
References: <20090326213953.19238.59497.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@tuxdriver.com>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
[edit: made rndis_change_virtual_intf static]
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   95 +++++++++++++++++--------------------
 1 files changed, 43 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index ebed802..464f73e 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -406,8 +406,17 @@ struct rndis_wext_private {
 	u8 command_buffer[COMMAND_BUFFER_SIZE];
 };
 
+/*
+ * cfg80211 ops
+ */
+static int rndis_change_virtual_intf(struct wiphy *wiphy, int ifindex,
+					enum nl80211_iftype type, u32 *flags,
+					struct vif_params *params);
+
+struct cfg80211_ops rndis_config_ops = {
+	.change_virtual_intf = rndis_change_virtual_intf,
+};
 
-struct cfg80211_ops rndis_config_ops = { };
 void *rndis_wiphy_privid = &rndis_wiphy_privid;
 
 static const int bcm4320_power_output[4] = { 25, 50, 75, 100 };
@@ -1125,6 +1134,37 @@ static void set_multicast_list(struct usbnet *usbdev)
 
 
 /*
+ * cfg80211 ops
+ */
+static int rndis_change_virtual_intf(struct wiphy *wiphy, int ifindex,
+					enum nl80211_iftype type, u32 *flags,
+					struct vif_params *params)
+{
+	struct net_device *dev;
+	struct usbnet *usbdev;
+	int mode;
+
+	/* we're under RTNL */
+	dev = __dev_get_by_index(&init_net, ifindex);
+	if (!dev)
+		return -ENODEV;
+	usbdev = netdev_priv(dev);
+
+	switch (type) {
+	case NL80211_IFTYPE_ADHOC:
+		mode = ndis_80211_infra_adhoc;
+		break;
+	case NL80211_IFTYPE_STATION:
+		mode = ndis_80211_infra_infra;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return set_infra_mode(usbdev, mode);
+}
+
+/*
  * wireless extension handlers
  */
 
@@ -1450,55 +1490,6 @@ static int rndis_iw_get_auth(struct net_device *dev,
 }
 
 
-static int rndis_iw_get_mode(struct net_device *dev,
-				struct iw_request_info *info,
-				union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
-
-	switch (priv->infra_mode) {
-	case ndis_80211_infra_adhoc:
-		wrqu->mode = IW_MODE_ADHOC;
-		break;
-	case ndis_80211_infra_infra:
-		wrqu->mode = IW_MODE_INFRA;
-		break;
-	/*case ndis_80211_infra_auto_unknown:*/
-	default:
-		wrqu->mode = IW_MODE_AUTO;
-		break;
-	}
-	devdbg(usbdev, "SIOCGIWMODE: %08x", wrqu->mode);
-	return 0;
-}
-
-
-static int rndis_iw_set_mode(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	int mode;
-
-	devdbg(usbdev, "SIOCSIWMODE: %08x", wrqu->mode);
-
-	switch (wrqu->mode) {
-	case IW_MODE_ADHOC:
-		mode = ndis_80211_infra_adhoc;
-		break;
-	case IW_MODE_INFRA:
-		mode = ndis_80211_infra_infra;
-		break;
-	/*case IW_MODE_AUTO:*/
-	default:
-		mode = ndis_80211_infra_auto_unknown;
-		break;
-	}
-
-	return set_infra_mode(usbdev, mode);
-}
-
-
 static int rndis_iw_set_encode(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
@@ -2196,8 +2187,8 @@ static const iw_handler rndis_iw_handler[] =
 	IW_IOCTL(SIOCGIWNAME)      = (iw_handler) cfg80211_wext_giwname,
 	IW_IOCTL(SIOCSIWFREQ)      = rndis_iw_set_freq,
 	IW_IOCTL(SIOCGIWFREQ)      = rndis_iw_get_freq,
-	IW_IOCTL(SIOCSIWMODE)      = rndis_iw_set_mode,
-	IW_IOCTL(SIOCGIWMODE)      = rndis_iw_get_mode,
+	IW_IOCTL(SIOCSIWMODE)      = (iw_handler) cfg80211_wext_siwmode,
+	IW_IOCTL(SIOCGIWMODE)      = (iw_handler) cfg80211_wext_giwmode,
 	IW_IOCTL(SIOCGIWRANGE)     = rndis_iw_get_range,
 	IW_IOCTL(SIOCSIWAP)        = rndis_iw_set_bssid,
 	IW_IOCTL(SIOCGIWAP)        = rndis_iw_get_bssid,

