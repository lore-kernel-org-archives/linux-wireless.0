Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47930 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbbG1Isg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:48:36 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/21] staging: wilc1000: remove the warnings on missing blank line
Date: Tue, 28 Jul 2015 17:47:24 +0900
Message-ID: <1438073261-28315-6-git-send-email-tony.cho@atmel.com> (sfid-20150728_104846_533922_A0C43EE8)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings reported by checkpatch.pl on missing a blank
line after declaration.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 632b2b0..6e865d4 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -168,6 +168,7 @@ static int sdio_clear_int(void)
 #ifndef WILC_SDIO_IRQ_GPIO
 	/* uint32_t sts; */
 	sdio_cmd52_t cmd;
+
 	cmd.read_write = 0;
 	cmd.function = 1;
 	cmd.raw = 0;
@@ -179,6 +180,7 @@ static int sdio_clear_int(void)
 	return cmd.data;
 #else
 	uint32_t reg;
+
 	if (!sdio_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
 		g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_HOST_RX_CTRL_0);
 		return 0;
@@ -195,6 +197,7 @@ uint32_t sdio_xfer_cnt(void)
 {
 	uint32_t cnt = 0;
 	sdio_cmd52_t cmd;
+
 	cmd.read_write = 0;
 	cmd.function = 1;
 	cmd.raw = 0;
@@ -259,6 +262,7 @@ static int sdio_write_reg(uint32_t addr, uint32_t data)
 
 	if ((addr >= 0xf0) && (addr <= 0xff)) {
 		sdio_cmd52_t cmd;
+
 		cmd.read_write = 1;
 		cmd.function = 0;
 		cmd.raw = 0;
@@ -482,6 +486,7 @@ static int sdio_read_reg(uint32_t addr, uint32_t *data)
 {
 	if ((addr >= 0xf0) && (addr <= 0xff)) {
 		sdio_cmd52_t cmd;
+
 		cmd.read_write = 0;
 		cmd.function = 0;
 		cmd.raw = 0;
@@ -776,6 +781,7 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	sdio_cmd52_t cmd;
 	int loop;
 	uint32_t chipid;
+
 	memset(&g_sdio, 0, sizeof(wilc_sdio_t));
 
 	g_sdio.dPrint = func;
@@ -977,6 +983,7 @@ static int sdio_read_int(uint32_t *int_status)
 	}
 	{
 		int i;
+
 		for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
 			if ((tmp >> (IRG_FLAGS_OFFSET + i)) & 0x1) {
 				g_sdio.dPrint(N_ERR, "[wilc sdio]: Unexpected interrupt (1) : tmp=%x, data=%x\n", tmp, cmd.data);
@@ -1015,6 +1022,7 @@ static int sdio_clear_int_ext(uint32_t val)
 #ifdef WILC_SDIO_IRQ_GPIO
 		{
 			uint32_t flags;
+
 			flags = val & ((1 << MAX_NUN_INT_THRPT_ENH2) - 1);
 			reg = flags;
 		}
@@ -1032,6 +1040,7 @@ static int sdio_clear_int_ext(uint32_t val)
 			reg |= (1 << 7);
 		if (reg) {
 			sdio_cmd52_t cmd;
+
 			cmd.read_write = 1;
 			cmd.function = 0;
 			cmd.raw = 0;
@@ -1051,6 +1060,7 @@ static int sdio_clear_int_ext(uint32_t val)
 			/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
 			/* Cannot clear multiple interrupts. Must clear each interrupt individually */
 			uint32_t flags;
+
 			flags = val & ((1 << MAX_NUM_INT) - 1);
 			if (flags) {
 				int i;
@@ -1059,6 +1069,7 @@ static int sdio_clear_int_ext(uint32_t val)
 				for (i = 0; i < g_sdio.nint; i++) {
 					if (flags & 1) {
 						sdio_cmd52_t cmd;
+
 						cmd.read_write = 1;
 						cmd.function = 0;
 						cmd.raw = 0;
-- 
1.9.1

