Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0068.outbound.protection.outlook.com ([104.47.42.68]:39264
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751517AbdHONHF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 09:07:05 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 6/9] qtnfmac: switch to kernel circ_buf implementation
Date: Tue, 15 Aug 2017 16:06:36 +0300
Message-Id: <20170815130638.31718-7-sergey.matyukevich.os@quantenna.com> (sfid-20170815_150717_050046_46637204)
In-Reply-To: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current code for both Rx and Tx queue management is a custom and incomplete
circular buffer implementation. It makes a lot of sense to switch to kernel
built-in circ_buf implementation.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 206 +++++++++++++--------
 .../quantenna/qtnfmac/pearl/pcie_bus_priv.h        |  10 +-
 2 files changed, 136 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index f18e8a724c68..f8207ab25576 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -25,6 +25,7 @@
 #include <linux/completion.h>
 #include <linux/crc32.h>
 #include <linux/spinlock.h>
+#include <linux/circ_buf.h>
 
 #include "qtn_hw_ids.h"
 #include "pcie_bus_priv.h"
@@ -44,10 +45,6 @@ static unsigned int rx_bd_size_param = 256;
 module_param(rx_bd_size_param, uint, 0644);
 MODULE_PARM_DESC(rx_bd_size_param, "Rx descriptors queue size");
 
-static unsigned int rx_bd_reserved_param = 16;
-module_param(rx_bd_reserved_param, uint, 0644);
-MODULE_PARM_DESC(rx_bd_reserved_param, "Reserved RX descriptors");
-
 static u8 flashboot = 1;
 module_param(flashboot, byte, 0644);
 MODULE_PARM_DESC(flashboot, "set to 0 to use FW binary file on FS");
@@ -392,9 +389,8 @@ static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
 
 	pr_debug("TX descriptor table: vaddr=0x%p paddr=%pad\n", vaddr, &paddr);
 
-	priv->tx_bd_reclaim_start = 0;
-	priv->tx_bd_index = 0;
-	priv->tx_queue_len = 0;
+	priv->tx_bd_r_index = 0;
+	priv->tx_bd_w_index = 0;
 
 	/* rx bd */
 
@@ -413,8 +409,6 @@ static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
 
 	pr_debug("RX descriptor table: vaddr=0x%p paddr=%pad\n", vaddr, &paddr);
 
-	priv->rx_bd_index = 0;
-
 	return 0;
 }
 
@@ -445,6 +439,8 @@ static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 index)
 	rxbd->addr_h = cpu_to_le32(QTN_HOST_HI32(paddr));
 	rxbd->info = 0x0;
 
+	priv->rx_bd_w_index = index;
+
 	/* sync up all descriptor updates */
 	wmb();
 
@@ -510,6 +506,8 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_bus_priv *priv)
 
 	priv->tx_bd_num = tx_bd_size_param;
 	priv->rx_bd_num = rx_bd_size_param;
+	priv->rx_bd_w_index = 0;
+	priv->rx_bd_r_index = 0;
 
 	ret = alloc_skb_array(priv);
 	if (ret) {
@@ -532,67 +530,69 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_bus_priv *priv)
 	return ret;
 }
 
-static int qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_bus_priv *priv)
 {
 	struct qtnf_tx_bd *txbd;
 	struct sk_buff *skb;
 	dma_addr_t paddr;
-	int last_sent;
-	int count;
+	u32 tx_done_index;
+	int count = 0;
 	int i;
 
-	last_sent = readl(PCIE_HDP_RX0DMA_CNT(priv->pcie_reg_base))
-			% priv->tx_bd_num;
-	i = priv->tx_bd_reclaim_start;
-	count = 0;
 
-	while (i != last_sent) {
-		skb = priv->tx_skb[i];
-		if (!skb)
-			break;
+	tx_done_index = readl(PCIE_HDP_RX0DMA_CNT(priv->pcie_reg_base))
+			& (priv->tx_bd_num - 1);
 
-		txbd = &priv->tx_bd_vbase[i];
-		paddr = QTN_HOST_ADDR(le32_to_cpu(txbd->addr_h),
-				      le32_to_cpu(txbd->addr));
-		pci_unmap_single(priv->pdev, paddr, skb->len, PCI_DMA_TODEVICE);
+	i = priv->tx_bd_r_index;
 
-		if (skb->dev) {
-			skb->dev->stats.tx_packets++;
-			skb->dev->stats.tx_bytes += skb->len;
+	while (CIRC_CNT(tx_done_index, i, priv->tx_bd_num)) {
+		skb = priv->tx_skb[i];
+		if (likely(skb)) {
+			txbd = &priv->tx_bd_vbase[i];
+			paddr = QTN_HOST_ADDR(le32_to_cpu(txbd->addr_h),
+					      le32_to_cpu(txbd->addr));
+			pci_unmap_single(priv->pdev, paddr, skb->len,
+					 PCI_DMA_TODEVICE);
+
+			if (skb->dev) {
+				skb->dev->stats.tx_packets++;
+				skb->dev->stats.tx_bytes += skb->len;
+
+				if (netif_queue_stopped(skb->dev))
+					netif_wake_queue(skb->dev);
+			}
 
-			if (netif_queue_stopped(skb->dev))
-				netif_wake_queue(skb->dev);
+			dev_kfree_skb_any(skb);
 		}
 
-		dev_kfree_skb_any(skb);
 		priv->tx_skb[i] = NULL;
-		priv->tx_queue_len--;
 		count++;
 
 		if (++i >= priv->tx_bd_num)
 			i = 0;
 	}
 
-	priv->tx_bd_reclaim_start = i;
 	priv->tx_reclaim_done += count;
 	priv->tx_reclaim_req++;
+	priv->tx_bd_r_index = i;
 
-	return count;
 }
 
-static bool qtnf_tx_queue_ready(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_tx_queue_ready(struct qtnf_pcie_bus_priv *priv)
 {
-	if (priv->tx_queue_len >= priv->tx_bd_num - 1) {
+	if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
+			priv->tx_bd_num)) {
 		pr_err_ratelimited("reclaim full Tx queue\n");
 		qtnf_pcie_data_tx_reclaim(priv);
 
-		if (priv->tx_queue_len >= priv->tx_bd_num - 1) {
+		if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
+				priv->tx_bd_num)) {
 			priv->tx_full_count++;
-			return false;
+			return 0;
 		}
 	}
 
-	return true;
+	return 1;
 }
 
 static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
@@ -617,7 +617,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 		return NETDEV_TX_BUSY;
 	}
 
-	i = priv->tx_bd_index;
+	i = priv->tx_bd_w_index;
 	priv->tx_skb[i] = skb;
 	len = skb->len;
 
@@ -649,8 +649,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	if (++i >= priv->tx_bd_num)
 		i = 0;
 
-	priv->tx_bd_index = i;
-	priv->tx_queue_len++;
+	priv->tx_bd_w_index = i;
 
 tx_done:
 	if (ret && skb) {
@@ -709,16 +708,19 @@ static irqreturn_t qtnf_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static inline void hw_txproc_wr_ptr_inc(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_rx_data_ready(struct qtnf_pcie_bus_priv *priv)
 {
-	u32 index;
+	u16 index = priv->rx_bd_r_index;
+	struct qtnf_rx_bd *rxbd;
+	u32 descw;
 
-	index = priv->hw_txproc_wr_ptr;
+	rxbd = &priv->rx_bd_vbase[index];
+	descw = le32_to_cpu(rxbd->info);
 
-	if (++index >= priv->rx_bd_num)
-		index = 0;
+	if (descw & QTN_TXDONE_MASK)
+		return 1;
 
-	priv->hw_txproc_wr_ptr = index;
+	return 0;
 }
 
 static int qtnf_rx_poll(struct napi_struct *napi, int budget)
@@ -730,26 +732,52 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 	int processed = 0;
 	struct qtnf_rx_bd *rxbd;
 	dma_addr_t skb_paddr;
+	int consume;
 	u32 descw;
-	u16 index;
+	u32 psize;
+	u16 r_idx;
+	u16 w_idx;
 	int ret;
 
-	index = priv->rx_bd_index;
-	rxbd = &priv->rx_bd_vbase[index];
+	while (processed < budget) {
 
-	descw = le32_to_cpu(rxbd->info);
 
-	while ((descw & QTN_TXDONE_MASK) && (processed < budget)) {
-		skb = priv->rx_skb[index];
+		if (!qtnf_rx_data_ready(priv))
+			goto rx_out;
 
-		if (likely(skb)) {
-			skb_put(skb, QTN_GET_LEN(descw));
+		r_idx = priv->rx_bd_r_index;
+		rxbd = &priv->rx_bd_vbase[r_idx];
+		descw = le32_to_cpu(rxbd->info);
+
+		skb = priv->rx_skb[r_idx];
+		psize = QTN_GET_LEN(descw);
+		consume = 1;
 
+		if (!(descw & QTN_TXDONE_MASK)) {
+			pr_warn("skip invalid rxbd[%d]\n", r_idx);
+			consume = 0;
+		}
+
+		if (!skb) {
+			pr_warn("skip missing rx_skb[%d]\n", r_idx);
+			consume = 0;
+		}
+
+		if (skb && (skb_tailroom(skb) <  psize)) {
+			pr_err("skip packet with invalid length: %u > %u\n",
+			       psize, skb_tailroom(skb));
+			consume = 0;
+		}
+
+		if (skb) {
 			skb_paddr = QTN_HOST_ADDR(le32_to_cpu(rxbd->addr_h),
 						  le32_to_cpu(rxbd->addr));
 			pci_unmap_single(priv->pdev, skb_paddr, SKB_BUF_SIZE,
 					 PCI_DMA_FROMDEVICE);
+		}
 
+		if (consume) {
+			skb_put(skb, psize);
 			ndev = qtnf_classify_skb(bus, skb);
 			if (likely(ndev)) {
 				ndev->stats.rx_packets++;
@@ -762,30 +790,38 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 				bus->mux_dev.stats.rx_dropped++;
 				dev_kfree_skb_any(skb);
 			}
-
-			processed++;
 		} else {
-			pr_err("missing rx_skb[%d]\n", index);
+			if (skb) {
+				bus->mux_dev.stats.rx_dropped++;
+				dev_kfree_skb_any(skb);
+			}
 		}
 
-		/* attached rx buffer is passed upstream: map a new one */
-		ret = skb2rbd_attach(priv, index);
-		if (likely(!ret)) {
-			if (++index >= priv->rx_bd_num)
-				index = 0;
+		priv->rx_skb[r_idx] = NULL;
+		if (++r_idx >= priv->rx_bd_num)
+			r_idx = 0;
 
-			priv->rx_bd_index = index;
-			hw_txproc_wr_ptr_inc(priv);
+		priv->rx_bd_r_index = r_idx;
 
-			rxbd = &priv->rx_bd_vbase[index];
-			descw = le32_to_cpu(rxbd->info);
-		} else {
-			pr_err("failed to allocate new rx_skb[%d]\n", index);
-			break;
+		/* repalce processed buffer by a new one */
+		w_idx = priv->rx_bd_w_index;
+		while (CIRC_SPACE(priv->rx_bd_w_index, priv->rx_bd_r_index,
+				  priv->rx_bd_num) > 0) {
+			if (++w_idx >= priv->rx_bd_num)
+				w_idx = 0;
+
+			ret = skb2rbd_attach(priv, w_idx);
+			if (ret) {
+				pr_err("failed to allocate new rx_skb[%d]\n",
+				       w_idx);
+				break;
+			}
 		}
 
+		processed++;
 	}
 
+rx_out:
 	if (processed < budget) {
 		napi_complete(napi);
 		qtnf_en_rxdone_irq(priv);
@@ -1056,10 +1092,18 @@ static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
 	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	u32 reg = readl(PCIE_HDP_INT_EN(priv->pcie_reg_base));
+	u32 status;
 
 	seq_printf(s, "pcie_irq_count(%u)\n", priv->pcie_irq_count);
 	seq_printf(s, "pcie_irq_tx_count(%u)\n", priv->pcie_irq_tx_count);
+	status = reg &  PCIE_HDP_INT_TX_BITS;
+	seq_printf(s, "pcie_irq_tx_status(%s)\n",
+		   (status == PCIE_HDP_INT_TX_BITS) ? "EN" : "DIS");
 	seq_printf(s, "pcie_irq_rx_count(%u)\n", priv->pcie_irq_rx_count);
+	status = reg &  PCIE_HDP_INT_RX_BITS;
+	seq_printf(s, "pcie_irq_rx_status(%s)\n",
+		   (status == PCIE_HDP_INT_RX_BITS) ? "EN" : "DIS");
 
 	return 0;
 }
@@ -1073,10 +1117,24 @@ static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
 	seq_printf(s, "tx_done_count(%u)\n", priv->tx_done_count);
 	seq_printf(s, "tx_reclaim_done(%u)\n", priv->tx_reclaim_done);
 	seq_printf(s, "tx_reclaim_req(%u)\n", priv->tx_reclaim_req);
-	seq_printf(s, "tx_bd_reclaim_start(%u)\n", priv->tx_bd_reclaim_start);
-	seq_printf(s, "tx_bd_index(%u)\n", priv->tx_bd_index);
-	seq_printf(s, "rx_bd_index(%u)\n", priv->rx_bd_index);
-	seq_printf(s, "tx_queue_len(%u)\n", priv->tx_queue_len);
+
+	seq_printf(s, "tx_bd_r_index(%u)\n", priv->tx_bd_r_index);
+	seq_printf(s, "tx_bd_p_index(%u)\n",
+		   readl(PCIE_HDP_RX0DMA_CNT(priv->pcie_reg_base))
+			& (priv->tx_bd_num - 1));
+	seq_printf(s, "tx_bd_w_index(%u)\n", priv->tx_bd_w_index);
+	seq_printf(s, "tx queue len(%u)\n",
+		   CIRC_CNT(priv->tx_bd_w_index, priv->tx_bd_r_index,
+			    priv->tx_bd_num));
+
+	seq_printf(s, "rx_bd_r_index(%u)\n", priv->rx_bd_r_index);
+	seq_printf(s, "rx_bd_p_index(%u)\n",
+		   readl(PCIE_HDP_TX0DMA_CNT(priv->pcie_reg_base))
+			& (priv->rx_bd_num - 1));
+	seq_printf(s, "rx_bd_w_index(%u)\n", priv->rx_bd_w_index);
+	seq_printf(s, "rx alloc queue len(%u)\n",
+		   CIRC_SPACE(priv->rx_bd_w_index, priv->rx_bd_r_index,
+			      priv->rx_bd_num));
 
 	return 0;
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
index 2a897db2bd79..1b37914299e9 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
@@ -66,13 +66,11 @@ struct qtnf_pcie_bus_priv {
 	void *bd_table_vaddr;
 	u32 bd_table_len;
 
-	u32 hw_txproc_wr_ptr;
+	u32 rx_bd_w_index;
+	u32 rx_bd_r_index;
 
-	u16 tx_bd_reclaim_start;
-	u16 tx_bd_index;
-	u32 tx_queue_len;
-
-	u16 rx_bd_index;
+	u32 tx_bd_w_index;
+	u32 tx_bd_r_index;
 
 	u32 pcie_irq_mask;
 
-- 
2.11.0
