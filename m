Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:45397 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab1DFXmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 19:42:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: fix cmd_skb headroom decreasing issue
Date: Wed,  6 Apr 2011 16:46:55 -0700
Message-Id: <1302133616-6595-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before calling host_to_card() to send the cmd to firmware,
we use skb_push() to add 4 bytes SDIO interface header at
the start of the data buffer. Since cmd_skb data structure
will be re-used at a later time, we need to restore its
headroom by removing the 4 bytes header.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index a9aeb31..8676480 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -206,6 +206,8 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 					     cmd_node->cmd_skb->data,
 					     cmd_node->cmd_skb->len, NULL);
 
+	skb_pull(cmd_node->cmd_skb, INTF_HEADER_LEN);
+
 	if (ret == -1) {
 		dev_err(adapter->dev, "DNLD_CMD: host to card failed\n");
 		if (wait_queue)
-- 
1.7.0.2

