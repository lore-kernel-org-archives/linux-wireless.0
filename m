Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:34881 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726917AbeGMHAe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jul 2018 03:00:34 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <simon@thekelleys.org.uk>, <kvalo@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH 03/10] atmel: hide unused procfs helpers
Date: Fri, 13 Jul 2018 14:46:58 +0800
Message-ID: <20180713064658.10340-1-yuehaibing@huawei.com> (sfid-20180713_084749_018424_86A88798)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When CONFIG_PROC_FS isn't set, gcc warning this:

drivers/net/wireless/atmel/atmel.c:1402:12: warning: ‘atmel_proc_show’ defined but not used [-Wunused-function]
 static int atmel_proc_show(struct seq_file *m, void *v)
            ^
fix this by adding #ifdef around it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/atmel/atmel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index b01dc34..3940876 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -1399,6 +1399,7 @@ static int atmel_validate_channel(struct atmel_private *priv, int channel)
 	return 0;
 }
 
+#ifdef CONFIG_PROC_FS
 static int atmel_proc_show(struct seq_file *m, void *v)
 {
 	struct atmel_private *priv = m->private;
@@ -1481,6 +1482,7 @@ static int atmel_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, "Current state:\t\t%s\n", s);
 	return 0;
 }
+#endif
 
 static const struct net_device_ops atmel_netdev_ops = {
 	.ndo_open 		= atmel_open,
-- 
2.7.0
