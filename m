Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40979 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab3LCHSl (ORCPT
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
Subject: [PATCH 09/12] mwifiex: update statistics for bridged packets on AP interface
Date: Mon, 2 Dec 2013 23:17:56 -0800
Message-ID: <1386055079-6623-10-git-send-email-bzhao@marvell.com> (sfid-20131203_081848_166706_D3F9DB38)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ujjal Roy <royujjal@gmail.com>

The bridged packets are updated to statistics on both TX and RX
paths. Also fix a typo in the comment.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_txrx.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 6c0a31a..3c74eb2 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -147,7 +147,7 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 		hdr_chop = (u8 *)&rx_pkt_hdr->eth803_hdr - (u8 *)uap_rx_pd;
 	}
 
-	/* Chop off the leading header bytes so the it points
+	/* Chop off the leading header bytes so that it points
 	 * to the start of either the reconstructed EthII frame
 	 * or the 802.2/llc/snap frame.
 	 */
@@ -179,6 +179,19 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	tx_info->bss_type = priv->bss_type;
 	tx_info->flags |= MWIFIEX_BUF_FLAG_BRIDGED_PKT;
 
+	if (is_unicast_ether_addr(rx_pkt_hdr->eth803_hdr.h_dest)) {
+		/* Update bridge packet statistics as the
+		 * packet is not going to kernel/upper layer.
+		 */
+		priv->stats.rx_bytes += skb->len;
+		priv->stats.rx_packets++;
+
+		/* Sending bridge packet to TX queue, so save the packet
+		 * length in TXCB to update statistics in TX complete.
+		 */
+		tx_info->pkt_len = skb->len;
+	}
+
 	do_gettimeofday(&tv);
 	skb->tstamp = timeval_to_ktime(tv);
 	mwifiex_wmm_add_buf_txqueue(priv, skb);
-- 
1.8.2.3

