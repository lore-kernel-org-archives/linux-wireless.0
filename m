Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35108 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbbHJCdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 22:33:49 -0400
Received: by pacgr6 with SMTP id gr6so15836939pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 19:33:48 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/11] staging: wilc1000: remove WILC_strncmp function
Date: Mon, 10 Aug 2015 11:33:18 +0900
Message-Id: <1439174002-7365-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20150810_043357_763012_FF938BD8)
In-Reply-To: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove WILC_strncmp function that is changed to strncmp.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_strutils.c | 21 ---------------------
 drivers/staging/wilc1000/wilc_strutils.h | 20 --------------------
 2 files changed, 41 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_strutils.c b/drivers/staging/wilc1000/wilc_strutils.c
index 337e62f..cc4e9fe 100644
--- a/drivers/staging/wilc1000/wilc_strutils.c
+++ b/drivers/staging/wilc1000/wilc_strutils.c
@@ -18,25 +18,4 @@ void WILC_memcpy_INTERNAL(void *pvTarget, const void *pvSource, u32 u32Count)
 
 
 
-s32 WILC_strncmp(const char *pcStr1, const char *pcStr2,
-			 u32 u32Count)
-{
-	s32 s32Result;
-
-	if (pcStr1 == NULL && pcStr2 == NULL)	{
-		s32Result = 0;
-	} else if (pcStr1 == NULL)	   {
-		s32Result = -1;
-	} else if (pcStr2 == NULL)	   {
-		s32Result = 1;
-	} else {
-		s32Result = strncmp(pcStr1, pcStr2, u32Count);
-		if (s32Result < 0)
-			s32Result = -1;
-		else if (s32Result > 0)
-			s32Result = 1;
-	}
-
-	return s32Result;
-}
 
diff --git a/drivers/staging/wilc1000/wilc_strutils.h b/drivers/staging/wilc1000/wilc_strutils.h
index 86728d2..03f4938 100644
--- a/drivers/staging/wilc1000/wilc_strutils.h
+++ b/drivers/staging/wilc1000/wilc_strutils.h
@@ -60,26 +60,6 @@ static WILC_ErrNo WILC_memcpy(void *pvTarget, const void *pvSource, u32 u32Count
 
 
 
-/*!
- *  @brief	Compares two strings up to u32Count characters
- *  @details	Compares 2 strings reporting which is bigger, NULL is considered
- *              the smallest string, then a zero length string then all other
- *              strings depending on thier ascii characters order with small case
- *              converted to uppder case
- *  @param[in]	pcStr1 the first string, NULL is valid and considered smaller
- *              than any other non-NULL string (incliding zero lenght strings)
- *  @param[in]	pcStr2 the second string, NULL is valid and considered smaller
- *              than any other non-NULL string (incliding zero lenght strings)
- *  @param[in]	u32Count copying will proceed until a null character in pcStr1 or
- *              pcStr2 is encountered or u32Count of bytes copied
- *  @return	0 if the 2 strings are equal, 1 if pcStr1 is bigger than pcStr2,
- *              -1 if pcStr1 smaller than pcStr2
- *  @author	aabozaeid
- *  @date	7 Dec 2010
- *  @version	1.0
- */
-s32 WILC_strncmp(const char *pcStr1, const char *pcStr2,
-			 u32 u32Count);
 
 
 #endif
-- 
1.9.1

