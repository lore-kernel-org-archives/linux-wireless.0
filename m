Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:44167 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753006AbdLMMv7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 07:51:59 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: [v5 8/8] rsi: sdio changes to support BT
Date: Wed, 13 Dec 2017 18:12:57 +0530
Message-Id: <1513168977-2121-9-git-send-email-amitkarwar@gmail.com> (sfid-20171213_135222_849094_A38036F4)
In-Reply-To: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Queue number is correctly updated for BT traffic. Also, kzalloc
instead of kmalloc is used for Rx packet allocation.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 2 ++
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 5722736..beb18d0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -763,6 +763,8 @@ static int rsi_sdio_host_intf_write_pkt(struct rsi_hw *adapter,
 	int status;
 
 	queueno = ((pkt[1] >> 4) & 0xf);
+	if (queueno == RSI_BT_MGMT_Q || queueno == RSI_BT_DATA_Q)
+		queueno = RSI_BT_Q;
 
 	num_blocks = len / block_size;
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 26abe51..83652bd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -103,7 +103,7 @@ static int rsi_process_pkt(struct rsi_common *common)
 
 	rcv_pkt_len = (num_blks * 256);
 
-	common->rx_data_pkt = kmalloc(rcv_pkt_len, GFP_KERNEL);
+	common->rx_data_pkt = kzalloc(rcv_pkt_len, GFP_KERNEL);
 	if (!common->rx_data_pkt) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in memory allocation\n",
 			__func__);
-- 
2.7.4
