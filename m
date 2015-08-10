Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35046 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbHJCdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 22:33:43 -0400
Received: by pacgr6 with SMTP id gr6so15835390pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 19:33:43 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/11] staging: wilc1000: remove WILC_strncpy function
Date: Mon, 10 Aug 2015 11:33:16 +0900
Message-Id: <1439174002-7365-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150810_043353_122695_3CF8B2F6)
In-Reply-To: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove WILC_strncpy function that is changed to strncpy.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_strutils.c | 10 ----------
 drivers/staging/wilc1000/wilc_strutils.h | 14 --------------
 2 files changed, 24 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_strutils.c b/drivers/staging/wilc1000/wilc_strutils.c
index 205a06a..337e62f 100644
--- a/drivers/staging/wilc1000/wilc_strutils.c
+++ b/drivers/staging/wilc1000/wilc_strutils.c
@@ -17,16 +17,6 @@ void WILC_memcpy_INTERNAL(void *pvTarget, const void *pvSource, u32 u32Count)
 }
 
 
-/*!
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-char *WILC_strncpy(char *pcTarget, const char *pcSource,
-			u32 u32Count)
-{
-	return strncpy(pcTarget, pcSource, u32Count);
-}
 
 s32 WILC_strncmp(const char *pcStr1, const char *pcStr2,
 			 u32 u32Count)
diff --git a/drivers/staging/wilc1000/wilc_strutils.h b/drivers/staging/wilc1000/wilc_strutils.h
index 7c38e14..86728d2 100644
--- a/drivers/staging/wilc1000/wilc_strutils.h
+++ b/drivers/staging/wilc1000/wilc_strutils.h
@@ -59,20 +59,6 @@ static WILC_ErrNo WILC_memcpy(void *pvTarget, const void *pvSource, u32 u32Count
 }
 
 
-/*!
- *  @brief	copies the contents of source string into the target string
- *  @param[in]	pcTarget the target string buffer
- *  @param[in]	pcSource the source string the will be copied
- *  @param[in]	u32Count copying will proceed until a null character in pcSource
- *              is encountered or u32Count of bytes copied
- *  @return	value of pcTarget
- *  @note	this function repeats the functionality of standard strncpy
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-char *WILC_strncpy(char *pcTarget, const char *pcSource,
-			u32 u32Count);
 
 /*!
  *  @brief	Compares two strings up to u32Count characters
-- 
1.9.1

