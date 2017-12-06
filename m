Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34027 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754395AbdLFKFa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Dec 2017 05:05:30 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: [v4 8/8] rsi: sdio changes to support BT
Date: Wed,  6 Dec 2017 15:26:37 +0530
Message-Id: <1512554197-19664-9-git-send-email-amitkarwar@gmail.com> (sfid-20171206_110538_044079_AD1D84D9)
In-Reply-To: <1512554197-19664-1-git-send-email-amitkarwar@gmail.com>
References: <1512554197-19664-1-git-send-email-amitkarwar@gmail.com>
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
