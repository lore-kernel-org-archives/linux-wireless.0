Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:35876 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932188Ab2IRWpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 18:45:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix issue in resumed scan operation
Date: Tue, 18 Sep 2012 15:33:32 -0700
Message-Id: <1348007612-28202-1-git-send-email-bzhao@marvell.com> (sfid-20120919_004519_842349_41AB5D84)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When delayed scan operation is resumed, we just add next scan
command in queue but don't wakeup main thread to process the
command. Hence the command is downloaded to firmware only after
waking up the main thread by any other means.

This bug which was introduced after "mwifiex: improve scan delay
logic.." patch is fixed here.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 9c1549e..b2ba262 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -118,6 +118,7 @@ static void scan_delay_timer_fn(unsigned long data)
 
 			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
 							true);
+			queue_work(adapter->workqueue, &adapter->main_work);
 			goto done;
 		}
 	} else {
-- 
1.7.0.2

