Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbXLJRPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:15:00 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 07/48] libertas: make more functions static
Message-Id: <E1J1kpB-0006kg-FH@shinybook.infradead.org> (sfid-20071210_171507_337448_F6FAEBC6)
Date: Mon, 10 Dec 2007 10:45:41 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <h.schurig@mn-solutions.de>
Date: Wed, 5 Dec 2007 17:58:06 +0100

These functions were used in the old debugfs code for events, but
as this code is now gone, there's no need to export those functions.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c  |    9 +++++++--
 drivers/net/wireless/libertas/decl.h |    7 +------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 43dde7e..54ef990 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -13,6 +13,11 @@
 #include "wext.h"
 
 static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode);
+struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
+void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
+		    struct cmd_ctrl_node *ptempnode,
+		    u16 wait_option, void *pdata_buf);
+
 
 static u16 commands_allowed_in_ps[] = {
 	CMD_802_11_RSSI,
@@ -1220,7 +1225,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		goto done;
 	}
 
-	cmdnode = lbs_get_free_cmd_ctrl_node(priv);
+	cmdnode = lbs_get_cmd_ctrl_node(priv);
 
 	if (cmdnode == NULL) {
 		lbs_deb_host("PREP_CMD: cmdnode is NULL\n");
@@ -1623,7 +1628,7 @@ done:
  *  @param priv		A pointer to struct lbs_private structure
  *  @return cmd_ctrl_node A pointer to cmd_ctrl_node structure or NULL
  */
-struct cmd_ctrl_node *lbs_get_free_cmd_ctrl_node(struct lbs_private *priv)
+struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
 {
 	struct cmd_ctrl_node *tempnode;
 	struct lbs_adapter *adapter = priv->adapter;
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 201ec60..0856cc9 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -15,18 +15,13 @@ struct lbs_private;
 struct lbs_adapter;
 struct sk_buff;
 struct net_device;
+struct cmd_ctrl_node;
 
 int lbs_set_mac_packet_filter(struct lbs_private *priv);
 
 void lbs_send_tx_feedback(struct lbs_private *priv);
 
 int lbs_free_cmd_buffer(struct lbs_private *priv);
-struct cmd_ctrl_node;
-struct cmd_ctrl_node *lbs_get_free_cmd_ctrl_node(struct lbs_private *priv);
-
-void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
-	struct cmd_ctrl_node *ptempnode,
-	u16 wait_option, void *pdata_buf);
 
 int lbs_prepare_and_send_command(struct lbs_private *priv,
 	u16 cmd_no,
-- 
1.5.3.4

