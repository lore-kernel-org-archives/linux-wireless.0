Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:33996 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756760AbdGYBOU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:20 -0400
Received: by mail-pf0-f181.google.com with SMTP id q85so53114359pfq.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:20 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 10/20] mwifiex: make mwifiex_free_cmd_buffer() return void
Date: Mon, 24 Jul 2017 18:13:26 -0700
Message-Id: <20170725011336.99993-11-briannorris@chromium.org> (sfid-20170725_031828_761640_A25EDC96)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't fail.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
new in v2; noticed when reworking driver
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 6 ++----
 drivers/net/wireless/marvell/mwifiex/main.h   | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 8dad52886034..6ff8e84b01e0 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -427,7 +427,7 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
  * The function calls the completion callback for all the command
  * buffers that still have response buffers associated with them.
  */
-int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
+void mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_array;
 	u32 i;
@@ -436,7 +436,7 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 	if (!adapter->cmd_pool) {
 		mwifiex_dbg(adapter, FATAL,
 			    "info: FREE_CMD_BUF: cmd_pool is null\n");
-		return 0;
+		return;
 	}
 
 	cmd_array = adapter->cmd_pool;
@@ -464,8 +464,6 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 		kfree(adapter->cmd_pool);
 		adapter->cmd_pool = NULL;
 	}
-
-	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 62ce4e81f695..2bee5cdf1fc8 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1077,7 +1077,7 @@ int mwifiex_get_debug_info(struct mwifiex_private *,
 			   struct mwifiex_debug_info *);
 
 int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter);
-int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
+void mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
 void mwifiex_free_cmd_buffers(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter);
-- 
2.14.0.rc0.284.gd933b75aa4-goog
