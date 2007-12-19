Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40755 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbXLSQJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:09:50 -0500
Subject: [PATCH 125/48] libertas: make lbs_submit_command always 'succeed' and set command timer
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50v4-00021G-3M@pmac.infradead.org> (sfid-20071219_160953_269702_4F7C5D91)
Date: Wed, 19 Dec 2007 15:33:14 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 16:03:58 -0500

Even if it fails, we want to wait a while and try again, with an
ultimate timeout if it the condition persists. So again, just use the
standard command timeout behaviour.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |   42 ++++++++++++++++------------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 10c60ba..0ae9851 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1199,14 +1199,15 @@ done:
 	lbs_deb_leave(LBS_DEB_HOST);
 }
 
-static int lbs_submit_command(struct lbs_private *priv,
-			      struct cmd_ctrl_node *cmdnode)
+static void lbs_submit_command(struct lbs_private *priv,
+			       struct cmd_ctrl_node *cmdnode)
 {
 	unsigned long flags;
 	struct cmd_header *cmd;
-	int ret = -1;
-	u16 cmdsize;
-	u16 command;
+	uint16_t cmdsize;
+	uint16_t command;
+	int timeo = 5 * HZ;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
@@ -1220,33 +1221,30 @@ static int lbs_submit_command(struct lbs_private *priv,
 	cmdsize = le16_to_cpu(cmd->size);
 	command = le16_to_cpu(cmd->command);
 
+	/* These commands take longer */
+	if (command == CMD_802_11_SCAN || command == CMD_802_11_ASSOCIATE ||
+	    command == CMD_802_11_AUTHENTICATE)
+		timeo = 10 * HZ;
+
 	lbs_deb_host("DNLD_CMD: command 0x%04x, seq %d, size %d, jiffies %lu\n",
 		     command, le16_to_cpu(cmd->seqnum), cmdsize, jiffies);
 	lbs_deb_hex(LBS_DEB_HOST, "DNLD_CMD", (void *) cmdnode->cmdbuf, cmdsize);
 
 	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmd, cmdsize);
+
 	if (ret) {
 		lbs_pr_info("DNLD_CMD: hw_host_to_card failed: %d\n", ret);
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		lbs_complete_command(priv, priv->cur_cmd, ret);
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		goto done;
-	}
-
-	lbs_deb_cmd("DNLD_CMD: sent command 0x%04x, jiffies %lu\n", command, jiffies);
+		/* Let the timer kick in and retry, and potentially reset
+		   the whole thing if the condition persists */
+		timeo = HZ;
+	} else
+		lbs_deb_cmd("DNLD_CMD: sent command 0x%04x, jiffies %lu\n",
+			    command, jiffies);
 
 	/* Setup the timer after transmit command */
-	if (command == CMD_802_11_SCAN || command == CMD_802_11_AUTHENTICATE
-	    || command == CMD_802_11_ASSOCIATE)
-		mod_timer(&priv->command_timer, jiffies + (10*HZ));
-	else
-		mod_timer(&priv->command_timer, jiffies + (5*HZ));
-
-	ret = 0;
+	mod_timer(&priv->command_timer, jiffies + timeo);
 
-done:
-	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
-	return ret;
+	lbs_deb_leave(LBS_DEB_HOST);
 }
 
 static int lbs_cmd_mac_control(struct lbs_private *priv,
-- 
1.5.3.4

