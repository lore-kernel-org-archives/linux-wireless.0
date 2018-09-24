Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A95C004D1
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62F1D204EC
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62F1D204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbeIYETt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:19:49 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46853 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1728588AbeIYETr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:47 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOD012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 03/11] qtnfmac_pcie: rename private Pearl PCIe state structure
Date:   Mon, 24 Sep 2018 15:15:06 -0700
Message-Id: <20180924221514.4273-4-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to extract common pcie driver state into a separate
structure, rename Pearl-specific state to qtnf_pcie_pearl_state and move
it directly to pearl-specific PCIe source file.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 158 +++++++++++++++------
 .../quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h   |  91 ------------
 2 files changed, 111 insertions(+), 138 deletions(-)
 delete mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 269a6e4..ab06eca 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -28,10 +28,12 @@
 #include <linux/circ_buf.h>
 #include <linux/log2.h>
 
+#include "pearl_pcie_regs.h"
+#include "pearl_pcie_ipc.h"
 #include "qtn_hw_ids.h"
-#include "pearl_pcie_bus_priv.h"
 #include "core.h"
 #include "bus.h"
+#include "shm_ipc.h"
 #include "debug.h"
 
 static bool use_msi = true;
@@ -52,6 +54,68 @@ MODULE_PARM_DESC(flashboot, "set to 0 to use FW binary file on FS");
 
 #define DRV_NAME	"qtnfmac_pearl_pcie"
 
+struct qtnf_pcie_pearl_state {
+	struct pci_dev  *pdev;
+
+	/* lock for irq configuration changes */
+	spinlock_t irq_lock;
+
+	/* lock for tx reclaim operations */
+	spinlock_t tx_reclaim_lock;
+	/* lock for tx0 operations */
+	spinlock_t tx0_lock;
+	u8 msi_enabled;
+	u8 tx_stopped;
+	int mps;
+
+	struct workqueue_struct *workqueue;
+	struct tasklet_struct reclaim_tq;
+
+	void __iomem *sysctl_bar;
+	void __iomem *epmem_bar;
+	void __iomem *dmareg_bar;
+
+	struct qtnf_shm_ipc shm_ipc_ep_in;
+	struct qtnf_shm_ipc shm_ipc_ep_out;
+
+	struct qtnf_pcie_bda __iomem *bda;
+	void __iomem *pcie_reg_base;
+
+	u16 tx_bd_num;
+	u16 rx_bd_num;
+
+	struct sk_buff **tx_skb;
+	struct sk_buff **rx_skb;
+
+	struct qtnf_tx_bd *tx_bd_vbase;
+	dma_addr_t tx_bd_pbase;
+
+	struct qtnf_rx_bd *rx_bd_vbase;
+	dma_addr_t rx_bd_pbase;
+
+	dma_addr_t bd_table_paddr;
+	void *bd_table_vaddr;
+	u32 bd_table_len;
+
+	u32 rx_bd_w_index;
+	u32 rx_bd_r_index;
+
+	u32 tx_bd_w_index;
+	u32 tx_bd_r_index;
+
+	u32 pcie_irq_mask;
+
+	/* diagnostics stats */
+	u32 pcie_irq_count;
+	u32 pcie_irq_rx_count;
+	u32 pcie_irq_tx_count;
+	u32 pcie_irq_uf_count;
+	u32 tx_full_count;
+	u32 tx_done_count;
+	u32 tx_reclaim_done;
+	u32 tx_reclaim_req;
+};
+
 static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
 {
 	writel(val, basereg);
@@ -60,7 +124,7 @@ static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
 	readl(basereg);
 }
 
-static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
 
@@ -69,7 +133,7 @@ static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
 
-static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
 
@@ -78,7 +142,7 @@ static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
 
-static inline void qtnf_disable_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_disable_hdp_irqs(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
 
@@ -87,7 +151,7 @@ static inline void qtnf_disable_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
 
-static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
 
@@ -97,7 +161,7 @@ static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
 
-static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
 
@@ -107,7 +171,7 @@ static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
 
-static inline void qtnf_en_txdone_irq(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_en_txdone_irq(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
 
@@ -117,7 +181,7 @@ static inline void qtnf_en_txdone_irq(struct qtnf_pcie_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
 
-static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
 
@@ -127,7 +191,7 @@ static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
 
-static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_pcie_init_irq(struct qtnf_pcie_pearl_state *priv)
 {
 	struct pci_dev *pdev = priv->pdev;
 
@@ -150,7 +214,7 @@ static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
 	}
 }
 
-static void qtnf_deassert_intx(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_deassert_intx(struct qtnf_pcie_pearl_state *priv)
 {
 	void __iomem *reg = priv->sysctl_bar + PEARL_PCIE_CFG0_OFFSET;
 	u32 cfg;
@@ -160,7 +224,7 @@ static void qtnf_deassert_intx(struct qtnf_pcie_bus_priv *priv)
 	qtnf_non_posted_write(cfg, reg);
 }
 
-static void qtnf_reset_card(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_reset_card(struct qtnf_pcie_pearl_state *priv)
 {
 	const u32 data = QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_EP_RESET);
 	void __iomem *reg = priv->sysctl_bar +
@@ -173,7 +237,7 @@ static void qtnf_reset_card(struct qtnf_pcie_bus_priv *priv)
 
 static void qtnf_ipc_gen_ep_int(void *arg)
 {
-	const struct qtnf_pcie_bus_priv *priv = arg;
+	const struct qtnf_pcie_pearl_state *priv = arg;
 	const u32 data = QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_IPC_IRQ);
 	void __iomem *reg = priv->sysctl_bar +
 			    QTN_PEARL_SYSCTL_LHOST_IRQ_OFFSET;
@@ -181,7 +245,7 @@ static void qtnf_ipc_gen_ep_int(void *arg)
 	qtnf_non_posted_write(data, reg);
 }
 
-static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 index)
+static void __iomem *qtnf_map_bar(struct qtnf_pcie_pearl_state *priv, u8 index)
 {
 	void __iomem *vaddr;
 	dma_addr_t busaddr;
@@ -206,7 +270,7 @@ static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 index)
 
 static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t len)
 {
-	struct qtnf_pcie_bus_priv *priv = arg;
+	struct qtnf_pcie_pearl_state *priv = arg;
 	struct qtnf_bus *bus = pci_get_drvdata(priv->pdev);
 	struct sk_buff *skb;
 
@@ -227,7 +291,7 @@ static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t len)
 	qtnf_trans_handle_rx_ctl_packet(bus, skb);
 }
 
-static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_pearl_state *priv)
 {
 	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
 	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
@@ -248,13 +312,13 @@ static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv)
 	return 0;
 }
 
-static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_pearl_state *priv)
 {
 	qtnf_shm_ipc_free(&priv->shm_ipc_ep_in);
 	qtnf_shm_ipc_free(&priv->shm_ipc_ep_out);
 }
 
-static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_pcie_init_memory(struct qtnf_pcie_pearl_state *priv)
 {
 	int ret = -ENOMEM;
 
@@ -283,7 +347,7 @@ static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_priv *priv)
 	return 0;
 }
 
-static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_tune_pcie_mps(struct qtnf_pcie_pearl_state *priv)
 {
 	struct pci_dev *pdev = priv->pdev;
 	struct pci_dev *parent;
@@ -355,7 +419,7 @@ static int qtnf_poll_state(__le32 __iomem *reg, u32 state, u32 delay_in_ms)
 	return 0;
 }
 
-static int alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
+static int alloc_skb_array(struct qtnf_pcie_pearl_state *priv)
 {
 	struct sk_buff **vaddr;
 	int len;
@@ -375,7 +439,7 @@ static int alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
 	return 0;
 }
 
-static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
+static int alloc_bd_table(struct qtnf_pcie_pearl_state *priv)
 {
 	dma_addr_t paddr;
 	void *vaddr;
@@ -426,7 +490,7 @@ static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
 	return 0;
 }
 
-static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 index)
+static int skb2rbd_attach(struct qtnf_pcie_pearl_state *priv, u16 index)
 {
 	struct qtnf_rx_bd *rxbd;
 	struct sk_buff *skb;
@@ -469,7 +533,7 @@ static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 index)
 	return 0;
 }
 
-static int alloc_rx_buffers(struct qtnf_pcie_bus_priv *priv)
+static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *priv)
 {
 	u16 i;
 	int ret = 0;
@@ -487,7 +551,7 @@ static int alloc_rx_buffers(struct qtnf_pcie_bus_priv *priv)
 }
 
 /* all rx/tx activity should have ceased before calling this function */
-static void qtnf_free_xfer_buffers(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *priv)
 {
 	struct qtnf_tx_bd *txbd;
 	struct qtnf_rx_bd *rxbd;
@@ -524,7 +588,7 @@ static void qtnf_free_xfer_buffers(struct qtnf_pcie_bus_priv *priv)
 	}
 }
 
-static int qtnf_hhbm_init(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_hhbm_init(struct qtnf_pcie_pearl_state *priv)
 {
 	u32 val;
 
@@ -542,7 +606,7 @@ static int qtnf_hhbm_init(struct qtnf_pcie_bus_priv *priv)
 	return 0;
 }
 
-static int qtnf_pcie_init_xfer(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *priv)
 {
 	int ret;
 	u32 val;
@@ -605,7 +669,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_bus_priv *priv)
 	return ret;
 }
 
-static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *priv)
 {
 	struct qtnf_tx_bd *txbd;
 	struct sk_buff *skb;
@@ -656,7 +720,7 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->tx_reclaim_lock, flags);
 }
 
-static int qtnf_tx_queue_ready(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_state *priv)
 {
 	if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 			priv->tx_bd_num)) {
@@ -675,7 +739,7 @@ static int qtnf_tx_queue_ready(struct qtnf_pcie_bus_priv *priv)
 
 static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
-	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
 	dma_addr_t txbd_paddr, skb_paddr;
 	struct qtnf_tx_bd *txbd;
 	unsigned long flags;
@@ -750,7 +814,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 
 static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
-	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
 	int ret;
 
 	ret = qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
@@ -766,7 +830,7 @@ static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 static irqreturn_t qtnf_interrupt(int irq, void *data)
 {
 	struct qtnf_bus *bus = (struct qtnf_bus *)data;
-	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
 	u32 status;
 
 	priv->pcie_irq_count++;
@@ -807,7 +871,7 @@ static irqreturn_t qtnf_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int qtnf_rx_data_ready(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_state *priv)
 {
 	u16 index = priv->rx_bd_r_index;
 	struct qtnf_rx_bd *rxbd;
@@ -825,7 +889,7 @@ static int qtnf_rx_data_ready(struct qtnf_pcie_bus_priv *priv)
 static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct qtnf_bus *bus = container_of(napi, struct qtnf_bus, mux_napi);
-	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
 	struct net_device *ndev = NULL;
 	struct sk_buff *skb = NULL;
 	int processed = 0;
@@ -930,14 +994,14 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 static void
 qtnf_pcie_data_tx_timeout(struct qtnf_bus *bus, struct net_device *ndev)
 {
-	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
 
 	tasklet_hi_schedule(&priv->reclaim_tq);
 }
 
 static void qtnf_pcie_data_rx_start(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
 
 	qtnf_enable_hdp_irqs(priv);
 	napi_enable(&bus->mux_napi);
@@ -945,7 +1009,7 @@ static void qtnf_pcie_data_rx_start(struct qtnf_bus *bus)
 
 static void qtnf_pcie_data_rx_stop(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
 
 	napi_disable(&bus->mux_napi);
 	qtnf_disable_hdp_irqs(priv);
@@ -965,7 +1029,7 @@ static const struct qtnf_bus_ops qtnf_pcie_bus_ops = {
 static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = get_bus_priv(bus);
 
 	seq_printf(s, "%d\n", priv->mps);
 
@@ -975,7 +1039,7 @@ static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
 static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = get_bus_priv(bus);
 
 	seq_printf(s, "%u\n", priv->msi_enabled);
 
@@ -985,7 +1049,7 @@ static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
 static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = get_bus_priv(bus);
 	u32 reg = readl(PCIE_HDP_INT_EN(priv->pcie_reg_base));
 	u32 status;
 
@@ -1009,7 +1073,7 @@ static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
 static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = get_bus_priv(bus);
 
 	seq_printf(s, "tx_full_count(%u)\n", priv->tx_full_count);
 	seq_printf(s, "tx_done_count(%u)\n", priv->tx_done_count);
@@ -1040,7 +1104,7 @@ static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
 static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = get_bus_priv(bus);
 
 	seq_printf(s, "shm_ipc_ep_in.tx_packet_count(%zu)\n",
 		   priv->shm_ipc_ep_in.tx_packet_count);
@@ -1054,7 +1118,7 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int qtnf_ep_fw_send(struct qtnf_pcie_bus_priv *priv, uint32_t size,
+static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *priv, uint32_t size,
 			   int blk, const u8 *pblk, const u8 *fw)
 {
 	struct pci_dev *pdev = priv->pdev;
@@ -1103,7 +1167,7 @@ static int qtnf_ep_fw_send(struct qtnf_pcie_bus_priv *priv, uint32_t size,
 }
 
 static int
-qtnf_ep_fw_load(struct qtnf_pcie_bus_priv *priv, const u8 *fw, u32 fw_size)
+qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv, const u8 *fw, u32 fw_size)
 {
 	int blk_size = QTN_PCIE_FW_BUFSZ - sizeof(struct qtnf_pcie_fw_hdr);
 	int blk_count = fw_size / blk_size + ((fw_size % blk_size) ? 1 : 0);
@@ -1172,7 +1236,7 @@ qtnf_ep_fw_load(struct qtnf_pcie_bus_priv *priv, const u8 *fw, u32 fw_size)
 static void qtnf_fw_work_handler(struct work_struct *work)
 {
 	struct qtnf_bus *bus = container_of(work, struct qtnf_bus, fw_work);
-	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
 	struct pci_dev *pdev = priv->pdev;
 	const struct firmware *fw;
 	int ret;
@@ -1256,7 +1320,7 @@ static void qtnf_fw_work_handler(struct work_struct *work)
 
 static void qtnf_bringup_fw_async(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
 	struct pci_dev *pdev = priv->pdev;
 
 	get_device(&pdev->dev);
@@ -1266,7 +1330,7 @@ static void qtnf_bringup_fw_async(struct qtnf_bus *bus)
 
 static void qtnf_reclaim_tasklet_fn(unsigned long data)
 {
-	struct qtnf_pcie_bus_priv *priv = (void *)data;
+	struct qtnf_pcie_pearl_state *priv = (void *)data;
 
 	qtnf_pcie_data_tx_reclaim(priv);
 	qtnf_en_txdone_irq(priv);
@@ -1274,7 +1338,7 @@ static void qtnf_reclaim_tasklet_fn(unsigned long data)
 
 static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct qtnf_pcie_bus_priv *pcie_priv;
+	struct qtnf_pcie_pearl_state *pcie_priv;
 	struct qtnf_bus *bus;
 	int ret;
 
@@ -1407,7 +1471,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void qtnf_pcie_remove(struct pci_dev *pdev)
 {
-	struct qtnf_pcie_bus_priv *priv;
+	struct qtnf_pcie_pearl_state *priv;
 	struct qtnf_bus *bus;
 
 	bus = pci_get_drvdata(pdev);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
deleted file mode 100644
index 986b957..0000000
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
+++ /dev/null
@@ -1,91 +0,0 @@
-/*
- * Copyright (c) 2015-2016 Quantenna Communications, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef _QTN_FMAC_PCIE_H_
-#define _QTN_FMAC_PCIE_H_
-
-#include <linux/dma-mapping.h>
-#include <linux/io.h>
-
-#include "pearl_pcie_regs.h"
-#include "pearl_pcie_ipc.h"
-#include "shm_ipc.h"
-
-struct bus;
-
-struct qtnf_pcie_bus_priv {
-	struct pci_dev  *pdev;
-
-	/* lock for irq configuration changes */
-	spinlock_t irq_lock;
-
-	/* lock for tx reclaim operations */
-	spinlock_t tx_reclaim_lock;
-	/* lock for tx0 operations */
-	spinlock_t tx0_lock;
-	u8 msi_enabled;
-	u8 tx_stopped;
-	int mps;
-
-	struct workqueue_struct *workqueue;
-	struct tasklet_struct reclaim_tq;
-
-	void __iomem *sysctl_bar;
-	void __iomem *epmem_bar;
-	void __iomem *dmareg_bar;
-
-	struct qtnf_shm_ipc shm_ipc_ep_in;
-	struct qtnf_shm_ipc shm_ipc_ep_out;
-
-	struct qtnf_pcie_bda __iomem *bda;
-	void __iomem *pcie_reg_base;
-
-	u16 tx_bd_num;
-	u16 rx_bd_num;
-
-	struct sk_buff **tx_skb;
-	struct sk_buff **rx_skb;
-
-	struct qtnf_tx_bd *tx_bd_vbase;
-	dma_addr_t tx_bd_pbase;
-
-	struct qtnf_rx_bd *rx_bd_vbase;
-	dma_addr_t rx_bd_pbase;
-
-	dma_addr_t bd_table_paddr;
-	void *bd_table_vaddr;
-	u32 bd_table_len;
-
-	u32 rx_bd_w_index;
-	u32 rx_bd_r_index;
-
-	u32 tx_bd_w_index;
-	u32 tx_bd_r_index;
-
-	u32 pcie_irq_mask;
-
-	/* diagnostics stats */
-	u32 pcie_irq_count;
-	u32 pcie_irq_rx_count;
-	u32 pcie_irq_tx_count;
-	u32 pcie_irq_uf_count;
-	u32 tx_full_count;
-	u32 tx_done_count;
-	u32 tx_reclaim_done;
-	u32 tx_reclaim_req;
-};
-
-#endif /* _QTN_FMAC_PCIE_H_ */
-- 
2.9.5

