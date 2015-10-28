Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43413 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794AbbJ1HGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:06:53 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 76/80] staging: wilc1000: rename u16FlagsMask of struct add_sta_param
Date: Wed, 28 Oct 2015 16:07:21 +0900
Message-ID: <1446016045-32154-26-git-send-email-glen.lee@atmel.com> (sfid-20151028_081700_704320_CACF8508)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u16FlagsMask of struct add_sta_param to flags_mask
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  4 ++--
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 ++++++----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ebf0be4..01d84c0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2340,8 +2340,8 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 
 	*pu8CurrByte++ = pstrStationParam->ht_ante_sel;
 
-	*pu8CurrByte++ = pstrStationParam->u16FlagsMask & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->u16FlagsMask >> 8) & 0xFF;
+	*pu8CurrByte++ = pstrStationParam->flags_mask & 0xFF;
+	*pu8CurrByte++ = (pstrStationParam->flags_mask >> 8) & 0xFF;
 
 	*pu8CurrByte++ = pstrStationParam->u16FlagsSet & 0xFF;
 	*pu8CurrByte++ = (pstrStationParam->u16FlagsSet >> 8) & 0xFF;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 47eb5a0..ca8eb10 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -299,7 +299,7 @@ struct add_sta_param {
 	u16 ht_ext_params;
 	u32 ht_tx_bf_cap;
 	u8 ht_ante_sel;
-	u16 u16FlagsMask;
+	u16 flags_mask;
 	u16 u16FlagsSet;
 };
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b6d2246..1cb779d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3033,7 +3033,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_ante_sel = params->ht_capa->antenna_selection_info;
 		}
 
-		strStaParams.u16FlagsMask = params->sta_flags_mask;
+		strStaParams.flags_mask = params->sta_flags_mask;
 		strStaParams.u16FlagsSet = params->sta_flags_set;
 
 		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
@@ -3048,7 +3048,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_tx_bf_cap);
 		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n",
 			strStaParams.ht_ante_sel);
-		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
+		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n",
+			strStaParams.flags_mask);
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
 
 		s32Error = host_int_add_station(priv->hWILCWFIDrv, &strStaParams);
@@ -3155,7 +3156,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_ante_sel = params->ht_capa->antenna_selection_info;
 		}
 
-		strStaParams.u16FlagsMask = params->sta_flags_mask;
+		strStaParams.flags_mask = params->sta_flags_mask;
 		strStaParams.u16FlagsSet = params->sta_flags_set;
 
 		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
@@ -3170,7 +3171,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_tx_bf_cap);
 		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n",
 			strStaParams.ht_ante_sel);
-		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
+		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n",
+			strStaParams.flags_mask);
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
 
 		s32Error = host_int_edit_station(priv->hWILCWFIDrv, &strStaParams);
-- 
1.9.1

