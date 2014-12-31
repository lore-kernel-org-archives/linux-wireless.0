Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33552 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbaLaKij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:38:39 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 6/9] mwifiex: do not release lock during list_for_each_entry_safe()
Date: Wed, 31 Dec 2014 02:36:43 -0800
Message-ID: <1420022206-11435-7-git-send-email-akarwar@marvell.com> (sfid-20141231_113845_903447_81ADB2D9)
In-Reply-To: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
References: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As we are releasing the lock, during next iteration we may end
up getting page fault if other thread has already deleted that
node.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 8559720..946a2f7 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1008,11 +1008,9 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 	list_for_each_entry_safe(cmd_node, tmp_node,
 				 &adapter->scan_pending_q, list) {
 		list_del(&cmd_node->list);
-		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
 
 		cmd_node->wait_q_enabled = false;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	}
 	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
 
@@ -1070,12 +1068,8 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 	list_for_each_entry_safe(cmd_node, tmp_node,
 				 &adapter->scan_pending_q, list) {
 		list_del(&cmd_node->list);
-		spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-				       scan_pending_q_flags);
 		cmd_node->wait_q_enabled = false;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-		spin_lock_irqsave(&adapter->scan_pending_q_lock,
-				  scan_pending_q_flags);
 	}
 	spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 			       scan_pending_q_flags);
-- 
1.8.1.4

