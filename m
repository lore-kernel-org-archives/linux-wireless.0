Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36762 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbbHJCdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 22:33:54 -0400
Received: by pdco4 with SMTP id o4so65831624pdc.3
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 19:33:54 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/11] staging: wilc1000: remove WILC_memcpy function
Date: Mon, 10 Aug 2015 11:33:20 +0900
Message-Id: <1439174002-7365-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20150810_043400_730437_F9BD213B)
In-Reply-To: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove WILC_memcpy function that is changed to memcpy.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_strutils.h | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_strutils.h b/drivers/staging/wilc1000/wilc_strutils.h
index 03f4938..dbca73d 100644
--- a/drivers/staging/wilc1000/wilc_strutils.h
+++ b/drivers/staging/wilc1000/wilc_strutils.h
@@ -27,36 +27,6 @@
  */
 void WILC_memcpy_INTERNAL(void *pvTarget, const void *pvSource, u32 u32Count);
 
-/*!
- *  @brief	Copies the contents of a memory buffer into another
- *  @param[in]	pvTarget the target buffer to which the data is copied into
- *  @param[in]	pvSource pointer to the second memory location
- *  @param[in]	u32Count the size of the data to copy
- *  @return	WILC_SUCCESS if copy is successfully handeled
- *              WILC_FAIL if copy failed
- *  @note	this function repeats the functionality of standard memcpy,
- *              however memcpy is undefined if the two buffers overlap but this
- *              implementation will check for overlap and report error
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-static WILC_ErrNo WILC_memcpy(void *pvTarget, const void *pvSource, u32 u32Count)
-{
-	if (
-		(((u8 *)pvTarget <= (u8 *)pvSource)
-		 && (((u8 *)pvTarget + u32Count) > (u8 *)pvSource))
-
-		|| (((u8 *)pvSource <= (u8 *)pvTarget)
-		    && (((u8 *)pvSource + u32Count) > (u8 *)pvTarget))
-		) {
-		/* ovelapped memory, return Error */
-		return WILC_FAIL;
-	} else {
-		WILC_memcpy_INTERNAL(pvTarget, pvSource, u32Count);
-		return WILC_SUCCESS;
-	}
-}
 
 
 
-- 
1.9.1

