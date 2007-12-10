Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55263 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbXLJPpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:49 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 16/48] libertas: Remove SET_BOOT2_VER support from the Big Switch Statement.
Message-Id: <E1J1kpK-0006lP-Sn@shinybook.infradead.org> (sfid-20071210_154552_639959_BE1BD930)
Date: Mon, 10 Dec 2007 10:45:50 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Thu, 6 Dec 2007 14:44:21 +0000

And the death of libertas_prepare_and_send_command() starts...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 851eb3c..b1ea878 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -974,17 +974,6 @@ static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
 	return 0;
 }
 
-static int lbs_cmd_set_boot2_ver(struct lbs_private *priv,
-				struct cmd_ds_command *cmd,
-				u16 cmd_action, void *pdata_buf)
-{
-	struct cmd_ds_set_boot2_ver *boot2_ver = &cmd->params.boot2_ver;
-	cmd->command = cpu_to_le16(CMD_SET_BOOT2_VER);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_set_boot2_ver) + S_DS_GEN);
-	boot2_ver->version = priv->boot2_version;
-	return 0;
-}
-
 /*
  * Note: NEVER use lbs_queue_cmd() with addtail==0 other than for
  * the command timer, because it does not account for queued commands.
@@ -1470,10 +1459,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_mesh_access(priv, cmdptr, cmd_action, pdata_buf);
 		break;
 
-	case CMD_SET_BOOT2_VER:
-		ret = lbs_cmd_set_boot2_ver(priv, cmdptr, cmd_action, pdata_buf);
-		break;
-
 	case CMD_GET_TSF:
 		cmdptr->command = cpu_to_le16(CMD_GET_TSF);
 		cmdptr->size = cpu_to_le16(sizeof(struct cmd_ds_get_tsf) +
-- 
1.5.3.4

