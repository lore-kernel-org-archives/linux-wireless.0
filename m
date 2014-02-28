Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21061 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbaB1Dfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 22:35:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@alum.mit.edu>,
	Avery Pennarun <apenwarr@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/9] mwifiex: skipping pending commands after unload
Date: Thu, 27 Feb 2014 19:35:16 -0800
Message-ID: <1393558517-887-2-git-send-email-bzhao@marvell.com> (sfid-20140228_043546_216646_E99372C7)
In-Reply-To: <1393558517-887-1-git-send-email-bzhao@marvell.com>
References: <1393558517-887-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We skip downloading other commands after FUNC_SHUTDOWN is queued
during driver unload. Main thread should be woken up each time
after freeing skipped command so that FUNC_SHUTDOWN gets served
in case if there are other pending commands before FUNC_SHUTDOWN.
Also, call mwifiex_complete_cmd() only for synchronous commands.

Reported-by: Avery Pennarun <apenwarr@gmail.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 58cf3a9..0958764 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -165,8 +165,10 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		dev_err(adapter->dev,
 			"DNLD_CMD: FW in reset state, ignore cmd %#x\n",
 			cmd_code);
-		mwifiex_complete_cmd(adapter, cmd_node);
+		if (cmd_node->wait_q_enabled)
+			mwifiex_complete_cmd(adapter, cmd_node);
 		mwifiex_recycle_cmd_node(adapter, cmd_node);
+		queue_work(adapter->workqueue, &adapter->main_work);
 		return -1;
 	}
 
-- 
1.8.2.3

