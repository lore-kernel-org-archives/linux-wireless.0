Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762748AbXLMG7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:51 -0500
Subject: [PATCH 84/48] libertas: be more careful about command responses matching cur_cmd
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i37-0005tm-Kg@shinybook.infradead.org> (sfid-20071213_070640_981164_E1EEC467)
Date: Thu, 13 Dec 2007 02:00:01 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 23:42:49 -0500

Especially in the light of OLPC trac #5461, in which the firmware starts
sending us seemingly random command responses which bear little relation
to the command we sent it.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |    4 +-
 drivers/net/wireless/libertas/cmdresp.c |   36 +++++++++++++++++++------------
 drivers/net/wireless/libertas/if_usb.c  |    1 +
 drivers/net/wireless/libertas/main.c    |    2 +-
 4 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 1cb42dc..5ddb46a 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1216,8 +1216,8 @@ static int DownloadcommandToStation(struct lbs_private *priv,
 	cmdsize = le16_to_cpu(cmd->size);
 	command = le16_to_cpu(cmd->command);
 
-	lbs_deb_host("DNLD_CMD: command 0x%04x, size %d, jiffies %lu\n",
-		    command, cmdsize, jiffies);
+	lbs_deb_host("DNLD_CMD: command 0x%04x, seq %d, size %d, jiffies %lu\n",
+		     command, le16_to_cpu(cmd->seqnum), cmdsize, jiffies);
 	lbs_deb_hex(LBS_DEB_HOST, "DNLD_CMD", (void *) cmdnode->cmdbuf, cmdsize);
 
 	cmdnode->cmdwaitqwoken = 0;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index bf9941e..53f73c4 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -611,7 +611,7 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 
 	default:
 		lbs_deb_host("CMD_RESP: unknown cmd response 0x%04x\n",
-			    resp->command);
+			     le16_to_cpu(resp->command));
 		break;
 	}
 	lbs_deb_leave(LBS_DEB_HOST);
@@ -620,17 +620,14 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 
 int lbs_process_rx_command(struct lbs_private *priv)
 {
-	u16 respcmd;
+	uint16_t respcmd, curcmd;
 	struct cmd_header *resp;
 	int ret = 0;
-	ulong flags;
-	u16 result;
+	unsigned long flags;
+	uint16_t result;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
-	/* Now we got response from FW, cancel the command timer */
-	del_timer(&priv->command_timer);
-
 	mutex_lock(&priv->lock);
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
@@ -640,24 +637,35 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		goto done;
 	}
+
+	curcmd = le16_to_cpu(priv->cur_cmd->cmdbuf->command);
+
 	resp = priv->cur_cmd->cmdbuf;
 
 	respcmd = le16_to_cpu(resp->command);
 	result = le16_to_cpu(resp->result);
 
-	lbs_deb_host("CMD_RESP: response 0x%04x, size %d, jiffies %lu\n",
-		respcmd, priv->upld_len, jiffies);
+	lbs_deb_host("CMD_RESP: response 0x%04x, seq %d, size %d, jiffies %lu\n",
+		     respcmd, le16_to_cpu(resp->seqnum), priv->upld_len, jiffies);
 	lbs_deb_hex(LBS_DEB_HOST, "CMD_RESP", (void *) resp, priv->upld_len);
 
-	if (!(respcmd & 0x8000)) {
-		lbs_deb_host("invalid response!\n");
-		priv->cur_cmd_retcode = -1;
-		__lbs_cleanup_and_insert_cmd(priv, priv->cur_cmd);
-		priv->cur_cmd = NULL;
+	if (resp->seqnum != priv->cur_cmd->cmdbuf->seqnum) {
+		lbs_pr_info("Received CMD_RESP with invalid sequence %d (expected %d)\n",
+			    le16_to_cpu(resp->seqnum), le16_to_cpu(priv->cur_cmd->cmdbuf->seqnum));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		ret = -1;
 		goto done;
 	}
+	if (respcmd != CMD_RET(curcmd) &&
+	    respcmd != CMD_802_11_ASSOCIATE && curcmd != CMD_RET_802_11_ASSOCIATE) {
+		lbs_pr_info("Invalid CMD_RESP %x to command %x!\n", respcmd, curcmd);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
+		ret = -1;
+		goto done;
+	}
+
+	/* Now we got response from FW, cancel the command timer */
+	del_timer(&priv->command_timer);
 
 	/* Store the response code to cur_cmd_retcode. */
 	priv->cur_cmd_retcode = result;
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 02192e8..6b8ac62 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -643,6 +643,7 @@ static inline void process_cmdrequest(int recvlength, u8 *recvbuff,
 	/* take care of cur_cmd = NULL case by reading the
 	 * data to clear the interrupt */
 	if (!priv->cur_cmd) {
+		lbs_deb_hex(LBS_DEB_HOST, "Unsolicited CMD_RESP", (void *) recvbuff + MESSAGE_HEADER_LEN, priv->upld_len);
 		cmdbuf = priv->upld_buf;
 		priv->hisregcpy &= ~MRVDRV_CMD_UPLD_RDY;
 	} else
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index bb685ac..cdf5934 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -893,7 +893,7 @@ static void command_timer_fn(unsigned long data)
 		return;
 	}
 
-	lbs_deb_fw("command_timer_fn fired, cmd %x\n", node->cmdbuf->command);
+	lbs_pr_info("command %x timed out\n", le16_to_cpu(node->cmdbuf->command));
 
 	if (!priv->fw_ready)
 		return;
-- 
1.5.3.4

