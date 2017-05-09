Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34005 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753847AbdEINbt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 09:31:49 -0400
Received: by mail-pf0-f193.google.com with SMTP id w69so55913pfk.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 06:31:49 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 03/11] rsi: Changes in USB read and write operations
Date: Tue,  9 May 2017 19:00:06 +0530
Message-Id: <1494336614-2107-4-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170509_153154_638386_7A1FFE34)
In-Reply-To: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

USB read and write registers maximum size is limited 2^16. More than
this size is not used in the driver.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c     | 6 +++---
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c | 9 +++++----
 drivers/net/wireless/rsi/rsi_usb.h         | 2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index cc8deec..dfb8a75 100644
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
 
 	buf = kzalloc(4096, GFP_KERNEL);
@@ -298,7 +298,7 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 		return -ENOMEM;
 
 	while (count) {
-		transfer = (u8)(min_t(u32, count, 4096));
+		transfer = min_t(u16, count, 4096);
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
index ebea0c4..52379c6 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -63,6 +63,6 @@ static inline int rsi_usb_event_timeout(struct rsi_hw *adapter)
 
 int rsi_usb_device_init(struct rsi_common *common);
 int rsi_usb_write_register_multiple(struct rsi_hw *adapter, u32 addr,
-				    u8 *data, u32 count);
+				    u8 *data, u16 count);
 void rsi_usb_rx_thread(struct rsi_common *common);
 #endif
-- 
2.7.4
