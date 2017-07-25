Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:34277 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756778AbdGYBOX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:23 -0400
Received: by mail-pg0-f45.google.com with SMTP id 123so64047407pgj.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:23 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 13/20] mwifiex: drop 'add_tail' param from mwifiex_insert_cmd_to_pending_q()
Date: Mon, 24 Jul 2017 18:13:29 -0700
Message-Id: <20170725011336.99993-14-briannorris@chromium.org> (sfid-20170725_031755_857601_5F48F3D1)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's always called with 'true' -- we only determine it 'false' locally
within this function. So drop the parameter.

Also, this should be 'bool' (since we use true/false), not 'u32'.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: no change
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 5 +++--
 drivers/net/wireless/marvell/mwifiex/main.h   | 3 +--
 drivers/net/wireless/marvell/mwifiex/scan.c   | 5 ++---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 6ff8e84b01e0..3f5e822673bf 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -664,7 +664,7 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 	    cmd_no == HostCmd_CMD_802_11_SCAN_EXT) {
 		mwifiex_queue_scan_cmd(priv, cmd_node);
 	} else {
-		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
+		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node);
 		queue_work(adapter->workqueue, &adapter->main_work);
 		if (cmd_node->wait_q_enabled)
 			ret = mwifiex_wait_queue_complete(adapter, cmd_node);
@@ -682,11 +682,12 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
  */
 void
 mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
-				struct cmd_ctrl_node *cmd_node, u32 add_tail)
+				struct cmd_ctrl_node *cmd_node)
 {
 	struct host_cmd_ds_command *host_cmd = NULL;
 	u16 command;
 	unsigned long flags;
+	bool add_tail = true;
 
 	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	if (!host_cmd) {
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 2bee5cdf1fc8..909bd1ad3838 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1088,8 +1088,7 @@ void mwifiex_recycle_cmd_node(struct mwifiex_adapter *adapter,
 			      struct cmd_ctrl_node *cmd_node);
 
 void mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
-				     struct cmd_ctrl_node *cmd_node,
-				     u32 addtail);
+				     struct cmd_ctrl_node *cmd_node);
 
 int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter);
 int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index ae9630b49342..16eaeae74979 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1534,8 +1534,7 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 			list_del(&cmd_node->list);
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
-			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
-							true);
+			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node);
 			queue_work(adapter->workqueue, &adapter->main_work);
 
 			/* Perform internal scan synchronously */
@@ -2033,7 +2032,7 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 					    struct cmd_ctrl_node, list);
 		list_del(&cmd_node->list);
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
-		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
+		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node);
 	}
 
 	return;
-- 
2.14.0.rc0.284.gd933b75aa4-goog
