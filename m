Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34311 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbbJEKfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:39 -0400
Received: by padhy16 with SMTP id hy16so33469989pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:39 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/20] staging: wilc1000: remove host_int_test_set_int_wid
Date: Mon,  5 Oct 2015 19:34:54 +0900
Message-Id: <1444041304-7727-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123542_286719_58E5F4C7)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is defined but never used anywhere,
so just delete it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 43 -------------------------------
 1 file changed, 43 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index edd8b81..40001fa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5452,49 +5452,6 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 
 }
 
-
-/**
- *  @brief                       host_int_test_set_int_wid
- *  @details             Test function for setting wids
- *  @param[in,out]   WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr
- *  @return              Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
-{
-	s32 s32Error = 0;
-	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-
-
-	if (pstrWFIDrv == NULL) {
-		PRINT_ER("driver is null\n");
-		return -EFAULT;
-	}
-
-	/*prepare configuration packet*/
-	strWID.u16WIDid = (u16)WID_MEMORY_ADDRESS;
-	strWID.enuWIDtype = WID_INT;
-	strWID.ps8WidVal = (char *)&u32TestMemAddr;
-	strWID.s32ValueSize = sizeof(u32);
-
-	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
-				   get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
-		PRINT_ER("Failed to set wid value\n");
-		return -EINVAL;
-	} else {
-		PRINT_D(HOSTINF_DBG, "Successfully set wid value\n");
-
-	}
-
-	return s32Error;
-}
-
 /**
  *  @brief              host_int_get_inactive_time
  *  @details
-- 
2.6.0

