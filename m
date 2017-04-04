Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33700 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdDDFDR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 01:03:17 -0400
Received: by mail-pg0-f68.google.com with SMTP id 79so34602720pgf.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 22:03:17 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 3/3] rsi: Remove old firmware loading method for RS9113 chip set
Date: Tue,  4 Apr 2017 10:31:26 +0530
Message-Id: <1491282086-3008-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20170404_070320_912598_A8BD8660)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Older firmware loading method is not being used by any RSI
module. Hence removing that part of code doesn't impact.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 187 ----------------------------
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  | 124 ------------------
 2 files changed, 311 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index c516be1..d8581c3 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -21,171 +21,6 @@
 #include "rsi_hal.h"
 
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
@@ -432,28 +267,6 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
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
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index de49008..ce22ab9 100644
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
@@ -120,66 +59,3 @@ void rsi_usb_rx_thread(struct rsi_common *common)
 }
 
 
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
-- 
2.4.0
