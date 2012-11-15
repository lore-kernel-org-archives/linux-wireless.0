Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:37593 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab2KPAAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 19:00:09 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@laptop.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, "3.4+" <stable@vger.kernel.org>
Subject: [PATCH 3.7] mwifiex: fix system hang issue in cmd timeout error case
Date: Thu, 15 Nov 2012 15:58:47 -0800
Message-Id: <1353023928-16983-1-git-send-email-bzhao@marvell.com> (sfid-20121116_010013_992856_8AECAFE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported by Tim Shepard:
I was seeing sporadic failures (wedgeups), and the majority of those
failures I saw printed the printouts in mwifiex_cmd_timeout_func with
cmd = 0xe5 which is CMD_802_11_HS_CFG_ENH.  When this happens, two
minutes later I get notified that the rtcwake thread is blocked, like
this:
      INFO: task rtcwake:3495 blocked for more than 120 seconds.

To get the hung thread unblocked we wake up the cmd wait queue and
cancel the ioctl.

Cc: "3.4+" <stable@vger.kernel.org>
Reported-by: Tim Shepard <shep@laptop.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index c9528b3..5f438e6 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -890,9 +890,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 		return;
 	}
 	cmd_node = adapter->curr_cmd;
-	if (cmd_node->wait_q_enabled)
-		adapter->cmd_wait_q.status = -ETIMEDOUT;
-
 	if (cmd_node) {
 		adapter->dbg.timeout_cmd_id =
 			adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index];
@@ -941,6 +938,14 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 
 		dev_err(adapter->dev, "ps_mode=%d ps_state=%d\n",
 			adapter->ps_mode, adapter->ps_state);
+
+		if (cmd_node->wait_q_enabled) {
+			adapter->cmd_wait_q.status = -ETIMEDOUT;
+			wake_up_interruptible(&adapter->cmd_wait_q.wait);
+			mwifiex_cancel_pending_ioctl(adapter);
+			/* reset cmd_sent flag to unblock new commands */
+			adapter->cmd_sent = false;
+		}
 	}
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);
-- 
1.7.0.2

