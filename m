Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:38409 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754349AbZIAMcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 08:32:55 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/4] rndis_wlan: use bool for on/off switches
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 01 Sep 2009 15:32:55 +0300
Message-ID: <20090901123255.9213.57970.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 402d367..dc2804f 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -466,7 +466,7 @@ struct rndis_wlan_private {
 	u32  param_workaround_interval;
 
 	/* hardware state */
-	int radio_on;
+	bool radio_on;
 	int infra_mode;
 	bool connected;
 	u8 bssid[ETH_ALEN];
@@ -966,8 +966,8 @@ static int set_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 	}
 	if (ret == 0) {
 		memcpy(&priv->essid, ssid, sizeof(priv->essid));
-		priv->radio_on = 1;
-		devdbg(usbdev, "set_essid: radio_on = 1");
+		priv->radio_on = true;
+		devdbg(usbdev, "set_essid: radio_on = true");
 	}
 
 	return ret;
@@ -1028,7 +1028,7 @@ static bool is_associated(struct usbnet *usbdev)
 }
 
 
-static int disassociate(struct usbnet *usbdev, int reset_ssid)
+static int disassociate(struct usbnet *usbdev, bool reset_ssid)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_ssid ssid;
@@ -1037,8 +1037,8 @@ static int disassociate(struct usbnet *usbdev, int reset_ssid)
 	if (priv->radio_on) {
 		ret = rndis_set_oid(usbdev, OID_802_11_DISASSOCIATE, NULL, 0);
 		if (ret == 0) {
-			priv->radio_on = 0;
-			devdbg(usbdev, "disassociate: radio_on = 0");
+			priv->radio_on = false;
+			devdbg(usbdev, "disassociate: radio_on = false");
 
 			if (reset_ssid)
 				msleep(100);
@@ -1234,7 +1234,7 @@ static int deauthenticate(struct usbnet *usbdev)
 {
 	int ret;
 
-	ret = disassociate(usbdev, 1);
+	ret = disassociate(usbdev, true);
 	set_default_iw_params(usbdev);
 	return ret;
 }
@@ -1634,7 +1634,7 @@ static int rndis_set_tx_power(struct wiphy *wiphy, enum tx_power_setting type,
 	 */
 	if (type == TX_POWER_AUTOMATIC || dbm == get_bcm4320_power_dbm(priv)) {
 		if (!priv->radio_on)
-			disassociate(usbdev, 1); /* turn on radio */
+			disassociate(usbdev, true); /* turn on radio */
 
 		return 0;
 	}
@@ -1923,7 +1923,7 @@ static int rndis_connect(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 
 err_turn_radio_on:
-	disassociate(usbdev, 1);
+	disassociate(usbdev, true);
 
 	return ret;
 }
@@ -2031,7 +2031,7 @@ static int rndis_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 
 err_turn_radio_on:
-	disassociate(usbdev, 1);
+	disassociate(usbdev, true);
 
 	return ret;
 }
@@ -2823,8 +2823,8 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 			WIPHY_PARAM_FRAG_THRESHOLD | WIPHY_PARAM_RTS_THRESHOLD);
 
 	/* turn radio on */
-	priv->radio_on = 1;
-	disassociate(usbdev, 1);
+	priv->radio_on = true;
+	disassociate(usbdev, true);
 	netif_carrier_off(usbdev->net);
 
 	return 0;
@@ -2846,7 +2846,7 @@ static void rndis_wlan_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
 	/* turn radio off */
-	disassociate(usbdev, 0);
+	disassociate(usbdev, false);
 
 	cancel_delayed_work_sync(&priv->dev_poller_work);
 	cancel_delayed_work_sync(&priv->scan_work);
@@ -2894,7 +2894,7 @@ static int rndis_wlan_stop(struct usbnet *usbdev)
 
 	devdbg(usbdev, "rndis_wlan_stop");
 
-	retval = disassociate(usbdev, 0);
+	retval = disassociate(usbdev, false);
 
 	priv->work_pending = 0;
 	cancel_delayed_work_sync(&priv->dev_poller_work);

