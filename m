Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47307 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044AbbKFJiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:38:22 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/26] staging: wilc1000: wilc_spi.c: add prefix wilc in all function name
Date: Fri, 6 Nov 2015 18:40:08 +0900
Message-ID: <1446802823-22598-12-git-send-email-glen.lee@atmel.com> (sfid-20151106_103829_712000_3AE764BE)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add prefix wilc for all functions name because the function name
such as spi_write, spi_read and spi_sync are same as linux spi function.
Hence, this should be done before restructuring wilc_spi.c and
linux_wlan_spi.c later.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 108 ++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index b09b3bd..946bda7 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -25,8 +25,8 @@ typedef struct {
 
 static wilc_spi_t g_spi;
 
-static int spi_read(u32, u8 *, u32);
-static int spi_write(u32, u8 *, u32);
+static int wilc_spi_read(u32, u8 *, u32);
+static int wilc_spi_write(u32, u8 *, u32);
 
 /********************************************
  *
@@ -790,7 +790,7 @@ static int spi_internal_read(u32 adr, u32 *data)
  *
  ********************************************/
 
-static int spi_write_reg(u32 addr, u32 data)
+static int wilc_spi_write_reg(u32 addr, u32 data)
 {
 	int result = N_OK;
 	u8 cmd = CMD_SINGLE_WRITE;
@@ -813,7 +813,7 @@ static int spi_write_reg(u32 addr, u32 data)
 	return result;
 }
 
-static int spi_write(u32 addr, u8 *buf, u32 size)
+static int wilc_spi_write(u32 addr, u8 *buf, u32 size)
 {
 	int result;
 	u8 cmd = CMD_DMA_EXT_WRITE;
@@ -841,7 +841,7 @@ static int spi_write(u32 addr, u8 *buf, u32 size)
 	return 1;
 }
 
-static int spi_read_reg(u32 addr, u32 *data)
+static int wilc_spi_read_reg(u32 addr, u32 *data)
 {
 	int result = N_OK;
 	u8 cmd = CMD_SINGLE_READ;
@@ -867,7 +867,7 @@ static int spi_read_reg(u32 addr, u32 *data)
 	return 1;
 }
 
-static int spi_read(u32 addr, u8 *buf, u32 size)
+static int wilc_spi_read(u32 addr, u8 *buf, u32 size)
 {
 	u8 cmd = CMD_DMA_EXT_READ;
 	int result;
@@ -890,20 +890,20 @@ static int spi_read(u32 addr, u8 *buf, u32 size)
  *
  ********************************************/
 
-static int spi_clear_int(void)
+static int wilc_spi_clear_int(void)
 {
 	u32 reg;
 
-	if (!spi_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
+	if (!wilc_spi_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_HOST_RX_CTRL_0);
 		return 0;
 	}
 	reg &= ~0x1;
-	spi_write_reg(WILC_HOST_RX_CTRL_0, reg);
+	wilc_spi_write_reg(WILC_HOST_RX_CTRL_0, reg);
 	return 1;
 }
 
-static int spi_deinit(void *pv)
+static int wilc_spi_deinit(void *pv)
 {
 	/**
 	 *      TODO:
@@ -911,7 +911,7 @@ static int spi_deinit(void *pv)
 	return 1;
 }
 
-static int spi_sync(void)
+static int wilc_spi_sync(void)
 {
 	u32 reg;
 	int ret;
@@ -919,13 +919,13 @@ static int spi_sync(void)
 	/**
 	 *      interrupt pin mux select
 	 **/
-	ret = spi_read_reg(WILC_PIN_MUX_0, &reg);
+	ret = wilc_spi_read_reg(WILC_PIN_MUX_0, &reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
 		return 0;
 	}
 	reg |= BIT(8);
-	ret = spi_write_reg(WILC_PIN_MUX_0, reg);
+	ret = wilc_spi_write_reg(WILC_PIN_MUX_0, reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
 		return 0;
@@ -934,13 +934,13 @@ static int spi_sync(void)
 	/**
 	 *      interrupt enable
 	 **/
-	ret = spi_read_reg(WILC_INTR_ENABLE, &reg);
+	ret = wilc_spi_read_reg(WILC_INTR_ENABLE, &reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
 		return 0;
 	}
 	reg |= BIT(16);
-	ret = spi_write_reg(WILC_INTR_ENABLE, reg);
+	ret = wilc_spi_write_reg(WILC_INTR_ENABLE, reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
 		return 0;
@@ -949,7 +949,7 @@ static int spi_sync(void)
 	return 1;
 }
 
-static int spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
+static int wilc_spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 {
 	u32 reg;
 	u32 chipid;
@@ -958,7 +958,7 @@ static int spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 
 	if (isinit) {
 
-		if (!spi_read_reg(0x1000, &chipid)) {
+		if (!wilc_spi_read_reg(0x1000, &chipid)) {
 			PRINT_ER("[wilc spi]: Fail cmd read chip id...\n");
 			return 0;
 		}
@@ -1015,7 +1015,7 @@ static int spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	/**
 	 *      make sure can read back chip id correctly
 	 **/
-	if (!spi_read_reg(0x1000, &chipid)) {
+	if (!wilc_spi_read_reg(0x1000, &chipid)) {
 		PRINT_ER("[wilc spi]: Fail cmd read chip id...\n");
 		return 0;
 	}
@@ -1028,16 +1028,16 @@ static int spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	return 1;
 }
 
-static void spi_max_bus_speed(void)
+static void wilc_spi_max_bus_speed(void)
 {
 	g_spi.spi_max_speed();
 }
 
-static void spi_default_bus_speed(void)
+static void wilc_spi_default_bus_speed(void)
 {
 }
 
-static int spi_read_size(u32 *size)
+static int wilc_spi_read_size(u32 *size)
 {
 	int ret;
 
@@ -1048,7 +1048,7 @@ static int spi_read_size(u32 *size)
 		u32 tmp;
 		u32 byte_cnt;
 
-		ret = spi_read_reg(WILC_VMM_TO_HOST_SIZE, &byte_cnt);
+		ret = wilc_spi_read_reg(WILC_VMM_TO_HOST_SIZE, &byte_cnt);
 		if (!ret) {
 			PRINT_ER("[wilc spi]: Failed read WILC_VMM_TO_HOST_SIZE ...\n");
 			goto _fail_;
@@ -1065,7 +1065,7 @@ _fail_:
 
 
 
-static int spi_read_int(u32 *int_status)
+static int wilc_spi_read_int(u32 *int_status)
 {
 	int ret;
 
@@ -1075,7 +1075,7 @@ static int spi_read_int(u32 *int_status)
 		u32 tmp;
 		u32 byte_cnt;
 
-		ret = spi_read_reg(WILC_VMM_TO_HOST_SIZE, &byte_cnt);
+		ret = wilc_spi_read_reg(WILC_VMM_TO_HOST_SIZE, &byte_cnt);
 		if (!ret) {
 			PRINT_ER("[wilc spi]: Failed read WILC_VMM_TO_HOST_SIZE ...\n");
 			goto _fail_;
@@ -1091,11 +1091,11 @@ static int spi_read_int(u32 *int_status)
 
 				happended = 0;
 
-				spi_read_reg(0x1a90, &irq_flags);
+				wilc_spi_read_reg(0x1a90, &irq_flags);
 				tmp |= ((irq_flags >> 27) << IRG_FLAGS_OFFSET);
 
 				if (g_spi.nint > 5) {
-					spi_read_reg(0x1a94, &irq_flags);
+					wilc_spi_read_reg(0x1a94, &irq_flags);
 					tmp |= (((irq_flags >> 0) & 0x7) << (IRG_FLAGS_OFFSET + 5));
 				}
 
@@ -1121,7 +1121,7 @@ _fail_:
 	return ret;
 }
 
-static int spi_clear_int_ext(u32 val)
+static int wilc_spi_clear_int_ext(u32 val)
 {
 	int ret;
 
@@ -1138,13 +1138,13 @@ static int spi_clear_int_ext(u32 val)
 			for (i = 0; i < g_spi.nint; i++) {
 				/* No matter what you write 1 or 0, it will clear interrupt. */
 				if (flags & 1)
-					ret = spi_write_reg(0x10c8 + i * 4, 1);
+					ret = wilc_spi_write_reg(0x10c8 + i * 4, 1);
 				if (!ret)
 					break;
 				flags >>= 1;
 			}
 			if (!ret) {
-				PRINT_ER("[wilc spi]: Failed spi_write_reg, set reg %x ...\n", 0x10c8 + i * 4);
+				PRINT_ER("[wilc spi]: Failed wilc_spi_write_reg, set reg %x ...\n", 0x10c8 + i * 4);
 				goto _fail_;
 			}
 			for (i = g_spi.nint; i < MAX_NUM_INT; i++) {
@@ -1165,7 +1165,7 @@ static int spi_clear_int_ext(u32 val)
 			if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
 				tbl_ctl |= BIT(1);
 
-			ret = spi_write_reg(WILC_VMM_TBL_CTL, tbl_ctl);
+			ret = wilc_spi_write_reg(WILC_VMM_TBL_CTL, tbl_ctl);
 			if (!ret) {
 				PRINT_ER("[wilc spi]: fail write reg vmm_tbl_ctl...\n");
 				goto _fail_;
@@ -1175,7 +1175,7 @@ static int spi_clear_int_ext(u32 val)
 				/**
 				 *      enable vmm transfer.
 				 **/
-				ret = spi_write_reg(WILC_VMM_CORE_CTL, 1);
+				ret = wilc_spi_write_reg(WILC_VMM_CORE_CTL, 1);
 				if (!ret) {
 					PRINT_ER("[wilc spi]: fail write reg vmm_core_ctl...\n");
 					goto _fail_;
@@ -1187,7 +1187,7 @@ _fail_:
 	return ret;
 }
 
-static int spi_sync_ext(int nint /*  how mant interrupts to enable. */)
+static int wilc_spi_sync_ext(int nint /*  how mant interrupts to enable. */)
 {
 	u32 reg;
 	int ret, i;
@@ -1202,13 +1202,13 @@ static int spi_sync_ext(int nint /*  how mant interrupts to enable. */)
 	/**
 	 *      interrupt pin mux select
 	 **/
-	ret = spi_read_reg(WILC_PIN_MUX_0, &reg);
+	ret = wilc_spi_read_reg(WILC_PIN_MUX_0, &reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
 		return 0;
 	}
 	reg |= BIT(8);
-	ret = spi_write_reg(WILC_PIN_MUX_0, reg);
+	ret = wilc_spi_write_reg(WILC_PIN_MUX_0, reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
 		return 0;
@@ -1217,7 +1217,7 @@ static int spi_sync_ext(int nint /*  how mant interrupts to enable. */)
 	/**
 	 *      interrupt enable
 	 **/
-	ret = spi_read_reg(WILC_INTR_ENABLE, &reg);
+	ret = wilc_spi_read_reg(WILC_INTR_ENABLE, &reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
 		return 0;
@@ -1226,13 +1226,13 @@ static int spi_sync_ext(int nint /*  how mant interrupts to enable. */)
 	for (i = 0; (i < 5) && (nint > 0); i++, nint--) {
 		reg |= (BIT((27 + i)));
 	}
-	ret = spi_write_reg(WILC_INTR_ENABLE, reg);
+	ret = wilc_spi_write_reg(WILC_INTR_ENABLE, reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
 		return 0;
 	}
 	if (nint) {
-		ret = spi_read_reg(WILC_INTR2_ENABLE, &reg);
+		ret = wilc_spi_read_reg(WILC_INTR2_ENABLE, &reg);
 		if (!ret) {
 			PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR2_ENABLE);
 			return 0;
@@ -1242,7 +1242,7 @@ static int spi_sync_ext(int nint /*  how mant interrupts to enable. */)
 			reg |= BIT(i);
 		}
 
-		ret = spi_read_reg(WILC_INTR2_ENABLE, &reg);
+		ret = wilc_spi_read_reg(WILC_INTR2_ENABLE, &reg);
 		if (!ret) {
 			PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR2_ENABLE);
 			return 0;
@@ -1257,20 +1257,20 @@ static int spi_sync_ext(int nint /*  how mant interrupts to enable. */)
  *
  ********************************************/
 struct wilc_hif_func hif_spi = {
-	spi_init,
-	spi_deinit,
-	spi_read_reg,
-	spi_write_reg,
-	spi_read,
-	spi_write,
-	spi_sync,
-	spi_clear_int,
-	spi_read_int,
-	spi_clear_int_ext,
-	spi_read_size,
-	spi_write,
-	spi_read,
-	spi_sync_ext,
-	spi_max_bus_speed,
-	spi_default_bus_speed,
+	wilc_spi_init,
+	wilc_spi_deinit,
+	wilc_spi_read_reg,
+	wilc_spi_write_reg,
+	wilc_spi_read,
+	wilc_spi_write,
+	wilc_spi_sync,
+	wilc_spi_clear_int,
+	wilc_spi_read_int,
+	wilc_spi_clear_int_ext,
+	wilc_spi_read_size,
+	wilc_spi_write,
+	wilc_spi_read,
+	wilc_spi_sync_ext,
+	wilc_spi_max_bus_speed,
+	wilc_spi_default_bus_speed,
 };
-- 
1.9.1

