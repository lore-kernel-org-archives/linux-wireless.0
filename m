Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30507 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbaILJKp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 05:10:45 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 14/16] mwifiex: remove low priority scan handling
Date: Fri, 12 Sep 2014 20:08:58 +0530
Message-ID: <1410532740-3173-15-git-send-email-patila@marvell.com> (sfid-20140912_111100_037783_56165F78)
In-Reply-To: <1410532740-3173-1-git-send-email-patila@marvell.com>
References: <1410532740-3173-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We have a logic in driver to delay or abort low priority scan
to serve Tx traffic effectively. With scan channel
gap support added, firmware now allows driver to send Tx data while
scan operation is in progress. Hence low priority scan handling
in driver is not required now. This patch removes related code.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  8 ---
 drivers/net/wireless/mwifiex/init.c     |  1 -
 drivers/net/wireless/mwifiex/main.c     | 96 +--------------------------------
 drivers/net/wireless/mwifiex/main.h     | 10 ----
 drivers/net/wireless/mwifiex/scan.c     | 59 ++++++++++----------
 5 files changed, 30 insertions(+), 144 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 50cc0db..1fd35be 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1935,13 +1935,6 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 
 	wiphy_dbg(wiphy, "info: received scan request on %s\n", dev->name);
 
-	if ((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
-	    atomic_read(&priv->wmm.tx_pkts_queued) >=
-	    MWIFIEX_MIN_TX_PENDING_TO_CANCEL_SCAN) {
-		dev_dbg(priv->adapter->dev, "scan rejected due to traffic\n");
-		return -EBUSY;
-	}
-
 	/* Block scan request if scan operation or scan cleanup when interface
 	 * is disabled is in process
 	 */
@@ -2919,7 +2912,6 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 
 	wiphy->features |= NL80211_FEATURE_HT_IBSS |
 			   NL80211_FEATURE_INACTIVITY_TIMER |
-			   NL80211_FEATURE_LOW_PRIORITY_SCAN |
 			   NL80211_FEATURE_NEED_OBSS_SCAN;
 
 	/* Reserve space for mwifiex specific private data for BSS */
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index d99c6f6..cd9baad 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -281,7 +281,6 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 	adapter->arp_filter_size = 0;
 	adapter->max_mgmt_ie_index = MAX_MGMT_IE_INDEX;
-	adapter->empty_tx_q_cnt = 0;
 	adapter->ext_scan = true;
 	adapter->key_api_major_ver = 0;
 	adapter->key_api_minor_ver = 0;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index d6d2342..f139386 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -28,91 +28,6 @@ const char driver_version[] = "mwifiex " VERSION " (%s) ";
 static char *cal_data_cfg;
 module_param(cal_data_cfg, charp, 0);
 
-static void scan_delay_timer_fn(unsigned long data)
-{
-	struct mwifiex_private *priv = (struct mwifiex_private *)data;
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *cmd_node, *tmp_node;
-	spinlock_t *scan_q_lock = &adapter->scan_pending_q_lock;
-	unsigned long flags;
-
-	if (adapter->surprise_removed)
-		return;
-
-	if (adapter->scan_delay_cnt == MWIFIEX_MAX_SCAN_DELAY_CNT ||
-	    !adapter->scan_processing) {
-		/*
-		 * Abort scan operation by cancelling all pending scan
-		 * commands
-		 */
-		spin_lock_irqsave(scan_q_lock, flags);
-		list_for_each_entry_safe(cmd_node, tmp_node,
-					 &adapter->scan_pending_q, list) {
-			list_del(&cmd_node->list);
-			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-		}
-		spin_unlock_irqrestore(scan_q_lock, flags);
-
-		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-		adapter->scan_processing = false;
-		adapter->scan_delay_cnt = 0;
-		adapter->empty_tx_q_cnt = 0;
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-
-		if (priv->scan_request) {
-			dev_dbg(adapter->dev, "info: aborting scan\n");
-			cfg80211_scan_done(priv->scan_request, 1);
-			priv->scan_request = NULL;
-		} else {
-			priv->scan_aborting = false;
-			dev_dbg(adapter->dev, "info: scan already aborted\n");
-		}
-		goto done;
-	}
-
-	if (!atomic_read(&priv->adapter->is_tx_received)) {
-		adapter->empty_tx_q_cnt++;
-		if (adapter->empty_tx_q_cnt == MWIFIEX_MAX_EMPTY_TX_Q_CNT) {
-			/*
-			 * No Tx traffic for 200msec. Get scan command from
-			 * scan pending queue and put to cmd pending queue to
-			 * resume scan operation
-			 */
-			adapter->scan_delay_cnt = 0;
-			adapter->empty_tx_q_cnt = 0;
-			spin_lock_irqsave(scan_q_lock, flags);
-
-			if (list_empty(&adapter->scan_pending_q)) {
-				spin_unlock_irqrestore(scan_q_lock, flags);
-				goto done;
-			}
-
-			cmd_node = list_first_entry(&adapter->scan_pending_q,
-						    struct cmd_ctrl_node, list);
-			list_del(&cmd_node->list);
-			spin_unlock_irqrestore(scan_q_lock, flags);
-
-			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
-							true);
-			queue_work(adapter->workqueue, &adapter->main_work);
-			goto done;
-		}
-	} else {
-		adapter->empty_tx_q_cnt = 0;
-	}
-
-	/* Delay scan operation further by 20msec */
-	mod_timer(&priv->scan_delay_timer, jiffies +
-		  msecs_to_jiffies(MWIFIEX_SCAN_DELAY_MSEC));
-	adapter->scan_delay_cnt++;
-
-done:
-	if (atomic_read(&priv->adapter->is_tx_received))
-		atomic_set(&priv->adapter->is_tx_received, false);
-
-	return;
-}
-
 /*
  * This function registers the device and performs all the necessary
  * initializations.
@@ -160,10 +75,6 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 
 		adapter->priv[i]->adapter = adapter;
 		adapter->priv_num++;
-
-		setup_timer(&adapter->priv[i]->scan_delay_timer,
-			    scan_delay_timer_fn,
-			    (unsigned long)adapter->priv[i]);
 	}
 	mwifiex_init_lock_list(adapter);
 
@@ -207,7 +118,6 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
 			mwifiex_free_curr_bcn(adapter->priv[i]);
-			del_timer_sync(&adapter->priv[i]->scan_delay_timer);
 			kfree(adapter->priv[i]);
 		}
 	}
@@ -285,7 +195,6 @@ process_start:
 				break;
 
 			if ((!adapter->scan_chan_gap_enabled &&
-			     !adapter->scan_delay_cnt &&
 			     adapter->scan_processing) || adapter->data_sent ||
 			    mwifiex_wmm_lists_empty(adapter)) {
 				if (adapter->cmd_sent || adapter->curr_cmd ||
@@ -341,7 +250,7 @@ process_start:
 		}
 
 		if ((adapter->scan_chan_gap_enabled ||
-		     (!adapter->scan_processing || adapter->scan_delay_cnt)) &&
+		     !adapter->scan_processing) &&
 		    !adapter->data_sent && !mwifiex_wmm_lists_empty(adapter)) {
 			mwifiex_wmm_process_tx(adapter);
 			if (adapter->hs_activated) {
@@ -600,9 +509,6 @@ int mwifiex_queue_tx_pkt(struct mwifiex_private *priv, struct sk_buff *skb)
 	atomic_inc(&priv->adapter->tx_pending);
 	mwifiex_wmm_add_buf_txqueue(priv, skb);
 
-	if (priv->adapter->scan_delay_cnt)
-		atomic_set(&priv->adapter->is_tx_received, true);
-
 	queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 651fd8c..e9cd4ab 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -90,12 +90,6 @@ enum {
 
 #define MWIFIEX_MAX_TOTAL_SCAN_TIME	(MWIFIEX_TIMER_10S - MWIFIEX_TIMER_1S)
 
-#define MWIFIEX_MAX_SCAN_DELAY_CNT			50
-#define MWIFIEX_MAX_EMPTY_TX_Q_CNT			10
-#define MWIFIEX_SCAN_DELAY_MSEC				20
-
-#define MWIFIEX_MIN_TX_PENDING_TO_CANCEL_SCAN		2
-
 #define RSN_GTK_OUI_OFFSET				2
 
 #define MWIFIEX_OUI_NOT_PRESENT			0
@@ -561,7 +555,6 @@ struct mwifiex_private {
 	u16 proberesp_idx;
 	u16 assocresp_idx;
 	u16 rsn_idx;
-	struct timer_list scan_delay_timer;
 	u8 ap_11n_enabled;
 	u8 ap_11ac_enabled;
 	u32 mgmt_frame_mask;
@@ -816,8 +809,6 @@ struct mwifiex_adapter {
 	spinlock_t queue_lock;		/* lock for tx queues */
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	u16 max_mgmt_ie_index;
-	u8 scan_delay_cnt;
-	u8 empty_tx_q_cnt;
 	const struct firmware *cal_data;
 	struct device_node *dt_node;
 
@@ -829,7 +820,6 @@ struct mwifiex_adapter {
 	u32 usr_dot_11ac_dev_cap_a;
 	u32 usr_dot_11ac_mcs_support;
 
-	atomic_t is_tx_received;
 	atomic_t pending_bridged_pkts;
 	struct semaphore *card_sem;
 	bool ext_scan;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 7b07da2..67f9cdb 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1765,7 +1765,7 @@ static void mwifiex_complete_scan(struct mwifiex_private *priv)
 static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *cmd_node;
+	struct cmd_ctrl_node *cmd_node, *tmp_node;
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
@@ -1786,37 +1786,36 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 			priv->scan_aborting = false;
 			dev_dbg(adapter->dev, "info: scan already aborted\n");
 		}
-	} else {
-		if ((priv->scan_aborting && !priv->scan_request) ||
-		    priv->scan_block) {
-			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-					       flags);
-			adapter->scan_delay_cnt = MWIFIEX_MAX_SCAN_DELAY_CNT;
-			mod_timer(&priv->scan_delay_timer, jiffies);
-			dev_dbg(priv->adapter->dev,
-				"info: %s: triggerring scan abort\n", __func__);
-		} else if (!mwifiex_wmm_lists_empty(adapter) &&
-			   (priv->scan_request && (priv->scan_request->flags &
-					    NL80211_SCAN_FLAG_LOW_PRIORITY))) {
-			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-					       flags);
-			adapter->scan_delay_cnt = 1;
-			mod_timer(&priv->scan_delay_timer, jiffies +
-				  msecs_to_jiffies(MWIFIEX_SCAN_DELAY_MSEC));
-			dev_dbg(priv->adapter->dev,
-				"info: %s: deferring scan\n", __func__);
-		} else {
-			/* Get scan command from scan_pending_q and put to
-			 * cmd_pending_q
-			 */
-			cmd_node = list_first_entry(&adapter->scan_pending_q,
-						    struct cmd_ctrl_node, list);
+	} else if ((priv->scan_aborting && !priv->scan_request) ||
+		   priv->scan_block) {
+		list_for_each_entry_safe(cmd_node, tmp_node,
+					 &adapter->scan_pending_q, list) {
 			list_del(&cmd_node->list);
-			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-					       flags);
-			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
-							true);
+			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		}
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->scan_processing = false;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+
+		if (priv->scan_request) {
+			dev_dbg(adapter->dev, "info: aborting scan\n");
+			cfg80211_scan_done(priv->scan_request, 1);
+			priv->scan_request = NULL;
+		} else {
+			priv->scan_aborting = false;
+			dev_dbg(adapter->dev, "info: scan already aborted\n");
 		}
+	} else {
+		/* Get scan command from scan_pending_q and put to
+		 * cmd_pending_q
+		 */
+		cmd_node = list_first_entry(&adapter->scan_pending_q,
+					    struct cmd_ctrl_node, list);
+		list_del(&cmd_node->list);
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
 	}
 
 	return;
-- 
1.8.1.4

