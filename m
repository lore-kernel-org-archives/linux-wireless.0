Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:57528 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122Ab2KFA7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:59:24 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] mwifiex: process RX packets in SDIO IRQ thread directly
Date: Mon,  5 Nov 2012 16:59:15 -0800
Message-Id: <1352163555-31558-1-git-send-email-bzhao@marvell.com> (sfid-20121106_021004_926901_B899A081)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ksdioirqd has higher priority than kworker. Process RX packets
in SDIO IRQ thread (ksdioirqd/mmcX) directly instead of deferring
the work to kworker to avoid the extra latency.
This improves TCP throughput 15~20% on an ARM platform with SDIO
2.0 controller.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: modify the comment to accompany the change
    (Mukesh Agrawal <quiche@chromium.org>)

 drivers/net/wireless/mwifiex/main.c |    1 +
 drivers/net/wireless/mwifiex/sdio.c |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 1df767b..51a13f8 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -282,6 +282,7 @@ exit_main_proc:
 		mwifiex_shutdown_drv(adapter);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mwifiex_main_process);
 
 /*
  * This function frees the adapter structure.
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index fc8a9bf..011c816 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -905,8 +905,8 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 /*
  * SDIO interrupt handler.
  *
- * This function reads the interrupt status from firmware and assigns
- * the main process in workqueue which will handle the interrupt.
+ * This function reads the interrupt status from firmware and handles
+ * the interrupt in current thread (ksdioirqd) right away.
  */
 static void
 mwifiex_sdio_interrupt(struct sdio_func *func)
@@ -929,7 +929,7 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 		adapter->ps_state = PS_STATE_AWAKE;
 
 	mwifiex_interrupt_status(adapter);
-	queue_work(adapter->workqueue, &adapter->main_work);
+	mwifiex_main_process(adapter);
 }
 
 /*
-- 
1.7.0.2

