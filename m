Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:59145 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074Ab0BDNj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 08:39:26 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: don't retry commands
Date: Thu, 4 Feb 2010 14:37:45 +0100
Cc: Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201002041437.45519.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Retrying commands seldomly works, most often the firmware is in a
weird state anyway and needs the device to reset. So it's better
to report the broken state back to user-space.

Also rename command_timer_fn() into lbs_cmd_timeout_handler(),
which better reflect it's usage.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---
 drivers/net/wireless/libertas/cmdresp.c |    5 -----
 drivers/net/wireless/libertas/dev.h     |    1 -
 drivers/net/wireless/libertas/main.c    |   31 +++++++------------------------
 3 files changed, 7 insertions(+), 30 deletions(-)

--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -218,11 +218,6 @@ int lbs_process_command_response(struct 
 	/* Now we got response from FW, cancel the command timer */
 	del_timer(&priv->command_timer);
 	priv->cmd_timed_out = 0;
-	if (priv->nr_retries) {
-		lbs_pr_info("Received result %x to command %x after %d retries\n",
-			    result, curcmd, priv->nr_retries);
-		priv->nr_retries = 0;
-	}
 
 	/* Store the response code to cur_cmd_retcode. */
 	priv->cur_cmd_retcode = result;
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -107,7 +107,6 @@ struct lbs_private {
 	struct list_head cmdpendingq; /* pending command buffers */
 	wait_queue_head_t cmd_pending;
 	struct timer_list command_timer;
-	int nr_retries;
 	int cmd_timed_out;
 
 	/* Command responses sent from the hardware to the driver */
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -457,31 +457,14 @@ static int lbs_thread(void *data)
 		if (priv->cmd_timed_out && priv->cur_cmd) {
 			struct cmd_ctrl_node *cmdnode = priv->cur_cmd;
 
-			if (++priv->nr_retries > 3) {
-				lbs_pr_info("Excessive timeouts submitting "
-					"command 0x%04x\n",
-					le16_to_cpu(cmdnode->cmdbuf->command));
-				lbs_complete_command(priv, cmdnode, -ETIMEDOUT);
-				priv->nr_retries = 0;
-				if (priv->reset_card)
-					priv->reset_card(priv);
-			} else {
-				priv->cur_cmd = NULL;
-				priv->dnld_sent = DNLD_RES_RECEIVED;
-				lbs_pr_info("requeueing command 0x%04x due "
-					"to timeout (#%d)\n",
-					le16_to_cpu(cmdnode->cmdbuf->command),
-					priv->nr_retries);
-
-				/* Stick it back at the _top_ of the pending queue
-				   for immediate resubmission */
-				list_add(&cmdnode->list, &priv->cmdpendingq);
-			}
+			lbs_pr_info("Timeout submitting command 0x%04x\n",
+				le16_to_cpu(cmdnode->cmdbuf->command));
+			lbs_complete_command(priv, cmdnode, -ETIMEDOUT);
+			if (priv->reset_card)
+				priv->reset_card(priv);
 		}
 		priv->cmd_timed_out = 0;
 
-
-
 		if (!priv->fw_ready)
 			continue;
 
@@ -653,7 +636,7 @@ done:
  *  This function handles the timeout of command sending.
  *  It will re-send the same command again.
  */
-static void command_timer_fn(unsigned long data)
+static void lbs_cmd_timeout_handler(unsigned long data)
 {
 	struct lbs_private *priv = (struct lbs_private *)data;
 	unsigned long flags;
@@ -751,7 +734,7 @@ static int lbs_init_adapter(struct lbs_p
 
 	mutex_init(&priv->lock);
 
-	setup_timer(&priv->command_timer, command_timer_fn,
+	setup_timer(&priv->command_timer, lbs_cmd_timeout_handler,
 		(unsigned long)priv);
 	setup_timer(&priv->auto_deepsleep_timer, auto_deepsleep_timer_fn,
 			(unsigned long)priv);
