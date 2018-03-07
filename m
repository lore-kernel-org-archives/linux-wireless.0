Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:7398 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934924AbeCHPLC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:11:02 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/10] staging: wilc1000: fix line over 80 char in change_virtual_intf()
Date: Wed, 7 Mar 2018 07:02:25 +0530
Message-ID: <1520386350-31607-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_161109_248191_44A0534E)
In-Reply-To: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
References: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 char' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1f6c02a..3354bf2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1804,7 +1804,8 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
-			       enum nl80211_iftype type, struct vif_params *params)
+			       enum nl80211_iftype type,
+			       struct vif_params *params)
 {
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
@@ -1828,7 +1829,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		vif->iftype = STATION_MODE;
 		wilc_set_operation_mode(vif, STATION_MODE);
 
-		memset(priv->assoc_stainfo.sta_associated_bss, 0, MAX_NUM_STA * ETH_ALEN);
+		memset(priv->assoc_stainfo.sta_associated_bss, 0,
+		       MAX_NUM_STA * ETH_ALEN);
 
 		wilc_enable_ps = true;
 		wilc_set_power_mgmt(vif, 1, 0);
-- 
2.7.4
