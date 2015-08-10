Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34038 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbbHJCd5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 22:33:57 -0400
Received: by pdbfa8 with SMTP id fa8so25734332pdb.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 19:33:57 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/11] staging: wilc1000: remove WILC_memcpy_INTERNAL
Date: Mon, 10 Aug 2015 11:33:21 +0900
Message-Id: <1439174002-7365-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20150810_043404_506500_F54B7311)
In-Reply-To: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove WILC_memcpy_INTERNAL that is used in the WILC_memcpy
because WILC_memcpy is replaced by memcpy.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_strutils.c |  9 ---------
 drivers/staging/wilc1000/wilc_strutils.h | 11 -----------
 2 files changed, 20 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_strutils.c b/drivers/staging/wilc1000/wilc_strutils.c
index cc4e9fe..ebc8668 100644
--- a/drivers/staging/wilc1000/wilc_strutils.c
+++ b/drivers/staging/wilc1000/wilc_strutils.c
@@ -6,15 +6,6 @@
 
 
 
-/*!
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-void WILC_memcpy_INTERNAL(void *pvTarget, const void *pvSource, u32 u32Count)
-{
-	memcpy(pvTarget, pvSource, u32Count);
-}
 
 
 
diff --git a/drivers/staging/wilc1000/wilc_strutils.h b/drivers/staging/wilc1000/wilc_strutils.h
index dbca73d..bb7b61d 100644
--- a/drivers/staging/wilc1000/wilc_strutils.h
+++ b/drivers/staging/wilc1000/wilc_strutils.h
@@ -15,17 +15,6 @@
 #include "wilc_errorsupport.h"
 
 
-/*!
- *  @brief	Internal implementation for memory copy
- *  @param[in]	pvTarget the target buffer to which the data is copied into
- *  @param[in]	pvSource pointer to the second memory location
- *  @param[in]	u32Count the size of the data to copy
- *  @note	this function should not be used directly, use WILC_memcpy instead
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-void WILC_memcpy_INTERNAL(void *pvTarget, const void *pvSource, u32 u32Count);
 
 
 
-- 
1.9.1

