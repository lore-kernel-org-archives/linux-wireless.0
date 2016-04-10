Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:33611 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbcDJVGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 17:06:43 -0400
From: mohammed.billoo@gmail.com
To: johnny.kim@atmel.com
Cc: austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Mohammed Billoo <mohammed.billoo@gmail.com>
Subject: [PATCH] staging: wilc1000: rework comments in wilc_sdio.c
Date: Sun, 10 Apr 2016 17:05:25 -0400
Message-Id: <1460322325-29785-1-git-send-email-mohammed.billoo@gmail.com> (sfid-20160410_230658_491162_84622E0F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Billoo <mohammed.billoo@gmail.com>

Remove unnecessary comments (highlighting sections of functions), make
multiline comments into single line comments, and ensure that multiline
comments adhere to coding style.

Signed-off-by: Mohammed Billoo <mohammed.billoo@gmail.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 136 ++++++++---------------------------
 1 file changed, 31 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index a839a79..a082e12 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -1,11 +1,7 @@
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_sdio.c */
-/*  */
-/*  */
-/* //////////////////////////////////////////////////////////////////////////// */
+/* Copyright (c) Atmel Corporation.  All rights reserved.
+ *
+ * Module Name:  wilc_sdio.c
+ */
 
 #include <linux/string.h>
 #include "wilc_wlan_if.h"
@@ -257,11 +253,6 @@ static void wilc_sdio_disable_interrupt(struct wilc *dev)
 	dev_info(&func->dev, "wilc_sdio_disable_interrupt OUT\n");
 }
 
-/********************************************
- *
- *      Function 0
- *
- ********************************************/
 
 static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 {
@@ -269,9 +260,7 @@ static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 	struct sdio_cmd52 cmd;
 	int ret;
 
-	/**
-	 *      Review: BIG ENDIAN
-	 **/
+	/* Review: BIG ENDIAN */
 	cmd.read_write = 1;
 	cmd.function = 0;
 	cmd.raw = 0;
@@ -334,11 +323,6 @@ _fail_:
 	return 0;
 }
 
-/********************************************
- *
- *      Function 1
- *
- ********************************************/
 
 static int sdio_set_func1_block_size(struct wilc *wilc, u32 block_size)
 {
@@ -369,11 +353,7 @@ _fail_:
 	return 0;
 }
 
-/********************************************
- *
- *      Sdio interfaces
- *
- ********************************************/
+
 static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
@@ -398,9 +378,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 	} else {
 		struct sdio_cmd53 cmd;
 
-		/**
-		 *      set the AHB address
-		 **/
+		/* set the AHB address */
 		if (!sdio_set_func0_csa_address(wilc, addr))
 			goto _fail_;
 
@@ -436,31 +414,23 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 
 	cmd.read_write = 1;
 	if (addr > 0) {
-		/**
-		 *      has to be word aligned...
-		 **/
+		/* has to be word aligned... */
 		if (size & 0x3) {
 			size += 4;
 			size &= ~0x3;
 		}
 
-		/**
-		 *      func 0 access
-		 **/
+		/* func 0 access */
 		cmd.function = 0;
 		cmd.address = 0x10f;
 	} else {
-		/**
-		 *      has to be word aligned...
-		 **/
+		/* has to be word aligned... */
 		if (size & 0x3) {
 			size += 4;
 			size &= ~0x3;
 		}
 
-		/**
-		 *      func 1 access
-		 **/
+		/* func 1 access */
 		cmd.function = 1;
 		cmd.address = 0;
 	}
@@ -576,31 +546,23 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 
 	cmd.read_write = 0;
 	if (addr > 0) {
-		/**
-		 *      has to be word aligned...
-		 **/
+		/* has to be word aligned... */
 		if (size & 0x3) {
 			size += 4;
 			size &= ~0x3;
 		}
 
-		/**
-		 *      func 0 access
-		 **/
+		/* func 0 access */
 		cmd.function = 0;
 		cmd.address = 0x10f;
 	} else {
-		/**
-		 *      has to be word aligned...
-		 **/
+		/* has to be word aligned... */
 		if (size & 0x3) {
 			size += 4;
 			size &= ~0x3;
 		}
 
-		/**
-		 *      func 1 access
-		 **/
+		/* func 1 access */
 		cmd.function = 1;
 		cmd.address = 0;
 	}
@@ -627,7 +589,7 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 		if (addr > 0)
 			addr += nblk * block_size;
 		buf += nblk * block_size;
-	}       /* if (nblk > 0) */
+	}
 
 	if (nleft > 0) {
 		cmd.block_mode = 0;
@@ -656,11 +618,6 @@ _fail_:
 	return 0;
 }
 
-/********************************************
- *
- *      Bus interfaces
- *
- ********************************************/
 
 static int sdio_deinit(struct wilc *wilc)
 {
@@ -679,9 +636,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		g_sdio.irq_gpio = wilc->dev_irq_num;
 	}
 
-	/**
-	 *      function 0 csa enable
-	 **/
+	/* function 0 csa enable */
 	cmd.read_write = 1;
 	cmd.function = 0;
 	cmd.raw = 1;
@@ -693,18 +648,14 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		goto _fail_;
 	}
 
-	/**
-	 *      function 0 block size
-	 **/
+	/* function 0 block size */
 	if (!sdio_set_func0_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
 		dev_err(&func->dev, "Fail cmd 52, set func 0 block size...\n");
 		goto _fail_;
 	}
 	g_sdio.block_size = WILC_SDIO_BLOCK_SIZE;
 
-	/**
-	 *      enable func1 IO
-	 **/
+	/* enable func1 IO */
 	cmd.read_write = 1;
 	cmd.function = 0;
 	cmd.raw = 1;
@@ -717,9 +668,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		goto _fail_;
 	}
 
-	/**
-	 *      make sure func 1 is up
-	 **/
+	/* make sure func 1 is up */
 	cmd.read_write = 0;
 	cmd.function = 0;
 	cmd.raw = 0;
@@ -742,17 +691,13 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		goto _fail_;
 	}
 
-	/**
-	 *      func 1 is ready, set func 1 block size
-	 **/
+	/* func 1 is ready, set func 1 block size */
 	if (!sdio_set_func1_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
 		dev_err(&func->dev, "Fail set func 1 block size...\n");
 		goto _fail_;
 	}
 
-	/**
-	 *      func 1 interrupt enable
-	 **/
+	/* func 1 interrupt enable */
 	cmd.read_write = 1;
 	cmd.function = 0;
 	cmd.raw = 1;
@@ -764,9 +709,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		goto _fail_;
 	}
 
-	/**
-	 *      make sure can read back chip id correctly
-	 **/
+	/* make sure can read back chip id correctly */
 	if (!resume) {
 		if (!sdio_read_reg(wilc, 0x1000, &chipid)) {
 			dev_err(&func->dev, "Fail cmd read chip id...\n");
@@ -793,9 +736,7 @@ static int sdio_read_size(struct wilc *wilc, u32 *size)
 	u32 tmp;
 	struct sdio_cmd52 cmd;
 
-	/**
-	 *      Read DMA count in words
-	 **/
+	/* Read DMA count in words */
 	cmd.read_write = 0;
 	cmd.function = 0;
 	cmd.raw = 0;
@@ -804,9 +745,6 @@ static int sdio_read_size(struct wilc *wilc, u32 *size)
 	wilc_sdio_cmd52(wilc, &cmd);
 	tmp = cmd.data;
 
-	/* cmd.read_write = 0; */
-	/* cmd.function = 0; */
-	/* cmd.raw = 0; */
 	cmd.address = 0xf3;
 	cmd.data = 0;
 	wilc_sdio_cmd52(wilc, &cmd);
@@ -824,9 +762,7 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 
 	sdio_read_size(wilc, &tmp);
 
-	/**
-	 *      Read IRQ flags
-	 **/
+	/* Read IRQ flags */
 	if (!g_sdio.irq_gpio) {
 		int i;
 
@@ -918,8 +854,9 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 		}
 	} else {
 		if (g_sdio.irq_gpio) {
-			/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
-			/* Cannot clear multiple interrupts. Must clear each interrupt individually */
+			/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts.
+			 * Cannot clear multiple interrupts. Must clear each interrupt individually
+			 */
 			u32 flags;
 
 			flags = val & (BIT(MAX_NUM_INT) - 1);
@@ -1017,9 +954,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 
 	g_sdio.nint = nint;
 
-	/**
-	 *      Disable power sequencer
-	 **/
+	/* Disable power sequencer */
 	if (!sdio_read_reg(wilc, WILC_MISC, &reg)) {
 		dev_err(&func->dev, "Failed read misc reg...\n");
 		return 0;
@@ -1035,9 +970,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 		u32 reg;
 		int ret, i;
 
-		/**
-		 *      interrupt pin mux select
-		 **/
+		/* interrupt pin mux select */
 		ret = sdio_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 		if (!ret) {
 			dev_err(&func->dev, "Failed read reg (%08x)...\n",
@@ -1052,9 +985,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 			return 0;
 		}
 
-		/**
-		 *      interrupt enable
-		 **/
+		/* interrupt enable */
 		ret = sdio_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 		if (!ret) {
 			dev_err(&func->dev, "Failed read reg (%08x)...\n",
@@ -1094,11 +1025,6 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 	return 1;
 }
 
-/********************************************
- *
- *      Global sdio HIF function table
- *
- ********************************************/
 
 const struct wilc_hif_func wilc_hif_sdio = {
 	.hif_init = sdio_init,
-- 
1.9.1

