Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27129 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965268AbbJ2DFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:05:16 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 51/64] staging: wilc1000: rename u8NumRates of struct add_sta_param
Date: Thu, 29 Oct 2015 12:05:43 +0900
Message-ID: <1446087956-19054-18-git-send-email-glen.lee@atmel.com> (sfid-20151029_041655_715117_EED4C29A)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
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
index 512000e..9b76acd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2314,10 +2314,11 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
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
@@ -2356,7 +2357,7 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	wid.id = (u16)WID_ADD_STA;
 	wid.type = WID_BIN;
-	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
+	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->rates_len;
 
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
@@ -2457,7 +2458,7 @@ static void Handle_EditStation(struct host_if_drv *hif_drv,
 
 	wid.id = (u16)WID_EDIT_STA;
 	wid.type = WID_BIN;
-	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
+	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->rates_len;
 
 	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
@@ -4545,13 +4546,14 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
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
 
@@ -4661,13 +4663,14 @@ s32 host_int_edit_station(struct host_if_drv *hif_drv,
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
index 7d8a166..b13c76e 100644
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
index 00fa411..715499a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2998,7 +2998,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
 		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
 		strStaParams.aid = params->aid;
-		strStaParams.u8NumRates = params->supported_rates_len;
+		strStaParams.rates_len = params->supported_rates_len;
 		strStaParams.pu8Rates = params->supported_rates;
 
 		PRINT_D(CFG80211_DBG, "Adding station parameters %d\n", params->aid);
@@ -3006,7 +3006,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n", priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][0], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][1], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][2], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][3], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][4],
 			priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][5]);
 		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.aid);
-		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n", strStaParams.u8NumRates);
+		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n",
+			strStaParams.rates_len);
 
 		if (params->ht_capa == NULL) {
 			strStaParams.bIsHTSupported = false;
@@ -3111,7 +3112,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
 		strStaParams.aid = params->aid;
-		strStaParams.u8NumRates = params->supported_rates_len;
+		strStaParams.rates_len = params->supported_rates_len;
 		strStaParams.pu8Rates = params->supported_rates;
 
 		PRINT_D(HOSTAPD_DBG, "BSSID = %x%x%x%x%x%x\n",
@@ -3119,7 +3120,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
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

