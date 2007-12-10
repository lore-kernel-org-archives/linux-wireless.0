Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXLJR3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:29:39 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 05/48] libertas: remove cmd_ctrl_node->cmdflags
Message-Id: <E1J1kp9-0006kW-CY@shinybook.infradead.org> (sfid-20071210_172947_621105_EED97C2A)
Date: Mon, 10 Dec 2007 10:45:39 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <h.schurig@mn-solutions.de>
Date: Wed, 5 Dec 2007 17:57:56 +0100

There was no code that ever did set this flag.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmdresp.c |    7 -------
 drivers/net/wireless/libertas/hostcmd.h |    1 -
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 90f1c49..cbd28ee 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -856,13 +856,6 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		goto done;
 	}
 
-	if (adapter->cur_cmd->cmdflags & CMD_F_HOSTCMD) {
-		/* Copy the response back to response buffer */
-		memcpy(adapter->cur_cmd->pdata_buf, resp,
-		       le16_to_cpu(resp->size));
-		adapter->cur_cmd->cmdflags &= ~CMD_F_HOSTCMD;
-	}
-
 	/* If the command is not successful, cleanup and return failure */
 	if ((result != 0 || !(respcmd & 0x8000))) {
 		lbs_deb_host("CMD_RESP: error 0x%04x in command reply 0x%04x\n",
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index c029149..217ae12 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -75,7 +75,6 @@ struct cmd_ctrl_node {
 	void *pdata_buf;
 	/*command data */
 	u8 *bufvirtualaddr;
-	u16 cmdflags;
 	/* wait queue */
 	u16 cmdwaitqwoken;
 	wait_queue_head_t cmdwait_q;
-- 
1.5.3.4

