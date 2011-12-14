Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:59183 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754134Ab1LNEnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 23:43:49 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.2] mwifiex: avoid double list_del in command cancel path
Date: Tue, 13 Dec 2011 20:43:16 -0800
Message-Id: <1323837797-32547-1-git-send-email-bzhao@marvell.com> (sfid-20111214_054353_597856_B8651E12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Command cancel path cancels the current command and moves
it to free command queue. While doing that it deletes the
command entry from the pending list. This is not correct
as the entry has been already deleted from the pending
list at 'mwifiex_exec_next_cmd'. Fixing it.

Also making sure the stale command pointer is cleaned and
unaccessible for later use.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index ac27815..6e0a3ea 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -939,7 +939,6 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
 	unsigned long cmd_flags;
-	unsigned long cmd_pending_q_flags;
 	unsigned long scan_pending_q_flags;
 	uint16_t cancel_scan_cmd = false;
 
@@ -949,12 +948,9 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 		cmd_node = adapter->curr_cmd;
 		cmd_node->wait_q_enabled = false;
 		cmd_node->cmd_flag |= CMD_F_CANCELED;
-		spin_lock_irqsave(&adapter->cmd_pending_q_lock,
-				  cmd_pending_q_flags);
-		list_del(&cmd_node->list);
-		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
-				       cmd_pending_q_flags);
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		mwifiex_complete_cmd(adapter, adapter->curr_cmd);
+		adapter->curr_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
 
@@ -981,7 +977,6 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
 	adapter->cmd_wait_q.status = -1;
-	mwifiex_complete_cmd(adapter, adapter->curr_cmd);
 }
 
 /*
-- 
1.7.0.2

