Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63280 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbaB1Dfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 22:35:39 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@alum.mit.edu>,
	Avery Pennarun <apenwarr@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/9] mwifiex: abort scan while cancelling pending command
Date: Thu, 27 Feb 2014 19:35:15 -0800
Message-ID: <1393558517-887-1-git-send-email-bzhao@marvell.com> (sfid-20140228_043542_756921_01481988)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

mwifiex_cancel_pending_ioctl() and
mwifiex_cancel_all_pending_cmd() are called in command timeout
and driver unload paths respectively.
If scan operation is in progress, we should abort it smoothly.

Reported-by: Tim Shepard <shep@alum.mit.edu>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 38 ++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 64e708b..58cf3a9 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -966,7 +966,9 @@ void
 mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node;
-	unsigned long flags;
+	unsigned long flags, cmd_flags;
+	struct mwifiex_private *priv;
+	int i;
 
 	/* Cancel current cmd */
 	if ((adapter->curr_cmd) && (adapter->curr_cmd->wait_q_enabled)) {
@@ -1006,9 +1008,21 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 	}
 	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
 
-	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-	adapter->scan_processing = false;
-	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+	if (adapter->scan_processing) {
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
+		adapter->scan_processing = false;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+		for (i = 0; i < adapter->priv_num; i++) {
+			priv = adapter->priv[i];
+			if (!priv)
+				continue;
+			if (priv->scan_request) {
+				dev_dbg(adapter->dev, "info: aborting scan\n");
+				cfg80211_scan_done(priv->scan_request, 1);
+				priv->scan_request = NULL;
+			}
+		}
+	}
 }
 
 /*
@@ -1027,7 +1041,8 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
 	unsigned long cmd_flags;
 	unsigned long scan_pending_q_flags;
-	bool cancel_scan_cmd = false;
+	struct mwifiex_private *priv;
+	int i;
 
 	if ((adapter->curr_cmd) &&
 	    (adapter->curr_cmd->wait_q_enabled)) {
@@ -1053,15 +1068,24 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		spin_lock_irqsave(&adapter->scan_pending_q_lock,
 				  scan_pending_q_flags);
-		cancel_scan_cmd = true;
 	}
 	spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 			       scan_pending_q_flags);
 
-	if (cancel_scan_cmd) {
+	if (adapter->scan_processing) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+		for (i = 0; i < adapter->priv_num; i++) {
+			priv = adapter->priv[i];
+			if (!priv)
+				continue;
+			if (priv->scan_request) {
+				dev_dbg(adapter->dev, "info: aborting scan\n");
+				cfg80211_scan_done(priv->scan_request, 1);
+				priv->scan_request = NULL;
+			}
+		}
 	}
 	adapter->cmd_wait_q.status = -1;
 }
-- 
1.8.2.3

