Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33107 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448AbbHKBdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 21:33:03 -0400
Received: by pabyb7 with SMTP id yb7so117956607pab.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2015 18:33:02 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/4] staging: wilc1000: remove unused memory functions
Date: Tue, 11 Aug 2015 10:32:40 +0900
Message-Id: <1439256762-16711-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150811_033310_037540_232A8ACD)
In-Reply-To: <1439256762-16711-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439256762-16711-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove unused memory functions because some macros with this
memory function are deleted.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_memory.c | 28 -------------------
 drivers/staging/wilc1000/wilc_memory.h | 50 ----------------------------------
 2 files changed, 78 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_memory.c b/drivers/staging/wilc1000/wilc_memory.c
index 34ef13e..53ba1d0 100644
--- a/drivers/staging/wilc1000/wilc_memory.c
+++ b/drivers/staging/wilc1000/wilc_memory.c
@@ -15,35 +15,7 @@ void *WILC_MemoryAlloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
 		return NULL;
 }
 
-/*!
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-void *WILC_MemoryCalloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
-			char *pcFileName, u32 u32LineNo)
-{
-	return kcalloc(u32Size, 1, GFP_KERNEL);
-}
-
-/*!
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-void *WILC_MemoryRealloc(void *pvOldBlock, u32 u32NewSize,
-			 tstrWILC_MemoryAttrs *strAttrs, char *pcFileName, u32 u32LineNo)
-{
-	if (u32NewSize == 0) {
-		kfree(pvOldBlock);
-		return NULL;
-	} else if (pvOldBlock == NULL)	 {
-		return kmalloc(u32NewSize, GFP_KERNEL);
-	} else {
-		return krealloc(pvOldBlock, u32NewSize, GFP_KERNEL);
-	}
 
-}
 
 /*!
  *  @author	syounan
diff --git a/drivers/staging/wilc1000/wilc_memory.h b/drivers/staging/wilc1000/wilc_memory.h
index e3be567..1c0cb82 100644
--- a/drivers/staging/wilc1000/wilc_memory.h
+++ b/drivers/staging/wilc1000/wilc_memory.h
@@ -47,57 +47,7 @@ typedef struct {
 void *WILC_MemoryAlloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
 		       char *pcFileName, u32 u32LineNo);
 
-/*!
- *  @brief	Allocates a given size of bytes and zero filling it
- *  @param[in]	u32Size size of memory in bytes to be allocated
- *  @param[in]	strAttrs Optional attributes, NULL for default
- *              if not NULL, pAllocationPool should point to the pool to use for
- *              this allocation. if NULL memory will be allocated directly from
- *              the system
- *  @param[in]	pcFileName file name of the calling code for debugging
- *  @param[in]	u32LineNo line number of the calling code for debugging
- *  @return	The new allocated block, NULL if allocation fails
- *  @note	It is recommended to use of of the wrapper macros instead of
- *              calling this function directly
- *  @sa		sttrWILC_MemoryAttrs
- *  @sa		WILC_CALLOC
- *  @sa		WILC_CALLOC_EX
- *  @sa		WILC_NEW_0
- *  @sa		WILC_NEW_0_EX
- *  @author	syounan
- *  @date	16 Aug 2010
- *  @version	1.0
- */
-void *WILC_MemoryCalloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
-			char *pcFileName, u32 u32LineNo);
 
-/*!
- *  @brief	Reallocates a given block to a new size
- *  @param[in]	pvOldBlock the old memory block, if NULL then this function
- *              behaves as a new allocation function
- *  @param[in]	u32NewSize size of the new memory block in bytes, if zero then
- *              this function behaves as a free function
- *  @param[in]	strAttrs Optional attributes, NULL for default
- *              if pAllocationPool!=NULL and pvOldBlock==NULL, pAllocationPool
- *              should point to the pool to use for this allocation.
- *              if pAllocationPool==NULL and pvOldBlock==NULL memory will be
- *              allocated directly from	the system
- *              if and pvOldBlock!=NULL, pAllocationPool will not be inspected
- *              and reallocation is done from the same pool as the original block
- *  @param[in]	pcFileName file name of the calling code for debugging
- *  @param[in]	u32LineNo line number of the calling code for debugging
- *  @return	The new allocated block, possibly same as pvOldBlock
- *  @note	It is recommended to use of of the wrapper macros instead of
- *              calling this function directly
- *  @sa		sttrWILC_MemoryAttrs
- *  @sa		WILC_REALLOC
- *  @sa		WILC_REALLOC_EX
- *  @author	syounan
- *  @date	16 Aug 2010
- *  @version	1.0
- */
-void *WILC_MemoryRealloc(void *pvOldBlock, u32 u32NewSize,
-			 tstrWILC_MemoryAttrs *strAttrs, char *pcFileName, u32 u32LineNo);
 
 /*!
  *  @brief	Frees given block
-- 
1.9.1

