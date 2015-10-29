Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27109 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965268AbbJ2DFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:05:10 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 50/64] staging: wilc1000: rename u16AssocID of struct add_sta_param
Date: Thu, 29 Oct 2015 12:05:42 +0900
Message-ID: <1446087956-19054-17-git-send-email-glen.lee@atmel.com> (sfid-20151029_041655_356830_B0B93357)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u16AssocID of struct add_sta_param to aid
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 4 ++--
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2cf3ed5..512000e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2311,8 +2311,8 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	memcpy(pu8CurrByte, pstrStationParam->bssid, ETH_ALEN);
 	pu8CurrByte +=  ETH_ALEN;
 
-	*pu8CurrByte++ = pstrStationParam->u16AssocID & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->u16AssocID >> 8) & 0xFF;
+	*pu8CurrByte++ = pstrStationParam->aid & 0xFF;
+	*pu8CurrByte++ = (pstrStationParam->aid >> 8) & 0xFF;
 
 	*pu8CurrByte++ = pstrStationParam->u8NumRates;
 	if (pstrStationParam->u8NumRates > 0)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 58e4f92..7d8a166 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -289,7 +289,7 @@ struct host_if_drv {
 
 struct add_sta_param {
 	u8 bssid[ETH_ALEN];
-	u16 u16AssocID;
+	u16 aid;
 	u8 u8NumRates;
 	const u8 *pu8Rates;
 	bool bIsHTSupported;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2ec85f0..00fa411 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2997,7 +2997,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
 		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
-		strStaParams.u16AssocID = params->aid;
+		strStaParams.aid = params->aid;
 		strStaParams.u8NumRates = params->supported_rates_len;
 		strStaParams.pu8Rates = params->supported_rates;
 
@@ -3005,7 +3005,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 
 		PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n", priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][0], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][1], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][2], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][3], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][4],
 			priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][5]);
-		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.u16AssocID);
+		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.aid);
 		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n", strStaParams.u8NumRates);
 
 		if (params->ht_capa == NULL) {
@@ -3110,7 +3110,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
-		strStaParams.u16AssocID = params->aid;
+		strStaParams.aid = params->aid;
 		strStaParams.u8NumRates = params->supported_rates_len;
 		strStaParams.pu8Rates = params->supported_rates;
 
@@ -3118,7 +3118,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.bssid[0], strStaParams.bssid[1],
 			strStaParams.bssid[2], strStaParams.bssid[3],
 			strStaParams.bssid[4], strStaParams.bssid[5]);
-		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.u16AssocID);
+		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.aid);
 		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n", strStaParams.u8NumRates);
 
 		if (params->ht_capa == NULL) {
-- 
1.9.1

