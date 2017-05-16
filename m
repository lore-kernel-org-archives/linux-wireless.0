Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34704 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752074AbdEPKDm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:03:42 -0400
Received: by mail-pf0-f193.google.com with SMTP id w69so19397671pfk.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 03:03:32 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v3 11/11] rsi: Remove old firmware loading method
Date: Tue, 16 May 2017 15:31:17 +0530
Message-Id: <1494928877-27168-12-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170516_120350_334292_64C9ADE5)
In-Reply-To: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

The older firmware loading method is not usable by any Redpine chipset.
Hence removing that part of the code. Older firmware image with
rsi_91x.fw name is deprecated

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v3: Included the name of older firmware which won't be used anymore in
commit description(Kalle Valo)
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 187 ----------------------------
 drivers/net/wireless/rsi/rsi_91x_usb.c      |   6 +-
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  | 126 -------------------
 drivers/net/wireless/rsi/rsi_common.h       |   3 +-
 drivers/net/wireless/rsi/rsi_sdio.h         |   1 -
 drivers/net/wireless/rsi/rsi_usb.h          |   3 -
 6 files changed, 3 insertions(+), 323 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 225042f..df2a63b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -60,171 +60,6 @@ int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word)
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
-			    u16 num_blocks)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
-	u32 indx, ii;
-	u16 block_size = dev->tx_blk_size;
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
-	u16 num_blocks;
-	const u8 *fw;
-	const struct firmware *fw_entry = NULL;
-	u16 block_size = dev->tx_blk_size;
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
@@ -471,28 +306,6 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
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
index 72c7f3a..f5de693 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -327,10 +327,8 @@ static int rsi_usb_read_register_multiple(struct rsi_hw *adapter, u32 addr,
  *
  * Return: status: 0 on success, a negative error code on failure.
  */
-int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
-				    u32 addr,
-				    u8 *data,
-				    u16 count)
+static int rsi_usb_write_register_multiple(struct rsi_hw *adapter, u32 addr,
+					   u8 *data, u16 count)
 {
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	u8 *buf;
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index 1c3e654..d3e0a07 100644
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
-			    u16 num_blocks)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
-	u32 indx, ii;
-	u16 block_size = dev->tx_blk_size;
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
@@ -119,68 +58,3 @@ void rsi_usb_rx_thread(struct rsi_common *common)
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
-	u16 block_size = dev->tx_blk_size;
-	const u8 *fw;
-	u16 num_blocks;
-	u32 len;
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
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index d3fbe33..4434969 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -20,8 +20,7 @@
 #include <linux/kthread.h>
 
 #define EVENT_WAIT_FOREVER              0
-#define TA_LOAD_ADDRESS                 0x00
-#define FIRMWARE_RSI9113                "rsi_91x.fw"
+#define FIRMWARE_RSI9113                "rs9113_wlan_qspi.rps"
 #define QUEUE_NOT_FULL                  1
 #define QUEUE_FULL                      0
 
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 7ae6d51..9fb73f6 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -116,7 +116,6 @@ struct rsi_91x_sdiodev {
 
 void rsi_interrupt_handler(struct rsi_hw *adapter);
 int rsi_init_sdio_slave_regs(struct rsi_hw *adapter);
-int rsi_sdio_device_init(struct rsi_common *common);
 int rsi_sdio_read_register(struct rsi_hw *adapter, u32 addr, u8 *data);
 int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter, u8 *pkt, u32 length);
 int rsi_sdio_write_register(struct rsi_hw *adapter, u8 function,
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index d1e01bc..59513ac 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -63,8 +63,5 @@ static inline int rsi_usb_event_timeout(struct rsi_hw *adapter)
 	return EVENT_WAIT_FOREVER;
 }
 
-int rsi_usb_device_init(struct rsi_common *common);
-int rsi_usb_write_register_multiple(struct rsi_hw *adapter, u32 addr,
-				    u8 *data, u16 count);
 void rsi_usb_rx_thread(struct rsi_common *common);
 #endif
-- 
2.7.4
