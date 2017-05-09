Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36777 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753810AbdEINbq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 09:31:46 -0400
Received: by mail-pf0-f195.google.com with SMTP id v14so46495pfd.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 06:31:45 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 02/11] rsi: Changes to sdio reads and writes
Date: Tue,  9 May 2017 19:00:05 +0530
Message-Id: <1494336614-2107-3-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170509_153148_919299_A11C8DE3)
In-Reply-To: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

SDIO read or write maximum size is limited to 2^16. This is done to make
the host interface operations common for SDIO and USB.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 10 +++++-----
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  8 ++++----
 drivers/net/wireless/rsi/rsi_sdio.h         |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 8428858..39d94b3 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -487,8 +487,8 @@ void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit)
  */
 static int rsi_sdio_read_register_multiple(struct rsi_hw *adapter,
 					   u32 addr,
-					   u32 count,
-					   u8 *data)
+					   u8 *data,
+					   u16 count)
 {
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
@@ -518,7 +518,7 @@ static int rsi_sdio_read_register_multiple(struct rsi_hw *adapter,
 int rsi_sdio_write_register_multiple(struct rsi_hw *adapter,
 				     u32 addr,
 				     u8 *data,
-				     u32 count)
+				     u16 count)
 {
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
@@ -614,8 +614,8 @@ int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter,
 
 	status = rsi_sdio_read_register_multiple(adapter,
 						 length,
-						 length, /*num of bytes*/
-						 (u8 *)pkt);
+						 (u8 *)pkt,
+						 length); /*num of bytes*/
 
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to read frame: %d\n", __func__,
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 40d7231..7c9cf01 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -75,13 +75,13 @@ static int rsi_sdio_master_access_msword(struct rsi_hw *adapter,
 static int rsi_copy_to_card(struct rsi_common *common,
 			    const u8 *fw,
 			    u32 len,
-			    u32 num_blocks)
+			    u16 num_blocks)
 {
 	struct rsi_hw *adapter = common->priv;
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	u32 indx, ii;
-	u32 block_size = dev->tx_blk_size;
+	u16 block_size = dev->tx_blk_size;
 	u32 lsb_address;
 	__le32 data[] = { TA_HOLD_THREAD_VALUE, TA_SOFT_RST_CLR,
 			  TA_PC_ZERO, TA_RELEASE_THREAD_VALUE };
@@ -171,10 +171,10 @@ static int rsi_load_ta_instructions(struct rsi_common *common)
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	u32 len;
-	u32 num_blocks;
+	u16 num_blocks;
 	const u8 *fw;
 	const struct firmware *fw_entry = NULL;
-	u32 block_size = dev->tx_blk_size;
+	u16 block_size = dev->tx_blk_size;
 	int status = 0;
 	u32 base_address;
 	u16 msb_address;
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index c7e8f2b..a82bc4c 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -110,7 +110,7 @@ struct rsi_91x_sdiodev {
 	u8 sdio_clock_speed;
 	u32 cardcapability;
 	u8 prev_desc[16];
-	u32 tx_blk_size;
+	u16 tx_blk_size;
 	u8 write_fail;
 };
 
@@ -122,7 +122,7 @@ int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter, u8 *pkt, u32 length);
 int rsi_sdio_write_register(struct rsi_hw *adapter, u8 function,
 			    u32 addr, u8 *data);
 int rsi_sdio_write_register_multiple(struct rsi_hw *adapter, u32 addr,
-				     u8 *data, u32 count);
+				     u8 *data, u16 count);
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit);
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter);
 int rsi_sdio_read_buffer_status_register(struct rsi_hw *adapter, u8 q_num);
-- 
2.7.4
