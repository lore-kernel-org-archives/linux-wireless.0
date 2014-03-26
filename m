Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8707 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbaCZCBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 22:01:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: corner case NULL pointer dereference fix
Date: Tue, 25 Mar 2014 19:01:18 -0700
Message-ID: <1395799280-29221-1-git-send-email-bzhao@marvell.com> (sfid-20140326_030159_948161_328E22D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When next scan command is delayed due to Tx traffic and
meanwhile synchronous command is received followed by a signal,
we cance all pending commands. NULL pointer dereference is seen
in this case while queueing next command in scan delay timer.
This patch adds a check to fix this issue.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 7b4502f..77db088 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -38,7 +38,8 @@ static void scan_delay_timer_fn(unsigned long data)
 	if (adapter->surprise_removed)
 		return;
 
-	if (adapter->scan_delay_cnt == MWIFIEX_MAX_SCAN_DELAY_CNT) {
+	if (adapter->scan_delay_cnt == MWIFIEX_MAX_SCAN_DELAY_CNT ||
+	    !adapter->scan_processing) {
 		/*
 		 * Abort scan operation by cancelling all pending scan
 		 * commands
-- 
1.8.2.3

