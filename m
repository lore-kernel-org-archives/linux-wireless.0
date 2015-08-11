Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35029 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbbHKBdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 21:33:09 -0400
Received: by pdrg1 with SMTP id g1so77410481pdr.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2015 18:33:08 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/4] staging: wilc1000: remove WILC_FREE
Date: Tue, 11 Aug 2015 10:32:42 +0900
Message-Id: <1439256762-16711-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150811_033315_373297_3BF28115)
In-Reply-To: <1439256762-16711-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439256762-16711-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove WILC_FREE that is replaced by kfree.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_memory.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_memory.h b/drivers/staging/wilc1000/wilc_memory.h
index 1c0cb82..5ec4ef3 100644
--- a/drivers/staging/wilc1000/wilc_memory.h
+++ b/drivers/staging/wilc1000/wilc_memory.h
@@ -112,11 +112,6 @@ void WILC_MemoryFree(const void *pvBlock, tstrWILC_MemoryAttrs *strAttrs,
 
 
 
-/*!
- * @brief	standrad free wrapper with default attributes
- */
-#define WILC_FREE(__ptr__) \
-	WILC_FREE_EX(__ptr__, NULL)
 
 /*!
  * @brief	Allocates a block (with default attributes) of given type and number of
-- 
1.9.1

