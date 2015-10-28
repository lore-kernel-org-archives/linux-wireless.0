Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43322 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbbJ1HGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:06:18 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 70/80] staging: wilc1000: rename u16HTCapInfo of struct add_sta_param
Date: Wed, 28 Oct 2015 16:07:15 +0900
Message-ID: <1446016045-32154-20-git-send-email-glen.lee@atmel.com> (sfid-20151028_080624_215648_9DD87828)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u16HTCapInfo of struct add_sta_param to ht_capa_info
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  4 ++--
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 ++++++----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b0c18ef..2e17db5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2322,8 +2322,8 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	pu8CurrByte += pstrStationParam->rates_len;
 
 	*pu8CurrByte++ = pstrStationParam->ht_supported;
-	*pu8CurrByte++ = pstrStationParam->u16HTCapInfo & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->u16HTCapInfo >> 8) & 0xFF;
+	*pu8CurrByte++ = pstrStationParam->ht_capa_info & 0xFF;
+	*pu8CurrByte++ = (pstrStationParam->ht_capa_info >> 8) & 0xFF;
 
 	*pu8CurrByte++ = pstrStationParam->u8AmpduParams;
 	memcpy(pu8CurrByte, pstrStationParam->au8SuppMCsSet, WILC_SUPP_MCS_SET_SIZE);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8a4765d..09a67ab 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -293,7 +293,7 @@ struct add_sta_param {
 	u8 rates_len;
 	const u8 *rates;
 	bool ht_supported;
-	u16 u16HTCapInfo;
+	u16 ht_capa_info;
 	u8 u8AmpduParams;
 	u8 au8SuppMCsSet[16];
 	u16 u16HTExtParams;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index eee187d..c597659 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3023,7 +3023,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_supported = false;
 		} else {
 			strStaParams.ht_supported = true;
-			strStaParams.u16HTCapInfo = params->ht_capa->cap_info;
+			strStaParams.ht_capa_info = params->ht_capa->cap_info;
 			strStaParams.u8AmpduParams = params->ht_capa->ampdu_params_info;
 			memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.u16HTExtParams = params->ht_capa->extended_ht_cap_info;
@@ -3036,7 +3036,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 
 		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
 			strStaParams.ht_supported);
-		PRINT_D(HOSTAPD_DBG, "Capability Info = %d\n", strStaParams.u16HTCapInfo);
+		PRINT_D(HOSTAPD_DBG, "Capability Info = %d\n",
+			strStaParams.ht_capa_info);
 		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n", strStaParams.u8AmpduParams);
 		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n", strStaParams.u16HTExtParams);
 		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n", strStaParams.u32TxBeamformingCap);
@@ -3138,7 +3139,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_supported = false;
 		} else {
 			strStaParams.ht_supported = true;
-			strStaParams.u16HTCapInfo = params->ht_capa->cap_info;
+			strStaParams.ht_capa_info = params->ht_capa->cap_info;
 			strStaParams.u8AmpduParams = params->ht_capa->ampdu_params_info;
 			memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.u16HTExtParams = params->ht_capa->extended_ht_cap_info;
@@ -3152,7 +3153,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 
 		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
 			strStaParams.ht_supported);
-		PRINT_D(HOSTAPD_DBG, "Capability Info = %d\n", strStaParams.u16HTCapInfo);
+		PRINT_D(HOSTAPD_DBG, "Capability Info = %d\n",
+			strStaParams.ht_capa_info);
 		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n", strStaParams.u8AmpduParams);
 		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n", strStaParams.u16HTExtParams);
 		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n", strStaParams.u32TxBeamformingCap);
-- 
1.9.1

