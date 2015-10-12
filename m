Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13456 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbbJLIAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 04:00:12 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 33/41] staging: wilc1000: rename u32SetCfgFlag of struct cfg_param_val
Date: Mon, 12 Oct 2015 16:56:07 +0900
Message-ID: <1444636575-2486-33-git-send-email-tony.cho@atmel.com> (sfid-20151012_101654_236793_EA9313AC)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32SetCfgFlag of struct cfg_param_val to flag to
avoid CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 36 +++++++++++------------
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++----
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4bf10eb..d905e17 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -847,7 +847,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting CFG params\n");
 
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & BSS_TYPE) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & BSS_TYPE) {
 		/*----------------------------------------------------------*/
 		/*Input Value:	INFRASTRUCTURE = 1,							*/
 		/*				INDEPENDENT= 2,								*/
@@ -867,7 +867,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & AUTH_TYPE) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & AUTH_TYPE) {
 		/*------------------------------------------------------*/
 		/*Input Values: OPEN_SYSTEM     = 0,					*/
 		/*				SHARED_KEY      = 1,					*/
@@ -887,7 +887,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & AUTHEN_TIMEOUT) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & AUTHEN_TIMEOUT) {
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.auth_timeout > 0 && strHostIFCfgParamAttr->cfg_attr_info.auth_timeout < 65536) {
 			strWIDList[u8WidCnt].id = WID_AUTH_TIMEOUT;
@@ -902,7 +902,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & POWER_MANAGEMENT) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & POWER_MANAGEMENT) {
 		/*-----------------------------------------------------------*/
 		/*Input Values:	NO_POWERSAVE     = 0,						*/
 		/*				MIN_FAST_PS      = 1,						*/
@@ -923,7 +923,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & RETRY_SHORT) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & RETRY_SHORT) {
 		/* range from 1 to 256 */
 		if ((strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit > 0) && (strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit < 256))	{
 			strWIDList[u8WidCnt].id = WID_SHORT_RETRY_LIMIT;
@@ -938,7 +938,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & RETRY_LONG) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & RETRY_LONG) {
 		/* range from 1 to 256 */
 		if ((strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit > 0) && (strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit < 256)) {
 			strWIDList[u8WidCnt].id = WID_LONG_RETRY_LIMIT;
@@ -954,7 +954,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & FRAG_THRESHOLD) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & FRAG_THRESHOLD) {
 
 		if (strHostIFCfgParamAttr->cfg_attr_info.frag_threshold > 255 && strHostIFCfgParamAttr->cfg_attr_info.frag_threshold < 7937) {
 			strWIDList[u8WidCnt].id = WID_FRAG_THRESHOLD;
@@ -969,7 +969,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & RTS_THRESHOLD) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & RTS_THRESHOLD) {
 		/* range 256 to 65535 */
 		if (strHostIFCfgParamAttr->cfg_attr_info.rts_threshold > 255 && strHostIFCfgParamAttr->cfg_attr_info.rts_threshold < 65536)	{
 			strWIDList[u8WidCnt].id = WID_RTS_THRESHOLD;
@@ -984,7 +984,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & PREAMBLE) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & PREAMBLE) {
 		/*-----------------------------------------------------*/
 		/*Input Values: Short= 0,								*/
 		/*				Long= 1,                                */
@@ -1003,7 +1003,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & SHORT_SLOT_ALLOWED) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & SHORT_SLOT_ALLOWED) {
 		if (strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed < 2) {
 			strWIDList[u8WidCnt].id = WID_SHORT_SLOT_ALLOWED;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed;
@@ -1017,7 +1017,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & TXOP_PROT_DISABLE) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & TXOP_PROT_DISABLE) {
 		/*Description:	used to Disable RTS-CTS protection for TXOP burst*/
 		/*transmission when the acknowledgement policy is No-Ack or Block-Ack	*/
 		/* this information is useful for external supplicant                                   */
@@ -1035,7 +1035,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & BEACON_INTERVAL) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & BEACON_INTERVAL) {
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.beacon_interval > 0 && strHostIFCfgParamAttr->cfg_attr_info.beacon_interval < 65536) {
 			strWIDList[u8WidCnt].id = WID_BEACON_INTERVAL;
@@ -1050,7 +1050,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & DTIM_PERIOD) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & DTIM_PERIOD) {
 		/* range is 1 to 255. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.dtim_period > 0 && strHostIFCfgParamAttr->cfg_attr_info.dtim_period < 256) {
 			strWIDList[u8WidCnt].id = WID_DTIM_PERIOD;
@@ -1065,7 +1065,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & SITE_SURVEY) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & SITE_SURVEY) {
 		/*----------------------------------------------------------------------*/
 		/*Input Values: SITE_SURVEY_1CH    = 0, i.e.: currently set channel		*/
 		/*				SITE_SURVEY_ALL_CH = 1,									*/
@@ -1084,7 +1084,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & SITE_SURVEY_SCAN_TIME) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & SITE_SURVEY_SCAN_TIME) {
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY_SCAN_TIME;
@@ -1099,7 +1099,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & ACTIVE_SCANTIME) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & ACTIVE_SCANTIME) {
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.active_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.active_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_ACTIVE_SCAN_TIME;
@@ -1114,7 +1114,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & PASSIVE_SCANTIME) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & PASSIVE_SCANTIME) {
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_PASSIVE_SCAN_TIME;
@@ -1129,7 +1129,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & CURRENT_TX_RATE) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.flag & CURRENT_TX_RATE) {
 		enum CURRENT_TXRATE curr_tx_rate = strHostIFCfgParamAttr->cfg_attr_info.curr_tx_rate;
 		/*----------------------------------------------------------------------*/
 		/*Rates:		1   2   5.5   11   6  9  12  18  24  36  48   54  Auto	*/
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c6dbb6e..0c5f395 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -102,7 +102,7 @@ enum CURRENT_TXRATE {
 };
 
 struct cfg_param_val {
-	u32 u32SetCfgFlag;
+	u32 flag;
 	u8 ht_enable;
 	u8 bss_type;
 	u8 auth_type;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7abdd53..cb2144f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1649,25 +1649,25 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 
 	priv = wiphy_priv(wiphy);
 
-	pstrCfgParamVal.u32SetCfgFlag = 0;
+	pstrCfgParamVal.flag = 0;
 	PRINT_D(CFG80211_DBG, "Setting Wiphy params\n");
 
 	if (changed & WIPHY_PARAM_RETRY_SHORT) {
 		PRINT_D(CFG80211_DBG, "Setting WIPHY_PARAM_RETRY_SHORT %d\n",
 			priv->dev->ieee80211_ptr->wiphy->retry_short);
-		pstrCfgParamVal.u32SetCfgFlag  |= RETRY_SHORT;
+		pstrCfgParamVal.flag  |= RETRY_SHORT;
 		pstrCfgParamVal.short_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_short;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG) {
 
 		PRINT_D(CFG80211_DBG, "Setting WIPHY_PARAM_RETRY_LONG %d\n", priv->dev->ieee80211_ptr->wiphy->retry_long);
-		pstrCfgParamVal.u32SetCfgFlag |= RETRY_LONG;
+		pstrCfgParamVal.flag |= RETRY_LONG;
 		pstrCfgParamVal.long_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_long;
 
 	}
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
 		PRINT_D(CFG80211_DBG, "Setting WIPHY_PARAM_FRAG_THRESHOLD %d\n", priv->dev->ieee80211_ptr->wiphy->frag_threshold);
-		pstrCfgParamVal.u32SetCfgFlag |= FRAG_THRESHOLD;
+		pstrCfgParamVal.flag |= FRAG_THRESHOLD;
 		pstrCfgParamVal.frag_threshold = priv->dev->ieee80211_ptr->wiphy->frag_threshold;
 
 	}
@@ -1675,7 +1675,7 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
 		PRINT_D(CFG80211_DBG, "Setting WIPHY_PARAM_RTS_THRESHOLD %d\n", priv->dev->ieee80211_ptr->wiphy->rts_threshold);
 
-		pstrCfgParamVal.u32SetCfgFlag |= RTS_THRESHOLD;
+		pstrCfgParamVal.flag |= RTS_THRESHOLD;
 		pstrCfgParamVal.rts_threshold = priv->dev->ieee80211_ptr->wiphy->rts_threshold;
 
 	}
-- 
1.9.1

