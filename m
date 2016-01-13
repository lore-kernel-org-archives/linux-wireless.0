Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:64317 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577AbcAMOgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 09:36:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: gregkh@linuxfoundation.org
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] staging: wilc1000: remove extraneous variable
Date: Wed, 13 Jan 2016 15:36:17 +0100
Message-ID: <17929596.uVo1cdZGxo@wuerfel> (sfid-20160113_153658_350409_87C02EC6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Building wilc1000 with clang currently fails in the staging-next branch:

drivers/staging/wilc1000/wilc_spi.c:123:34: warning: tentative definition of variable with internal linkage has incomplete non-array type 'const struct wilc1000_ops' [-Wtentative-definition-incomplete-type]
static const struct wilc1000_ops wilc1000_spi_ops;

The reason is that wilc1000_ops was left behind after a recent cleanup,
and is completely unused and also uninitialized and const and has an
incomplete type.

Removing the variable is obviously correct, and gets rid of the warning.
No idea why gcc does not complain about it though.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 86de50c9f7f5..b3d6541b3896 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -120,8 +120,6 @@ static u8 crc7(u8 crc, const u8 *buffer, u32 len)
 
 #define USE_SPI_DMA     0
 
-static const struct wilc1000_ops wilc1000_spi_ops;
-
 static int wilc_bus_probe(struct spi_device *spi)
 {
 	int ret, gpio;

