Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47995 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbbG1Is5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:48:57 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/21] staging: wilc1000: remove a dead preprocessor conditionals
Date: Tue, 28 Jul 2015 17:47:27 +0900
Message-ID: <1438073261-28315-9-git-send-email-tony.cho@atmel.com> (sfid-20150728_104906_477455_CF639957)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the preprocessor conditionals which are related to
the WILC1000_SINGLE_TRANSFER definition becasue this is not used.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index ea545c9..8f674ad 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -10,11 +10,7 @@
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
-#ifdef WILC1000_SINGLE_TRANSFER
-#define WILC_SDIO_BLOCK_SIZE 256
-#else
 #define WILC_SDIO_BLOCK_SIZE 512
-#endif
 
 typedef struct {
 	void *os_context;
@@ -321,16 +317,6 @@ static int sdio_write(uint32_t addr, uint8_t *buf, uint32_t size)
 		cmd.function = 0;
 		cmd.address = 0x10f;
 	} else {
-#ifdef WILC1000_SINGLE_TRANSFER
-		/**
-		 *      has to be block aligned...
-		 **/
-		nleft = size % block_size;
-		if (nleft > 0) {
-			size += block_size;
-			size &= ~(block_size - 1);
-		}
-#else
 		/**
 		 *      has to be word aligned...
 		 **/
@@ -338,7 +324,6 @@ static int sdio_write(uint32_t addr, uint8_t *buf, uint32_t size)
 			size += 4;
 			size &= ~0x3;
 		}
-#endif
 
 		/**
 		 *      func 1 access
@@ -463,16 +448,6 @@ static int sdio_read(uint32_t addr, uint8_t *buf, uint32_t size)
 		cmd.function = 0;
 		cmd.address = 0x10f;
 	} else {
-#ifdef WILC1000_SINGLE_TRANSFER
-		/**
-		 *      has to be block aligned...
-		 **/
-		nleft = size % block_size;
-		if (nleft > 0) {
-			size += block_size;
-			size &= ~(block_size - 1);
-		}
-#else
 		/**
 		 *      has to be word aligned...
 		 **/
@@ -480,7 +455,6 @@ static int sdio_read(uint32_t addr, uint8_t *buf, uint32_t size)
 			size += 4;
 			size &= ~0x3;
 		}
-#endif
 
 		/**
 		 *      func 1 access
-- 
1.9.1

