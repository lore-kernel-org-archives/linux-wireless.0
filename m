Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27237 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965285AbbJ2DF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:05:57 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 58/64] staging: wilc1000: rename u32TxBeamformingCap of struct add_sta_param
Date: Thu, 29 Oct 2015 12:05:50 +0900
Message-ID: <1446087956-19054-25-git-send-email-glen.lee@atmel.com> (sfid-20151029_040559_549147_111D1D22)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32TxBeamformingCap of struct add_sta_param to ht_tx_bf_cap
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  8 ++++----
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 ++++++----
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index be1fcbd..41ccd80 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2332,10 +2332,10 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	*pu8CurrByte++ = pstrStationParam->ht_ext_params & 0xFF;
 	*pu8CurrByte++ = (pstrStationParam->ht_ext_params >> 8) & 0xFF;
 
-	*pu8CurrByte++ = pstrStationParam->u32TxBeamformingCap & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->u32TxBeamformingCap >> 8) & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->u32TxBeamformingCap >> 16) & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->u32TxBeamformingCap >> 24) & 0xFF;
+	*pu8CurrByte++ = pstrStationParam->ht_tx_bf_cap & 0xFF;
+	*pu8CurrByte++ = (pstrStationParam->ht_tx_bf_cap >> 8) & 0xFF;
+	*pu8CurrByte++ = (pstrStationParam->ht_tx_bf_cap >> 16) & 0xFF;
+	*pu8CurrByte++ = (pstrStationParam->ht_tx_bf_cap >> 24) & 0xFF;
 
 	*pu8CurrByte++ = pstrStationParam->u8ASELCap;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c8e2d3f..3311d2f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -297,7 +297,7 @@ struct add_sta_param {
 	u8 ht_ampdu_params;
 	u8 ht_supp_mcs_set[16];
 	u16 ht_ext_params;
-	u32 u32TxBeamformingCap;
+	u32 ht_tx_bf_cap;
 	u8 u8ASELCap;
 	u16 u16FlagsMask;
 	u16 u16FlagsSet;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e417785..abd90963 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3019,7 +3019,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			       &params->ht_capa->mcs,
 			       WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.ht_ext_params = params->ht_capa->extended_ht_cap_info;
-			strStaParams.u32TxBeamformingCap = params->ht_capa->tx_BF_cap_info;
+			strStaParams.ht_tx_bf_cap = params->ht_capa->tx_BF_cap_info;
 			strStaParams.u8ASELCap = params->ht_capa->antenna_selection_info;
 		}
 
@@ -3034,7 +3034,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_ampdu_params);
 		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n",
 			strStaParams.ht_ext_params);
-		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n", strStaParams.u32TxBeamformingCap);
+		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n",
+			strStaParams.ht_tx_bf_cap);
 		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n", strStaParams.u8ASELCap);
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
@@ -3139,7 +3140,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			       &params->ht_capa->mcs,
 			       WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.ht_ext_params = params->ht_capa->extended_ht_cap_info;
-			strStaParams.u32TxBeamformingCap = params->ht_capa->tx_BF_cap_info;
+			strStaParams.ht_tx_bf_cap = params->ht_capa->tx_BF_cap_info;
 			strStaParams.u8ASELCap = params->ht_capa->antenna_selection_info;
 
 		}
@@ -3155,7 +3156,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_ampdu_params);
 		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n",
 			strStaParams.ht_ext_params);
-		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n", strStaParams.u32TxBeamformingCap);
+		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n",
+			strStaParams.ht_tx_bf_cap);
 		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n", strStaParams.u8ASELCap);
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
-- 
1.9.1

