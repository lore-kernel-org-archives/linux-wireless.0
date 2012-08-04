Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog031.obsmtp.com ([74.125.150.105]:45158 "EHLO
	na6sys009bog031.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423Ab2HDBY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:24:28 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 06/16] mwifiex: improve scan delay logic during Tx traffic
Date: Fri,  3 Aug 2012 18:06:04 -0700
Message-Id: <1344042374-6892-7-git-send-email-bzhao@marvell.com> (sfid-20120804_032551_511089_FE44D138)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Earlier scan command was postponed by 20msec multiple times to give
preference to Tx traffic until we find empty wmm queue.

There is a corner case in which wmm queue becomes empty immediately
after processing the packet(before 20msec) and there may be next
packet coming after some time. In this case we should not resume scan
operation.

We will use new flag to check Tx traffic and resume scan operation
only if there is no traffic for 200msec.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |  103 ++++++++++++++++++++---------------
 drivers/net/wireless/mwifiex/main.c |    3 +
 drivers/net/wireless/mwifiex/main.h |    3 +
 3 files changed, 64 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 21fdc6c..81fc8ed 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -64,60 +64,72 @@ static void scan_delay_timer_fn(unsigned long data)
 	struct cmd_ctrl_node *cmd_node, *tmp_node;
 	unsigned long flags;
 
-	if (!mwifiex_wmm_lists_empty(adapter)) {
-		if (adapter->scan_delay_cnt == MWIFIEX_MAX_SCAN_DELAY_CNT) {
+	if (adapter->scan_delay_cnt == MWIFIEX_MAX_SCAN_DELAY_CNT) {
+		/*
+		 * Abort scan operation by cancelling all pending scan
+		 * commands
+		 */
+		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+		list_for_each_entry_safe(cmd_node, tmp_node,
+					 &adapter->scan_pending_q, list) {
+			list_del(&cmd_node->list);
+			cmd_node->wait_q_enabled = false;
+			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		}
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->scan_processing = false;
+		adapter->scan_delay_cnt = 0;
+		adapter->empty_tx_q_cnt = 0;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+
+		if (priv->user_scan_cfg) {
+			dev_dbg(priv->adapter->dev,
+				"info: %s: scan aborted\n", __func__);
+			cfg80211_scan_done(priv->scan_request, 1);
+			priv->scan_request = NULL;
+			kfree(priv->user_scan_cfg);
+			priv->user_scan_cfg = NULL;
+		}
+		goto done;
+	}
+
+	if (!atomic_read(&priv->adapter->is_tx_received)) {
+		adapter->empty_tx_q_cnt++;
+		if (adapter->empty_tx_q_cnt == MWIFIEX_MAX_EMPTY_TX_Q_CNT) {
 			/*
-			 * Abort scan operation by cancelling all pending scan
-			 * command
+			 * No Tx traffic for 200msec. Get scan command from
+			 * scan pending queue and put to cmd pending queue to
+			 * resume scan operation
 			 */
+			adapter->scan_delay_cnt = 0;
+			adapter->empty_tx_q_cnt = 0;
 			spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
-			list_for_each_entry_safe(cmd_node, tmp_node,
-						 &adapter->scan_pending_q,
-						 list) {
-				list_del(&cmd_node->list);
-				cmd_node->wait_q_enabled = false;
-				mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-			}
+			cmd_node = list_first_entry(&adapter->scan_pending_q,
+						    struct cmd_ctrl_node, list);
+			list_del(&cmd_node->list);
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
 
-			spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-			adapter->scan_processing = false;
-			spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
-					       flags);
-
-			if (priv->user_scan_cfg) {
-				dev_dbg(priv->adapter->dev,
-					"info: %s: scan aborted\n", __func__);
-				cfg80211_scan_done(priv->scan_request, 1);
-				priv->scan_request = NULL;
-				kfree(priv->user_scan_cfg);
-				priv->user_scan_cfg = NULL;
-			}
-		} else {
-			/*
-			 * Tx data queue is still not empty, delay scan
-			 * operation further by 20msec.
-			 */
-			mod_timer(&priv->scan_delay_timer, jiffies +
-				  msecs_to_jiffies(MWIFIEX_SCAN_DELAY_MSEC));
-			adapter->scan_delay_cnt++;
+			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
+							true);
+			goto done;
 		}
-		queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
 	} else {
-		/*
-		 * Tx data queue is empty. Get scan command from scan_pending_q
-		 * and put to cmd_pending_q to resume scan operation
-		 */
-		adapter->scan_delay_cnt = 0;
-		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
-		cmd_node = list_first_entry(&adapter->scan_pending_q,
-					    struct cmd_ctrl_node, list);
-		list_del(&cmd_node->list);
-		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
-
-		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
+		adapter->empty_tx_q_cnt = 0;
 	}
+
+	/* Delay scan operation further by 20msec */
+	mod_timer(&priv->scan_delay_timer, jiffies +
+		  msecs_to_jiffies(MWIFIEX_SCAN_DELAY_MSEC));
+	adapter->scan_delay_cnt++;
+
+done:
+	if (atomic_read(&priv->adapter->is_tx_received))
+		atomic_set(&priv->adapter->is_tx_received, false);
+
+	return;
 }
 
 /*
@@ -345,6 +357,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 	adapter->arp_filter_size = 0;
 	adapter->max_mgmt_ie_index = MAX_MGMT_IE_INDEX;
+	adapter->empty_tx_q_cnt = 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 4680362..cb11552 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -520,6 +520,9 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	mwifiex_wmm_add_buf_txqueue(priv, skb);
 	atomic_inc(&priv->adapter->tx_pending);
 
+	if (priv->adapter->scan_delay_cnt)
+		atomic_set(&priv->adapter->is_tx_received, true);
+
 	if (atomic_read(&priv->adapter->tx_pending) >= MAX_TX_PENDING) {
 		mwifiex_set_trans_start(dev);
 		mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e7c2a82..16f046a 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -88,6 +88,7 @@ enum {
 #define MWIFIEX_MAX_TOTAL_SCAN_TIME	(MWIFIEX_TIMER_10S - MWIFIEX_TIMER_1S)
 
 #define MWIFIEX_MAX_SCAN_DELAY_CNT			50
+#define MWIFIEX_MAX_EMPTY_TX_Q_CNT			10
 #define MWIFIEX_SCAN_DELAY_MSEC				20
 
 #define RSN_GTK_OUI_OFFSET				2
@@ -690,6 +691,8 @@ struct mwifiex_adapter {
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	u16 max_mgmt_ie_index;
 	u8 scan_delay_cnt;
+	u8 empty_tx_q_cnt;
+	atomic_t is_tx_received;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
-- 
1.7.0.2

