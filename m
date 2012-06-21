Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:52455 "HELO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757899Ab2FUC7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 22:59:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stone Piao <piaoyun@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Ying Luo <luoy@marvell.com>, Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: wake up main thread to handle Tx traffic if scan is delayed/aborted
Date: Wed, 20 Jun 2012 19:58:36 -0700
Message-Id: <1340247517-4593-5-git-send-email-bzhao@marvell.com> (sfid-20120621_045920_245899_4EBEF468)
In-Reply-To: <1340247517-4593-1-git-send-email-bzhao@marvell.com>
References: <1340247517-4593-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This is a flaw in recently implemented logic to handle Tx traffic
and scan operation simultaneously. We missed to wakeup main thread
to handle Tx traffic if scan is delayed/aborted.

For some cards (SD8797, for example), firmware will send SLEEP event
if there is no activity for 50msec. While handling the SLEEP event,
main thread will be woken up and Tx packet gets sent hence. In worst
case Tx traffic will be delayed for 50msec.

For other cards, such as USB8797, firmware won't send SLEEP event.
So, Tx traffic gets stuck if no other event triggers the wakeup of
main thread.

This patch fixes above issues.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |    1 +
 drivers/net/wireless/mwifiex/main.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 0f18ef6..b543a4d 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -103,6 +103,7 @@ static void scan_delay_timer_fn(unsigned long data)
 				  msecs_to_jiffies(MWIFIEX_SCAN_DELAY_MSEC));
 			adapter->scan_delay_cnt++;
 		}
+		queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
 	} else {
 		/*
 		 * Tx data queue is empty. Get scan command from scan_pending_q
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 0f06f07..f0219ef 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -190,7 +190,8 @@ process_start:
 			    adapter->tx_lock_flag)
 				break;
 
-			if (adapter->scan_processing || adapter->data_sent ||
+			if ((adapter->scan_processing &&
+			     !adapter->scan_delay_cnt) || adapter->data_sent ||
 			    mwifiex_wmm_lists_empty(adapter)) {
 				if (adapter->cmd_sent || adapter->curr_cmd ||
 				    (!is_command_pending(adapter)))
-- 
1.7.0.2

