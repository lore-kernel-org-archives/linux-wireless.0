Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:40073 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473Ab3GWCSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:42 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Huawei Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 01/21] mwifiex: remove stop_net_dev_queue operation in AP forwarding
Date: Mon, 22 Jul 2013 19:17:38 -0700
Message-ID: <1374545878-15683-2-git-send-email-bzhao@marvell.com> (sfid-20130723_041844_636714_6AC34D28)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Huawei Yang <harvey.huawei.yang@gmail.com>

Under uAP mode mwifiex may stop all net tx queues on forwarding
packets. This may stop some tx queues and they never have chance
to be waked up. There is also no need to check tx_pending and
stop queues here. Because local host has such kind of check when
transmitting packets and it's not proper to have forwarding affect
local transmitting.

Signed-off-by: Huawei Yang <harvey.huawei.yang@gmail.com>
Reviewed-by: Avinash Patil <patila@marvell.com>
Acked-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_txrx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index a018e42..11df2b2 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -95,10 +95,6 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	atomic_inc(&adapter->tx_pending);
 	atomic_inc(&adapter->pending_bridged_pkts);
 
-	if ((atomic_read(&adapter->tx_pending) >= MAX_TX_PENDING)) {
-		mwifiex_set_trans_start(priv->netdev);
-		mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
-	}
 	return;
 }
 
-- 
1.8.2.3

