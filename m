Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10598 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415AbaJFFJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 01:09:53 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <maithili@marvell.com>,
	<cluo@marvell.com>, <huxm@marvell.com>, <yangyang@marvell.com>,
	<akarwar@marvell.com>, Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: [PATCH 2/2] mwifiex: add support for SD8887 chipset
Date: Wed, 1 Oct 2014 15:43:12 +0530
Message-ID: <1412158392-11322-2-git-send-email-patila@marvell.com> (sfid-20141006_071019_626844_0BF0085F)
In-Reply-To: <1412158392-11322-1-git-send-email-patila@marvell.com>
References: <1412158392-11322-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds SD8887 support to mwifiex.
SD8887 is Marvell's 1x1 11ac solution.

The corresponding firmware image file is located at:
"mrvl/sd8887_uapsta.bin"

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
 drivers/net/wireless/mwifiex/Kconfig |  4 +--
 drivers/net/wireless/mwifiex/sdio.c  |  5 ++++
 drivers/net/wireless/mwifiex/sdio.h  | 55 ++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
index ecdf345..e70d0df 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -9,12 +9,12 @@ config MWIFIEX
 	  mwifiex.
 
 config MWIFIEX_SDIO
-	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8897"
+	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8887/SD8897"
 	depends on MWIFIEX && MMC
 	select FW_LOADER
 	---help---
 	  This adds support for wireless adapters based on Marvell
-	  8786/8787/8797 chipsets with SDIO interface.
+	  8786/8787/8797/8887/8897 chipsets with SDIO interface.
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex_sdio.
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index a22e9a9..b25766b 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -279,6 +279,8 @@ static int mwifiex_sdio_suspend(struct device *dev)
 #define SDIO_DEVICE_ID_MARVELL_8797   (0x9129)
 /* Device ID for SD8897 */
 #define SDIO_DEVICE_ID_MARVELL_8897   (0x912d)
+/* Device ID for SD8887 */
+#define SDIO_DEVICE_ID_MARVELL_8887   (0x9135)
 
 /* WLAN IDs */
 static const struct sdio_device_id mwifiex_ids[] = {
@@ -290,6 +292,8 @@ static const struct sdio_device_id mwifiex_ids[] = {
 		.driver_data = (unsigned long) &mwifiex_sdio_sd8797},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8897),
 		.driver_data = (unsigned long) &mwifiex_sdio_sd8897},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8887),
+		.driver_data = (unsigned long)&mwifiex_sdio_sd8887},
 	{},
 };
 
@@ -2233,3 +2237,4 @@ MODULE_FIRMWARE(SD8786_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8787_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8797_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8897_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(SD8887_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 5a08ebc..20cd9ad 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -33,6 +33,7 @@
 #define SD8787_DEFAULT_FW_NAME "mrvl/sd8787_uapsta.bin"
 #define SD8797_DEFAULT_FW_NAME "mrvl/sd8797_uapsta.bin"
 #define SD8897_DEFAULT_FW_NAME "mrvl/sd8897_uapsta.bin"
+#define SD8887_DEFAULT_FW_NAME "mrvl/sd8887_uapsta.bin"
 
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
@@ -334,6 +335,47 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
 	.fw_dump_end = 0xea,
 };
 
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8887 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0x6C,
+	.base_1_reg = 0x6D,
+	.poll_reg = 0x5C,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x4,
+	.host_int_status_reg = 0x0C,
+	.host_int_mask_reg = 0x08,
+	.status_reg_0 = 0x90,
+	.status_reg_1 = 0x91,
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
+};
+
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
 	.firmware = SD8786_DEFAULT_FW_NAME,
 	.reg = &mwifiex_reg_sd87xx,
@@ -386,6 +428,19 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
 	.supports_fw_dump = true,
 };
 
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
+	.firmware = SD8887_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8887,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
+	.supports_fw_dump = false,
+};
+
 /*
  * .cmdrsp_complete handler
  */
-- 
1.8.1.4

