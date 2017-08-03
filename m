Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34133 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdHCOde (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 10:33:34 -0400
Received: by mail-pg0-f67.google.com with SMTP id y192so1677946pgd.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 07:33:34 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v2 5/8] rsi: rename sdio_read_buffer_status_register
Date: Thu,  3 Aug 2017 19:59:01 +0530
Message-Id: <1501770544-6746-6-git-send-email-amitkarwar@gmail.com> (sfid-20170803_163337_228970_2881B5DF)
In-Reply-To: <1501770544-6746-1-git-send-email-amitkarwar@gmail.com>
References: <1501770544-6746-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

rsi_sdio_check_buffer_status would be the appropriate name
for this function as we are checking hardware buffers
availability status.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 13 +++----------
 drivers/net/wireless/rsi/rsi_sdio.h         |  2 +-
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 42d558b..742f6cd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -860,7 +860,7 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 	sdio_release_host(pfunction);
 
 	adapter->determine_event_timeout = rsi_sdio_determine_event_timeout;
-	adapter->check_hw_queue_status = rsi_sdio_read_buffer_status_register;
+	adapter->check_hw_queue_status = rsi_sdio_check_buffer_status;
 
 #ifdef CONFIG_RSI_DEBUGFS
 	adapter->num_debugfs_entries = MAX_DEBUGFS_ENTRIES;
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index b3f7adc..9b94ba7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -323,17 +323,10 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 	} while (1);
 }
 
-/**
- * rsi_sdio_read_buffer_status_register() - This function is used to the read
- *					    buffer status register and set
- *					    relevant fields in
- *					    rsi_91x_sdiodev struct.
- * @adapter: Pointer to the driver hw structure.
- * @q_num: The Q number whose status is to be found.
- *
- * Return: status: -1 on failure or else queue full/stop is indicated.
+/* This function is used to read buffer status register and
+ * set relevant fields in rsi_91x_sdiodev struct.
  */
-int rsi_sdio_read_buffer_status_register(struct rsi_hw *adapter, u8 q_num)
+int rsi_sdio_check_buffer_status(struct rsi_hw *adapter, u8 q_num)
 {
 	struct rsi_common *common = adapter->priv;
 	struct rsi_91x_sdiodev *dev =
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 3cf6756..9239fbe 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -127,5 +127,5 @@ int rsi_sdio_write_register_multiple(struct rsi_hw *adapter, u32 addr,
 int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word);
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit);
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter);
-int rsi_sdio_read_buffer_status_register(struct rsi_hw *adapter, u8 q_num);
+int rsi_sdio_check_buffer_status(struct rsi_hw *adapter, u8 q_num);
 #endif
-- 
2.7.4
