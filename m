Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55443 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579Ab3JLBdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 21:33:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: use alloc_workqueue() function
Date: Fri, 11 Oct 2013 18:33:04 -0700
Message-ID: <1381541584-28351-1-git-send-email-bzhao@marvell.com> (sfid-20131012_033323_494962_303AAD80)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

It replaces deprecated create_workqueue().

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index c2b91f5..9d7c9d3 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -882,7 +882,9 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	adapter->cmd_wait_q.status = 0;
 	adapter->scan_wait_q_woken = false;
 
-	adapter->workqueue = create_workqueue("MWIFIEX_WORK_QUEUE");
+	adapter->workqueue =
+		alloc_workqueue("MWIFIEX_WORK_QUEUE",
+				WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
 	if (!adapter->workqueue)
 		goto err_kmalloc;
 
-- 
1.8.2.3

