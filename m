Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:45786 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbeGSGrD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:47:03 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 22/23] staging: wilc1000: remove unnecessary 'NULL' check from cfg80211_ops callbacks
Date: Thu, 19 Jul 2018 04:15:18 +0530
Message-ID: <1531953919-20804-23-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080540_471359_61A78584)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unnecessary 'NULL' check used in 'cfg80211_ops'
callback functions.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ba6f9ed..2d44333 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1781,9 +1781,6 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 
-	if (!wiphy)
-		return -ENOENT;
-
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
 	if (!priv->hif_drv)
@@ -1921,9 +1918,6 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	struct wilc_vif *vif;
 	u8 null_bssid[ETH_ALEN] = {0};
 
-	if (!wiphy)
-		return -EFAULT;
-
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
 
@@ -1945,9 +1939,6 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 	struct add_sta_param sta_params = { {0} };
 	struct wilc_vif *vif;
 
-	if (!wiphy)
-		return -EFAULT;
-
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(dev);
 
@@ -1986,9 +1977,6 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 	struct wilc_vif *vif;
 	struct sta_info *info;
 
-	if (!wiphy)
-		return -EFAULT;
-
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(dev);
 
@@ -2013,9 +2001,6 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 	struct add_sta_param sta_params = { {0} };
 	struct wilc_vif *vif;
 
-	if (!wiphy)
-		return -EFAULT;
-
 	vif = netdev_priv(dev);
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
-- 
2.7.4
