Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10594 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbaFGChe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 22:37:34 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Chin-Ran Lo <crlo@marvell.com>,
	Aaron Durbin <adurbin@chromium.org>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] mwifiex: fix tx_info/rx_info overlap with PCIe dma_mapping
Date: Fri, 6 Jun 2014 19:37:10 -0700
Message-ID: <1402108630-6833-1-git-send-email-bzhao@marvell.com> (sfid-20140607_043737_738445_D4E8AAA9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chin-Ran Lo <crlo@marvell.com>

On PCIe Tx data path, network interface specific tx_info
parameters such as bss_num and bss_type are saved at
"skb->cb + sizeof(dma_addr_t)" (returned by MWIFIEX_SKB_TXCB).
Later mwifiex_map_pci_memory() called from
mwifiex_pcie_send_data() will memcpy
sizeof(struct mwifiex_dma_mapping) bytes to save PCIe DMA
address and length information at beginning of skb->cb.
This accidently overwrites bss_num and bss_type saved in skb->cb
previously because bss_num/bss_type and mwifiex_dma_mapping data
overlap.
Similarly, on PCIe Rx data path, rx_info parameters overlaps
with PCIe DMA address and length information too.

Fix it by defining mwifiex_cb structure and having
MWIFIEX_SKB_TXCB and MWIFIEX_SKB_RXCB return the correct address
of tx_info/rx_info using the structure members.

Also add a BUILD_BUG_ON to maks sure that mwifiex_cb structure
doesn't exceed the size of skb->cb.

Reviewed-by: Aaron Durbin <adurbin@chromium.org>
Signed-off-by: Chin-Ran Lo <crlo@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: rename patch subject (was: mwifiex: fix PCIe tx_info overlap)
    fix buffer overlap for rx_info as well; (Aaron Durbin)
    add symmetrical 'store' inline function; (Aaron Durbin)

 drivers/net/wireless/mwifiex/pcie.c |  4 ++--
 drivers/net/wireless/mwifiex/util.h | 43 ++++++++++++++++++++++++++++---------
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 574d4b5..2cc9b6f 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -50,7 +50,7 @@ mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		return -1;
 	}
 	mapping.len = size;
-	memcpy(skb->cb, &mapping, sizeof(mapping));
+	mwifiex_store_mapping(skb, &mapping);
 	return 0;
 }
 
@@ -60,7 +60,7 @@ static void mwifiex_unmap_pci_memory(struct mwifiex_adapter *adapter,
 	struct pcie_service_card *card = adapter->card;
 	struct mwifiex_dma_mapping mapping;
 
-	MWIFIEX_SKB_PACB(skb, &mapping);
+	mwifiex_get_mapping(skb, &mapping);
 	pci_unmap_single(card->dev, mapping.addr, mapping.len, flags);
 }
 
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index ddae570..caadb37 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -20,32 +20,55 @@
 #ifndef _MWIFIEX_UTIL_H_
 #define _MWIFIEX_UTIL_H_
 
+struct mwifiex_dma_mapping {
+	dma_addr_t addr;
+	size_t len;
+};
+
+struct mwifiex_cb {
+	struct mwifiex_dma_mapping dma_mapping;
+	union {
+		struct mwifiex_rxinfo rx_info;
+		struct mwifiex_txinfo tx_info;
+	};
+};
+
 static inline struct mwifiex_rxinfo *MWIFIEX_SKB_RXCB(struct sk_buff *skb)
 {
-	return (struct mwifiex_rxinfo *)(skb->cb + sizeof(dma_addr_t));
+	struct mwifiex_cb *cb = (struct mwifiex_cb *)skb->cb;
+
+	BUILD_BUG_ON(sizeof(struct mwifiex_cb) > sizeof(skb->cb));
+	return &cb->rx_info;
 }
 
 static inline struct mwifiex_txinfo *MWIFIEX_SKB_TXCB(struct sk_buff *skb)
 {
-	return (struct mwifiex_txinfo *)(skb->cb + sizeof(dma_addr_t));
+	struct mwifiex_cb *cb = (struct mwifiex_cb *)skb->cb;
+
+	return &cb->tx_info;
 }
 
-struct mwifiex_dma_mapping {
-	dma_addr_t addr;
-	size_t len;
-};
+static inline void mwifiex_store_mapping(struct sk_buff *skb,
+					 struct mwifiex_dma_mapping *mapping)
+{
+	struct mwifiex_cb *cb = (struct mwifiex_cb *)skb->cb;
+
+	memcpy(&cb->dma_mapping, mapping, sizeof(*mapping));
+}
 
-static inline void MWIFIEX_SKB_PACB(struct sk_buff *skb,
-					struct mwifiex_dma_mapping *mapping)
+static inline void mwifiex_get_mapping(struct sk_buff *skb,
+				       struct mwifiex_dma_mapping *mapping)
 {
-	memcpy(mapping, skb->cb, sizeof(*mapping));
+	struct mwifiex_cb *cb = (struct mwifiex_cb *)skb->cb;
+
+	memcpy(mapping, &cb->dma_mapping, sizeof(*mapping));
 }
 
 static inline dma_addr_t MWIFIEX_SKB_DMA_ADDR(struct sk_buff *skb)
 {
 	struct mwifiex_dma_mapping mapping;
 
-	MWIFIEX_SKB_PACB(skb, &mapping);
+	mwifiex_get_mapping(skb, &mapping);
 
 	return mapping.addr;
 }
-- 
1.8.2.3

