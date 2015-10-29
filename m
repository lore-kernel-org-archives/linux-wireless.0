Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27253 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965285AbbJ2DGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:06:03 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 59/64] staging: wilc1000: rename u8ASELCap of struct add_sta_param
Date: Thu, 29 Oct 2015 12:05:51 +0900
Message-ID: <1446087956-19054-26-git-send-email-glen.lee@atmel.com> (sfid-20151029_040607_479274_39663639)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8ASELCap of struct add_sta_param to ht_ante_sel
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  2 +-
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 11 ++++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 41ccd80..5a2e874 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2337,7 +2337,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	*pu8CurrByte++ = (pstrStationParam->ht_tx_bf_cap >> 16) & 0xFF;
 	*pu8CurrByte++ = (pstrStationParam->ht_tx_bf_cap >> 24) & 0xFF;
 
-	*pu8CurrByte++ = pstrStationParam->u8ASELCap;
+	*pu8CurrByte++ = pstrStationParam->ht_ante_sel;
 
 	*pu8CurrByte++ = pstrStationParam->u16FlagsMask & 0xFF;
 	*pu8CurrByte++ = (pstrStationParam->u16FlagsMask >> 8) & 0xFF;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 3311d2f..5ad0bfa 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -298,7 +298,7 @@ struct add_sta_param {
 	u8 ht_supp_mcs_set[16];
 	u16 ht_ext_params;
 	u32 ht_tx_bf_cap;
-	u8 u8ASELCap;
+	u8 ht_ante_sel;
 	u16 u16FlagsMask;
 	u16 u16FlagsSet;
 };
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index abd90963..a2c0878 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3020,7 +3020,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			       WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.ht_ext_params = params->ht_capa->extended_ht_cap_info;
 			strStaParams.ht_tx_bf_cap = params->ht_capa->tx_BF_cap_info;
-			strStaParams.u8ASELCap = params->ht_capa->antenna_selection_info;
+			strStaParams.ht_ante_sel = params->ht_capa->antenna_selection_info;
 		}
 
 		strStaParams.u16FlagsMask = params->sta_flags_mask;
@@ -3036,7 +3036,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_ext_params);
 		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n",
 			strStaParams.ht_tx_bf_cap);
-		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n", strStaParams.u8ASELCap);
+		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n",
+			strStaParams.ht_ante_sel);
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
 
@@ -3141,8 +3142,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			       WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.ht_ext_params = params->ht_capa->extended_ht_cap_info;
 			strStaParams.ht_tx_bf_cap = params->ht_capa->tx_BF_cap_info;
-			strStaParams.u8ASELCap = params->ht_capa->antenna_selection_info;
-
+			strStaParams.ht_ante_sel = params->ht_capa->antenna_selection_info;
 		}
 
 		strStaParams.u16FlagsMask = params->sta_flags_mask;
@@ -3158,7 +3158,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_ext_params);
 		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n",
 			strStaParams.ht_tx_bf_cap);
-		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n", strStaParams.u8ASELCap);
+		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n",
+			strStaParams.ht_ante_sel);
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
 
-- 
1.9.1

