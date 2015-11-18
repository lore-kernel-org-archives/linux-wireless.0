Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20645 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbKRGJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:09:09 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/16] staging: wilc1000: wilc_spi_write: pass struct wilc
Date: Wed, 18 Nov 2015 15:11:29 +0900
Message-ID: <1447827097-9436-9-git-send-email-glen.lee@atmel.com> (sfid-20151118_070912_988536_B4D7704E)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add new function parameter struct wilc and use it instead of
wilc_dev, and pass wilc to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 4 ++--
 drivers/staging/wilc1000/linux_wlan_spi.h | 3 ++-
 drivers/staging/wilc1000/wilc_spi.c       | 6 +++---
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index bfd3cc3..7be750b 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -66,9 +66,9 @@ int wilc_spi_init(void)
 	return 1;
 }
 
-int wilc_spi_write(u8 *b, u32 len)
+int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len)
 {
-	struct spi_device *spi = to_spi_device(wilc_dev->dev);
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int ret;
 	struct spi_message msg;
 
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index baa98cc..41d47dc 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -2,9 +2,10 @@
 #define LINUX_WLAN_SPI_H
 
 #include <linux/spi/spi.h>
+#include "wilc_wfi_netdevice.h"
 
 int wilc_spi_init(void);
-int wilc_spi_write(u8 *b, u32 len);
+int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len);
 int wilc_spi_read(u8 *rb, u32 rlen);
 int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 7a96004..0d89a282 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -482,7 +482,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 				order = 0x2;
 		}
 		cmd |= order;
-		if (!wilc_spi_write(&cmd, 1)) {
+		if (!wilc_spi_write(wilc, &cmd, 1)) {
 			PRINT_ER("[wilc spi]: Failed data block cmd write, bus error...\n");
 			result = N_FAIL;
 			break;
@@ -491,7 +491,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 		/**
 		 *      Write data
 		 **/
-		if (!wilc_spi_write(&b[ix], nbytes)) {
+		if (!wilc_spi_write(wilc, &b[ix], nbytes)) {
 			PRINT_ER("[wilc spi]: Failed data block write, bus error...\n");
 			result = N_FAIL;
 			break;
@@ -501,7 +501,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 		 *      Write Crc
 		 **/
 		if (!g_spi.crc_off) {
-			if (!wilc_spi_write(crc, 2)) {
+			if (!wilc_spi_write(wilc, crc, 2)) {
 				PRINT_ER("[wilc spi]: Failed data block crc write, bus error...\n");
 				result = N_FAIL;
 				break;
-- 
1.9.1

