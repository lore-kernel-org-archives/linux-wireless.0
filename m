Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2003 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbaGLDxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 23:53:40 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/7] mwifiex: fix corner case system hang issue
Date: Fri, 11 Jul 2014 20:53:14 -0700
Message-ID: <1405137194-13794-2-git-send-email-bzhao@marvell.com> (sfid-20140712_055404_154683_826B571F)
In-Reply-To: <1405137194-13794-1-git-send-email-bzhao@marvell.com>
References: <1405137194-13794-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Sometimes pending internal scan commands are delayed to give
preference to Tx traffic. 'scan_processing' flag has been
checked at the beginning of delay timer routine to know if in the
meantime scan operation has been cancelled.

There is a corner case where pending scan commands are emptied
after scan_processing flag check is passed. In this case
wrong pointer returned by list_first_entry() is passed to
list_del() which causes system hang.

This patch fixes the issue by adding list_empty() check.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 3e5194f..dfa37ea 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -33,6 +33,7 @@ static void scan_delay_timer_fn(unsigned long data)
 	struct mwifiex_private *priv = (struct mwifiex_private *)data;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmd_node, *tmp_node;
+	spinlock_t *scan_q_lock = &adapter->scan_pending_q_lock;
 	unsigned long flags;
 
 	if (adapter->surprise_removed)
@@ -44,13 +45,13 @@ static void scan_delay_timer_fn(unsigned long data)
 		 * Abort scan operation by cancelling all pending scan
 		 * commands
 		 */
-		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+		spin_lock_irqsave(scan_q_lock, flags);
 		list_for_each_entry_safe(cmd_node, tmp_node,
 					 &adapter->scan_pending_q, list) {
 			list_del(&cmd_node->list);
 			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		}
-		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+		spin_unlock_irqrestore(scan_q_lock, flags);
 
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = false;
@@ -79,12 +80,17 @@ static void scan_delay_timer_fn(unsigned long data)
 			 */
 			adapter->scan_delay_cnt = 0;
 			adapter->empty_tx_q_cnt = 0;
-			spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+			spin_lock_irqsave(scan_q_lock, flags);
+
+			if (list_empty(&adapter->scan_pending_q)) {
+				spin_unlock_irqrestore(scan_q_lock, flags);
+				goto done;
+			}
+
 			cmd_node = list_first_entry(&adapter->scan_pending_q,
 						    struct cmd_ctrl_node, list);
 			list_del(&cmd_node->list);
-			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-					       flags);
+			spin_unlock_irqrestore(scan_q_lock, flags);
 
 			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
 							true);
-- 
1.8.2.3

