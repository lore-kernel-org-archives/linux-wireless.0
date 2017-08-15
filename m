Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0084.outbound.protection.outlook.com ([104.47.42.84]:62496
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751598AbdHONHI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 09:07:08 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 8/9] qtnfmac: modify tx reclaim locking
Date: Tue, 15 Aug 2017 16:06:38 +0300
Message-Id: <20170815130638.31718-9-sergey.matyukevich.os@quantenna.com> (sfid-20170815_150713_085021_C0530061)
In-Reply-To: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Perform additional reclaim from qtnf_pcie_data_tx. Lock tx_lock serves only
reclaim synchronization purposes. Rename it accordingly and improve
granularity moving this lock to qtnf_pcie_data_tx_reclaim.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c     | 17 ++++++-----------
 .../wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h    |  4 ++--
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 72730aff2a41..cd2f2b667643 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -534,11 +534,13 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_bus_priv *priv)
 {
 	struct qtnf_tx_bd *txbd;
 	struct sk_buff *skb;
+	unsigned long flags;
 	dma_addr_t paddr;
 	u32 tx_done_index;
 	int count = 0;
 	int i;
 
+	spin_lock_irqsave(&priv->tx_reclaim_lock, flags);
 
 	tx_done_index = readl(PCIE_HDP_RX0DMA_CNT(priv->pcie_reg_base))
 			& (priv->tx_bd_num - 1);
@@ -576,6 +578,7 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_bus_priv *priv)
 	priv->tx_reclaim_req++;
 	priv->tx_bd_r_index = i;
 
+	spin_unlock_irqrestore(&priv->tx_reclaim_lock, flags);
 }
 
 static int qtnf_tx_queue_ready(struct qtnf_pcie_bus_priv *priv)
@@ -600,20 +603,14 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
 	dma_addr_t txbd_paddr, skb_paddr;
 	struct qtnf_tx_bd *txbd;
-	unsigned long flags;
 	int len, i;
 	u32 info;
 	int ret = 0;
 
-	spin_lock_irqsave(&priv->tx_lock, flags);
-
-	priv->tx_done_count++;
-
 	if (!qtnf_tx_queue_ready(priv)) {
 		if (skb->dev)
 			netif_stop_queue(skb->dev);
 
-		spin_unlock_irqrestore(&priv->tx_lock, flags);
 		return NETDEV_TX_BUSY;
 	}
 
@@ -659,7 +656,8 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 		dev_kfree_skb_any(skb);
 	}
 
-	spin_unlock_irqrestore(&priv->tx_lock, flags);
+	qtnf_pcie_data_tx_reclaim(priv);
+	priv->tx_done_count++;
 
 	return NETDEV_TX_OK;
 }
@@ -1067,11 +1065,8 @@ static int qtnf_bringup_fw(struct qtnf_bus *bus)
 static void qtnf_reclaim_tasklet_fn(unsigned long data)
 {
 	struct qtnf_pcie_bus_priv *priv = (void *)data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&priv->tx_lock, flags);
 	qtnf_pcie_data_tx_reclaim(priv);
-	spin_unlock_irqrestore(&priv->tx_lock, flags);
 	qtnf_en_txdone_irq(priv);
 }
 
@@ -1192,7 +1187,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	init_completion(&bus->request_firmware_complete);
 	mutex_init(&bus->bus_lock);
 	spin_lock_init(&pcie_priv->irq_lock);
-	spin_lock_init(&pcie_priv->tx_lock);
+	spin_lock_init(&pcie_priv->tx_reclaim_lock);
 
 	/* init stats */
 	pcie_priv->tx_full_count = 0;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
index 698e42132ed4..e76a23716ee0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
@@ -32,8 +32,8 @@ struct qtnf_pcie_bus_priv {
 	/* lock for irq configuration changes */
 	spinlock_t irq_lock;
 
-	/* lock for tx operations */
-	spinlock_t tx_lock;
+	/* lock for tx reclaim operations */
+	spinlock_t tx_reclaim_lock;
 	u8 msi_enabled;
 	int mps;
 
-- 
2.11.0
