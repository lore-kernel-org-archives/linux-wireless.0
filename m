Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:37893 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751026Ab1IVEnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 00:43:20 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: reset skb length before inserting to free queue
Date: Wed, 21 Sep 2011 21:43:25 -0700
Message-Id: <1316666605-30954-4-git-send-email-bzhao@marvell.com> (sfid-20110922_064322_793969_41E6959E)
In-Reply-To: <1316666605-30954-1-git-send-email-bzhao@marvell.com>
References: <1316666605-30954-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

After handling command response, cmd skb is inserted into command
free queue(which keeps track of availabile skbs) for reuse purpose.
Skb length is not getting reset to zero here. This patch takes care
of it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index b5352af..d12e25d 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -90,6 +90,9 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 	cmd_node->data_buf = NULL;
 	cmd_node->wait_q_enabled = false;
 
+	if (cmd_node->cmd_skb)
+		skb_trim(cmd_node->cmd_skb, 0);
+
 	if (cmd_node->resp_skb) {
 		dev_kfree_skb_any(cmd_node->resp_skb);
 		cmd_node->resp_skb = NULL;
-- 
1.7.0.2

