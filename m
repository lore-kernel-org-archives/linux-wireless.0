Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:41860 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004Ab3ERAuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 20:50:39 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 01/17] mwifiex: rename mwifiex_free_adapter() routine in init.c
Date: Fri, 17 May 2013 17:50:18 -0700
Message-ID: <1368838234-32585-2-git-send-email-bzhao@marvell.com> (sfid-20130518_025044_882255_ECB50773)
In-Reply-To: <1368838234-32585-1-git-send-email-bzhao@marvell.com>
References: <1368838234-32585-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We have two different static routines with name
mwifiex_free_adapter(). The routine in main.c actually frees the
adapter structure.

We will rename other routine in init.c to mwifiex_adapter_cleanup()
to avoid confusion.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 9f44fda..58e151e 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -447,17 +447,16 @@ static void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function frees the adapter structure.
+ * This function performs cleanup for adapter structure.
  *
- * The freeing operation is done recursively, by canceling all
- * pending commands, freeing the member buffers previously
- * allocated (command buffers, scan table buffer, sleep confirm
- * command buffer), stopping the timers and calling the cleanup
- * routines for every interface, before the actual adapter
- * structure is freed.
+ * The cleanup is done recursively, by canceling all pending
+ * commands, freeing the member buffers previously allocated
+ * (command buffers, scan table buffer, sleep confirm command
+ * buffer), stopping the timers and calling the cleanup routines
+ * for every interface.
  */
 static void
-mwifiex_free_adapter(struct mwifiex_adapter *adapter)
+mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
 	if (!adapter) {
 		pr_err("%s: adapter is NULL\n", __func__);
@@ -733,8 +732,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 		}
 	}
 
-	/* Free adapter structure */
-	mwifiex_free_adapter(adapter);
+	mwifiex_adapter_cleanup(adapter);
 
 	spin_unlock_irqrestore(&adapter->mwifiex_lock, flags);
 
-- 
1.8.2.3

