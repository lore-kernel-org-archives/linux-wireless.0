Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58088 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbbG3JLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 05:11:07 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 5/5] staging: wilc1000: remove unused functions
Date: Thu, 30 Jul 2015 18:10:14 +0900
Message-ID: <1438247414-19708-6-git-send-email-tony.cho@atmel.com> (sfid-20150730_111111_742363_A1CB6DF1)
In-Reply-To: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
References: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the dead functions which are not used anymore.
	- sdio_check_bs
	- sdio_xfer_cnt

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
V2: This patch doesn't have any difference with the first patch becasue
this patch just removes unnecessary functions. However, it is resent
because it's not accepted with the 9th patch which has a problem.
---
 drivers/staging/wilc1000/wilc_sdio.c | 56 ------------------------------------
 drivers/staging/wilc1000/wilc_wlan.c |  1 -
 2 files changed, 57 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index c52044a..44421d0 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -186,67 +186,11 @@ static int sdio_clear_int(void)
 }
 #endif /* WILC_SDIO_IRQ_GPIO */
 
-uint32_t sdio_xfer_cnt(void)
-{
-	uint32_t cnt = 0;
-	sdio_cmd52_t cmd;
-
-	cmd.read_write = 0;
-	cmd.function = 1;
-	cmd.raw = 0;
-	cmd.address = 0x1C;
-	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
-	cnt = cmd.data;
-
-	cmd.read_write = 0;
-	cmd.function = 1;
-	cmd.raw = 0;
-	cmd.address = 0x1D;
-	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
-	cnt |= (cmd.data << 8);
-
-	cmd.read_write = 0;
-	cmd.function = 1;
-	cmd.raw = 0;
-	cmd.address = 0x1E;
-	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
-	cnt |= (cmd.data << 16);
-
-	return cnt;
-}
-
 /********************************************
  *
  *      Sdio interfaces
  *
  ********************************************/
-int sdio_check_bs(void)
-{
-	sdio_cmd52_t cmd;
-
-	/**
-	 *      poll until BS is 0
-	 **/
-	cmd.read_write = 0;
-	cmd.function = 0;
-	cmd.raw = 0;
-	cmd.address = 0xc;
-	cmd.data = 0;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, get BS register...\n");
-		goto _fail_;
-	}
-
-	return 1;
-
-_fail_:
-
-	return 0;
-}
-
 static int sdio_write_reg(uint32_t addr, uint32_t data)
 {
 #ifdef BIG_ENDIAN
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index def72fd..68c38ec 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -25,7 +25,6 @@ extern u8 g_wilc_initialized; /* AMR : 0422 RK3026 Crash issue */
 #endif
 extern void WILC_WFI_mgmt_rx(uint8_t *buff, uint32_t size);
 extern void frmw_to_linux(uint8_t *buff, uint32_t size);
-int sdio_xfer_cnt(void);
 uint32_t wilc_get_chipid(uint8_t update);
 u16 Set_machw_change_vir_if(bool bValue);
 
-- 
1.9.1

