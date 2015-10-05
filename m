Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34360 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbbJEKfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:42 -0400
Received: by padhy16 with SMTP id hy16so33471170pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:42 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/20] staging: wilc1000: remove host_int_get_pmkid_info
Date: Mon,  5 Oct 2015 19:34:55 +0900
Message-Id: <1444041304-7727-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123545_635810_768FA844)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is defined but never used anywhere,
so just delete it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 35 -------------------------------
 drivers/staging/wilc1000/host_interface.h | 25 ----------------------
 2 files changed, 60 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 40001fa..99375ba 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4765,41 +4765,6 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	return s32Error;
 }
 
-/**
- *  @brief              gets the cached the pmkid info
- *  @details    valid only in BSS STA mode if External Supplicant
- *                              support is enabled. This Function sets the PMKID in firmware
- *                              when host drivr receives the corresponding request from NDIS.
- *                              The firmware then includes theset PMKID in the appropriate
- *                              management frames
- *  @param[in,out] handle to the wifi driver,
- *                                message containing PMKID Info in the following format
- *|-----------------------------------------------------------------|
- *|NumEntries |	BSSID[1] | PMKID[1] |  ...	| BSSID[K] | PMKID[K] |
- *|-----------|------------|----------|-------|----------|----------|
- |	   1	|		6	 |   16		|  ...	|	 6	   |	16	  |
- ||-----------------------------------------------------------------|
- *  @param[in]
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
-				    u32 u32PmkidInfoLen)
-{
-	s32 s32Error = 0;
-	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
-
-	strWID.u16WIDid	= (u16)WID_PMKID_INFO;
-	strWID.enuWIDtype	= WID_STR;
-	strWID.s32ValueSize = u32PmkidInfoLen;
-	strWID.ps8WidVal = pu8PmkidInfoArray;
-
-	return s32Error;
-}
 
 /**
  *  @brief              sets the pass phrase
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8f77ccb..64a3de5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -552,31 +552,6 @@ s32 host_int_add_tx_gtk(tstrWILC_WFIDrv *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8
  */
 
 s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray);
-/**
- *  @brief              gets the cached the pmkid info
- *  @details    valid only in BSS STA mode if External Supplicant
- *                              support is enabled. This Function sets the PMKID in firmware
- *                              when host drivr receives the corresponding request from NDIS.
- *                              The firmware then includes theset PMKID in the appropriate
- *                              management frames
- *  @param[in,out] handle to the wifi driver,
- *
- *                                message containing PMKID Info in the following format
- *|-----------------------------------------------------------------|
- *|NumEntries |	BSSID[1] | PMKID[1] |  ...	| BSSID[K] | PMKID[K] |
- *|-----------|------------|----------|-------|----------|----------|
- |	   1	|		6	 |   16		|  ...	|	 6	   |	16	  |
- ||-----------------------------------------------------------------|
- *  @param[in]
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-
-s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
-				    u32 u32PmkidInfoLen);
 
 /**
  *  @brief              sets the pass phrase
-- 
2.6.0

