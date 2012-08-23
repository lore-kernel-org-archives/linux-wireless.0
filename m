Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:37402 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab2HWDdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 23:33:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.6] mwifiex: fix skb length issue when send a command to firmware
Date: Wed, 22 Aug 2012 20:26:31 -0700
Message-Id: <1345692391-8693-1-git-send-email-bzhao@marvell.com> (sfid-20120823_053355_052975_945597D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

When we send a command to firmware, we assumed that cmd_size
will be always less than or equal to the structure size of
host_cmd_ds_command. However, this is no longer true after
we added AP support. There are some AP commands that Custom
IE TLVs are included in command buffer, hence the cmd_size
gets enlarged by the TLV data. We need to increase the skb
length for the extra data.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index c229ddd..225c1a4 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -170,7 +170,20 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	cmd_code = le16_to_cpu(host_cmd->command);
 	cmd_size = le16_to_cpu(host_cmd->size);
 
-	skb_trim(cmd_node->cmd_skb, cmd_size);
+	/* Adjust skb length */
+	if (cmd_node->cmd_skb->len > cmd_size)
+		/*
+		 * cmd_size is less than sizeof(struct host_cmd_ds_command).
+		 * Trim off the unused portion.
+		 */
+		skb_trim(cmd_node->cmd_skb, cmd_size);
+	else if (cmd_node->cmd_skb->len < cmd_size)
+		/*
+		 * cmd_size is larger than sizeof(struct host_cmd_ds_command)
+		 * because we have appended custom IE TLV. Increase skb length
+		 * accordingly.
+		 */
+		skb_put(cmd_node->cmd_skb, cmd_size - cmd_node->cmd_skb->len);
 
 	do_gettimeofday(&tstamp);
 	dev_dbg(adapter->dev, "cmd: DNLD_CMD: (%lu.%lu): %#x, act %#x, len %d,"
-- 
1.7.0.2

