Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:43310 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab1CUXlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 19:41:09 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: fix uninitialized command buffer
Date: Mon, 21 Mar 2011 16:44:39 -0700
Message-Id: <1300751079-20535-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300751079-20535-1-git-send-email-bzhao@marvell.com>
References: <1300751079-20535-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The command buffer being passed to mwifiex_sta_prepare_cmd()
is uninitialized and contains garbage data. As a result, some
commands don't work properly. For example, while creating an
adhoc network without security, the privacy bit in cap info
is sometimes unnecessarily enabled. In this case adhoc-joiner
creates new network with same SSID instead of joining the
existing one assuming that it is in secure mode.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index eab83fb..3a8fe1e 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -492,7 +492,8 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		return -1;
 	}
 
-	skb_put(cmd_node->cmd_skb, sizeof(struct host_cmd_ds_command));
+	memset(skb_put(cmd_node->cmd_skb, sizeof(struct host_cmd_ds_command)),
+	       0, sizeof(struct host_cmd_ds_command));
 
 	cmd_ptr = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	cmd_ptr->command = cpu_to_le16(cmd_no);
-- 
1.7.0.2

