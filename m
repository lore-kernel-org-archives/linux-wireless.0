Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7304 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbbFKDma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 23:42:30 -0400
From: Chris Park <chris.park@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH] staging: wilc1000: fix warning while printing
Date: Thu, 11 Jun 2015 12:42:23 +0900
Message-ID: <1433994143-23363-1-git-send-email-chris.park@atmel.com> (sfid-20150611_054233_320023_DA12CBC5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

size_t should print using %zu, but here it was use %lu.
we were getting warning while printing.

Signed-off-by: Chris Park <chris.park@atmel.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 6d854fd..a43dc9b 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -404,7 +404,7 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
 #undef NUM_DUMMY_BYTES
 
 	if (len2 > (sizeof(wb) / sizeof(wb[0]))) {
-		PRINT_ER("[wilc spi]: spi buffer size too small (%d) (%lu)\n",
+		PRINT_ER("[wilc spi]: spi buffer size too small (%d) (%zu)\n",
 			 len2, (sizeof(wb) / sizeof(wb[0])));
 		result = N_FAIL;
 		return result;
-- 
1.9.1

