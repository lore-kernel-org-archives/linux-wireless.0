Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33938 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbbHQCF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 22:05:26 -0400
Received: by pdbfa8 with SMTP id fa8so50080305pdb.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2015 19:05:25 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/6] staging: wilc1000: remove WILC_NEW and WILC_NEW_EX
Date: Mon, 17 Aug 2015 11:05:11 +0900
Message-Id: <1439777115-25861-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150817_040528_998122_E4CDEE93)
In-Reply-To: <1439777115-25861-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439777115-25861-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes WILC_NEW and WILC_NEW_EX defines that are not used anywhere.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_memory.h | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_memory.h b/drivers/staging/wilc1000/wilc_memory.h
index 877617c..f19cec1 100644
--- a/drivers/staging/wilc1000/wilc_memory.h
+++ b/drivers/staging/wilc1000/wilc_memory.h
@@ -38,8 +38,6 @@ typedef struct {
  *  @sa		sttrWILC_MemoryAttrs
  *  @sa		WILC_MALLOC
  *  @sa		WILC_MALLOC_EX
- *  @sa		WILC_NEW
- *  @sa		WILC_NEW_EX
  *  @author	syounan
  *  @date	16 Aug 2010
  *  @version	1.0
@@ -54,13 +52,6 @@ void *WILC_MemoryAlloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
 	(WILC_MemoryAlloc( \
 		 (__size__), __attrs__, NULL, 0))
 
-/*!
- * @brief	Allocates a block (with custom attributes) of given type and number of
- * elements
- */
-#define WILC_NEW_EX(__struct_type__, __n_structs__, __attrs__) \
-	((__struct_type__ *)WILC_MALLOC_EX( \
-		 sizeof(__struct_type__) * (u32)(__n_structs__), __attrs__))
 
 /*!
  * @brief	standrad malloc wrapper with default attributes
@@ -71,11 +62,5 @@ void *WILC_MemoryAlloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
 
 
 
-/*!
- * @brief	Allocates a block (with default attributes) of given type and number of
- * elements
- */
-#define WILC_NEW(__struct_type__, __n_structs__) \
-	WILC_NEW_EX(__struct_type__, __n_structs__, NULL)
 
 #endif
-- 
1.9.1

