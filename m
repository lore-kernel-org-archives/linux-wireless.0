Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57425 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbaBRXsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 18:48:04 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"Frank Huang" <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: use del_timer_sync instead of del_timer
Date: Tue, 18 Feb 2014 15:47:55 -0800
Message-ID: <1392767277-10941-1-git-send-email-bzhao@marvell.com> (sfid-20140219_004815_036889_E01A2097)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Use SMP safe del_timer_sync instead of del_timer for cancelling
timers.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 2 +-
 drivers/net/wireless/mwifiex/cmdevt.c        | 2 +-
 drivers/net/wireless/mwifiex/init.c          | 2 +-
 drivers/net/wireless/mwifiex/main.c          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index b361257..1cfdbfe 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -142,7 +142,7 @@ mwifiex_del_rx_reorder_entry(struct mwifiex_private *priv,
 	mwifiex_11n_dispatch_pkt(priv, tbl, (tbl->start_win + tbl->win_size) &
 					    (MAX_TID_VALUE - 1));
 
-	del_timer(&tbl->timer_context.timer);
+	del_timer_sync(&tbl->timer_context.timer);
 
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	list_del(&tbl->list);
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 2154460..f4faeaf 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -786,7 +786,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	unsigned long flags;
 
 	/* Now we got response from FW, cancel the command timer */
-	del_timer(&adapter->cmd_timer);
+	del_timer_sync(&adapter->cmd_timer);
 
 	if (!adapter->curr_cmd || !adapter->curr_cmd->resp_skb) {
 		resp = (struct host_cmd_ds_command *) adapter->upld_buf;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index a4cd2cb..7594928 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -620,7 +620,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 	/* cancel current command */
 	if (adapter->curr_cmd) {
 		dev_warn(adapter->dev, "curr_cmd is still in processing\n");
-		del_timer(&adapter->cmd_timer);
+		del_timer_sync(&adapter->cmd_timer);
 		mwifiex_recycle_cmd_node(adapter, adapter->curr_cmd);
 		adapter->curr_cmd = NULL;
 	}
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 4d79761..f87ce28 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -194,7 +194,7 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 	if (adapter->if_ops.cleanup_if)
 		adapter->if_ops.cleanup_if(adapter);
 
-	del_timer(&adapter->cmd_timer);
+	del_timer_sync(&adapter->cmd_timer);
 
 	/* Free private structures */
 	for (i = 0; i < adapter->priv_num; i++) {
-- 
1.8.2.3

