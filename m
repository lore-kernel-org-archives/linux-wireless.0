Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.dnainternet.fi ([87.94.96.72]:5383 "EHLO
	smtp4.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZEVOkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 10:40:14 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/4] rndis_wlan: remove
	CAP_SUPPORT_TXPOWER/OID_802_11_TX_POWER_LEVEL code
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Fri, 22 May 2009 17:40:12 +0300
Message-ID: <20090522144012.8134.27669.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BCM4320 doesn't support OID_802_11_TX_POWER_LEVEL (chip implements
the command but setting value has no effect and getting txpower value
always returns 0xff, full power). So remove the code for cleanup.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   46 ++++++-------------------------------
 1 files changed, 8 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 52fc647..f9b0a35 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2,7 +2,7 @@
  * Driver for RNDIS based wireless USB devices.
  *
  * Copyright (C) 2007 by Bjorge Dijkstra <bjd@jooz.net>
- * Copyright (C) 2008 by Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (C) 2008-2009 by Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -309,7 +309,6 @@ enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
 #define CAP_MODE_80211B		2
 #define CAP_MODE_80211G		4
 #define CAP_MODE_MASK		7
-#define CAP_SUPPORT_TXPOWER	8
 
 #define WORK_LINK_UP		(1<<0)
 #define WORK_LINK_DOWN		(1<<1)
@@ -1849,18 +1848,10 @@ static int rndis_iw_get_txpower(struct net_device *dev,
 	struct usbnet *usbdev = netdev_priv(dev);
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 	__le32 tx_power;
-	int ret = 0, len;
 
 	if (priv->radio_on) {
-		if (priv->caps & CAP_SUPPORT_TXPOWER) {
-			len = sizeof(tx_power);
-			ret = rndis_query_oid(usbdev, OID_802_11_TX_POWER_LEVEL,
-							&tx_power, &len);
-			if (ret != 0)
-				return ret;
-		} else
-			/* fake incase not supported */
-			tx_power = cpu_to_le32(get_bcm4320_power(priv));
+		/* fake since changing tx_power (by userlevel) not supported */
+		tx_power = cpu_to_le32(get_bcm4320_power(priv));
 
 		wrqu->txpower.flags = IW_TXPOW_MWATT;
 		wrqu->txpower.value = le32_to_cpu(tx_power);
@@ -1873,7 +1864,7 @@ static int rndis_iw_get_txpower(struct net_device *dev,
 
 	devdbg(usbdev, "SIOCGIWTXPOW: %d", wrqu->txpower.value);
 
-	return ret;
+	return 0;
 }
 
 
@@ -1883,7 +1874,6 @@ static int rndis_iw_set_txpower(struct net_device *dev,
 	struct usbnet *usbdev = netdev_priv(dev);
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 	__le32 tx_power = 0;
-	int ret = 0;
 
 	if (!wrqu->txpower.disabled) {
 		if (wrqu->txpower.flags == IW_TXPOW_MWATT)
@@ -1906,22 +1896,10 @@ static int rndis_iw_set_txpower(struct net_device *dev,
 	devdbg(usbdev, "SIOCSIWTXPOW: %d", le32_to_cpu(tx_power));
 
 	if (le32_to_cpu(tx_power) != 0) {
-		if (priv->caps & CAP_SUPPORT_TXPOWER) {
-			/* turn radio on first */
-			if (!priv->radio_on)
-				disassociate(usbdev, 1);
-
-			ret = rndis_set_oid(usbdev, OID_802_11_TX_POWER_LEVEL,
-						&tx_power, sizeof(tx_power));
-			if (ret != 0)
-				ret = -EOPNOTSUPP;
-			return ret;
-		} else {
-			/* txpower unsupported, just turn radio on */
-			if (!priv->radio_on)
-				return disassociate(usbdev, 1);
-			return 0; /* all ready on */
-		}
+		/* txpower unsupported, just turn radio on */
+		if (!priv->radio_on)
+			return disassociate(usbdev, 1);
+		return 0; /* all ready on */
 	}
 
 	/* tx_power == 0, turn off radio */
@@ -2130,16 +2108,8 @@ static int rndis_wext_get_caps(struct usbnet *usbdev)
 		__le32	items[8];
 	} networks_supported;
 	int len, retval, i, n;
-	__le32 tx_power;
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 
-	/* determine if supports setting txpower */
-	len = sizeof(tx_power);
-	retval = rndis_query_oid(usbdev, OID_802_11_TX_POWER_LEVEL, &tx_power,
-									&len);
-	if (retval == 0 && le32_to_cpu(tx_power) != 0xFF)
-		priv->caps |= CAP_SUPPORT_TXPOWER;
-
 	/* determine supported modes */
 	len = sizeof(networks_supported);
 	retval = rndis_query_oid(usbdev, OID_802_11_NETWORK_TYPES_SUPPORTED,

