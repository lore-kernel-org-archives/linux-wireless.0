Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53067 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab1CHDFK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 22:05:10 -0500
Message-ID: <4D759C2B.1050400@cn.fujitsu.com>
Date: Tue, 08 Mar 2011 11:02:03 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: buytenh@wantstofly.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: used kzalloc instead of kmalloc & memset
References: <4D74BC3C.1080203@cn.fujitsu.com> <AANLkTi=T0eeNXrfBLdiPGch1X5EnHY+WrqYekXnZ+5=-@mail.gmail.com>
In-Reply-To: <AANLkTi=T0eeNXrfBLdiPGch1X5EnHY+WrqYekXnZ+5=-@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby wrote, at 03/07/2011 09:30 PM:
>> -       rxq->buf = kmalloc(MWL8K_RX_DESCS * sizeof(*rxq->buf), GFP_KERNEL);
>> +       rxq->buf = kzalloc(MWL8K_RX_DESCS * sizeof(*rxq->buf), GFP_KERNEL);
> 
> Random nit, you're changing this from kmalloc to kzalloc when it would
> be trivial to change it to kcalloc instead if you don't restrict the T
> variable in your semantic patch to a type.

Thanks for your review.
here patch-v2.

==========================================
[PATCH v2] wireless: use kcalloc instead of kmalloc & memset

Use kcalloc or kzalloc rather than the combination of kmalloc and memset.

Thanks coccicheck for detecting this.
(http://coccinelle.lip6.fr/)



Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 drivers/net/wireless/mwl8k.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index df5959f..3695227 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1056,13 +1056,12 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 	}
 	memset(rxq->rxd, 0, size);
 
-	rxq->buf = kmalloc(MWL8K_RX_DESCS * sizeof(*rxq->buf), GFP_KERNEL);
+	rxq->buf = kcalloc(MWL8K_RX_DESCS, sizeof(*rxq->buf), GFP_KERNEL);
 	if (rxq->buf == NULL) {
 		wiphy_err(hw->wiphy, "failed to alloc RX skbuff list\n");
 		pci_free_consistent(priv->pdev, size, rxq->rxd, rxq->rxd_dma);
 		return -ENOMEM;
 	}
-	memset(rxq->buf, 0, MWL8K_RX_DESCS * sizeof(*rxq->buf));
 
 	for (i = 0; i < MWL8K_RX_DESCS; i++) {
 		int desc_size;
@@ -1347,13 +1346,12 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 	}
 	memset(txq->txd, 0, size);
 
-	txq->skb = kmalloc(MWL8K_TX_DESCS * sizeof(*txq->skb), GFP_KERNEL);
+	txq->skb = kcalloc(MWL8K_TX_DESCS, sizeof(*txq->skb), GFP_KERNEL);
 	if (txq->skb == NULL) {
 		wiphy_err(hw->wiphy, "failed to alloc TX skbuff list\n");
 		pci_free_consistent(priv->pdev, size, txq->txd, txq->txd_dma);
 		return -ENOMEM;
 	}
-	memset(txq->skb, 0, MWL8K_TX_DESCS * sizeof(*txq->skb));
 
 	for (i = 0; i < MWL8K_TX_DESCS; i++) {
 		struct mwl8k_tx_desc *tx_desc;
-- 
1.6.3.3
