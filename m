Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36096 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdHCOdl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 10:33:41 -0400
Received: by mail-pg0-f65.google.com with SMTP id y129so1665134pgy.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 07:33:41 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v2 6/8] rsi: buffer full check optimization
Date: Thu,  3 Aug 2017 19:59:02 +0530
Message-Id: <1501770544-6746-7-git-send-email-amitkarwar@gmail.com> (sfid-20170803_163344_045899_E7D3541C)
In-Reply-To: <1501770544-6746-1-git-send-email-amitkarwar@gmail.com>
References: <1501770544-6746-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

We get buffer full event from firmware whenever Tx queue is full
Host should stop writing packets after this and resume after
buffer free event.
Buffer status checking is optimized for once in 4 times if
BUFF_FULL condition is not set, otherwise once for every
packet.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 16 +++++++++++++++-
 drivers/net/wireless/rsi/rsi_sdio.h         |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 9b94ba7..94a9fcd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -271,6 +271,7 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 					"%s: ==> BUFFER_AVAILABLE <==\n",
 					__func__);
 				dev->rx_info.buf_available_counter++;
+				dev->buff_status_updated = true;
 				break;
 
 			case FIRMWARE_ASSERT_IND:
@@ -333,7 +334,14 @@ int rsi_sdio_check_buffer_status(struct rsi_hw *adapter, u8 q_num)
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	u8 buf_status = 0;
 	int status = 0;
+	static int counter = 4;
 
+	if (!dev->buff_status_updated && counter) {
+		counter--;
+		goto out;
+	}
+
+	dev->buff_status_updated = false;
 	status = rsi_sdio_read_register(common->priv,
 					RSI_DEVICE_BUFFER_STATUS_REGISTER,
 					&buf_status);
@@ -368,10 +376,16 @@ int rsi_sdio_check_buffer_status(struct rsi_hw *adapter, u8 q_num)
 		dev->rx_info.semi_buffer_full = false;
 	}
 
+	if (dev->rx_info.mgmt_buffer_full || dev->rx_info.buf_full_counter)
+		counter = 1;
+	else
+		counter = 4;
+
+out:
 	if ((q_num == MGMT_SOFT_Q) && (dev->rx_info.mgmt_buffer_full))
 		return QUEUE_FULL;
 
-	if (dev->rx_info.buffer_full)
+	if ((q_num < MGMT_SOFT_Q) && (dev->rx_info.buffer_full))
 		return QUEUE_FULL;
 
 	return QUEUE_NOT_FULL;
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 9239fbe..95e4bed 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -114,6 +114,7 @@ struct rsi_91x_sdiodev {
 	u8 prev_desc[16];
 	u16 tx_blk_size;
 	u8 write_fail;
+	bool buff_status_updated;
 };
 
 void rsi_interrupt_handler(struct rsi_hw *adapter);
-- 
2.7.4
