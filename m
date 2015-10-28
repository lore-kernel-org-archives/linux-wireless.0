Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43347 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbbJ1HG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:06:29 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 72/80] staging: wilc1000: rename au8SuppMCsSet of struct add_sta_param
Date: Wed, 28 Oct 2015 16:07:17 +0900
Message-ID: <1446016045-32154-22-git-send-email-glen.lee@atmel.com> (sfid-20151028_080634_517047_2AAFABBF)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames au8SuppMCsSet of struct add_sta_param to ht_supp_mcs_set
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 3 ++-
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6f4dd85..976d432 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2326,7 +2326,8 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	*pu8CurrByte++ = (pstrStationParam->ht_capa_info >> 8) & 0xFF;
 
 	*pu8CurrByte++ = pstrStationParam->ht_ampdu_params;
-	memcpy(pu8CurrByte, pstrStationParam->au8SuppMCsSet, WILC_SUPP_MCS_SET_SIZE);
+	memcpy(pu8CurrByte, pstrStationParam->ht_supp_mcs_set,
+	       WILC_SUPP_MCS_SET_SIZE);
 	pu8CurrByte += WILC_SUPP_MCS_SET_SIZE;
 
 	*pu8CurrByte++ = pstrStationParam->u16HTExtParams & 0xFF;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d2567af..48ef051 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -295,7 +295,7 @@ struct add_sta_param {
 	bool ht_supported;
 	u16 ht_capa_info;
 	u8 ht_ampdu_params;
-	u8 au8SuppMCsSet[16];
+	u8 ht_supp_mcs_set[16];
 	u16 u16HTExtParams;
 	u32 u32TxBeamformingCap;
 	u8 u8ASELCap;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9fcdf9e..c0dbd39 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3025,7 +3025,9 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_supported = true;
 			strStaParams.ht_capa_info = params->ht_capa->cap_info;
 			strStaParams.ht_ampdu_params = params->ht_capa->ampdu_params_info;
-			memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
+			memcpy(strStaParams.ht_supp_mcs_set,
+			       &params->ht_capa->mcs,
+			       WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.u16HTExtParams = params->ht_capa->extended_ht_cap_info;
 			strStaParams.u32TxBeamformingCap = params->ht_capa->tx_BF_cap_info;
 			strStaParams.u8ASELCap = params->ht_capa->antenna_selection_info;
@@ -3142,7 +3144,9 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_supported = true;
 			strStaParams.ht_capa_info = params->ht_capa->cap_info;
 			strStaParams.ht_ampdu_params = params->ht_capa->ampdu_params_info;
-			memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
+			memcpy(strStaParams.ht_supp_mcs_set,
+			       &params->ht_capa->mcs,
+			       WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.u16HTExtParams = params->ht_capa->extended_ht_cap_info;
 			strStaParams.u32TxBeamformingCap = params->ht_capa->tx_BF_cap_info;
 			strStaParams.u8ASELCap = params->ht_capa->antenna_selection_info;
-- 
1.9.1

