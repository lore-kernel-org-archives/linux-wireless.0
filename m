Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34002 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754090AbdEINcS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 09:32:18 -0400
Received: by mail-pg0-f68.google.com with SMTP id u187so15142596pgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 06:32:18 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 10/11] rsi: Add new firmware loading method
Date: Tue,  9 May 2017 19:00:13 +0530
Message-Id: <1494336614-2107-11-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170509_153226_222285_A12BE8A9)
In-Reply-To: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

The older firmware loading method has been deprecated and not in use
for any chipets. New method is introduced which works based on soft
boot loader. In this method, complete RAM image and FLASH image are
present in the flash. Before loading the functional firmware, host
issues boot loader commands to verify whether firmware to load is
different from the current functional firmware. If not, firmware
upgrade progresses and boot loader will switch to the new functional
firmware.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c  | 527 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_sdio.c |  11 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c  |  16 +-
 drivers/net/wireless/rsi/rsi_hal.h      |  90 ++++++
 drivers/net/wireless/rsi/rsi_main.h     |  10 +
 5 files changed, 644 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/rsi_hal.h

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 8fbf904..d49dbaa 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -14,7 +14,16 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/firmware.h>
 #include "rsi_mgmt.h"
+#include "rsi_hal.h"
+#include "rsi_sdio.h"
+
+/* FLASH Firmware */
+static struct ta_metadata metadata_flash_content[] = {
+	{"flash_content", 0x00010000},
+	{"rs9113_wlan_qspi.rps", 0x00010000},
+};
 
 /**
  * rsi_send_data_pkt() - This function sends the recieved data packet from
@@ -211,3 +220,521 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	rsi_indicate_tx_status(common->priv, skb, status);
 	return status;
 }
+
+static void bl_cmd_timeout(unsigned long priv)
+{
+	struct rsi_hw *adapter = (struct rsi_hw *)priv;
+
+	adapter->blcmd_timer_expired = true;
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
+	adapter->blcmd_timer_expired = false;
+	add_timer(&adapter->bl_cmd_timer);
+
+	return 0;
+}
+
+static int bl_stop_cmd_timer(struct rsi_hw *adapter)
+{
+	adapter->blcmd_timer_expired = false;
+	if (timer_pending(&adapter->bl_cmd_timer))
+		del_timer(&adapter->bl_cmd_timer);
+
+	return 0;
+}
+
+static int bl_write_cmd(struct rsi_hw *adapter, u8 cmd, u8 exp_resp,
+			u16 *cmd_resp)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	u32 regin_val = 0, regout_val = 0;
+	u32 regin_input = 0;
+	u8 output = 0;
+	int status;
+
+	regin_input = (REGIN_INPUT | adapter->priv->coex_mode);
+
+	while (!adapter->blcmd_timer_expired) {
+		regin_val = 0;
+		status = hif_ops->master_reg_read(adapter, SWBL_REGIN,
+						  &regin_val, 2);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Command %0x REGIN reading failed..\n",
+				__func__, cmd);
+			return status;
+		}
+		mdelay(1);
+		if ((regin_val >> 12) != REGIN_VALID)
+			break;
+	}
+	if (adapter->blcmd_timer_expired) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %0x REGIN reading timed out..\n",
+			__func__, cmd);
+		return -ETIMEDOUT;
+	}
+
+	rsi_dbg(INFO_ZONE,
+		"Issuing write to Regin val:%0x sending cmd:%0x\n",
+		regin_val, (cmd | regin_input << 8));
+	status = hif_ops->master_reg_write(adapter, SWBL_REGIN,
+					   (cmd | regin_input << 8), 2);
+	if (status < 0)
+		return status;
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
+		status = hif_ops->master_reg_read(adapter, SWBL_REGOUT,
+					     &regout_val, 2);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Command %0x REGOUT reading failed..\n",
+				__func__, cmd);
+			return status;
+		}
+		mdelay(1);
+		if ((regout_val >> 8) == REGOUT_VALID)
+			break;
+	}
+	if (adapter->blcmd_timer_expired) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %0x REGOUT reading timed out..\n",
+			__func__, cmd);
+		return status;
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
+		return status;
+	}
+	mdelay(1);
+
+	if (output != exp_resp) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Recvd resp %x for cmd %0x\n",
+			__func__, output, cmd);
+		return -EINVAL;
+	}
+	rsi_dbg(INFO_ZONE,
+		"%s: Recvd Expected resp %x for cmd %0x\n",
+		__func__, output, cmd);
+
+	return 0;
+}
+
+static int bl_cmd(struct rsi_hw *adapter, u8 cmd, u8 exp_resp, char *str)
+{
+	u16 regout_val = 0;
+	u32 timeout;
+	int status;
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
+		return status;
+	}
+	bl_stop_cmd_timer(adapter);
+	return 0;
+}
+
+#define CHECK_SUM_OFFSET 20
+#define LEN_OFFSET 8
+#define ADDR_OFFSET 16
+static int bl_write_header(struct rsi_hw *adapter, u8 *flash_content,
+			   u32 content_size)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	struct bl_header bl_hdr;
+	u32 write_addr, write_len;
+	int status;
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
+		status = hif_ops->write_reg_multiple(adapter, write_addr,
+						 (u8 *)&bl_hdr, write_len);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load Version/CRC structure\n",
+				__func__);
+			return status;
+		}
+	} else {
+		write_addr = PING_BUFFER_ADDRESS >> 16;
+		status = hif_ops->master_access_msword(adapter, write_addr);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Unable to set ms word to common reg\n",
+				__func__);
+			return status;
+		}
+		write_addr = RSI_SD_REQUEST_MASTER |
+			     (PING_BUFFER_ADDRESS & 0xFFFF);
+		status = hif_ops->write_reg_multiple(adapter, write_addr,
+						 (u8 *)&bl_hdr, write_len);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load Version/CRC structure\n",
+				__func__);
+			return status;
+		}
+	}
+	return 0;
+}
+
+static u32 read_flash_capacity(struct rsi_hw *adapter)
+{
+	u32 flash_sz = 0;
+
+	if ((adapter->host_intf_ops->master_reg_read(adapter, FLASH_SIZE_ADDR,
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
+	u32 block_size = adapter->block_size;
+	u32 cmd_addr;
+	u16 cmd_resp, cmd_req;
+	u8 *str;
+	int status;
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
+	status = hif_ops->load_data_master_write(adapter, cmd_addr, size,
+					    block_size, addr);
+	if (status) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to write blk at addr %0x\n",
+			__func__, *addr);
+		return status;
+	}
+
+	status = bl_cmd(adapter, cmd_req, cmd_resp, str);
+	if (status) {
+		bl_stop_cmd_timer(adapter);
+		return status;
+	}
+	return 0;
+}
+
+static int auto_fw_upgrade(struct rsi_hw *adapter, u8 *flash_content,
+			   u32 content_size)
+{
+	u8 cmd, *temp_flash_content;
+	u32 temp_content_size, num_flash, index;
+	u32 flash_start_address;
+	int status;
+
+	temp_flash_content = flash_content;
+
+	if (content_size > MAX_FLASH_FILE_SIZE) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Flash Content size is more than 400K %u\n",
+			__func__, MAX_FLASH_FILE_SIZE);
+		return -EINVAL;
+	}
+
+	flash_start_address = *(u32 *)&flash_content[FLASH_START_ADDRESS];
+	rsi_dbg(INFO_ZONE, "flash start address: %08x\n", flash_start_address);
+
+	if (flash_start_address < FW_IMAGE_MIN_ADDRESS) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Fw image Flash Start Address is less than 64K\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if (flash_start_address % FLASH_SECTOR_SIZE) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Flash Start Address is not multiple of 4K\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if ((flash_start_address + content_size) > adapter->flash_capacity) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Flash Content will cross max flash size\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	temp_content_size  = content_size;
+	num_flash = content_size / FLASH_WRITE_CHUNK_SIZE;
+
+	rsi_dbg(INFO_ZONE, "content_size: %d, num_flash: %d\n",
+		content_size, num_flash);
+
+	for (index = 0; index <= num_flash; index++) {
+		rsi_dbg(INFO_ZONE, "flash index: %d\n", index);
+		if (index != num_flash) {
+			content_size = FLASH_WRITE_CHUNK_SIZE;
+			rsi_dbg(INFO_ZONE, "QSPI content_size:%d\n",
+				content_size);
+		} else {
+			content_size =
+				temp_content_size % FLASH_WRITE_CHUNK_SIZE;
+			rsi_dbg(INFO_ZONE,
+				"Writing last sector content_size:%d\n",
+				content_size);
+			if (!content_size) {
+				rsi_dbg(INFO_ZONE, "instruction size zero\n");
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
+		if (status) {
+			rsi_dbg(ERR_ZONE, "%s: Unable to load %d block\n",
+				__func__, index);
+			return status;
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
+	if (status) {
+		bl_stop_cmd_timer(adapter);
+		return status;
+	}
+	rsi_dbg(INFO_ZONE, "FW loading is done and FW is running..\n");
+	return 0;
+}
+
+static int rsi_load_firmware(struct rsi_hw *adapter)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	const struct firmware *fw_entry = NULL;
+	u32 regout_val = 0, content_size;
+	u16 tmp_regout_val = 0;
+	u8 *flash_content = NULL;
+	struct ta_metadata *metadata_p;
+	int status;
+
+	bl_start_cmd_timer(adapter, BL_CMD_TIMEOUT);
+
+	while (!adapter->blcmd_timer_expired) {
+		status = hif_ops->master_reg_read(adapter, SWBL_REGOUT,
+					      &regout_val, 2);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: REGOUT read failed\n", __func__);
+			return status;
+		}
+		mdelay(1);
+		if ((regout_val >> 8) == REGOUT_VALID)
+			break;
+	}
+	if (adapter->blcmd_timer_expired) {
+		rsi_dbg(ERR_ZONE, "%s: REGOUT read timedout\n", __func__);
+		rsi_dbg(ERR_ZONE,
+			"%s: Soft boot loader not present\n", __func__);
+		return -ETIMEDOUT;
+	}
+	bl_stop_cmd_timer(adapter);
+
+	rsi_dbg(INFO_ZONE, "Received Board Version Number: %x\n",
+		(regout_val & 0xff));
+
+	status = hif_ops->master_reg_write(adapter, SWBL_REGOUT,
+					(REGOUT_INVALID | REGOUT_INVALID << 8),
+					2);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "%s: REGOUT writing failed..\n", __func__);
+		return status;
+	}
+	mdelay(1);
+
+	status = bl_cmd(adapter, CONFIG_AUTO_READ_MODE, CMD_PASS,
+			"AUTO_READ_CMD");
+	if (status < 0)
+		return status;
+
+	adapter->flash_capacity = read_flash_capacity(adapter);
+	if (adapter->flash_capacity <= 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to read flash size from EEPROM\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	metadata_p = &metadata_flash_content[adapter->priv->coex_mode];
+
+	rsi_dbg(INIT_ZONE, "%s: Loading file %s\n", __func__, metadata_p->name);
+	adapter->fw_file_name = metadata_p->name;
+
+	status = request_firmware(&fw_entry, metadata_p->name, adapter->device);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to open file %s\n",
+			__func__, metadata_p->name);
+		return status;
+	}
+	flash_content = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
+	if (!flash_content) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to copy firmware\n", __func__);
+		status = -EIO;
+		goto fail;
+	}
+	content_size = fw_entry->size;
+	rsi_dbg(INFO_ZONE, "FW Length = %d bytes\n", content_size);
+
+	status = bl_write_header(adapter, flash_content, content_size);
+	if (status) {
+		rsi_dbg(ERR_ZONE,
+			"%s: RPS Image header loading failed\n",
+			__func__);
+		goto fail;
+	}
+
+	bl_start_cmd_timer(adapter, BL_CMD_TIMEOUT);
+	status = bl_write_cmd(adapter, CHECK_CRC, CMD_PASS, &tmp_regout_val);
+	if (status) {
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
+	if (status)
+		goto fail;
+
+load_image_cmd:
+	status = bl_cmd(adapter, LOAD_HOSTED_FW, LOADING_INITIATED,
+			"LOAD_HOSTED_FW");
+	if (status)
+		goto fail;
+	rsi_dbg(INFO_ZONE, "Load Image command passed..\n");
+	goto success;
+
+fw_upgrade:
+	status = bl_cmd(adapter, BURN_HOSTED_FW, SEND_RPS_FILE, "FW_UPGRADE");
+	if (status)
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
+	status = bl_cmd(adapter, CONFIG_AUTO_READ_MODE, CMD_PASS,
+			"AUTO_READ_MODE");
+	if (status)
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
+	struct rsi_common *common = adapter->priv;
+
+	common->coex_mode = 1;
+	adapter->device_model = RSI_DEV_9113;
+
+	switch (adapter->device_model) {
+	case RSI_DEV_9113:
+		if (rsi_load_firmware(adapter)) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load TA instructions\n",
+				__func__);
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rsi_hal_device_init);
+
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b397e2c..2ef844a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include "rsi_sdio.h"
 #include "rsi_common.h"
+#include "rsi_hal.h"
 
 /**
  * rsi_sdio_set_cmd52_arg() - This function prepares cmd 52 read/write arg.
@@ -365,6 +366,7 @@ static int rsi_setblocklength(struct rsi_hw *adapter, u32 length)
 
 	status = sdio_set_block_size(dev->pfunction, length);
 	dev->pfunction->max_blksize = 256;
+	adapter->block_size = dev->pfunction->max_blksize;
 
 	rsi_dbg(INFO_ZONE,
 		"%s: Operational blk length is %d\n", __func__, length);
@@ -868,6 +870,7 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 static struct rsi_host_intf_ops sdio_host_intf_ops = {
 	.write_pkt		= rsi_sdio_host_intf_write_pkt,
 	.read_pkt		= rsi_sdio_host_intf_read_pkt,
+	.master_access_msword	= rsi_sdio_master_access_msword,
 	.read_reg_multiple	= rsi_sdio_read_register_multiple,
 	.write_reg_multiple	= rsi_sdio_write_register_multiple,
 	.master_reg_read	= rsi_sdio_master_reg_read,
@@ -906,13 +909,19 @@ static int rsi_probe(struct sdio_func *pfunction,
 		goto fail;
 	}
 
-	if (rsi_sdio_device_init(adapter->priv)) {
+	if (rsi_hal_device_init(adapter)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in device init\n", __func__);
 		sdio_claim_host(pfunction);
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
 
 	sdio_claim_host(pfunction);
 	if (sdio_claim_irq(pfunction, rsi_handle_interrupt)) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 7156fcb..10dc724 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -17,6 +17,7 @@
 
 #include <linux/module.h>
 #include "rsi_usb.h"
+#include "rsi_hal.h"
 
 /**
  * rsi_usb_card_write() - This function writes to the USB Card.
@@ -515,6 +516,7 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	}
 	rsi_dev->rx_usb_urb[0]->transfer_buffer = adapter->priv->rx_data_pkt;
 	rsi_dev->tx_blk_size = 252;
+	adapter->block_size = rsi_dev->tx_blk_size;
 
 	/* Initializing function callbacks */
 	adapter->rx_urb_submit = rsi_rx_urb_submit;
@@ -573,6 +575,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 			__func__);
 		return -ENOMEM;
 	}
+	adapter->rsi_host_intf = RSI_HOST_INTF_USB;
 
 	status = rsi_init_usb_interface(adapter, pfunction);
 	if (status) {
@@ -586,25 +589,20 @@ static int rsi_probe(struct usb_interface *pfunction,
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
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
new file mode 100644
index 0000000..e1c26e5
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -0,0 +1,90 @@
+/**
+ * Copyright (c) 2017 Redpine Signals Inc.
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
+#define FLASH_WRITE_CHUNK_SIZE		(4 * 1024)
+#define FLASH_SECTOR_SIZE		(4 * 1024)
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
+#define SEND_RPS_FILE			'2'
+
+#define FW_IMAGE_MIN_ADDRESS		(68 * 1024)
+#define FLASH_MAX_ADDRESS		(4 * 1024 * 1024) //4MB
+#define MAX_FLASH_FILE_SIZE		(400 * 1024) //400K
+#define FLASH_START_ADDRESS		16
+#define CALIB_VALUES_START_ADDR		16
+#define EEPROM_DATA_SIZE		4096
+#define BL_HEADER			32
+
+#define WLAN_CARD_READY_IND		0x0
+#define COMMON_HAL_CARD_READY_IND	0x0
+
+#define COMMAN_HAL_WAIT_FOR_CARD_READY	1
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
+int rsi_hal_device_init(struct rsi_hw *adapter);
+
+#endif
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 2ac5bcf..ea4fc22 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -82,6 +82,8 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 	((_q) == VI_Q) ? IEEE80211_AC_VI : \
 	IEEE80211_AC_VO)
 
+#define RSI_DEV_9113		1
+
 struct version_info {
 	u16 major;
 	u16 minor;
@@ -204,6 +206,7 @@ struct rsi_common {
 	struct cqm_info cqm_info;
 
 	bool hw_data_qs_blocked;
+	u8 coex_mode;
 	
 	int tx_power;
 	u8 ant_in_use;
@@ -216,6 +219,7 @@ enum host_intf {
 
 struct rsi_hw {
 	struct rsi_common *priv;
+	u8 device_model;
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vifs[RSI_MAX_VIFS];
 	struct ieee80211_tx_queue_params edca_params[NUM_EDCA_QUEUES];
@@ -225,10 +229,15 @@ struct rsi_hw {
 	u8 sc_nvifs;
 
 	enum host_intf rsi_host_intf;
+	u16 block_size;
 #ifdef CONFIG_RSI_DEBUGFS
 	struct rsi_debugfs *dfsentry;
 	u8 num_debugfs_entries;
 #endif
+	char *fw_file_name;
+	struct timer_list bl_cmd_timer;
+	bool blcmd_timer_expired;
+	u32 flash_capacity;
 	u8 dfs_region;
 	void *rsi_dev;
 	struct rsi_host_intf_ops *host_intf_ops;
@@ -240,6 +249,7 @@ struct rsi_hw {
 struct rsi_host_intf_ops {
 	int (*read_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
 	int (*write_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+	int (*master_access_msword)(struct rsi_hw *adapter, u16 ms_word);
 	int (*read_reg_multiple)(struct rsi_hw *adapter, u32 addr,
 				 u8 *data, u16 count);
 	int (*write_reg_multiple)(struct rsi_hw *adapter, u32 addr,
-- 
2.7.4
