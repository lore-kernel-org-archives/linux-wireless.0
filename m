Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13330 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbbHENKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 09:10:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t75DA5Oh017580
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2015 06:10:24 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 1w2kka5w1q-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 06:10:24 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 1/3] mwifiex: add support for 8997 chipset
Date: Wed, 5 Aug 2015 06:09:40 -0700
Message-ID: <1438780182-19320-1-git-send-email-akarwar@marvell.com> (sfid-20150805_151028_735377_4BEFF3D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch adds support for 8997 chipset to mwifiex
with SDIO/PCIe/USB interface.

The corresponding firmware image files are located in:
"mrvl/sd8997_uapsta.bin"
"mrvl/pcie8997_uapsta.bin"
"mrvl/usb8997_uapsta.bin"

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/Kconfig | 12 +++----
 drivers/net/wireless/mwifiex/pcie.c  | 12 +++++--
 drivers/net/wireless/mwifiex/pcie.h  | 45 ++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/sdio.c  |  5 +++
 drivers/net/wireless/mwifiex/sdio.h  | 65 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/usb.c   | 14 ++++++++
 drivers/net/wireless/mwifiex/usb.h   |  3 ++
 7 files changed, 147 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
index 48edf38..317d991 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -9,36 +9,36 @@ config MWIFIEX
 	  mwifiex.
 
 config MWIFIEX_SDIO
-	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8887/SD8897"
+	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8887/SD8897/SD8997"
 	depends on MWIFIEX && MMC
 	select FW_LOADER
 	select WANT_DEV_COREDUMP
 	---help---
 	  This adds support for wireless adapters based on Marvell
-	  8786/8787/8797/8887/8897 chipsets with SDIO interface.
+	  8786/8787/8797/8887/8897/8997 chipsets with SDIO interface.
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex_sdio.
 
 config MWIFIEX_PCIE
-	tristate "Marvell WiFi-Ex Driver for PCIE 8766/8897"
+	tristate "Marvell WiFi-Ex Driver for PCIE 8766/8897/8997"
 	depends on MWIFIEX && PCI
 	select FW_LOADER
 	select WANT_DEV_COREDUMP
 	---help---
 	  This adds support for wireless adapters based on Marvell
-	  8766/8897 chipsets with PCIe interface.
+	  8766/8897/8997 chipsets with PCIe interface.
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex_pcie.
 
 config MWIFIEX_USB
-	tristate "Marvell WiFi-Ex Driver for USB8766/8797/8897"
+	tristate "Marvell WiFi-Ex Driver for USB8766/8797/8897/8997"
 	depends on MWIFIEX && USB
 	select FW_LOADER
 	---help---
 	  This adds support for wireless adapters based on Marvell
-	  8797/8897 chipset with USB interface.
+	  8797/8897/8997 chipset with USB interface.
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex_usb.
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 33c75d7..408b684 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -266,12 +266,17 @@ static const struct pci_device_id mwifiex_ids[] = {
 	{
 		PCIE_VENDOR_ID_MARVELL, PCIE_DEVICE_ID_MARVELL_88W8766P,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		.driver_data = (unsigned long) &mwifiex_pcie8766,
+		.driver_data = (unsigned long)&mwifiex_pcie8766,
 	},
 	{
 		PCIE_VENDOR_ID_MARVELL, PCIE_DEVICE_ID_MARVELL_88W8897,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		.driver_data = (unsigned long) &mwifiex_pcie8897,
+		.driver_data = (unsigned long)&mwifiex_pcie8897,
+	},
+	{
+		PCIE_VENDOR_ID_MARVELL, PCIE_DEVICE_ID_MARVELL_88W8997,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		.driver_data = (unsigned long)&mwifiex_pcie8997,
 	},
 	{},
 };
@@ -1082,6 +1087,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 			card->txbd_rdptr++;
 			break;
 		case PCIE_DEVICE_ID_MARVELL_88W8897:
+		case PCIE_DEVICE_ID_MARVELL_88W8997:
 			card->txbd_rdptr += reg->ring_tx_start_ptr;
 			break;
 		}
@@ -1179,6 +1185,7 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 			card->txbd_wrptr++;
 			break;
 		case PCIE_DEVICE_ID_MARVELL_88W8897:
+		case PCIE_DEVICE_ID_MARVELL_88W8997:
 			card->txbd_wrptr += reg->ring_tx_start_ptr;
 			break;
 		}
@@ -2733,3 +2740,4 @@ MODULE_VERSION(PCIE_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_FIRMWARE(PCIE8766_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(PCIE8897_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(PCIE8997_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 0e7ee8b..48e549c 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -30,10 +30,12 @@
 
 #define PCIE8766_DEFAULT_FW_NAME "mrvl/pcie8766_uapsta.bin"
 #define PCIE8897_DEFAULT_FW_NAME "mrvl/pcie8897_uapsta.bin"
+#define PCIE8997_DEFAULT_FW_NAME "mrvl/pcie8997_uapsta.bin"
 
 #define PCIE_VENDOR_ID_MARVELL              (0x11ab)
 #define PCIE_DEVICE_ID_MARVELL_88W8766P		(0x2b30)
 #define PCIE_DEVICE_ID_MARVELL_88W8897		(0x2b38)
+#define PCIE_DEVICE_ID_MARVELL_88W8997		(0x2b42)
 
 /* Constants for Buffer Descriptor (BD) rings */
 #define MWIFIEX_MAX_TXRX_BD			0x20
@@ -197,7 +199,38 @@ static const struct mwifiex_pcie_card_reg mwifiex_reg_8897 = {
 	.sleep_cookie = 0,
 	.fw_dump_ctrl = 0xcf4,
 	.fw_dump_start = 0xcf8,
-	.fw_dump_end = 0xcff
+	.fw_dump_end = 0xcff,
+};
+
+static const struct mwifiex_pcie_card_reg mwifiex_reg_8997 = {
+	.cmd_addr_lo = PCIE_SCRATCH_0_REG,
+	.cmd_addr_hi = PCIE_SCRATCH_1_REG,
+	.cmd_size = PCIE_SCRATCH_2_REG,
+	.fw_status = PCIE_SCRATCH_3_REG,
+	.cmdrsp_addr_lo = PCIE_SCRATCH_4_REG,
+	.cmdrsp_addr_hi = PCIE_SCRATCH_5_REG,
+	.tx_rdptr = 0xC1A4,
+	.tx_wrptr = 0xC1A8,
+	.rx_rdptr = 0xC1A8,
+	.rx_wrptr = 0xC1A4,
+	.evt_rdptr = PCIE_SCRATCH_10_REG,
+	.evt_wrptr = PCIE_SCRATCH_11_REG,
+	.drv_rdy = PCIE_SCRATCH_12_REG,
+	.tx_start_ptr = 16,
+	.tx_mask = 0x0FFF0000,
+	.tx_wrap_mask = 0x01FF0000,
+	.rx_mask = 0x00000FFF,
+	.rx_wrap_mask = 0x000001FF,
+	.tx_rollover_ind = BIT(28),
+	.rx_rollover_ind = BIT(12),
+	.evt_rollover_ind = MWIFIEX_BD_FLAG_EVT_ROLLOVER_IND,
+	.ring_flag_sop = MWIFIEX_BD_FLAG_SOP,
+	.ring_flag_eop = MWIFIEX_BD_FLAG_EOP,
+	.ring_flag_xs_sop = MWIFIEX_BD_FLAG_XS_SOP,
+	.ring_flag_xs_eop = MWIFIEX_BD_FLAG_XS_EOP,
+	.ring_tx_start_ptr = MWIFIEX_BD_FLAG_TX_START_PTR,
+	.pfu_enabled = 1,
+	.sleep_cookie = 0,
 };
 
 struct mwifiex_pcie_device {
@@ -227,6 +260,15 @@ static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
 	.can_ext_scan = true,
 };
 
+static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
+	.firmware       = PCIE8997_DEFAULT_FW_NAME,
+	.reg            = &mwifiex_reg_8997,
+	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.can_dump_fw = false,
+	.can_ext_scan = true,
+};
+
 struct mwifiex_evt_buf_desc {
 	u64 paddr;
 	u16 len;
@@ -325,6 +367,7 @@ mwifiex_pcie_txbd_not_full(struct pcie_service_card *card)
 			return 1;
 		break;
 	case PCIE_DEVICE_ID_MARVELL_88W8897:
+	case PCIE_DEVICE_ID_MARVELL_88W8997:
 		if (((card->txbd_wrptr & reg->tx_mask) !=
 		     (card->txbd_rdptr & reg->tx_mask)) ||
 		    ((card->txbd_wrptr & reg->tx_rollover_ind) ==
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index e4c35ee..9904a77 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -288,6 +288,8 @@ static int mwifiex_sdio_suspend(struct device *dev)
 #define SDIO_DEVICE_ID_MARVELL_8887   (0x9135)
 /* Device ID for SD8801 */
 #define SDIO_DEVICE_ID_MARVELL_8801   (0x9139)
+/* Device ID for SD8997 */
+#define SDIO_DEVICE_ID_MARVELL_8997   (0x9141)
 
 
 /* WLAN IDs */
@@ -304,6 +306,8 @@ static const struct sdio_device_id mwifiex_ids[] = {
 		.driver_data = (unsigned long)&mwifiex_sdio_sd8887},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8801),
 		.driver_data = (unsigned long)&mwifiex_sdio_sd8801},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8997),
+		.driver_data = (unsigned long)&mwifiex_sdio_sd8997},
 	{},
 };
 
@@ -2531,3 +2535,4 @@ MODULE_FIRMWARE(SD8787_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8797_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8897_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8887_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(SD8997_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index c44da61..cd149196 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -35,6 +35,7 @@
 #define SD8897_DEFAULT_FW_NAME "mrvl/sd8897_uapsta.bin"
 #define SD8887_DEFAULT_FW_NAME "mrvl/sd8887_uapsta.bin"
 #define SD8801_DEFAULT_FW_NAME "mrvl/sd8801_uapsta.bin"
+#define SD8997_DEFAULT_FW_NAME "mrvl/sd8997_uapsta.bin"
 
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
@@ -364,6 +365,55 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
 				 0x59, 0x5c, 0x5d},
 };
 
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8997 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0xF8,
+	.base_1_reg = 0xF9,
+	.poll_reg = 0x5C,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x4,
+	.host_int_status_reg = 0x0C,
+	.host_int_mask_reg = 0x08,
+	.status_reg_0 = 0xE8,
+	.status_reg_1 = 0xE9,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xE4,
+	.io_port_1_reg = 0xE5,
+	.io_port_2_reg = 0xE6,
+	.max_mp_regs = 196,
+	.rd_bitmap_l = 0x10,
+	.rd_bitmap_u = 0x11,
+	.rd_bitmap_1l = 0x12,
+	.rd_bitmap_1u = 0x13,
+	.wr_bitmap_l = 0x14,
+	.wr_bitmap_u = 0x15,
+	.wr_bitmap_1l = 0x16,
+	.wr_bitmap_1u = 0x17,
+	.rd_len_p0_l = 0x18,
+	.rd_len_p0_u = 0x19,
+	.card_misc_cfg_reg = 0xd8,
+	.card_cfg_2_1_reg = 0xd9,
+	.cmd_rd_len_0 = 0xc0,
+	.cmd_rd_len_1 = 0xc1,
+	.cmd_rd_len_2 = 0xc2,
+	.cmd_rd_len_3 = 0xc3,
+	.cmd_cfg_0 = 0xc4,
+	.cmd_cfg_1 = 0xc5,
+	.cmd_cfg_2 = 0xc6,
+	.cmd_cfg_3 = 0xc7,
+	.func1_dump_reg_start = 0x10,
+	.func1_dump_reg_end = 0x17,
+	.func1_scratch_reg = 0xe8,
+	.func1_spec_reg_num = 13,
+	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D,
+				 0x60, 0x61, 0x62, 0x64,
+				 0x65, 0x66, 0x68, 0x69,
+				 0x6a},
+};
+
 static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8887 = {
 	.start_rd_port = 0,
 	.start_wr_port = 0,
@@ -472,6 +522,21 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
 	.can_ext_scan = true,
 };
 
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
+	.firmware = SD8997_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8997,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
 	.firmware = SD8887_DEFAULT_FW_NAME,
 	.reg = &mwifiex_reg_sd8887,
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index fbad99c..6eabd95 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -47,6 +47,11 @@ static struct usb_device_id mwifiex_usb_table[] = {
 	{USB_DEVICE_AND_INTERFACE_INFO(USB8XXX_VID, USB8897_PID_2,
 				       USB_CLASS_VENDOR_SPEC,
 				       USB_SUBCLASS_VENDOR_SPEC, 0xff)},
+	/* 8997 */
+	{USB_DEVICE(USB8XXX_VID, USB8997_PID_1)},
+	{USB_DEVICE_AND_INTERFACE_INFO(USB8XXX_VID, USB8997_PID_2,
+				       USB_CLASS_VENDOR_SPEC,
+				       USB_SUBCLASS_VENDOR_SPEC, 0xff)},
 	{ }	/* Terminating entry */
 };
 
@@ -382,12 +387,14 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	case USB8797_PID_1:
 	case USB8801_PID_1:
 	case USB8897_PID_1:
+	case USB8997_PID_1:
 		card->usb_boot_state = USB8XXX_FW_DNLD;
 		break;
 	case USB8766_PID_2:
 	case USB8797_PID_2:
 	case USB8801_PID_2:
 	case USB8897_PID_2:
+	case USB8997_PID_2:
 		card->usb_boot_state = USB8XXX_FW_READY;
 		break;
 	default:
@@ -814,6 +821,12 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	adapter->dev = &card->udev->dev;
 
 	switch (le16_to_cpu(card->udev->descriptor.idProduct)) {
+	case USB8997_PID_1:
+	case USB8997_PID_2:
+		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
+		strcpy(adapter->fw_name, USB8997_DEFAULT_FW_NAME);
+		adapter->ext_scan = true;
+		break;
 	case USB8897_PID_1:
 	case USB8897_PID_2:
 		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
@@ -1121,3 +1134,4 @@ MODULE_FIRMWARE(USB8766_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(USB8797_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(USB8801_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(USB8897_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(USB8997_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/mwifiex/usb.h b/drivers/net/wireless/mwifiex/usb.h
index 57e1a57..f0051f8 100644
--- a/drivers/net/wireless/mwifiex/usb.h
+++ b/drivers/net/wireless/mwifiex/usb.h
@@ -32,6 +32,8 @@
 #define USB8897_PID_2		0x2046
 #define USB8801_PID_1		0x2049
 #define USB8801_PID_2		0x204a
+#define USB8997_PID_1		0x204d
+#define USB8997_PID_2		0x204e
 
 
 #define USB8XXX_FW_DNLD		1
@@ -46,6 +48,7 @@
 #define USB8797_DEFAULT_FW_NAME	"mrvl/usb8797_uapsta.bin"
 #define USB8801_DEFAULT_FW_NAME	"mrvl/usb8801_uapsta.bin"
 #define USB8897_DEFAULT_FW_NAME	"mrvl/usb8897_uapsta.bin"
+#define USB8997_DEFAULT_FW_NAME	"mrvl/usb8997_uapsta.bin"
 
 #define FW_DNLD_TX_BUF_SIZE	620
 #define FW_DNLD_RX_BUF_SIZE	2048
-- 
1.8.1.4

