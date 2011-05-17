Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51482 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1EQCNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 22:13:14 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/5] mwifiex: check mwifiex_wmm_lists_empty() before dequeue
Date: Mon, 16 May 2011 19:17:51 -0700
Message-Id: <1305598673-26606-4-git-send-email-bzhao@marvell.com> (sfid-20110517_041318_318958_78F3BE60)
In-Reply-To: <1305598673-26606-1-git-send-email-bzhao@marvell.com>
References: <1305598673-26606-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

add checks to mwifiex_wmm_process_tx() loop so it doesn't re-enter
mwifiex_dequeue_tx_packet() to find it can't send.

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index f3d5f23..784ad4c 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1254,5 +1254,5 @@ mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter)
 
 		if (mwifiex_dequeue_tx_packet(adapter))
 			break;
-	} while (true);
+	} while (!mwifiex_wmm_lists_empty(adapter));
 }
-- 
1.7.0.2

