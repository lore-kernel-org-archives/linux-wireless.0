Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:39221 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237Ab1EZUbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 16:31:13 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: Set command sequence number later to ensure consistency
Message-Id: <20110526203108.ADEDB9D401C@zog.reactivated.net> (sfid-20110526_223116_203647_BE68C6A7)
Date: Thu, 26 May 2011 21:31:08 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before this patch, the command sequence number is being set before
lbs_queue_cmd() adds the command to the queue. However, lbs_queue_cmd()
sometimes forces commands to queue-jump (e.g. CMD_802_11_WAKEUP_CONFIRM).
It currently does this without considering that sequence numbers might need
adjusting to keep things running in order.

Fix this by setting the sequence number at a later stage, just before
we're actually submitting the command to the hardware. Also fixes a
possible race where seqnum was being modified outside of the driver
lock.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/cmd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 84566db..71c8f3f 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -994,6 +994,8 @@ static void lbs_submit_command(struct lbs_private *priv,
 	cmd = cmdnode->cmdbuf;
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
+	priv->seqnum++;
+	cmd->seqnum = cpu_to_le16(priv->seqnum);
 	priv->cur_cmd = cmdnode;
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
@@ -1621,11 +1623,9 @@ struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
 	/* Copy the incoming command to the buffer */
 	memcpy(cmdnode->cmdbuf, in_cmd, in_cmd_size);
 
-	/* Set sequence number, clean result, move to buffer */
-	priv->seqnum++;
+	/* Set command, clean result, move to buffer */
 	cmdnode->cmdbuf->command = cpu_to_le16(command);
 	cmdnode->cmdbuf->size    = cpu_to_le16(in_cmd_size);
-	cmdnode->cmdbuf->seqnum  = cpu_to_le16(priv->seqnum);
 	cmdnode->cmdbuf->result  = 0;
 
 	lbs_deb_host("PREP_CMD: command 0x%04x\n", command);
-- 
1.7.5.1

