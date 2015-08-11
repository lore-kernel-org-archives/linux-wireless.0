Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34389 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864AbbHKBdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 21:33:00 -0400
Received: by pawu10 with SMTP id u10so151921743paw.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2015 18:33:00 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/4] staging: wilc1000: wilc_memory.h: remove unused define
Date: Tue, 11 Aug 2015 10:32:39 +0900
Message-Id: <1439256762-16711-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150811_033309_410275_AD63B7A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused define macro that is never used.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_memory.h | 51 ----------------------------------
 1 file changed, 51 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_memory.h b/drivers/staging/wilc1000/wilc_memory.h
index 372d705..e3be567 100644
--- a/drivers/staging/wilc1000/wilc_memory.h
+++ b/drivers/staging/wilc1000/wilc_memory.h
@@ -126,20 +126,8 @@ void WILC_MemoryFree(const void *pvBlock, tstrWILC_MemoryAttrs *strAttrs,
 	(WILC_MemoryAlloc( \
 		 (__size__), __attrs__, NULL, 0))
 
-/*!
- * @brief	standrad calloc wrapper with custom attributes
- */
-	#define WILC_CALLOC_EX(__size__, __attrs__) \
-	(WILC_MemoryCalloc( \
-		 (__size__), __attrs__, NULL, 0))
 
 /*!
- * @brief	standrad realloc wrapper with custom attributes
- */
-	#define WILC_REALLOC_EX(__ptr__, __new_size__, __attrs__) \
-	(WILC_MemoryRealloc( \
-		 (__ptr__), (__new_size__), __attrs__, NULL, 0))
-/*!
  * @brief	standrad free wrapper with custom attributes
  */
 	#define WILC_FREE_EX(__ptr__, __attrs__) \
@@ -154,24 +142,7 @@ void WILC_MemoryFree(const void *pvBlock, tstrWILC_MemoryAttrs *strAttrs,
 	((__struct_type__ *)WILC_MALLOC_EX( \
 		 sizeof(__struct_type__) * (u32)(__n_structs__), __attrs__))
 
-/*!
- * @brief	Allocates a block (with custom attributes) of given type and number of
- * elements and Zero-fills it
- */
-#define WILC_NEW_0_EX(__struct_type__, __n_structs__, __attrs__) \
-	((__struct_type__ *)WILC_CALLOC_EX( \
-		 sizeof(__struct_type__) * (u32)(__n_structs__), __attrs__))
 
-/*!
- * @brief	Frees a block (with custom attributes), also setting the original pointer
- * to NULL
- */
-#define WILC_FREE_SET_NULL_EX(__ptr__, __attrs__) do { \
-		if (__ptr__ != NULL) { \
-			WILC_FREE_EX(__ptr__, __attrs__); \
-			__ptr__ = NULL; \
-		} \
-} while (0)
 
 /*!
  * @brief	Frees a block (with custom attributes) if the pointer expression evaluates
@@ -189,17 +160,7 @@ void WILC_MemoryFree(const void *pvBlock, tstrWILC_MemoryAttrs *strAttrs,
 #define WILC_MALLOC(__size__) \
 	WILC_MALLOC_EX(__size__, NULL)
 
-/*!
- * @brief	standrad calloc wrapper with default attributes
- */
-#define WILC_CALLOC(__size__) \
-	WILC_CALLOC_EX(__size__, NULL)
 
-/*!
- * @brief	standrad realloc wrapper with default attributes
- */
-#define WILC_REALLOC(__ptr__, __new_size__) \
-	WILC_REALLOC_EX(__ptr__, __new_size__, NULL)
 
 /*!
  * @brief	standrad free wrapper with default attributes
@@ -214,19 +175,7 @@ void WILC_MemoryFree(const void *pvBlock, tstrWILC_MemoryAttrs *strAttrs,
 #define WILC_NEW(__struct_type__, __n_structs__) \
 	WILC_NEW_EX(__struct_type__, __n_structs__, NULL)
 
-/*!
- * @brief	Allocates a block (with default attributes) of given type and number of
- * elements and Zero-fills it
- */
-#define WILC_NEW_0(__struct_type__, __n_structs__) \
-	WILC_NEW_O_EX(__struct_type__, __n_structs__, NULL)
 
-/*!
- * @brief	Frees a block (with default attributes), also setting the original pointer
- * to NULL
- */
-#define WILC_FREE_SET_NULL(__ptr__) \
-	WILC_FREE_SET_NULL_EX(__ptr__, NULL)
 
 /*!
  * @brief	Frees a block (with default attributes) if the pointer expression evaluates
-- 
1.9.1

