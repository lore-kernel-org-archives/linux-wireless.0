Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760407AbXLPW6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:24 -0500
Subject: [PATCH 101/48] libertas: kill unused wait_option field in struct cmd_ctrl_node
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42Rq-00037w-SM@shinybook.infradead.org> (sfid-20071216_225829_151119_6AEB06C9)
Date: Sun, 16 Dec 2007 17:59:02 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Fri, 14 Dec 2007 23:08:13 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   12 ++++--------
 drivers/net/wireless/libertas/hostcmd.h |    2 --
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index ffef721..5ceb331 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -17,7 +17,7 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode);
 static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
 static void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 		    struct cmd_ctrl_node *ptempnode,
-		    u16 wait_option, void *pdata_buf);
+		    void *pdata_buf);
 
 
 /**
@@ -1392,7 +1392,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		goto done;
 	}
 
-	lbs_set_cmd_ctrl_node(priv, cmdnode, wait_option, pdata_buf);
+	lbs_set_cmd_ctrl_node(priv, cmdnode, pdata_buf);
 
 	cmdptr = (struct cmd_ds_command *)cmdnode->cmdbuf;
 
@@ -1554,7 +1554,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 	case CMD_802_11_INACTIVITY_TIMEOUT:
 		ret = lbs_cmd_802_11_inactivity_timeout(priv, cmdptr,
 							 cmd_action, pdata_buf);
-		lbs_set_cmd_ctrl_node(priv, cmdnode, 0, pdata_buf);
+		lbs_set_cmd_ctrl_node(priv, cmdnode, pdata_buf);
 		break;
 
 	case CMD_802_11_TPC_CFG:
@@ -1800,7 +1800,6 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *cmdnode)
 		return;
 	cmdnode->cmdwaitqwoken = 1;
 	wake_up_interruptible(&cmdnode->cmdwait_q);
-	cmdnode->wait_option = 0;
 	cmdnode->pdata_buf = NULL;
 	cmdnode->callback = NULL;
 	cmdnode->callback_arg = 0;
@@ -1816,20 +1815,18 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *cmdnode)
  *
  *  @param priv		A pointer to struct lbs_private structure
  *  @param ptempnode	A pointer to cmd_ctrl_node structure
- *  @param wait_option	wait option: wait response or not
  *  @param pdata_buf	A pointer to informaion buffer
  *  @return 		0 or -1
  */
 static void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 				  struct cmd_ctrl_node *ptempnode,
-				  u16 wait_option, void *pdata_buf)
+				  void *pdata_buf)
 {
 	lbs_deb_enter(LBS_DEB_HOST);
 
 	if (!ptempnode)
 		return;
 
-	ptempnode->wait_option = wait_option;
 	ptempnode->pdata_buf = pdata_buf;
 	ptempnode->callback = NULL;
 	ptempnode->callback_arg = 0;
@@ -2213,7 +2210,6 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 		goto done;
 	}
 
-	cmdnode->wait_option = CMD_OPTION_WAITFORRSP;
 	cmdnode->callback = callback;
 	cmdnode->callback_arg = callback_arg;
 
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index aa4cea0..1b31250 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -74,8 +74,6 @@ struct cmd_header {
 
 struct cmd_ctrl_node {
 	struct list_head list;
-	/* wait for finish or not */
-	u16 wait_option;
 	/* command response */
 	void *pdata_buf;
 	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *);
-- 
1.5.3.4

