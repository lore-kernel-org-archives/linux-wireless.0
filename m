Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:33210 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357Ab1EIKFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 06:05:05 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Cc: dcbw@redhat.com
Cc: pgf@laptop.org
Subject: [PATCH] libertas: fix cmdpendingq locking
Message-Id: <20110509094042.39C2E9D401C@zog.reactivated.net> (sfid-20110509_120515_867677_41DA5278)
Date: Mon,  9 May 2011 10:40:42 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Paul Fox <pgf@laptop.org>

We occasionally see list corruption using libertas.

While we haven't been able to diagnose this precisely, we have spotted
a possible cause: cmdpendingq is generally modified with driver_lock
held. However, there are a couple of points where this is not the case.

Fix up those operations to execute under the lock, it seems like
the correct thing to do and will hopefully improve the situation.

Signed-off-by: Paul Fox <pgf@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/cmd.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 7e8a658..f3ac624 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1339,8 +1339,8 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				    cpu_to_le16(PS_MODE_ACTION_EXIT_PS)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore ENTER_PS cmd\n");
-					list_del(&cmdnode->list);
 					spin_lock_irqsave(&priv->driver_lock, flags);
+					list_del(&cmdnode->list);
 					lbs_complete_command(priv, cmdnode, 0);
 					spin_unlock_irqrestore(&priv->driver_lock, flags);
 
@@ -1352,8 +1352,8 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				    (priv->psstate == PS_STATE_PRE_SLEEP)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
-					list_del(&cmdnode->list);
 					spin_lock_irqsave(&priv->driver_lock, flags);
+					list_del(&cmdnode->list);
 					lbs_complete_command(priv, cmdnode, 0);
 					spin_unlock_irqrestore(&priv->driver_lock, flags);
 					priv->needtowakeup = 1;
@@ -1366,7 +1366,9 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				       "EXEC_NEXT_CMD: sending EXIT_PS\n");
 			}
 		}
+		spin_lock_irqsave(&priv->driver_lock, flags);
 		list_del(&cmdnode->list);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
 			    le16_to_cpu(cmd->command));
 		lbs_submit_command(priv, cmdnode);
-- 
1.7.4.4

