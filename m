Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:50622 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753895Ab3GWCSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:54 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 12/21] mwifiex: remove unnecessary del_timer(cmd_timer)
Date: Mon, 22 Jul 2013 19:17:49 -0700
Message-ID: <1374545878-15683-13-git-send-email-bzhao@marvell.com> (sfid-20130723_041925_643457_FC80E439)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

It is already there in mwifiex_unregister(). So unnecessary
call in mwifiex_adapter_cleanup() is removed in this patch.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 787cff8..8ff5d7b 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -392,8 +392,6 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 	dev_dbg(adapter->dev, "info: free cmd buffer\n");
 	mwifiex_free_cmd_buffer(adapter);
 
-	del_timer(&adapter->cmd_timer);
-
 	dev_dbg(adapter->dev, "info: free scan table\n");
 
 	if (adapter->if_ops.cleanup_if)
-- 
1.8.2.3

