Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:54155 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752701AbeBUQMz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 11:12:55 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 4/4] staging: wilc1000: refactor sdio_clear_int_ext() by using GENMASK macro
Date: Wed, 21 Feb 2018 21:42:12 +0530
Message-ID: <1519229532-11265-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180221_171258_602254_FD0C65C4)
In-Reply-To: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com>
References: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use GENMASK macro in sdio_clear_int_ext function to get the required
bitmask value. Simplified the logic by making use of GENMASK
macro.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 74 +++++++++++++++---------------------
 1 file changed, 31 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index a088999..8218085 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -876,14 +876,9 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 	if (g_sdio.has_thrpt_enh3) {
 		u32 reg;
 
-		if (g_sdio.irq_gpio) {
-			u32 flags;
+		reg = g_sdio.irq_gpio ?
+			(val & GENMASK(MAX_NUN_INT_THRPT_ENH2 - 1, 0)) : 0;
 
-			flags = val & (BIT(MAX_NUN_INT_THRPT_ENH2) - 1);
-			reg = flags;
-		} else {
-			reg = 0;
-		}
 		/* select VMM table 0 */
 		if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
 			reg |= BIT(5);
@@ -918,45 +913,38 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 		 * Cannot clear multiple interrupts.
 		 * Must clear each interrupt individually.
 		 */
-		u32 flags;
-
-		flags = val & (BIT(MAX_NUM_INT) - 1);
-		if (flags) {
-			int i;
-
-			ret = 1;
-			for (i = 0; i < g_sdio.nint; i++) {
-				if (flags & 1) {
-					struct sdio_cmd52 cmd;
-
-					cmd.read_write = 1;
-					cmd.function = 0;
-					cmd.raw = 0;
-					cmd.address = 0xf8;
-					cmd.data = BIT(i);
-
-					ret = wilc_sdio_cmd52(wilc, &cmd);
-					if (ret) {
-						dev_err(&func->dev,
-							"Failed cmd52, set 0xf8 data (%d) ...\n",
-							__LINE__);
-						goto _fail_;
-					}
-				}
-				if (!ret)
-					break;
-				flags >>= 1;
-			}
-			if (!ret)
-				goto _fail_;
-			for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
-				if (flags & 1)
+		int i;
+		u32 expected_irqs, unexpected_irqs;
+
+		expected_irqs = val & GENMASK(g_sdio.nint - 1, 0);
+		unexpected_irqs = val & GENMASK(MAX_NUM_INT - 1, g_sdio.nint);
+
+		for (i = 0; i < g_sdio.nint && expected_irqs; i++) {
+			if (expected_irqs & BIT(i)) {
+				struct sdio_cmd52 cmd;
+
+				cmd.read_write = 1;
+				cmd.function = 0;
+				cmd.raw = 0;
+				cmd.address = 0xf8;
+				cmd.data = BIT(i);
+
+				ret = wilc_sdio_cmd52(wilc, &cmd);
+				if (ret) {
 					dev_err(&func->dev,
-						"Unexpected interrupt cleared %d...\n",
-						i);
-				flags >>= 1;
+						"Failed cmd52, set 0xf8 data (%d) ...\n",
+						__LINE__);
+					goto _fail_;
+				}
 			}
 		}
+
+		for (i = g_sdio.nint; i < MAX_NUM_INT && unexpected_irqs; i++) {
+			if (unexpected_irqs & BIT(i))
+				dev_err(&func->dev,
+					"Unexpected interrupt cleared %d...\n",
+					i);
+		}
 	}
 
 	vmm_ctl = 0;
-- 
2.7.4
