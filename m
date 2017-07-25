Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:33353 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756757AbdGYBOT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:19 -0400
Received: by mail-pg0-f45.google.com with SMTP id g14so15187924pgu.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:19 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 09/20] mwifiex: fix misnomers in mwifiex_free_lock_list()
Date: Mon, 24 Jul 2017 18:13:25 -0700
Message-Id: <20170725011336.99993-10-briannorris@chromium.org> (sfid-20170725_031830_362127_84FC3E48)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Despite the name (and meticulous comments), this function frees no
memory and does not touch any locks. All it does is "delete" the list
heads -- which just means they'll be dangling, and we'll need to re-init
them if we use them again.

It seems like this code would work OK as a sort of canary for using the
list after we've torn everything down, so it's fine to keep the code;
let's just get the name and comments to match what's actually happening.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
new in v2; noticed when bugfixing/reworking other parts of this series
---
 drivers/net/wireless/marvell/mwifiex/init.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index de96675e43d5..de974e8bb9c6 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -373,15 +373,13 @@ void mwifiex_stop_net_dev_queue(struct net_device *netdev,
 }
 
 /*
- *  This function releases the lock variables and frees the locks and
- *  associated locks.
+ * This function invalidates the list heads.
  */
-static void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
+static void mwifiex_invalidate_lists(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_private *priv;
 	s32 i, j;
 
-	/* Free lists */
 	list_del(&adapter->cmd_free_q);
 	list_del(&adapter->cmd_pending_q);
 	list_del(&adapter->scan_pending_q);
@@ -422,8 +420,7 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 
 void mwifiex_free_cmd_buffers(struct mwifiex_adapter *adapter)
 {
-	/* Free lock variables */
-	mwifiex_free_lock_list(adapter);
+	mwifiex_invalidate_lists(adapter);
 
 	/* Free command buffer */
 	mwifiex_dbg(adapter, INFO, "info: free cmd buffer\n");
-- 
2.14.0.rc0.284.gd933b75aa4-goog
