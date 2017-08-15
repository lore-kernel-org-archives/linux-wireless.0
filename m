Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0073.outbound.protection.outlook.com ([104.47.42.73]:15232
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751344AbdHONG5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 09:06:57 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 3/9] qtnfmac: use __netdev_alloc_skb_ip_align
Date: Tue, 15 Aug 2017 16:06:33 +0300
Message-Id: <20170815130638.31718-4-sergey.matyukevich.os@quantenna.com> (sfid-20170815_150703_155172_96A77F9B)
In-Reply-To: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace __dev_alloc_skb and explicit NET_IP_ALIGN alignment by built-in
__netdev_alloc_skb_ip_align function.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 08b35dc30bc8..079aa1693ff5 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -429,8 +429,7 @@ static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 rx_bd_index)
 	struct sk_buff *skb;
 	dma_addr_t paddr;
 
-	skb = __dev_alloc_skb(SKB_BUF_SIZE + NET_IP_ALIGN,
-			      GFP_ATOMIC);
+	skb = __netdev_alloc_skb_ip_align(NULL, SKB_BUF_SIZE, GFP_ATOMIC);
 	if (!skb) {
 		priv->rx_skb[rx_bd_index] = NULL;
 		return -ENOMEM;
@@ -438,8 +437,6 @@ static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 rx_bd_index)
 
 	priv->rx_skb[rx_bd_index] = skb;
 
-	skb_reserve(skb, NET_IP_ALIGN);
-
 	rxbd = &priv->rx_bd_vbase[rx_bd_index];
 
 	paddr = pci_map_single(priv->pdev, skb->data,
-- 
2.11.0
