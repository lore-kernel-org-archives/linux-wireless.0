Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:43561 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753098AbeCTNxB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 09:53:01 -0400
Received: by mail-pg0-f65.google.com with SMTP id i9so631200pgq.10
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2018 06:53:00 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [PATCH 1/2] rsi: fix error path handling in SDIO probe
Date: Tue, 20 Mar 2018 19:10:40 +0530
Message-Id: <1521553241-12676-1-git-send-email-amitkarwar@gmail.com> (sfid-20180320_145305_211288_D4815162)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

We miss to release IRQ in certain error path in SDIO probe which
causes following kernel panic. This patch corrects error path
handling

BUG: unable to handle kernel NULL pointer dereference at        (null)
IP:           (null)
PGD 0 P4D 0
Oops: 0010 [#1] SMP PTI
Call Trace:
 <IRQ>
 ? call_timer_fn+0x29/0x120
 ? run_timer_softirq+0x1da/0x420
 ? timer_interrupt+0x11/0x20
 ? __do_softirq+0xef/0x26e
 ? irq_exit+0xbe/0xd0
 ? do_IRQ+0x4a/0xc0
 ? common_interrupt+0xa2/0xa2
 </IRQ>
 ? cpuidle_enter_state+0x118/0x250
 ? do_idle+0x186/0x1e0
 ? cpu_startup_entry+0x6f/0x80
 ? start_kernel+0x47c/0x49c
 ? secondary_startup_64+0xa5/0xb0

Fixes: 50117605770c ("rsi: improve RX handling in SDIO interface")
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 13705fc..9ce2edb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -967,7 +967,7 @@ static int rsi_probe(struct sdio_func *pfunction,
 				    rsi_sdio_rx_thread, "SDIO-RX-Thread");
 	if (status) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to init rx thrd\n", __func__);
-		goto fail_free_adapter;
+		goto fail_kill_thread;
 	}
 	skb_queue_head_init(&sdev->rx_q.head);
 	sdev->rx_q.num_rx_pkts = 0;
@@ -977,7 +977,7 @@ static int rsi_probe(struct sdio_func *pfunction,
 		rsi_dbg(ERR_ZONE, "%s: Failed to request IRQ\n", __func__);
 		sdio_release_host(pfunction);
 		status = -EIO;
-		goto fail_kill_thread;
+		goto fail_claim_irq;
 	}
 	sdio_release_host(pfunction);
 	rsi_dbg(INIT_ZONE, "%s: Registered Interrupt handler\n", __func__);
@@ -985,7 +985,7 @@ static int rsi_probe(struct sdio_func *pfunction,
 	if (rsi_hal_device_init(adapter)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in device init\n", __func__);
 		status = -EINVAL;
-		goto fail_kill_thread;
+		goto fail_dev_init;
 	}
 	rsi_dbg(INFO_ZONE, "===> RSI Device Init Done <===\n");
 
@@ -1002,10 +1002,13 @@ static int rsi_probe(struct sdio_func *pfunction,
 fail_dev_init:
 	sdio_claim_host(pfunction);
 	sdio_release_irq(pfunction);
-	sdio_disable_func(pfunction);
 	sdio_release_host(pfunction);
-fail_kill_thread:
+fail_claim_irq:
 	rsi_kill_thread(&sdev->rx_thread);
+fail_kill_thread:
+	sdio_claim_host(pfunction);
+	sdio_disable_func(pfunction);
+	sdio_release_host(pfunction);
 fail_free_adapter:
 	rsi_91x_deinit(adapter);
 	rsi_dbg(ERR_ZONE, "%s: Failed in probe...Exiting\n", __func__);
-- 
2.7.4
