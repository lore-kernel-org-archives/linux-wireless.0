Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43216 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964895AbbJ1HFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:05:47 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 65/80] staging: wilc1000: rename au8BSSID of struct add_sta_param
Date: Wed, 28 Oct 2015 16:07:10 +0900
Message-ID: <1446016045-32154-15-git-send-email-glen.lee@atmel.com> (sfid-20151028_080612_596370_99793C17)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames au8BSSID of struct add_sta_param to bssid
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  2 +-
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 ++++++----
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ff65b87..16aa2c9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2309,7 +2309,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	pu8CurrByte = pu8Buffer;
 
 	PRINT_D(HOSTINF_DBG, "Packing STA params\n");
-	memcpy(pu8CurrByte, pstrStationParam->au8BSSID, ETH_ALEN);
+	memcpy(pu8CurrByte, pstrStationParam->bssid, ETH_ALEN);
 	pu8CurrByte +=  ETH_ALEN;
 
 	*pu8CurrByte++ = pstrStationParam->u16AssocID & 0xFF;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4991d55..c102a5b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -288,7 +288,7 @@ struct host_if_drv {
 };
 
 struct add_sta_param {
-	u8 au8BSSID[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
 	u16 u16AssocID;
 	u8 u8NumRates;
 	const u8 *pu8Rates;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2fdf856..608bfe9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3005,7 +3005,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 	nic = netdev_priv(dev);
 
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
-		memcpy(strStaParams.au8BSSID, mac, ETH_ALEN);
+		memcpy(strStaParams.bssid, mac, ETH_ALEN);
 		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
 		strStaParams.u16AssocID = params->aid;
 		strStaParams.u8NumRates = params->supported_rates_len;
@@ -3119,13 +3119,15 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 	nic = netdev_priv(dev);
 
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
-		memcpy(strStaParams.au8BSSID, mac, ETH_ALEN);
+		memcpy(strStaParams.bssid, mac, ETH_ALEN);
 		strStaParams.u16AssocID = params->aid;
 		strStaParams.u8NumRates = params->supported_rates_len;
 		strStaParams.pu8Rates = params->supported_rates;
 
-		PRINT_D(HOSTAPD_DBG, "BSSID = %x%x%x%x%x%x\n", strStaParams.au8BSSID[0], strStaParams.au8BSSID[1], strStaParams.au8BSSID[2], strStaParams.au8BSSID[3], strStaParams.au8BSSID[4],
-			strStaParams.au8BSSID[5]);
+		PRINT_D(HOSTAPD_DBG, "BSSID = %x%x%x%x%x%x\n",
+			strStaParams.bssid[0], strStaParams.bssid[1],
+			strStaParams.bssid[2], strStaParams.bssid[3],
+			strStaParams.bssid[4], strStaParams.bssid[5]);
 		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.u16AssocID);
 		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n", strStaParams.u8NumRates);
 
-- 
1.9.1

