Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39607 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966305AbeBUQMb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 11:12:31 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 2/4] staging: wilc1000: modified wilc_spi_read_int() by using GENMASK macro
Date: Wed, 21 Feb 2018 21:42:10 +0530
Message-ID: <1519229532-11265-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180221_171240_389912_1C5E5FAE)
In-Reply-To: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com>
References: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use existing macro GENMASK to get the bitmask value. Moved the code to
get the bitmask value outside the loop, as its only required one time.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 131d2b7..c63f534 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -955,6 +955,7 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 	tmp = (byte_cnt >> 2) & IRQ_DMA_WD_CNT_MASK;
 
 	j = 0;
+	unknown_mask = GENMASK(g_spi.nint - 1, 0);
 	do {
 		wilc_spi_read_reg(wilc, 0x1a90, &irq_flags);
 		tmp |= ((irq_flags >> 27) << IRG_FLAGS_OFFSET);
@@ -964,8 +965,6 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 			tmp |= (((irq_flags >> 0) & 0x7) << k);
 		}
 
-		unknown_mask = ~((1ul << g_spi.nint) - 1);
-
 		if ((tmp >> IRG_FLAGS_OFFSET) & unknown_mask) {
 			dev_err(&spi->dev,
 				"Unexpected interrupt(2):j=%d,tmp=%x,mask=%x\n",
-- 
2.7.4
