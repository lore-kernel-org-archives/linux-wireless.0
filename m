Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33812 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbbIVNrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:47:52 -0400
Received: by padhy16 with SMTP id hy16so10095745pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 06:47:51 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/9] staging: wilc1000: remove CoreConfiguratorDeInit
Date: Tue, 22 Sep 2015 22:47:37 +0900
Message-Id: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_154755_641991_0590E28F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes CoreConfiguratorDeInit function, which is not doing
anything else except printing a PRINT_D message and returning a
s32Error. It is also removed the codes that is calling this function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 20 --------------------
 drivers/staging/wilc1000/coreconfigurator.h |  2 --
 drivers/staging/wilc1000/host_interface.c   |  2 --
 3 files changed, 24 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index e563c9b..9676044 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -700,26 +700,6 @@ s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
 }
 #endif
 
-/**
- *  @brief              Deinitializes the Core Configurator
- *  @details
- *  @return     Error code indicating success/failure
- *  @note
- *  @author	mabubakr
- *  @date		1 Mar 2012
- *  @version	1.0
- */
-
-s32 CoreConfiguratorDeInit(void)
-{
-	s32 s32Error = 0;
-
-	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorDeInit()\n");
-
-
-	return s32Error;
-}
-
 /*Using the global handle of the driver*/
 extern wilc_wlan_oup_t *gpstrWlanOps;
 /**
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 88a697b..a255e45 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -156,8 +156,6 @@ typedef struct wid_site_survey_reslts {
 } wid_site_survey_reslts_s;
 #endif
 
-s32 CoreConfiguratorDeInit(void);
-
 s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
 		  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
 s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index db93940..86dbe46 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6525,8 +6525,6 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 
 		pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult = NULL;
 	}
-	/*deinit configurator and simulator*/
-	CoreConfiguratorDeInit();
 
 	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
 
-- 
2.5.1

