Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43427 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794AbbJ1HG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:06:59 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 77/80] staging: wilc1000: rename u16FlagsSet of struct add_sta_param
Date: Wed, 28 Oct 2015 16:07:22 +0900
Message-ID: <1446016045-32154-27-git-send-email-glen.lee@atmel.com> (sfid-20151028_081702_584854_F1AB66A4)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
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
index 01d84c0..6160d03 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2343,8 +2343,8 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	*pu8CurrByte++ = pstrStationParam->flags_mask & 0xFF;
 	*pu8CurrByte++ = (pstrStationParam->flags_mask >> 8) & 0xFF;
 
-	*pu8CurrByte++ = pstrStationParam->u16FlagsSet & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->u16FlagsSet >> 8) & 0xFF;
+	*pu8CurrByte++ = pstrStationParam->flags_set & 0xFF;
+	*pu8CurrByte++ = (pstrStationParam->flags_set >> 8) & 0xFF;
 
 	return pu8CurrByte - pu8Buffer;
 }
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index ca8eb10..f66f0cc 100644
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
index 1cb779d..15e0685 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3034,7 +3034,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		strStaParams.flags_mask = params->sta_flags_mask;
-		strStaParams.u16FlagsSet = params->sta_flags_set;
+		strStaParams.flags_set = params->sta_flags_set;
 
 		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
 			strStaParams.ht_supported);
@@ -3050,7 +3050,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_ante_sel);
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n",
 			strStaParams.flags_mask);
-		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
+		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n",
+			strStaParams.flags_set);
 
 		s32Error = host_int_add_station(priv->hWILCWFIDrv, &strStaParams);
 		if (s32Error)
@@ -3157,7 +3158,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		strStaParams.flags_mask = params->sta_flags_mask;
-		strStaParams.u16FlagsSet = params->sta_flags_set;
+		strStaParams.flags_set = params->sta_flags_set;
 
 		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
 			strStaParams.ht_supported);
@@ -3173,7 +3174,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
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

