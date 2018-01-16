Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:22634 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751390AbeAPOCx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:02:53 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 03/13] staging: wilc1000: rename au8Sta_AssociatedBss element sta_info structure
Date: Tue, 16 Jan 2018 19:32:21 +0530
Message-ID: <1516111351-5353-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150258_612262_EE8931FA)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cleanup patch, to rename au8Sta_AssociatedBss element of
sta_info structure.
The changes fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d6ff989..7dfb230 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1182,7 +1182,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		for (i = 0; i < NUM_STA_ASSOCIATED; i++) {
-			if (!(memcmp(mac, priv->assoc_stainfo.au8Sta_AssociatedBss[i], ETH_ALEN))) {
+			if (!(memcmp(mac, priv->assoc_stainfo.sta_associated_bss[i], ETH_ALEN))) {
 				associatedsta = i;
 				break;
 			}
@@ -1837,7 +1837,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		vif->iftype = STATION_MODE;
 		wilc_set_operation_mode(vif, STATION_MODE);
 
-		memset(priv->assoc_stainfo.au8Sta_AssociatedBss, 0, MAX_NUM_STA * ETH_ALEN);
+		memset(priv->assoc_stainfo.sta_associated_bss, 0, MAX_NUM_STA * ETH_ALEN);
 
 		wilc_enable_ps = true;
 		wilc_set_power_mgmt(vif, 1, 0);
@@ -1970,7 +1970,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
-		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
+		memcpy(priv->assoc_stainfo.sta_associated_bss[params->aid], mac, ETH_ALEN);
 		strStaParams.aid = params->aid;
 		strStaParams.rates_len = params->supported_rates_len;
 		strStaParams.rates = params->supported_rates;
@@ -2010,7 +2010,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		if (!mac)
 			s32Error = wilc_del_allstation(vif,
-				     priv->assoc_stainfo.au8Sta_AssociatedBss);
+				     priv->assoc_stainfo.sta_associated_bss);
 
 		s32Error = wilc_del_station(vif, mac);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 0a936a4..a4c193e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -86,7 +86,7 @@ struct wilc_wfi_wep_key {
 };
 
 struct sta_info {
-	u8 au8Sta_AssociatedBss[MAX_NUM_STA][ETH_ALEN];
+	u8 sta_associated_bss[MAX_NUM_STA][ETH_ALEN];
 };
 
 /*Parameters needed for host interface for  remaining on channel*/
-- 
2.7.4
