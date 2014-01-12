Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31511 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaALIlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 03:41:21 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 2/3] wil6210: Fix IP version indication for Tx csum offload
Date: Sun, 12 Jan 2014 10:41:03 +0200
Message-ID: <1389516065-19515-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140112_094131_297552_5C7C1201)
In-Reply-To: <1389516065-19515-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1389516065-19515-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bit DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS should be set for IPv4
only. Don't set it for IPv6

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index d505b26..18003c0 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -673,9 +673,12 @@ static int wil_tx_desc_offload_cksum_set(struct wil6210_priv *wil,
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
 		return 0;
 
+	d->dma.b11 = ETH_HLEN; /* MAC header length */
+
 	switch (skb->protocol) {
 	case cpu_to_be16(ETH_P_IP):
 		protocol = ip_hdr(skb)->protocol;
+		d->dma.b11 |= BIT(DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS);
 		break;
 	case cpu_to_be16(ETH_P_IPV6):
 		protocol = ipv6_hdr(skb)->nexthdr;
@@ -701,8 +704,6 @@ static int wil_tx_desc_offload_cksum_set(struct wil6210_priv *wil,
 	}
 
 	d->dma.ip_length = skb_network_header_len(skb);
-	d->dma.b11 = ETH_HLEN; /* MAC header length */
-	d->dma.b11 |= BIT(DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS);
 	/* Enable TCP/UDP checksum */
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_POS);
 	/* Calculate pseudo-header */
-- 
1.8.3.2

