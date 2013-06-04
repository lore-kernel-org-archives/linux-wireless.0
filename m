Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:59665 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652Ab3FDXVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 19:21:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix regression issue for usb interface
Date: Tue, 4 Jun 2013 16:19:56 -0700
Message-ID: <1370387996-32406-1-git-send-email-bzhao@marvell.com> (sfid-20130605_012205_133983_A35E98E4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

PATCH "mwifiex: scan delay timer cleanup in unload path" adds code
to cancel scan delay timer in unload path. It causes a regression
for USB interface.

USB8797 card gets enumerated twice. First enumeration is for
firmware download and second enumeration expects firmware
initialization.

It was observed that we are trying del_timer_sync() without setting
up the timer when remove handler is called after first enumeration.

This patch moves setup_timer() call to appropriate place so that
timer is setup for both the enumerations.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 81 ------------------------------------
 drivers/net/wireless/mwifiex/main.c | 82 +++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index c7f11c0..2fe31dc 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -52,84 +52,6 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 	return 0;
 }
 
-static void scan_delay_timer_fn(unsigned long data)
-{
-	struct mwifiex_private *priv = (struct mwifiex_private *)data;
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *cmd_node, *tmp_node;
-	unsigned long flags;
-
-	if (adapter->surprise_removed)
-		return;
-
-	if (adapter->scan_delay_cnt == MWIFIEX_MAX_SCAN_DELAY_CNT) {
-		/*
-		 * Abort scan operation by cancelling all pending scan
-		 * commands
-		 */
-		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
-		list_for_each_entry_safe(cmd_node, tmp_node,
-					 &adapter->scan_pending_q, list) {
-			list_del(&cmd_node->list);
-			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-		}
-		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
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
-			spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
-			cmd_node = list_first_entry(&adapter->scan_pending_q,
-						    struct cmd_ctrl_node, list);
-			list_del(&cmd_node->list);
-			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-					       flags);
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
  * This function initializes the private structure and sets default
  * values to the members.
@@ -211,9 +133,6 @@ int mwifiex_init_priv(struct mwifiex_private *priv)
 
 	priv->scan_block = false;
 
-	setup_timer(&priv->scan_delay_timer, scan_delay_timer_fn,
-		    (unsigned long)priv);
-
 	return mwifiex_add_bss_prio_tbl(priv);
 }
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 5bc7ef8..4858719 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -28,6 +28,84 @@ const char driver_version[] = "mwifiex " VERSION " (%s) ";
 static char *cal_data_cfg;
 module_param(cal_data_cfg, charp, 0);
 
+static void scan_delay_timer_fn(unsigned long data)
+{
+	struct mwifiex_private *priv = (struct mwifiex_private *)data;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct cmd_ctrl_node *cmd_node, *tmp_node;
+	unsigned long flags;
+
+	if (adapter->surprise_removed)
+		return;
+
+	if (adapter->scan_delay_cnt == MWIFIEX_MAX_SCAN_DELAY_CNT) {
+		/*
+		 * Abort scan operation by cancelling all pending scan
+		 * commands
+		 */
+		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+		list_for_each_entry_safe(cmd_node, tmp_node,
+					 &adapter->scan_pending_q, list) {
+			list_del(&cmd_node->list);
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
+		if (priv->scan_request) {
+			dev_dbg(adapter->dev, "info: aborting scan\n");
+			cfg80211_scan_done(priv->scan_request, 1);
+			priv->scan_request = NULL;
+		} else {
+			priv->scan_aborting = false;
+			dev_dbg(adapter->dev, "info: scan already aborted\n");
+		}
+		goto done;
+	}
+
+	if (!atomic_read(&priv->adapter->is_tx_received)) {
+		adapter->empty_tx_q_cnt++;
+		if (adapter->empty_tx_q_cnt == MWIFIEX_MAX_EMPTY_TX_Q_CNT) {
+			/*
+			 * No Tx traffic for 200msec. Get scan command from
+			 * scan pending queue and put to cmd pending queue to
+			 * resume scan operation
+			 */
+			adapter->scan_delay_cnt = 0;
+			adapter->empty_tx_q_cnt = 0;
+			spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+			cmd_node = list_first_entry(&adapter->scan_pending_q,
+						    struct cmd_ctrl_node, list);
+			list_del(&cmd_node->list);
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
+
+			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
+							true);
+			queue_work(adapter->workqueue, &adapter->main_work);
+			goto done;
+		}
+	} else {
+		adapter->empty_tx_q_cnt = 0;
+	}
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
+}
+
 /*
  * This function registers the device and performs all the necessary
  * initializations.
@@ -75,6 +153,10 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 
 		adapter->priv[i]->adapter = adapter;
 		adapter->priv_num++;
+
+		setup_timer(&adapter->priv[i]->scan_delay_timer,
+			    scan_delay_timer_fn,
+			    (unsigned long)adapter->priv[i]);
 	}
 	mwifiex_init_lock_list(adapter);
 
-- 
1.8.2.3

