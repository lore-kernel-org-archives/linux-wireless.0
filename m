Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43264 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841AbbJ1HF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:05:59 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 67/80] staging: wilc1000: rename u8NumRates of struct add_sta_param
Date: Wed, 28 Oct 2015 16:07:12 +0900
Message-ID: <1446016045-32154-17-git-send-email-glen.lee@atmel.com> (sfid-20151028_080605_933532_E2C24313)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8NumRates of struct add_sta_param to rates_len
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 27 +++++++++++++----------
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++----
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f1d6175..af395a9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2315,10 +2315,11 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	*pu8CurrByte++ = pstrStationParam->aid & 0xFF;
 	*pu8CurrByte++ = (pstrStationParam->aid >> 8) & 0xFF;
 
-	*pu8CurrByte++ = pstrStationParam->u8NumRates;
-	if (pstrStationParam->u8NumRates > 0)
-		memcpy(pu8CurrByte, pstrStationParam->pu8Rates, pstrStationParam->u8NumRates);
-	pu8CurrByte += pstrStationParam->u8NumRates;
+	*pu8CurrByte++ = pstrStationParam->rates_len;
+	if (pstrStationParam->rates_len > 0)
+		memcpy(pu8CurrByte, pstrStationParam->pu8Rates,
+		       pstrStationParam->rates_len);
+	pu8CurrByte += pstrStationParam->rates_len;
 
 	*pu8CurrByte++ = pstrStationParam->bIsHTSupported;
 	*pu8CurrByte++ = pstrStationParam->u16HTCapInfo & 0xFF;
@@ -2357,7 +2358,7 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	wid.id = (u16)WID_ADD_STA;
 	wid.type = WID_BIN;
-	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
+	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->rates_len;
 
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
@@ -2458,7 +2459,7 @@ static void Handle_EditStation(struct host_if_drv *hif_drv,
 
 	wid.id = (u16)WID_EDIT_STA;
 	wid.type = WID_BIN;
-	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
+	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->rates_len;
 
 	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
@@ -4548,13 +4549,14 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 	msg.drv = hif_drv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
-	if (pstrAddStationMsg->u8NumRates > 0) {
-		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
+	if (pstrAddStationMsg->rates_len > 0) {
+		u8 *rates = kmalloc(pstrAddStationMsg->rates_len, GFP_KERNEL);
 
 		if (!rates)
 			return -ENOMEM;
 
-		memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
+		memcpy(rates, pstrStaParams->pu8Rates,
+		       pstrAddStationMsg->rates_len);
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
@@ -4664,13 +4666,14 @@ s32 host_int_edit_station(struct host_if_drv *hif_drv,
 	msg.drv = hif_drv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
-	if (pstrAddStationMsg->u8NumRates > 0) {
-		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
+	if (pstrAddStationMsg->rates_len > 0) {
+		u8 *rates = kmalloc(pstrAddStationMsg->rates_len, GFP_KERNEL);
 
 		if (!rates)
 			return -ENOMEM;
 
-		memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
+		memcpy(rates, pstrStaParams->pu8Rates,
+		       pstrAddStationMsg->rates_len);
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 124532a..7811bc0 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -290,7 +290,7 @@ struct host_if_drv {
 struct add_sta_param {
 	u8 bssid[ETH_ALEN];
 	u16 aid;
-	u8 u8NumRates;
+	u8 rates_len;
 	const u8 *pu8Rates;
 	bool bIsHTSupported;
 	u16 u16HTCapInfo;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b44b34d..2fba4dd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3008,7 +3008,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
 		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
 		strStaParams.aid = params->aid;
-		strStaParams.u8NumRates = params->supported_rates_len;
+		strStaParams.rates_len = params->supported_rates_len;
 		strStaParams.pu8Rates = params->supported_rates;
 
 		PRINT_D(CFG80211_DBG, "Adding station parameters %d\n", params->aid);
@@ -3016,7 +3016,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n", priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][0], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][1], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][2], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][3], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][4],
 			priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][5]);
 		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.aid);
-		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n", strStaParams.u8NumRates);
+		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n",
+			strStaParams.rates_len);
 
 		if (params->ht_capa == NULL) {
 			strStaParams.bIsHTSupported = false;
@@ -3121,7 +3122,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
 		strStaParams.aid = params->aid;
-		strStaParams.u8NumRates = params->supported_rates_len;
+		strStaParams.rates_len = params->supported_rates_len;
 		strStaParams.pu8Rates = params->supported_rates;
 
 		PRINT_D(HOSTAPD_DBG, "BSSID = %x%x%x%x%x%x\n",
@@ -3129,7 +3130,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.bssid[2], strStaParams.bssid[3],
 			strStaParams.bssid[4], strStaParams.bssid[5]);
 		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.aid);
-		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n", strStaParams.u8NumRates);
+		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n",
+			strStaParams.rates_len);
 
 		if (params->ht_capa == NULL) {
 			strStaParams.bIsHTSupported = false;
-- 
1.9.1

