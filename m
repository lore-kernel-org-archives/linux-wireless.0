Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40725 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbcAYHmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:42:21 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 02/26] staging: wilc1000: remove define WILC_OPTIMIZE_SLEEP_INT
Date: Mon, 25 Jan 2016 16:35:06 +0900
Message-ID: <1453707330-13526-3-git-send-email-glen.lee@atmel.com> (sfid-20160125_084224_188936_BD54E1AC)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Take the codes of WILC_OPTIMIZE_SLEEP_INT and remove codes inside ifndef.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 74 +-----------------------------------
 1 file changed, 2 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 07460ff..dabb0bd 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -3,9 +3,7 @@
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
-#ifdef WILC_OPTIMIZE_SLEEP_INT
 static inline void chip_allow_sleep(struct wilc *wilc);
-#endif
 static inline void chip_wakeup(struct wilc *wilc);
 static u32 dbgflag = N_INIT | N_ERR | N_INTR | N_TXQ | N_RXQ;
 
@@ -29,21 +27,14 @@ static CHIP_PS_STATE_T chip_ps_state = CHIP_WAKEDUP;
 static inline void acquire_bus(struct wilc *wilc, BUS_ACQUIRE_T acquire)
 {
 	mutex_lock(&wilc->hif_cs);
-	#ifndef WILC_OPTIMIZE_SLEEP_INT
-	if (chip_ps_state != CHIP_WAKEDUP)
-	#endif
-	{
-		if (acquire == ACQUIRE_AND_WAKEUP)
-			chip_wakeup(wilc);
-	}
+	if (acquire == ACQUIRE_AND_WAKEUP)
+		chip_wakeup(wilc);
 }
 
 static inline void release_bus(struct wilc *wilc, BUS_RELEASE_T release)
 {
-	#ifdef WILC_OPTIMIZE_SLEEP_INT
 	if (release == RELEASE_ALLOW_SLEEP)
 		chip_allow_sleep(wilc);
-	#endif
 	mutex_unlock(&wilc->hif_cs);
 }
 
@@ -524,8 +515,6 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 	return NULL;
 }
 
-#ifdef WILC_OPTIMIZE_SLEEP_INT
-
 static inline void chip_allow_sleep(struct wilc *wilc)
 {
 	u32 reg = 0;
@@ -538,7 +527,6 @@ static inline void chip_allow_sleep(struct wilc *wilc)
 static inline void chip_wakeup(struct wilc *wilc)
 {
 	u32 reg, clk_status_reg, trials = 0;
-	u32 sleep_time;
 
 	if ((wilc->io_type & 0x1) == HIF_SPI) {
 		do {
@@ -597,66 +585,14 @@ static inline void chip_wakeup(struct wilc *wilc)
 	}
 	chip_ps_state = CHIP_WAKEDUP;
 }
-#else
-static inline void chip_wakeup(struct wilc *wilc)
-{
-	u32 reg, trials = 0;
-
-	do {
-		if ((wilc->io_type & 0x1) == HIF_SPI) {
-			wilc->hif_func->hif_read_reg(wilc, 1, &reg);
-			wilc->hif_func->hif_write_reg(wilc, 1, reg & ~BIT(1));
-			wilc->hif_func->hif_write_reg(wilc, 1, reg | BIT(1));
-			wilc->hif_func->hif_write_reg(wilc, 1, reg  & ~BIT(1));
-		} else if ((wilc->io_type & 0x1) == HIF_SDIO)	 {
-			wilc->hif_func->hif_read_reg(wilc, 0xf0, &reg);
-			wilc->hif_func->hif_write_reg(wilc, 0xf0,
-						      reg & ~BIT(0));
-			wilc->hif_func->hif_write_reg(wilc, 0xf0,
-						      reg | BIT(0));
-			wilc->hif_func->hif_write_reg(wilc, 0xf0,
-						      reg  & ~BIT(0));
-		}
-
-		do {
-			mdelay(3);
-
-			if ((wilc_get_chipid(wilc, true) == 0))
-				wilc_debug(N_ERR, "Couldn't read chip id. Wake up failed\n");
-
-		} while ((wilc_get_chipid(wilc, true) == 0) && ((++trials % 3) == 0));
-
-	} while (wilc_get_chipid(wilc, true) == 0);
 
-	if (chip_ps_state == CHIP_SLEEPING_MANUAL) {
-		wilc->hif_func->hif_read_reg(wilc, 0x1C0C, &reg);
-		reg &= ~BIT(0);
-		wilc->hif_func->hif_write_reg(wilc, 0x1C0C, reg);
-
-		if (wilc_get_chipid(wilc, false) >= 0x1002b0) {
-			u32 val32;
-
-			wilc->hif_func->hif_read_reg(wilc, 0x1e1c, &val32);
-			val32 |= BIT(6);
-			wilc->hif_func->hif_write_reg(wilc, 0x1e1c, val32);
-
-			wilc->hif_func->hif_read_reg(wilc, 0x1e9c, &val32);
-			val32 |= BIT(6);
-			wilc->hif_func->hif_write_reg(wilc, 0x1e9c, val32);
-		}
-	}
-	chip_ps_state = CHIP_WAKEDUP;
-}
-#endif
 void wilc_chip_sleep_manually(struct wilc *wilc)
 {
 	if (chip_ps_state != CHIP_WAKEDUP)
 		return;
 	acquire_bus(wilc, ACQUIRE_ONLY);
 
-#ifdef WILC_OPTIMIZE_SLEEP_INT
 	chip_allow_sleep(wilc);
-#endif
 	wilc->hif_func->hif_write_reg(wilc, 0x10a8, 1);
 
 	chip_ps_state = CHIP_SLEEPING_MANUAL;
@@ -1041,9 +977,6 @@ static void wilc_pllupdate_isr_ext(struct wilc *wilc, u32 int_stats)
 static void wilc_sleeptimer_isr_ext(struct wilc *wilc, u32 int_stats1)
 {
 	wilc->hif_func->hif_clear_int_ext(wilc, SLEEP_INT_CLR);
-#ifndef WILC_OPTIMIZE_SLEEP_INT
-	chip_ps_state = CHIP_SLEEPING_AUTO;
-#endif
 }
 
 static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
@@ -1113,9 +1046,6 @@ void wilc_handle_isr(struct wilc *wilc)
 
 	if (int_status & DATA_INT_EXT) {
 		wilc_wlan_handle_isr_ext(wilc, int_status);
-	#ifndef WILC_OPTIMIZE_SLEEP_INT
-		chip_ps_state = CHIP_WAKEDUP;
-	#endif
 	}
 	if (int_status & SLEEP_INT_EXT)
 		wilc_sleeptimer_isr_ext(wilc, int_status);
-- 
1.9.1

