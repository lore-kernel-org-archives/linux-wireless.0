Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20888 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3GUIfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jul 2013 04:35:52 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	<wil6210@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] wil6210: Enable TCP/UDP checksum HW offload
Date: Sun, 21 Jul 2013 11:34:37 +0300
Message-ID: <1374395677-16751-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130721_103601_162157_3DF0B3DF)
In-Reply-To: <1374395677-16751-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1374395677-16751-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kirshenbaum Erez <erezk@wilocity.com>

Add support for TCP and UDP HW checksum offloading.
RX chain is allways configured for offload mode.
In case of checksum error in RX path the DMA L4 error bit(5)
will be set to 1 and driver will drop the packet.
TX checksum offloading is configrable (ethtool -K).
TX descriptors are configured for checksum offload according
to the SKB protocol type (TCP/UDP, IPV4/6), Upon mismatch drop
the TX packet (checksum required but not TCP/UDP IPV4/6 type).

Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c |  2 +
 drivers/net/wireless/ath/wil6210/txrx.c   | 76 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/txrx.h   | 20 +++++++-
 drivers/net/wireless/ath/wil6210/wmi.c    |  6 +++
 4 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 29dd1e5..717178f 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -127,6 +127,8 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 
 	ndev->netdev_ops = &wil_netdev_ops;
 	ndev->ieee80211_ptr = wdev;
+	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	ndev->features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index e563af1..ea1abeb 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -18,6 +18,9 @@
 #include <net/ieee80211_radiotap.h>
 #include <linux/if_arp.h>
 #include <linux/moduleparam.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
 
 #include "wil6210.h"
 #include "wmi.h"
@@ -407,6 +410,21 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 		return NULL;
 	}
 
+	/* L4 IDENT is on when HW calculated checksum, check status
+	 * and in case of error drop the packet
+	 * higher stack layers will handle retransmission (if required)
+	 */
+	if (d->dma.status & RX_DMA_STATUS_L4_IDENT) {
+		/* L4 protocol identified, csum calculated */
+		if ((d->dma.error & RX_DMA_ERROR_L4_ERR) == 0) {
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		} else {
+			wil_err(wil, "Incorrect checksum reported\n");
+			kfree_skb(skb);
+			return NULL;
+		}
+	}
+
 	ds_bits = wil_rxdesc_ds_bits(d);
 	if (ds_bits == 1) {
 		/*
@@ -646,6 +664,53 @@ static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len,
 	return 0;
 }
 
+static int wil_tx_desc_offload_cksum_set(struct wil6210_priv *wil,
+				struct vring_tx_desc *d,
+				struct sk_buff *skb)
+{
+	int protocol;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return 0;
+
+	switch (skb->protocol) {
+	case cpu_to_be16(ETH_P_IP):
+		protocol = ip_hdr(skb)->protocol;
+		break;
+	case cpu_to_be16(ETH_P_IPV6):
+		protocol = ipv6_hdr(skb)->nexthdr;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (protocol) {
+	case IPPROTO_TCP:
+		d->dma.d0 |= (2 << DMA_CFG_DESC_TX_0_L4_TYPE_POS);
+		/* L4 header len: TCP header length */
+		d->dma.d0 |=
+		(tcp_hdrlen(skb) & DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
+		break;
+	case IPPROTO_UDP:
+		/* L4 header len: UDP header length */
+		d->dma.d0 |=
+		(sizeof(struct udphdr) & DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	d->dma.ip_length = skb_network_header_len(skb);
+	d->dma.b11 = ETH_HLEN; /* MAC header length */
+	d->dma.b11 |= BIT(DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS);
+	/* Enable TCP/UDP checksum */
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_POS);
+	/* Calculate pseudo-header */
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_POS);
+
+	return 0;
+}
+
 static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 			struct sk_buff *skb)
 {
@@ -655,7 +720,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	u32 swhead = vring->swhead;
 	int avail = wil_vring_avail_tx(vring);
 	int nr_frags = skb_shinfo(skb)->nr_frags;
-	uint f;
+	uint f = 0;
 	int vring_index = vring - wil->vring_tx;
 	uint i = swhead;
 	dma_addr_t pa;
@@ -686,13 +751,20 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		return -EINVAL;
 	/* 1-st segment */
 	wil_tx_desc_map(d, pa, skb_headlen(skb), vring_index);
+	/* Process TCP/UDP checksum offloading */
+	if (wil_tx_desc_offload_cksum_set(wil, d, skb)) {
+		wil_err(wil, "VRING #%d Failed to set cksum, drop packet\n",
+			vring_index);
+		goto dma_error;
+	}
+
 	d->mac.d[2] |= ((nr_frags + 1) <<
 		       MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
 	if (nr_frags)
 		*_d = *d;
 
 	/* middle segments */
-	for (f = 0; f < nr_frags; f++) {
+	for (; f < nr_frags; f++) {
 		const struct skb_frag_struct *frag =
 				&skb_shinfo(skb)->frags[f];
 		int len = skb_frag_size(frag);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 859aea6..b382827 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -235,7 +235,16 @@ struct vring_tx_mac {
 
 #define DMA_CFG_DESC_TX_0_L4_TYPE_POS 30
 #define DMA_CFG_DESC_TX_0_L4_TYPE_LEN 2
-#define DMA_CFG_DESC_TX_0_L4_TYPE_MSK 0xC0000000
+#define DMA_CFG_DESC_TX_0_L4_TYPE_MSK 0xC0000000 /* L4 type: 0-UDP, 2-TCP */
+
+
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_POS 0
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_LEN 7
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_MSK 0x7F /* MAC hdr len */
+
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS 7
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_LEN 1
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_MSK 0x80 /* 1-IPv4, 0-IPv6 */
 
 
 #define TX_DMA_STATUS_DU         BIT(0)
@@ -334,8 +343,17 @@ struct vring_rx_mac {
 
 #define RX_DMA_D0_CMD_DMA_IT     BIT(10)
 
+/* Error field, offload bits */
+#define RX_DMA_ERROR_L3_ERR   BIT(4)
+#define RX_DMA_ERROR_L4_ERR   BIT(5)
+
+
+/* Status field */
 #define RX_DMA_STATUS_DU         BIT(0)
 #define RX_DMA_STATUS_ERROR      BIT(2)
+
+#define RX_DMA_STATUS_L3_IDENT   BIT(4)
+#define RX_DMA_STATUS_L4_IDENT   BIT(5)
 #define RX_DMA_STATUS_PHY_INFO   BIT(6)
 
 struct vring_rx_dma {
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index a62511a..5220f15 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -924,6 +924,12 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 		cmd.sniffer_cfg.phy_support =
 			cpu_to_le32((wil->monitor_flags & MONITOR_FLAG_CONTROL)
 				    ? WMI_SNIFFER_CP : WMI_SNIFFER_DP);
+	} else {
+		/* Initialize offload (in non-sniffer mode).
+		 * Linux IP stack always calculates IP checksum
+		 * HW always calculate TCP/UDP checksum
+		 */
+		cmd.l3_l4_ctrl |= (1 << L3_L4_CTRL_TCPIP_CHECKSUM_EN_POS);
 	}
 	/* typical time for secure PCP is 840ms */
 	rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
-- 
1.8.1.2

