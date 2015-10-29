Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27161 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965268AbbJ2DF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:05:27 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 53/64] staging: wilc1000: rename bIsHTSupported of struct add_sta_param
Date: Thu, 29 Oct 2015 12:05:45 +0900
Message-ID: <1446087956-19054-20-git-send-email-glen.lee@atmel.com> (sfid-20151029_041656_966451_4D2685C9)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames bIsHTSupported of struct add_sta_param to ht_supported
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  2 +-
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 ++++++++------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 910462a..fbfaf12 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2320,7 +2320,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 		       pstrStationParam->rates_len);
 	pu8CurrByte += pstrStationParam->rates_len;
 
-	*pu8CurrByte++ = pstrStationParam->bIsHTSupported;
+	*pu8CurrByte++ = pstrStationParam->ht_supported;
 	*pu8CurrByte++ = pstrStationParam->u16HTCapInfo & 0xFF;
 	*pu8CurrByte++ = (pstrStationParam->u16HTCapInfo >> 8) & 0xFF;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5fba44f..2d9d808 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -292,7 +292,7 @@ struct add_sta_param {
 	u16 aid;
 	u8 rates_len;
 	const u8 *rates;
-	bool bIsHTSupported;
+	bool ht_supported;
 	u16 u16HTCapInfo;
 	u8 u8AmpduParams;
 	u8 au8SuppMCsSet[16];
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 019364a..d5b5158 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3010,9 +3010,9 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.rates_len);
 
 		if (params->ht_capa == NULL) {
-			strStaParams.bIsHTSupported = false;
+			strStaParams.ht_supported = false;
 		} else {
-			strStaParams.bIsHTSupported = true;
+			strStaParams.ht_supported = true;
 			strStaParams.u16HTCapInfo = params->ht_capa->cap_info;
 			strStaParams.u8AmpduParams = params->ht_capa->ampdu_params_info;
 			memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
@@ -3024,7 +3024,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		strStaParams.u16FlagsMask = params->sta_flags_mask;
 		strStaParams.u16FlagsSet = params->sta_flags_set;
 
-		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n", strStaParams.bIsHTSupported);
+		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
+			strStaParams.ht_supported);
 		PRINT_D(HOSTAPD_DBG, "Capability Info = %d\n", strStaParams.u16HTCapInfo);
 		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n", strStaParams.u8AmpduParams);
 		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n", strStaParams.u16HTExtParams);
@@ -3124,9 +3125,9 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.rates_len);
 
 		if (params->ht_capa == NULL) {
-			strStaParams.bIsHTSupported = false;
+			strStaParams.ht_supported = false;
 		} else {
-			strStaParams.bIsHTSupported = true;
+			strStaParams.ht_supported = true;
 			strStaParams.u16HTCapInfo = params->ht_capa->cap_info;
 			strStaParams.u8AmpduParams = params->ht_capa->ampdu_params_info;
 			memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
@@ -3139,7 +3140,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		strStaParams.u16FlagsMask = params->sta_flags_mask;
 		strStaParams.u16FlagsSet = params->sta_flags_set;
 
-		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n", strStaParams.bIsHTSupported);
+		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
+			strStaParams.ht_supported);
 		PRINT_D(HOSTAPD_DBG, "Capability Info = %d\n", strStaParams.u16HTCapInfo);
 		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n", strStaParams.u8AmpduParams);
 		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n", strStaParams.u16HTExtParams);
-- 
1.9.1

