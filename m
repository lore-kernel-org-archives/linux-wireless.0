Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36280 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbcLHFMq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Dec 2016 00:12:46 -0500
Received: by mail-pg0-f67.google.com with SMTP id x23so25666873pgx.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 21:12:46 -0800 (PST)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 2/3] rsi: Add new firmware loading method for RS9113 chip set
Date: Thu,  8 Dec 2016 10:40:18 +0530
Message-Id: <1481173818-18871-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161208_061251_506089_9857EECF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The older firmware loading method has been deprecated and not
in use with the current RS9113 modules. The newer method uses
soft boot loader (resides in device) to load the functional
firmware.
In this method complete RAM image and FLASH image are present
in the flash. Before loading the functional firmware, host
issues boot loader commands to verify whether the firmware
to load is different from the firmware in the device. If it is
different, firmware upgrade will progress and then boot loader
switches to the functional firmware.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 667 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_hal.h     | 152 ++++++++
 drivers/net/wireless/rsi/rsi_main.h    |  40 ++
 3 files changed, 859 insertions(+)
 create mode 100644 drivers/net/wireless/rsi/rsi_hal.h

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 02920c9..55bc8f4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -1,6 +1,9 @@
 /**
  * Copyright (c) 2014 Redpine Signals Inc.
  *
+ * Developers
+ *	Prameela Rani Garnepudi 2016 <prameela.garnepudi@redpinesignals.com>
+ *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
  * copyright notice and this permission notice appear in all copies.
@@ -14,7 +17,21 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/firmware.h>
 #include "rsi_mgmt.h"
+#include "rsi_hal.h"
+#include "rsi_sdio.h"
+
+/* FLASH Firmware */
+struct ta_metadata metadata_flash_content[] = {
+	{"flash_content", 0x00010000},
+	{"rs9113_wlan_qspi.rps", 0x00010000},
+	{"rs9113_wlan_bt_dual_mode.rps", 0x00010000},
+	{"rs9113_wlan_zigbee.rps", 0x00010000},
+	{"rs9113_ap_bt_dual_mode.rps", 0x00010000},
+	{"rs9113_wlan_qspi.rps", 0x00010000}
+};
+
 
 /**
  * rsi_send_data_pkt() - This function sends the recieved data packet from
@@ -213,3 +230,653 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	rsi_indicate_tx_status(common->priv, skb, status);
 	return status;
 }
+
+/**
+ * bl_cmd_timeout() - This function is called when BL(Boot Loader) command is
+ *		      timed out
+ *
+ * @priv: Pointer to the hardware structure.
+ *
+ * Return: NONE.
+ */
+static void bl_cmd_timeout(unsigned long priv)
+{
+	struct rsi_hw *adapter = (struct rsi_hw *)priv;
+
+	adapter->blcmd_timer_expired = 1;
+	del_timer(&adapter->bl_cmd_timer);
+}
+
+/**
+ * bl_start_cmd_timer() - This function starts the BL command timer
+ *
+ * @adapter: Pointer to the hardware structure.
+ * @timeout: Timeout of the command in milliseconds
+ *
+ * Return: 0 on success.
+ */
+static int bl_start_cmd_timer(struct rsi_hw *adapter, u32 timeout)
+{
+	init_timer(&adapter->bl_cmd_timer);
+	adapter->bl_cmd_timer.data = (unsigned long)adapter;
+	adapter->bl_cmd_timer.function = (void *)&bl_cmd_timeout;
+	adapter->bl_cmd_timer.expires = (msecs_to_jiffies(timeout) + jiffies);
+
+	adapter->blcmd_timer_expired = 0;
+	add_timer(&adapter->bl_cmd_timer);
+
+	return 0;
+}
+
+/**
+ * bl_stop_cmd_timer() - This function stops the BL command timer
+ *
+ * @adapter: Pointer to the hardware structure.
+ *
+ * Return: 0 on success.
+ */
+static int bl_stop_cmd_timer(struct rsi_hw *adapter)
+{
+	adapter->blcmd_timer_expired = 0;
+	if (timer_pending(&adapter->bl_cmd_timer))
+		del_timer(&adapter->bl_cmd_timer);
+
+	return 0;
+}
+
+/**
+ * bl_write_cmd() - This function writes the BL command to device
+ *
+ * @adapter: Pointer to the hardware structure.
+ * @cmd: Command to write
+ * @exp_resp: Expected Response
+ * @cmd_resp: Received Response
+ *
+ * Return: 0 on success.
+ */
+static int bl_write_cmd(struct rsi_hw *adapter, u8 cmd,
+			u8 exp_resp, u16 *cmd_resp)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	u32 regin_val = 0, regout_val = 0;
+	u8 output = 0;
+	u32 regin_input = 0;
+
+	regin_input = (REGIN_INPUT | adapter->priv->coex_mode);
+
+	while (!adapter->blcmd_timer_expired) {
+		regin_val = 0;
+		if (hif_ops->master_reg_read(adapter,
+					     SWBL_REGIN,
+					     &regin_val,
+					     2) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Command %0x REGIN reading failed\n",
+				__func__, cmd);
+			goto fail;
+		}
+		mdelay(1);
+		if ((regin_val >> 12) != REGIN_VALID)
+			break;
+	}
+	if (adapter->blcmd_timer_expired) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %0x REGIN reading timed out\n",
+			__func__, cmd);
+		goto fail;
+	}
+
+	rsi_dbg(INFO_ZONE,
+		"Issuing write to Regin regin_val:%0x sending cmd:%0x\n",
+		regin_val, (cmd | regin_input << 8));
+	if ((hif_ops->master_reg_write(adapter,
+				       SWBL_REGIN,
+				       (cmd | regin_input << 8),
+				       2)) < 0) {
+		goto fail;
+	}
+	mdelay(1);
+
+	if (cmd == LOAD_HOSTED_FW || cmd == JUMP_TO_ZERO_PC) {
+		/* JUMP_TO_ZERO_PC doesn't expect
+		 * any response. So return from here
+		 */
+		return 0;
+	}
+
+	while (!adapter->blcmd_timer_expired) {
+		regout_val = 0;
+		if (hif_ops->master_reg_read(adapter,
+					     SWBL_REGOUT,
+					     &regout_val,
+					     2) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Command %0x REGOUT reading failed\n",
+				__func__, cmd);
+			goto fail;
+		}
+		mdelay(1);
+		if ((regout_val >> 8) == REGOUT_VALID)
+			break;
+	}
+	if (adapter->blcmd_timer_expired) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %0x REGOUT reading timed out\n",
+			__func__, cmd);
+		goto fail;
+	}
+
+	*cmd_resp = ((u16 *)&regout_val)[0] & 0xffff;
+
+	output = ((u8 *)&regout_val)[0] & 0xff;
+
+	rsi_dbg(INFO_ZONE, "Invalidating regout\n");
+	if ((hif_ops->master_reg_write(adapter,
+				       SWBL_REGOUT,
+				       (cmd | REGOUT_INVALID << 8),
+				       2)) < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %0x REGOUT writing failed..\n",
+			__func__, cmd);
+		goto fail;
+	}
+	mdelay(1);
+
+	if (output == exp_resp) {
+		rsi_dbg(INFO_ZONE,
+			"%s: Recvd Expected resp %x for cmd %0x\n",
+			__func__, output, cmd);
+	} else {
+		rsi_dbg(ERR_ZONE,
+			"%s: Recvd resp %x for cmd %0x\n",
+			__func__, output, cmd);
+		goto fail;
+	}
+	return 0;
+
+fail:
+	return -EINVAL;
+}
+
+/**
+ * bl_cmd() - This function initiates the BL command
+ *
+ * @adapter: Pointer to the hardware structure.
+ * @cmd: Command to write
+ * @exp_resp: Expected Response
+ * @str: Command string
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int bl_cmd(struct rsi_hw *adapter, u8 cmd, u8 exp_resp, char *str)
+{
+	u16 regout_val = 0;
+	u32 timeout = 0;
+
+	rsi_dbg(INFO_ZONE, "Issuing cmd: \"%s\"\n", str);
+
+	if ((cmd == EOF_REACHED) || (cmd == PING_VALID) || (cmd == PONG_VALID))
+		timeout = BL_BURN_TIMEOUT;
+	else
+		timeout = BL_CMD_TIMEOUT;
+
+	bl_start_cmd_timer(adapter, timeout);
+	if (bl_write_cmd(adapter, cmd, exp_resp, &regout_val) < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %s (%0x) writing failed..\n",
+			__func__, str, cmd);
+		goto fail;
+	}
+	bl_stop_cmd_timer(adapter);
+	return 0;
+
+fail:
+	return -EINVAL;
+}
+
+/**
+ * bl_write_header() - This function writes the Bootloader header
+ *
+ * @adapter: Pointer to the hardware structure.
+ * @flash_content: Flash content
+ * @content_size: Flash content size
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int bl_write_header(struct rsi_hw *adapter,
+			   u8 *flash_content, u32 content_size)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	struct bl_header bl_hdr;
+	u32 write_addr, write_len;
+
+#define CHECK_SUM_OFFSET 20
+#define LEN_OFFSET 8
+#define ADDR_OFFSET 16
+
+	bl_hdr.flags = 0;
+	bl_hdr.image_no = cpu_to_le32(adapter->priv->coex_mode);
+	bl_hdr.check_sum = cpu_to_le32(
+				*(u32 *)&flash_content[CHECK_SUM_OFFSET]);
+	bl_hdr.flash_start_address = cpu_to_le32(
+					*(u32 *)&flash_content[ADDR_OFFSET]);
+	bl_hdr.flash_len = cpu_to_le32(*(u32 *)&flash_content[LEN_OFFSET]);
+	write_len = sizeof(struct bl_header);
+
+	if (adapter->rsi_host_intf == RSI_HOST_INTF_USB) {
+		write_addr = PING_BUFFER_ADDRESS;
+		if ((hif_ops->write_reg_multiple(adapter,
+						 write_addr,
+						 (u8 *)&bl_hdr,
+						 write_len)) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load Version/CRC structure\n",
+				__func__);
+			goto fail;
+		}
+	} else {
+		write_addr = PING_BUFFER_ADDRESS >> 16;
+		if ((hif_ops->master_access_msword(adapter, write_addr)) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Unable to set ms word to common reg\n",
+				__func__);
+			goto fail;
+		}
+		write_addr = RSI_SD_REQUEST_MASTER |
+			     (PING_BUFFER_ADDRESS & 0xFFFF);
+		if ((hif_ops->write_reg_multiple(adapter,
+						 write_addr,
+						 (u8 *)&bl_hdr,
+						 write_len)) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load Version/CRC structure\n",
+				__func__);
+			goto fail;
+		}
+	}
+	return 0;
+
+fail:
+	return -EINVAL;
+}
+
+/**
+ * read_flash_capacity() - This function reads the flash size from device
+ *
+ * @adapter: Pointer to the hardware structure.
+ *
+ * Return: flash capacity on success, 0 on failure.
+ */
+static u32 read_flash_capacity(struct rsi_hw *adapter)
+{
+	u32 flash_sz = 0;
+
+	if ((adapter->host_intf_ops->master_reg_read(adapter,
+						     FLASH_SIZE_ADDR,
+						     &flash_sz, 2)) < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Flash size reading failed..\n",
+			__func__);
+		return 0;
+	}
+	rsi_dbg(INIT_ZONE, "Flash capacity: %d KiloBytes\n", flash_sz);
+
+	return (flash_sz * 1024); /* Return size in kbytes */
+}
+
+/**
+ * ping_pong_write() - This function writes the flash contents throgh ping
+ *			pong buffers
+ *
+ * @adapter: Pointer to the hardware structure.
+ * @cmd: command ping/pong write
+ * @addr: address to write
+ * @size: size
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int ping_pong_write(struct rsi_hw *adapter, u8 cmd, u8 *addr, u32 size)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	u32 block_size = 0;
+	u32 cmd_addr;
+	u16 cmd_resp = 0, cmd_req = 0;
+	u8 *str;
+
+	if (adapter->rsi_host_intf == RSI_HOST_INTF_SDIO)
+		block_size = RSI_USB_BLOCK_SIZE;
+	else
+		block_size = RSI_SDIO_BLOCK_SIZE;
+
+	if (cmd == PING_WRITE) {
+		cmd_addr = PING_BUFFER_ADDRESS;
+		cmd_resp = PONG_AVAIL;
+		cmd_req = PING_VALID;
+		str = "PING_VALID";
+	} else {
+		cmd_addr = PONG_BUFFER_ADDRESS;
+		cmd_resp = PING_AVAIL;
+		cmd_req = PONG_VALID;
+		str = "PONG_VALID";
+	}
+
+	if (hif_ops->load_data_master_write(adapter,
+					    cmd_addr,
+					    size,
+					    block_size,
+					    addr)) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to write blk at addr %0x\n",
+			__func__, *addr);
+		goto fail;
+	}
+	if (bl_cmd(adapter, cmd_req, cmd_resp, str) < 0) {
+		bl_stop_cmd_timer(adapter);
+		goto fail;
+	}
+	return 0;
+
+fail:
+	return -EINVAL;
+}
+
+/**
+ * auto_fw_upgrade() - This function loads the firmware to device
+ *
+ * @adapter: Pointer to the hardware structure.
+ * @flash_content: Firmware to load
+ * @content_size: Size of the firmware
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int auto_fw_upgrade(struct rsi_hw *adapter,
+			   u8 *flash_content,
+			   u32 content_size)
+{
+	u8 cmd;
+	u8 *temp_flash_content;
+	u32 temp_content_size;
+	u32 num_flash;
+	u32 index;
+	u32 flash_start_address;
+
+	temp_flash_content = flash_content;
+
+	if (content_size > MAX_FLASH_FILE_SIZE) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Flash Content size is more than 400K %u\n",
+			__func__, MAX_FLASH_FILE_SIZE);
+		goto fail;
+	}
+
+	flash_start_address = cpu_to_le32(
+				*(u32 *)&flash_content[FLASHING_START_ADDRESS]);
+	rsi_dbg(INFO_ZONE, "flash start address: %08x\n", flash_start_address);
+
+	if (flash_start_address < FW_IMAGE_MIN_ADDRESS) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Fw image Flash Start Address is less than 64K\n",
+			__func__);
+		goto fail;
+	}
+
+	if (flash_start_address % FLASH_SECTOR_SIZE) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Flash Start Address is not multiple of 4K\n",
+			__func__);
+		goto fail;
+	}
+
+	if ((flash_start_address + content_size) > adapter->flash_capacity) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Flash Content will cross max flash size\n",
+			__func__);
+		goto fail;
+	}
+
+	temp_content_size  = content_size;
+	num_flash = content_size / FLASH_WRITE_CHUNK_SIZE;
+
+	rsi_dbg(INFO_ZONE, "content_size: %d\n", content_size);
+	rsi_dbg(INFO_ZONE, "num_flash: %d\n", num_flash);
+
+	for (index = 0; index <= num_flash; index++) {
+		rsi_dbg(INFO_ZONE, "flash index: %d\n", index);
+		if (index != num_flash) {
+			content_size = FLASH_WRITE_CHUNK_SIZE;
+			rsi_dbg(INFO_ZONE,
+				"QSPI content_size:%d\n",
+				content_size);
+		} else {
+			content_size =
+				temp_content_size % FLASH_WRITE_CHUNK_SIZE;
+			rsi_dbg(INFO_ZONE,
+				"Writing last sector content_size:%d\n",
+				content_size);
+			if (!content_size) {
+				rsi_dbg(INFO_ZONE, "INSTRUCTION SIZE ZERO\n");
+				break;
+			}
+		}
+
+		if (index % 2)
+			cmd = PING_WRITE;
+		else
+			cmd = PONG_WRITE;
+
+		if (ping_pong_write(adapter,
+				    cmd,
+				    flash_content,
+				    content_size)) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Unable to load %d block\n",
+				__func__, index);
+			goto fail;
+		}
+
+		rsi_dbg(INFO_ZONE,
+			"%s: Successfully loaded block %d instructions\n",
+			__func__, index);
+		flash_content += content_size;
+	}
+
+	if (bl_cmd(adapter, EOF_REACHED, FW_LOADING_SUCCESSFUL,
+		   "EOF_REACHED") < 0) {
+		bl_stop_cmd_timer(adapter);
+		goto fail;
+	}
+	rsi_dbg(INFO_ZONE, "FW loading is done and FW is running..\n");
+	return 0;
+
+fail:
+	return -EINVAL;
+}
+
+/**
+ * rsi_load_9113_firmware () - This function loads the TA firmware for 9113
+ *				module.
+ *
+ * @adapter: Pointer to the rsi hw.
+ *
+ * Return: status: 0 on success, negative error code on failure.
+ */
+int rsi_load_9113_firmware(struct rsi_hw *adapter)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	const struct firmware *fw_entry = NULL;
+	u32 regout_val = 0;
+	u16 tmp_regout_val = 0;
+	u8 *flash_content = NULL;
+	u32 content_size = 0;
+	struct ta_metadata *metadata_p;
+
+	bl_start_cmd_timer(adapter, BL_CMD_TIMEOUT);
+
+	while (!adapter->blcmd_timer_expired) {
+		if ((hif_ops->master_reg_read(adapter,
+					      SWBL_REGOUT,
+					      &regout_val,
+					      2)) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: REGOUT read failed\n", __func__);
+			goto fail;
+		}
+		mdelay(1);
+		if ((regout_val >> 8) == REGOUT_VALID)
+			break;
+	}
+	if (adapter->blcmd_timer_expired) {
+		rsi_dbg(ERR_ZONE, "%s: REGOUT read timedout\n", __func__);
+		rsi_dbg(ERR_ZONE,
+			"%s: Soft boot loader not present\n", __func__);
+		goto fail;
+	}
+	bl_stop_cmd_timer(adapter);
+
+	rsi_dbg(INFO_ZONE, "Received Board Version Number: %x\n",
+		(regout_val & 0xff));
+
+	if ((hif_ops->master_reg_write(adapter,
+				       SWBL_REGOUT,
+				       (REGOUT_INVALID | REGOUT_INVALID << 8),
+				       2)) < 0) {
+		rsi_dbg(ERR_ZONE, "%s: REGOUT writing failed..\n", __func__);
+		goto fail;
+	}
+	mdelay(1);
+
+	if ((bl_cmd(adapter, CONFIG_AUTO_READ_MODE, CMD_PASS,
+		    "AUTO_READ_CMD")) < 0)
+		goto fail;
+
+	adapter->flash_capacity = read_flash_capacity(adapter);
+	if (adapter->flash_capacity <= 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to read flash size from EEPROM\n",
+			__func__);
+		goto fail;
+	}
+
+	metadata_p = &metadata_flash_content[adapter->priv->coex_mode];
+
+	rsi_dbg(INIT_ZONE, "%s: loading file %s\n", __func__, metadata_p->name);
+
+	if ((request_firmware(&fw_entry, metadata_p->name,
+			      adapter->device)) < 0) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to open file %s\n",
+			__func__, metadata_p->name);
+		goto fail;
+	}
+	flash_content = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
+	if (!flash_content) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to copy firmware\n", __func__);
+		goto fail;
+	}
+	content_size = fw_entry->size;
+	rsi_dbg(INFO_ZONE, "FW Length = %d bytes\n", content_size);
+
+	if (bl_write_header(adapter, flash_content, content_size)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: RPS Image header loading failed\n",
+			__func__);
+		goto fail;
+	}
+
+	/* Check whether firmware in the device and firmware to load
+	 * is same or not using crc check
+	 */
+	bl_start_cmd_timer(adapter, BL_CMD_TIMEOUT);
+	if (bl_write_cmd(adapter, CHECK_CRC, CMD_PASS, &tmp_regout_val) < 0) {
+		bl_stop_cmd_timer(adapter);
+		rsi_dbg(ERR_ZONE,
+			"%s: CHECK_CRC Command writing failed..\n",
+			__func__);
+		if ((tmp_regout_val & 0xff) == CMD_FAIL) {
+			rsi_dbg(ERR_ZONE,
+				"CRC Fail.. Proceeding to Upgrade mode\n");
+			goto fw_upgrade;
+		}
+	}
+	bl_stop_cmd_timer(adapter);
+
+	if (bl_cmd(adapter, POLLING_MODE, CMD_PASS, "POLLING_MODE") < 0)
+		goto fail;
+
+load_image_cmd:
+	if ((bl_cmd(adapter,
+		    LOAD_HOSTED_FW,
+		    LOADING_INITIATED,
+		    "LOAD_HOSTED_FW")) < 0)
+		goto fail;
+	rsi_dbg(INFO_ZONE, "Load Image command passed..\n");
+	goto success;
+
+fw_upgrade:
+	/* After burning the RPS header, firmware has to be
+	 * burned using the below steps
+	 */
+	if (bl_cmd(adapter, BURN_HOSTED_FW, SEND_RPS_FILE, "FW_UPGRADE") < 0)
+		goto fail;
+
+	rsi_dbg(INFO_ZONE, "Burn Command Pass.. Upgrading the firmware\n");
+
+	if (auto_fw_upgrade(adapter, flash_content, content_size) == 0) {
+		rsi_dbg(ERR_ZONE,
+			"***** Auto firmware upgrade successful *****\n");
+		goto load_image_cmd;
+	}
+
+	bl_cmd(adapter, CONFIG_AUTO_READ_MODE, CMD_PASS, "AUTO_READ_MODE");
+	goto fail;
+
+	rsi_dbg(INFO_ZONE, "SWBL FLASHING THROUGH SWBL PASSED...\n");
+
+success:
+	kfree(flash_content);
+	release_firmware(fw_entry);
+	return 0;
+
+fail:
+	kfree(flash_content);
+	release_firmware(fw_entry);
+	return -EINVAL;
+}
+
+/**
+ * rsi_hal_device_init() - This function initializes the Device
+ * @adapter: Pointer to the hardware structure
+ *
+ * Return: status: 0 on success, -1 on failure.
+ */
+int rsi_hal_device_init(struct rsi_hw *adapter, enum rsi_dev_model dev_model)
+{
+#ifdef CONFIG_RSI_HCI
+	adapter->priv->coex_mode = 4;
+#else
+	adapter->priv->coex_mode = 1;
+#endif
+
+	adapter->device_model = dev_model;
+	switch (adapter->device_model) {
+	case RSI_DEV_9110:
+		/* Add code for 9110 */
+		break;
+	case RSI_DEV_9113:
+		if (rsi_load_9113_firmware(adapter)) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load TA instructions\n",
+				__func__);
+			return -EINVAL;
+		}
+		break;
+	case RSI_DEV_9116:
+		/* Add code for 9116 */
+		break;
+	default:
+		return -EINVAL;
+	}
+	adapter->common_hal_fsm = COMMAN_HAL_WAIT_FOR_CARD_READY;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rsi_hal_device_init);
+
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
new file mode 100644
index 0000000..77ededc
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -0,0 +1,152 @@
+/**
+ * Copyright (c) 2014 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __RSI_HAL_H__
+#define __RSI_HAL_H__
+
+#define TA_LOAD_ADDRESS			0x00
+#define FLASH_WRITE_CHUNK_SIZE		(4 * 1024)
+#define USB_FLASH_READ_CHUNK_SIZE	((2 * 1024) - 4)
+#define SDIO_FLASH_READ_CHUNK_SIZE	(2 * 1024)
+#define FLASH_SECTOR_SIZE		(4 * 1024)
+#define STARTING_BLOCK_INDEX		0
+#define FLASH_BLOCK_SIZE		(32 * 1024)
+
+#define FLASH_SIZE_ADDR			0x04000016
+#define PING_BUFFER_ADDRESS		0x19000
+#define PONG_BUFFER_ADDRESS		0x1a000
+#define SWBL_REGIN			0x41050034
+#define SWBL_REGOUT			0x4105003c
+#define PING_WRITE			0x1
+#define PONG_WRITE			0x2
+
+#define BL_CMD_TIMEOUT			2000
+#define BL_BURN_TIMEOUT			(50 * 1000)
+
+#define MASTER_READ_MODE		1
+#define EEPROM_READ_MODE		2
+
+#define REGIN_VALID			0xA
+#define REGIN_INPUT			0xA0
+#define REGOUT_VALID			0xAB
+#define REGOUT_INVALID			(~0xAB)
+#define CMD_PASS			0xAA
+#define CMD_FAIL			0xCC
+#define INVALID_ADDR			0x4C
+
+#define BURN_BL				0x23
+#define LOAD_HOSTED_FW			'A'
+#define BURN_HOSTED_FW			'B'
+#define PING_VALID			'I'
+#define PONG_VALID			'O'
+#define PING_AVAIL			'I'
+#define PONG_AVAIL			'O'
+#define EOF_REACHED			'E'
+#define CHECK_CRC			'K'
+#define POLLING_MODE			'P'
+#define CONFIG_AUTO_READ_MODE		'R'
+#define JUMP_TO_ZERO_PC			'J'
+#define FW_LOADING_SUCCESSFUL		'S'
+#define LOADING_INITIATED		'1'
+
+/* Boot loader commands */
+#define HOST_INTF_REG_OUT		0x4105003C
+#define HOST_INTF_REG_IN		0x41050034
+#define BOARD_READY			0xABCD
+#define REG_READ			0xD1
+#define REG_WRITE			0xD2
+#define SEND_RPS_FILE			'2'
+#define BOOTUP_OPTIONS_LAST_CONFIG_NOT_SAVED 0xF1
+#define BOOTUP_OPTIONS_CHECKSUM_FAIL 0xF2
+#define INVALID_OPTION			0xF3
+#define CHECKSUM_SUCCESS		0xAA
+#define CHECKSUM_FAILURE		0xCC
+#define CHECKSUM_INVALID_ADDRESS	0x4C
+
+#define EEPROM_VERSION_OFFSET		77
+#define CALIB_CRC_OFFSET		4092
+#define MAGIC_WORD			0x5A
+#define MAGIC_WORD_OFFSET_1		40
+#define MAGIC_WORD_OFFSET_2		424
+#define FW_IMAGE_MIN_ADDRESS		(68 * 1024)
+#define FLASH_MAX_ADDRESS		(4 * 1024 * 1024) //4MB
+#define MAX_FLASH_FILE_SIZE		(400 * 1024) //400K
+#define FLASHING_START_ADDRESS		16
+#define CALIB_VALUES_START_ADDR		16
+#define SOC_FLASH_ADDR			0x04000000
+#define EEPROM_DATA_SIZE		4096
+#define CALIB_DATA_SIZE		(EEPROM_DATA_SIZE - CALIB_VALUES_START_ADDR)
+#define BL_HEADER			32
+
+#define BT_CARD_READY_IND		0x89
+#define WLAN_CARD_READY_IND		0x0
+#define COMMON_HAL_CARD_READY_IND	0x0
+#define ZIGB_CARD_READY_IND		0xff
+
+#define COMMAN_HAL_WAIT_FOR_CARD_READY	1
+#define COMMON_HAL_SEND_CONFIG_PARAMS	2
+#define COMMON_HAL_TX_ACCESS		3
+#define COMMON_HAL_WAIT_FOR_PROTO_CARD_READY 4
+#define HEX_FILE			1
+#define BIN_FILE			0
+#define UNIX_FILE_TYPE			8
+#define DOS_FILE_TYPE			9
+#define LMAC_INSTRUCTIONS_SIZE		(16  * 1024) /* 16Kbytes */
+
+#define ULP_RESET_REG			0x161
+#define WATCH_DOG_TIMER_1		0x16c
+#define WATCH_DOG_TIMER_2		0x16d
+#define WATCH_DOG_DELAY_TIMER_1		0x16e
+#define WATCH_DOG_DELAY_TIMER_2		0x16f
+#define WATCH_DOG_TIMER_ENABLE		0x170
+
+#define RESTART_WDT			BIT(11)
+#define BYPASS_ULP_ON_WDT		BIT(1)
+
+#define RF_SPI_PROG_REG_BASE_ADDR	0x40080000
+
+#define GSPI_CTRL_REG0			(RF_SPI_PROG_REG_BASE_ADDR)
+#define GSPI_CTRL_REG1			(RF_SPI_PROG_REG_BASE_ADDR + 0x2)
+#define GSPI_DATA_REG0			(RF_SPI_PROG_REG_BASE_ADDR + 0x4)
+#define GSPI_DATA_REG1			(RF_SPI_PROG_REG_BASE_ADDR + 0x6)
+#define GSPI_DATA_REG2			(RF_SPI_PROG_REG_BASE_ADDR + 0x8)
+
+#define GSPI_DMA_MODE			BIT(13)
+
+#define GSPI_2_ULP			BIT(12)
+#define GSPI_TRIG			BIT(7)
+#define GSPI_READ			BIT(6)
+#define GSPI_RF_SPI_ACTIVE		BIT(8)
+
+#define RSI_USB_BLOCK_SIZE		256
+#define RSI_SDIO_BLOCK_SIZE		252
+
+struct bl_header {
+	u32 flags;
+	u32 image_no;
+	u32 check_sum;
+	u32 flash_start_address;
+	u32 flash_len;
+} __packed;
+
+struct ta_metadata {
+	char *name;
+	unsigned int address;
+};
+
+int rsi_hal_device_init(struct rsi_hw *adapter, enum rsi_dev_model dev_model);
+
+#endif
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index dcd0957..2c2c0bb 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -204,10 +204,23 @@ struct rsi_common {
 	struct cqm_info cqm_info;
 
 	bool hw_data_qs_blocked;
+	u8 coex_mode;
+};
+
+enum host_intf {
+	RSI_HOST_INTF_SDIO = 0,
+	RSI_HOST_INTF_USB
+};
+
+enum rsi_dev_model {
+	RSI_DEV_9110 = 0,
+	RSI_DEV_9113,
+	RSI_DEV_9116
 };
 
 struct rsi_hw {
 	struct rsi_common *priv;
+	enum rsi_dev_model device_model;
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vifs[RSI_MAX_VIFS];
 	struct ieee80211_tx_queue_params edca_params[NUM_EDCA_QUEUES];
@@ -215,16 +228,43 @@ struct rsi_hw {
 
 	struct device *device;
 	u8 sc_nvifs;
+	enum host_intf rsi_host_intf;
 
 #ifdef CONFIG_RSI_DEBUGFS
 	struct rsi_debugfs *dfsentry;
 	u8 num_debugfs_entries;
 #endif
+
+	struct timer_list bl_cmd_timer;
+	u8 blcmd_timer_expired;
+	u32 flash_capacity;
+	u32 tx_blk_size;
+	u32 common_hal_fsm;
 	void *rsi_dev;
+	struct rsi_host_intf_ops *host_intf_ops;
 	int (*host_intf_read_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
 	int (*host_intf_write_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
 	int (*check_hw_queue_status)(struct rsi_hw *adapter, u8 q_num);
 	int (*rx_urb_submit)(struct rsi_hw *adapter);
 	int (*determine_event_timeout)(struct rsi_hw *adapter);
 };
+
+struct rsi_host_intf_ops {
+	int (*read_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+	int (*write_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+	int (*master_access_msword)(struct rsi_hw *adapter, u16 ms_word);
+	int (*read_reg_multiple)(struct rsi_hw *adapter, u32 addr,
+				 u8 *data, u16 count);
+	int (*write_reg_multiple)(struct rsi_hw *adapter, u32 addr,
+				  u8 *data, u16 count);
+	int (*master_reg_read)(struct rsi_hw *adapter, u32 addr,
+			       u32 *read_buf, u16 size);
+	int (*master_reg_write)(struct rsi_hw *adapter,
+				unsigned long addr, unsigned long data,
+				u16 size);
+	int (*load_data_master_write)(struct rsi_hw *adapter, u32 addr,
+				      u32 instructions_size, u16 block_size,
+				      u8 *fw);
+};
+
 #endif
-- 
2.4.11
