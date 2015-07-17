Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33028 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915AbbGQHNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 03:13:40 -0400
Received: by widic2 with SMTP id ic2so32151929wid.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2015 00:13:39 -0700 (PDT)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 1/4] mwifiex: remove explicit mwifiex_complete_cmd calls
Date: Fri, 17 Jul 2015 09:13:03 +0200
Message-Id: <1437117186-25243-2-git-send-email-afenkart@gmail.com> (sfid-20150717_091342_979025_9647A8FE)
In-Reply-To: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
References: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

standard call chain when releasing a cmd node:
mwifiex_recycle_cmd_node
-> mwifiex_insert_cmd_to_free_q
-> mwifiex_complete_cmd, if wait_q_enabled

calling mwifiex_complete_cmd explicitly and setting
wait_q_enabled = false is redundant

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 207da40..2f4715e 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -167,8 +167,6 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		mwifiex_dbg(adapter, ERROR,
 			    "DNLD_CMD: FW in reset state, ignore cmd %#x\n",
 			cmd_code);
-		if (cmd_node->wait_q_enabled)
-			mwifiex_complete_cmd(adapter, cmd_node);
 		mwifiex_recycle_cmd_node(adapter, cmd_node);
 		queue_work(adapter->workqueue, &adapter->main_work);
 		return -1;
@@ -1024,6 +1022,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		adapter->curr_cmd->wait_q_enabled = false;
 		adapter->cmd_wait_q.status = -1;
 		mwifiex_complete_cmd(adapter, adapter->curr_cmd);
+		/* no recycle probably wait for response */
 	}
 	/* Cancel all pending command */
 	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
@@ -1032,11 +1031,8 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		list_del(&cmd_node->list);
 		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 
-		if (cmd_node->wait_q_enabled) {
+		if (cmd_node->wait_q_enabled)
 			adapter->cmd_wait_q.status = -1;
-			mwifiex_complete_cmd(adapter, cmd_node);
-			cmd_node->wait_q_enabled = false;
-		}
 		mwifiex_recycle_cmd_node(adapter, cmd_node);
 		spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
 	}
@@ -1094,10 +1090,8 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 	    (adapter->curr_cmd->wait_q_enabled)) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 		cmd_node = adapter->curr_cmd;
-		cmd_node->wait_q_enabled = false;
 		cmd_node->cmd_flag |= CMD_F_CANCELED;
 		mwifiex_recycle_cmd_node(adapter, cmd_node);
-		mwifiex_complete_cmd(adapter, adapter->curr_cmd);
 		adapter->curr_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
-- 
2.1.4

