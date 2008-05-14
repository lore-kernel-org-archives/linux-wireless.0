Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:27816 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbYENOeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 10:34:04 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH, take 2] libertas: reduce command retry time
Date: Wed, 14 May 2008 16:30:28 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805141630.28357.hs4233@mail.mn-solutions.de> (sfid-20080514_163645_109653_B723CA68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[PATCH, take 2] libertas: reduce command retry time

In the normal case, an unsuccessful command would be retried for 10*5 seconds,
or 10*10 seconds in the worst case. This patch reduces this to 3*3 seconds,
or 3*10 seconds in the worst case.

I also reduced the time it takes to start a new command downloaded.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
With this patch, I don't have a command retry kernel log anymore in my
devices, even after running for hours and calling "iwconfig" every
1.5 seconds while constantly sending out VNC updates. I bumped up the
times from my last mail.

It reduces loooooong delays if a command get's retried and you issue
"pccardctl eject" at the same time. This command unfortunately doesn't
set priv->surpriseremoved, which would speed up things tremendously.

Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-05-06 14:06:40.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-05-13 14:17:52.000000000 +0200
@@ -1144,7 +1144,7 @@ static void lbs_submit_command(struct lb
 	struct cmd_header *cmd;
 	uint16_t cmdsize;
 	uint16_t command;
-	int timeo = 5 * HZ;
+	int timeo = 3 * HZ;
 	int ret;
 
 	lbs_deb_enter(LBS_DEB_HOST);
@@ -1162,7 +1162,7 @@ static void lbs_submit_command(struct lb
 	/* These commands take longer */
 	if (command == CMD_802_11_SCAN || command == CMD_802_11_ASSOCIATE ||
 	    command == CMD_802_11_AUTHENTICATE)
-		timeo = 10 * HZ;
+		timeo = 5 * HZ;
 
 	lbs_deb_cmd("DNLD_CMD: command 0x%04x, seq %d, size %d\n",
 		     command, le16_to_cpu(cmd->seqnum), cmdsize);
@@ -1174,7 +1174,7 @@ static void lbs_submit_command(struct lb
 		lbs_pr_info("DNLD_CMD: hw_host_to_card failed: %d\n", ret);
 		/* Let the timer kick in and retry, and potentially reset
 		   the whole thing if the condition persists */
-		timeo = HZ;
+		timeo = HZ/4;
 	}
 
 	/* Setup the timer after transmit command */
Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-05-13 14:17:44.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-05-13 14:19:07.000000000 +0200
@@ -749,16 +749,19 @@ static int lbs_thread(void *data)
 		if (priv->cmd_timed_out && priv->cur_cmd) {
 			struct cmd_ctrl_node *cmdnode = priv->cur_cmd;
 
-			if (++priv->nr_retries > 10) {
-				lbs_pr_info("Excessive timeouts submitting command %x\n",
-					    le16_to_cpu(cmdnode->cmdbuf->command));
+			if (++priv->nr_retries > 3) {
+				lbs_pr_info("excessive timeouts submitting "
+					"command 0x%04x\n",
+					le16_to_cpu(cmdnode->cmdbuf->command));
 				lbs_complete_command(priv, cmdnode, -ETIMEDOUT);
 				priv->nr_retries = 0;
 			} else {
 				priv->cur_cmd = NULL;
 				priv->dnld_sent = DNLD_RES_RECEIVED;
-				lbs_pr_info("requeueing command %x due to timeout (#%d)\n",
-					    le16_to_cpu(cmdnode->cmdbuf->command), priv->nr_retries);
+				lbs_pr_info("requeueing command 0x%04x due "
+					"to timeout (#%d)\n",
+					le16_to_cpu(cmdnode->cmdbuf->command),
+					priv->nr_retries);
 
 				/* Stick it back at the _top_ of the pending queue
 				   for immediate resubmission */
@@ -959,12 +962,11 @@ static void command_timer_fn(unsigned lo
 	lbs_deb_enter(LBS_DEB_CMD);
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
-	if (!priv->cur_cmd) {
-		lbs_pr_info("Command timer expired; no pending command\n");
+	if (!priv->cur_cmd)
 		goto out;
-	}
 
-	lbs_pr_info("Command %x timed out\n", le16_to_cpu(priv->cur_cmd->cmdbuf->command));
+	lbs_pr_info("command 0x%04x timed out\n",
+		le16_to_cpu(priv->cur_cmd->cmdbuf->command));
 
 	priv->cmd_timed_out = 1;
 	wake_up_interruptible(&priv->waitq);
