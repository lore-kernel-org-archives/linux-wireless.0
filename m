Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58873 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759588Ab2KBBqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 21:46:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: process RX packets in SDIO IRQ thread directly
Date: Thu,  1 Nov 2012 18:44:10 -0700
Message-Id: <1351820650-24405-1-git-send-email-bzhao@marvell.com> (sfid-20121102_024624_470468_1CF906CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ksdioirqd has higher priority than kworker. Process RX packets
in SDIO IRQ thread (ksdioirqd/mmcX) directly instead of deferring
the work to kworker to avoid the extra latency.
This improves TCP throughput 15~20% on an ARM platform with SDIO
2.0 controller.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |    1 +
 drivers/net/wireless/mwifiex/sdio.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

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
index fc8a9bf..8b81d8a 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -929,7 +929,7 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 		adapter->ps_state = PS_STATE_AWAKE;
 
 	mwifiex_interrupt_status(adapter);
-	queue_work(adapter->workqueue, &adapter->main_work);
+	mwifiex_main_process(adapter);
 }
 
 /*
-- 
1.7.0.2

