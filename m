Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47947 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbbG1Isn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:48:43 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/21] staging: wilc1000: remove the warnings on unnecessary braces
Date: Tue, 28 Jul 2015 17:47:25 +0900
Message-ID: <1438073261-28315-7-git-send-email-tony.cho@atmel.com> (sfid-20150728_104851_329105_443A5159)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings reported by checkpatch.pl on {} not
necessary for the single statement blocks.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 6e865d4..967df95 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -106,6 +106,7 @@ static int sdio_set_func0_csa_address_byte0(uint32_t adr)
 _fail_:
 	return 0;
 }
+
 static int sdio_set_func0_block_size(uint32_t block_size)
 {
 	sdio_cmd52_t cmd;
@@ -963,24 +964,18 @@ static int sdio_read_int(uint32_t *int_status)
 	cmd.data = 0;
 	g_sdio.sdio_cmd52(&cmd);
 
-	if (cmd.data & (1 << 0)) {
+	if (cmd.data & (1 << 0))
 		tmp |= INT_0;
-	}
-	if (cmd.data & (1 << 2)) {
+	if (cmd.data & (1 << 2))
 		tmp |= INT_1;
-	}
-	if (cmd.data & (1 << 3)) {
+	if (cmd.data & (1 << 3))
 		tmp |= INT_2;
-	}
-	if (cmd.data & (1 << 4)) {
+	if (cmd.data & (1 << 4))
 		tmp |= INT_3;
-	}
-	if (cmd.data & (1 << 5)) {
+	if (cmd.data & (1 << 5))
 		tmp |= INT_4;
-	}
-	if (cmd.data & (1 << 6)) {
+	if (cmd.data & (1 << 6))
 		tmp |= INT_5;
-	}
 	{
 		int i;
 
@@ -1087,9 +1082,8 @@ static int sdio_clear_int_ext(uint32_t val)
 						break;
 					flags >>= 1;
 				}
-				if (!ret) {
+				if (!ret)
 					goto _fail_;
-				}
 				for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
 					if (flags & 1)
 						g_sdio.dPrint(N_ERR, "[wilc sdio]: Unexpected interrupt cleared %d...\n", i);
@@ -1193,9 +1187,8 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 			return 0;
 		}
 
-		for (i = 0; (i < 5) && (nint > 0); i++, nint--) {
+		for (i = 0; (i < 5) && (nint > 0); i++, nint--)
 			reg |= (1 << (27 + i));
-		}
 		ret = sdio_write_reg(WILC_INTR_ENABLE, reg);
 		if (!ret) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
@@ -1208,9 +1201,8 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 				return 0;
 			}
 
-			for (i = 0; (i < 3) && (nint > 0); i++, nint--) {
+			for (i = 0; (i < 3) && (nint > 0); i++, nint--)
 				reg |= (1 << i);
-			}
 
 			ret = sdio_read_reg(WILC_INTR2_ENABLE, &reg);
 			if (!ret) {
-- 
1.9.1

