Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43334 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976AbbJ1HGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:06:24 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 71/80] staging: wilc1000: rename u8AmpduParams of struct add_sta_param
Date: Wed, 28 Oct 2015 16:07:16 +0900
Message-ID: <1446016045-32154-21-git-send-email-glen.lee@atmel.com> (sfid-20151028_080629_806472_408DEAB5)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8AmpduParams of struct add_sta_param to ht_ampdu_params
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  2 +-
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 ++++++----
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2e17db5..6f4dd85 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2325,7 +2325,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	*pu8CurrByte++ = pstrStationParam->ht_capa_info & 0xFF;
 	*pu8CurrByte++ = (pstrStationParam->ht_capa_info >> 8) & 0xFF;
 
-	*pu8CurrByte++ = pstrStationParam->u8AmpduParams;
+	*pu8CurrByte++ = pstrStationParam->ht_ampdu_params;
 	memcpy(pu8CurrByte, pstrStationParam->au8SuppMCsSet, WILC_SUPP_MCS_SET_SIZE);
 	pu8CurrByte += WILC_SUPP_MCS_SET_SIZE;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 09a67ab..d2567af 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -294,7 +294,7 @@ struct add_sta_param {
 	const u8 *rates;
 	bool ht_supported;
 	u16 ht_capa_info;
-	u8 u8AmpduParams;
+	u8 ht_ampdu_params;
 	u8 au8SuppMCsSet[16];
 	u16 u16HTExtParams;
 	u32 u32TxBeamformingCap;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c597659..9fcdf9e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3024,7 +3024,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		} else {
 			strStaParams.ht_supported = true;
 			strStaParams.ht_capa_info = params->ht_capa->cap_info;
-			strStaParams.u8AmpduParams = params->ht_capa->ampdu_params_info;
+			strStaParams.ht_ampdu_params = params->ht_capa->ampdu_params_info;
 			memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.u16HTExtParams = params->ht_capa->extended_ht_cap_info;
 			strStaParams.u32TxBeamformingCap = params->ht_capa->tx_BF_cap_info;
@@ -3038,7 +3038,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_supported);
 		PRINT_D(HOSTAPD_DBG, "Capability Info = %d\n",
 			strStaParams.ht_capa_info);
-		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n", strStaParams.u8AmpduParams);
+		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n",
+			strStaParams.ht_ampdu_params);
 		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n", strStaParams.u16HTExtParams);
 		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n", strStaParams.u32TxBeamformingCap);
 		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n", strStaParams.u8ASELCap);
@@ -3140,7 +3141,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		} else {
 			strStaParams.ht_supported = true;
 			strStaParams.ht_capa_info = params->ht_capa->cap_info;
-			strStaParams.u8AmpduParams = params->ht_capa->ampdu_params_info;
+			strStaParams.ht_ampdu_params = params->ht_capa->ampdu_params_info;
 			memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.u16HTExtParams = params->ht_capa->extended_ht_cap_info;
 			strStaParams.u32TxBeamformingCap = params->ht_capa->tx_BF_cap_info;
@@ -3155,7 +3156,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_supported);
 		PRINT_D(HOSTAPD_DBG, "Capability Info = %d\n",
 			strStaParams.ht_capa_info);
-		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n", strStaParams.u8AmpduParams);
+		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n",
+			strStaParams.ht_ampdu_params);
 		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n", strStaParams.u16HTExtParams);
 		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n", strStaParams.u32TxBeamformingCap);
 		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n", strStaParams.u8ASELCap);
-- 
1.9.1

