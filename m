Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7883 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab3LCHSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 07/12] mwifiex: correct RX byte count statistics
Date: Mon, 2 Dec 2013 23:17:54 -0800
Message-ID: <1386055079-6623-8-git-send-email-bzhao@marvell.com> (sfid-20131203_081847_241841_5EB5F647)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ujjal Roy <royujjal@gmail.com>

The skb is modified in processing the RX packet. Save the original
packet length to a variable so that we can get the correct
statistics update.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 5d9e150..9b82e22 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -191,6 +191,9 @@ int mwifiex_recv_packet(struct mwifiex_private *priv, struct sk_buff *skb)
 	if (!skb)
 		return -1;
 
+	priv->stats.rx_bytes += skb->len;
+	priv->stats.rx_packets++;
+
 	skb->dev = priv->netdev;
 	skb->protocol = eth_type_trans(skb, priv->netdev);
 	skb->ip_summed = CHECKSUM_NONE;
@@ -217,8 +220,6 @@ int mwifiex_recv_packet(struct mwifiex_private *priv, struct sk_buff *skb)
 	    (skb->truesize > MWIFIEX_RX_DATA_BUF_SIZE))
 		skb->truesize += (skb->len - MWIFIEX_RX_DATA_BUF_SIZE);
 
-	priv->stats.rx_bytes += skb->len;
-	priv->stats.rx_packets++;
 	if (in_interrupt())
 		netif_rx(skb);
 	else
-- 
1.8.2.3

