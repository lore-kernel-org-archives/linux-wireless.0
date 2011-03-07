Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62473 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab1CGLJk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 06:09:40 -0500
Message-ID: <4D74BC3C.1080203@cn.fujitsu.com>
Date: Mon, 07 Mar 2011 19:06:36 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
MIME-Version: 1.0
To: buytenh@wantstofly.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] wireless: used kzalloc instead of kmalloc & memset
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kcalloc or kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,y,flags;
statement S;
type T;
@@

x = 
-   kmalloc
+   kcalloc
           (
-           y * sizeof(T),
+           y, sizeof(T),
                flags);
 if (x == NULL) S
-memset(x, 0, y * sizeof(T));

@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>



Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 drivers/net/wireless/mwl8k.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index df5959f..43776e6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1056,13 +1056,12 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 	}
 	memset(rxq->rxd, 0, size);
 
-	rxq->buf = kmalloc(MWL8K_RX_DESCS * sizeof(*rxq->buf), GFP_KERNEL);
+	rxq->buf = kzalloc(MWL8K_RX_DESCS * sizeof(*rxq->buf), GFP_KERNEL);
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
+	txq->skb = kzalloc(MWL8K_TX_DESCS * sizeof(*txq->skb), GFP_KERNEL);
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
