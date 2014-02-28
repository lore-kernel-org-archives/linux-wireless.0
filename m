Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12624 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbaB1Df1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 22:35:27 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 6/9] mwifiex: block further commands after timeout
Date: Thu, 27 Feb 2014 19:35:15 -0800
Message-ID: <1393558518-921-1-git-send-email-bzhao@marvell.com> (sfid-20140228_043530_938571_E7884DD8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch adds a check in command preparation routine.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 0958764..83195d9 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -514,6 +514,11 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 		return -1;
 	}
 
+	if (adapter->num_cmd_timeout) {
+		dev_err(adapter->dev, "PREP_CMD: FW is in bad state\n");
+		return -1;
+	}
+
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_RESET) {
 		if (cmd_no != HostCmd_CMD_FUNC_INIT) {
 			dev_err(adapter->dev, "PREP_CMD: FW in reset state\n");
-- 
1.8.2.3

