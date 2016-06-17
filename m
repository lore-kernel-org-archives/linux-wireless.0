Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:53764 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120AbcFQRfN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 13:35:13 -0400
From: weiyj_lk@163.com
To: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: wilc1000: fix return value check in wlan_initialize_threads()
Date: Fri, 17 Jun 2016 17:34:17 +0000
Message-Id: <1466184857-21605-1-git-send-email-weiyj_lk@163.com> (sfid-20160617_193524_856267_6A1C7B57)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function kthread_run() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4f93c11..b622510 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -717,10 +717,10 @@ static int wlan_initialize_threads(struct net_device *dev)
 
 	wilc->txq_thread = kthread_run(linux_wlan_txq_task, (void *)dev,
 				     "K_TXQ_TASK");
-	if (!wilc->txq_thread) {
+	if (IS_ERR(wilc->txq_thread)) {
 		netdev_err(dev, "couldn't create TXQ thread\n");
 		wilc->close = 0;
-		return -ENOBUFS;
+		return PTR_ERR(wilc->txq_thread);
 	}
 	wait_for_completion(&wilc->txq_thread_started);
 





