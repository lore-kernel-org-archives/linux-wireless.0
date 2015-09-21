Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35751 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbIUM64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:58:56 -0400
Received: by pacfv12 with SMTP id fv12so118702586pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 05:58:56 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/16] staging: wilc1000: remove CoreConfiguratorInit
Date: Mon, 21 Sep 2015 21:58:18 +0900
Message-Id: <1442840306-9657-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150921_145900_290928_2A24FD9F)
In-Reply-To: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes CoreConfiguratorInit function, which is not doing
anything else except printing a PRINT_D message and returing a s32Error.
It is also removed the code that is calling this function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 19 -------------------
 drivers/staging/wilc1000/host_interface.c   | 11 -----------
 2 files changed, 30 deletions(-)

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

