Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34571 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdDDFDC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 01:03:02 -0400
Received: by mail-pg0-f67.google.com with SMTP id o123so34545053pga.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 22:03:02 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 2/3] rsi: Add new firmware loading method for RS9113 chip set
Date: Tue,  4 Apr 2017 10:31:11 +0530
Message-Id: <1491282071-2953-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20170404_070307_183429_CB30B6E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The older firmware loading method has been deprecated and not
in use with the current RS9113 modules. The newer method uses
soft boot loader to load the functional firmware.
In this method complete RAM image and FLASH image are present
in the flash. Before loading the functional firmware, host
issues boot loader commands to verify whether the firmware
to load is different from the firmware in device. If it is
different, firmware upgrade will progress and then boot loader
switches to the functional firmware.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 595 +++++++++++++++++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_main.c     |   2 +
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 267 ++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  42 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 166 +++++++-
 drivers/net/wireless/rsi/rsi_hal.h          | 110 +++++
 drivers/net/wireless/rsi/rsi_main.h         |  46 ++-
 drivers/net/wireless/rsi/rsi_sdio.h         |   5 +-
 drivers/net/wireless/rsi/rsi_usb.h          |   4 +-
 9 files changed, 1146 insertions(+), 91 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/rsi_hal.h

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 02920c9..7f78ca1 100644
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
@@ -14,7 +17,17 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/firmware.h>
+#include <linux/jiffies.h>
 #include "rsi_mgmt.h"
+#include "rsi_hal.h"
+#include "rsi_sdio.h"
+
+/* FLASH Firmware */
+struct ta_metadata metadata_flash_content[] = {
+	{"flash_content", 0x00010000},
+	{"RS9113_wlan_qspi.rps", 0x00010000},
+};
 
 /**
  * rsi_send_data_pkt() - This function sends the recieved data packet from
@@ -100,9 +113,9 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 				    (skb->priority & 0xf) |
 				    (tx_params->sta_id << 8));
 
-	status = adapter->host_intf_write_pkt(common->priv,
-					      skb->data,
-					      skb->len);
+	status = adapter->host_intf_ops->write_pkt(common->priv,
+						   skb->data,
+						   skb->len);
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to write pkt\n",
 			__func__);
@@ -148,9 +161,9 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 		}
 		skb_push(skb, extnd_size);
 		skb->data[extnd_size + 4] = extnd_size;
-		status = adapter->host_intf_write_pkt(common->priv,
-						      (u8 *)skb->data,
-						      skb->len);
+		status = adapter->host_intf_ops->write_pkt(common->priv,
+							   (u8 *)skb->data,
+							   skb->len);
 		if (status) {
 			rsi_dbg(ERR_ZONE,
 				"%s: Failed to write the packet\n", __func__);
@@ -203,9 +216,9 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 
 	msg[7] |= cpu_to_le16(vap_id << 8);
 
-	status = adapter->host_intf_write_pkt(common->priv,
-					      (u8 *)msg,
-					      skb->len);
+	status = adapter->host_intf_ops->write_pkt(common->priv,
+						   (u8 *)msg,
+						   skb->len);
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to write the packet\n", __func__);
 
@@ -213,3 +226,567 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	rsi_indicate_tx_status(common->priv, skb, status);
 	return status;
 }
+
+static void bl_cmd_timeout(unsigned long priv)
+{
+	struct rsi_hw *adapter = (struct rsi_hw *)priv;
+
+	adapter->blcmd_timer_expired = 1;
+	del_timer(&adapter->bl_cmd_timer);
+}
+
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
+static int bl_stop_cmd_timer(struct rsi_hw *adapter)
+{
+	adapter->blcmd_timer_expired = 0;
+	if (timer_pending(&adapter->bl_cmd_timer))
+		del_timer(&adapter->bl_cmd_timer);
+
+	return 0;
+}
+
+static int bl_write_cmd(struct rsi_hw *adapter, u8 cmd,
+			u8 exp_resp, u16 *cmd_resp)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	u32 regin_val = 0, regout_val = 0;
+	u8 output = 0;
+	u32 regin_input = 0;
+	int status = -EINVAL;
+
+	regin_input = (REGIN_INPUT | adapter->priv->coex_mode);
+
+	while (!adapter->blcmd_timer_expired) {
+		regin_val = 0;
+		status = hif_ops->master_reg_read(adapter,
+						  SWBL_REGIN,
+						  &regin_val,
+						  2);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Command %0x REGIN reading failed..\n",
+				__func__, cmd);
+			goto fail;
+		}
+		mdelay(1);
+		if ((regin_val >> 12) != REGIN_VALID)
+			break;
+	}
+	if (adapter->blcmd_timer_expired) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %0x REGIN reading timed out..\n",
+			__func__, cmd);
+		status = -ETIMEDOUT;
+		goto fail;
+	}
+
+	rsi_dbg(INFO_ZONE,
+		"Issuing write to Regin val:%0x sending cmd:%0x\n",
+		regin_val, (cmd | regin_input << 8));
+	status = hif_ops->master_reg_write(adapter, SWBL_REGIN,
+					   (cmd | regin_input << 8), 2);
+	if (status < 0)
+		goto fail;
+	mdelay(1);
+
+	if (cmd == LOAD_HOSTED_FW || cmd == JUMP_TO_ZERO_PC) {
+		/* JUMP_TO_ZERO_PC does not expect
+		 * any response. So return from here
+		 */
+		return 0;
+	}
+
+	while (!adapter->blcmd_timer_expired) {
+		regout_val = 0;
+		status = hif_ops->master_reg_read(adapter,
+						  SWBL_REGOUT,
+						  &regout_val,
+						  2);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Command %0x REGOUT reading failed..\n",
+				__func__, cmd);
+			goto fail;
+		}
+		mdelay(1);
+		if ((regout_val >> 8) == REGOUT_VALID)
+			break;
+	}
+	if (adapter->blcmd_timer_expired) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %0x REGOUT reading timed out..\n",
+			__func__, cmd);
+		status = -ETIMEDOUT;
+		goto fail;
+	}
+
+	*cmd_resp = ((u16 *)&regout_val)[0] & 0xffff;
+
+	output = ((u8 *)&regout_val)[0] & 0xff;
+
+	status = hif_ops->master_reg_write(adapter, SWBL_REGOUT,
+					   (cmd | REGOUT_INVALID << 8), 2);
+	if (status < 0) {
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
+	return status;
+}
+
+static int bl_cmd(struct rsi_hw *adapter, u8 cmd, u8 exp_resp, char *str)
+{
+	u16 regout_val = 0;
+	u32 timeout = 0;
+	int status = -EINVAL;
+
+	if ((cmd == EOF_REACHED) || (cmd == PING_VALID) || (cmd == PONG_VALID))
+		timeout = BL_BURN_TIMEOUT;
+	else
+		timeout = BL_CMD_TIMEOUT;
+
+	bl_start_cmd_timer(adapter, timeout);
+	status = bl_write_cmd(adapter, cmd, exp_resp, &regout_val);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %s (%0x) writing failed..\n",
+			__func__, str, cmd);
+		goto fail;
+	}
+	bl_stop_cmd_timer(adapter);
+	return 0;
+
+fail:
+	return status;
+}
+
+static int bl_write_header(struct rsi_hw *adapter,
+			   u8 *flash_content, u32 content_size)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	struct bl_header bl_hdr;
+	u32 write_addr, write_len;
+	int status = -EINVAL;
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
+	if (adapter->host_intf == RSI_HOST_INTF_USB) {
+		write_addr = PING_BUFFER_ADDRESS;
+		status = hif_ops->write_reg_multiple(adapter,
+						     write_addr,
+						     (u8 *)&bl_hdr,
+						     write_len);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load Version/CRC structure\n",
+				__func__);
+			goto fail;
+		}
+	} else {
+		write_addr = PING_BUFFER_ADDRESS >> 16;
+		status = hif_ops->master_access_msword(adapter, write_addr);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Unable to set ms word to common reg\n",
+				__func__);
+			goto fail;
+		}
+		write_addr = RSI_SD_REQUEST_MASTER |
+			     (PING_BUFFER_ADDRESS & 0xFFFF);
+		status = hif_ops->write_reg_multiple(adapter,
+						     write_addr,
+						     (u8 *)&bl_hdr,
+						     write_len);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load Version/CRC structure\n",
+				__func__);
+			goto fail;
+		}
+	}
+	return 0;
+
+fail:
+	return status;
+}
+
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
+static int ping_pong_write(struct rsi_hw *adapter, u8 cmd, u8 *addr, u32 size)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	u32 block_size = adapter->tx_blk_size;
+	u32 cmd_addr;
+	u16 cmd_resp = 0, cmd_req = 0;
+	u8 *str;
+	int status = -EINVAL;
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
+	status = hif_ops->load_data_master_write(adapter,
+						 cmd_addr,
+						 size,
+						 block_size,
+						 addr);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to write blk at addr %0x\n",
+			__func__, *addr);
+		goto fail;
+	}
+	status = bl_cmd(adapter, cmd_req, cmd_resp, str);
+	if (status <  0) {
+		bl_stop_cmd_timer(adapter);
+		goto fail;
+	}
+	return 0;
+
+fail:
+	return status;
+}
+
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
+	int status = -EINVAL;
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
+				*(u32 *)&flash_content[FLASH_START_ADDRESS]);
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
+				rsi_dbg(INFO_ZONE, "instruction size ZERO\n");
+				break;
+			}
+		}
+
+		if (index % 2)
+			cmd = PING_WRITE;
+		else
+			cmd = PONG_WRITE;
+
+		status = ping_pong_write(adapter, cmd, flash_content,
+					 content_size);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Unable to load %d block\n",
+				__func__, index);
+			goto fail;
+		}
+
+		rsi_dbg(INFO_ZONE,
+			"%s: Successfully loaded %d instructions\n",
+			__func__, index);
+		flash_content += content_size;
+	}
+
+	status = bl_cmd(adapter, EOF_REACHED, FW_LOADING_SUCCESSFUL,
+			"EOF_REACHED");
+	if (status < 0) {
+		bl_stop_cmd_timer(adapter);
+		goto fail;
+	}
+	rsi_dbg(INFO_ZONE, "FW loading is done and FW is running..\n");
+	return 0;
+
+fail:
+	return status;
+}
+
+int rsi_load_firmware(struct rsi_hw *adapter)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	const struct firmware *fw_entry = NULL;
+	u32 regout_val = 0;
+	u16 tmp_regout_val = 0;
+	u8 *flash_content = NULL;
+	u32 content_size = 0;
+	struct ta_metadata *metadata_p;
+	int status = -EINVAL;
+
+	bl_start_cmd_timer(adapter, BL_CMD_TIMEOUT);
+
+	while (!adapter->blcmd_timer_expired) {
+		status = hif_ops->master_reg_read(adapter,
+						  SWBL_REGOUT,
+						  &regout_val,
+						  2);
+		if (status < 0) {
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
+		status = -ETIMEDOUT;
+		goto fail;
+	}
+	bl_stop_cmd_timer(adapter);
+
+	rsi_dbg(INFO_ZONE, "Received Board Version Number: %x\n",
+		(regout_val & 0xff));
+
+	status = hif_ops->master_reg_write(adapter,
+					SWBL_REGOUT,
+					(REGOUT_INVALID | REGOUT_INVALID << 8),
+					2);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "%s: REGOUT writing failed..\n", __func__);
+		goto fail;
+	}
+	mdelay(1);
+
+	status = bl_cmd(adapter, CONFIG_AUTO_READ_MODE, CMD_PASS,
+			"AUTO_READ_CMD");
+	if (status < 0)
+		goto fail;
+
+	adapter->flash_capacity = read_flash_capacity(adapter);
+	if (adapter->flash_capacity <= 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to read flash size from EEPROM\n",
+			__func__);
+		status = -EIO;
+		goto fail;
+	}
+
+	metadata_p = &metadata_flash_content[adapter->priv->coex_mode];
+
+	rsi_dbg(INIT_ZONE, "%s: Loading file %s\n", __func__, metadata_p->name);
+
+	status = request_firmware(&fw_entry, metadata_p->name, adapter->device);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to open file %s err=%d\n",
+			__func__, metadata_p->name, status);
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
+	status = bl_write_header(adapter, flash_content, content_size);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: RPS Image header loading failed\n",
+			__func__);
+		goto fail;
+	}
+
+	bl_start_cmd_timer(adapter, BL_CMD_TIMEOUT);
+	status = bl_write_cmd(adapter, CHECK_CRC, CMD_PASS, &tmp_regout_val);
+	if (status < 0) {
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
+	status = bl_cmd(adapter, POLLING_MODE, CMD_PASS, "POLLING_MODE");
+	if (status < 0)
+		goto fail;
+
+load_image_cmd:
+	status = bl_cmd(adapter, LOAD_HOSTED_FW, LOADING_INITIATED,
+			"LOAD_HOSTED_FW");
+	if (status < 0)
+		goto fail;
+
+	rsi_dbg(INFO_ZONE, "Load Image command passed..\n");
+	goto success;
+
+fw_upgrade:
+	status = bl_cmd(adapter, BURN_HOSTED_FW, SEND_RPS_FILE, "FW_UPGRADE");
+	if (status < 0)
+		goto fail;
+
+	rsi_dbg(INFO_ZONE, "Burn Command Pass.. Upgrading the firmware\n");
+
+	status = auto_fw_upgrade(adapter, flash_content, content_size);
+	if (status == 0) {
+		rsi_dbg(ERR_ZONE, "Firmware upgradation Done\n");
+		goto load_image_cmd;
+	}
+	rsi_dbg(ERR_ZONE, "Firmware upgrade failed\n");
+
+	status = bl_cmd(adapter, CONFIG_AUTO_READ_MODE,
+			CMD_PASS, "AUTO_READ_MODE");
+	if (status < 0)
+		goto fail;
+
+success:
+	rsi_dbg(ERR_ZONE, "***** Firmware Loading successful *****\n");
+	kfree(flash_content);
+	release_firmware(fw_entry);
+	return 0;
+
+fail:
+	rsi_dbg(ERR_ZONE, "##### Firmware loading failed #####\n");
+	kfree(flash_content);
+	release_firmware(fw_entry);
+	return status;
+}
+
+int rsi_hal_device_init(struct rsi_hw *adapter)
+{
+	int status = 0;
+
+	switch (adapter->device_model) {
+	case RSI_DEV_9110:
+		/* TODO: 9110 FW load */
+		break;
+	case RSI_DEV_9113:
+		status = rsi_load_firmware(adapter);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load TA instructions\n",
+				__func__);
+			return status;
+		}
+		break;
+	case RSI_DEV_9116:
+		/* TODO: 9116 FW load */
+		break;
+	default:
+		return -EINVAL;
+	}
+	adapter->common_hal_fsm = FSM_CARD_NOT_READY;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rsi_hal_device_init);
+
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 8810862..d5a9aa8 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -207,6 +207,8 @@ struct rsi_hw *rsi_91x_init(void)
 		common = adapter->priv;
 		common->priv = adapter;
 	}
+	adapter->device_model = RSI_DEV_9113;
+	common->coex_mode = 1; /* Wi-Fi only mode */
 
 	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
 		skb_queue_head_init(&common->tx_queue[ii]);
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 8428858..775640f 100644
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
@@ -365,6 +368,7 @@ static int rsi_setblocklength(struct rsi_hw *adapter, u32 length)
 
 	status = sdio_set_block_size(dev->pfunction, length);
 	dev->pfunction->max_blksize = 256;
+	adapter->tx_blk_size = dev->pfunction->max_blksize;
 
 	rsi_dbg(INFO_ZONE,
 		"%s: Operational blk length is %d\n", __func__, length);
@@ -393,6 +397,38 @@ static int rsi_setupcard(struct rsi_hw *adapter)
 	return status;
 }
 
+int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word)
+{
+	u8 byte;
+	u8 function = 0;
+	int status = 0;
+
+	byte = (u8)(ms_word & 0x00FF);
+
+	rsi_dbg(INIT_ZONE,
+		"%s: MASTER_ACCESS_MSBYTE:0x%x\n", __func__, byte);
+
+	status = rsi_sdio_write_register(adapter,
+					 function,
+					 SDIO_MASTER_ACCESS_MSBYTE,
+					 &byte);
+	if (status) {
+		rsi_dbg(ERR_ZONE,
+			"%s: fail to access MASTER_ACCESS_MSBYTE\n",
+			__func__);
+		return status;
+	}
+
+	byte = (u8)(ms_word >> 8);
+
+	rsi_dbg(INIT_ZONE, "%s:MASTER_ACCESS_LSBYTE:0x%x\n", __func__, byte);
+	status = rsi_sdio_write_register(adapter,
+					 function,
+					 SDIO_MASTER_ACCESS_LSBYTE,
+					 &byte);
+	return status;
+}
+
 /**
  * rsi_sdio_read_register() - This function reads one byte of information
  *			      from a register.
@@ -473,8 +509,6 @@ void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit)
 		rsi_dbg(ERR_ZONE, "%s: unable to send ack\n", __func__);
 }
 
-
-
 /**
  * rsi_sdio_read_register_multiple() - This function read multiple bytes of
  *				       information from the SD card.
@@ -485,10 +519,10 @@ void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit)
  *
  * Return: 0 on success, -1 on failure.
  */
-static int rsi_sdio_read_register_multiple(struct rsi_hw *adapter,
-					   u32 addr,
-					   u32 count,
-					   u8 *data)
+int rsi_sdio_read_register_multiple(struct rsi_hw *adapter,
+				    u32 addr,
+				    u8 *data,
+				    u16 count)
 {
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
@@ -518,7 +552,7 @@ static int rsi_sdio_read_register_multiple(struct rsi_hw *adapter,
 int rsi_sdio_write_register_multiple(struct rsi_hw *adapter,
 				     u32 addr,
 				     u8 *data,
-				     u32 count)
+				     u16 count)
 {
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
@@ -552,6 +586,186 @@ int rsi_sdio_write_register_multiple(struct rsi_hw *adapter,
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
+	int status = -EINVAL;
+
+	num_blocks = instructions_sz / block_size;
+	msb_address = base_address >> 16;
+
+	rsi_dbg(INFO_ZONE, "ins_size: %d\n", instructions_sz);
+	rsi_dbg(INFO_ZONE, "num_blocks: %d\n", num_blocks);
+
+	/* Loading DM ms word in the sdio slave */
+	status = rsi_sdio_master_access_msword(adapter, msb_address);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to set ms word reg\n", __func__);
+		return status;
+	}
+
+	for (offset = 0, ii = 0; ii < num_blocks; ii++, offset += block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + offset, block_size);
+		lsb_address = (u16)base_address;
+		status = rsi_sdio_write_register_multiple(adapter,
+					lsb_address | RSI_SD_REQUEST_MASTER,
+					temp_buf, block_size);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE, "%s: failed to write\n", __func__);
+			return status;
+		}
+		rsi_dbg(INFO_ZONE, "%s: loading block: %d\n", __func__, ii);
+		base_address += block_size;
+
+		if ((base_address >> 16) != msb_address) {
+			msb_address += 1;
+
+			/* Loading DM ms word in the sdio slave */
+			status = rsi_sdio_master_access_msword(adapter,
+							       msb_address);
+			if (status < 0) {
+				rsi_dbg(ERR_ZONE,
+					"%s: Unable to set ms word reg\n",
+					__func__);
+				return status;
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
+		status = rsi_sdio_write_register_multiple(adapter,
+					lsb_address | RSI_SD_REQUEST_MASTER,
+					temp_buf,
+					instructions_sz % block_size);
+		if (status < 0)
+			return -EIO;
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
+	int status = -EINVAL;
+
+	data = PTR_ALIGN(&align[0], 8);
+
+	ms_addr = (addr >> 16);
+	status = rsi_sdio_master_access_msword(adapter, ms_addr);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to set ms word to common reg\n",
+			__func__);
+		return status;
+	}
+	addr = addr & 0xFFFF;
+
+	addr_on_bus = (addr & 0xFF000000);
+	if ((addr_on_bus == (FLASH_SIZE_ADDR & 0xFF000000)) ||
+	    (addr_on_bus == 0x0))
+		addr_on_bus = (addr & ~(0x3));
+	else
+		addr_on_bus = addr;
+
+	/* Bring TA out of reset */
+	status = rsi_sdio_read_register_multiple(adapter,
+					(addr_on_bus | RSI_SD_REQUEST_MASTER),
+					(u8 *)data, 4);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "%s: AHB register read failed\n", __func__);
+		return status;
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
+	int status = -EINVAL;
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
+	status = rsi_sdio_master_access_msword(adapter, (addr >> 16));
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to set ms word to common reg\n",
+			__func__);
+		return status;
+	}
+	addr = addr & 0xFFFF;
+
+	/* Bring TA out of reset */
+	status = rsi_sdio_write_register_multiple(adapter,
+					     (addr | RSI_SD_REQUEST_MASTER),
+					     (u8 *)data_aligned, size);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to do AHB reg write\n", __func__);
+		return status;
+	}
+	return 0;
+}
+
 /**
  * rsi_sdio_host_intf_write_pkt() - This function writes the packet to device.
  * @adapter: Pointer to the adapter structure.
@@ -560,9 +774,9 @@ int rsi_sdio_write_register_multiple(struct rsi_hw *adapter,
  *
  * Return: 0 on success, -1 on failure.
  */
-static int rsi_sdio_host_intf_write_pkt(struct rsi_hw *adapter,
-					u8 *pkt,
-					u32 len)
+int rsi_sdio_host_intf_write_pkt(struct rsi_hw *adapter,
+				 u8 *pkt,
+				 u32 len)
 {
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
@@ -583,9 +797,9 @@ static int rsi_sdio_host_intf_write_pkt(struct rsi_hw *adapter,
 
 	status = rsi_sdio_write_register_multiple(adapter,
 						  address,
-						  (u8 *)pkt,
+						  pkt,
 						  length);
-	if (status)
+	if (status < 0)
 		rsi_dbg(ERR_ZONE, "%s: Unable to write onto the card: %d\n",
 			__func__, status);
 	rsi_dbg(DATA_TX_ZONE, "%s: Successfully written onto card\n", __func__);
@@ -614,8 +828,8 @@ int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter,
 
 	status = rsi_sdio_read_register_multiple(adapter,
 						 length,
-						 length, /*num of bytes*/
-						 (u8 *)pkt);
+						 (u8 *)pkt,
+						 length);
 
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to read frame: %d\n", __func__,
@@ -676,8 +890,6 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 	}
 	sdio_release_host(pfunction);
 
-	adapter->host_intf_write_pkt = rsi_sdio_host_intf_write_pkt;
-	adapter->host_intf_read_pkt = rsi_sdio_host_intf_read_pkt;
 	adapter->determine_event_timeout = rsi_sdio_determine_event_timeout;
 	adapter->check_hw_queue_status = rsi_sdio_read_buffer_status_register;
 
@@ -691,6 +903,17 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
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
@@ -713,6 +936,8 @@ static int rsi_probe(struct sdio_func *pfunction,
 			__func__);
 		return 1;
 	}
+	adapter->host_intf = RSI_HOST_INTF_SDIO;
+	adapter->host_intf_ops = &sdio_host_intf_ops;
 
 	if (rsi_init_sdio_interface(adapter, pfunction)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to init sdio interface\n",
@@ -720,13 +945,21 @@ static int rsi_probe(struct sdio_func *pfunction,
 		goto fail;
 	}
 
-	if (rsi_sdio_device_init(adapter->priv)) {
+	if (rsi_hal_device_init(adapter)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in device init\n", __func__);
 		sdio_claim_host(pfunction);
+		sdio_release_irq(pfunction);
 		sdio_disable_func(pfunction);
 		sdio_release_host(pfunction);
 		goto fail;
 	}
+	rsi_dbg(INFO_ZONE, "===> RSI Device Init Done <===\n");
+
+	if (rsi_sdio_master_access_msword(adapter, MISC_CFG_BASE_ADDR)) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to set ms word reg\n", __func__);
+		return -EIO;
+	}
+	rsi_dbg(INIT_ZONE, "%s: Setting ms word to 0x41050000\n", __func__);
 
 	sdio_claim_host(pfunction);
 	if (sdio_claim_irq(pfunction, rsi_handle_interrupt)) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 40d7231..c516be1 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -18,47 +18,7 @@
 #include <linux/firmware.h>
 #include "rsi_sdio.h"
 #include "rsi_common.h"
-
-/**
- * rsi_sdio_master_access_msword() - This function sets the AHB master access
- *				     MS word in the SDIO slave registers.
- * @adapter: Pointer to the adapter structure.
- * @ms_word: ms word need to be initialized.
- *
- * Return: status: 0 on success, -1 on failure.
- */
-static int rsi_sdio_master_access_msword(struct rsi_hw *adapter,
-					 u16 ms_word)
-{
-	u8 byte;
-	u8 function = 0;
-	int status = 0;
-
-	byte = (u8)(ms_word & 0x00FF);
-
-	rsi_dbg(INIT_ZONE,
-		"%s: MASTER_ACCESS_MSBYTE:0x%x\n", __func__, byte);
-
-	status = rsi_sdio_write_register(adapter,
-					 function,
-					 SDIO_MASTER_ACCESS_MSBYTE,
-					 &byte);
-	if (status) {
-		rsi_dbg(ERR_ZONE,
-			"%s: fail to access MASTER_ACCESS_MSBYTE\n",
-			__func__);
-		return -1;
-	}
-
-	byte = (u8)(ms_word >> 8);
-
-	rsi_dbg(INIT_ZONE, "%s:MASTER_ACCESS_LSBYTE:0x%x\n", __func__, byte);
-	status = rsi_sdio_write_register(adapter,
-					 function,
-					 SDIO_MASTER_ACCESS_LSBYTE,
-					 &byte);
-	return status;
-}
+#include "rsi_hal.h"
 
 /**
  * rsi_copy_to_card() - This function includes the actual funtionality of
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index cc8deec..b912e4a 100644
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
@@ -16,7 +19,9 @@
  */
 
 #include <linux/module.h>
+#include <linux/usb.h>
 #include "rsi_usb.h"
+#include "rsi_hal.h"
 
 /**
  * rsi_usb_card_write() - This function writes to the USB Card.
@@ -141,6 +146,9 @@ static int rsi_find_bulk_in_and_out_endpoints(struct usb_interface *interface,
 	return 0;
 }
 
+#define RSI_USB_REQ_OUT	(USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_DEVICE)
+#define RSI_USB_REQ_IN	(USB_TYPE_VENDOR | USB_DIR_IN | USB_RECIP_DEVICE)
+
 /* rsi_usb_reg_read() - This function reads data from given register address.
  * @usbdev: Pointer to the usb_device structure.
  * @reg: Address of the register to be read.
@@ -164,7 +172,7 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 	status = usb_control_msg(usbdev,
 				 usb_rcvctrlpipe(usbdev, 0),
 				 USB_VENDOR_REGISTER_READ,
-				 USB_TYPE_VENDOR,
+				 RSI_USB_REQ_IN,
 				 ((reg & 0xffff0000) >> 16), (reg & 0xffff),
 				 (void *)buf,
 				 len,
@@ -211,7 +219,7 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 	status = usb_control_msg(usbdev,
 				 usb_sndctrlpipe(usbdev, 0),
 				 USB_VENDOR_REGISTER_WRITE,
-				 USB_TYPE_VENDOR,
+				 RSI_USB_REQ_OUT,
 				 ((reg & 0xffff0000) >> 16),
 				 (reg & 0xffff),
 				 (void *)usb_reg_buf,
@@ -273,6 +281,53 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
 	return status;
 }
 
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
+					 RSI_USB_REQ_IN,
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
 /**
  * rsi_usb_write_register_multiple() - This function writes multiple bytes of
  *				       information to multiple registers.
@@ -286,7 +341,7 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
 int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 				    u32 addr,
 				    u8 *data,
-				    u32 count)
+				    u16 count)
 {
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	u8 *buf;
@@ -303,7 +358,7 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 		status = usb_control_msg(dev->usbdev,
 					 usb_sndctrlpipe(dev->usbdev, 0),
 					 USB_VENDOR_REGISTER_WRITE,
-					 USB_TYPE_VENDOR,
+					 RSI_USB_REQ_OUT,
 					 ((addr & 0xffff0000) >> 16),
 					 (addr & 0xffff),
 					 (void *)buf,
@@ -333,9 +388,9 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
  *
  * Return: 0 on success, a negative error code on failure.
  */
-static int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
-				       u8 *pkt,
-				       u32 len)
+int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
+				u8 *pkt,
+				u32 len)
 {
 	u32 queueno = ((pkt[1] >> 4) & 0xf);
 	u8 endpoint;
@@ -348,6 +403,84 @@ static int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
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
+	return rsi_usb_reg_read(usbdev, reg, (u16 *)value, len);
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
+	u8 temp_buf[256];
+	int status = -EINVAL;
+
+	num_blocks = instructions_sz / block_size;
+	rsi_dbg(INFO_ZONE, "num_blocks: %d\n", num_blocks);
+
+	for (cur_indx = 0, ii = 0;
+	     ii < num_blocks;
+	     ii++, cur_indx += block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + cur_indx, block_size);
+		status = rsi_usb_write_register_multiple(adapter,
+							 base_address,
+							 (u8 *)(temp_buf),
+							 block_size);
+		if (status < 0)
+			return status;
+
+		rsi_dbg(INFO_ZONE, "%s: loading block: %d\n", __func__, ii);
+		base_address += block_size;
+	}
+
+	if (instructions_sz % block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + cur_indx,
+		       instructions_sz % block_size);
+		status = rsi_usb_write_register_multiple(adapter,
+						base_address,
+						(u8 *)temp_buf,
+						instructions_sz % block_size);
+		if (status < 0)
+			return status;
+		rsi_dbg(INFO_ZONE,
+			"Written Last Block in Address 0x%x Successfully\n",
+			cur_indx);
+	}
+	return 0;
+}
+
+static struct rsi_host_intf_ops usb_host_intf_ops = {
+	.write_pkt		= rsi_usb_host_intf_write_pkt,
+	.master_reg_read	= rsi_usb_master_reg_read,
+	.master_reg_write	= rsi_usb_master_reg_write,
+	.read_reg_multiple	= rsi_usb_read_register_multiple,
+	.write_reg_multiple	= rsi_usb_write_register_multiple,
+	.load_data_master_write	= rsi_usb_load_data_master_write,
+};
+
 /**
  * rsi_deinit_usb_interface() - This function deinitializes the usb interface.
  * @adapter: Pointer to the adapter structure.
@@ -376,7 +509,7 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 {
 	struct rsi_91x_usbdev *rsi_dev;
 	struct rsi_common *common = adapter->priv;
-	int status;
+	int status = 0;
 
 	rsi_dev = kzalloc(sizeof(*rsi_dev), GFP_KERNEL);
 	if (!rsi_dev)
@@ -410,12 +543,14 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	}
 	rsi_dev->rx_usb_urb[0]->transfer_buffer = adapter->priv->rx_data_pkt;
 	rsi_dev->tx_blk_size = 252;
+	adapter->tx_blk_size = rsi_dev->tx_blk_size;
 
 	/* Initializing function callbacks */
 	adapter->rx_urb_submit = rsi_rx_urb_submit;
-	adapter->host_intf_write_pkt = rsi_usb_host_intf_write_pkt;
 	adapter->check_hw_queue_status = rsi_usb_check_queue_status;
 	adapter->determine_event_timeout = rsi_usb_event_timeout;
+	adapter->host_intf = RSI_HOST_INTF_USB;
+	adapter->host_intf_ops = &usb_host_intf_ops;
 
 	rsi_init_event(&rsi_dev->rx_thread.event);
 	status = rsi_create_kthread(common, &rsi_dev->rx_thread,
@@ -480,25 +615,19 @@ static int rsi_probe(struct usb_interface *pfunction,
 	dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 
 	status = rsi_usb_reg_read(dev->usbdev, FW_STATUS_REG, &fw_status, 2);
-	if (status)
+	if (status < 0)
 		goto err1;
 	else
 		fw_status &= 1;
 
 	if (!fw_status) {
-		status = rsi_usb_device_init(adapter->priv);
+		status = rsi_hal_device_init(adapter);
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
@@ -554,6 +683,7 @@ static const struct usb_device_id rsi_dev_table[] = {
 	{ USB_DEVICE(0x041B, 0x0301) },
 	{ USB_DEVICE(0x041B, 0x0201) },
 	{ USB_DEVICE(0x041B, 0x9330) },
+	{ USB_DEVICE(0x1618, 0x9113) },
 	{ /* Blank */},
 };
 
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
new file mode 100644
index 0000000..96ae41b
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -0,0 +1,110 @@
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
+#define FIRMWARE_RSI9113		"rsi_91x.fw"
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
+#define BOOTUP_OPTIONS_CHECKSUM_FAIL	0xF2
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
+#define FLASH_START_ADDRESS		16
+#define CALIB_VALUES_START_ADDR		16
+#define SOC_FLASH_ADDR			0x04000000
+#define EEPROM_DATA_SIZE		4096
+#define CALIB_DATA_SIZE		(EEPROM_DATA_SIZE - CALIB_VALUES_START_ADDR)
+#define BL_HEADER			32
+
+struct bl_header {
+	__le32 flags;
+	__le32 image_no;
+	__le32 check_sum;
+	__le32 flash_start_address;
+	__le32 flash_len;
+} __packed;
+
+struct ta_metadata {
+	char *name;
+	unsigned int address;
+};
+
+
+int rsi_hal_device_init (struct rsi_hw *adapter);
+#endif
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 1d5904b..b76602b 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -204,13 +204,26 @@ struct rsi_common {
 	struct cqm_info cqm_info;
 
 	bool hw_data_qs_blocked;
-	
+
+	u8 coex_mode;
 	int tx_power;
 	u8 ant_in_use;
 };
 
+enum host_intf {
+	RSI_HOST_INTF_SDIO = 0,
+	RSI_HOST_INTF_USB
+};
+
+enum rsi_dev_model {
+	RSI_DEV_9110 = 0,
+	RSI_DEV_9113,
+	RSI_DEV_9116
+};
+
 struct rsi_hw {
 	struct rsi_common *priv;
+	enum rsi_dev_model device_model;
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vifs[RSI_MAX_VIFS];
 	struct ieee80211_tx_queue_params edca_params[NUM_EDCA_QUEUES];
@@ -218,17 +231,44 @@ struct rsi_hw {
 
 	struct device *device;
 	u8 sc_nvifs;
+	enum host_intf host_intf;
 
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
+
 	u8 dfs_region;
 	void *rsi_dev;
-	int (*host_intf_read_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
-	int (*host_intf_write_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+
+	struct rsi_host_intf_ops *host_intf_ops;
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
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index c7e8f2b..ab34028 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -47,7 +47,7 @@ enum sdio_interrupt_type {
 
 #define RSI_DEVICE_BUFFER_STATUS_REGISTER       0xf3
 #define RSI_FN1_INT_REGISTER                    0xf9
-#define RSI_SD_REQUEST_MASTER                   0x10000
+#define RSI_SD_REQUEST_MASTER			0x10000
 
 /* FOR SD CARD ONLY */
 #define SDIO_RX_NUM_BLOCKS_REG                  0x000F1
@@ -122,7 +122,8 @@ int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter, u8 *pkt, u32 length);
 int rsi_sdio_write_register(struct rsi_hw *adapter, u8 function,
 			    u32 addr, u8 *data);
 int rsi_sdio_write_register_multiple(struct rsi_hw *adapter, u32 addr,
-				     u8 *data, u32 count);
+				     u8 *data, u16 count);
+int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word);
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit);
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter);
 int rsi_sdio_read_buffer_status_register(struct rsi_hw *adapter, u8 q_num);
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index ebea0c4..ad16030 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -62,7 +62,9 @@ static inline int rsi_usb_event_timeout(struct rsi_hw *adapter)
 }
 
 int rsi_usb_device_init(struct rsi_common *common);
+int rsi_usb_read_register_multiple(struct rsi_hw *adapter, u32 addr,
+				   u8 *data, u16 count);
 int rsi_usb_write_register_multiple(struct rsi_hw *adapter, u32 addr,
-				    u8 *data, u32 count);
+				    u8 *data, u16 count);
 void rsi_usb_rx_thread(struct rsi_common *common);
 #endif
-- 
2.4.0
