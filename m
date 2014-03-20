Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34034 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759420AbaCTXYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 19:24:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: cancel pending commands for signal
Date: Thu, 20 Mar 2014 16:23:49 -0700
Message-ID: <1395357830-15722-2-git-send-email-bzhao@marvell.com> (sfid-20140321_002421_785996_A17C9CC0)
In-Reply-To: <1395357830-15722-1-git-send-email-bzhao@marvell.com>
References: <1395357830-15722-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When a thread is interrupted by signal, all
wait_event_interruptible calls after queueing commands return
an error. Numbers of commands in pending queue are increased
in this case. Sometimes all commands nodes in pool are filled.

We will cancel pending commands when signal is received.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 33170af..95abaf4 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -64,6 +64,7 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter,
 					  *(cmd_queued->condition));
 	if (status) {
 		dev_err(adapter->dev, "cmd_wait_q terminated: %d\n", status);
+		mwifiex_cancel_all_pending_cmd(adapter);
 		return status;
 	}
 
-- 
1.8.2.3

