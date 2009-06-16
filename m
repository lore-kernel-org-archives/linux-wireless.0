Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:54847 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZFPO0E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 10:26:04 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/3] rndis_wlan: convert set/get txpower to cfg80211
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Tue, 16 Jun 2009 17:17:32 +0300
Message-ID: <20090616141732.23639.73854.stgit@fate.lan>
In-Reply-To: <20090616141721.23639.15379.stgit@fate.lan>
References: <20090616141721.23639.15379.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert set/get txpower to cfg80211 and add stop netdev handler to turn off
radio for rfkill.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  148 +++++++++++++++++++------------------
 1 files changed, 75 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 323dd29..0c58c0e 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -139,9 +139,15 @@ MODULE_PARM_DESC(workaround_interval,
 /* Assume that Broadcom 4320 (only chipset at time of writing known to be
  * based on wireless rndis) has default txpower of 13dBm.
  * This value is from Linksys WUSB54GSC User Guide, Appendix F: Specifications.
- *   13dBm == 19.9mW
+ *  100% : 20 mW ~ 13dBm
+ *   75% : 15 mW ~ 12dBm
+ *   50% : 10 mW ~ 10dBm
+ *   25% :  5 mW ~  7dBm
  */
-#define BCM4320_DEFAULT_TXPOWER 20
+#define BCM4320_DEFAULT_TXPOWER_DBM_100 13
+#define BCM4320_DEFAULT_TXPOWER_DBM_75  12
+#define BCM4320_DEFAULT_TXPOWER_DBM_50  10
+#define BCM4320_DEFAULT_TXPOWER_DBM_25  7
 
 
 /* codes for "status" field of completion messages */
@@ -429,15 +435,20 @@ static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 
 static int rndis_set_wiphy_params(struct wiphy *wiphy, u32 changed);
 
+static int rndis_set_tx_power(struct wiphy *wiphy, enum tx_power_setting type,
+				int dbm);
+static int rndis_get_tx_power(struct wiphy *wiphy, int *dbm);
+
 static struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
 	.scan = rndis_scan,
 	.set_wiphy_params = rndis_set_wiphy_params,
+	.set_tx_power = rndis_set_tx_power,
+	.get_tx_power = rndis_get_tx_power,
 };
 
 static void *rndis_wiphy_privid = &rndis_wiphy_privid;
 
-static const int bcm4320_power_output[4] = { 25, 50, 75, 100 };
 
 static const unsigned char zero_bssid[ETH_ALEN] = {0,};
 static const unsigned char ffff_bssid[ETH_ALEN] = { 0xff, 0xff, 0xff,
@@ -450,10 +461,19 @@ static struct rndis_wlan_private *get_rndis_wlan_priv(struct usbnet *dev)
 }
 
 
-static u32 get_bcm4320_power(struct rndis_wlan_private *priv)
+static u32 get_bcm4320_power_dbm(struct rndis_wlan_private *priv)
 {
-	return BCM4320_DEFAULT_TXPOWER *
-		bcm4320_power_output[priv->param_power_output] / 100;
+	switch (priv->param_power_output) {
+	default:
+	case 3:
+		return BCM4320_DEFAULT_TXPOWER_DBM_100;
+	case 2:
+		return BCM4320_DEFAULT_TXPOWER_DBM_75;
+	case 1:
+		return BCM4320_DEFAULT_TXPOWER_DBM_50;
+	case 0:
+		return BCM4320_DEFAULT_TXPOWER_DBM_25;
+	}
 }
 
 
@@ -1306,6 +1326,42 @@ static int rndis_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 }
 
 
+static int rndis_set_tx_power(struct wiphy *wiphy, enum tx_power_setting type,
+				int dbm)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+
+	devdbg(usbdev, "rndis_set_tx_power type:0x%x dbm:%i", type, dbm);
+
+	/* Device doesn't support changing txpower after initialization, only
+	 * turn off/on radio. Support 'auto' mode and setting same dBm that is
+	 * currently used.
+	 */
+	if (type == TX_POWER_AUTOMATIC || dbm == get_bcm4320_power_dbm(priv)) {
+		if (!priv->radio_on)
+			disassociate(usbdev, 1); /* turn on radio */
+
+		return 0;
+	}
+
+	return -ENOTSUPP;
+}
+
+
+static int rndis_get_tx_power(struct wiphy *wiphy, int *dbm)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+
+	*dbm = get_bcm4320_power_dbm(priv);
+
+	devdbg(usbdev, "rndis_get_tx_power dbm:%i", *dbm);
+
+	return 0;
+}
+
+
 #define SCAN_DELAY_JIFFIES (HZ)
 static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request)
@@ -1869,71 +1925,6 @@ static int rndis_iw_get_freq(struct net_device *dev,
 }
 
 
-static int rndis_iw_get_txpower(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
-	__le32 tx_power;
-
-	if (priv->radio_on) {
-		/* fake since changing tx_power (by userlevel) not supported */
-		tx_power = cpu_to_le32(get_bcm4320_power(priv));
-
-		wrqu->txpower.flags = IW_TXPOW_MWATT;
-		wrqu->txpower.value = le32_to_cpu(tx_power);
-		wrqu->txpower.disabled = 0;
-	} else {
-		wrqu->txpower.flags = IW_TXPOW_MWATT;
-		wrqu->txpower.value = 0;
-		wrqu->txpower.disabled = 1;
-	}
-
-	devdbg(usbdev, "SIOCGIWTXPOW: %d", wrqu->txpower.value);
-
-	return 0;
-}
-
-
-static int rndis_iw_set_txpower(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
-	__le32 tx_power = 0;
-
-	if (!wrqu->txpower.disabled) {
-		if (wrqu->txpower.flags == IW_TXPOW_MWATT)
-			tx_power = cpu_to_le32(wrqu->txpower.value);
-		else { /* wrqu->txpower.flags == IW_TXPOW_DBM */
-			if (wrqu->txpower.value > 20)
-				tx_power = cpu_to_le32(128);
-			else if (wrqu->txpower.value < -43)
-				tx_power = cpu_to_le32(127);
-			else {
-				signed char tmp;
-				tmp = wrqu->txpower.value;
-				tmp = -12 - tmp;
-				tmp <<= 2;
-				tx_power = cpu_to_le32((unsigned char)tmp);
-			}
-		}
-	}
-
-	devdbg(usbdev, "SIOCSIWTXPOW: %d", le32_to_cpu(tx_power));
-
-	if (le32_to_cpu(tx_power) != 0) {
-		/* txpower unsupported, just turn radio on */
-		if (!priv->radio_on)
-			return disassociate(usbdev, 1);
-		return 0; /* all ready on */
-	}
-
-	/* tx_power == 0, turn off radio */
-	return disassociate(usbdev, 0);
-}
-
-
 static int rndis_iw_get_rate(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
@@ -2013,8 +2004,8 @@ static const iw_handler rndis_iw_handler[] =
 	IW_IOCTL(SIOCGIWRTS)       = (iw_handler) cfg80211_wext_giwrts,
 	IW_IOCTL(SIOCSIWFRAG)      = (iw_handler) cfg80211_wext_siwfrag,
 	IW_IOCTL(SIOCGIWFRAG)      = (iw_handler) cfg80211_wext_giwfrag,
-	IW_IOCTL(SIOCSIWTXPOW)     = rndis_iw_set_txpower,
-	IW_IOCTL(SIOCGIWTXPOW)     = rndis_iw_get_txpower,
+	IW_IOCTL(SIOCSIWTXPOW)     = (iw_handler) cfg80211_wext_siwtxpower,
+	IW_IOCTL(SIOCGIWTXPOW)     = (iw_handler) cfg80211_wext_giwtxpower,
 	IW_IOCTL(SIOCSIWENCODE)    = rndis_iw_set_encode,
 	IW_IOCTL(SIOCSIWENCODEEXT) = rndis_iw_set_encode_ext,
 	IW_IOCTL(SIOCSIWAUTH)      = rndis_iw_set_auth,
@@ -2513,10 +2504,18 @@ static void rndis_wlan_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 
 static int rndis_wlan_reset(struct usbnet *usbdev)
 {
+	devdbg(usbdev, "rndis_wlan_reset");
 	return deauthenticate(usbdev);
 }
 
 
+static int rndis_wlan_stop(struct usbnet *usbdev)
+{
+	devdbg(usbdev, "rndis_wlan_stop");
+	return disassociate(usbdev, 0);
+}
+
+
 static const struct driver_info	bcm4320b_info = {
 	.description =	"Wireless RNDIS device, BCM4320b based",
 	.flags =	FLAG_WLAN | FLAG_FRAMING_RN | FLAG_NO_SETINT,
@@ -2526,6 +2525,7 @@ static const struct driver_info	bcm4320b_info = {
 	.rx_fixup =	rndis_rx_fixup,
 	.tx_fixup =	rndis_tx_fixup,
 	.reset =	rndis_wlan_reset,
+	.stop =		rndis_wlan_stop,
 	.early_init =	bcm4320b_early_init,
 	.link_change =	rndis_wlan_link_change,
 };
@@ -2539,6 +2539,7 @@ static const struct driver_info	bcm4320a_info = {
 	.rx_fixup =	rndis_rx_fixup,
 	.tx_fixup =	rndis_tx_fixup,
 	.reset =	rndis_wlan_reset,
+	.stop =		rndis_wlan_stop,
 	.early_init =	bcm4320a_early_init,
 	.link_change =	rndis_wlan_link_change,
 };
@@ -2552,6 +2553,7 @@ static const struct driver_info rndis_wlan_info = {
 	.rx_fixup =	rndis_rx_fixup,
 	.tx_fixup =	rndis_tx_fixup,
 	.reset =	rndis_wlan_reset,
+	.stop =		rndis_wlan_stop,
 	.early_init =	bcm4320a_early_init,
 	.link_change =	rndis_wlan_link_change,
 };

