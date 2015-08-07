Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33942 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbbHGACY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 20:02:24 -0400
Received: by pdber20 with SMTP id er20so37830919pdb.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 17:02:23 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/4] staging: wilc1000: remove WILC_memset function
Date: Fri,  7 Aug 2015 09:02:02 +0900
Message-Id: <1438905724-26810-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150807_020227_502909_1E5C24FC)
In-Reply-To: <1438905724-26810-1-git-send-email-chaehyun.lim@gmail.com>
References: <1438905724-26810-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove WILC_memset function because it is changed to memset.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_strutils.c |  9 ---------
 drivers/staging/wilc1000/wilc_strutils.h | 12 ------------
 2 files changed, 21 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_strutils.c b/drivers/staging/wilc1000/wilc_strutils.c
index e014595..c15375e 100644
--- a/drivers/staging/wilc1000/wilc_strutils.c
+++ b/drivers/staging/wilc1000/wilc_strutils.c
@@ -25,15 +25,6 @@ void WILC_memcpy_INTERNAL(void *pvTarget, const void *pvSource, u32 u32Count)
 	memcpy(pvTarget, pvSource, u32Count);
 }
 
-/*!
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-void *WILC_memset(void *pvTarget, u8 u8SetValue, u32 u32Count)
-{
-	return memset(pvTarget, u8SetValue, u32Count);
-}
 
 /*!
  *  @author	syounan
diff --git a/drivers/staging/wilc1000/wilc_strutils.h b/drivers/staging/wilc1000/wilc_strutils.h
index d144557..acc0ca4 100644
--- a/drivers/staging/wilc1000/wilc_strutils.h
+++ b/drivers/staging/wilc1000/wilc_strutils.h
@@ -71,18 +71,6 @@ static WILC_ErrNo WILC_memcpy(void *pvTarget, const void *pvSource, u32 u32Count
 	}
 }
 
-/*!
- *  @brief	Sets the contents of a memory buffer with the given value
- *  @param[in]	pvTarget the target buffer which contsnts will be set
- *  @param[in]	u8SetValue the value to be used
- *  @param[in]	u32Count the size of the memory buffer
- *  @return	value of pvTarget
- *  @note	this function repeats the functionality of standard memset
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-void *WILC_memset(void *pvTarget, u8 u8SetValue, u32 u32Count);
 
 /*!
  *  @brief	copies the contents of source string into the target string
-- 
1.9.1

