Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:19954 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966305AbeBUQM3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 11:12:29 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 3/4] staging: wilc1000: refactor wilc_spi_clear_int_ext() by using GENMASK macro
Date: Wed, 21 Feb 2018 21:42:11 +0530
Message-ID: <1519229532-11265-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180221_171239_738037_2B46043A)
In-Reply-To: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com>
References: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use available macro GENMASK to get the bitmask value of specific value.
Simplified the logic by adding expected_irqs & unexpected_irqs to check
the interrupt bits.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 46 +++++++++++++++----------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index c63f534..12827c2 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -985,8 +985,9 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	int ret;
-	u32 flags;
 	u32 tbl_ctl;
+	u32 expected_irqs, unexpected_irqs;
+	int i;
 
 	if (g_spi.has_thrpt_enh) {
 		ret = spi_internal_write(wilc, 0xe844 - WILC_SPI_REG_BASE,
@@ -994,37 +995,26 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 		return ret;
 	}
 
-	flags = val & (BIT(MAX_NUM_INT) - 1);
-	if (flags) {
-		int i;
+	expected_irqs = val & GENMASK(g_spi.nint - 1, 0);
+	unexpected_irqs = val & GENMASK(MAX_NUM_INT - 1, g_spi.nint);
 
-		ret = 1;
-		for (i = 0; i < g_spi.nint; i++) {
-			/*
-			 * No matter what you write 1 or 0,
-			 * it will clear interrupt.
-			 */
-			if (flags & 1)
-				ret = wilc_spi_write_reg(wilc,
-							 0x10c8 + i * 4, 1);
-			if (!ret)
-				break;
-			flags >>= 1;
-		}
-		if (!ret) {
-			dev_err(&spi->dev,
-				"Failed wilc_spi_write_reg, set reg %x ...\n",
-				0x10c8 + i * 4);
-			goto _fail_;
-		}
-		for (i = g_spi.nint; i < MAX_NUM_INT; i++) {
-			if (flags & 1)
+	for (i = 0; i < g_spi.nint && expected_irqs; i++) {
+		/* No matter what you write 1 or 0, it will clear interrupt. */
+		if (expected_irqs & BIT(i)) {
+			ret = wilc_spi_write_reg(wilc, 0x10c8 + i * 4, 1);
+			if (!ret) {
 				dev_err(&spi->dev,
-					"Unexpected interrupt cleared %d...\n",
-					i);
-			flags >>= 1;
+					"Failed wilc_spi_write_reg, set reg %x ...\n",
+					0x10c8 + i * 4);
+				goto _fail_;
+			}
 		}
 	}
+	for (i = g_spi.nint; i < MAX_NUM_INT && unexpected_irqs; i++) {
+		if (unexpected_irqs & BIT(i))
+			dev_err(&spi->dev,
+				"Unexpected interrupt cleared %d...\n", i);
+	}
 
 	tbl_ctl = 0;
 	/* select VMM table 0 */
-- 
2.7.4
