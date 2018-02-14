Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:56614 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031149AbeBNPPD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 10:15:03 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 4/6] staging: wilc1000: fix line over 80 characters in wilc_spi_init()
Date: Wed, 14 Feb 2018 16:40:13 +0530
Message-ID: <1518606615-14404-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180214_161506_657010_C5BAAFA6)
In-Reply-To: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com>
References: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modified wilc_spi_init() to fix the line over 80 char issues reported
by checkpatch.pl script.
To overcome the checkpatch.pl reported issue modified debug logs and
comments used in wilc_spi_init().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 30a9a61..fddc0db 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -835,7 +835,6 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	u32 reg;
 	u32 chipid;
-
 	static int isinit;
 
 	if (isinit) {
@@ -864,20 +863,25 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 		 * is removed but chip isn't reset
 		 */
 		g_spi.crc_off = 1;
-		dev_err(&spi->dev, "Failed internal read protocol with CRC on, retrying with CRC off...\n");
+		dev_err(&spi->dev,
+			"Failed read with CRC on, retrying with CRC off\n");
 		if (!spi_internal_read(wilc, WILC_SPI_PROTOCOL_OFFSET, &reg)) {
-			/* Reaad failed with both CRC on and off, something went bad */
-			dev_err(&spi->dev,
-				"Failed internal read protocol...\n");
+			/*
+			 * Read failed with both CRC on and off,
+			 * something went bad
+			 */
+			dev_err(&spi->dev, "Failed internal read protocol\n");
 			return 0;
 		}
 	}
-	if (g_spi.crc_off == 0)	{
+	if (g_spi.crc_off == 0) {
 		reg &= ~0xc; /* disable crc checking */
 		reg &= ~0x70;
 		reg |= (0x5 << 4);
 		if (!spi_internal_write(wilc, WILC_SPI_PROTOCOL_OFFSET, reg)) {
-			dev_err(&spi->dev, "[wilc spi %d]: Failed internal write protocol reg...\n", __LINE__);
+			dev_err(&spi->dev,
+				"[wilc spi %d]: Failed internal write reg\n",
+				__LINE__);
 			return 0;
 		}
 		g_spi.crc_off = 1;
-- 
2.7.4
