Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:36945 "HELO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750999Ab2FGEOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 00:14:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: fix simultaneous scan and Tx traffic problem
Date: Wed,  6 Jun 2012 21:12:41 -0700
Message-Id: <1339042362-30317-3-git-send-email-bzhao@marvell.com> (sfid-20120607_061440_073996_D9433A9F)
In-Reply-To: <1339042362-30317-1-git-send-email-bzhao@marvell.com>
References: <1339042362-30317-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

If scan operation is started when Tx traffic is already running,
driver locks Tx queue until it gets completed. With this logic
there is a delay for Tx packets.

This patch implements new approach to give Tx path higher priority
in this case. Driver internally sends multiple synchronous scan
commands to firmware when scan is requested by user. Now we will
make sure that Tx queue is empty everytime before sending next scan
command. If Tx queue isn't empty scan command will be postponsed by
20msec. This rule will be followed until Tx queue becomes empty or
timeout of 1 second happens. In case of timeout scan operation will
be aborted.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |   65 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.c |    4 +-
 drivers/net/wireless/mwifiex/main.h |    5 +++
 drivers/net/wireless/mwifiex/scan.c |   25 +++++++++----
 4 files changed, 89 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index c1cb004..0f18ef6 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -57,6 +57,68 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 	return 0;
 }
 
+static void scan_delay_timer_fn(unsigned long data)
+{
+	struct mwifiex_private *priv = (struct mwifiex_private *)data;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct cmd_ctrl_node *cmd_node, *tmp_node;
+	unsigned long flags;
+
+	if (!mwifiex_wmm_lists_empty(adapter)) {
+		if (adapter->scan_delay_cnt == MWIFIEX_MAX_SCAN_DELAY_CNT) {
+			/*
+			 * Abort scan operation by cancelling all pending scan
+			 * command
+			 */
+			spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+			list_for_each_entry_safe(cmd_node, tmp_node,
+						 &adapter->scan_pending_q,
+						 list) {
+				list_del(&cmd_node->list);
+				cmd_node->wait_q_enabled = false;
+				mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+			}
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
+
+			spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+			adapter->scan_processing = false;
+			spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
+					       flags);
+
+			if (priv->user_scan_cfg) {
+				dev_dbg(priv->adapter->dev,
+					"info: %s: scan aborted\n", __func__);
+				cfg80211_scan_done(priv->scan_request, 1);
+				priv->scan_request = NULL;
+				kfree(priv->user_scan_cfg);
+				priv->user_scan_cfg = NULL;
+			}
+		} else {
+			/*
+			 * Tx data queue is still not empty, delay scan
+			 * operation further by 20msec.
+			 */
+			mod_timer(&priv->scan_delay_timer, jiffies +
+				  msecs_to_jiffies(MWIFIEX_SCAN_DELAY_MSEC));
+			adapter->scan_delay_cnt++;
+		}
+	} else {
+		/*
+		 * Tx data queue is empty. Get scan command from scan_pending_q
+		 * and put to cmd_pending_q to resume scan operation
+		 */
+		adapter->scan_delay_cnt = 0;
+		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+		cmd_node = list_first_entry(&adapter->scan_pending_q,
+					    struct cmd_ctrl_node, list);
+		list_del(&cmd_node->list);
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+
+		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
+	}
+}
+
 /*
  * This function initializes the private structure and sets default
  * values to the members.
@@ -136,6 +198,9 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 
 	priv->scan_block = false;
 
+	setup_timer(&priv->scan_delay_timer, scan_delay_timer_fn,
+		    (unsigned long)priv);
+
 	return mwifiex_add_bss_prio_tbl(priv);
 }
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 3192855..0f06f07 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -244,8 +244,8 @@ process_start:
 			}
 		}
 
-		if (!adapter->scan_processing && !adapter->data_sent &&
-		    !mwifiex_wmm_lists_empty(adapter)) {
+		if ((!adapter->scan_processing || adapter->scan_delay_cnt) &&
+		    !adapter->data_sent && !mwifiex_wmm_lists_empty(adapter)) {
 			mwifiex_wmm_process_tx(adapter);
 			if (adapter->hs_activated) {
 				adapter->is_hs_configured = false;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index cbad00d..5b32221 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -87,6 +87,9 @@ enum {
 
 #define MWIFIEX_MAX_TOTAL_SCAN_TIME	(MWIFIEX_TIMER_10S - MWIFIEX_TIMER_1S)
 
+#define MWIFIEX_MAX_SCAN_DELAY_CNT			50
+#define MWIFIEX_SCAN_DELAY_MSEC				20
+
 #define RSN_GTK_OUI_OFFSET				2
 
 #define MWIFIEX_OUI_NOT_PRESENT			0
@@ -482,6 +485,7 @@ struct mwifiex_private {
 	u16 proberesp_idx;
 	u16 assocresp_idx;
 	u16 rsn_idx;
+	struct timer_list scan_delay_timer;
 };
 
 enum mwifiex_ba_status {
@@ -686,6 +690,7 @@ struct mwifiex_adapter {
 	struct completion fw_load;
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	u16 max_mgmt_ie_index;
+	u8 scan_delay_cnt;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 74f0457..ea2f1bd 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1772,14 +1772,23 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			priv->user_scan_cfg = NULL;
 		}
 	} else {
-		/* Get scan command from scan_pending_q and put to
-		   cmd_pending_q */
-		cmd_node = list_first_entry(&adapter->scan_pending_q,
-					    struct cmd_ctrl_node, list);
-		list_del(&cmd_node->list);
-		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
-
-		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
+		if (!mwifiex_wmm_lists_empty(adapter)) {
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
+			adapter->scan_delay_cnt = 1;
+			mod_timer(&priv->scan_delay_timer, jiffies +
+				  msecs_to_jiffies(MWIFIEX_SCAN_DELAY_MSEC));
+		} else {
+			/* Get scan command from scan_pending_q and put to
+			   cmd_pending_q */
+			cmd_node = list_first_entry(&adapter->scan_pending_q,
+						    struct cmd_ctrl_node, list);
+			list_del(&cmd_node->list);
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
+			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
+							true);
+		}
 	}
 
 done:
-- 
1.7.0.2

