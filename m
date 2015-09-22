Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34126 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbbIVJf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:29 -0400
Received: by padhy16 with SMTP id hy16so4754561pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:28 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 08/16] staging: wilc1000: remove CoreConfiguratorInit
Date: Tue, 22 Sep 2015 18:34:53 +0900
Message-Id: <1442914501-2315-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_113535_643368_670490D5)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes CoreConfiguratorInit function, which is not doing
anything else except printing a PRINT_D message and returing a s32Error.
It is also removed the code that is calling this function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing and remove declaration of function.

 drivers/staging/wilc1000/coreconfigurator.c | 19 -------------------
 drivers/staging/wilc1000/coreconfigurator.h |  1 -
 drivers/staging/wilc1000/host_interface.c   | 11 -----------
 3 files changed, 31 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 14e8efc..e563c9b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -327,25 +327,6 @@ static inline u16 get_asoc_id(u8 *data)
 	return asoc_id;
 }
 
-/**
- *  @brief              initializes the Core Configurator
- *  @details
- *  @return     Error code indicating success/failure
- *  @note
- *  @author	mabubakr
- *  @date		1 Mar 2012
- *  @version		1.0
- */
-
-s32 CoreConfiguratorInit(void)
-{
-	s32 s32Error = 0;
-
-	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit()\n");
-
-	return s32Error;
-}
-
 u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
 {
 	u16 u16index = 0;
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 8439066..88a697b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -156,7 +156,6 @@ typedef struct wid_site_survey_reslts {
 } wid_site_survey_reslts_s;
 #endif
 
-s32 CoreConfiguratorInit(void);
 s32 CoreConfiguratorDeInit(void);
 
 s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 62f4a8a..bc0adcd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6465,22 +6465,11 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
 
 	/*TODO Code to setup simulation to be removed later*/
-	/*Intialize configurator module*/
-	s32Error = CoreConfiguratorInit();
-	if (s32Error < 0) {
-		PRINT_ER("Failed to initialize core configurator\n");
-		goto _fail_mem_;
-	}
 
 	clients_count++; /* increase number of created entities */
 
 	return s32Error;
 
-
-_fail_mem_:
-	if (pstrWFIDrv != NULL)
-		kfree(pstrWFIDrv);
-	del_timer_sync(&pstrWFIDrv->hRemainOnChannel);
 _fail_timer_2:
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
 	del_timer_sync(&pstrWFIDrv->hConnectTimer);
-- 
2.5.1

