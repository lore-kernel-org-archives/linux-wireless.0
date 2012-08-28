Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:42160 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436Ab2H1DfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 23:35:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: don't disable wait_q_enabled flag
Date: Mon, 27 Aug 2012 20:32:52 -0700
Message-Id: <1346124774-17701-2-git-send-email-bzhao@marvell.com> (sfid-20120828_054601_668291_FD3F08EF)
In-Reply-To: <1346124774-17701-1-git-send-email-bzhao@marvell.com>
References: <1346124774-17701-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We should not disable "cmd_node->wait_q_enabled" flag here before
calling mwifiex_insert_cmd_to_free_q() because we want to wake up
the thread waiting for command completion inside this function.

The wait_q_enabled flag will be disabled internally upon command
completion.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index c510563..9c1549e 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -73,7 +73,6 @@ static void scan_delay_timer_fn(unsigned long data)
 		list_for_each_entry_safe(cmd_node, tmp_node,
 					 &adapter->scan_pending_q, list) {
 			list_del(&cmd_node->list);
-			cmd_node->wait_q_enabled = false;
 			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		}
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
-- 
1.7.0.2

