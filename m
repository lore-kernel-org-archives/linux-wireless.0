Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33047 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753656AbdFMOws (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:52:48 -0400
Received: by mail-pf0-f196.google.com with SMTP id w12so11954511pfk.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:52:47 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 18/20] rsi: SDIO Rx packet processing enhancement
Date: Tue, 13 Jun 2017 20:19:06 +0530
Message-Id: <1497365348-2305-19-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_165251_032156_0A1F7772)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

Newer firmware sends information about number of blocks through
interrupt only. We don't need to read extra register for this.
This patch adds needed driver changes for this enhancment. The
change here is backward compatible

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 34 ++++++++++++++++++++++-------
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 drivers/net/wireless/rsi/rsi_sdio.h         |  1 +
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index df2a63b..b6d0e2a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -69,20 +69,37 @@ int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word)
 static int rsi_process_pkt(struct rsi_common *common)
 {
 	struct rsi_hw *adapter = common->priv;
+	struct rsi_91x_sdiodev *dev =
+		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	u8 num_blks = 0;
 	u32 rcv_pkt_len = 0;
 	int status = 0;
+	u8 value = 0;
 
-	status = rsi_sdio_read_register(adapter,
-					SDIO_RX_NUM_BLOCKS_REG,
-					&num_blks);
+	num_blks = ((adapter->interrupt_status & 1) |
+			((adapter->interrupt_status >> RECV_NUM_BLOCKS) << 1));
 
-	if (status) {
-		rsi_dbg(ERR_ZONE,
-			"%s: Failed to read pkt length from the card:\n",
-			__func__);
-		return status;
+	if (!num_blks) {
+		status = rsi_sdio_read_register(adapter,
+						SDIO_RX_NUM_BLOCKS_REG,
+						&value);
+		if (status) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to read pkt length from the card:\n",
+				__func__);
+			return status;
+		}
+		num_blks = value & 0x1f;
 	}
+
+	if (dev->write_fail == 2)
+		rsi_sdio_ack_intr(common->priv, (1 << MSDU_PKT_PENDING));
+
+	if (unlikely(!num_blks)) {
+		dev->write_fail = 2;
+		return -1;
+	}
+
 	rcv_pkt_len = (num_blks * 256);
 
 	common->rx_data_pkt = kmalloc(rcv_pkt_len, GFP_KERNEL);
@@ -224,6 +241,7 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 			mutex_unlock(&common->tx_rxlock);
 			return;
 		}
+		adapter->interrupt_status = isr_status;
 
 		if (isr_status == 0) {
 			rsi_set_event(&common->tx_thread.event);
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 4b4312e..febecbd 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -273,6 +273,7 @@ struct rsi_hw {
 	bool blcmd_timer_expired;
 	u32 flash_capacity;
 	struct eepromrw_info eeprom;
+	u32 interrupt_status;
 	u8 dfs_region;
 	void *rsi_dev;
 	struct rsi_host_intf_ops *host_intf_ops;
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index cbbc0448..3cf6756 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -41,6 +41,7 @@ enum sdio_interrupt_type {
 #define PKT_BUFF_FULL                           1
 #define PKT_MGMT_BUFF_FULL                      2
 #define MSDU_PKT_PENDING                        3
+#define RECV_NUM_BLOCKS                         4
 /* Interrupt Bit Related Macros */
 #define PKT_BUFF_AVAILABLE                      1
 #define FW_ASSERT_IND                           2
-- 
2.7.4
