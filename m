Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:34568 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754682Ab1I3DoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 23:44:08 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: handle an error path correctly
Date: Thu, 29 Sep 2011 20:43:41 -0700
Message-Id: <1317354221-13688-2-git-send-email-bzhao@marvell.com> (sfid-20110930_054420_744140_03688A9B)
In-Reply-To: <1317354221-13688-1-git-send-email-bzhao@marvell.com>
References: <1317354221-13688-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

In failure case locks are not allocated in mwifiex_register().
So mwifiex_free_lock_list() routine call becomes redundant.
Also we don't need to check return type for mwifiex_init_lock_list()
routine. It never fails.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 8b05b4f..8486451 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -75,8 +75,7 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 	adapter->priv_num++;
 
 	adapter->priv[0]->adapter = adapter;
-	if (mwifiex_init_lock_list(adapter))
-		goto error;
+	mwifiex_init_lock_list(adapter);
 
 	init_timer(&adapter->cmd_timer);
 	adapter->cmd_timer.function = mwifiex_cmd_timeout_func;
@@ -87,8 +86,6 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 error:
 	dev_dbg(adapter->dev, "info: leave mwifiex_register with error\n");
 
-	mwifiex_free_lock_list(adapter);
-
 	for (i = 0; i < adapter->priv_num; i++)
 		kfree(adapter->priv[i]);
 
-- 
1.7.0.2

