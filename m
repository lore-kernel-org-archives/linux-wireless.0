Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34706 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752025AbdEPKC5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:02:57 -0400
Received: by mail-pg0-f67.google.com with SMTP id u187so20813451pgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 03:02:57 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v3 04/11] rsi: Changes in USB read and write operations
Date: Tue, 16 May 2017 15:31:10 +0530
Message-Id: <1494928877-27168-5-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170516_120345_561927_1582B5D6)
In-Reply-To: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

USB read and write registers maximum size is limited 2^16. More than
this size is not used in the driver.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v3: Same as v2 03/11
---
 drivers/net/wireless/rsi/rsi_91x_usb.c     | 6 +++---
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c | 9 +++++----
 drivers/net/wireless/rsi/rsi_usb.h         | 2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index be8487c..5f6c700 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -286,11 +286,11 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
 int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 				    u32 addr,
 				    u8 *data,
-				    u32 count)
+				    u16 count)
 {
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	u8 *buf;
-	u8 transfer;
+	u16 transfer;
 	int status = 0;
 
 	buf = kzalloc(RSI_USB_BUF_SIZE, GFP_KERNEL);
@@ -298,7 +298,7 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 		return -ENOMEM;
 
 	while (count) {
-		transfer = (u8)(min_t(u32, count, RSI_USB_BUF_SIZE));
+		transfer = min_t(u16, count, RSI_USB_BUF_SIZE);
 		memcpy(buf, data, transfer);
 		status = usb_control_msg(dev->usbdev,
 					 usb_sndctrlpipe(dev->usbdev, 0),
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index de49008..1c3e654 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
@@ -33,12 +33,12 @@
 static int rsi_copy_to_card(struct rsi_common *common,
 			    const u8 *fw,
 			    u32 len,
-			    u32 num_blocks)
+			    u16 num_blocks)
 {
 	struct rsi_hw *adapter = common->priv;
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	u32 indx, ii;
-	u32 block_size = dev->tx_blk_size;
+	u16 block_size = dev->tx_blk_size;
 	u32 lsb_address;
 	u32 base_address;
 
@@ -134,9 +134,10 @@ static int rsi_load_ta_instructions(struct rsi_common *common)
 	struct rsi_hw *adapter = common->priv;
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	const struct firmware *fw_entry = NULL;
-	u32 block_size = dev->tx_blk_size;
+	u16 block_size = dev->tx_blk_size;
 	const u8 *fw;
-	u32 num_blocks, len;
+	u16 num_blocks;
+	u32 len;
 	int status = 0;
 
 	status = request_firmware(&fw_entry, FIRMWARE_RSI9113, adapter->device);
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 48c9211..d1e01bc 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -65,6 +65,6 @@ static inline int rsi_usb_event_timeout(struct rsi_hw *adapter)
 
 int rsi_usb_device_init(struct rsi_common *common);
 int rsi_usb_write_register_multiple(struct rsi_hw *adapter, u32 addr,
-				    u8 *data, u32 count);
+				    u8 *data, u16 count);
 void rsi_usb_rx_thread(struct rsi_common *common);
 #endif
-- 
2.7.4
