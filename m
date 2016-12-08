Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33926 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbcLHFNE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Dec 2016 00:13:04 -0500
Received: by mail-pg0-f65.google.com with SMTP id e9so25624516pgc.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 21:13:04 -0800 (PST)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 3/3] rsi: Remove old firmware loading method for RS9113 chip set
Date: Thu,  8 Dec 2016 10:40:34 +0530
Message-Id: <1481173834-18925-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161208_061307_878318_2D7A6FD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Older firmware loading method is not being used by any RSI
module. Hence removing that part of code doesn't impact.
New device ID is added which is widely used for current
RSI chip sets. Changes done in usb and sdio inteface files
to support new firmware loading method.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 221 ++++++++++++++++++++++++++--
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 190 +-----------------------
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 162 ++++++++++++++++++--
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  | 125 ----------------
 drivers/net/wireless/rsi/rsi_sdio.h         |   4 +-
 drivers/net/wireless/rsi/rsi_usb.h          |  14 +-
 6 files changed, 369 insertions(+), 347 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 8428858..4eb59f0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1,6 +1,8 @@
 /**
  * Copyright (c) 2014 Redpine Signals Inc.
  *
+ * Developers:
+ *		Fariya Fathima	2014 <fariya.f@redpinesignals.com>
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
  * copyright notice and this permission notice appear in all copies.
@@ -18,6 +20,7 @@
 #include <linux/module.h>
 #include "rsi_sdio.h"
 #include "rsi_common.h"
+#include "rsi_hal.h"
 
 /**
  * rsi_sdio_set_cmd52_arg() - This function prepares cmd 52 read/write arg.
@@ -473,8 +476,6 @@ void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit)
 		rsi_dbg(ERR_ZONE, "%s: unable to send ack\n", __func__);
 }
 
-
-
 /**
  * rsi_sdio_read_register_multiple() - This function read multiple bytes of
  *				       information from the SD card.
@@ -487,8 +488,8 @@ void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit)
  */
 static int rsi_sdio_read_register_multiple(struct rsi_hw *adapter,
 					   u32 addr,
-					   u32 count,
-					   u8 *data)
+					   u8 *data,
+					   u16 count)
 {
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
@@ -518,7 +519,7 @@ static int rsi_sdio_read_register_multiple(struct rsi_hw *adapter,
 int rsi_sdio_write_register_multiple(struct rsi_hw *adapter,
 				     u32 addr,
 				     u8 *data,
-				     u32 count)
+				     u16 count)
 {
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
@@ -552,6 +553,176 @@ int rsi_sdio_write_register_multiple(struct rsi_hw *adapter,
 	return status;
 }
 
+int rsi_sdio_load_data_master_write(struct rsi_hw *adapter,
+				    u32 base_address,
+				    u32 instructions_sz,
+				    u16 block_size,
+				    u8 *ta_firmware)
+{
+	u32 num_blocks;
+	u16 msb_address;
+	u32 offset, ii;
+	u8 temp_buf[block_size];
+	u16 lsb_address;
+
+	num_blocks = instructions_sz / block_size;
+	msb_address = base_address >> 16;
+
+	rsi_dbg(INFO_ZONE, "ins_size: %d\n", instructions_sz);
+	rsi_dbg(INFO_ZONE, "num_blocks: %d\n", num_blocks);
+
+	/* Loading DM ms word in the sdio slave */
+	if (rsi_sdio_master_access_msword(adapter, msb_address)) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to set ms word reg\n", __func__);
+		return -EINVAL;
+	}
+
+	for (offset = 0, ii = 0; ii < num_blocks; ii++, offset += block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + offset, block_size);
+		lsb_address = (u16)base_address;
+		if (rsi_sdio_write_register_multiple(adapter,
+					(lsb_address | RSI_SD_REQUEST_MASTER),
+					temp_buf, block_size)) {
+			rsi_dbg(ERR_ZONE, "%s: failed to write\n", __func__);
+			return -EINVAL;
+		}
+		rsi_dbg(INFO_ZONE, "%s: loading block: %d\n", __func__, ii);
+		base_address += block_size;
+
+		if ((base_address >> 16) != msb_address) {
+			msb_address += 1;
+
+			/* Loading DM ms word in the sdio slave */
+			if (rsi_sdio_master_access_msword(adapter,
+							  msb_address)) {
+				rsi_dbg(ERR_ZONE,
+					"%s: Unable to set ms word reg\n",
+					__func__);
+				return -EINVAL;
+			}
+		}
+	}
+
+	if (instructions_sz % block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf,
+		       ta_firmware + offset,
+		       instructions_sz % block_size);
+		lsb_address = (u16)base_address;
+		if (rsi_sdio_write_register_multiple(adapter,
+					lsb_address | RSI_SD_REQUEST_MASTER,
+					temp_buf,
+					instructions_sz % block_size)) {
+			return -EINVAL;
+		}
+		rsi_dbg(INFO_ZONE,
+			"Written Last Block in Address 0x%x Successfully\n",
+			offset | RSI_SD_REQUEST_MASTER);
+	}
+	return 0;
+}
+
+int rsi_sdio_master_reg_read(struct rsi_hw *adapter, u32 addr,
+			     u32 *read_buf, u16 size)
+{
+	u32 *data = NULL;
+	u16 ms_addr = 0;
+	u32 align[2] = {};
+	u32 addr_on_bus;
+
+	data = PTR_ALIGN(&align[0], 8);
+
+	ms_addr = (addr >> 16);
+	if (rsi_sdio_master_access_msword(adapter, ms_addr)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to set ms word to common reg\n",
+			__func__);
+		return -EINVAL;
+	}
+	addr = addr & 0xFFFF;
+
+	addr_on_bus = (addr & 0xFF000000);
+	if ((addr_on_bus == (FLASH_SIZE_ADDR & 0xFF000000)) ||
+	    (addr_on_bus == 0x0)) {
+		addr_on_bus = (addr & ~(0x3));
+	} else
+		addr_on_bus = addr;
+
+	/* Bringing TA out of reset */
+	if (rsi_sdio_read_register_multiple(adapter,
+					(addr_on_bus | RSI_SD_REQUEST_MASTER),
+					(u8 *)data, 4)) {
+		rsi_dbg(ERR_ZONE, "%s: AHB register read failed\n", __func__);
+		return -EINVAL;
+	}
+	if (size == 2) {
+		if ((addr & 0x3) == 0)
+			*read_buf = *data;
+		else
+			*read_buf  = (*data >> 16);
+		*read_buf = (*read_buf & 0xFFFF);
+	} else if (size == 1) {
+		if ((addr & 0x3) == 0)
+			*read_buf = *data;
+		else if ((addr & 0x3) == 1)
+			*read_buf = (*data >> 8);
+		else if ((addr & 0x3) == 2)
+			*read_buf = (*data >> 16);
+		else
+			*read_buf = (*data >> 24);
+		*read_buf = (*read_buf & 0xFF);
+	} else { /*size is 4 */
+		*read_buf = *data;
+	}
+
+	return 0;
+}
+
+int rsi_sdio_master_reg_write(struct rsi_hw *adapter,
+			      unsigned long addr,
+			      unsigned long data,
+			      u16 size)
+{
+	unsigned long data1[2];
+	unsigned long *data_aligned;
+
+	data_aligned = PTR_ALIGN(&data1[0], 8);
+
+	if (size == 2) {
+		*data_aligned = ((data << 16) | (data & 0xFFFF));
+	} else if (size == 1) {
+		u32 temp_data;
+
+		temp_data = (data & 0xFF);
+		*data_aligned = ((temp_data << 24) |
+				  (temp_data << 16) |
+				  (temp_data << 8) |
+				  (temp_data));
+	} else {
+		*data_aligned = data;
+	}
+	size = 4;
+
+	if (rsi_sdio_master_access_msword(adapter, (addr >> 16))) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to set ms word to common reg\n",
+			__func__);
+		return -EINVAL;
+	}
+	addr = addr & 0xFFFF;
+
+	/* Bringing TA out of reset */
+	if (rsi_sdio_write_register_multiple(adapter,
+					     (addr | RSI_SD_REQUEST_MASTER),
+					     (u8 *)data_aligned, size)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to do AHB reg write\n", __func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /**
  * rsi_sdio_host_intf_write_pkt() - This function writes the packet to device.
  * @adapter: Pointer to the adapter structure.
@@ -614,8 +785,8 @@ int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter,
 
 	status = rsi_sdio_read_register_multiple(adapter,
 						 length,
-						 length, /*num of bytes*/
-						 (u8 *)pkt);
+						 pkt,
+						 length);
 
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to read frame: %d\n", __func__,
@@ -691,6 +862,17 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 	return status;
 }
 
+static struct rsi_host_intf_ops sdio_host_intf_ops = {
+	.write_pkt		= rsi_sdio_host_intf_write_pkt,
+	.read_pkt		= rsi_sdio_host_intf_read_pkt,
+	.master_access_msword	= rsi_sdio_master_access_msword,
+	.master_reg_read	= rsi_sdio_master_reg_read,
+	.master_reg_write	= rsi_sdio_master_reg_write,
+	.read_reg_multiple	= rsi_sdio_read_register_multiple,
+	.write_reg_multiple	= rsi_sdio_write_register_multiple,
+	.load_data_master_write	= rsi_sdio_load_data_master_write,
+};
+
 /**
  * rsi_probe() - This function is called by kernel when the driver provided
  *		 Vendor and device IDs are matched. All the initialization
@@ -713,6 +895,8 @@ static int rsi_probe(struct sdio_func *pfunction,
 			__func__);
 		return 1;
 	}
+	adapter->rsi_host_intf = RSI_HOST_INTF_SDIO;
+	adapter->host_intf_ops = &sdio_host_intf_ops;
 
 	if (rsi_init_sdio_interface(adapter, pfunction)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to init sdio interface\n",
@@ -720,14 +904,6 @@ static int rsi_probe(struct sdio_func *pfunction,
 		goto fail;
 	}
 
-	if (rsi_sdio_device_init(adapter->priv)) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in device init\n", __func__);
-		sdio_claim_host(pfunction);
-		sdio_disable_func(pfunction);
-		sdio_release_host(pfunction);
-		goto fail;
-	}
-
 	sdio_claim_host(pfunction);
 	if (sdio_claim_irq(pfunction, rsi_handle_interrupt)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to request IRQ\n", __func__);
@@ -738,6 +914,21 @@ static int rsi_probe(struct sdio_func *pfunction,
 	sdio_release_host(pfunction);
 	rsi_dbg(INIT_ZONE, "%s: Registered Interrupt handler\n", __func__);
 
+	if (rsi_hal_device_init(adapter, RSI_DEV_9113)) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in device init\n", __func__);
+		sdio_claim_host(pfunction);
+		sdio_disable_func(pfunction);
+		sdio_release_host(pfunction);
+		goto fail;
+	}
+	rsi_dbg(INFO_ZONE, "===> RSI Device Init Done <===\n");
+
+	if (rsi_sdio_master_access_msword(adapter, MISC_CFG_BASE_ADDR)) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to set ms word reg\n", __func__);
+		return -1;
+	}
+	rsi_dbg(INIT_ZONE, "%s: Setting ms word to 0x41050000\n", __func__);
+
 	return 0;
 fail:
 	rsi_91x_deinit(adapter);
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 40d7231..df2a63b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -27,8 +27,7 @@
  *
  * Return: status: 0 on success, -1 on failure.
  */
-static int rsi_sdio_master_access_msword(struct rsi_hw *adapter,
-					 u16 ms_word)
+int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word)
 {
 	u8 byte;
 	u8 function = 0;
@@ -61,171 +60,6 @@ static int rsi_sdio_master_access_msword(struct rsi_hw *adapter,
 }
 
 /**
- * rsi_copy_to_card() - This function includes the actual funtionality of
- *			copying the TA firmware to the card.Basically this
- *			function includes opening the TA file,reading the
- *			TA file and writing their values in blocks of data.
- * @common: Pointer to the driver private structure.
- * @fw: Pointer to the firmware value to be written.
- * @len: length of firmware file.
- * @num_blocks: Number of blocks to be written to the card.
- *
- * Return: 0 on success and -1 on failure.
- */
-static int rsi_copy_to_card(struct rsi_common *common,
-			    const u8 *fw,
-			    u32 len,
-			    u32 num_blocks)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
-	u32 indx, ii;
-	u32 block_size = dev->tx_blk_size;
-	u32 lsb_address;
-	__le32 data[] = { TA_HOLD_THREAD_VALUE, TA_SOFT_RST_CLR,
-			  TA_PC_ZERO, TA_RELEASE_THREAD_VALUE };
-	u32 address[] = { TA_HOLD_THREAD_REG, TA_SOFT_RESET_REG,
-			  TA_TH0_PC_REG, TA_RELEASE_THREAD_REG };
-	u32 base_address;
-	u16 msb_address;
-
-	base_address = TA_LOAD_ADDRESS;
-	msb_address = base_address >> 16;
-
-	for (indx = 0, ii = 0; ii < num_blocks; ii++, indx += block_size) {
-		lsb_address = ((u16) base_address | RSI_SD_REQUEST_MASTER);
-		if (rsi_sdio_write_register_multiple(adapter,
-						     lsb_address,
-						     (u8 *)(fw + indx),
-						     block_size)) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Unable to load %s blk\n", __func__,
-				FIRMWARE_RSI9113);
-			return -1;
-		}
-		rsi_dbg(INIT_ZONE, "%s: loading block: %d\n", __func__, ii);
-		base_address += block_size;
-		if ((base_address >> 16) != msb_address) {
-			msb_address += 1;
-			if (rsi_sdio_master_access_msword(adapter,
-							  msb_address)) {
-				rsi_dbg(ERR_ZONE,
-					"%s: Unable to set ms word reg\n",
-					__func__);
-				return -1;
-			}
-		}
-	}
-
-	if (len % block_size) {
-		lsb_address = ((u16) base_address | RSI_SD_REQUEST_MASTER);
-		if (rsi_sdio_write_register_multiple(adapter,
-						     lsb_address,
-						     (u8 *)(fw + indx),
-						     len % block_size)) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Unable to load f/w\n", __func__);
-			return -1;
-		}
-	}
-	rsi_dbg(INIT_ZONE,
-		"%s: Succesfully loaded TA instructions\n", __func__);
-
-	if (rsi_sdio_master_access_msword(adapter, TA_BASE_ADDR)) {
-		rsi_dbg(ERR_ZONE,
-			"%s: Unable to set ms word to common reg\n",
-			__func__);
-		return -1;
-	}
-
-	for (ii = 0; ii < ARRAY_SIZE(data); ii++) {
-		/* Bringing TA out of reset */
-		if (rsi_sdio_write_register_multiple(adapter,
-						     (address[ii] |
-						     RSI_SD_REQUEST_MASTER),
-						     (u8 *)&data[ii],
-						     4)) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Unable to hold TA threads\n", __func__);
-			return -1;
-		}
-	}
-
-	rsi_dbg(INIT_ZONE, "%s: loaded firmware\n", __func__);
-	return 0;
-}
-
-/**
- * rsi_load_ta_instructions() - This function includes the actual funtionality
- *				of loading the TA firmware.This function also
- *				includes opening the TA file,reading the TA
- *				file and writing their value in blocks of data.
- * @common: Pointer to the driver private structure.
- *
- * Return: status: 0 on success, -1 on failure.
- */
-static int rsi_load_ta_instructions(struct rsi_common *common)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
-	u32 len;
-	u32 num_blocks;
-	const u8 *fw;
-	const struct firmware *fw_entry = NULL;
-	u32 block_size = dev->tx_blk_size;
-	int status = 0;
-	u32 base_address;
-	u16 msb_address;
-
-	if (rsi_sdio_master_access_msword(adapter, TA_BASE_ADDR)) {
-		rsi_dbg(ERR_ZONE,
-			"%s: Unable to set ms word to common reg\n",
-			__func__);
-		return -1;
-	}
-	base_address = TA_LOAD_ADDRESS;
-	msb_address = (base_address >> 16);
-
-	if (rsi_sdio_master_access_msword(adapter, msb_address)) {
-		rsi_dbg(ERR_ZONE,
-			"%s: Unable to set ms word reg\n", __func__);
-		return -1;
-	}
-
-	status = request_firmware(&fw_entry, FIRMWARE_RSI9113, adapter->device);
-	if (status < 0) {
-		rsi_dbg(ERR_ZONE, "%s Firmware file %s not found\n",
-			__func__, FIRMWARE_RSI9113);
-		return status;
-	}
-
-	/* Copy firmware into DMA-accessible memory */
-	fw = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
-	if (!fw) {
-		status = -ENOMEM;
-		goto out;
-	}
-	len = fw_entry->size;
-
-	if (len % 4)
-		len += (4 - (len % 4));
-
-	num_blocks = (len / block_size);
-
-	rsi_dbg(INIT_ZONE, "%s: Instruction size:%d\n", __func__, len);
-	rsi_dbg(INIT_ZONE, "%s: num blocks: %d\n", __func__, num_blocks);
-
-	status = rsi_copy_to_card(common, fw, len, num_blocks);
-	kfree(fw);
-
-out:
-	release_firmware(fw_entry);
-	return status;
-}
-
-/**
  * rsi_process_pkt() - This Function reads rx_blocks register and figures out
  *		       the size of the rx pkt.
  * @common: Pointer to the driver private structure.
@@ -472,28 +306,6 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 }
 
 /**
- * rsi_device_init() - This Function Initializes The HAL.
- * @common: Pointer to the driver private structure.
- *
- * Return: 0 on success, -1 on failure.
- */
-int rsi_sdio_device_init(struct rsi_common *common)
-{
-	if (rsi_load_ta_instructions(common))
-		return -1;
-
-	if (rsi_sdio_master_access_msword(common->priv, MISC_CFG_BASE_ADDR)) {
-		rsi_dbg(ERR_ZONE, "%s: Unable to set ms word reg\n",
-			__func__);
-		return -1;
-	}
-	rsi_dbg(INIT_ZONE,
-		"%s: Setting ms word to 0x41050000\n", __func__);
-
-	return 0;
-}
-
-/**
  * rsi_sdio_read_buffer_status_register() - This function is used to the read
  *					    buffer status register and set
  *					    relevant fields in
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index ef5d394..c78a2c7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -1,6 +1,9 @@
 /**
  * Copyright (c) 2014 Redpine Signals Inc.
  *
+ * Developers:
+ *	Prameela Rani Garnepudi	2016 <prameela.garnepudi@redpinesignals.com>
+ *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
  * copyright notice and this permission notice appear in all copies.
@@ -17,6 +20,16 @@
 
 #include <linux/module.h>
 #include "rsi_usb.h"
+#include "rsi_hal.h"
+
+static struct rsi_host_intf_ops usb_host_intf_ops = {
+	.write_pkt		= rsi_usb_host_intf_write_pkt,
+	.master_reg_read	= rsi_usb_master_reg_read,
+	.master_reg_write	= rsi_usb_master_reg_write,
+	.read_reg_multiple	= rsi_usb_read_register_multiple,
+	.write_reg_multiple	= rsi_usb_write_register_multiple,
+	.load_data_master_write	= rsi_usb_load_data_master_write,
+};
 
 /**
  * rsi_usb_card_write() - This function writes to the USB Card.
@@ -151,7 +164,7 @@ static int rsi_find_bulk_in_and_out_endpoints(struct usb_interface *interface,
  */
 static int rsi_usb_reg_read(struct usb_device *usbdev,
 			    u32 reg,
-			    u16 *value,
+			    u32 *value,
 			    u16 len)
 {
 	u8 *buf;
@@ -274,6 +287,63 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
 }
 
 /**
+ * rsi_usb_read_register_multiple() - This function reads multiple
+ *					bytes of data from the address.
+ * @adapter:	Pointer to the adapter structure.
+ * @addr:	Address of the register.
+ * @data:	Read data.
+ * @len:	Number of bytes to read.
+ *
+ * Return: status: 0 on success, a negative error code on failure.
+ */
+int rsi_usb_read_register_multiple(struct rsi_hw *adapter,
+				   u32 addr,
+				   u8 *data,
+				   u16 count)
+{
+	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
+	u8 *buf;
+	u16 transfer;
+	int status = 0;
+	u16 reg_val, index;
+
+	if (addr == 0)
+		return -EINVAL;
+
+	buf = kzalloc(4096, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	reg_val = ((u16 *)&addr)[1] & 0xffff;
+	index = ((u16 *)&addr)[0] & 0xffff;
+	while (count) {
+		transfer = min_t(u16, count, 4096);
+		status = usb_control_msg(dev->usbdev,
+					 usb_rcvctrlpipe(dev->usbdev, 0),
+					 USB_VENDOR_REGISTER_READ,
+					 USB_TYPE_VENDOR,
+					 reg_val,
+					 index,
+					 (void *)buf,
+					 transfer,
+					 USB_CTRL_GET_TIMEOUT);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"Reg read failed with error code :%d\n",
+				 status);
+			kfree(buf);
+			return status;
+		}
+		memcpy(data, buf, transfer);
+		count -= transfer;
+		data += transfer;
+		addr += transfer;
+	}
+	kfree(buf);
+	return status;
+}
+
+/**
  * rsi_usb_write_register_multiple() - This function writes multiple bytes of
  *				       information to multiple registers.
  * @adapter: Pointer to the adapter structure.
@@ -286,7 +356,7 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
 int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 				    u32 addr,
 				    u8 *data,
-				    u32 count)
+				    u16 count)
 {
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	u8 *buf;
@@ -333,9 +403,7 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
  *
  * Return: 0 on success, a negative error code on failure.
  */
-static int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
-				       u8 *pkt,
-				       u32 len)
+int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter, u8 *pkt, u32 len)
 {
 	u32 queueno = ((pkt[1] >> 4) & 0xf);
 	u8 endpoint;
@@ -348,6 +416,72 @@ static int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
 				  len);
 }
 
+int rsi_usb_master_reg_read(struct rsi_hw *adapter,
+			    u32 reg,
+			    u32 *value,
+			    u16 len)
+{
+	struct usb_device *usbdev =
+		((struct rsi_91x_usbdev *)adapter->rsi_dev)->usbdev;
+
+	return rsi_usb_reg_read(usbdev, reg, value, len);
+}
+
+int rsi_usb_master_reg_write(struct rsi_hw *adapter,
+			     unsigned long reg,
+			     unsigned long value,
+			     u16 len)
+{
+	struct usb_device *usbdev =
+		((struct rsi_91x_usbdev *)adapter->rsi_dev)->usbdev;
+
+	return rsi_usb_reg_write(usbdev, reg, value, len);
+}
+
+int rsi_usb_load_data_master_write(struct rsi_hw *adapter,
+				   u32 base_address,
+				   u32 instructions_sz,
+				   u16 block_size,
+				   u8 *ta_firmware)
+{
+	u16 num_blocks;
+	u32 cur_indx, ii;
+	u8  temp_buf[256];
+
+	num_blocks = instructions_sz / block_size;
+	rsi_dbg(INFO_ZONE, "num_blocks: %d\n", num_blocks);
+
+	for (cur_indx = 0, ii = 0;
+	     ii < num_blocks;
+	     ii++, cur_indx += block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + cur_indx, block_size);
+		if ((rsi_usb_write_register_multiple(adapter,
+						     base_address,
+						     (u8 *)(temp_buf),
+						     block_size)) < 0)
+			return -1;
+
+		rsi_dbg(INFO_ZONE, "%s: loading block: %d\n", __func__, ii);
+		base_address += block_size;
+	}
+
+	if (instructions_sz % block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + cur_indx,
+		       instructions_sz % block_size);
+		if ((rsi_usb_write_register_multiple(adapter,
+					     base_address,
+					     (u8 *)temp_buf,
+					     instructions_sz % block_size)) < 0)
+			return -1;
+		rsi_dbg(INFO_ZONE,
+			"Written Last Block in Address 0x%x Successfully\n",
+			cur_indx);
+	}
+	return 0;
+}
+
 /**
  * rsi_deinit_usb_interface() - This function deinitializes the usb interface.
  * @adapter: Pointer to the adapter structure.
@@ -416,6 +550,7 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	adapter->host_intf_write_pkt = rsi_usb_host_intf_write_pkt;
 	adapter->check_hw_queue_status = rsi_usb_check_queue_status;
 	adapter->determine_event_timeout = rsi_usb_event_timeout;
+	adapter->host_intf_ops = &usb_host_intf_ops;
 
 	rsi_init_event(&rsi_dev->rx_thread.event);
 	status = rsi_create_kthread(common, &rsi_dev->rx_thread,
@@ -456,7 +591,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 {
 	struct rsi_hw *adapter;
 	struct rsi_91x_usbdev *dev;
-	u16 fw_status;
+	u32 fw_status;
 	int status;
 
 	rsi_dbg(INIT_ZONE, "%s: Init function called\n", __func__);
@@ -467,6 +602,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 			__func__);
 		return -ENOMEM;
 	}
+	adapter->rsi_host_intf = RSI_HOST_INTF_USB;
 
 	status = rsi_init_usb_interface(adapter, pfunction);
 	if (status) {
@@ -480,25 +616,20 @@ static int rsi_probe(struct usb_interface *pfunction,
 	dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 
 	status = rsi_usb_reg_read(dev->usbdev, FW_STATUS_REG, &fw_status, 2);
-	if (status)
+	if (status < 0)
 		goto err1;
 	else
 		fw_status &= 1;
 
 	if (!fw_status) {
-		status = rsi_usb_device_init(adapter->priv);
+		rsi_dbg(INIT_ZONE, "Loading firmware...\n");
+		status = rsi_hal_device_init(adapter, RSI_DEV_9113);
 		if (status) {
 			rsi_dbg(ERR_ZONE, "%s: Failed in device init\n",
 				__func__);
 			goto err1;
 		}
-
-		status = rsi_usb_reg_write(dev->usbdev,
-					   USB_INTERNAL_REG_1,
-					   RSI_USB_READY_MAGIC_NUM, 1);
-		if (status)
-			goto err1;
-		rsi_dbg(INIT_ZONE, "%s: Performed device init\n", __func__);
+		rsi_dbg(INIT_ZONE, "%s: Device Init Done\n", __func__);
 	}
 
 	status = rsi_rx_urb_submit(adapter);
@@ -554,6 +685,7 @@ static const struct usb_device_id rsi_dev_table[] = {
 	{ USB_DEVICE(0x041B, 0x0301) },
 	{ USB_DEVICE(0x041B, 0x0201) },
 	{ USB_DEVICE(0x041B, 0x9330) },
+	{ USB_DEVICE(0x1618, 0x9113) },
 	{ /* Blank */},
 };
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index de49008..d3e0a07 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
@@ -19,67 +19,6 @@
 #include "rsi_usb.h"
 
 /**
- * rsi_copy_to_card() - This function includes the actual funtionality of
- *			copying the TA firmware to the card.Basically this
- *			function includes opening the TA file,reading the TA
- *			file and writing their values in blocks of data.
- * @common: Pointer to the driver private structure.
- * @fw: Pointer to the firmware value to be written.
- * @len: length of firmware file.
- * @num_blocks: Number of blocks to be written to the card.
- *
- * Return: 0 on success and -1 on failure.
- */
-static int rsi_copy_to_card(struct rsi_common *common,
-			    const u8 *fw,
-			    u32 len,
-			    u32 num_blocks)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
-	u32 indx, ii;
-	u32 block_size = dev->tx_blk_size;
-	u32 lsb_address;
-	u32 base_address;
-
-	base_address = TA_LOAD_ADDRESS;
-
-	for (indx = 0, ii = 0; ii < num_blocks; ii++, indx += block_size) {
-		lsb_address = base_address;
-		if (rsi_usb_write_register_multiple(adapter,
-						    lsb_address,
-						    (u8 *)(fw + indx),
-						    block_size)) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Unable to load %s blk\n", __func__,
-				FIRMWARE_RSI9113);
-			return -EIO;
-		}
-		rsi_dbg(INIT_ZONE, "%s: loading block: %d\n", __func__, ii);
-		base_address += block_size;
-	}
-
-	if (len % block_size) {
-		lsb_address = base_address;
-		if (rsi_usb_write_register_multiple(adapter,
-						    lsb_address,
-						    (u8 *)(fw + indx),
-						    len % block_size)) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Unable to load %s blk\n", __func__,
-				FIRMWARE_RSI9113);
-			return -EIO;
-		}
-	}
-	rsi_dbg(INIT_ZONE,
-		"%s: Succesfully loaded %s instructions\n", __func__,
-		FIRMWARE_RSI9113);
-
-	rsi_dbg(INIT_ZONE, "%s: loaded firmware\n", __func__);
-	return 0;
-}
-
-/**
  * rsi_usb_rx_thread() - This is a kernel thread to receive the packets from
  *			 the USB device.
  * @common: Pointer to the driver private structure.
@@ -119,67 +58,3 @@ void rsi_usb_rx_thread(struct rsi_common *common)
 	complete_and_exit(&dev->rx_thread.completion, 0);
 }
 
-
-/**
- * rsi_load_ta_instructions() - This function includes the actual funtionality
- *				of loading the TA firmware.This function also
- *				includes opening the TA file,reading the TA
- *				file and writing their value in blocks of data.
- * @common: Pointer to the driver private structure.
- *
- * Return: status: 0 on success, -1 on failure.
- */
-static int rsi_load_ta_instructions(struct rsi_common *common)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
-	const struct firmware *fw_entry = NULL;
-	u32 block_size = dev->tx_blk_size;
-	const u8 *fw;
-	u32 num_blocks, len;
-	int status = 0;
-
-	status = request_firmware(&fw_entry, FIRMWARE_RSI9113, adapter->device);
-	if (status < 0) {
-		rsi_dbg(ERR_ZONE, "%s Firmware file %s not found\n",
-			__func__, FIRMWARE_RSI9113);
-		return status;
-	}
-
-	/* Copy firmware into DMA-accessible memory */
-	fw = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
-	if (!fw) {
-		status = -ENOMEM;
-		goto out;
-	}
-	len = fw_entry->size;
-
-	if (len % 4)
-		len += (4 - (len % 4));
-
-	num_blocks = (len / block_size);
-
-	rsi_dbg(INIT_ZONE, "%s: Instruction size:%d\n", __func__, len);
-	rsi_dbg(INIT_ZONE, "%s: num blocks: %d\n", __func__, num_blocks);
-
-	status = rsi_copy_to_card(common, fw, len, num_blocks);
-	kfree(fw);
-
-out:
-	release_firmware(fw_entry);
-	return status;
-}
-
-/**
- * rsi_device_init() - This Function Initializes The HAL.
- * @common: Pointer to the driver private structure.
- *
- * Return: 0 on success, -1 on failure.
- */
-int rsi_usb_device_init(struct rsi_common *common)
-{
-	if (rsi_load_ta_instructions(common))
-		return -EIO;
-
-	return 0;
-		}
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index c7e8f2b..ad68f53 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -116,14 +116,14 @@ struct rsi_91x_sdiodev {
 
 void rsi_interrupt_handler(struct rsi_hw *adapter);
 int rsi_init_sdio_slave_regs(struct rsi_hw *adapter);
-int rsi_sdio_device_init(struct rsi_common *common);
 int rsi_sdio_read_register(struct rsi_hw *adapter, u32 addr, u8 *data);
 int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter, u8 *pkt, u32 length);
 int rsi_sdio_write_register(struct rsi_hw *adapter, u8 function,
 			    u32 addr, u8 *data);
 int rsi_sdio_write_register_multiple(struct rsi_hw *adapter, u32 addr,
-				     u8 *data, u32 count);
+				     u8 *data, u16 count);
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit);
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter);
 int rsi_sdio_read_buffer_status_register(struct rsi_hw *adapter, u8 q_num);
+int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word);
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index ebea0c4..afd58da 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -63,6 +63,18 @@ static inline int rsi_usb_event_timeout(struct rsi_hw *adapter)
 
 int rsi_usb_device_init(struct rsi_common *common);
 int rsi_usb_write_register_multiple(struct rsi_hw *adapter, u32 addr,
-				    u8 *data, u32 count);
+				    u8 *data, u16 count);
 void rsi_usb_rx_thread(struct rsi_common *common);
+int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter, u8 *pkt, u32 len);
+int rsi_usb_master_reg_read(struct rsi_hw *adapter, u32 reg,
+			    u32 *value, u16 len);
+int rsi_usb_master_reg_write(struct rsi_hw *adapter, unsigned long reg,
+			     unsigned long value, u16 len);
+int rsi_usb_read_register_multiple(struct rsi_hw *adapter, u32 addr,
+				   u8 *data, u16 count);
+int rsi_usb_load_data_master_write(struct rsi_hw *adapter,
+				   u32 base_address,
+				   u32 instructions_sz,
+				   u16 block_size,
+				   u8 *ta_firmware);
 #endif
-- 
2.4.11
