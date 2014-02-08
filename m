Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45456 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbaBHAXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:23:55 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 07/30] mwifiex: separate out next scan command queueing logic
Date: Fri, 7 Feb 2014 16:23:36 -0800
Message-ID: <1391819017-20995-3-git-send-email-bzhao@marvell.com> (sfid-20140208_012358_306915_2F2436EA)
In-Reply-To: <1391819017-20995-1-git-send-email-bzhao@marvell.com>
References: <1391819017-20995-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This new function will be useful later for extended scan
feature.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c | 133 +++++++++++++++++++-----------------
 1 file changed, 71 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 28f0a38..3633347 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1726,6 +1726,76 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 	return 0;
 }
 
+static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct cmd_ctrl_node *cmd_node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+	if (list_empty(&adapter->scan_pending_q)) {
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->scan_processing = false;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+
+		/* Need to indicate IOCTL complete */
+		if (adapter->curr_cmd->wait_q_enabled) {
+			adapter->cmd_wait_q.status = 0;
+			if (!priv->scan_request) {
+				dev_dbg(adapter->dev,
+					"complete internal scan\n");
+				mwifiex_complete_cmd(adapter,
+						     adapter->curr_cmd);
+			}
+		}
+		if (priv->report_scan_result)
+			priv->report_scan_result = false;
+
+		if (priv->scan_request) {
+			dev_dbg(adapter->dev, "info: notifying scan done\n");
+			cfg80211_scan_done(priv->scan_request, 0);
+			priv->scan_request = NULL;
+		} else {
+			priv->scan_aborting = false;
+			dev_dbg(adapter->dev, "info: scan already aborted\n");
+		}
+	} else {
+		if ((priv->scan_aborting && !priv->scan_request) ||
+		    priv->scan_block) {
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
+			adapter->scan_delay_cnt = MWIFIEX_MAX_SCAN_DELAY_CNT;
+			mod_timer(&priv->scan_delay_timer, jiffies);
+			dev_dbg(priv->adapter->dev,
+				"info: %s: triggerring scan abort\n", __func__);
+		} else if (!mwifiex_wmm_lists_empty(adapter) &&
+			   (priv->scan_request && (priv->scan_request->flags &
+					    NL80211_SCAN_FLAG_LOW_PRIORITY))) {
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
+			adapter->scan_delay_cnt = 1;
+			mod_timer(&priv->scan_delay_timer, jiffies +
+				  msecs_to_jiffies(MWIFIEX_SCAN_DELAY_MSEC));
+			dev_dbg(priv->adapter->dev,
+				"info: %s: deferring scan\n", __func__);
+		} else {
+			/* Get scan command from scan_pending_q and put to
+			 * cmd_pending_q
+			 */
+			cmd_node = list_first_entry(&adapter->scan_pending_q,
+						    struct cmd_ctrl_node, list);
+			list_del(&cmd_node->list);
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
+			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
+							true);
+		}
+	}
+
+	return;
+}
+
 /*
  * This function handles the command response of scan.
  *
@@ -1750,7 +1820,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *cmd_node;
 	struct host_cmd_ds_802_11_scan_rsp *scan_rsp;
 	struct mwifiex_ie_types_data *tlv_data;
 	struct mwifiex_ie_types_tsf_timestamp *tsf_tlv;
@@ -1762,7 +1831,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_chan_band_list_param_set *chan_band_tlv;
 	struct chan_band_param_set *chan_band;
 	u8 is_bgscan_resp;
-	unsigned long flags;
 	__le64 fw_tsf = 0;
 	u8 *radio_type;
 
@@ -1852,66 +1920,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	}
 
 check_next_scan:
-	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
-	if (list_empty(&adapter->scan_pending_q)) {
-		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
-		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-		adapter->scan_processing = false;
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-
-		/* Need to indicate IOCTL complete */
-		if (adapter->curr_cmd->wait_q_enabled) {
-			adapter->cmd_wait_q.status = 0;
-			if (!priv->scan_request) {
-				dev_dbg(adapter->dev,
-					"complete internal scan\n");
-				mwifiex_complete_cmd(adapter,
-						     adapter->curr_cmd);
-			}
-		}
-		if (priv->report_scan_result)
-			priv->report_scan_result = false;
-
-		if (priv->scan_request) {
-			dev_dbg(adapter->dev, "info: notifying scan done\n");
-			cfg80211_scan_done(priv->scan_request, 0);
-			priv->scan_request = NULL;
-		} else {
-			priv->scan_aborting = false;
-			dev_dbg(adapter->dev, "info: scan already aborted\n");
-		}
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
-			   cmd_pending_q */
-			cmd_node = list_first_entry(&adapter->scan_pending_q,
-						    struct cmd_ctrl_node, list);
-			list_del(&cmd_node->list);
-			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-					       flags);
-			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
-							true);
-		}
-	}
-
+	mwifiex_check_next_scan_command(priv);
 	return ret;
 }
 
-- 
1.8.2.3

