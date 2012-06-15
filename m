Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:36308 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758494Ab2FOXaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 19:30:20 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.5] mwifiex: fix uAP TX packet timeout issue
Date: Fri, 15 Jun 2012 16:21:53 -0700
Message-Id: <1339802513-22009-1-git-send-email-bzhao@marvell.com> (sfid-20120616_013025_944165_91ABBCFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

When running heavy traffic we stop the tx queue if the pending
packet count reaches certain threshold. Later, the tx queue should
be woken up as soon as the packet count falls below the threshold.

Current code wakes TX queue up on STA interface only. Removing the
check for STA interface will allow both STA and AP interfaces to
resume transmit when tx_pending count becomes low.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/txrx.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index e2faec4..cecb272 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -161,15 +161,11 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 		goto done;
 
 	for (i = 0; i < adapter->priv_num; i++) {
-
 		tpriv = adapter->priv[i];
 
-		if ((GET_BSS_ROLE(tpriv) == MWIFIEX_BSS_ROLE_STA) &&
-		    (tpriv->media_connected)) {
-			if (netif_queue_stopped(tpriv->netdev))
-				mwifiex_wake_up_net_dev_queue(tpriv->netdev,
-							      adapter);
-		}
+		if (tpriv->media_connected &&
+		    netif_queue_stopped(tpriv->netdev))
+			mwifiex_wake_up_net_dev_queue(tpriv->netdev, adapter);
 	}
 done:
 	dev_kfree_skb_any(skb);
-- 
1.7.0.2

