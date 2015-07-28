Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48012 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbbG1ItD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:49:03 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/21] staging: wilc1000: #ifdef conditionals cover entire functions
Date: Tue, 28 Jul 2015 17:47:28 +0900
Message-ID: <1438073261-28315-10-git-send-email-tony.cho@atmel.com> (sfid-20150728_104911_678543_3BDA4657)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch lets preprocessor conditionals (#ifdef) related to
WILC_SDIO_IRQ_GPIO to compile out the entire functions. Compiling out
the entire functions is preferred rather than portions of functions or
expressions becausue doing so makes code harder to read.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 482 +++++++++++++++++++++--------------
 1 file changed, 293 insertions(+), 189 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 8f674ad..83b8da9 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -155,22 +155,9 @@ _fail_:
 	return 0;
 }
 
+#ifdef WILC_SDIO_IRQ_GPIO
 static int sdio_clear_int(void)
 {
-#ifndef WILC_SDIO_IRQ_GPIO
-	/* uint32_t sts; */
-	sdio_cmd52_t cmd;
-
-	cmd.read_write = 0;
-	cmd.function = 1;
-	cmd.raw = 0;
-	cmd.address = 0x4;
-	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
-	int_clrd++;
-
-	return cmd.data;
-#else
 	uint32_t reg;
 
 	if (!sdio_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
@@ -181,9 +168,23 @@ static int sdio_clear_int(void)
 	sdio_write_reg(WILC_HOST_RX_CTRL_0, reg);
 	int_clrd++;
 	return 1;
-#endif
+}
+#else
+static int sdio_clear_int(void)
+{
+	sdio_cmd52_t cmd;
 
+	cmd.read_write = 0;
+	cmd.function = 1;
+	cmd.raw = 0;
+	cmd.address = 0x4;
+	cmd.data = 0;
+	g_sdio.sdio_cmd52(&cmd);
+	int_clrd++;
+
+	return cmd.data;
 }
+#endif /* WILC_SDIO_IRQ_GPIO */
 
 uint32_t sdio_xfer_cnt(void)
 {
@@ -521,14 +522,16 @@ static int sdio_deinit(void *pv)
 	return 1;
 }
 
+#ifdef WILC_SDIO_IRQ_GPIO
 static int sdio_sync(void)
 {
 	uint32_t reg;
+	int ret;
 
 	/**
 	 *      Disable power sequencer
 	 **/
-	if (!sdio_read_reg(WILC_MISC, &reg)) {
+	if(!sdio_read_reg(WILC_MISC, &reg)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read misc reg...\n");
 		return 0;
 	}
@@ -539,45 +542,60 @@ static int sdio_sync(void)
 		return 0;
 	}
 
-#ifdef WILC_SDIO_IRQ_GPIO
-	{
-		uint32_t reg;
-		int ret;
+	/**
+	 *      interrupt pin mux select
+	 **/
+	ret = sdio_read_reg(WILC_PIN_MUX_0, &reg);
+	if (!ret) {
+		g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
+		return 0;
+	}
+	reg |= (1 << 8);
+	ret = sdio_write_reg(WILC_PIN_MUX_0, reg);
+	if (!ret) {
+		g_sdio.dPrint(N_ERR, "[wilc spi]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
+		return 0;
+	}
 
-		/**
-		 *      interrupt pin mux select
-		 **/
-		ret = sdio_read_reg(WILC_PIN_MUX_0, &reg);
-		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
-			return 0;
-		}
-		reg |= (1 << 8);
-		ret = sdio_write_reg(WILC_PIN_MUX_0, reg);
-		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
-			return 0;
-		}
+	/**
+	 *      interrupt enable
+	 **/
+	ret = sdio_read_reg(WILC_INTR_ENABLE, &reg);
+	if (!ret) {
+		g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
+		return 0;
+	}
+	reg |= (1 << 16);
+	ret = sdio_write_reg(WILC_INTR_ENABLE, reg);
+	if (!ret) {
+		g_sdio.dPrint(N_ERR, "[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
+		return 0;
+	}
 
-		/**
-		 *      interrupt enable
-		 **/
-		ret = sdio_read_reg(WILC_INTR_ENABLE, &reg);
-		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
-			return 0;
-		}
-		reg |= (1 << 16);
-		ret = sdio_write_reg(WILC_INTR_ENABLE, reg);
-		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
-			return 0;
-		}
+	return 1;
+}
+#else
+static int sdio_sync(void)
+{
+	uint32_t reg;
+
+	/**
+	 *      Disable power sequencer
+	 **/
+	if (!sdio_read_reg(WILC_MISC, &reg)) {
+		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read misc reg...\n");
+		return 0;
+	}
+
+	reg &= ~(1 << 8);
+	if (!sdio_write_reg(WILC_MISC, reg)) {
+		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write misc reg...\n");
+		return 0;
 	}
-#endif
 
 	return 1;
 }
+#endif /* WILC_SDIO_IRQ_GPIO */
 
 static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 {
@@ -747,18 +765,40 @@ static int sdio_read_size(uint32_t *size)
 	return 1;
 }
 
+#ifdef WILC_SDIO_IRQ_GPIO
 static int sdio_read_int(uint32_t *int_status)
 {
+	uint32_t tmp;
+	sdio_cmd52_t cmd;
+	uint32_t irq_flags;
+
+	sdio_read_size(&tmp);
+
+	cmd.read_write = 0;
+	cmd.function = 0;
+	cmd.raw = 0;
+	cmd.address = 0xf7;
+	cmd.data = 0;
+	g_sdio.sdio_cmd52(&cmd);
+	irq_flags = cmd.data & 0x1f;
+	tmp |= ((irq_flags >> 0) << IRG_FLAGS_OFFSET);
+
+	*int_status = tmp;
 
+	return 1;
+}
+#else
+static int sdio_read_int(uint32_t *int_status)
+{
 	uint32_t tmp;
 	sdio_cmd52_t cmd;
+	int i;
 
 	sdio_read_size(&tmp);
 
 	/**
 	 *      Read IRQ flags
 	 **/
-#ifndef WILC_SDIO_IRQ_GPIO
 	/* cmd.read_write = 0; */
 	cmd.function = 1;
 	/* cmd.raw = 0; */
@@ -778,54 +818,29 @@ static int sdio_read_int(uint32_t *int_status)
 		tmp |= INT_4;
 	if (cmd.data & (1 << 6))
 		tmp |= INT_5;
-	{
-		int i;
 
-		for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
-			if ((tmp >> (IRG_FLAGS_OFFSET + i)) & 0x1) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Unexpected interrupt (1) : tmp=%x, data=%x\n", tmp, cmd.data);
-				break;
-			}
+	for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
+		if ((tmp >> (IRG_FLAGS_OFFSET + i)) & 0x1) {
+			g_sdio.dPrint(N_ERR, "[wilc sdio]: Unexpected interrupt (1) : tmp=%x, data=%x\n", tmp, cmd.data);
+			break;
 		}
 	}
-#else
-	{
-		uint32_t irq_flags;
-
-		cmd.read_write = 0;
-		cmd.function = 0;
-		cmd.raw = 0;
-		cmd.address = 0xf7;
-		cmd.data = 0;
-		g_sdio.sdio_cmd52(&cmd);
-		irq_flags = cmd.data & 0x1f;
-		tmp |= ((irq_flags >> 0) << IRG_FLAGS_OFFSET);
-	}
-
-#endif
 
 	*int_status = tmp;
 
 	return 1;
 }
+#endif	/* WILC_SDIO_IRQ_GPIO */
 
+#ifdef WILC_SDIO_IRQ_GPIO
 static int sdio_clear_int_ext(uint32_t val)
 {
 	int ret;
 
-	if (g_sdio.has_thrpt_enh3) {
+	if(g_sdio.has_thrpt_enh3) {
 		uint32_t reg;
+		reg = val & ((1 << MAX_NUN_INT_THRPT_ENH2) - 1);
 
-#ifdef WILC_SDIO_IRQ_GPIO
-		{
-			uint32_t flags;
-
-			flags = val & ((1 << MAX_NUN_INT_THRPT_ENH2) - 1);
-			reg = flags;
-		}
-#else
-		reg = 0;
-#endif
 		/* select VMM table 0 */
 		if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
 			reg |= (1 << 5);
@@ -852,76 +867,68 @@ static int sdio_clear_int_ext(uint32_t val)
 
 		}
 	} else {
-#ifdef WILC_SDIO_IRQ_GPIO
-		{
-			/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
-			/* Cannot clear multiple interrupts. Must clear each interrupt individually */
-			uint32_t flags;
-
-			flags = val & ((1 << MAX_NUM_INT) - 1);
-			if (flags) {
-				int i;
-
-				ret = 1;
-				for (i = 0; i < g_sdio.nint; i++) {
-					if (flags & 1) {
-						sdio_cmd52_t cmd;
-
-						cmd.read_write = 1;
-						cmd.function = 0;
-						cmd.raw = 0;
-						cmd.address = 0xf8;
-						cmd.data = (1 << i);
-
-						ret = g_sdio.sdio_cmd52(&cmd);
-						if (!ret) {
-							g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
-							goto _fail_;
-						}
-
+		/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
+		/* Cannot clear multiple interrupts. Must clear each interrupt individually */
+		uint32_t flags;
+		uint32_t vmm_ctl;
+
+		flags = val & ((1 << MAX_NUM_INT) - 1);
+		if (flags) {
+			int i;
+
+			ret = 1;
+			for (i = 0; i < g_sdio.nint; i++) {
+				if (flags & 1) {
+					sdio_cmd52_t cmd;
+
+					cmd.read_write = 1;
+					cmd.function = 0;
+					cmd.raw = 0;
+					cmd.address = 0xf8;
+					cmd.data = (1 << i);
+
+					ret = g_sdio.sdio_cmd52(&cmd);
+					if (!ret) {
+						g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
+						goto _fail_;
 					}
-					if (!ret)
-						break;
-					flags >>= 1;
 				}
 				if (!ret)
-					goto _fail_;
-				for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
-					if (flags & 1)
-						g_sdio.dPrint(N_ERR, "[wilc sdio]: Unexpected interrupt cleared %d...\n", i);
-					flags >>= 1;
-				}
+					break;
+				flags >>= 1;
+			}
+			if (!ret)
+				goto _fail_;
+			for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
+				if (flags & 1)
+					g_sdio.dPrint(N_ERR, "[wilc sdio]: Unexpected interrupt cleared %d...\n", i);
+				flags >>= 1;
 			}
 		}
-#endif /* WILC_SDIO_IRQ_GPIO */
 
-		{
-			uint32_t vmm_ctl;
-
-			vmm_ctl = 0;
-			/* select VMM table 0 */
-			if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
-				vmm_ctl |= (1 << 0);
-			/* select VMM table 1 */
-			if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
-				vmm_ctl |= (1 << 1);
-			/* enable VMM */
-			if ((val & EN_VMM) == EN_VMM)
-				vmm_ctl |= (1 << 2);
-
-			if (vmm_ctl) {
-				sdio_cmd52_t cmd;
-
-				cmd.read_write = 1;
-				cmd.function = 0;
-				cmd.raw = 0;
-				cmd.address = 0xf6;
-				cmd.data = vmm_ctl;
-				ret = g_sdio.sdio_cmd52(&cmd);
-				if (!ret) {
-					g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf6 data (%d) ...\n", __LINE__);
-					goto _fail_;
-				}
+		vmm_ctl = 0;
+		/* select VMM table 0 */
+		if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
+			vmm_ctl |= (1 << 0);
+		/* select VMM table 1 */
+		if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
+			vmm_ctl |= (1 << 1);
+		/* enable VMM */
+		if ((val & EN_VMM) == EN_VMM)
+			vmm_ctl |= (1 << 2);
+
+		if (vmm_ctl) {
+			sdio_cmd52_t cmd;
+
+			cmd.read_write = 1;
+			cmd.function = 0;
+			cmd.raw = 0;
+			cmd.address = 0xf6;
+			cmd.data = vmm_ctl;
+			ret = g_sdio.sdio_cmd52(&cmd);
+			if (!ret) {
+				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf6 data (%d) ...\n", __LINE__);
+				goto _fail_;
 			}
 		}
 	}
@@ -930,10 +937,80 @@ static int sdio_clear_int_ext(uint32_t val)
 _fail_:
 	return 0;
 }
+#else
+static int sdio_clear_int_ext(uint32_t val)
+{
+	int ret;
+
+	if (g_sdio.has_thrpt_enh3) {
+		uint32_t reg = 0;
 
+		/* select VMM table 0 */
+		if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
+			reg |= (1 << 5);
+		/* select VMM table 1 */
+		if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
+			reg |= (1 << 6);
+		/* enable VMM */
+		if ((val & EN_VMM) == EN_VMM)
+			reg |= (1 << 7);
+		if (reg) {
+			sdio_cmd52_t cmd;
+
+			cmd.read_write = 1;
+			cmd.function = 0;
+			cmd.raw = 0;
+			cmd.address = 0xf8;
+			cmd.data = reg;
+
+			ret = g_sdio.sdio_cmd52(&cmd);
+			if (!ret) {
+				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
+				goto _fail_;
+			}
+
+		}
+	} else {
+		uint32_t vmm_ctl;
+
+		vmm_ctl = 0;
+		/* select VMM table 0 */
+		if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
+			vmm_ctl |= (1 << 0);
+		/* select VMM table 1 */
+		if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
+			vmm_ctl |= (1 << 1);
+		/* enable VMM */
+		if ((val & EN_VMM) == EN_VMM)
+			vmm_ctl |= (1 << 2);
+
+		if (vmm_ctl) {
+			sdio_cmd52_t cmd;
+
+			cmd.read_write = 1;
+			cmd.function = 0;
+			cmd.raw = 0;
+			cmd.address = 0xf6;
+			cmd.data = vmm_ctl;
+			ret = g_sdio.sdio_cmd52(&cmd);
+			if (!ret) {
+				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf6 data (%d) ...\n", __LINE__);
+				goto _fail_;
+			}
+		}
+	}
+
+	return 1;
+_fail_:
+	return 0;
+}
+#endif	/* WILC_SDIO_IRQ_GPIO */
+
+#ifdef WILC_SDIO_IRQ_GPIO
 static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 {
 	uint32_t reg;
+	int ret, i;
 
 	if (nint > MAX_NUM_INT) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Too many interupts (%d)...\n", nint);
@@ -960,62 +1037,89 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 		return 0;
 	}
 
-#ifdef WILC_SDIO_IRQ_GPIO
-	{
-		uint32_t reg;
-		int ret, i;
+	/**
+	 *      interrupt pin mux select
+	 **/
+	ret = sdio_read_reg(WILC_PIN_MUX_0, &reg);
+	if (!ret) {
+		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
+		return 0;
+	}
+	reg |= (1 << 8);
+	ret = sdio_write_reg(WILC_PIN_MUX_0, reg);
+	if (!ret) {
+		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
+		return 0;
+	}
 
-		/**
-		 *      interrupt pin mux select
-		 **/
-		ret = sdio_read_reg(WILC_PIN_MUX_0, &reg);
-		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
-			return 0;
-		}
-		reg |= (1 << 8);
-		ret = sdio_write_reg(WILC_PIN_MUX_0, reg);
-		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
-			return 0;
-		}
+	/**
+	 *      interrupt enable
+	 **/
+	ret = sdio_read_reg(WILC_INTR_ENABLE, &reg);
+	if (!ret) {
+		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
+		return 0;
+	}
 
-		/**
-		 *      interrupt enable
-		 **/
-		ret = sdio_read_reg(WILC_INTR_ENABLE, &reg);
+	for (i = 0; (i < 5) && (nint > 0); i++, nint--)
+		reg |= (1 << (27 + i));
+	ret = sdio_write_reg(WILC_INTR_ENABLE, reg);
+	if (!ret) {
+		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
+		return 0;
+	}
+	if (nint) {
+		ret = sdio_read_reg(WILC_INTR2_ENABLE, &reg);
 		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
+			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_INTR2_ENABLE);
 			return 0;
 		}
 
-		for (i = 0; (i < 5) && (nint > 0); i++, nint--)
-			reg |= (1 << (27 + i));
-		ret = sdio_write_reg(WILC_INTR_ENABLE, reg);
+		for (i = 0; (i < 3) && (nint > 0); i++, nint--)
+			reg |= (1 << i);
+
+		ret = sdio_read_reg(WILC_INTR2_ENABLE, &reg);
 		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
+			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_INTR2_ENABLE);
 			return 0;
 		}
-		if (nint) {
-			ret = sdio_read_reg(WILC_INTR2_ENABLE, &reg);
-			if (!ret) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_INTR2_ENABLE);
-				return 0;
-			}
+	}
+
+	return 1;
+}
+#else
+static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
+{
+	uint32_t reg;
 
-			for (i = 0; (i < 3) && (nint > 0); i++, nint--)
-				reg |= (1 << i);
+	if (nint > MAX_NUM_INT) {
+		g_sdio.dPrint(N_ERR, "[wilc sdio]: Too many interupts (%d)...\n", nint);
+		return 0;
+	}
+	if (nint > MAX_NUN_INT_THRPT_ENH2) {
+		g_sdio.dPrint(N_ERR, "[wilc sdio]: Error: Cannot support more than 5 interrupts when has_thrpt_enh2=1.\n");
+		return 0;
+	}
 
-			ret = sdio_read_reg(WILC_INTR2_ENABLE, &reg);
-			if (!ret) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_INTR2_ENABLE);
-				return 0;
-			}
-		}
+	g_sdio.nint = nint;
+
+	/**
+	 *      Disable power sequencer
+	 **/
+	if (!sdio_read_reg(WILC_MISC, &reg)) {
+		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read misc reg...\n");
+		return 0;
 	}
-#endif /* WILC_SDIO_IRQ_GPIO */
+
+	reg &= ~(1 << 8);
+	if (!sdio_write_reg(WILC_MISC, reg)) {
+		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write misc reg...\n");
+		return 0;
+	}
+
 	return 1;
 }
+#endif	/* WILC_SDIO_IRQ_GPIO */
 
 /********************************************
  *
-- 
1.9.1

