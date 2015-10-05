Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33303 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbbJEKfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:46 -0400
Received: by pacex6 with SMTP id ex6so173831511pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:45 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 12/20] staging: wilc1000: remove host_int_set_RSNAConfigPSKPassPhrase
Date: Mon,  5 Oct 2015 19:34:56 +0900
Message-Id: <1444041304-7727-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123551_765561_DB79E132)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is defined but never used anywhere,
so just delete it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 31 -------------------------------
 drivers/staging/wilc1000/host_interface.h | 16 ----------------
 2 files changed, 47 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 99375ba..f217b62 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4765,37 +4765,6 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	return s32Error;
 }
 
-
-/**
- *  @brief              sets the pass phrase
- *  @details    AP/STA mode. This function gives the pass phrase used to
- *                              generate the Pre-Shared Key when WPA/WPA2 is enabled
- *                              The length of the field can vary from 8 to 64 bytes,
- *                              the lower layer should get the
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]   String containing PSK
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPhrase,
-						 u8 u8Psklength)
-{
-	s32 s32Error = 0;
-	tstrWID strWID;
-
-	/*validating psk length*/
-	if ((u8Psklength > 7) && (u8Psklength < 65)) {
-		strWID.u16WIDid	= (u16)WID_11I_PSK;
-		strWID.enuWIDtype	= WID_STR;
-		strWID.ps8WidVal	= pu8PassPhrase;
-		strWID.s32ValueSize = u8Psklength;
-	}
-
-	return s32Error;
-}
 /**
  *  @brief              host_int_get_MacAddress
  *  @details	gets mac address
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 64a3de5..c94bebc 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -554,22 +554,6 @@ s32 host_int_add_tx_gtk(tstrWILC_WFIDrv *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8
 s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray);
 
 /**
- *  @brief              sets the pass phrase
- *  @details    AP/STA mode. This function gives the pass phrase used to
- *                              generate the Pre-Shared Key when WPA/WPA2 is enabled
- *                              The length of the field can vary from 8 to 64 bytes,
- *                              the lower layer should get the
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]   String containing PSK
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPhrase,
-						 u8 u8Psklength);
-/**
  *  @brief              gets the pass phrase
  *  @details    AP/STA mode. This function gets the pass phrase used to
  *                              generate the Pre-Shared Key when WPA/WPA2 is enabled
-- 
2.6.0

