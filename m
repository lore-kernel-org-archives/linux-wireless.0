Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:52362 "EHLO mail.mleia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbcCIXNW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 18:13:22 -0500
From: Vladimir Zapolskiy <vz@mleia.com>
To: Glen Lee <glen.lee@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: wilc1000: fix check of kthread_run() return value
Date: Thu, 10 Mar 2016 01:13:14 +0200
Message-Id: <1457565194-31533-1-git-send-email-vz@mleia.com> (sfid-20160310_001325_134821_B5C10054)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kthread_run() function returns either a valid task_struct or
ERR_PTR() value, check for NULL is invalid. The change fixes potential
oops, e.g. in OOM situation.

Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 54fe9d7..5077c30 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -849,10 +849,10 @@ static int wlan_initialize_threads(struct net_device *dev)
 	PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
 	wilc->txq_thread = kthread_run(linux_wlan_txq_task, (void *)dev,
 				     "K_TXQ_TASK");
-	if (!wilc->txq_thread) {
+	if (IS_ERR(wilc->txq_thread)) {
 		PRINT_ER("couldn't create TXQ thread\n");
 		wilc->close = 0;
-		return -ENOBUFS;
+		return PTR_ERR(wilc->txq_thread);
 	}
 	down(&wilc->txq_thread_started);
 
-- 
2.1.4

