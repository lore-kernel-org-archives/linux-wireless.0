Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0068.outbound.protection.outlook.com ([104.47.42.68]:39264
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750997AbdHONHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 09:07:07 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 7/9] qtnfmac: introduce counter for Rx underflow events
Date: Tue, 15 Aug 2017 16:06:37 +0300
Message-Id: <20170815130638.31718-8-sergey.matyukevich.os@quantenna.com> (sfid-20170815_150710_743493_F2F6C7D0)
In-Reply-To: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce counter for Rx underflow events. Export this counter via debugfs.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c      | 16 ++++++++++++++--
 .../net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h |  1 +
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h  |  1 +
 .../wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h   |  1 +
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index f8207ab25576..72730aff2a41 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -686,14 +686,21 @@ static irqreturn_t qtnf_interrupt(int irq, void *data)
 	if (!(status & priv->pcie_irq_mask))
 		goto irq_done;
 
-	if (status & PCIE_HDP_INT_RX_BITS) {
+	if (status & PCIE_HDP_INT_RX_BITS)
 		priv->pcie_irq_rx_count++;
+
+	if (status & PCIE_HDP_INT_TX_BITS)
+		priv->pcie_irq_tx_count++;
+
+	if (status & PCIE_HDP_INT_HHBM_UF)
+		priv->pcie_irq_uf_count++;
+
+	if (status & PCIE_HDP_INT_RX_BITS) {
 		qtnf_dis_rxdone_irq(priv);
 		napi_schedule(&bus->mux_napi);
 	}
 
 	if (status & PCIE_HDP_INT_TX_BITS) {
-		priv->pcie_irq_tx_count++;
 		qtnf_dis_txdone_irq(priv);
 		tasklet_hi_schedule(&priv->reclaim_tq);
 	}
@@ -1104,6 +1111,10 @@ static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
 	status = reg &  PCIE_HDP_INT_RX_BITS;
 	seq_printf(s, "pcie_irq_rx_status(%s)\n",
 		   (status == PCIE_HDP_INT_RX_BITS) ? "EN" : "DIS");
+	seq_printf(s, "pcie_irq_uf_count(%u)\n", priv->pcie_irq_uf_count);
+	status = reg &  PCIE_HDP_INT_HHBM_UF;
+	seq_printf(s, "pcie_irq_hhbm_uf_status(%s)\n",
+		   (status == PCIE_HDP_INT_HHBM_UF) ? "EN" : "DIS");
 
 	return 0;
 }
@@ -1189,6 +1200,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pcie_priv->pcie_irq_count = 0;
 	pcie_priv->pcie_irq_rx_count = 0;
 	pcie_priv->pcie_irq_tx_count = 0;
+	pcie_priv->pcie_irq_uf_count = 0;
 	pcie_priv->tx_reclaim_done = 0;
 	pcie_priv->tx_reclaim_req = 0;
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
index 1b37914299e9..698e42132ed4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
@@ -78,6 +78,7 @@ struct qtnf_pcie_bus_priv {
 	u32 pcie_irq_count;
 	u32 pcie_irq_rx_count;
 	u32 pcie_irq_tx_count;
+	u32 pcie_irq_uf_count;
 	u32 tx_full_count;
 	u32 tx_done_count;
 	u32 tx_reclaim_done;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
index e00d508fbcf0..667f5ec457e3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
@@ -50,6 +50,7 @@
 #define PCIE_HDP_INT_RX_BITS (0		\
 	| PCIE_HDP_INT_EP_TXDMA		\
 	| PCIE_HDP_INT_EP_TXEMPTY	\
+	| PCIE_HDP_INT_HHBM_UF		\
 	)
 
 #define PCIE_HDP_INT_TX_BITS (0		\
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
index 78715b8a8ef9..69696f118769 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
@@ -333,6 +333,7 @@
 #define PCIE_HDP_INT_RX_LEN_ERR		(BIT(2))
 #define PCIE_HDP_INT_RX_HDR_LEN_ERR	(BIT(3))
 #define PCIE_HDP_INT_EP_TXDMA		(BIT(12))
+#define PCIE_HDP_INT_HHBM_UF		(BIT(13))
 #define PCIE_HDP_INT_EP_TXEMPTY		(BIT(15))
 #define PCIE_HDP_INT_IPC		(BIT(29))
 
-- 
2.11.0
