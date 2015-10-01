Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33166 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbbJANoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 09:44:30 -0400
Received: by pacex6 with SMTP id ex6so75450236pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 06:44:30 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/12] staging: wilc1000: use ARRAY_SIZE macro
Date: Thu,  1 Oct 2015 22:43:54 +0900
Message-Id: <1443707039-18433-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20151001_154432_986936_87021FA2)
In-Reply-To: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses ARRAY_SIZE macro found by checkpatch.pl

WARNING: Prefer ARRAY_SIZE(wb)
drivers/staging/wilc1000/wilc_spi.c:400
drivers/staging/wilc1000/wilc_spi.c:402

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 8acf648..599508b 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -397,9 +397,9 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 	}
 #undef NUM_DUMMY_BYTES
 
-	if (len2 > (sizeof(wb) / sizeof(wb[0]))) {
+	if (len2 > ARRAY_SIZE(wb)) {
 		PRINT_ER("[wilc spi]: spi buffer size too small (%d) (%zu)\n",
-			 len2, (sizeof(wb) / sizeof(wb[0])));
+			 len2, ARRAY_SIZE(wb));
 		result = N_FAIL;
 		return result;
 	}
-- 
2.6.0

