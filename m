Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:53419 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab3CEA3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 19:29:16 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/7] mwifiex: modify skb->truesize for PCIE Rx
Date: Mon,  4 Mar 2013 16:27:56 -0800
Message-Id: <1362443279-6064-5-git-send-email-bzhao@marvell.com> (sfid-20130305_012922_099035_05960ECF)
In-Reply-To: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
References: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

We allocate SKB buffers of 4K size to make sure that we process
RX AMSDU of 4K. So when skb->len is lesser than 4K; we should
modify skb->truesize. This resolves an issue where kernel has
allocated packets with 2K assumption and starts dropping packets
for large size data transfer.

This fix is already present for USB; extend it to PCIE.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/util.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 2155397..54667e6 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -195,7 +195,7 @@ int mwifiex_recv_packet(struct mwifiex_private *priv, struct sk_buff *skb)
 	skb->protocol = eth_type_trans(skb, priv->netdev);
 	skb->ip_summed = CHECKSUM_NONE;
 
-	/* This is required only in case of 11n and USB as we alloc
+	/* This is required only in case of 11n and USB/PCIE as we alloc
 	 * a buffer of 4K only if its 11N (to be able to receive 4K
 	 * AMSDU packets). In case of SD we allocate buffers based
 	 * on the size of packet and hence this is not needed.
@@ -212,7 +212,8 @@ int mwifiex_recv_packet(struct mwifiex_private *priv, struct sk_buff *skb)
 	 * fragments. Currently we fail the Filesndl-ht.scr script
 	 * for UDP, hence this fix
 	 */
-	if ((priv->adapter->iface_type == MWIFIEX_USB) &&
+	if ((priv->adapter->iface_type == MWIFIEX_USB ||
+	     priv->adapter->iface_type == MWIFIEX_PCIE) &&
 	    (skb->truesize > MWIFIEX_RX_DATA_BUF_SIZE))
 		skb->truesize += (skb->len - MWIFIEX_RX_DATA_BUF_SIZE);
 
-- 
1.7.0.2

