Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50907 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761565AbXLPW6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:38 -0500
Subject: [PATCH 108/48] libertas: let __lbs_cmd() free its own cmdnode
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42S5-00038V-LS@shinybook.infradead.org> (sfid-20071216_232057_677461_CC335605)
Date: Sun, 16 Dec 2007 17:59:17 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 02:06:16 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 4c0bd9f..e7f07c3 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1310,7 +1310,8 @@ void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
 	cmd->cmdwaitqwoken = 1;
 	wake_up_interruptible(&cmd->cmdwait_q);
 
-	__lbs_cleanup_and_insert_cmd(priv, cmd);
+	if (!cmd->callback)
+		__lbs_cleanup_and_insert_cmd(priv, cmd);
 	priv->cur_cmd = NULL;
 }
 
@@ -2219,6 +2220,7 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 		priv->cur_cmd_retcode = 0;
 		ret = -1;
 	}
+	__lbs_cleanup_and_insert_cmd(priv, cmdnode);
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 done:
-- 
1.5.3.4

