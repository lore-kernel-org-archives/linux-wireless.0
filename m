Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43278 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841AbbJ1HGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:06:05 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 68/80] staging: wilc1000: rename pu8Rates of struct add_sta_param
Date: Wed, 28 Oct 2015 16:07:13 +0900
Message-ID: <1446016045-32154-18-git-send-email-glen.lee@atmel.com> (sfid-20151028_080609_906040_5C40171A)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8Rates of struct add_sta_param to rates
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 14 +++++++-------
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index af395a9..a62c17b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2317,7 +2317,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 
 	*pu8CurrByte++ = pstrStationParam->rates_len;
 	if (pstrStationParam->rates_len > 0)
-		memcpy(pu8CurrByte, pstrStationParam->pu8Rates,
+		memcpy(pu8CurrByte, pstrStationParam->rates,
 		       pstrStationParam->rates_len);
 	pu8CurrByte += pstrStationParam->rates_len;
 
@@ -2373,7 +2373,7 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
-	kfree(pstrStationParam->pu8Rates);
+	kfree(pstrStationParam->rates);
 	kfree(wid.val);
 }
 
@@ -2475,7 +2475,7 @@ static void Handle_EditStation(struct host_if_drv *hif_drv,
 		PRINT_ER("Failed to send edit station config packet\n");
 
 ERRORHANDLER:
-	kfree(pstrStationParam->pu8Rates);
+	kfree(pstrStationParam->rates);
 	kfree(wid.val);
 }
 
@@ -4555,9 +4555,9 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 		if (!rates)
 			return -ENOMEM;
 
-		memcpy(rates, pstrStaParams->pu8Rates,
+		memcpy(rates, pstrStaParams->rates,
 		       pstrAddStationMsg->rates_len);
-		pstrAddStationMsg->pu8Rates = rates;
+		pstrAddStationMsg->rates = rates;
 	}
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4672,9 +4672,9 @@ s32 host_int_edit_station(struct host_if_drv *hif_drv,
 		if (!rates)
 			return -ENOMEM;
 
-		memcpy(rates, pstrStaParams->pu8Rates,
+		memcpy(rates, pstrStaParams->rates,
 		       pstrAddStationMsg->rates_len);
-		pstrAddStationMsg->pu8Rates = rates;
+		pstrAddStationMsg->rates = rates;
 	}
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7811bc0..343726f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -291,7 +291,7 @@ struct add_sta_param {
 	u8 bssid[ETH_ALEN];
 	u16 aid;
 	u8 rates_len;
-	const u8 *pu8Rates;
+	const u8 *rates;
 	bool bIsHTSupported;
 	u16 u16HTCapInfo;
 	u8 u8AmpduParams;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2fba4dd..234fbe7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3009,7 +3009,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
 		strStaParams.aid = params->aid;
 		strStaParams.rates_len = params->supported_rates_len;
-		strStaParams.pu8Rates = params->supported_rates;
+		strStaParams.rates = params->supported_rates;
 
 		PRINT_D(CFG80211_DBG, "Adding station parameters %d\n", params->aid);
 
@@ -3123,7 +3123,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
 		strStaParams.aid = params->aid;
 		strStaParams.rates_len = params->supported_rates_len;
-		strStaParams.pu8Rates = params->supported_rates;
+		strStaParams.rates = params->supported_rates;
 
 		PRINT_D(HOSTAPD_DBG, "BSSID = %x%x%x%x%x%x\n",
 			strStaParams.bssid[0], strStaParams.bssid[1],
-- 
1.9.1

