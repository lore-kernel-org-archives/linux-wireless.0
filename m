Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49277 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760167AbXLPW6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:52 -0500
Subject: [PATCH 113/48] libertas: handle command timeout in main thread instead of directly in timer
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42SG-00038u-5T@shinybook.infradead.org> (sfid-20071216_232426_527525_81B9716A)
Date: Sun, 16 Dec 2007 17:59:28 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 19:33:43 -0500

And handle the case where it times out more than once, too, instead of
locking up for ever.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmdresp.c |    6 +++
 drivers/net/wireless/libertas/dev.h     |    2 +
 drivers/net/wireless/libertas/main.c    |   52 ++++++++++++++++++-------------
 3 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 4c22e78..ef63c37 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -667,6 +667,12 @@ int lbs_process_rx_command(struct lbs_private *priv)
 
 	/* Now we got response from FW, cancel the command timer */
 	del_timer(&priv->command_timer);
+	priv->cmd_timed_out = 0;
+	if (priv->nr_retries) {
+		lbs_pr_info("Received result %x to command %x after %d retries\n",
+			    result, curcmd, priv->nr_retries);
+		priv->nr_retries = 0;
+	}
 
 	/* Store the response code to cur_cmd_retcode. */
 	priv->cur_cmd_retcode = result;
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index e6f553d..465080f 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -201,6 +201,8 @@ struct lbs_private {
 
 	/** Timers */
 	struct timer_list command_timer;
+	int nr_retries;
+	int cmd_timed_out;
 
 	u8 hisregcpy;
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 839ffe8..9677b0d 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -670,6 +670,8 @@ static int lbs_thread(void *data)
 			shouldsleep = 1;	/* Sleep mode. Nothing we can do till it wakes */
 		else if (priv->intcounter)
 			shouldsleep = 0;	/* Interrupt pending. Deal with it now */
+		else if (priv->cmd_timed_out)
+			shouldsleep = 0;	/* Command timed out. Recover */
 		else if (!priv->fw_ready)
 			shouldsleep = 1;	/* Firmware not ready. We're waiting for it */
 		else if (priv->dnld_sent)
@@ -740,6 +742,26 @@ static int lbs_thread(void *data)
 			spin_lock_irq(&priv->driver_lock);
 		}
 
+		if (priv->cmd_timed_out && priv->cur_cmd) {
+			struct cmd_ctrl_node *cmdnode = priv->cur_cmd;
+
+			if (++priv->nr_retries > 10) {
+				lbs_pr_info("Excessive timeouts submitting command %x\n",
+					    le16_to_cpu(cmdnode->cmdbuf->command));
+				lbs_complete_command(priv, cmdnode, -ETIMEDOUT);
+				priv->nr_retries = 0;
+			} else {
+				priv->cur_cmd = NULL;
+				lbs_pr_info("requeueing command %x due to timeout (#%d)\n",
+					    le16_to_cpu(cmdnode->cmdbuf->command), priv->nr_retries);
+
+				/* Stick it back at the _top_ of the pending queue
+				   for immediate resubmission */
+				list_add(&cmdnode->list, &priv->cmdpendingq);
+			}
+		}
+		priv->cmd_timed_out = 0;
+
 		/* Any Card Event */
 		if (priv->hisregcpy & MRVDRV_CARDEVENT) {
 			lbs_deb_thread("main-thread: Card Event Activity\n");
@@ -922,35 +944,21 @@ done:
 static void command_timer_fn(unsigned long data)
 {
 	struct lbs_private *priv = (struct lbs_private *)data;
-	struct cmd_ctrl_node *node;
 	unsigned long flags;
 
-	node = priv->cur_cmd;
-	if (node == NULL) {
-		lbs_deb_fw("ptempnode empty\n");
-		return;
-	}
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
-	if (!node->cmdbuf) {
-		lbs_deb_fw("cmd is NULL\n");
-		return;
+	if (!priv->cur_cmd) {
+		lbs_pr_info("Command timer expired; no pending command\n");
+		goto out;
 	}
 
-	lbs_pr_info("command %x timed out\n", le16_to_cpu(node->cmdbuf->command));
-
-	if (!priv->fw_ready)
-		return;
-
-	spin_lock_irqsave(&priv->driver_lock, flags);
-	priv->cur_cmd = NULL;
-	spin_unlock_irqrestore(&priv->driver_lock, flags);
-
-	lbs_deb_fw("re-sending same command because of timeout\n");
-	lbs_queue_cmd(priv, node, 0);
+	lbs_pr_info("Command %x timed out\n", le16_to_cpu(priv->cur_cmd->cmdbuf->command));
 
+	priv->cmd_timed_out = 1;
 	wake_up_interruptible(&priv->waitq);
-
-	return;
+ out:
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 }
 
 static int lbs_init_adapter(struct lbs_private *priv)
-- 
1.5.3.4

