Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:44664 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573Ab3AZCZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 21:25:38 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@laptop.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: do not overwrite error code from lower layer driver
Date: Fri, 25 Jan 2013 18:23:00 -0800
Message-Id: <1359166980-13161-1-git-send-email-bzhao@marvell.com> (sfid-20130126_032542_059625_FFC14B67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of converting it to a bogus error code -1, we should
return the original error code from lower layer driver. This
error code will be printed so it may give user some clues on
what has happened.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c |   10 ++++------
 drivers/net/wireless/mwifiex/usb.c  |    4 ++--
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 5a1c1d0..e35b67a 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -332,7 +332,7 @@ mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
 			u8 *buffer, u32 pkt_len, u32 port)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	int ret = -1;
+	int ret;
 	u8 blk_mode =
 		(port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE : BLOCK_MODE;
 	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
@@ -350,8 +350,7 @@ mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
 
 	sdio_claim_host(card->func);
 
-	if (!sdio_writesb(card->func, ioport, buffer, blk_cnt * blk_size))
-		ret = 0;
+	ret = sdio_writesb(card->func, ioport, buffer, blk_cnt * blk_size);
 
 	sdio_release_host(card->func);
 
@@ -365,7 +364,7 @@ static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *buffer,
 				  u32 len, u32 port, u8 claim)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	int ret = -1;
+	int ret;
 	u8 blk_mode = (port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE
 		       : BLOCK_MODE;
 	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
@@ -376,8 +375,7 @@ static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *buffer,
 	if (claim)
 		sdio_claim_host(card->func);
 
-	if (!sdio_readsb(card->func, buffer, ioport, blk_cnt * blk_size))
-		ret = 0;
+	ret = sdio_readsb(card->func, buffer, ioport, blk_cnt * blk_size);
 
 	if (claim)
 		sdio_release_host(card->func);
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 5d4a10a..f90fe21 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -672,7 +672,7 @@ static int mwifiex_write_data_sync(struct mwifiex_adapter *adapter, u8 *pbuf,
 			   *len, &actual_length, timeout);
 	if (ret) {
 		dev_err(adapter->dev, "usb_bulk_msg for tx failed: %d\n", ret);
-		ret = -1;
+		return ret;
 	}
 
 	*len = actual_length;
@@ -691,7 +691,7 @@ static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *pbuf,
 			   *len, &actual_length, timeout);
 	if (ret) {
 		dev_err(adapter->dev, "usb_bulk_msg for rx failed: %d\n", ret);
-		ret = -1;
+		return ret;
 	}
 
 	*len = actual_length;
-- 
1.7.0.2

