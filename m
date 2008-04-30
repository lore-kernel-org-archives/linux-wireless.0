Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20916 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbYD3Orb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:47:31 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: reduce command retry time
Date: Wed, 30 Apr 2008 16:44:29 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804301644.29927.hs4233@mail.mn-solutions.de> (sfid-20080430_164726_081603_91840AF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the normal case, an unsuccessful command would be tried for
10*5 seconds, or 10*10 seconds in the worst case. This patch
reduces this to 3*1 seconds, or 3*5 seconds in the worst case.

Also changed the needless del_timer_sync(&priv->command_timer);
to del_timer().

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

The story behind this patch is the following: let the driver
load, and let the hardware have a failure, e.g. because of a
bad power supply to the device. Now try "pccardctl eject".
It looks like this is now hanging, nothing happens. Only
when all the retries are done does the "pccardctrl eject"
do what it is supposed to do, that might have been in 50 or 100
seconds.

As I didn't have seen a case where it makes sense to retry a
faulty command 10 times I changed this number.

Also, I've never seen a command (except scan/assoc) to take more
than a few milliseconds. So giving them 5 seconds seemed excessive.


Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-04-30 15:10:14.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-04-30 15:18:08.000000000 +0200
@@ -1144,7 +1144,7 @@ static void lbs_submit_command(struct lb
 	struct cmd_header *cmd;
 	uint16_t cmdsize;
 	uint16_t command;
-	int timeo = 5 * HZ;
+	int timeo = HZ;
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
+		timeo = HZ/2;
 	}
 
 	/* Setup the timer after transmit command */
Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-04-30 15:10:13.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-04-30 15:16:27.000000000 +0200
@@ -749,15 +749,18 @@ static int lbs_thread(void *data)
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
-				lbs_pr_info("requeueing command %x due to timeout (#%d)\n",
-					    le16_to_cpu(cmdnode->cmdbuf->command), priv->nr_retries);
+				lbs_pr_info("requeueing command 0x%04x due "
+					"to timeout (#%d)\n",
+					le16_to_cpu(cmdnode->cmdbuf->command),
+					priv->nr_retries);
 
 				/* Stick it back at the _top_ of the pending queue
 				   for immediate resubmission */
@@ -958,12 +961,11 @@ static void command_timer_fn(unsigned lo
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
@@ -1278,7 +1280,7 @@ void lbs_stop_card(struct lbs_private *p
 		device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
 
 	/* Flush pending command nodes */
-	del_timer_sync(&priv->command_timer);
+	del_timer(&priv->command_timer);
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	list_for_each_entry(cmdnode, &priv->cmdpendingq, list) {
 		cmdnode->result = -ENOENT;
