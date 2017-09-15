Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0044.outbound.protection.outlook.com ([104.47.33.44]:39568
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751370AbdIOLxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 07:53:30 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 1/2] qtnfmac: lock access to h/w in tx path
Date: Fri, 15 Sep 2017 14:52:59 +0300
Message-Id: <20170915115300.12719-2-sergey.matyukevich.os@quantenna.com> (sfid-20170915_135335_622473_0B1EBB10)
In-Reply-To: <20170915115300.12719-1-sergey.matyukevich.os@quantenna.com>
References: <20170915115300.12719-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix tx path regression. Lock should be held when queuing packets
to h/w fifos in order to properly handle configurations with
multiple enabled interfaces.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c          | 9 ++++++++-
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 502e72b7cdcc..69131965a298 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -661,14 +661,18 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
 	dma_addr_t txbd_paddr, skb_paddr;
 	struct qtnf_tx_bd *txbd;
+	unsigned long flags;
 	int len, i;
 	u32 info;
 	int ret = 0;
 
+	spin_lock_irqsave(&priv->tx0_lock, flags);
+
 	if (!qtnf_tx_queue_ready(priv)) {
 		if (skb->dev)
 			netif_stop_queue(skb->dev);
 
+		spin_unlock_irqrestore(&priv->tx0_lock, flags);
 		return NETDEV_TX_BUSY;
 	}
 
@@ -717,8 +721,10 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 		dev_kfree_skb_any(skb);
 	}
 
-	qtnf_pcie_data_tx_reclaim(priv);
 	priv->tx_done_count++;
+	spin_unlock_irqrestore(&priv->tx0_lock, flags);
+
+	qtnf_pcie_data_tx_reclaim(priv);
 
 	return NETDEV_TX_OK;
 }
@@ -1247,6 +1253,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	strcpy(bus->fwname, QTN_PCI_PEARL_FW_NAME);
 	init_completion(&bus->request_firmware_complete);
 	mutex_init(&bus->bus_lock);
+	spin_lock_init(&pcie_priv->tx0_lock);
 	spin_lock_init(&pcie_priv->irq_lock);
 	spin_lock_init(&pcie_priv->tx_reclaim_lock);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
index e76a23716ee0..86ac1ccedb52 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
@@ -34,6 +34,8 @@ struct qtnf_pcie_bus_priv {
 
 	/* lock for tx reclaim operations */
 	spinlock_t tx_reclaim_lock;
+	/* lock for tx0 operations */
+	spinlock_t tx0_lock;
 	u8 msi_enabled;
 	int mps;
 
-- 
2.11.0
