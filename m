Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32787 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbcDGVjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 17:39:18 -0400
Received: by mail-wm0-f66.google.com with SMTP id y144so7589408wmd.0
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2016 14:39:17 -0700 (PDT)
From: Vishal Thanki <vishalthanki@gmail.com>
To: akarwar@marvell.com, nishants@marvell.com, afenkart@gmail.com,
	linux-wireless@vger.kernel.org
Cc: Vishal Thanki <vishalthanki@gmail.com>
Subject: [PATCH] mwifiex: fix the incorrect WARN_ON during suspend
Date: Thu,  7 Apr 2016 23:37:12 +0200
Message-Id: <1460065032-23043-1-git-send-email-vishalthanki@gmail.com> (sfid-20160407_233922_913427_B774D150)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During system suspend, there is a kernel WARNING issued if there
is a pending command present. By marking the wait queue disabled
after calling the command completion routine fixes it.

Signed-off-by: Vishal Thanki <vishalthanki@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index a12adee..6f047064 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1009,9 +1009,9 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 	/* Cancel current cmd */
 	if ((adapter->curr_cmd) && (adapter->curr_cmd->wait_q_enabled)) {
-		adapter->curr_cmd->wait_q_enabled = false;
 		adapter->cmd_wait_q.status = -1;
 		mwifiex_complete_cmd(adapter, adapter->curr_cmd);
+		adapter->curr_cmd->wait_q_enabled = false;
 		/* no recycle probably wait for response */
 	}
 	/* Cancel all pending command */
-- 
2.4.11

