Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5937 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbXLEQ5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 11:57:37 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH 1/5] [LIBERTAS] Remove cmd_oid from struct cmd_ctrl_node
Date: Wed, 5 Dec 2007 17:57:54 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	David Woodhouse <dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712051757.54806.hs4233@mail.mn-solutions.de> (sfid-20071205_165740_280583_BAED1AB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 873ae059c3d82664a0198423da6f3efdceb6e7e3 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw2@infradead.org>
Date: Sat, 1 Dec 2007 15:15:41 +0000
Subject: [PATCH] [LIBERTAS] Remove cmd_oid from struct cmd_ctrl_node

This is only needed for SNMP and key operations; it doesn't need to be
preserved outside that context.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |    9 +++------
 drivers/net/wireless/libertas/decl.h    |    2 +-
 drivers/net/wireless/libertas/hostcmd.h |    2 --
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 8d22ec3..71c3833 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1209,7 +1209,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		goto done;
 	}
 
-	lbs_set_cmd_ctrl_node(priv, cmdnode, cmd_oid, wait_option, pdata_buf);
+	lbs_set_cmd_ctrl_node(priv, cmdnode, wait_option, pdata_buf);
 
 	cmdptr = (struct cmd_ds_command *)cmdnode->bufvirtualaddr;
 
@@ -1382,7 +1382,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 	case CMD_802_11_INACTIVITY_TIMEOUT:
 		ret = lbs_cmd_802_11_inactivity_timeout(priv, cmdptr,
 							 cmd_action, pdata_buf);
-		lbs_set_cmd_ctrl_node(priv, cmdnode, 0, 0, pdata_buf);
+		lbs_set_cmd_ctrl_node(priv, cmdnode, 0, pdata_buf);
 		break;
 
 	case CMD_802_11_TPC_CFG:
@@ -1643,7 +1643,6 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode)
 	ptempnode->cmdwaitqwoken = 1;
 	wake_up_interruptible(&ptempnode->cmdwait_q);
 	ptempnode->status = 0;
-	ptempnode->cmd_oid = (u32) 0;
 	ptempnode->wait_option = 0;
 	ptempnode->pdata_buf = NULL;
 
@@ -1658,21 +1657,19 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode)
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
index fd80d2f..66934f8 100644
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

