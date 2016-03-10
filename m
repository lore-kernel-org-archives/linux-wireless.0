Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36283 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935187AbcCJIod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 03:44:33 -0500
Received: by mail-wm0-f47.google.com with SMTP id n186so19330629wmn.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2016 00:44:32 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v2 7/7] mwifiex: make mwifiex_insert_cmd_to_free_q local static
Date: Thu, 10 Mar 2016 09:44:11 +0100
Message-Id: <1457599451-13910-8-git-send-email-afenkart@gmail.com> (sfid-20160310_094437_371472_D3D8420A)
In-Reply-To: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
References: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

after factoring out mwifiex_cancel_pending_scan_cmd
the function is not called outside of cmdevt file
moved function to head of file to avoid forward declaration,
also moved mwifiex_recycle_cmd_node since they are very similar

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 82 +++++++++++++--------------
 drivers/net/wireless/marvell/mwifiex/main.h   |  2 -
 2 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 61426b3..3d7de4a 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -105,6 +105,47 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 }
 
 /*
+ * This function returns a command to the command free queue.
+ *
+ * The function also calls the completion callback if required, before
+ * cleaning the command node and re-inserting it into the free queue.
+ */
+static void
+mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
+			     struct cmd_ctrl_node *cmd_node)
+{
+	unsigned long flags;
+
+	if (!cmd_node)
+		return;
+
+	if (cmd_node->wait_q_enabled)
+		mwifiex_complete_cmd(adapter, cmd_node);
+	/* Clean the node */
+	mwifiex_clean_cmd_node(adapter, cmd_node);
+
+	/* Insert node into cmd_free_q */
+	spin_lock_irqsave(&adapter->cmd_free_q_lock, flags);
+	list_add_tail(&cmd_node->list, &adapter->cmd_free_q);
+	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
+}
+
+/* This function reuses a command node. */
+void mwifiex_recycle_cmd_node(struct mwifiex_adapter *adapter,
+			      struct cmd_ctrl_node *cmd_node)
+{
+	struct host_cmd_ds_command *host_cmd = (void *)cmd_node->cmd_skb->data;
+
+	mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+
+	atomic_dec(&adapter->cmd_pending);
+	mwifiex_dbg(adapter, CMD,
+		    "cmd: FREE_CMD: cmd=%#x, cmd_pending=%d\n",
+		le16_to_cpu(host_cmd->command),
+		atomic_read(&adapter->cmd_pending));
+}
+
+/*
  * This function sends a host command to the firmware.
  *
  * The function copies the host command into the driver command
@@ -614,47 +655,6 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 }
 
 /*
- * This function returns a command to the command free queue.
- *
- * The function also calls the completion callback if required, before
- * cleaning the command node and re-inserting it into the free queue.
- */
-void
-mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
-			     struct cmd_ctrl_node *cmd_node)
-{
-	unsigned long flags;
-
-	if (!cmd_node)
-		return;
-
-	if (cmd_node->wait_q_enabled)
-		mwifiex_complete_cmd(adapter, cmd_node);
-	/* Clean the node */
-	mwifiex_clean_cmd_node(adapter, cmd_node);
-
-	/* Insert node into cmd_free_q */
-	spin_lock_irqsave(&adapter->cmd_free_q_lock, flags);
-	list_add_tail(&cmd_node->list, &adapter->cmd_free_q);
-	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
-}
-
-/* This function reuses a command node. */
-void mwifiex_recycle_cmd_node(struct mwifiex_adapter *adapter,
-			      struct cmd_ctrl_node *cmd_node)
-{
-	struct host_cmd_ds_command *host_cmd = (void *)cmd_node->cmd_skb->data;
-
-	mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-
-	atomic_dec(&adapter->cmd_pending);
-	mwifiex_dbg(adapter, CMD,
-		    "cmd: FREE_CMD: cmd=%#x, cmd_pending=%d\n",
-		le16_to_cpu(host_cmd->command),
-		atomic_read(&adapter->cmd_pending));
-}
-
-/*
  * This function queues a command to the command pending queue.
  *
  * This in effect adds the command to the command list to be executed.
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index f71f894..840e5d4 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1045,8 +1045,6 @@ void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_pending_scan_cmd(struct mwifiex_adapter *adapter);
 
-void mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
-				  struct cmd_ctrl_node *cmd_node);
 void mwifiex_recycle_cmd_node(struct mwifiex_adapter *adapter,
 			      struct cmd_ctrl_node *cmd_node);
 
-- 
2.7.0

