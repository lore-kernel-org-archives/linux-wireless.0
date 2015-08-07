Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35645 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbbHGAC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 20:02:29 -0400
Received: by pabxd6 with SMTP id xd6so55739259pab.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 17:02:29 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/4] staging: wilc1000: remove WILC_memcmp function
Date: Fri,  7 Aug 2015 09:02:04 +0900
Message-Id: <1438905724-26810-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150807_020232_594664_297B0EEE)
In-Reply-To: <1438905724-26810-1-git-send-email-chaehyun.lim@gmail.com>
References: <1438905724-26810-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove WILC_memcmp function because it is changed to memcmp.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_strutils.c |  9 ---------
 drivers/staging/wilc1000/wilc_strutils.h | 13 -------------
 2 files changed, 22 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_strutils.c b/drivers/staging/wilc1000/wilc_strutils.c
index c15375e..3600706 100644
--- a/drivers/staging/wilc1000/wilc_strutils.c
+++ b/drivers/staging/wilc1000/wilc_strutils.c
@@ -4,15 +4,6 @@
 #include "wilc_strutils.h"
 
 
-/*!
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-s32 WILC_memcmp(const void *pvArg1, const void *pvArg2, u32 u32Count)
-{
-	return memcmp(pvArg1, pvArg2, u32Count);
-}
 
 
 /*!
diff --git a/drivers/staging/wilc1000/wilc_strutils.h b/drivers/staging/wilc1000/wilc_strutils.h
index acc0ca4..9e3c5d9 100644
--- a/drivers/staging/wilc1000/wilc_strutils.h
+++ b/drivers/staging/wilc1000/wilc_strutils.h
@@ -14,19 +14,6 @@
 #include <linux/string.h>
 #include "wilc_errorsupport.h"
 
-/*!
- *  @brief	Compares two memory buffers
- *  @param[in]	pvArg1 pointer to the first memory location
- *  @param[in]	pvArg2 pointer to the second memory location
- *  @param[in]	u32Count the size of the memory buffers
- *  @return	0 if the 2 buffers are equal, 1 if pvArg1 is bigger than pvArg2,
- *              -1 if pvArg1 smaller than pvArg2
- *  @note	this function repeats the functionality of standard memcmp
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-s32 WILC_memcmp(const void *pvArg1, const void *pvArg2, u32 u32Count);
 
 /*!
  *  @brief	Internal implementation for memory copy
-- 
1.9.1

