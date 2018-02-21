Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:51201 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966305AbeBUQMW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 11:12:22 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 1/4] staging: wilc1000: remove use of 'happened' variable in wilc_spi_read_int()
Date: Wed, 21 Feb 2018 21:42:09 +0530
Message-ID: <1519229532-11265-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180221_171239_128040_C8C1B25C)
In-Reply-To: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com>
References: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modified wilc_spi_read_int() by removing unnecessary use of "happened"
variable.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 6b392c9..131d2b7 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -936,7 +936,7 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 	int ret;
 	u32 tmp;
 	u32 byte_cnt;
-	int happened, j;
+	int j;
 	u32 unknown_mask;
 	u32 irq_flags;
 	int k = IRG_FLAGS_OFFSET + 5;
@@ -956,8 +956,6 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 
 	j = 0;
 	do {
-		happened = 0;
-
 		wilc_spi_read_reg(wilc, 0x1a90, &irq_flags);
 		tmp |= ((irq_flags >> 27) << IRG_FLAGS_OFFSET);
 
@@ -972,11 +970,11 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 			dev_err(&spi->dev,
 				"Unexpected interrupt(2):j=%d,tmp=%x,mask=%x\n",
 				j, tmp, unknown_mask);
-				happened = 1;
+				break;
 		}
 
 		j++;
-	} while (happened);
+	} while (1);
 
 	*int_status = tmp;
 
-- 
2.7.4
