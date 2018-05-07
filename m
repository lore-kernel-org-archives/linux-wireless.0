Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:17781 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752233AbeEGIpC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:45:02 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 24/30] staging: wilc1000: refactor del_station() to avoid parenthesis misalignment
Date: Mon, 7 May 2018 14:13:28 +0530
Message-ID: <1525682614-3824-25-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104536_795531_2B3F5A0C)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor the code to fix open parenthesis alignment issue reported by
checkpatch.pl script in del_station().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4600f4a..7f49d60 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1997,6 +1997,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 	s32 ret = 0;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
+	struct sta_info *info;
 
 	if (!wiphy)
 		return -EFAULT;
@@ -2004,16 +2005,17 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(dev);
 
-	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
-		if (!mac)
-			ret = wilc_del_allstation(vif,
-				     priv->assoc_stainfo.sta_associated_bss);
+	if (!(vif->iftype == AP_MODE || vif->iftype == GO_MODE))
+		return ret;
 
-		ret = wilc_del_station(vif, mac);
+	info = &priv->assoc_stainfo;
 
-		if (ret)
-			netdev_err(dev, "Host delete station fail\n");
-	}
+	if (!mac)
+		ret = wilc_del_allstation(vif, info->sta_associated_bss);
+
+	ret = wilc_del_station(vif, mac);
+	if (ret)
+		netdev_err(dev, "Host delete station fail\n");
 	return ret;
 }
 
-- 
2.7.4
