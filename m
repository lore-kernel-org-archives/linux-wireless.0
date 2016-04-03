Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35785 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbcDCST2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2016 14:19:28 -0400
From: mohammed.billoo@gmail.com
To: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Mohammed Billoo <mohammed.billoo@gmail.com>
Subject: [PATCH] Ensure that comments adhere to coding standard
Date: Sun,  3 Apr 2016 14:18:46 -0400
Message-Id: <1459707526-21124-1-git-send-email-mohammed.billoo@gmail.com> (sfid-20160403_201950_197358_122E4699)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Billoo <mohammed.billoo@gmail.com>

Files in wilc1000 were modified to ensure that comments
adhere to standard specified by Documentation/CodingStyle

Signed-off-by: Mohammed Billoo <mohammed.billoo@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c     |   6 +-
 drivers/staging/wilc1000/linux_mon.c          |  19 ++-
 drivers/staging/wilc1000/wilc_debugfs.c       |  12 +-
 drivers/staging/wilc1000/wilc_sdio.c          | 145 +++++------------
 drivers/staging/wilc1000/wilc_spi.c           | 220 +++++++++-----------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |   4 +-
 drivers/staging/wilc1000/wilc_wlan.h          |  89 ++++-------
 drivers/staging/wilc1000/wilc_wlan_cfg.c      |  46 ++----
 drivers/staging/wilc1000/wilc_wlan_cfg.h      |  13 +-
 drivers/staging/wilc1000/wilc_wlan_if.h       |  44 ++----
 10 files changed, 194 insertions(+), 404 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0a922c7..b40dce2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -263,7 +263,8 @@ static struct wilc_vif *join_req_vif;
 static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 
-/* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
+/*
+ * The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
  * special purpose in wilc device, so we add 1 to the index to starts from 1.
  * As a result, the returned index will be 1 to NUM_CONCURRENT_IFC.
  */
@@ -272,7 +273,8 @@ int wilc_get_vif_idx(struct wilc_vif *vif)
 	return vif->idx + 1;
 }
 
-/* We need to minus 1 from idx which is from wilc device to get real index
+/*
+ * We need to minus 1 from idx which is from wilc device to get real index
  * of wilc->vif[], because we add 1 when pass to wilc device in the function
  * wilc_get_vif_idx.
  * As a result, the index should be between 0 and NUM_CONCURRENT_IFC -1.
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 7d9e5de..d8d4be6 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -60,8 +60,10 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 	/* Get WILC header */
 	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
 
-	/* The packet offset field conain info about what type of managment frame */
-	/* we are dealing with and ack status */
+	/*
+	 * The packet offset field conain info about what type of managment
+	 * frame we are dealing with and ack status
+	 */
 	pkt_offset = GET_PKT_OFFSET(header);
 
 	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
@@ -128,7 +130,10 @@ static void mgmt_tx_complete(void *priv, int status)
 {
 	struct tx_complete_mon_data *pv_data = priv;
 
-	/* incase of fully hosting mode, the freeing will be done in response to the cfg packet */
+	/*
+	 * In case of fully hosting mode, the freeing will be done in response
+	 * to the cfg packet
+	 */
 	kfree(pv_data->buff);
 
 	kfree(pv_data);
@@ -227,8 +232,10 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	/* Identify if Ethernet or MAC header (data or mgmt) */
 	memcpy(srcAdd, &skb->data[10], 6);
 	memcpy(bssid, &skb->data[16], 6);
-	/* if source address and bssid fields are equal>>Mac header */
-	/*send it to mgmt frames handler */
+	/*
+	 * If source address and bssid fields are equal>>Mac header
+	 * send it to mgmt frames handler
+	 */
 	if (!(memcmp(srcAdd, bssid, 6))) {
 		ret = mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
 		if (ret)
@@ -260,7 +267,7 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 	u32 ret = 0;
 	struct WILC_WFI_mon_priv *priv;
 
-	/*If monitor interface is already initialized, return it*/
+	/* If monitor interface is already initialized, return it*/
 	if (wilc_wfi_mon)
 		return wilc_wfi_mon;
 
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index fcbc95d..4fb819d 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -6,7 +6,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
  */
 
 #if defined(WILC_DEBUGFS)
@@ -20,9 +19,7 @@
 
 static struct dentry *wilc_dir;
 
-/*
- * --------------------------------------------------------------------------------
- */
+
 #define DEBUG           BIT(0)
 #define INFO            BIT(1)
 #define WRN             BIT(2)
@@ -32,10 +29,6 @@ static struct dentry *wilc_dir;
 atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
 EXPORT_SYMBOL_GPL(WILC_DEBUG_LEVEL);
 
-/*
- * --------------------------------------------------------------------------------
- */
-
 
 static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf, size_t count, loff_t *ppos)
 {
@@ -76,9 +69,6 @@ static ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
 	return count;
 }
 
-/*
- * --------------------------------------------------------------------------------
- */
 
 #define FOPS(_open, _read, _write, _poll) { \
 		.owner	= THIS_MODULE, \
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index a839a79..6ae3490 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -1,11 +1,8 @@
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_sdio.c */
-/*  */
-/*  */
-/* //////////////////////////////////////////////////////////////////////////// */
+/*
+ * Copyright (c) Atmel Corporation.  All rights reserved.
+ *
+ * Module Name:  wilc_sdio.c
+ */
 
 #include <linux/string.h>
 #include "wilc_wlan_if.h"
@@ -334,11 +331,6 @@ _fail_:
 	return 0;
 }
 
-/********************************************
- *
- *      Function 1
- *
- ********************************************/
 
 static int sdio_set_func1_block_size(struct wilc *wilc, u32 block_size)
 {
@@ -369,11 +361,7 @@ _fail_:
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
@@ -436,31 +424,23 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 
 	cmd.read_write = 1;
 	if (addr > 0) {
-		/**
-		 *      has to be word aligned...
-		 **/
+		/* Has to be word aligned */
 		if (size & 0x3) {
 			size += 4;
 			size &= ~0x3;
 		}
 
-		/**
-		 *      func 0 access
-		 **/
+		/* Func 0 access */
 		cmd.function = 0;
 		cmd.address = 0x10f;
 	} else {
-		/**
-		 *      has to be word aligned...
-		 **/
+		/* Has to be word aligned */
 		if (size & 0x3) {
 			size += 4;
 			size &= ~0x3;
 		}
 
-		/**
-		 *      func 1 access
-		 **/
+		/* Func 1 access */
 		cmd.function = 1;
 		cmd.address = 0;
 	}
@@ -495,7 +475,8 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 		cmd.count = nleft;
 		cmd.buffer = buf;
 
-		cmd.block_size = block_size; /* johnny : prevent it from setting unexpected value */
+		/* Johnny : Prevent it from setting unexpected value */
+		cmd.block_size = block_size;
 
 		if (addr > 0) {
 			if (!sdio_set_func0_csa_address(wilc, addr))
@@ -549,7 +530,8 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		cmd.count = 4;
 		cmd.buffer = (u8 *)data;
 
-		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
+		/* Johnny : Prevent it from setting unexpected value */
+		cmd.block_size = g_sdio.block_size;
 		ret = wilc_sdio_cmd53(wilc, &cmd);
 		if (ret) {
 			dev_err(&func->dev,
@@ -576,31 +558,23 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 
 	cmd.read_write = 0;
 	if (addr > 0) {
-		/**
-		 *      has to be word aligned...
-		 **/
+		/* Has to be word aligned */
 		if (size & 0x3) {
 			size += 4;
 			size &= ~0x3;
 		}
 
-		/**
-		 *      func 0 access
-		 **/
+		/* Func 0 access */
 		cmd.function = 0;
 		cmd.address = 0x10f;
 	} else {
-		/**
-		 *      has to be word aligned...
-		 **/
+		/* Has to be word aligned */
 		if (size & 0x3) {
 			size += 4;
 			size &= ~0x3;
 		}
 
-		/**
-		 *      func 1 access
-		 **/
+		/* Func 1 access */
 		cmd.function = 1;
 		cmd.address = 0;
 	}
@@ -635,7 +609,8 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 		cmd.count = nleft;
 		cmd.buffer = buf;
 
-		cmd.block_size = block_size; /* johnny : prevent it from setting unexpected value */
+		/* Johnny : Prevent it from setting unexpected value */
+		cmd.block_size = block_size;
 
 		if (addr > 0) {
 			if (!sdio_set_func0_csa_address(wilc, addr))
@@ -656,11 +631,6 @@ _fail_:
 	return 0;
 }
 
-/********************************************
- *
- *      Bus interfaces
- *
- ********************************************/
 
 static int sdio_deinit(struct wilc *wilc)
 {
@@ -679,9 +649,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		g_sdio.irq_gpio = wilc->dev_irq_num;
 	}
 
-	/**
-	 *      function 0 csa enable
-	 **/
+	/* Function 0 csa enable */
 	cmd.read_write = 1;
 	cmd.function = 0;
 	cmd.raw = 1;
@@ -693,18 +661,14 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		goto _fail_;
 	}
 
-	/**
-	 *      function 0 block size
-	 **/
+	/* Function 0 block size */
 	if (!sdio_set_func0_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
 		dev_err(&func->dev, "Fail cmd 52, set func 0 block size...\n");
 		goto _fail_;
 	}
 	g_sdio.block_size = WILC_SDIO_BLOCK_SIZE;
 
-	/**
-	 *      enable func1 IO
-	 **/
+	/* Enable func1 IO */
 	cmd.read_write = 1;
 	cmd.function = 0;
 	cmd.raw = 1;
@@ -717,9 +681,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		goto _fail_;
 	}
 
-	/**
-	 *      make sure func 1 is up
-	 **/
+	/* Make sure func 1 is up */
 	cmd.read_write = 0;
 	cmd.function = 0;
 	cmd.raw = 0;
@@ -742,17 +704,13 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		goto _fail_;
 	}
 
-	/**
-	 *      func 1 is ready, set func 1 block size
-	 **/
+	/* Func 1 is ready, set func 1 block size */
 	if (!sdio_set_func1_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
 		dev_err(&func->dev, "Fail set func 1 block size...\n");
 		goto _fail_;
 	}
 
-	/**
-	 *      func 1 interrupt enable
-	 **/
+	/* Func 1 interrupt enable */
 	cmd.read_write = 1;
 	cmd.function = 0;
 	cmd.raw = 1;
@@ -764,9 +722,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		goto _fail_;
 	}
 
-	/**
-	 *      make sure can read back chip id correctly
-	 **/
+	/* Make sure can read back chip id correctly */
 	if (!resume) {
 		if (!sdio_read_reg(wilc, 0x1000, &chipid)) {
 			dev_err(&func->dev, "Fail cmd read chip id...\n");
@@ -793,9 +749,7 @@ static int sdio_read_size(struct wilc *wilc, u32 *size)
 	u32 tmp;
 	struct sdio_cmd52 cmd;
 
-	/**
-	 *      Read DMA count in words
-	 **/
+	/* Read DMA count in words */
 	cmd.read_write = 0;
 	cmd.function = 0;
 	cmd.raw = 0;
@@ -804,9 +758,6 @@ static int sdio_read_size(struct wilc *wilc, u32 *size)
 	wilc_sdio_cmd52(wilc, &cmd);
 	tmp = cmd.data;
 
-	/* cmd.read_write = 0; */
-	/* cmd.function = 0; */
-	/* cmd.raw = 0; */
 	cmd.address = 0xf3;
 	cmd.data = 0;
 	wilc_sdio_cmd52(wilc, &cmd);
@@ -824,9 +775,7 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 
 	sdio_read_size(wilc, &tmp);
 
-	/**
-	 *      Read IRQ flags
-	 **/
+	/* Read IRQ flags */
 	if (!g_sdio.irq_gpio) {
 		int i;
 
@@ -889,13 +838,13 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 		} else {
 			reg = 0;
 		}
-		/* select VMM table 0 */
+		/* Select VMM table 0 */
 		if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
 			reg |= BIT(5);
-		/* select VMM table 1 */
+		/* Select VMM table 1 */
 		if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
 			reg |= BIT(6);
-		/* enable VMM */
+		/* Enable VMM */
 		if ((val & EN_VMM) == EN_VMM)
 			reg |= BIT(7);
 		if (reg) {
@@ -918,8 +867,11 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 		}
 	} else {
 		if (g_sdio.irq_gpio) {
-			/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
-			/* Cannot clear multiple interrupts. Must clear each interrupt individually */
+			/*
+			 * See below. has_thrpt_enh2 uses register 0xf8 to
+			 * clear interrupts. Cannot clear multiple interrupts.
+			 * Must clear each interrupt individually
+			 */
 			u32 flags;
 
 			flags = val & (BIT(MAX_NUM_INT) - 1);
@@ -966,13 +918,13 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 			u32 vmm_ctl;
 
 			vmm_ctl = 0;
-			/* select VMM table 0 */
+			/* Select VMM table 0 */
 			if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
 				vmm_ctl |= BIT(0);
-			/* select VMM table 1 */
+			/* Select VMM table 1 */
 			if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
 				vmm_ctl |= BIT(1);
-			/* enable VMM */
+			/* Enable VMM */
 			if ((val & EN_VMM) == EN_VMM)
 				vmm_ctl |= BIT(2);
 
@@ -1017,9 +969,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 
 	g_sdio.nint = nint;
 
-	/**
-	 *      Disable power sequencer
-	 **/
+	/* Disable power sequencer */
 	if (!sdio_read_reg(wilc, WILC_MISC, &reg)) {
 		dev_err(&func->dev, "Failed read misc reg...\n");
 		return 0;
@@ -1035,9 +985,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 		u32 reg;
 		int ret, i;
 
-		/**
-		 *      interrupt pin mux select
-		 **/
+		/* Interrupt pin mux select */
 		ret = sdio_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 		if (!ret) {
 			dev_err(&func->dev, "Failed read reg (%08x)...\n",
@@ -1052,9 +1000,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 			return 0;
 		}
 
-		/**
-		 *      interrupt enable
-		 **/
+		/* Interrupt enable */
 		ret = sdio_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 		if (!ret) {
 			dev_err(&func->dev, "Failed read reg (%08x)...\n",
@@ -1094,11 +1040,6 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 	return 1;
 }
 
-/********************************************
- *
- *      Global sdio HIF function table
- *
- ********************************************/
 
 const struct wilc_hif_func wilc_hif_sdio = {
 	.hif_init = sdio_init,
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index d41b8b6..5328c3e 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1,11 +1,8 @@
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_spi.c */
-/*  */
-/*  */
-/* //////////////////////////////////////////////////////////////////////////// */
+/*
+ * Copyright (c) Atmel Corporation.  All rights reserved.
+ *
+ * Module Name:  wilc_spi.c
+ */
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -34,11 +31,6 @@ static struct wilc_spi g_spi;
 static int wilc_spi_read(struct wilc *wilc, u32, u8 *, u32);
 static int wilc_spi_write(struct wilc *wilc, u32, u8 *, u32);
 
-/********************************************
- *
- *      Crc7
- *
- ********************************************/
 
 static const u8 crc7_syndrome_table[256] = {
 	0x00, 0x09, 0x12, 0x1b, 0x24, 0x2d, 0x36, 0x3f,
@@ -87,11 +79,6 @@ static u8 crc7(u8 crc, const u8 *buffer, u32 len)
 	return crc;
 }
 
-/********************************************
- *
- *      Spi protocol Function
- *
- ********************************************/
 
 #define CMD_DMA_WRITE				0xc1
 #define CMD_DMA_READ				0xc2
@@ -293,14 +280,14 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 
 	wb[0] = cmd;
 	switch (cmd) {
-	case CMD_SINGLE_READ:                           /* single word (4 bytes) read */
+	case CMD_SINGLE_READ:	/* Single word (4 bytes) read */
 		wb[1] = (u8)(adr >> 16);
 		wb[2] = (u8)(adr >> 8);
 		wb[3] = (u8)adr;
 		len = 5;
 		break;
 
-	case CMD_INTERNAL_READ:                 /* internal register read */
+	case CMD_INTERNAL_READ:	/* Internal register read */
 		wb[1] = (u8)(adr >> 8);
 		if (clockless == 1)
 			wb[1] |= BIT(7);
@@ -309,29 +296,29 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		len = 5;
 		break;
 
-	case CMD_TERMINATE:                                     /* termination */
+	case CMD_TERMINATE: /* Termination */
 		wb[1] = 0x00;
 		wb[2] = 0x00;
 		wb[3] = 0x00;
 		len = 5;
 		break;
 
-	case CMD_REPEAT:                                                /* repeat */
+	case CMD_REPEAT: /* Repeat */
 		wb[1] = 0x00;
 		wb[2] = 0x00;
 		wb[3] = 0x00;
 		len = 5;
 		break;
 
-	case CMD_RESET:                                                 /* reset */
+	case CMD_RESET: /* Reset */
 		wb[1] = 0xff;
 		wb[2] = 0xff;
 		wb[3] = 0xff;
 		len = 5;
 		break;
 
-	case CMD_DMA_WRITE:                                     /* dma write */
-	case CMD_DMA_READ:                                      /* dma read */
+	case CMD_DMA_WRITE: /* Dma write */
+	case CMD_DMA_READ:  /* Dma read */
 		wb[1] = (u8)(adr >> 16);
 		wb[2] = (u8)(adr >> 8);
 		wb[3] = (u8)adr;
@@ -340,8 +327,8 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		len = 7;
 		break;
 
-	case CMD_DMA_EXT_WRITE:         /* dma extended write */
-	case CMD_DMA_EXT_READ:                  /* dma extended read */
+	case CMD_DMA_EXT_WRITE: /* Dma extended write */
+	case CMD_DMA_EXT_READ:  /* Dma extended read */
 		wb[1] = (u8)(adr >> 16);
 		wb[2] = (u8)(adr >> 8);
 		wb[3] = (u8)adr;
@@ -351,7 +338,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		len = 8;
 		break;
 
-	case CMD_INTERNAL_WRITE:                /* internal register write */
+	case CMD_INTERNAL_WRITE: /* Internal register write */
 		wb[1] = (u8)(adr >> 8);
 		if (clockless == 1)
 			wb[1] |= BIT(7);
@@ -363,7 +350,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		len = 8;
 		break;
 
-	case CMD_SINGLE_WRITE:                  /* single word write */
+	case CMD_SINGLE_WRITE: /* Single word write */
 		wb[1] = (u8)(adr >> 16);
 		wb[2] = (u8)(adr >> 8);
 		wb[3] = (u8)(adr);
@@ -416,7 +403,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		result = N_FAIL;
 		return result;
 	}
-	/* zero spi write buffers. */
+	/* Zero spi write buffers. */
 	for (wix = len; wix < len2; wix++)
 		wb[wix] = 0;
 	rix = len;
@@ -427,19 +414,11 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		return result;
 	}
 
-	/**
-	 * Command/Control response
-	 **/
-	if ((cmd == CMD_RESET) ||
-	    (cmd == CMD_TERMINATE) ||
-	    (cmd == CMD_REPEAT)) {
-		rix++;         /* skip 1 byte */
-	}
+	/* Command/Control response */
+	if ((cmd == CMD_RESET) || (cmd == CMD_TERMINATE) || (cmd == CMD_REPEAT))
+		rix++; /* skip 1 byte */
 
-	/* do { */
 	rsp = rb[rix++];
-	/*	if(rsp == cmd) break; */
-	/* } while(&rptr[1] <= &rb[len2]); */
 
 	if (rsp != cmd) {
 		dev_err(&spi->dev,
@@ -449,9 +428,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		return result;
 	}
 
-	/**
-	 * State response
-	 **/
+	/* State response */
 	rsp = rb[rix++];
 	if (rsp != 0x00) {
 		dev_err(&spi->dev, "Failed cmd state response state (%02x)\n",
@@ -463,14 +440,14 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 	if ((cmd == CMD_INTERNAL_READ) || (cmd == CMD_SINGLE_READ)
 	    || (cmd == CMD_DMA_READ) || (cmd == CMD_DMA_EXT_READ)) {
 		int retry;
-		/* u16 crc1, crc2; */
 		u8 crc[2];
-		/**
-		 * Data Respnose header
-		 **/
+		/* Data Response header */
 		retry = 100;
 		do {
-			/* ensure there is room in buffer later to read data and crc */
+			/*
+			 * Ensure there is room in buffer later to read data
+			 * and crc
+			 */
 			if (rix < len2) {
 				rsp = rb[rix++];
 			} else {
@@ -489,9 +466,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		}
 
 		if ((cmd == CMD_INTERNAL_READ) || (cmd == CMD_SINGLE_READ)) {
-			/**
-			 * Read bytes
-			 **/
+			/* Read bytes */
 			if ((rix + 3) < len2) {
 				b[0] = rb[rix++];
 				b[1] = rb[rix++];
@@ -505,9 +480,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 			}
 
 			if (!g_spi.crc_off) {
-				/**
-				 * Read Crc
-				 **/
+				/* Read Crc */
 				if ((rix + 1) < len2) {
 					crc[0] = rb[rix++];
 					crc[1] = rb[rix++];
@@ -520,7 +493,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		} else if ((cmd == CMD_DMA_READ) || (cmd == CMD_DMA_EXT_READ)) {
 			int ix;
 
-			/* some data may be read in response to dummy bytes. */
+			/* Some data may be read in response to dummy bytes. */
 			for (ix = 0; (rix < len2) && (ix < sz); )
 				b[ix++] = rb[rix++];
 
@@ -534,18 +507,14 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				else
 					nbytes = DATA_PKT_SZ - ix;
 
-				/**
-				 * Read bytes
-				 **/
+				/* Read bytes */
 				if (wilc_spi_rx(wilc, &b[ix], nbytes)) {
 					dev_err(&spi->dev, "Failed data block read, bus error...\n");
 					result = N_FAIL;
 					goto _error_;
 				}
 
-				/**
-				 * Read Crc
-				 **/
+				/* Read Crc */
 				if (!g_spi.crc_off) {
 					if (wilc_spi_rx(wilc, crc, 2)) {
 						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
@@ -559,7 +528,10 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				sz -= nbytes;
 			}
 
-			/*  if any data in left unread, then read the rest using normal DMA code.*/
+			/*
+			 * If any data in left unread, then read the rest using
+			 * normal DMA code.
+			 */
 			while (sz > 0) {
 				int nbytes;
 
@@ -568,14 +540,14 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				else
 					nbytes = DATA_PKT_SZ;
 
-				/**
-				 * read data response only on the next DMA cycles not
-				 * the first DMA since data response header is already
-				 * handled above for the first DMA.
-				 **/
-				/**
-				 * Data Respnose header
-				 **/
+				/*
+				 * Read data response only on the next DMA
+				 * cycles not the first DMA since data response
+				 * header is already handled above for the first
+				 * DMA.
+				 */
+
+				/*Data Respnose header */
 				retry = 10;
 				do {
 					if (wilc_spi_rx(wilc, &rsp, 1)) {
@@ -591,18 +563,14 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 					break;
 
 
-				/**
-				 * Read bytes
-				 **/
+				/* Read bytes */
 				if (wilc_spi_rx(wilc, &b[ix], nbytes)) {
 					dev_err(&spi->dev, "Failed data block read, bus error...\n");
 					result = N_FAIL;
 					break;
 				}
 
-				/**
-				 * Read Crc
-				 **/
+				/* Read Crc */
 				if (!g_spi.crc_off) {
 					if (wilc_spi_rx(wilc, crc, 2)) {
 						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
@@ -626,11 +594,8 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 	int ix, nbytes;
 	int result = 1;
 	u8 cmd, order, crc[2] = {0};
-	/* u8 rsp; */
 
-	/**
-	 *      Data
-	 **/
+	/* Data*/
 	ix = 0;
 	do {
 		if (sz <= DATA_PKT_SZ)
@@ -638,9 +603,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 		else
 			nbytes = DATA_PKT_SZ;
 
-		/**
-		 *      Write command
-		 **/
+		/* Write command */
 		cmd = 0xf0;
 		if (ix == 0) {
 			if (sz <= DATA_PKT_SZ)
@@ -662,9 +625,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 			break;
 		}
 
-		/**
-		 *      Write data
-		 **/
+		/* Write data */
 		if (wilc_spi_tx(wilc, &b[ix], nbytes)) {
 			dev_err(&spi->dev,
 				"Failed data block write, bus error...\n");
@@ -672,9 +633,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 			break;
 		}
 
-		/**
-		 *      Write Crc
-		 **/
+		/* Write Crc */
 		if (!g_spi.crc_off) {
 			if (wilc_spi_tx(wilc, crc, 2)) {
 				dev_err(&spi->dev, "Failed data block crc write, bus error...\n");
@@ -683,9 +642,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 			}
 		}
 
-		/**
-		 *      No need to wait for response
-		 **/
+		/* No need to wait for response */
 		ix += nbytes;
 		sz -= nbytes;
 	} while (sz);
@@ -694,11 +651,6 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 	return result;
 }
 
-/********************************************
- *
- *      Spi Internal Read/Write Function
- *
- ********************************************/
 
 static int spi_internal_write(struct wilc *wilc, u32 adr, u32 dat)
 {
@@ -731,11 +683,6 @@ static int spi_internal_read(struct wilc *wilc, u32 adr, u32 *data)
 	return 1;
 }
 
-/********************************************
- *
- *      Spi interfaces
- *
- ********************************************/
 
 static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
 {
@@ -746,7 +693,7 @@ static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
 
 	data = cpu_to_le32(data);
 	if (addr < 0x30) {
-		/* Clockless register*/
+		/* Clockless register */
 		cmd = CMD_INTERNAL_WRITE;
 		clockless = 1;
 	}
@@ -764,9 +711,7 @@ static int wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 	int result;
 	u8 cmd = CMD_DMA_EXT_WRITE;
 
-	/**
-	 *      has to be greated than 4
-	 **/
+	/* Has to be greated than 4 */
 	if (size <= 4)
 		return 0;
 
@@ -777,9 +722,7 @@ static int wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 		return 0;
 	}
 
-	/**
-	 *      Data
-	 **/
+	/* Data */
 	result = spi_data_write(wilc, buf, size);
 	if (result != N_OK)
 		dev_err(&spi->dev, "Failed block data write...\n");
@@ -795,8 +738,7 @@ static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 	u8 clockless = 0;
 
 	if (addr < 0x30) {
-		/* dev_err(&spi->dev, "***** read addr %d\n\n", addr); */
-		/* Clockless register*/
+		/* Clockless register */
 		cmd = CMD_INTERNAL_READ;
 		clockless = 1;
 	}
@@ -830,17 +772,10 @@ static int wilc_spi_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 	return 1;
 }
 
-/********************************************
- *
- *      Bus interfaces
- *
- ********************************************/
 
 static int _wilc_spi_deinit(struct wilc *wilc)
 {
-	/**
-	 *      TODO:
-	 **/
+	/* TODO: */
 	return 1;
 }
 
@@ -863,16 +798,18 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 
 	memset(&g_spi, 0, sizeof(struct wilc_spi));
 
-	/**
-	 *      configure protocol
-	 **/
+	/* Configure protocol */
 	g_spi.crc_off = 0;
 
-	/* TODO: We can remove the CRC trials if there is a definite way to reset */
-	/* the SPI to it's initial value. */
+	/*
+	 * TODO: We can remove the CRC trials if there is a definite way to
+	 * reset the SPI to it's initial value.
+	 */
 	if (!spi_internal_read(wilc, WILC_SPI_PROTOCOL_OFFSET, &reg)) {
-		/* Read failed. Try with CRC off. This might happen when module
-		 * is removed but chip isn't reset*/
+		/*
+		 * Read failed. Try with CRC off. This might happen when module
+		 * is removed but chip isn't reset
+		 */
 		g_spi.crc_off = 1;
 		dev_err(&spi->dev, "Failed internal read protocol with CRC on, retyring with CRC off...\n");
 		if (!spi_internal_read(wilc, WILC_SPI_PROTOCOL_OFFSET, &reg)) {
@@ -883,7 +820,7 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 		}
 	}
 	if (g_spi.crc_off == 0)	{
-		reg &= ~0xc;    /* disable crc checking */
+		reg &= ~0xc; /* Disable crc checking */
 		reg &= ~0x70;
 		reg |= (0x5 << 4);
 		if (!spi_internal_write(wilc, WILC_SPI_PROTOCOL_OFFSET, reg)) {
@@ -894,14 +831,11 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 	}
 
 
-	/**
-	 *      make sure can read back chip id correctly
-	 **/
+	/* Make sure can read back chip id correctly */
 	if (!wilc_spi_read_reg(wilc, 0x1000, &chipid)) {
 		dev_err(&spi->dev, "Fail cmd read chip id...\n");
 		return 0;
 	}
-	/* dev_err(&spi->dev, "chipid (%08x)\n", chipid); */
 
 	g_spi.has_thrpt_enh = 1;
 
@@ -1046,10 +980,10 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 			u32 tbl_ctl;
 
 			tbl_ctl = 0;
-			/* select VMM table 0 */
+			/* Select VMM table 0 */
 			if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
 				tbl_ctl |= BIT(0);
-			/* select VMM table 1 */
+			/* Select VMM table 1 */
 			if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
 				tbl_ctl |= BIT(1);
 
@@ -1062,9 +996,7 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 			}
 
 			if ((val & EN_VMM) == EN_VMM) {
-				/**
-				 *      enable vmm transfer.
-				 **/
+				/* Enable vmm transfer. */
 				ret = wilc_spi_write_reg(wilc,
 							 WILC_VMM_CORE_CTL, 1);
 				if (!ret) {
@@ -1091,9 +1023,7 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 
 	g_spi.nint = nint;
 
-	/**
-	 *      interrupt pin mux select
-	 **/
+	/* Interrupt pin mux select */
 	ret = wilc_spi_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 	if (!ret) {
 		dev_err(&spi->dev, "Failed read reg (%08x)...\n",
@@ -1108,9 +1038,7 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 		return 0;
 	}
 
-	/**
-	 *      interrupt enable
-	 **/
+	/* Interrupt enable */
 	ret = wilc_spi_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 	if (!ret) {
 		dev_err(&spi->dev, "Failed read reg (%08x)...\n",
@@ -1148,11 +1076,7 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 
 	return 1;
 }
-/********************************************
- *
- *      Global spi HIF function table
- *
- ********************************************/
+
 const struct wilc_hif_func wilc_hif_spi = {
 	.hif_init = wilc_spi_init,
 	.hif_deinit = _wilc_spi_deinit,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 4123cff..3d89167 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -86,7 +86,7 @@ struct sta_info {
 	u8 au8Sta_AssociatedBss[MAX_NUM_STA][ETH_ALEN];
 };
 
-/*Parameters needed for host interface for  remaining on channel*/
+/* Parameters needed for host interface for  remaining on channel */
 struct wilc_wfi_p2pListenParams {
 	struct ieee80211_channel *pstrListenChan;
 	enum nl80211_channel_type tenuChannelType;
@@ -129,10 +129,8 @@ struct wilc_priv {
 	struct wilc_wfi_key *wilc_gtk[MAX_NUM_STA];
 	struct wilc_wfi_key *wilc_ptk[MAX_NUM_STA];
 	u8 wilc_groupkey;
-	/* semaphores */
 	struct semaphore SemHandleUpdateStats;
 	struct semaphore hSemScanReq;
-	/*  */
 	bool gbAutoRateAdjusted;
 
 	bool bInP2PlistenState;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index bcd4bfa..3d73aa3 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -5,11 +5,7 @@
 
 #define ISWILC1000(id)			((id & 0xfffff000) == 0x100000 ? 1 : 0)
 
-/********************************************
- *
- *      Mac eth header length
- *
- ********************************************/
+/* Mac eth header length */
 #define DRIVER_HANDLER_SIZE		4
 #define MAX_MAC_HDR_LEN			26 /* QOS_MAC_HDR_LEN */
 #define SUB_MSDU_HEADER_LENGTH		14
@@ -35,11 +31,7 @@
 #define ETH_CONFIG_PKT_HDR_OFFSET	(ETH_ETHERNET_HDR_OFFSET + \
 					 ETH_CONFIG_PKT_HDR_LEN)
 
-/********************************************
- *
- *      Register Defines
- *
- ********************************************/
+/* Register Defines */
 #define WILC_PERIPH_REG_BASE		0x1000
 #define WILC_CHANGING_VIR_IF		0x108c
 #define WILC_CHIPID			WILC_PERIPH_REG_BASE
@@ -133,20 +125,17 @@
 
 #define MODALIAS		"WILC_SPI"
 #define GPIO_NUM		0x44
-/*******************************************/
-/*        E0 and later Interrupt flags.    */
-/*******************************************/
-/*******************************************/
-/*        E0 and later Interrupt flags.    */
-/*           IRQ Status word               */
-/* 15:0 = DMA count in words.              */
-/* 16: INT0 flag                           */
-/* 17: INT1 flag                           */
-/* 18: INT2 flag                           */
-/* 19: INT3 flag                           */
-/* 20: INT4 flag                           */
-/* 21: INT5 flag                           */
-/*******************************************/
+/*
+ * E0 and later Interrupt flags.
+ * IRQ Status word
+ * 15:0 = DMA count in words.
+ * 16: INT0 flag
+ * 17: INT1 flag
+ * 18: INT2 flag
+ * 19: INT3 flag
+ * 20: INT4 flag
+ * 21: INT5 flag
+ */
 #define IRG_FLAGS_OFFSET	16
 #define IRQ_DMA_WD_CNT_MASK	((1ul << IRG_FLAGS_OFFSET) - 1)
 #define INT_0			BIT(IRG_FLAGS_OFFSET)
@@ -157,19 +146,19 @@
 #define INT_5			BIT(IRG_FLAGS_OFFSET + 5)
 #define MAX_NUM_INT		6
 
-/*******************************************/
-/*        E0 and later Interrupt flags.    */
-/*           IRQ Clear word                */
-/* 0: Clear INT0                           */
-/* 1: Clear INT1                           */
-/* 2: Clear INT2                           */
-/* 3: Clear INT3                           */
-/* 4: Clear INT4                           */
-/* 5: Clear INT5                           */
-/* 6: Select VMM table 1                   */
-/* 7: Select VMM table 2                   */
-/* 8: Enable VMM                           */
-/*******************************************/
+/*
+ * E0 and later Interrupt flags.
+ * IRQ Clear word
+ * 0: Clear INT0
+ * 1: Clear INT1
+ * 2: Clear INT2
+ * 3: Clear INT3
+ * 4: Clear INT4
+ * 5: Clear INT5
+ * 6: Select VMM table 1
+ * 7: Select VMM table 2
+ * 8: Enable VMM
+ */
 #define CLR_INT0		BIT(0)
 #define CLR_INT1		BIT(1)
 #define CLR_INT2		BIT(2)
@@ -192,20 +181,12 @@
 
 #define ENABLE_RX_VMM		(SEL_VMM_TBL1 | EN_VMM)
 #define ENABLE_TX_VMM		(SEL_VMM_TBL0 | EN_VMM)
-/*time for expiring the semaphores of cfg packets*/
+/* Time for expiring the semaphores of cfg packets */
 #define CFG_PKTS_TIMEOUT	2000
-/********************************************
- *
- *      Debug Type
- *
- ********************************************/
+/* Debug Type */
 typedef void (*wilc_debug_func)(u32, char *, ...);
 
-/********************************************
- *
- *      Tx/Rx Queue Structure
- *
- ********************************************/
+/* Tx/Rx Queue Structure */
 
 struct txq_entry_t {
 	struct txq_entry_t *next;
@@ -225,11 +206,7 @@ struct rxq_entry_t {
 	int buffer_size;
 };
 
-/********************************************
- *
- *      Host IF Structure
- *
- ********************************************/
+/* Host IF Structure */
 struct wilc;
 struct wilc_hif_func {
 	int (*hif_init)(struct wilc *, bool resume);
@@ -251,11 +228,7 @@ struct wilc_hif_func {
 extern const struct wilc_hif_func wilc_hif_spi;
 extern const struct wilc_hif_func wilc_hif_sdio;
 
-/********************************************
- *
- *      Configuration Structure
- *
- ********************************************/
+/* Configuration Structure */
 
 #define MAX_CFG_FRAME_SIZE	1468
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index b3425b9..f4c643c 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -1,11 +1,8 @@
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_wlan_cfg.c */
-/*  */
-/*  */
-/* ///////////////////////////////////////////////////////////////////////// */
+/*
+ * Copyright (c) Atmel Corporation.  All rights reserved.
+ *
+ * Module Name:  wilc_wlan_cfg.c
+ */
 
 #include <linux/string.h>
 #include "wilc_wlan_if.h"
@@ -13,11 +10,7 @@
 #include "wilc_wlan_cfg.h"
 #include "coreconfigurator.h"
 
-/********************************************
- *
- *      Global Data
- *
- ********************************************/
+/* Global Data */
 enum cfg_cmd_type {
 	CFG_BYTE_CMD	= 0,
 	CFG_HWORD_CMD	= 1,
@@ -157,11 +150,7 @@ static struct wilc_cfg_str g_cfg_str[] = {
 	{WID_NIL, NULL}
 };
 
-/********************************************
- *
- *      Configuration Functions
- *
- ********************************************/
+/* Configuration Functions */
 
 static int wilc_wlan_cfg_set_byte(u8 *frame, u32 offset, u16 id, u8 val8)
 {
@@ -263,11 +252,7 @@ static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32 size)
 	return (size + 5);
 }
 
-/********************************************
- *
- *      Configuration Response Functions
- *
- ********************************************/
+/* Configuration Response Functions */
 
 static void wilc_wlan_parse_response_frame(u8 *info, int size)
 {
@@ -367,11 +352,7 @@ static int wilc_wlan_parse_info_frame(u8 *info, int size)
 	return type;
 }
 
-/********************************************
- *
- *      Configuration Exported Functions
- *
- ********************************************/
+/* Configuration Exported Functions */
 
 int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size)
 {
@@ -506,13 +487,14 @@ int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 	u8 msg_id;
 
 	msg_type = frame[0];
-	msg_id = frame[1];      /* seq no */
+	msg_id = frame[1]; /* Seq no */
 	frame += 4;
 	size -= 4;
 
-	/**
-	 *      The  valid types of response messages are 'R' (Response), 'I' (Information), and 'N' (Network Information)
-	 **/
+	/*
+	 * The  valid types of response messages are 'R' (Response),
+	 * 'I' (Information), and 'N' (Network Information)
+	 */
 
 	switch (msg_type) {
 	case 'R':
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index b8641a2..79644c4 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -1,11 +1,8 @@
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_wlan_cfg.h */
-/*  */
-/*  */
-/* ///////////////////////////////////////////////////////////////////////// */
+/*
+/* Copyright (c) Atmel Corporation.  All rights reserved.
+ *
+ * Module Name:  wilc_wlan_cfg.h
+ */
 
 #ifndef WILC_WLAN_CFG_H
 #define WILC_WLAN_CFG_H
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 83cf84d..fb5a0ca 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -1,11 +1,7 @@
-/* ///////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_wlan_if.h */
-/*  */
-/*  */
-/* ///////////////////////////////////////////////////////////////////////// */
+/*
+ * Copyright (c) Atmel Corporation.  All rights reserved.
+ * Module Name:  wilc_wlan_if.h
+ */
 
 #ifndef WILC_WLAN_IF_H
 #define WILC_WLAN_IF_H
@@ -13,11 +9,7 @@
 #include <linux/semaphore.h>
 #include <linux/netdevice.h>
 
-/********************************************
- *
- *      Debug Flags
- *
- ********************************************/
+/* Debug Flags */
 
 #define N_INIT			0x00000001
 #define N_ERR			0x00000002
@@ -25,30 +17,18 @@
 #define N_INTR			0x00000008
 #define N_RXQ			0x00000010
 
-/********************************************
- *
- *      Host Interface Defines
- *
- ********************************************/
+/* Host Interface Defines */
 
 #define HIF_SDIO		(0)
 #define HIF_SPI			BIT(0)
 #define HIF_SDIO_GPIO_IRQ	BIT(2)
 
-/********************************************
- *
- *      Tx/Rx Buffer Size Defines
- *
- ********************************************/
+/* Tx/Rx Buffer Size Defines */
 
 #define CE_TX_BUFFER_SIZE	(64 * 1024)
 #define CE_RX_BUFFER_SIZE	(384 * 1024)
 
-/********************************************
- *
- *      Wlan Interface Defines
- *
- ********************************************/
+/* Wlan Interface Defines */
 
 struct sdio_cmd52 {
 	u32 read_write:		1;
@@ -87,11 +67,7 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 
 #define WILC_TX_ERR_NO_BUF	(-2)
 
-/********************************************
- *
- *      Wlan Configuration ID
- *
- ********************************************/
+/* Wlan Configuration ID */
 #define WILC_MULTICAST_TABLE_SIZE	8
 #define MAX_SSID_LEN            33
 #define MAX_RATES_SUPPORTED     12
@@ -270,7 +246,7 @@ typedef enum {
 typedef enum {
 	STATIC_MODE		= 1,
 	DYNAMIC_MODE		= 2,
-	MIMO_MODE		= 3,	/* power save disable */
+	MIMO_MODE		= 3,	/* Power save disable */
 } N_SMPS_MODE_T;
 
 typedef enum {
-- 
1.9.1

