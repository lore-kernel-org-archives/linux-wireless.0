Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55241 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbXLJPpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:34 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 02/48] libertas: Remove cmd_oid from struct cmd_ctrl_node
Message-Id: <E1J1kp6-0006kH-6w@shinybook.infradead.org> (sfid-20071210_154540_079769_44639A1B)
Date: Mon, 10 Dec 2007 10:45:36 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 1 Dec 2007 15:15:41 +0000

This is only needed for SNMP and key operations; it doesn't need to be
preserved outside that context.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |    9 +++------
 drivers/net/wireless/libertas/decl.h    |    2 +-
 drivers/net/wireless/libertas/hostcmd.h |    2 --
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index d98bec9..6658590 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1231,7 +1231,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		goto done;
 	}
 
-	lbs_set_cmd_ctrl_node(priv, cmdnode, cmd_oid, wait_option, pdata_buf);
+	lbs_set_cmd_ctrl_node(priv, cmdnode, wait_option, pdata_buf);
 
 	cmdptr = (struct cmd_ds_command *)cmdnode->bufvirtualaddr;
 
@@ -1404,7 +1404,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 	case CMD_802_11_INACTIVITY_TIMEOUT:
 		ret = lbs_cmd_802_11_inactivity_timeout(priv, cmdptr,
 							 cmd_action, pdata_buf);
-		lbs_set_cmd_ctrl_node(priv, cmdnode, 0, 0, pdata_buf);
+		lbs_set_cmd_ctrl_node(priv, cmdnode, 0, pdata_buf);
 		break;
 
 	case CMD_802_11_TPC_CFG:
@@ -1668,7 +1668,6 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode)
 	ptempnode->cmdwaitqwoken = 1;
 	wake_up_interruptible(&ptempnode->cmdwait_q);
 	ptempnode->status = 0;
-	ptempnode->cmd_oid = (u32) 0;
 	ptempnode->wait_option = 0;
 	ptempnode->pdata_buf = NULL;
 
@@ -1683,21 +1682,19 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode)
  *
  *  @param priv		A pointer to struct lbs_private structure
  *  @param ptempnode	A pointer to cmd_ctrl_node structure
- *  @param cmd_oid	cmd oid: treated as sub command
  *  @param wait_option	wait option: wait response or not
  *  @param pdata_buf	A pointer to informaion buffer
  *  @return 		0 or -1
  */
 void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 		    struct cmd_ctrl_node *ptempnode,
-		    u32 cmd_oid, u16 wait_option, void *pdata_buf)
+		    u16 wait_option, void *pdata_buf)
 {
 	lbs_deb_enter(LBS_DEB_HOST);
 
 	if (!ptempnode)
 		return;
 
-	ptempnode->cmd_oid = cmd_oid;
 	ptempnode->wait_option = wait_option;
 	ptempnode->pdata_buf = pdata_buf;
 
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 74187f3..447297a 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -26,7 +26,7 @@ struct cmd_ctrl_node *lbs_get_free_cmd_ctrl_node(struct lbs_private *priv);
 
 void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 	struct cmd_ctrl_node *ptempnode,
-	u32 cmd_oid, u16 wait_option, void *pdata_buf);
+	u16 wait_option, void *pdata_buf);
 
 int lbs_prepare_and_send_command(struct lbs_private *priv,
 	u16 cmd_no,
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 614db6c..c029149 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -69,8 +69,6 @@ struct cmd_ctrl_node {
 	/* CMD link list */
 	struct list_head list;
 	u32 status;
-	/* CMD ID */
-	u32 cmd_oid;
 	/*CMD wait option: wait for finish or no wait */
 	u16 wait_option;
 	/* command parameter */
-- 
1.5.3.4

