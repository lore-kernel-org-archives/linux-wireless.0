Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbXLJRle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:41:34 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 13/48] libertas: don't cast a pointer to pointer of
Message-Id: <E1J1kpH-0006lA-OS@shinybook.infradead.org> (sfid-20071210_174137_085646_B490C44A)
Date: Mon, 10 Dec 2007 10:45:47 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Thu, 6 Dec 2007 13:01:21 +0100

Don't cast struct foo * to struct list_head *, it's safe only when
the list member is the first member of struct foo.

Also don't cast struct list_head * to struct foo *.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 7097dcf..851eb3c 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1021,11 +1021,10 @@ void lbs_queue_cmd(struct lbs_adapter *adapter,
 	spin_lock_irqsave(&adapter->driver_lock, flags);
 
 	if (addtail) {
-		list_add_tail((struct list_head *)cmdnode,
-			      &adapter->cmdpendingq);
+		list_add_tail(&cmdnode->list, &adapter->cmdpendingq);
 		adapter->nr_cmd_pending++;
 	} else
-		list_add((struct list_head *)cmdnode, &adapter->cmdpendingq);
+		list_add(&cmdnode->list, &adapter->cmdpendingq);
 
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
 
@@ -1144,7 +1143,7 @@ void __lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
 		return;
 
 	cleanup_cmdnode(ptempcmd);
-	list_add_tail((struct list_head *)ptempcmd, &adapter->cmdfreeq);
+	list_add_tail(&ptempcmd->list, &adapter->cmdfreeq);
 }
 
 static void lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
@@ -1642,8 +1641,9 @@ struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
 	spin_lock_irqsave(&adapter->driver_lock, flags);
 
 	if (!list_empty(&adapter->cmdfreeq)) {
-		tempnode = (struct cmd_ctrl_node *)adapter->cmdfreeq.next;
-		list_del((struct list_head *)tempnode);
+		tempnode = list_first_entry(&adapter->cmdfreeq,
+					    struct cmd_ctrl_node, list);
+		list_del(&tempnode->list);
 	} else {
 		lbs_deb_host("GET_CMD_NODE: cmd_ctrl_node is not available\n");
 		tempnode = NULL;
@@ -1738,8 +1738,8 @@ int lbs_execute_next_command(struct lbs_private *priv)
 	}
 
 	if (!list_empty(&adapter->cmdpendingq)) {
-		cmdnode = (struct cmd_ctrl_node *)
-		    adapter->cmdpendingq.next;
+		cmdnode = list_first_entry(&adapter->cmdpendingq,
+					   struct cmd_ctrl_node, list);
 	}
 
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
@@ -1803,7 +1803,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				    cpu_to_le16(CMD_SUBCMD_EXIT_PS)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore ENTER_PS cmd\n");
-					list_del((struct list_head *)cmdnode);
+					list_del(&cmdnode->list);
 					lbs_cleanup_and_insert_cmd(priv, cmdnode);
 
 					ret = 0;
@@ -1814,7 +1814,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				    (adapter->psstate == PS_STATE_PRE_SLEEP)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
-					list_del((struct list_head *)cmdnode);
+					list_del(&cmdnode->list);
 					lbs_cleanup_and_insert_cmd(priv, cmdnode);
 					adapter->needtowakeup = 1;
 
@@ -1826,7 +1826,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				       "EXEC_NEXT_CMD: sending EXIT_PS\n");
 			}
 		}
-		list_del((struct list_head *)cmdnode);
+		list_del(&cmdnode->list);
 		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
 			    le16_to_cpu(cmdptr->command));
 		DownloadcommandToStation(priv, cmdnode);
-- 
1.5.3.4

