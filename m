Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20703 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbbKRGJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:09:21 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/16] staging: wilc1000: wilc_spi_write_read: pass struct wilc
Date: Wed, 18 Nov 2015 15:11:31 +0900
Message-ID: <1447827097-9436-11-git-send-email-glen.lee@atmel.com> (sfid-20151118_070924_291926_D9762997)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new function parameter struct wilc and use it instead of
global variable wilc_dev, and pass wilc to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 4 ++--
 drivers/staging/wilc1000/linux_wlan_spi.h | 2 +-
 drivers/staging/wilc1000/wilc_spi.c       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 5066191..f3ffc9e 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -154,9 +154,9 @@ int wilc_spi_read(struct wilc *wilc, u8 *rb, u32 rlen)
 	return ret;
 }
 
-int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
+int wilc_spi_write_read(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen)
 {
-	struct spi_device *spi = to_spi_device(wilc_dev->dev);
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int ret;
 
 	if (rlen > 0) {
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index 16f0b9f..00733ab 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -7,5 +7,5 @@
 int wilc_spi_init(void);
 int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len);
 int wilc_spi_read(struct wilc *wilc, u8 *rb, u32 rlen);
-int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
+int wilc_spi_write_read(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index f5db2fc..b6a6ce2 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -250,7 +250,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 	}
 	rix = len;
 
-	if (!wilc_spi_write_read(wb, rb, len2)) {
+	if (!wilc_spi_write_read(wilc, wb, rb, len2)) {
 		PRINT_ER("[wilc spi]: Failed cmd write, bus error...\n");
 		result = N_FAIL;
 		return result;
-- 
1.9.1

