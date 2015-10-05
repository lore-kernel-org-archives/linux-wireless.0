Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8879 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbJEG1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:27:14 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/18] staging: wilc1000: remove typedef from tstrCfgParamVal
Date: Mon, 5 Oct 2015 15:25:46 +0900
Message-ID: <1444026353-29024-11-git-send-email-tony.cho@atmel.com> (sfid-20151005_084654_085128_2E485E15)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrCfgParamVal.
And rename it to cfg_param_val.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 4 ++--
 drivers/staging/wilc1000/host_interface.h         | 8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index adc81cd..073a724 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -72,7 +72,7 @@ extern u8 g_wilc_initialized;
  *  @version		1.0
  */
 struct cfg_param_attr {
-	tstrCfgParamVal pstrCfgParamVal;
+	struct cfg_param_val pstrCfgParamVal;
 };
 
 /*!
@@ -5783,7 +5783,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
+s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal)
 {
 
 	s32 s32Error = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 460c73b..69c5a94 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -109,7 +109,7 @@ typedef enum {
 	MBPS_54		= 54
 } CURRENT_TX_RATE_T;
 
-typedef struct {
+struct cfg_param_val {
 	u32 u32SetCfgFlag;
 	u8 ht_enable;
 	u8 bss_type;
@@ -132,7 +132,7 @@ typedef struct {
 	u16 passive_scan_time;
 	CURRENT_TX_RATE_T curr_tx_rate;
 
-} tstrCfgParamVal;
+};
 
 typedef enum {
 	RETRY_SHORT		= BIT(0),
@@ -319,7 +319,7 @@ typedef struct {
 	tenuHostIFstate enuHostIFstate;
 
 	u8 au8AssociatedBSSID[ETH_ALEN];
-	tstrCfgParamVal strCfgValues;
+	struct cfg_param_val strCfgValues;
 /* semaphores */
 	struct semaphore gtOsCfgValuesSem;
 	struct semaphore hSemTestKeyBlock;
@@ -885,7 +885,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal);
+s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal);
 
 /**
  *  @brief              gets configuration wids values
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8068a7e..5905040 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1742,7 +1742,7 @@ static int  WILC_WFI_disassoc(struct wiphy *wiphy, struct net_device *dev,
 static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	s32 s32Error = 0;
-	tstrCfgParamVal pstrCfgParamVal;
+	struct cfg_param_val pstrCfgParamVal;
 	struct wilc_priv *priv;
 
 	priv = wiphy_priv(wiphy);
-- 
1.9.1

