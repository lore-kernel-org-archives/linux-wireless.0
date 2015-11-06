Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36532 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031107AbbKFCLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:11:21 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/73] staging: wilc1000: rename genuChipPSstate variable
Date: Fri, 6 Nov 2015 11:12:30 +0900
Message-ID: <1446776014-28094-9-git-send-email-glen.lee@atmel.com> (sfid-20151106_031123_966608_7BA1D41E)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename genuChipPSstate variable to chip_ps_state
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7ebfcaf..c393e52 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -55,13 +55,13 @@ static void wilc_debug(u32 flag, char *fmt, ...)
 	}
 }
 
-static CHIP_PS_STATE_T genuChipPSstate = CHIP_WAKEDUP;
+static CHIP_PS_STATE_T chip_ps_state = CHIP_WAKEDUP;
 
 static inline void acquire_bus(BUS_ACQUIRE_T acquire)
 {
 	mutex_lock(&g_linux_wlan->hif_cs);
 	#ifndef WILC_OPTIMIZE_SLEEP_INT
-	if (genuChipPSstate != CHIP_WAKEDUP)
+	if (chip_ps_state != CHIP_WAKEDUP)
 	#endif
 	{
 		if (acquire == ACQUIRE_AND_WAKEUP)
@@ -606,7 +606,7 @@ static inline void chip_wakeup(void)
 		} while ((clk_status_reg & 0x1) == 0);
 	}
 
-	if (genuChipPSstate == CHIP_SLEEPING_MANUAL) {
+	if (chip_ps_state == CHIP_SLEEPING_MANUAL) {
 		g_wlan.hif_func.hif_read_reg(0x1C0C, &reg);
 		reg &= ~BIT(0);
 		g_wlan.hif_func.hif_write_reg(0x1C0C, reg);
@@ -623,7 +623,7 @@ static inline void chip_wakeup(void)
 			g_wlan.hif_func.hif_write_reg(0x1e9c, val32);
 		}
 	}
-	genuChipPSstate = CHIP_WAKEDUP;
+	chip_ps_state = CHIP_WAKEDUP;
 }
 #else
 static inline void chip_wakeup(void)
@@ -653,7 +653,7 @@ static inline void chip_wakeup(void)
 
 	} while (wilc_get_chipid(true) == 0);
 
-	if (genuChipPSstate == CHIP_SLEEPING_MANUAL) {
+	if (chip_ps_state == CHIP_SLEEPING_MANUAL) {
 		g_wlan.hif_func.hif_read_reg(0x1C0C, &reg);
 		reg &= ~BIT(0);
 		g_wlan.hif_func.hif_write_reg(0x1C0C, reg);
@@ -670,12 +670,12 @@ static inline void chip_wakeup(void)
 			g_wlan.hif_func.hif_write_reg(0x1e9c, val32);
 		}
 	}
-	genuChipPSstate = CHIP_WAKEDUP;
+	chip_ps_state = CHIP_WAKEDUP;
 }
 #endif
 void chip_sleep_manually(u32 u32SleepTime)
 {
-	if (genuChipPSstate != CHIP_WAKEDUP)
+	if (chip_ps_state != CHIP_WAKEDUP)
 		return;
 	acquire_bus(ACQUIRE_ONLY);
 
@@ -684,7 +684,7 @@ void chip_sleep_manually(u32 u32SleepTime)
 #endif
 	g_wlan.hif_func.hif_write_reg(0x10a8, 1);
 
-	genuChipPSstate = CHIP_SLEEPING_MANUAL;
+	chip_ps_state = CHIP_SLEEPING_MANUAL;
 	release_bus(RELEASE_ONLY);
 }
 
@@ -1069,7 +1069,7 @@ static void wilc_sleeptimer_isr_ext(u32 int_stats1)
 {
 	g_wlan.hif_func.hif_clear_int_ext(SLEEP_INT_CLR);
 #ifndef WILC_OPTIMIZE_SLEEP_INT
-	genuChipPSstate = CHIP_SLEEPING_AUTO;
+	chip_ps_state = CHIP_SLEEPING_AUTO;
 #endif
 }
 
@@ -1158,7 +1158,7 @@ void wilc_handle_isr(void *wilc)
 	if (int_status & DATA_INT_EXT) {
 		wilc_wlan_handle_isr_ext(wilc, int_status);
 	#ifndef WILC_OPTIMIZE_SLEEP_INT
-		genuChipPSstate = CHIP_WAKEDUP;
+		chip_ps_state = CHIP_WAKEDUP;
 	#endif
 	}
 	if (int_status & SLEEP_INT_EXT)
-- 
1.9.1

