Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:34879 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834Ab3ACAHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 19:07:43 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@laptop.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, "3.6+" <stable@vger.kernel.org>
Subject: [PATCH 3.8] mwifiex: check wait_event_interruptible return value
Date: Wed,  2 Jan 2013 16:07:35 -0800
Message-Id: <1357171655-26850-1-git-send-email-bzhao@marvell.com> (sfid-20130103_010747_368256_3DD933A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wait_event_interruptible function returns -ERESTARTSYS if it's
interrupted by a signal. Driver should check the return value
and handle this case properly.

In mwifiex_wait_queue_complete() routine, as we are now checking
wait_event_interruptible return value, the condition check is not
required. Also, we have removed mwifiex_cancel_pending_ioctl()
call to avoid a chance of sending second command to FW by other path
as soon as we clear current command node. FW can not handle two
commands simultaneously.

Cc: "3.6+" <stable@vger.kernel.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index cb68256..60e88b5 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -56,7 +56,6 @@ int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
  */
 int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 {
-	bool cancel_flag = false;
 	int status;
 	struct cmd_ctrl_node *cmd_queued;
 
@@ -70,14 +69,11 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 	atomic_inc(&adapter->cmd_pending);
 
 	/* Wait for completion */
-	wait_event_interruptible(adapter->cmd_wait_q.wait,
-				 *(cmd_queued->condition));
-	if (!*(cmd_queued->condition))
-		cancel_flag = true;
-
-	if (cancel_flag) {
-		mwifiex_cancel_pending_ioctl(adapter);
-		dev_dbg(adapter->dev, "cmd cancel\n");
+	status = wait_event_interruptible(adapter->cmd_wait_q.wait,
+					  *(cmd_queued->condition));
+	if (status) {
+		dev_err(adapter->dev, "cmd_wait_q terminated: %d\n", status);
+		return status;
 	}
 
 	status = adapter->cmd_wait_q.status;
@@ -496,8 +492,11 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 		return false;
 	}
 
-	wait_event_interruptible(adapter->hs_activate_wait_q,
-				 adapter->hs_activate_wait_q_woken);
+	if (wait_event_interruptible(adapter->hs_activate_wait_q,
+				     adapter->hs_activate_wait_q_woken)) {
+		dev_err(adapter->dev, "hs_activate_wait_q terminated\n");
+		return false;
+	}
 
 	return true;
 }
-- 
1.7.0.2

