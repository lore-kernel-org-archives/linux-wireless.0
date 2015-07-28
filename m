Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47909 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbbG1Is3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:48:29 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/21] staging: wilc1000: remove warnings on the multiple line uses
Date: Tue, 28 Jul 2015 17:47:23 +0900
Message-ID: <1438073261-28315-5-git-send-email-tony.cho@atmel.com> (sfid-20150728_104836_916934_FDD8ED4B)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings reported by checkpatch.pl for using
multiple blank lines.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 897e47e..632b2b0 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -10,7 +10,6 @@
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
-
 #ifdef WILC1000_SINGLE_TRANSFER
 #define WILC_SDIO_BLOCK_SIZE 256
 #else
@@ -90,7 +89,6 @@ static int sdio_set_func0_csa_address_byte0(uint32_t adr)
 {
 	sdio_cmd52_t cmd;
 
-
 	/**
 	 *      Review: BIG ENDIAN
 	 **/
@@ -222,8 +220,6 @@ uint32_t sdio_xfer_cnt(void)
 	cnt |= (cmd.data << 16);
 
 	return cnt;
-
-
 }
 
 /********************************************
@@ -412,7 +408,6 @@ static int sdio_write(uint32_t addr, uint8_t *buf, uint32_t size)
 
 		}
 
-
 		if (rest > 0) {
 			cmd.block_mode = 1;
 			cmd.increment = 1;
@@ -458,7 +453,6 @@ static int sdio_write(uint32_t addr, uint8_t *buf, uint32_t size)
 #endif /* platform */
 	}
 
-
 	if (nleft > 0) {
 		cmd.block_mode = 0;
 		cmd.increment = 1;
@@ -622,7 +616,6 @@ static int sdio_read(uint32_t addr, uint8_t *buf, uint32_t size)
 			cmd.buffer = buf;
 			cmd.block_size = block_size;
 
-
 			if (addr > 0) {
 				if (!sdio_set_func0_csa_address(addr))
 					goto _fail_;
@@ -639,7 +632,6 @@ static int sdio_read(uint32_t addr, uint8_t *buf, uint32_t size)
 
 		}
 
-
 		if (rest > 0) {
 			cmd.block_mode = 1;
 			cmd.increment = 1;
@@ -898,7 +890,6 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	}
 	g_sdio.dPrint(N_ERR, "[wilc sdio]: has_thrpt_enh3 = %d...\n", g_sdio.has_thrpt_enh3);
 
-
 	return 1;
 
 _fail_:
@@ -1097,7 +1088,6 @@ static int sdio_clear_int_ext(uint32_t val)
 		}
 #endif /* WILC_SDIO_IRQ_GPIO */
 
-
 		{
 			uint32_t vmm_ctl;
 
@@ -1138,7 +1128,6 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 {
 	uint32_t reg;
 
-
 	if (nint > MAX_NUM_INT) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Too many interupts (%d)...\n", nint);
 		return 0;
@@ -1148,7 +1137,6 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 		return 0;
 	}
 
-
 	g_sdio.nint = nint;
 
 	/**
@@ -1170,7 +1158,6 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 		uint32_t reg;
 		int ret, i;
 
-
 		/**
 		 *      interrupt pin mux select
 		 **/
@@ -1225,7 +1212,6 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 	return 1;
 }
 
-
 /********************************************
  *
  *      Global sdio HIF function table
-- 
1.9.1

