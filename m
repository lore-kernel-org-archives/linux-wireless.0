Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61554 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756619AbaCUCu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 22:50:29 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] mwifiex: scan command preparation failure handling
Date: Thu, 20 Mar 2014 19:50:06 -0700
Message-ID: <1395370206-16732-1-git-send-email-bzhao@marvell.com> (sfid-20140321_035033_797496_53C4F133)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When scan request is received, scan commands are prepared and
queued into scan pending queue. There is a corner case when
command nodes are full. So we stop queueing further scan
commands and return an error. This patch makes sure that
currently queued commands in scan pending queue are also freed
in this case.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: coding style fix: remove an extra blank line

 drivers/net/wireless/mwifiex/scan.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index f139244..71d3739 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -591,10 +591,12 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			  *chan_tlv_out,
 			  struct mwifiex_chan_scan_param_set *scan_chan_list)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct mwifiex_chan_scan_param_set *tmp_chan_list;
 	struct mwifiex_chan_scan_param_set *start_chan;
-
+	struct cmd_ctrl_node *cmd_node, *tmp_node;
+	unsigned long flags;
 	u32 tlv_idx, rates_size, cmd_no;
 	u32 total_scan_time;
 	u32 done_early;
@@ -748,8 +750,19 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 		scan_cfg_out->tlv_buf_len -=
 			    sizeof(struct mwifiex_ie_types_header) + rates_size;
 
-		if (ret)
+		if (ret) {
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
 			break;
+		}
 	}
 
 	if (ret)
-- 
1.8.2.3

