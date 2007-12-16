Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761550AbXLPW6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:32 -0500
Subject: [PATCH 105/48] libertas: introduce and use lbs_complete_command() for command completion
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42Rz-00038G-Bi@shinybook.infradead.org> (sfid-20071216_225845_271160_60B85DBE)
Date: Sun, 16 Dec 2007 17:59:11 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 01:52:54 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   25 ++++++++++++++++++-------
 drivers/net/wireless/libertas/cmdresp.c |   10 +++-------
 drivers/net/wireless/libertas/decl.h    |    5 ++---
 3 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 4ffb84a..9c73902 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1230,9 +1230,7 @@ static int lbs_submit_command(struct lbs_private *priv,
 	if (ret) {
 		lbs_pr_info("DNLD_CMD: hw_host_to_card failed: %d\n", ret);
 		spin_lock_irqsave(&priv->driver_lock, flags);
-		priv->cur_cmd_retcode = ret;
-		__lbs_cleanup_and_insert_cmd(priv, priv->cur_cmd);
-		priv->cur_cmd = NULL;
+		lbs_complete_command(priv, priv->cur_cmd, ret);
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		goto done;
 	}
@@ -1275,8 +1273,8 @@ static int lbs_cmd_mac_control(struct lbs_private *priv,
  *  This function inserts command node to cmdfreeq
  *  after cleans it. Requires priv->driver_lock held.
  */
-void __lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
-	struct cmd_ctrl_node *ptempcmd)
+static void __lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
+					 struct cmd_ctrl_node *ptempcmd)
 {
 
 	if (!ptempcmd)
@@ -1296,6 +1294,15 @@ static void lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 }
 
+void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
+			  int result)
+{
+	if (cmd == priv->cur_cmd)
+		priv->cur_cmd_retcode = result;
+	__lbs_cleanup_and_insert_cmd(priv, cmd);
+	priv->cur_cmd = NULL;
+}
+
 int lbs_set_radio_control(struct lbs_private *priv)
 {
 	int ret = 0;
@@ -1901,7 +1908,9 @@ int lbs_execute_next_command(struct lbs_private *priv)
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore ENTER_PS cmd\n");
 					list_del(&cmdnode->list);
-					lbs_cleanup_and_insert_cmd(priv, cmdnode);
+					spin_lock_irqsave(&priv->driver_lock, flags);
+					lbs_complete_command(priv, cmdnode, 0);
+					spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 					ret = 0;
 					goto done;
@@ -1912,7 +1921,9 @@ int lbs_execute_next_command(struct lbs_private *priv)
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
 					list_del(&cmdnode->list);
-					lbs_cleanup_and_insert_cmd(priv, cmdnode);
+					spin_lock_irqsave(&priv->driver_lock, flags);
+					lbs_complete_command(priv, cmdnode, 0);
+					spin_unlock_irqrestore(&priv->driver_lock, flags);
 					priv->needtowakeup = 1;
 
 					ret = 0;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index a809f8f..89f8316 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -717,8 +717,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
 			lbs_deb_host("CMD_RESP: PS action 0x%X\n", action);
 		}
 
-		__lbs_cleanup_and_insert_cmd(priv, priv->cur_cmd);
-		priv->cur_cmd = NULL;
+		lbs_complete_command(priv, priv->cur_cmd, result);
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 		ret = 0;
@@ -739,9 +738,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
 			break;
 
 		}
-
-		__lbs_cleanup_and_insert_cmd(priv, priv->cur_cmd);
-		priv->cur_cmd = NULL;
+		lbs_complete_command(priv, priv->cur_cmd, result);
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 		ret = -1;
@@ -760,8 +757,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
 
 	if (priv->cur_cmd) {
 		/* Clean up and Put current command back to cmdfreeq */
-		__lbs_cleanup_and_insert_cmd(priv, priv->cur_cmd);
-		priv->cur_cmd = NULL;
+		lbs_complete_command(priv, priv->cur_cmd, result);
 	}
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 45f081b..5dd5c9e 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -45,9 +45,8 @@ void lbs_get_fwversion(struct lbs_private *priv,
 
 /** The proc fs interface */
 int lbs_process_rx_command(struct lbs_private *priv);
-void __lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
-	struct cmd_ctrl_node *ptempcmd);
-
+void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
+			  int result);
 int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band);
 
-- 
1.5.3.4

