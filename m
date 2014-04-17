Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48498 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbaDQFCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 01:02:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: don't clear cmd_sent flag in timeout handler
Date: Wed, 16 Apr 2014 22:01:54 -0700
Message-ID: <1397710914-10061-2-git-send-email-bzhao@marvell.com> (sfid-20140417_070713_408345_4407DB6E)
In-Reply-To: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
References: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When command timeout occurs due to a firmware/hardware bug,
there is no chance of next command being successful. We will
keep cmd_sent flag on so that next command won't be sent to
firmware.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 1062c91..8dee6c8 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -955,8 +955,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 			adapter->cmd_wait_q.status = -ETIMEDOUT;
 			wake_up_interruptible(&adapter->cmd_wait_q.wait);
 			mwifiex_cancel_pending_ioctl(adapter);
-			/* reset cmd_sent flag to unblock new commands */
-			adapter->cmd_sent = false;
 		}
 	}
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
-- 
1.8.2.3

