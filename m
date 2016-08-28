Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42079 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755273AbcH1LaA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Aug 2016 07:30:00 -0400
From: Colin King <colin.king@canonical.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: fix spelling mistake: "retyring" -> "retrying"
Date: Sun, 28 Aug 2016 12:28:41 +0100
Message-Id: <20160828112841.10919-1-colin.king@canonical.com> (sfid-20160828_133021_561795_9329D550)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in dev_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 22cf4b7..0f8d625 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -871,7 +871,7 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 		/* Read failed. Try with CRC off. This might happen when module
 		 * is removed but chip isn't reset*/
 		g_spi.crc_off = 1;
-		dev_err(&spi->dev, "Failed internal read protocol with CRC on, retyring with CRC off...\n");
+		dev_err(&spi->dev, "Failed internal read protocol with CRC on, retrying with CRC off...\n");
 		if (!spi_internal_read(wilc, WILC_SPI_PROTOCOL_OFFSET, &reg)) {
 			/* Reaad failed with both CRC on and off, something went bad */
 			dev_err(&spi->dev,
-- 
2.9.3
