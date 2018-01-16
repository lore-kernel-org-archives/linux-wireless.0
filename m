Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:44705 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbeAPODM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:03:12 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/13] staging: wilc1000: rename NullBssid to null_bssid to avoid camelCase variable name
Date: Tue, 16 Jan 2018 19:32:27 +0530
Message-ID: <1516111351-5353-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150318_810661_2D11BF6B)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is cleanup patch, it fixes "Avoid CamelCase: <NullBssid>" found
by checkpatch.pl.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1c5782e..ae8df88 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -815,7 +815,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	struct host_if_drv *wfi_drv;
 	struct wilc_vif *vif;
 	struct wilc *wilc;
-	u8 NullBssid[ETH_ALEN] = {0};
+	u8 null_bssid[ETH_ALEN] = {0};
 
 	wilc_connecting = 0;
 	priv = wiphy_priv(wiphy);
@@ -834,7 +834,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	wfi_drv = (struct host_if_drv *)priv->hif_drv;
 	if (!wfi_drv->p2p_connect)
 		wlan_channel = INVALID_CHANNEL;
-	wilc_wlan_set_bssid(priv->dev, NullBssid, STATION_MODE);
+	wilc_wlan_set_bssid(priv->dev, null_bssid, STATION_MODE);
 
 	p2p_local_random = 0x01;
 	p2p_recv_random = 0x00;
@@ -1936,7 +1936,7 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	s32 ret = 0;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
-	u8 NullBssid[ETH_ALEN] = {0};
+	u8 null_bssid[ETH_ALEN] = {0};
 
 	if (!wiphy)
 		return -EFAULT;
@@ -1944,7 +1944,7 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
 
-	wilc_wlan_set_bssid(dev, NullBssid, AP_MODE);
+	wilc_wlan_set_bssid(dev, null_bssid, AP_MODE);
 
 	ret = wilc_del_beacon(vif);
 
-- 
2.7.4
