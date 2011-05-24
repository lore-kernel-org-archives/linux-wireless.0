Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:37359 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1EXAzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 20:55:31 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: remove support for old chipsets W0/W1
Date: Mon, 23 May 2011 18:00:17 -0700
Message-Id: <1306198818-7423-1-git-send-email-bzhao@marvell.com> (sfid-20110524_025537_453391_596BDC22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

For SD8787 A0/A1 chipsets we use the default firmware image
file 'mrvl/sd8787_uapsta.bin'. So the chip rev id variable
is removed.

The global variable fw_name is moved to adapter structure
so that we can support a different interface, such as PCIe,
in future.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |   18 ++----------------
 drivers/net/wireless/mwifiex/main.h |   11 +----------
 drivers/net/wireless/mwifiex/sdio.c |    8 ++------
 drivers/net/wireless/mwifiex/sdio.h |    2 ++
 4 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 44957ca..f6db51c 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -35,8 +35,6 @@ static struct mwifiex_bss_attr mwifiex_bss_sta[] = {
 
 static int drv_mode = DRV_MODE_STA;
 
-static char fw_name[32] = DEFAULT_FW_NAME;
-
 /* Supported drv_mode table */
 static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
 	{
@@ -384,20 +382,8 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 
 	memset(&fw, 0, sizeof(struct mwifiex_fw_image));
 
-	switch (adapter->revision_id) {
-	case SD8787_W0:
-	case SD8787_W1:
-		strcpy(fw_name, SD8787_W1_FW_NAME);
-		break;
-	case SD8787_A0:
-	case SD8787_A1:
-		strcpy(fw_name, SD8787_AX_FW_NAME);
-		break;
-	default:
-		break;
-	}
-
-	err = request_firmware(&adapter->firmware, fw_name, adapter->dev);
+	err = request_firmware(&adapter->firmware, adapter->fw_name,
+			       adapter->dev);
 	if (err < 0) {
 		dev_err(adapter->dev, "request_firmware() returned"
 				" error code %#x\n", err);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 8316b3c..89f9870 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -48,15 +48,6 @@ enum {
 
 #define DRV_MODE_STA       0x1
 
-#define SD8787_W0   0x30
-#define SD8787_W1   0x31
-#define SD8787_A0   0x40
-#define SD8787_A1   0x41
-
-#define DEFAULT_FW_NAME "mrvl/sd8787_uapsta.bin"
-#define SD8787_W1_FW_NAME "mrvl/sd8787_uapsta_w1.bin"
-#define SD8787_AX_FW_NAME "mrvl/sd8787_uapsta.bin"
-
 struct mwifiex_drv_mode {
 	u16 drv_mode;
 	u16 intf_num;
@@ -576,10 +567,10 @@ struct mwifiex_adapter {
 	u8 priv_num;
 	struct mwifiex_drv_mode *drv_mode;
 	const struct firmware *firmware;
+	char fw_name[32];
 	struct device *dev;
 	bool surprise_removed;
 	u32 fw_release_number;
-	u32 revision_id;
 	u16 init_wait_q_woken;
 	wait_queue_head_t init_wait_q;
 	void *card;
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index d425dbd..4327b6d 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1531,6 +1531,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	sdio_set_drvdata(func, card);
 
 	adapter->dev = &func->dev;
+	strcpy(adapter->fw_name, SD8787_DEFAULT_FW_NAME);
 
 	return 0;
 
@@ -1552,7 +1553,6 @@ disable_func:
  *        the first interrupt got from bootloader
  *      - Disable host interrupt mask register
  *      - Get SDIO port
- *      - Get revision ID
  *      - Initialize SDIO variables in card
  *      - Allocate MP registers
  *      - Allocate MPA Tx and Rx buffers
@@ -1576,10 +1576,6 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	/* Get SDIO ioport */
 	mwifiex_init_sdio_ioport(adapter);
 
-	/* Get revision ID */
-#define REV_ID_REG	0x5c
-	mwifiex_read_reg(adapter, REV_ID_REG, &adapter->revision_id);
-
 	/* Initialize SDIO variables in card */
 	card->mp_rd_bitmap = 0;
 	card->mp_wr_bitmap = 0;
@@ -1751,4 +1747,4 @@ MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell WiFi-Ex SDIO Driver version " SDIO_VERSION);
 MODULE_VERSION(SDIO_VERSION);
 MODULE_LICENSE("GPL v2");
-MODULE_FIRMWARE("sd8787.bin");
+MODULE_FIRMWARE("mrvl/sd8787_uapsta.bin");
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 4e97e90..c925376 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -28,6 +28,8 @@
 
 #include "main.h"
 
+#define SD8787_DEFAULT_FW_NAME "mrvl/sd8787_uapsta.bin"
+
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
 
-- 
1.7.0.2

