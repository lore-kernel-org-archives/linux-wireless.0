Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27360 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbaE3TNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 15:13:41 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>,
	Aaron Durbin <adurbin@chromium.org>
Subject: [PATCH 1/2] mwifiex: fix PCIe tx_info overlap
Date: Fri, 30 May 2014 12:13:08 -0700
Message-ID: <1401477189-24531-1-git-send-email-bzhao@marvell.com> (sfid-20140530_211343_468027_74EB1859)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chin-Ran Lo <crlo@marvell.com>

On PCIe Tx data path, network interface specific parameters
bss_num and bss_type are saved at "skb->cb + sizeof(dma_addr_t)"
(returned by MWIFIEX_SKB_TXCB). Later mwifiex_map_pci_memory()
called from mwifiex_pcie_send_data() will memcpy
sizeof(struct mwifiex_dma_mapping) bytes to save PCIe DMA
address and length information at beginning of skb->cb.
This accidently overwrites bss_num and bss_type saved in skb->cb
previously because bss_num/bss_type and mwifiex_dma_mapping data
overlap. Fix it by having MWIFIEX_SKB_TXCB return the correct
offset for bss_num and bss_type.

Cc: Aaron Durbin <adurbin@chromium.org>
Signed-off-by: Chin-Ran Lo <crlo@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/util.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index ddae570..2cde441 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -25,16 +25,17 @@ static inline struct mwifiex_rxinfo *MWIFIEX_SKB_RXCB(struct sk_buff *skb)
 	return (struct mwifiex_rxinfo *)(skb->cb + sizeof(dma_addr_t));
 }
 
-static inline struct mwifiex_txinfo *MWIFIEX_SKB_TXCB(struct sk_buff *skb)
-{
-	return (struct mwifiex_txinfo *)(skb->cb + sizeof(dma_addr_t));
-}
-
 struct mwifiex_dma_mapping {
 	dma_addr_t addr;
 	size_t len;
 };
 
+static inline struct mwifiex_txinfo *MWIFIEX_SKB_TXCB(struct sk_buff *skb)
+{
+	return (struct mwifiex_txinfo *)(skb->cb +
+		sizeof(struct mwifiex_dma_mapping));
+}
+
 static inline void MWIFIEX_SKB_PACB(struct sk_buff *skb,
 					struct mwifiex_dma_mapping *mapping)
 {
-- 
1.8.2.3

