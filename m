Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55356 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbcBOPSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 10:18:33 -0500
From: Colin King <colin.king@canonical.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: remove wilc1000_spi_ops as it is not used
Date: Mon, 15 Feb 2016 15:18:27 +0000
Message-Id: <1455549507-25553-1-git-send-email-colin.king@canonical.com> (sfid-20160215_184439_397578_261919BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

building with gcc 6 I hit a build failure:

  CC      drivers/staging/wilc1000/wilc_spi.o
drivers/staging/wilc1000/wilc_spi.c:123:34: error: storage size of
 ‘wilc1000_spi_ops’ isn’t known
 static const struct wilc1000_ops wilc1000_spi_ops;
                                  ^~~~~~~~~~~~~~~~
drivers/staging/wilc1000/wilc_spi.c:123:34: warning: ‘wilc1000_spi_ops’
  defined but not used [-Wunused-const-variable]

Since wilc1000_spi_ops is not used, remove it and the driver builds.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 86de50c..b3d6541 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -120,8 +120,6 @@ static u8 crc7(u8 crc, const u8 *buffer, u32 len)
 
 #define USE_SPI_DMA     0
 
-static const struct wilc1000_ops wilc1000_spi_ops;
-
 static int wilc_bus_probe(struct spi_device *spi)
 {
 	int ret, gpio;
-- 
2.7.0

