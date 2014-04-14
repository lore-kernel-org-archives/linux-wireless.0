Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22407 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537AbaDNWbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 18:31:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.15] mwifiex: fix hung task on command timeout
Date: Mon, 14 Apr 2014 15:31:06 -0700
Message-ID: <1397514666-4656-2-git-send-email-bzhao@marvell.com> (sfid-20140415_003121_151942_AA492A9D)
In-Reply-To: <1397514666-4656-1-git-send-email-bzhao@marvell.com>
References: <1397514666-4656-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Sometimes when command timeout occurs due to a firmware or
hardware bug, there may be some synchronous commands in command
queue. These commands are never downloaded to firmware causing
hung task warnings. This patch replaces wait_event_interruptible
call with wait_event_interruptible_timeout to fix the issue.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 8942706..536c14a 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -60,9 +60,10 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter,
 	int status;
 
 	/* Wait for completion */
-	status = wait_event_interruptible(adapter->cmd_wait_q.wait,
-					  *(cmd_queued->condition));
-	if (status) {
+	status = wait_event_interruptible_timeout(adapter->cmd_wait_q.wait,
+						  *(cmd_queued->condition),
+						  (12 * HZ));
+	if (status <= 0) {
 		dev_err(adapter->dev, "cmd_wait_q terminated: %d\n", status);
 		mwifiex_cancel_all_pending_cmd(adapter);
 		return status;
-- 
1.8.2.3

