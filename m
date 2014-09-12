Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46386 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbaILJKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 05:10:15 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 04/16] mwifiex: rework internal scan for association
Date: Fri, 12 Sep 2014 20:08:48 +0530
Message-ID: <1410532740-3173-5-git-send-email-patila@marvell.com> (sfid-20140912_111024_069740_EFAA69AD)
In-Reply-To: <1410532740-3173-1-git-send-email-patila@marvell.com>
References: <1410532740-3173-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was an issue with internal scan during association wherein
we would complete internal scan on first scan command response.
This would cause association failure if AP is not found in first scan
response e.g. APs from A band.
This patch fixes this issue by completing internal scan only when all
scan commands from scan pending queue and command pending queue are
sent to FW and response to last scan command is received.

Tested-by: Xinmin Hu <huxm@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index dee717a..bec48cc 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1970,9 +1970,34 @@ int mwifiex_cmd_802_11_scan_ext(struct mwifiex_private *priv,
 /* This function handles the command response of extended scan */
 int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_command *cmd_ptr;
+	struct cmd_ctrl_node *cmd_node;
+	unsigned long cmd_flags, scan_flags;
+	bool complete_scan = false;
+
 	dev_dbg(priv->adapter->dev, "info: EXT scan returns successfully\n");
 
-	mwifiex_complete_scan(priv);
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, cmd_flags);
+	spin_lock_irqsave(&adapter->scan_pending_q_lock, scan_flags);
+	if (list_empty(&adapter->scan_pending_q)) {
+		complete_scan = true;
+		list_for_each_entry(cmd_node, &adapter->cmd_pending_q, list) {
+			cmd_ptr = (void *)cmd_node->cmd_skb->data;
+			if (le16_to_cpu(cmd_ptr->command) ==
+			    HostCmd_CMD_802_11_SCAN_EXT) {
+				dev_dbg(priv->adapter->dev,
+					"Scan pending in command pending list");
+				complete_scan = false;
+				break;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, scan_flags);
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, cmd_flags);
+
+	if (complete_scan)
+		mwifiex_complete_scan(priv);
 
 	return 0;
 }
-- 
1.8.1.4

