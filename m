Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27281 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965285AbbJ2DGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:06:14 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 61/64] staging: wilc1000: rename u16FlagsSet of struct add_sta_param
Date: Thu, 29 Oct 2015 12:05:53 +0900
Message-ID: <1446087956-19054-28-git-send-email-glen.lee@atmel.com> (sfid-20151029_040618_058008_48CA3D64)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u16FlagsSet of struct add_sta_param to flags_set
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  4 ++--
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 ++++++----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 258dabd..34b3455 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2342,8 +2342,8 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	*pu8CurrByte++ = pstrStationParam->flags_mask & 0xFF;
 	*pu8CurrByte++ = (pstrStationParam->flags_mask >> 8) & 0xFF;
 
-	*pu8CurrByte++ = pstrStationParam->u16FlagsSet & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->u16FlagsSet >> 8) & 0xFF;
+	*pu8CurrByte++ = pstrStationParam->flags_set & 0xFF;
+	*pu8CurrByte++ = (pstrStationParam->flags_set >> 8) & 0xFF;
 
 	return pu8CurrByte - pu8Buffer;
 }
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 1422b90..72c4797 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -300,7 +300,7 @@ struct add_sta_param {
 	u32 ht_tx_bf_cap;
 	u8 ht_ante_sel;
 	u16 flags_mask;
-	u16 u16FlagsSet;
+	u16 flags_set;
 };
 
 s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0ae47c5..4de27ef 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3024,7 +3024,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		strStaParams.flags_mask = params->sta_flags_mask;
-		strStaParams.u16FlagsSet = params->sta_flags_set;
+		strStaParams.flags_set = params->sta_flags_set;
 
 		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
 			strStaParams.ht_supported);
@@ -3040,7 +3040,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_ante_sel);
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n",
 			strStaParams.flags_mask);
-		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
+		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n",
+			strStaParams.flags_set);
 
 		s32Error = host_int_add_station(priv->hWILCWFIDrv, &strStaParams);
 		if (s32Error)
@@ -3147,7 +3148,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		strStaParams.flags_mask = params->sta_flags_mask;
-		strStaParams.u16FlagsSet = params->sta_flags_set;
+		strStaParams.flags_set = params->sta_flags_set;
 
 		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
 			strStaParams.ht_supported);
@@ -3163,7 +3164,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_ante_sel);
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n",
 			strStaParams.flags_mask);
-		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
+		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n",
+			strStaParams.flags_set);
 
 		s32Error = host_int_edit_station(priv->hWILCWFIDrv, &strStaParams);
 		if (s32Error)
-- 
1.9.1

