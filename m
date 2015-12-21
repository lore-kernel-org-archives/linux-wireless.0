Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11228 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbLUFPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:15:40 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 06/46] staging: wilc1000: remove io_type of wilc_wlan_dev_t
Date: Mon, 21 Dec 2015 14:18:10 +0900
Message-ID: <1450675130-17866-7-git-send-email-glen.lee@atmel.com> (sfid-20151221_061543_417063_BB8BC7BB)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

io_type of wilc_wlan_dev_t is unneeded, we can use io_type of struct wilc.
Remove io_type of wilc_wlan_dev_t and use io_type of wilc.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index b9bedc8..37879cd 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -5,7 +5,6 @@
 
 typedef struct {
 	int quit;
-	int io_type;
 	int cfg_frame_in_use;
 	struct wilc_cfg_frame cfg_frame;
 	u32 cfg_frame_offset;
@@ -573,7 +572,7 @@ static inline void chip_wakeup(struct wilc *wilc)
 	u32 reg, clk_status_reg, trials = 0;
 	u32 sleep_time;
 
-	if ((g_wlan.io_type & 0x1) == HIF_SPI) {
+	if ((wilc->io_type & 0x1) == HIF_SPI) {
 		do {
 			wilc->hif_func->hif_read_reg(wilc, 1, &reg);
 			wilc->hif_func->hif_write_reg(wilc, 1, reg | BIT(1));
@@ -587,7 +586,7 @@ static inline void chip_wakeup(struct wilc *wilc)
 			} while ((wilc_get_chipid(wilc, true) == 0) && ((++trials % 3) == 0));
 
 		} while (wilc_get_chipid(wilc, true) == 0);
-	} else if ((g_wlan.io_type & 0x1) == HIF_SDIO)	 {
+	} else if ((wilc->io_type & 0x1) == HIF_SDIO)	 {
 		wilc->hif_func->hif_read_reg(wilc, 0xf0, &reg);
 		do {
 			wilc->hif_func->hif_write_reg(wilc, 0xf0,
@@ -636,12 +635,12 @@ static inline void chip_wakeup(struct wilc *wilc)
 	u32 reg, trials = 0;
 
 	do {
-		if ((g_wlan.io_type & 0x1) == HIF_SPI) {
+		if ((wilc->io_type & 0x1) == HIF_SPI) {
 			wilc->hif_func->hif_read_reg(wilc, 1, &reg);
 			wilc->hif_func->hif_write_reg(wilc, 1, reg & ~BIT(1));
 			wilc->hif_func->hif_write_reg(wilc, 1, reg | BIT(1));
 			wilc->hif_func->hif_write_reg(wilc, 1, reg  & ~BIT(1));
-		} else if ((g_wlan.io_type & 0x1) == HIF_SDIO)	 {
+		} else if ((wilc->io_type & 0x1) == HIF_SDIO)	 {
 			wilc->hif_func->hif_read_reg(wilc, 0xf0, &reg);
 			wilc->hif_func->hif_write_reg(wilc, 0xf0,
 						      reg & ~BIT(0));
@@ -1061,7 +1060,7 @@ static void wilc_pllupdate_isr_ext(struct wilc *wilc, u32 int_stats)
 
 	wilc->hif_func->hif_clear_int_ext(wilc, PLL_INT_CLR);
 
-	if (g_wlan.io_type == HIF_SDIO)
+	if (wilc->io_type == HIF_SDIO)
 		mdelay(WILC_PLL_TO_SDIO);
 	else
 		mdelay(WILC_PLL_TO_SPI);
@@ -1225,15 +1224,14 @@ _fail_1:
 
 int wilc_wlan_start(struct wilc *wilc)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	u32 reg = 0;
 	int ret;
 	u32 chipid;
 
-	if (p->io_type == HIF_SDIO) {
+	if (wilc->io_type == HIF_SDIO) {
 		reg = 0;
 		reg |= BIT(3);
-	} else if (p->io_type == HIF_SPI) {
+	} else if (wilc->io_type == HIF_SPI) {
 		reg = 1;
 	}
 	acquire_bus(wilc, ACQUIRE_ONLY);
@@ -1245,7 +1243,7 @@ int wilc_wlan_start(struct wilc *wilc)
 		return ret;
 	}
 	reg = 0;
-	if (p->io_type == HIF_SDIO && wilc->dev_irq_num)
+	if (wilc->io_type == HIF_SDIO && wilc->dev_irq_num)
 		reg |= WILC_HAVE_SDIO_IRQ_GPIO;
 
 #ifdef WILC_DISABLE_PMU
@@ -1627,7 +1625,6 @@ int wilc_wlan_init(struct net_device *dev)
 	PRINT_D(INIT_DBG, "Initializing WILC_Wlan ...\n");
 
 	memset((void *)&g_wlan, 0, sizeof(wilc_wlan_dev_t));
-	g_wlan.io_type = wilc->io_type;
 	if (!wilc->hif_func->hif_init(wilc, wilc_debug)) {
 		ret = -EIO;
 		goto _fail_;
-- 
1.9.1

