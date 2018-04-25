Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46871 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755910AbeDYRTd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:33 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 03/21] staging: wilc1000: remove unnecessary assingment from 'if' conditions
Date: Wed, 25 Apr 2018 22:48:08 +0530
Message-ID: <1524676706-13179-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191938_223507_F8EBFE25)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unnecessary use of '==' check used in if
conditions.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 12 ++++++------
 drivers/staging/wilc1000/wilc_spi.c  |  6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 087ad42..54121c3 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -885,13 +885,13 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 			reg = 0;
 		}
 		/* select VMM table 0 */
-		if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
+		if (val & SEL_VMM_TBL0)
 			reg |= BIT(5);
 		/* select VMM table 1 */
-		if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
+		if (val & SEL_VMM_TBL1)
 			reg |= BIT(6);
 		/* enable VMM */
-		if ((val & EN_VMM) == EN_VMM)
+		if (val & EN_VMM)
 			reg |= BIT(7);
 		if (reg) {
 			struct sdio_cmd52 cmd;
@@ -961,13 +961,13 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 
 	vmm_ctl = 0;
 	/* select VMM table 0 */
-	if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
+	if (val & SEL_VMM_TBL0)
 		vmm_ctl |= BIT(0);
 	/* select VMM table 1 */
-	if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
+	if (val & SEL_VMM_TBL1)
 		vmm_ctl |= BIT(1);
 	/* enable VMM */
-	if ((val & EN_VMM) == EN_VMM)
+	if (val & EN_VMM)
 		vmm_ctl |= BIT(2);
 
 	if (vmm_ctl) {
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 600005c..c980d3b 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1023,10 +1023,10 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 
 	tbl_ctl = 0;
 	/* select VMM table 0 */
-	if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
+	if (val & SEL_VMM_TBL0)
 		tbl_ctl |= BIT(0);
 	/* select VMM table 1 */
-	if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
+	if (val & SEL_VMM_TBL1)
 		tbl_ctl |= BIT(1);
 
 	ret = wilc_spi_write_reg(wilc, WILC_VMM_TBL_CTL, tbl_ctl);
@@ -1035,7 +1035,7 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 		return ret;
 	}
 
-	if ((val & EN_VMM) == EN_VMM) {
+	if (val & EN_VMM) {
 		/*
 		 * enable vmm transfer.
 		 */
-- 
2.7.4
