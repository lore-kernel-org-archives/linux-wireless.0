Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:36115 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab3EHJds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 05:33:48 -0400
Received: by mail-ea0-f175.google.com with SMTP id q10so784596eaj.6
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 02:33:46 -0700 (PDT)
From: wilocity.git@gmail.com
To: qca_vkondrat@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Erez Kirshenbaum <erezk@wilocity.com>,
	Wilocity Git <wilocity.git@gmail.com>
Subject: [PATCH 1/3] wil6210: TCP/UDP checksum offloading support
Date: Wed,  8 May 2013 11:32:51 +0300
Message-Id: <1368001971-11551-1-git-send-email-wilocity.git@gmail.com> (sfid-20130508_113352_854222_D24E2EE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erez Kirshenbaum <erezk@wilocity.com>

Add TCP/UDP checksum hardware offloading, configure hw and set the corresponding offloading bits in the
DMA descriptors.

Signed-off-by: Erez Kirshenbaum <erezk@wilocity.com>
Signed-off-by: Wilocity Git <wilocity.git@gmail.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c | 24 ++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c   | 77 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/txrx.h   | 28 +++++++++--
 drivers/net/wireless/ath/wil6210/wmi.c    |  8 ++++
 4 files changed, 130 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 098a8ec..4f2a61f 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -32,12 +32,34 @@ static int wil_stop(struct net_device *ndev)
 	return wil_down(wil);
 }
 
+static netdev_features_t wil_fix_features(struct net_device *netdev,
+			netdev_features_t features)
+{
+	return features;
+}
+
+static int wil_set_features(struct net_device *netdev,
+			netdev_features_t features)
+{
+	struct wil6210_priv *wil = ndev_to_wil(netdev);
+	netdev_features_t changed = features ^ netdev->features;
+
+	wil_info(wil, "wil_set_features: %x\n", (unsigned int)features);
+	if (changed & NETIF_F_HW_CSUM)
+		wil_info(wil, "Tx checksum offloading changed\n");
+	else if (changed & NETIF_F_RXCSUM)
+		wil_info(wil, "Rx checksum offloading changed\n");
+	return 0;
+}
+
 static const struct net_device_ops wil_netdev_ops = {
 	.ndo_open		= wil_open,
 	.ndo_stop		= wil_stop,
 	.ndo_start_xmit		= wil_start_xmit,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_fix_features	= wil_fix_features,
+	.ndo_set_features	= wil_set_features,
 };
 
 void *wil_if_alloc(struct device *dev, void __iomem *csr)
@@ -78,6 +100,8 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 
 	ndev->netdev_ops = &wil_netdev_ops;
 	ndev->ieee80211_ptr = wdev;
+	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	ndev->features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 7970245..3f44a6c 100644
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
@@ -391,7 +394,16 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 		 */
 		wil_swap_ethaddr(skb->data);
 	}
-
+	/* Check checksum-offload status */
+	if (ndev->features & NETIF_F_RXCSUM) {
+		if (d->dma.status & RX_DMA_STATUS_L4_IDENT) {
+			/* L4 protocol identified, csum calculated */
+			if ((d->dma.error & RX_DMA_ERROR_L4_ERR) == 0)
+				skb->ip_summed = CHECKSUM_UNNECESSARY;
+			else
+				wil_err(wil, "Incorrect checksum reported\n");
+		}
+	}
 	return skb;
 }
 
@@ -605,9 +617,7 @@ static int wil_tx_desc_map(volatile struct vring_tx_desc *d,
 {
 	d->dma.addr_low = lower_32_bits(pa);
 	d->dma.addr_high = (u16)upper_32_bits(pa);
-	d->dma.ip_length = 0;
-	/* 0..6: mac_length; 7:ip_version 0-IP6 1-IP4*/
-	d->dma.b11 = 0/*14 | BIT(7)*/;
+	d->dma.offload_cfg = 0;
 	d->dma.error = 0;
 	d->dma.status = 0; /* BIT(0) should be 0 for HW_OWNED */
 	d->dma.length = len;
@@ -630,6 +640,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 			struct sk_buff *skb)
 {
 	struct device *dev = wil_to_dev(wil);
+	struct net_device *ndev = wil_to_ndev(wil);
 	volatile struct vring_tx_desc *d;
 	u32 swhead = vring->swhead;
 	int avail = wil_vring_avail_tx(vring);
@@ -638,6 +649,8 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	int vring_index = vring - wil->vring_tx;
 	uint i = swhead;
 	dma_addr_t pa;
+	int is_ip4 = 0, is_ip6 = 0, is_tcp = 0, is_udp = 0;
+
 
 	wil_dbg_txrx(wil, "%s()\n", __func__);
 
@@ -665,6 +678,62 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		return -EINVAL;
 	/* 1-st segment */
 	wil_tx_desc_map(d, pa, skb_headlen(skb));
+	/*
+	 * Process offloading
+	 */
+	if ((skb->ip_summed == CHECKSUM_PARTIAL) &&
+		(ndev->features & NETIF_F_HW_CSUM))  {
+		if (skb->protocol == htons(ETH_P_IP)) {
+			is_ip4 = 1;
+		if (ip_hdr(skb)->protocol == IPPROTO_TCP)
+			is_tcp = 1;
+		else if (ip_hdr(skb)->protocol == IPPROTO_UDP)
+			is_udp = 1;
+		} else if (skb->protocol == htons(ETH_P_IPV6)) {
+			unsigned int offset = 0;
+			int ipv6hdr =  ipv6_find_hdr(skb,
+						&offset, -1, NULL, NULL);
+			is_ip6 = 1;
+			if (ipv6hdr == NEXTHDR_TCP)
+				is_tcp = 1;
+			else if (ipv6hdr == NEXTHDR_UDP)
+				is_udp = 1;
+		}
+	}
+
+
+	if (is_ip4 || is_ip6) {
+		if (is_ip4)
+			d->dma.offload_cfg |=
+				BIT(DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS);
+		d->dma.offload_cfg |=
+			(skb_network_header_len(skb) &
+			DMA_CFG_DESC_TX_OFFLOAD_CFG_IP_LEN_MSK);
+		d->dma.offload_cfg |=
+			(0x0e << DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_POS);
+		if (is_tcp || is_udp) {
+			/* Enable TCP/UDP checksum */
+			d->dma.d0 |=
+				BIT(DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_POS);
+			/* Calculate pseudo-header */
+			d->dma.d0 |=
+			   BIT(DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_POS);
+			if (is_tcp)  {
+				d->dma.d0 |=
+					(2 << DMA_CFG_DESC_TX_0_L4_TYPE_POS);
+			/* L4 header len: TCP header length */
+				d->dma.d0 |=
+					(tcp_hdrlen(skb) &
+					DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
+			} else  {
+				/* L4 header len: UDP header length */
+				d->dma.d0 |=
+					(sizeof(struct udphdr) &
+					DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
+			}
+		}
+	}
+
 	d->mac.d[2] |= ((nr_frags + 1) <<
 		       MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
 	/* middle segments */
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index adef12f..da22a93 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -209,7 +209,21 @@ struct vring_tx_mac {
 
 #define DMA_CFG_DESC_TX_0_L4_TYPE_POS 30
 #define DMA_CFG_DESC_TX_0_L4_TYPE_LEN 2
-#define DMA_CFG_DESC_TX_0_L4_TYPE_MSK 0xC0000000
+#define DMA_CFG_DESC_TX_0_L4_TYPE_MSK 0xC0000000 /* L4 type: 0-UDP, 2-TCP */
+
+/* TX DMA Dword 2 */
+/* Offload bits in offload_cfg field */
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_IP_LEN_POS 0
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_IP_LEN_LEN 8
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_IP_LEN_MSK 0x00FF /* IP hdr len */
+
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_POS 8
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_LEN 7
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_MSK 0x7F00 /* MAC hdr len */
+
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS 15
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_LEN 1
+#define DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_MSK 0x8000 /* 1-IPv4, 0-IPv6 */
 
 
 #define TX_DMA_STATUS_DU         BIT(0)
@@ -218,8 +232,7 @@ struct vring_tx_dma {
 	u32 d0;
 	u32 addr_low;
 	u16 addr_high;
-	u8  ip_length;
-	u8  b11;       /* 0..6: mac_length; 7:ip_version */
+	u16 offload_cfg;
 	u8  error;     /* 0..2: err; 3..7: reserved; */
 	u8  status;    /* 0: used; 1..7; reserved */
 	u16 length;
@@ -309,8 +322,17 @@ struct vring_rx_mac {
 
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
index 45b04e3..dc0aa8a 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -932,6 +932,14 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 		struct wmi_cfg_rx_chain_done_event evt;
 	} __packed evt;
 	int rc;
+	u8 csum_enabled = 0;
+
+	/* Initialize offload. Linux always calculates IP checksum */
+	cmd.l3_l4_ctrl |= (0 << L3_L4_CTRL_IPV4_CHECKSUM_EN_POS);
+	/* Enable/disable TCP/UDP checksum */
+	if (ndev->features & NETIF_F_RXCSUM)
+		csum_enabled = 1;
+	cmd.l3_l4_ctrl |= (csum_enabled << L3_L4_CTRL_TCPIP_CHECKSUM_EN_POS);
 
 	if (wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		struct ieee80211_channel *ch = wdev->preset_chandef.chan;
-- 
1.7.11.7

