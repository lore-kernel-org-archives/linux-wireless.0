Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36868 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750729AbeFAHyB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Jun 2018 03:54:01 -0400
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: uap: do not chok ethernet header in bridge path
Date: Fri, 1 Jun 2018 15:53:40 +0800
Message-ID: <1527839620-1760-1-git-send-email-huxm@marvell.com> (sfid-20180601_095405_492916_31BB64D4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not chock ethernet header for uap bridge data path,
as it is still needed to send skb to dest station.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c | 52 ++++++++++++-------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
index 1e6a62c..5ce85d5 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
@@ -289,32 +289,6 @@ int mwifiex_uap_recv_packet(struct mwifiex_private *priv,
 		src_node->stats.rx_packets++;
 	}
 
-	skb->dev = priv->netdev;
-	skb->protocol = eth_type_trans(skb, priv->netdev);
-	skb->ip_summed = CHECKSUM_NONE;
-
-	/* This is required only in case of 11n and USB/PCIE as we alloc
-	 * a buffer of 4K only if its 11N (to be able to receive 4K
-	 * AMSDU packets). In case of SD we allocate buffers based
-	 * on the size of packet and hence this is not needed.
-	 *
-	 * Modifying the truesize here as our allocation for each
-	 * skb is 4K but we only receive 2K packets and this cause
-	 * the kernel to start dropping packets in case where
-	 * application has allocated buffer based on 2K size i.e.
-	 * if there a 64K packet received (in IP fragments and
-	 * application allocates 64K to receive this packet but
-	 * this packet would almost double up because we allocate
-	 * each 1.5K fragment in 4K and pass it up. As soon as the
-	 * 64K limit hits kernel will start to drop rest of the
-	 * fragments. Currently we fail the Filesndl-ht.scr script
-	 * for UDP, hence this fix
-	 */
-	if ((adapter->iface_type == MWIFIEX_USB ||
-	     adapter->iface_type == MWIFIEX_PCIE) &&
-	    (skb->truesize > MWIFIEX_RX_DATA_BUF_SIZE))
-		skb->truesize += (skb->len - MWIFIEX_RX_DATA_BUF_SIZE);
-
 	if (is_multicast_ether_addr(p_ethhdr->h_dest) ||
 	    mwifiex_get_sta_entry(priv, p_ethhdr->h_dest)) {
 		if (skb_headroom(skb) < MWIFIEX_MIN_DATA_HEADER_LEN)
@@ -350,6 +324,32 @@ int mwifiex_uap_recv_packet(struct mwifiex_private *priv,
 			return 0;
 	}
 
+	skb->dev = priv->netdev;
+	skb->protocol = eth_type_trans(skb, priv->netdev);
+	skb->ip_summed = CHECKSUM_NONE;
+
+	/* This is required only in case of 11n and USB/PCIE as we alloc
+	 * a buffer of 4K only if its 11N (to be able to receive 4K
+	 * AMSDU packets). In case of SD we allocate buffers based
+	 * on the size of packet and hence this is not needed.
+	 *
+	 * Modifying the truesize here as our allocation for each
+	 * skb is 4K but we only receive 2K packets and this cause
+	 * the kernel to start dropping packets in case where
+	 * application has allocated buffer based on 2K size i.e.
+	 * if there a 64K packet received (in IP fragments and
+	 * application allocates 64K to receive this packet but
+	 * this packet would almost double up because we allocate
+	 * each 1.5K fragment in 4K and pass it up. As soon as the
+	 * 64K limit hits kernel will start to drop rest of the
+	 * fragments. Currently we fail the Filesndl-ht.scr script
+	 * for UDP, hence this fix
+	 */
+	if ((adapter->iface_type == MWIFIEX_USB ||
+	     adapter->iface_type == MWIFIEX_PCIE) &&
+	    skb->truesize > MWIFIEX_RX_DATA_BUF_SIZE)
+		skb->truesize += (skb->len - MWIFIEX_RX_DATA_BUF_SIZE);
+
 	/* Forward multicast/broadcast packet to upper layer*/
 	if (in_interrupt())
 		netif_rx(skb);
-- 
1.9.1
