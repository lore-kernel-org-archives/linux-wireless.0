Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43366 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbbJ1HGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:06:35 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 73/80] staging: wilc1000: rename u16HTExtParams of struct add_sta_param
Date: Wed, 28 Oct 2015 16:07:18 +0900
Message-ID: <1446016045-32154-23-git-send-email-glen.lee@atmel.com> (sfid-20151028_080642_081205_BE65A89D)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u16HTExtParams of struct add_sta_param to ht_ext_params
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  4 ++--
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 ++++++----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 976d432..fa45327 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2330,8 +2330,8 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	       WILC_SUPP_MCS_SET_SIZE);
 	pu8CurrByte += WILC_SUPP_MCS_SET_SIZE;
 
-	*pu8CurrByte++ = pstrStationParam->u16HTExtParams & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->u16HTExtParams >> 8) & 0xFF;
+	*pu8CurrByte++ = pstrStationParam->ht_ext_params & 0xFF;
+	*pu8CurrByte++ = (pstrStationParam->ht_ext_params >> 8) & 0xFF;
 
 	*pu8CurrByte++ = pstrStationParam->u32TxBeamformingCap & 0xFF;
 	*pu8CurrByte++ = (pstrStationParam->u32TxBeamformingCap >> 8) & 0xFF;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 48ef051..6fcbbc6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -296,7 +296,7 @@ struct add_sta_param {
 	u16 ht_capa_info;
 	u8 ht_ampdu_params;
 	u8 ht_supp_mcs_set[16];
-	u16 u16HTExtParams;
+	u16 ht_ext_params;
 	u32 u32TxBeamformingCap;
 	u8 u8ASELCap;
 	u16 u16FlagsMask;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c0dbd39..38ab0e7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3028,7 +3028,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			memcpy(strStaParams.ht_supp_mcs_set,
 			       &params->ht_capa->mcs,
 			       WILC_SUPP_MCS_SET_SIZE);
-			strStaParams.u16HTExtParams = params->ht_capa->extended_ht_cap_info;
+			strStaParams.ht_ext_params = params->ht_capa->extended_ht_cap_info;
 			strStaParams.u32TxBeamformingCap = params->ht_capa->tx_BF_cap_info;
 			strStaParams.u8ASELCap = params->ht_capa->antenna_selection_info;
 		}
@@ -3042,7 +3042,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_capa_info);
 		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n",
 			strStaParams.ht_ampdu_params);
-		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n", strStaParams.u16HTExtParams);
+		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n",
+			strStaParams.ht_ext_params);
 		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n", strStaParams.u32TxBeamformingCap);
 		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n", strStaParams.u8ASELCap);
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
@@ -3147,7 +3148,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			memcpy(strStaParams.ht_supp_mcs_set,
 			       &params->ht_capa->mcs,
 			       WILC_SUPP_MCS_SET_SIZE);
-			strStaParams.u16HTExtParams = params->ht_capa->extended_ht_cap_info;
+			strStaParams.ht_ext_params = params->ht_capa->extended_ht_cap_info;
 			strStaParams.u32TxBeamformingCap = params->ht_capa->tx_BF_cap_info;
 			strStaParams.u8ASELCap = params->ht_capa->antenna_selection_info;
 
@@ -3162,7 +3163,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_capa_info);
 		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n",
 			strStaParams.ht_ampdu_params);
-		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n", strStaParams.u16HTExtParams);
+		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n",
+			strStaParams.ht_ext_params);
 		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n", strStaParams.u32TxBeamformingCap);
 		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n", strStaParams.u8ASELCap);
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
-- 
1.9.1

