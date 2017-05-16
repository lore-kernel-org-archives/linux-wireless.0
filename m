Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36243 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751483AbdEPKD0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:03:26 -0400
Received: by mail-pf0-f194.google.com with SMTP id n23so18272945pfb.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 03:03:21 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v3 09/11] rsi: Add new host interface operations
Date: Tue, 16 May 2017 15:31:15 +0530
Message-Id: <1494928877-27168-10-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170516_120349_802487_20CA3745)
In-Reply-To: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Host interface opearation master_reg_read, master_reg_write and
load_data_master_write are added. These functions are needed for the
new firmware loading method. As part of this, the function
master_access_msword is moved from rsi_91x_sdio_ops.c to rsi_91x_sdio.c.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v3: Same as earlier
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 179 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |   3 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c      |  65 ++++++++++
 drivers/net/wireless/rsi/rsi_main.h         |   8 ++
 drivers/net/wireless/rsi/rsi_sdio.h         |   1 +
 5 files changed, 254 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index bdbec8b..b397e2c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -552,6 +552,182 @@ int rsi_sdio_write_register_multiple(struct rsi_hw *adapter,
 	return status;
 }
 
+static int rsi_sdio_load_data_master_write(struct rsi_hw *adapter,
+					   u32 base_address,
+					   u32 instructions_sz,
+					   u16 block_size,
+					   u8 *ta_firmware)
+{
+	u32 num_blocks, offset, i;
+	u16 msb_address, lsb_address;
+	u8 temp_buf[block_size];
+	int status;
+
+	num_blocks = instructions_sz / block_size;
+	msb_address = base_address >> 16;
+
+	rsi_dbg(INFO_ZONE, "ins_size: %d, num_blocks: %d\n",
+		instructions_sz, num_blocks);
+
+	/* Loading DM ms word in the sdio slave */
+	status = rsi_sdio_master_access_msword(adapter, msb_address);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to set ms word reg\n", __func__);
+		return status;
+	}
+
+	for (offset = 0, i = 0; i < num_blocks; i++, offset += block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + offset, block_size);
+		lsb_address = (u16)base_address;
+		status = rsi_sdio_write_register_multiple
+					(adapter,
+					 lsb_address | RSI_SD_REQUEST_MASTER,
+					 temp_buf, block_size);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE, "%s: failed to write\n", __func__);
+			return status;
+		}
+		rsi_dbg(INFO_ZONE, "%s: loading block: %d\n", __func__, i);
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
+		memcpy(temp_buf, ta_firmware + offset,
+		       instructions_sz % block_size);
+		lsb_address = (u16)base_address;
+		status = rsi_sdio_write_register_multiple
+					(adapter,
+					 lsb_address | RSI_SD_REQUEST_MASTER,
+					 temp_buf,
+					 instructions_sz % block_size);
+		if (status < 0)
+			return status;
+		rsi_dbg(INFO_ZONE,
+			"Written Last Block in Address 0x%x Successfully\n",
+			offset | RSI_SD_REQUEST_MASTER);
+	}
+	return 0;
+}
+
+#define FLASH_SIZE_ADDR                 0x04000016
+static int rsi_sdio_master_reg_read(struct rsi_hw *adapter, u32 addr,
+				    u32 *read_buf, u16 size)
+{
+	u32 addr_on_bus, *data;
+	u32 align[2] = {};
+	u16 ms_addr;
+	int status;
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
+	addr &= 0xFFFF;
+
+	addr_on_bus = (addr & 0xFF000000);
+	if ((addr_on_bus == (FLASH_SIZE_ADDR & 0xFF000000)) ||
+	    (addr_on_bus == 0x0))
+		addr_on_bus = (addr & ~(0x3));
+	else
+		addr_on_bus = addr;
+
+	/* Bring TA out of reset */
+	status = rsi_sdio_read_register_multiple
+					(adapter,
+					 (addr_on_bus | RSI_SD_REQUEST_MASTER),
+					 (u8 *)data, 4);
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
+	} else {
+		*read_buf = *data;
+	}
+
+	return 0;
+}
+
+static int rsi_sdio_master_reg_write(struct rsi_hw *adapter,
+				     unsigned long addr,
+				     unsigned long data, u16 size)
+{
+	unsigned long data1[2], *data_aligned;
+	int status;
+
+	data_aligned = PTR_ALIGN(&data1[0], 8);
+
+	if (size == 2) {
+		*data_aligned = ((data << 16) | (data & 0xFFFF));
+	} else if (size == 1) {
+		u32 temp_data = data & 0xFF;
+
+		*data_aligned = ((temp_data << 24) | (temp_data << 16) |
+				 (temp_data << 8) | temp_data);
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
+		return -EIO;
+	}
+	addr = addr & 0xFFFF;
+
+	/* Bring TA out of reset */
+	status = rsi_sdio_write_register_multiple
+					(adapter,
+					 (addr | RSI_SD_REQUEST_MASTER),
+					 (u8 *)data_aligned, size);
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
@@ -694,6 +870,9 @@ static struct rsi_host_intf_ops sdio_host_intf_ops = {
 	.read_pkt		= rsi_sdio_host_intf_read_pkt,
 	.read_reg_multiple	= rsi_sdio_read_register_multiple,
 	.write_reg_multiple	= rsi_sdio_write_register_multiple,
+	.master_reg_read	= rsi_sdio_master_reg_read,
+	.master_reg_write	= rsi_sdio_master_reg_write,
+	.load_data_master_write	= rsi_sdio_load_data_master_write,
 };
 
 /**
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 7c9cf01..225042f 100644
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
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 9000e09..b10b145 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -392,10 +392,75 @@ static int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
 				  len);
 }
 
+static int rsi_usb_master_reg_read(struct rsi_hw *adapter, u32 reg,
+				   u32 *value, u16 len)
+{
+	struct usb_device *usbdev =
+		((struct rsi_91x_usbdev *)adapter->rsi_dev)->usbdev;
+
+	return rsi_usb_reg_read(usbdev, reg, (u16 *)value, len);
+}
+
+static int rsi_usb_master_reg_write(struct rsi_hw *adapter,
+				    unsigned long reg,
+				    unsigned long value, u16 len)
+{
+	struct usb_device *usbdev =
+		((struct rsi_91x_usbdev *)adapter->rsi_dev)->usbdev;
+
+	return rsi_usb_reg_write(usbdev, reg, value, len);
+}
+
+static int rsi_usb_load_data_master_write(struct rsi_hw *adapter,
+					  u32 base_address,
+					  u32 instructions_sz, u16 block_size,
+					  u8 *ta_firmware)
+{
+	u16 num_blocks;
+	u32 cur_indx, i;
+	u8 temp_buf[256];
+	int status;
+
+	num_blocks = instructions_sz / block_size;
+	rsi_dbg(INFO_ZONE, "num_blocks: %d\n", num_blocks);
+
+	for (cur_indx = 0, i = 0; i < num_blocks; i++, cur_indx += block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + cur_indx, block_size);
+		status = rsi_usb_write_register_multiple(adapter, base_address,
+							 (u8 *)(temp_buf),
+							 block_size);
+		if (status < 0)
+			return status;
+
+		rsi_dbg(INFO_ZONE, "%s: loading block: %d\n", __func__, i);
+		base_address += block_size;
+	}
+
+	if (instructions_sz % block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + cur_indx,
+		       instructions_sz % block_size);
+		status = rsi_usb_write_register_multiple
+						(adapter, base_address,
+						 (u8 *)temp_buf,
+						 instructions_sz % block_size);
+		if (status < 0)
+			return status;
+		rsi_dbg(INFO_ZONE,
+			"Written Last Block in Address 0x%x Successfully\n",
+			cur_indx);
+	}
+	return 0;
+}
+
 static struct rsi_host_intf_ops usb_host_intf_ops = {
 	.write_pkt		= rsi_usb_host_intf_write_pkt,
 	.read_reg_multiple	= rsi_usb_read_register_multiple,
 	.write_reg_multiple	= rsi_usb_write_register_multiple,
+	.master_reg_read	= rsi_usb_master_reg_read,
+	.master_reg_write	= rsi_usb_master_reg_write,
+	.load_data_master_write	= rsi_usb_load_data_master_write,
 };
 
 /**
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 7fdeda7..2ac5bcf 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -244,5 +244,13 @@ struct rsi_host_intf_ops {
 				 u8 *data, u16 count);
 	int (*write_reg_multiple)(struct rsi_hw *adapter, u32 addr,
 				  u8 *data, u16 count);
+	int (*master_reg_read)(struct rsi_hw *adapter, u32 addr,
+			       u32 *read_buf, u16 size);
+	int (*master_reg_write)(struct rsi_hw *adapter,
+				unsigned long addr, unsigned long data,
+				u16 size);
+	int (*load_data_master_write)(struct rsi_hw *adapter, u32 addr,
+				      u32 instructions_size, u16 block_size,
+				      u8 *fw);
 };
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index a82bc4c..7ae6d51 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -123,6 +123,7 @@ int rsi_sdio_write_register(struct rsi_hw *adapter, u8 function,
 			    u32 addr, u8 *data);
 int rsi_sdio_write_register_multiple(struct rsi_hw *adapter, u32 addr,
 				     u8 *data, u16 count);
+int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word);
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit);
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter);
 int rsi_sdio_read_buffer_status_register(struct rsi_hw *adapter, u8 q_num);
-- 
2.7.4
