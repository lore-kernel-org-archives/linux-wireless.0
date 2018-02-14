Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:14662 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030987AbeBNPO4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 10:14:56 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 2/6] staging: wilc1000: removed the unnecessary commented code
Date: Wed, 14 Feb 2018 16:40:11 +0530
Message-ID: <1518606615-14404-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180214_161459_903486_5A76FEA3)
In-Reply-To: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com>
References: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unused commented code.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 5d0de4e..66b6aea 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -431,10 +431,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		rix++;         /* skip 1 byte */
 	}
 
-	/* do { */
 	rsp = rb[rix++];
-	/*	if(rsp == cmd) break; */
-	/* } while(&rptr[1] <= &rb[len2]); */
 
 	if (rsp != cmd) {
 		dev_err(&spi->dev,
@@ -456,7 +453,6 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 	if (cmd == CMD_INTERNAL_READ || cmd == CMD_SINGLE_READ ||
 	    cmd == CMD_DMA_READ || cmd == CMD_DMA_EXT_READ) {
 		int retry;
-		/* u16 crc1, crc2; */
 		u8 crc[2];
 		/*
 		 * Data Respnose header
@@ -620,7 +616,6 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 	int ix, nbytes;
 	int result = 1;
 	u8 cmd, order, crc[2] = {0};
-	/* u8 rsp; */
 
 	/*
 	 * Data
@@ -897,7 +892,6 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 		dev_err(&spi->dev, "Fail cmd read chip id...\n");
 		return 0;
 	}
-	/* dev_err(&spi->dev, "chipid (%08x)\n", chipid); */
 
 	g_spi.has_thrpt_enh = 1;
 
-- 
2.7.4
