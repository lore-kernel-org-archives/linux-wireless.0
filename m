Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:58574 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750877AbdL2VSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 16:18:24 -0500
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] rt2x00: Delete an error message for a failed memory
 allocation in rt2x00queue_allocate()
Message-ID: <cdeaa8a2-06bb-10e9-05d7-f531c00eef5d@users.sourceforge.net> (sfid-20171229_221843_533631_A1F18FA7)
Date: Fri, 29 Dec 2017 22:18:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 29 Dec 2017 22:11:42 +0100

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index a2c1ca5c76d1..6598cefdbe71 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -1244,10 +1244,8 @@ int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->data_queues = 2 + rt2x00dev->ops->tx_queues + req_atim;
 
 	queue = kcalloc(rt2x00dev->data_queues, sizeof(*queue), GFP_KERNEL);
-	if (!queue) {
-		rt2x00_err(rt2x00dev, "Queue allocation failed\n");
+	if (!queue)
 		return -ENOMEM;
-	}
 
 	/*
 	 * Initialize pointers
-- 
2.15.1
