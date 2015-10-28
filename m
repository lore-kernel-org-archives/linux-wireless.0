Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43237 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841AbbJ1HFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:05:53 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 66/80] staging: wilc1000: rename u16AssocID of struct add_sta_param
Date: Wed, 28 Oct 2015 16:07:11 +0900
Message-ID: <1446016045-32154-16-git-send-email-glen.lee@atmel.com> (sfid-20151028_080602_224656_DEE87F59)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
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
index 16aa2c9..f1d6175 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2312,8 +2312,8 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	memcpy(pu8CurrByte, pstrStationParam->bssid, ETH_ALEN);
 	pu8CurrByte +=  ETH_ALEN;
 
-	*pu8CurrByte++ = pstrStationParam->u16AssocID & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->u16AssocID >> 8) & 0xFF;
+	*pu8CurrByte++ = pstrStationParam->aid & 0xFF;
+	*pu8CurrByte++ = (pstrStationParam->aid >> 8) & 0xFF;
 
 	*pu8CurrByte++ = pstrStationParam->u8NumRates;
 	if (pstrStationParam->u8NumRates > 0)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c102a5b..124532a 100644
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
index 608bfe9..b44b34d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3007,7 +3007,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
 		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
-		strStaParams.u16AssocID = params->aid;
+		strStaParams.aid = params->aid;
 		strStaParams.u8NumRates = params->supported_rates_len;
 		strStaParams.pu8Rates = params->supported_rates;
 
@@ -3015,7 +3015,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 
 		PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n", priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][0], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][1], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][2], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][3], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][4],
 			priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][5]);
-		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.u16AssocID);
+		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.aid);
 		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n", strStaParams.u8NumRates);
 
 		if (params->ht_capa == NULL) {
@@ -3120,7 +3120,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
-		strStaParams.u16AssocID = params->aid;
+		strStaParams.aid = params->aid;
 		strStaParams.u8NumRates = params->supported_rates_len;
 		strStaParams.pu8Rates = params->supported_rates;
 
@@ -3128,7 +3128,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.bssid[0], strStaParams.bssid[1],
 			strStaParams.bssid[2], strStaParams.bssid[3],
 			strStaParams.bssid[4], strStaParams.bssid[5]);
-		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.u16AssocID);
+		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.aid);
 		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n", strStaParams.u8NumRates);
 
 		if (params->ht_capa == NULL) {
-- 
1.9.1

