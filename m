Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:50015 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbdKAMTj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 08:19:39 -0400
Received: by mail-pf0-f194.google.com with SMTP id i5so1834881pfe.6
        for <linux-wireless@vger.kernel.org>; Wed, 01 Nov 2017 05:19:39 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 1/2] rsi: move rsi_sdio_reinit_device() out of CONFIG_PM
Date: Wed,  1 Nov 2017 17:42:44 +0530
Message-Id: <1509538365-31532-1-git-send-email-amitkarwar@gmail.com> (sfid-20171101_131943_310760_F9FD72C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This function is generic. It doesn't contain wowlan specific code.
It should not be under CONFIG_PM. This patch resolves compilation
errors observed when CONFIG_PM flag is disabled.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Fixes: ef71ed0608c ("rsi: sdio: Add WOWLAN support for S5 shutdown state")
Fixes: a24e35fcee0 ("rsi: sdio: Add WOWLAN support for S4 hibernate state")
Fixes: e1ced6422a3 ("rsi: sdio: add WOWLAN support for S3 suspend state")
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 52 ++++++++++++++++-----------------
 drivers/net/wireless/rsi/rsi_sdio.h     |  1 -
 2 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 3288fb6..b0cf411 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -871,6 +871,32 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 	return status;
 }
 
+static int rsi_sdio_reinit_device(struct rsi_hw *adapter)
+{
+	struct rsi_91x_sdiodev *sdev = adapter->rsi_dev;
+	struct sdio_func *pfunction = sdev->pfunction;
+	int ii;
+
+	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
+		skb_queue_purge(&adapter->priv->tx_queue[ii]);
+
+	/* Initialize device again */
+	sdio_claim_host(pfunction);
+
+	sdio_release_irq(pfunction);
+	rsi_reset_card(pfunction);
+
+	sdio_enable_func(pfunction);
+	rsi_setupcard(adapter);
+	rsi_init_sdio_slave_regs(adapter);
+	sdio_claim_irq(pfunction, rsi_handle_interrupt);
+	rsi_hal_device_init(adapter);
+
+	sdio_release_host(pfunction);
+
+	return 0;
+}
+
 static struct rsi_host_intf_ops sdio_host_intf_ops = {
 	.write_pkt		= rsi_sdio_host_intf_write_pkt,
 	.read_pkt		= rsi_sdio_host_intf_read_pkt,
@@ -1281,32 +1307,6 @@ static void rsi_shutdown(struct device *dev)
 	rsi_dbg(INFO_ZONE, "***** RSI module shut down *****\n");
 }
 
-int rsi_sdio_reinit_device(struct rsi_hw *adapter)
-{
-	struct rsi_91x_sdiodev *sdev = adapter->rsi_dev;
-	struct sdio_func *pfunction = sdev->pfunction;
-	int ii;
-
-	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
-		skb_queue_purge(&adapter->priv->tx_queue[ii]);
-
-	/* Initialize device again */
-	sdio_claim_host(pfunction);
-
-	sdio_release_irq(pfunction);
-	rsi_reset_card(pfunction);
-
-	sdio_enable_func(pfunction);
-	rsi_setupcard(adapter);
-	rsi_init_sdio_slave_regs(adapter);
-	sdio_claim_irq(pfunction, rsi_handle_interrupt);
-	rsi_hal_device_init(adapter);
-
-	sdio_release_host(pfunction);
-
-	return 0;
-}
-
 static int rsi_restore(struct device *dev)
 {
 	struct sdio_func *pfunction = dev_to_sdio_func(dev);
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 8fbf90e..49c549b 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -131,5 +131,4 @@ int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word);
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit);
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter);
 int rsi_sdio_check_buffer_status(struct rsi_hw *adapter, u8 q_num);
-int rsi_sdio_reinit_device(struct rsi_hw *adapter);
 #endif
-- 
2.7.4
