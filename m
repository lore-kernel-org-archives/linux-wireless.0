Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12771 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755256AbdC1JAl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 05:00:41 -0400
From: Elena Reshetova <elena.reshetova@intel.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-wireless@vger.kernel.org,
        ganeshgr@chelsio.com, nbd@openwrt.org, blogic@openwrt.org,
        matthias.bgg@gmail.com, yishaih@mellanox.com, saeedm@mellanox.com,
        matanb@mellanox.com, leonro@mellanox.com,
        ajk@comnets.uni-bremen.de, paulus@samba.org, j@w1.fi,
        kvalo@codeaurora.org, peterz@infradead.org, keescook@chromium.org,
        gregkh@linuxfoundation.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        David Windsor <dwindsor@gmail.com>
Subject: [PATCH 02/16] drivers, net, ethernet: convert mtk_eth.dma_refcnt from atomic_t to refcount_t
Date: Tue, 28 Mar 2017 11:56:29 +0300
Message-Id: <1490691403-4016-3-git-send-email-elena.reshetova@intel.com> (sfid-20170328_112613_640184_7493A1FE)
In-Reply-To: <1490691403-4016-1-git-send-email-elena.reshetova@intel.com>
References: <1490691403-4016-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 8 +++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 4 +++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index bf6317e..d27f9d9 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1725,7 +1725,7 @@ static int mtk_open(struct net_device *dev)
 	struct mtk_eth *eth = mac->hw;
 
 	/* we run 2 netdevs on the same dma ring so we only bring it up once */
-	if (!atomic_read(&eth->dma_refcnt)) {
+	if (!refcount_read(&eth->dma_refcnt)) {
 		int err = mtk_start_dma(eth);
 
 		if (err)
@@ -1735,8 +1735,10 @@ static int mtk_open(struct net_device *dev)
 		napi_enable(&eth->rx_napi);
 		mtk_irq_enable(eth, MTK_QDMA_INT_MASK, MTK_TX_DONE_INT);
 		mtk_irq_enable(eth, MTK_PDMA_INT_MASK, MTK_RX_DONE_INT);
+		refcount_set(&eth->dma_refcnt, 1);
 	}
-	atomic_inc(&eth->dma_refcnt);
+	else
+		refcount_inc(&eth->dma_refcnt);
 
 	phy_start(dev->phydev);
 	netif_start_queue(dev);
@@ -1776,7 +1778,7 @@ static int mtk_stop(struct net_device *dev)
 	phy_stop(dev->phydev);
 
 	/* only shutdown DMA if this is the last user */
-	if (!atomic_dec_and_test(&eth->dma_refcnt))
+	if (!refcount_dec_and_test(&eth->dma_refcnt))
 		return 0;
 
 	mtk_irq_disable(eth, MTK_QDMA_INT_MASK, MTK_TX_DONE_INT);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 99b1c8e..e5b99b7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -15,6 +15,8 @@
 #ifndef MTK_ETH_H
 #define MTK_ETH_H
 
+#include <linux/refcount.h>
+
 #define MTK_QDMA_PAGE_SIZE	2048
 #define	MTK_MAX_RX_LENGTH	1536
 #define MTK_TX_DMA_BUF_LEN	0x3fff
@@ -541,7 +543,7 @@ struct mtk_eth {
 	struct regmap			*pctl;
 	u32				chip_id;
 	bool				hwlro;
-	atomic_t			dma_refcnt;
+	refcount_t			dma_refcnt;
 	struct mtk_tx_ring		tx_ring;
 	struct mtk_rx_ring		rx_ring[MTK_MAX_RX_RING_NUM];
 	struct napi_struct		tx_napi;
-- 
2.7.4
