Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:35163 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471Ab1GIOla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 10:41:30 -0400
From: Daniel Drake <dsd@laptop.org>
To: dcbw@redhat.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: fix handling of command timeout, completion and interruption
Message-Id: <20110709144125.A0FB49D401C@zog.reactivated.net> (sfid-20110709_164137_313608_D439E91C)
Date: Sat,  9 Jul 2011 15:41:25 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When commands time out, corruption ensues. As lbs_complete_command()
is called without locking, the command node is mistakenly freed twice.
Also fixed up locking here in a few other places.

The nature of command timeout may be that the card didn't even
acknowledge receipt of the request. Detect this case and reset dnld_sent
so that other commands don't hang forever.

When cmdnodes are moved between the free list and the pending list,
their list heads should be reinitialized. Fixed this.

Sometimes commands are completed without actually submitting them or
removing them from cmdpendingq. We must remember to remove them from
cmdpendingq in these cases, so handle this in lbs_complete_command().

Harmless signals generated during suspend/resume were interrupting
lbs_cmd. Convert to an uninterruptible sleep to avoid this.

lbs_thread must be woken up every time there is some new work to do.
I found that when 2 commands are queued, ther completion of the first
command would not wake up lbs_thread to submit the second. Poke lbs_thread
at the end of lbs_complete_command() to fix this.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/cmd.c     |   42 ++++++++++++++++++++++---------
 drivers/net/wireless/libertas/cmd.h     |    2 +
 drivers/net/wireless/libertas/cmdresp.c |    6 ++--
 drivers/net/wireless/libertas/main.c    |   12 +++++++-
 4 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 71c8f3f..0e89d23 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1067,16 +1067,34 @@ static void lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 }
 
-void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
-			  int result)
+void __lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
+			    int result)
 {
+	/*
+	 * Normally, commands are removed from cmdpendingq before being
+	 * submitted. However, we can arrive here on alternative codepaths
+	 * where the command is still pending. Make sure the command really
+	 * isn't part of a list at this point.
+	 */
+	list_del_init(&cmd->list);
+
 	cmd->result = result;
 	cmd->cmdwaitqwoken = 1;
-	wake_up_interruptible(&cmd->cmdwait_q);
+	wake_up(&cmd->cmdwait_q);
 
 	if (!cmd->callback || cmd->callback == lbs_cmd_async_callback)
 		__lbs_cleanup_and_insert_cmd(priv, cmd);
 	priv->cur_cmd = NULL;
+	wake_up_interruptible(&priv->waitq);
+}
+
+void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
+			  int result)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&priv->driver_lock, flags);
+	__lbs_complete_command(priv, cmd, result);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 }
 
 int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on)
@@ -1248,7 +1266,7 @@ static struct cmd_ctrl_node *lbs_get_free_cmd_node(struct lbs_private *priv)
 	if (!list_empty(&priv->cmdfreeq)) {
 		tempnode = list_first_entry(&priv->cmdfreeq,
 					    struct cmd_ctrl_node, list);
-		list_del(&tempnode->list);
+		list_del_init(&tempnode->list);
 	} else {
 		lbs_deb_host("GET_CMD_NODE: cmd_ctrl_node is not available\n");
 		tempnode = NULL;
@@ -1356,10 +1374,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				    cpu_to_le16(PS_MODE_ACTION_EXIT_PS)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore ENTER_PS cmd\n");
-					spin_lock_irqsave(&priv->driver_lock, flags);
-					list_del(&cmdnode->list);
 					lbs_complete_command(priv, cmdnode, 0);
-					spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 					ret = 0;
 					goto done;
@@ -1369,10 +1384,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				    (priv->psstate == PS_STATE_PRE_SLEEP)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
-					spin_lock_irqsave(&priv->driver_lock, flags);
-					list_del(&cmdnode->list);
 					lbs_complete_command(priv, cmdnode, 0);
-					spin_unlock_irqrestore(&priv->driver_lock, flags);
 					priv->needtowakeup = 1;
 
 					ret = 0;
@@ -1384,7 +1396,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 			}
 		}
 		spin_lock_irqsave(&priv->driver_lock, flags);
-		list_del(&cmdnode->list);
+		list_del_init(&cmdnode->list);
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
 			    le16_to_cpu(cmd->command));
@@ -1667,7 +1679,13 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	}
 
 	might_sleep();
-	wait_event_interruptible(cmdnode->cmdwait_q, cmdnode->cmdwaitqwoken);
+
+	/*
+	 * Be careful with signals here. A signal may be received as the system
+	 * goes into suspend or resume. We do not want this to interrupt the
+	 * command, so we perform an uninterruptible sleep.
+	 */
+	wait_event(cmdnode->cmdwait_q, cmdnode->cmdwaitqwoken);
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	ret = cmdnode->result;
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 7109d6b..b280ef7 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -59,6 +59,8 @@ int lbs_allocate_cmd_buffer(struct lbs_private *priv);
 int lbs_free_cmd_buffer(struct lbs_private *priv);
 
 int lbs_execute_next_command(struct lbs_private *priv);
+void __lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
+			    int result);
 void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
 			  int result);
 int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len);
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 207fc36..7da8949 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -165,7 +165,7 @@ int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len)
 			lbs_deb_host("CMD_RESP: PS action 0x%X\n", action);
 		}
 
-		lbs_complete_command(priv, priv->cur_cmd, result);
+		__lbs_complete_command(priv, priv->cur_cmd, result);
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 		ret = 0;
@@ -186,7 +186,7 @@ int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len)
 			break;
 
 		}
-		lbs_complete_command(priv, priv->cur_cmd, result);
+		__lbs_complete_command(priv, priv->cur_cmd, result);
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 		ret = -1;
@@ -204,7 +204,7 @@ int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len)
 
 	if (priv->cur_cmd) {
 		/* Clean up and Put current command back to cmdfreeq */
-		lbs_complete_command(priv, priv->cur_cmd, result);
+		__lbs_complete_command(priv, priv->cur_cmd, result);
 	}
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 8c40949..a839de0 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -638,6 +638,14 @@ static void lbs_cmd_timeout_handler(unsigned long data)
 		    le16_to_cpu(priv->cur_cmd->cmdbuf->command));
 
 	priv->cmd_timed_out = 1;
+
+	/*
+	 * If the device didn't even acknowledge the command, reset the state
+	 * so that we don't block all future commands due to this one timeout.
+	 */
+	if (priv->dnld_sent == DNLD_CMD_SENT)
+		priv->dnld_sent = DNLD_RES_RECEIVED;
+
 	wake_up_interruptible(&priv->waitq);
 out:
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -994,7 +1002,7 @@ void lbs_stop_card(struct lbs_private *priv)
 	list_for_each_entry(cmdnode, &priv->cmdpendingq, list) {
 		cmdnode->result = -ENOENT;
 		cmdnode->cmdwaitqwoken = 1;
-		wake_up_interruptible(&cmdnode->cmdwait_q);
+		wake_up(&cmdnode->cmdwait_q);
 	}
 
 	/* Flush the command the card is currently processing */
@@ -1002,7 +1010,7 @@ void lbs_stop_card(struct lbs_private *priv)
 		lbs_deb_main("clearing current command\n");
 		priv->cur_cmd->result = -ENOENT;
 		priv->cur_cmd->cmdwaitqwoken = 1;
-		wake_up_interruptible(&priv->cur_cmd->cmdwait_q);
+		wake_up(&priv->cur_cmd->cmdwait_q);
 	}
 	lbs_deb_main("done clearing commands\n");
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
-- 
1.7.5.4

