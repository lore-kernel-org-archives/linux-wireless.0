Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34292 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdH2SzE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 14:55:04 -0400
From: Himanshu Jha <himanshujha199640@gmail.com>
To: kvalo@codeaurora.org
Cc: amit.karwar@redpinesignals.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] rsi: remove memset before memcpy
Date: Wed, 30 Aug 2017 00:24:50 +0530
Message-Id: <1504032890-25229-1-git-send-email-himanshujha199640@gmail.com> (sfid-20170829_205523_454791_0F9DF68B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

calling memcpy immediately after memset with the same region of memory
makes memset redundant.

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 1 -
 drivers/net/wireless/rsi/rsi_91x_usb.c  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 742f6cd..8d3a483 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -584,7 +584,6 @@ static int rsi_sdio_load_data_master_write(struct rsi_hw *adapter,
 	}
 
 	for (offset = 0, i = 0; i < num_blocks; i++, offset += block_size) {
-		memset(temp_buf, 0, block_size);
 		memcpy(temp_buf, ta_firmware + offset, block_size);
 		lsb_address = (u16)base_address;
 		status = rsi_sdio_write_register_multiple
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 9097f7e..81df09d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -439,7 +439,6 @@ static int rsi_usb_load_data_master_write(struct rsi_hw *adapter,
 	rsi_dbg(INFO_ZONE, "num_blocks: %d\n", num_blocks);
 
 	for (cur_indx = 0, i = 0; i < num_blocks; i++, cur_indx += block_size) {
-		memset(temp_buf, 0, block_size);
 		memcpy(temp_buf, ta_firmware + cur_indx, block_size);
 		status = rsi_usb_write_register_multiple(adapter, base_address,
 							 (u8 *)(temp_buf),
-- 
2.7.4
