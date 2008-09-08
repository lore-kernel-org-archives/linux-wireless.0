Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbYIHUdv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 16:33:51 -0400
Subject: [RFC PATCH] libertas_tf: clear current command on remove
From: Dan Williams <dcbw@redhat.com>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 08 Sep 2008 16:34:42 -0400
Message-Id: <1220906082.1618.22.camel@localhost.localdomain> (sfid-20080908_223355_015142_DB10C3A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ensure that the current command is torn down when cleaning up.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---

Completely untested but based on the libertas patch for the same
problem.  Luis, can you give it a shot and make sure there aren't any
regressions when pulling the card or rmmod-ing the driver?

diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index c948021..5f7bf04 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -296,8 +296,8 @@ static void lbtf_op_stop(struct ieee80211_hw *hw)
 	struct lbtf_private *priv = hw->priv;
 	unsigned long flags;
 	struct sk_buff *skb;
-
 	struct cmd_ctrl_node *cmdnode;
+
 	/* Flush pending command nodes */
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	list_for_each_entry(cmdnode, &priv->cmdpendingq, list) {
@@ -306,7 +306,14 @@ static void lbtf_op_stop(struct ieee80211_hw *hw)
 		wake_up_interruptible(&cmdnode->cmdwait_q);
 	}
 
+	/* Flush the command the card is currently processing */
+	if (priv->cur_cmd) {
+		priv->cur_cmd->result = -ENOENT;
+		priv->cur_cmd->cmdwaitqwoken = 1;
+		wake_up_interruptible(&priv->cur_cmd->cmdwait_q);
+	}
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
+
 	cancel_work_sync(&priv->cmd_work);
 	cancel_work_sync(&priv->tx_work);
 	while ((skb = skb_dequeue(&priv->bc_ps_buf)))


