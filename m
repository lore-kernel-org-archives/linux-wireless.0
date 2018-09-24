Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422D6C004D1
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6E88204EC
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:16:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6E88204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbeIYEUf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:20:35 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46850 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1728574AbeIYETr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:47 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOG012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 06/11] qtnfmac_pcie: separate platform-independent PCIe structure
Date:   Mon, 24 Sep 2018 15:15:09 -0700
Message-Id: <20180924221514.4273-7-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move platform-independent PCIe data structure to a separate header file
so it can be reused by different devices.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |  70 +++
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 471 ++++++++++-----------
 .../quantenna/qtnfmac/pcie/pearl_pcie_ipc.h        |   7 -
 3 files changed, 287 insertions(+), 261 deletions(-)
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
new file mode 100644
index 0000000..8da9612
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2018 Quantenna Communications, Inc. All rights reserved. */
+
+#ifndef _QTN_FMAC_PCIE_H_
+#define _QTN_FMAC_PCIE_H_
+
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/skbuff.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+
+#include "shm_ipc.h"
+
+#define SKB_BUF_SIZE		2048
+
+#define QTN_FW_DL_TIMEOUT_MS	3000
+#define QTN_FW_QLINK_TIMEOUT_MS	30000
+#define QTN_EP_RESET_WAIT_MS	1000
+
+struct qtnf_pcie_bus_priv {
+	struct pci_dev *pdev;
+
+	spinlock_t tx_reclaim_lock;
+	spinlock_t tx_lock;
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
+	u16 tx_bd_num;
+	u16 rx_bd_num;
+
+	struct sk_buff **tx_skb;
+	struct sk_buff **rx_skb;
+
+	u32 rx_bd_w_index;
+	u32 rx_bd_r_index;
+
+	u32 tx_bd_w_index;
+	u32 tx_bd_r_index;
+
+	/* diagnostics stats */
+	u32 pcie_irq_count;
+	u32 tx_full_count;
+	u32 tx_done_count;
+	u32 tx_reclaim_done;
+	u32 tx_reclaim_req;
+
+	u8 msi_enabled;
+	u8 tx_stopped;
+};
+
+static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
+{
+	writel(val, basereg);
+
+	/* flush posted write */
+	readl(basereg);
+}
+
+#endif /* _QTN_FMAC_PCIE_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 791a1e3..97f3001 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -28,6 +28,7 @@
 #include <linux/circ_buf.h>
 #include <linux/log2.h>
 
+#include "pcie_priv.h"
 #include "pearl_pcie_regs.h"
 #include "pearl_pcie_ipc.h"
 #include "qtn_hw_ids.h"
@@ -102,38 +103,14 @@ struct qtnf_pearl_fw_hdr {
 } __packed;
 
 struct qtnf_pcie_pearl_state {
-	struct pci_dev  *pdev;
+	struct qtnf_pcie_bus_priv base;
 
 	/* lock for irq configuration changes */
 	spinlock_t irq_lock;
 
-	/* lock for tx reclaim operations */
-	spinlock_t tx_reclaim_lock;
-	/* lock for tx0 operations */
-	spinlock_t tx_lock;
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
 	struct qtnf_pearl_bda __iomem *bda;
 	void __iomem *pcie_reg_base;
 
-	u16 tx_bd_num;
-	u16 rx_bd_num;
-
-	struct sk_buff **tx_skb;
-	struct sk_buff **rx_skb;
-
 	struct qtnf_pearl_tx_bd *tx_bd_vbase;
 	dma_addr_t tx_bd_pbase;
 
@@ -143,102 +120,80 @@ struct qtnf_pcie_pearl_state {
 	dma_addr_t bd_table_paddr;
 	void *bd_table_vaddr;
 	u32 bd_table_len;
-
-	u32 rx_bd_w_index;
-	u32 rx_bd_r_index;
-
-	u32 tx_bd_w_index;
-	u32 tx_bd_r_index;
-
 	u32 pcie_irq_mask;
-
-	/* diagnostics stats */
-	u32 pcie_irq_count;
 	u32 pcie_irq_rx_count;
 	u32 pcie_irq_tx_count;
 	u32 pcie_irq_uf_count;
-	u32 tx_full_count;
-	u32 tx_done_count;
-	u32 tx_reclaim_done;
-	u32 tx_reclaim_req;
 };
 
-static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
-{
-	writel(val, basereg);
-
-	/* flush posted write */
-	readl(basereg);
-}
-
-static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	priv->pcie_irq_mask = (PCIE_HDP_INT_RX_BITS | PCIE_HDP_INT_TX_BITS);
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	ps->pcie_irq_mask = (PCIE_HDP_INT_RX_BITS | PCIE_HDP_INT_TX_BITS);
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
 
-static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	writel(ps->pcie_irq_mask, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
 
-static inline void qtnf_disable_hdp_irqs(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_disable_hdp_irqs(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	writel(0x0, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	writel(0x0, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
 
-static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	priv->pcie_irq_mask |= PCIE_HDP_INT_RX_BITS;
-	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	ps->pcie_irq_mask |= PCIE_HDP_INT_RX_BITS;
+	writel(ps->pcie_irq_mask, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
 
-static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	priv->pcie_irq_mask &= ~PCIE_HDP_INT_RX_BITS;
-	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	ps->pcie_irq_mask &= ~PCIE_HDP_INT_RX_BITS;
+	writel(ps->pcie_irq_mask, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
 
-static inline void qtnf_en_txdone_irq(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_en_txdone_irq(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	priv->pcie_irq_mask |= PCIE_HDP_INT_TX_BITS;
-	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	ps->pcie_irq_mask |= PCIE_HDP_INT_TX_BITS;
+	writel(ps->pcie_irq_mask, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
 
-static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	priv->pcie_irq_mask &= ~PCIE_HDP_INT_TX_BITS;
-	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	ps->pcie_irq_mask &= ~PCIE_HDP_INT_TX_BITS;
+	writel(ps->pcie_irq_mask, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
 
-static void qtnf_pcie_init_irq(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
 {
 	struct pci_dev *pdev = priv->pdev;
 
@@ -261,9 +216,9 @@ static void qtnf_pcie_init_irq(struct qtnf_pcie_pearl_state *priv)
 	}
 }
 
-static void qtnf_deassert_intx(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_deassert_intx(struct qtnf_pcie_pearl_state *ps)
 {
-	void __iomem *reg = priv->sysctl_bar + PEARL_PCIE_CFG0_OFFSET;
+	void __iomem *reg = ps->base.sysctl_bar + PEARL_PCIE_CFG0_OFFSET;
 	u32 cfg;
 
 	cfg = readl(reg);
@@ -271,28 +226,28 @@ static void qtnf_deassert_intx(struct qtnf_pcie_pearl_state *priv)
 	qtnf_non_posted_write(cfg, reg);
 }
 
-static void qtnf_reset_card(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_reset_card(struct qtnf_pcie_pearl_state *ps)
 {
 	const u32 data = QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_EP_RESET);
-	void __iomem *reg = priv->sysctl_bar +
+	void __iomem *reg = ps->base.sysctl_bar +
 			    QTN_PEARL_SYSCTL_LHOST_IRQ_OFFSET;
 
 	qtnf_non_posted_write(data, reg);
 	msleep(QTN_EP_RESET_WAIT_MS);
-	pci_restore_state(priv->pdev);
+	pci_restore_state(ps->base.pdev);
 }
 
 static void qtnf_ipc_gen_ep_int(void *arg)
 {
-	const struct qtnf_pcie_pearl_state *priv = arg;
+	const struct qtnf_pcie_pearl_state *ps = arg;
 	const u32 data = QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_IPC_IRQ);
-	void __iomem *reg = priv->sysctl_bar +
+	void __iomem *reg = ps->base.sysctl_bar +
 			    QTN_PEARL_SYSCTL_LHOST_IRQ_OFFSET;
 
 	qtnf_non_posted_write(data, reg);
 }
 
-static void __iomem *qtnf_map_bar(struct qtnf_pcie_pearl_state *priv, u8 index)
+static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 index)
 {
 	void __iomem *vaddr;
 	dma_addr_t busaddr;
@@ -317,7 +272,7 @@ static void __iomem *qtnf_map_bar(struct qtnf_pcie_pearl_state *priv, u8 index)
 
 static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t len)
 {
-	struct qtnf_pcie_pearl_state *priv = arg;
+	struct qtnf_pcie_bus_priv *priv = arg;
 	struct qtnf_bus *bus = pci_get_drvdata(priv->pdev);
 	struct sk_buff *skb;
 
@@ -338,35 +293,36 @@ static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t len)
 	qtnf_trans_handle_rx_ctl_packet(bus, skb);
 }
 
-static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
 	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
-	const struct qtnf_shm_ipc_int ipc_int = { qtnf_ipc_gen_ep_int, priv };
+	const struct qtnf_shm_ipc_int ipc_int = { qtnf_ipc_gen_ep_int, ps };
 	const struct qtnf_shm_ipc_rx_callback rx_callback = {
-					qtnf_pcie_control_rx_callback, priv };
+					qtnf_pcie_control_rx_callback, ps };
 
-	ipc_tx_reg = &priv->bda->bda_shm_reg1;
-	ipc_rx_reg = &priv->bda->bda_shm_reg2;
+	ipc_tx_reg = &ps->bda->bda_shm_reg1;
+	ipc_rx_reg = &ps->bda->bda_shm_reg2;
 
-	qtnf_shm_ipc_init(&priv->shm_ipc_ep_in, QTNF_SHM_IPC_OUTBOUND,
-			  ipc_tx_reg, priv->workqueue,
+	qtnf_shm_ipc_init(&ps->base.shm_ipc_ep_in, QTNF_SHM_IPC_OUTBOUND,
+			  ipc_tx_reg, ps->base.workqueue,
 			  &ipc_int, &rx_callback);
-	qtnf_shm_ipc_init(&priv->shm_ipc_ep_out, QTNF_SHM_IPC_INBOUND,
-			  ipc_rx_reg, priv->workqueue,
+	qtnf_shm_ipc_init(&ps->base.shm_ipc_ep_out, QTNF_SHM_IPC_INBOUND,
+			  ipc_rx_reg, ps->base.workqueue,
 			  &ipc_int, &rx_callback);
 
 	return 0;
 }
 
-static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus_priv *priv)
 {
 	qtnf_shm_ipc_free(&priv->shm_ipc_ep_in);
 	qtnf_shm_ipc_free(&priv->shm_ipc_ep_out);
 }
 
-static int qtnf_pcie_init_memory(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_pcie_init_memory(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	int ret = -ENOMEM;
 
 	priv->sysctl_bar = qtnf_map_bar(priv, QTN_SYSCTL_BAR);
@@ -387,14 +343,14 @@ static int qtnf_pcie_init_memory(struct qtnf_pcie_pearl_state *priv)
 		return ret;
 	}
 
-	priv->pcie_reg_base = priv->dmareg_bar;
-	priv->bda = priv->epmem_bar;
-	writel(priv->msi_enabled, &priv->bda->bda_rc_msi_enabled);
+	ps->pcie_reg_base = priv->dmareg_bar;
+	ps->bda = priv->epmem_bar;
+	writel(priv->msi_enabled, &ps->bda->bda_rc_msi_enabled);
 
 	return 0;
 }
 
-static void qtnf_tune_pcie_mps(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
 {
 	struct pci_dev *pdev = priv->pdev;
 	struct pci_dev *parent;
@@ -466,7 +422,7 @@ static int qtnf_poll_state(__le32 __iomem *reg, u32 state, u32 delay_in_ms)
 	return 0;
 }
 
-static int alloc_skb_array(struct qtnf_pcie_pearl_state *priv)
+static int alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
 {
 	struct sk_buff **vaddr;
 	int len;
@@ -486,8 +442,9 @@ static int alloc_skb_array(struct qtnf_pcie_pearl_state *priv)
 	return 0;
 }
 
-static int alloc_bd_table(struct qtnf_pcie_pearl_state *priv)
+static int alloc_bd_table(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	dma_addr_t paddr;
 	void *vaddr;
 	int len;
@@ -503,12 +460,12 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state *priv)
 
 	memset(vaddr, 0, len);
 
-	priv->bd_table_vaddr = vaddr;
-	priv->bd_table_paddr = paddr;
-	priv->bd_table_len = len;
+	ps->bd_table_vaddr = vaddr;
+	ps->bd_table_paddr = paddr;
+	ps->bd_table_len = len;
 
-	priv->tx_bd_vbase = vaddr;
-	priv->tx_bd_pbase = paddr;
+	ps->tx_bd_vbase = vaddr;
+	ps->tx_bd_pbase = paddr;
 
 	pr_debug("TX descriptor table: vaddr=0x%p paddr=%pad\n", vaddr, &paddr);
 
@@ -520,25 +477,26 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state *priv)
 	vaddr = ((struct qtnf_pearl_tx_bd *)vaddr) + priv->tx_bd_num;
 	paddr += priv->tx_bd_num * sizeof(struct qtnf_pearl_tx_bd);
 
-	priv->rx_bd_vbase = vaddr;
-	priv->rx_bd_pbase = paddr;
+	ps->rx_bd_vbase = vaddr;
+	ps->rx_bd_pbase = paddr;
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	writel(QTN_HOST_HI32(paddr),
-	       PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
+	       PCIE_HDP_TX_HOST_Q_BASE_H(ps->pcie_reg_base));
 #endif
 	writel(QTN_HOST_LO32(paddr),
-	       PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
+	       PCIE_HDP_TX_HOST_Q_BASE_L(ps->pcie_reg_base));
 	writel(priv->rx_bd_num | (sizeof(struct qtnf_pearl_rx_bd)) << 16,
-	       PCIE_HDP_TX_HOST_Q_SZ_CTRL(priv->pcie_reg_base));
+	       PCIE_HDP_TX_HOST_Q_SZ_CTRL(ps->pcie_reg_base));
 
 	pr_debug("RX descriptor table: vaddr=0x%p paddr=%pad\n", vaddr, &paddr);
 
 	return 0;
 }
 
-static int skb2rbd_attach(struct qtnf_pcie_pearl_state *priv, u16 index)
+static int skb2rbd_attach(struct qtnf_pcie_pearl_state *ps, u16 index)
 {
+	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	struct qtnf_pearl_rx_bd *rxbd;
 	struct sk_buff *skb;
 	dma_addr_t paddr;
@@ -550,7 +508,7 @@ static int skb2rbd_attach(struct qtnf_pcie_pearl_state *priv, u16 index)
 	}
 
 	priv->rx_skb[index] = skb;
-	rxbd = &priv->rx_bd_vbase[index];
+	rxbd = &ps->rx_bd_vbase[index];
 
 	paddr = pci_map_single(priv->pdev, skb->data,
 			       SKB_BUF_SIZE, PCI_DMA_FROMDEVICE);
@@ -571,25 +529,25 @@ static int skb2rbd_attach(struct qtnf_pcie_pearl_state *priv, u16 index)
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	writel(QTN_HOST_HI32(paddr),
-	       PCIE_HDP_HHBM_BUF_PTR_H(priv->pcie_reg_base));
+	       PCIE_HDP_HHBM_BUF_PTR_H(ps->pcie_reg_base));
 #endif
 	writel(QTN_HOST_LO32(paddr),
-	       PCIE_HDP_HHBM_BUF_PTR(priv->pcie_reg_base));
+	       PCIE_HDP_HHBM_BUF_PTR(ps->pcie_reg_base));
 
-	writel(index, PCIE_HDP_TX_HOST_Q_WR_PTR(priv->pcie_reg_base));
+	writel(index, PCIE_HDP_TX_HOST_Q_WR_PTR(ps->pcie_reg_base));
 	return 0;
 }
 
-static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *priv)
+static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *ps)
 {
 	u16 i;
 	int ret = 0;
 
-	memset(priv->rx_bd_vbase, 0x0,
-	       priv->rx_bd_num * sizeof(struct qtnf_pearl_rx_bd));
+	memset(ps->rx_bd_vbase, 0x0,
+	       ps->base.rx_bd_num * sizeof(struct qtnf_pearl_rx_bd));
 
-	for (i = 0; i < priv->rx_bd_num; i++) {
-		ret = skb2rbd_attach(priv, i);
+	for (i = 0; i < ps->base.rx_bd_num; i++) {
+		ret = skb2rbd_attach(ps, i);
 		if (ret)
 			break;
 	}
@@ -598,8 +556,9 @@ static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *priv)
 }
 
 /* all rx/tx activity should have ceased before calling this function */
-static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	struct qtnf_pearl_tx_bd *txbd;
 	struct qtnf_pearl_rx_bd *rxbd;
 	struct sk_buff *skb;
@@ -609,7 +568,7 @@ static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *priv)
 	/* free rx buffers */
 	for (i = 0; i < priv->rx_bd_num; i++) {
 		if (priv->rx_skb && priv->rx_skb[i]) {
-			rxbd = &priv->rx_bd_vbase[i];
+			rxbd = &ps->rx_bd_vbase[i];
 			skb = priv->rx_skb[i];
 			paddr = QTN_HOST_ADDR(le32_to_cpu(rxbd->addr_h),
 					      le32_to_cpu(rxbd->addr));
@@ -623,7 +582,7 @@ static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *priv)
 	/* free tx buffers */
 	for (i = 0; i < priv->tx_bd_num; i++) {
 		if (priv->tx_skb && priv->tx_skb[i]) {
-			txbd = &priv->tx_bd_vbase[i];
+			txbd = &ps->tx_bd_vbase[i];
 			skb = priv->tx_skb[i];
 			paddr = QTN_HOST_ADDR(le32_to_cpu(txbd->addr_h),
 					      le32_to_cpu(txbd->addr));
@@ -635,26 +594,27 @@ static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *priv)
 	}
 }
 
-static int qtnf_hhbm_init(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_hhbm_init(struct qtnf_pcie_pearl_state *ps)
 {
 	u32 val;
 
-	val = readl(PCIE_HHBM_CONFIG(priv->pcie_reg_base));
+	val = readl(PCIE_HHBM_CONFIG(ps->pcie_reg_base));
 	val |= HHBM_CONFIG_SOFT_RESET;
-	writel(val, PCIE_HHBM_CONFIG(priv->pcie_reg_base));
+	writel(val, PCIE_HHBM_CONFIG(ps->pcie_reg_base));
 	usleep_range(50, 100);
 	val &= ~HHBM_CONFIG_SOFT_RESET;
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	val |= HHBM_64BIT;
 #endif
-	writel(val, PCIE_HHBM_CONFIG(priv->pcie_reg_base));
-	writel(priv->rx_bd_num, PCIE_HHBM_Q_LIMIT_REG(priv->pcie_reg_base));
+	writel(val, PCIE_HHBM_CONFIG(ps->pcie_reg_base));
+	writel(ps->base.rx_bd_num, PCIE_HHBM_Q_LIMIT_REG(ps->pcie_reg_base));
 
 	return 0;
 }
 
-static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	int ret;
 	u32 val;
 
@@ -689,7 +649,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *priv)
 		return -EINVAL;
 	}
 
-	ret = qtnf_hhbm_init(priv);
+	ret = qtnf_hhbm_init(ps);
 	if (ret) {
 		pr_err("failed to init h/w queues\n");
 		return ret;
@@ -701,13 +661,13 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *priv)
 		return ret;
 	}
 
-	ret = alloc_bd_table(priv);
+	ret = alloc_bd_table(ps);
 	if (ret) {
 		pr_err("failed to allocate bd table\n");
 		return ret;
 	}
 
-	ret = alloc_rx_buffers(priv);
+	ret = alloc_rx_buffers(ps);
 	if (ret) {
 		pr_err("failed to allocate rx buffers\n");
 		return ret;
@@ -716,8 +676,9 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *priv)
 	return ret;
 }
 
-static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	struct qtnf_pearl_tx_bd *txbd;
 	struct sk_buff *skb;
 	unsigned long flags;
@@ -728,7 +689,7 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *priv)
 
 	spin_lock_irqsave(&priv->tx_reclaim_lock, flags);
 
-	tx_done_index = readl(PCIE_HDP_RX0DMA_CNT(priv->pcie_reg_base))
+	tx_done_index = readl(PCIE_HDP_RX0DMA_CNT(ps->pcie_reg_base))
 			& (priv->tx_bd_num - 1);
 
 	i = priv->tx_bd_r_index;
@@ -736,7 +697,7 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *priv)
 	while (CIRC_CNT(tx_done_index, i, priv->tx_bd_num)) {
 		skb = priv->tx_skb[i];
 		if (likely(skb)) {
-			txbd = &priv->tx_bd_vbase[i];
+			txbd = &ps->tx_bd_vbase[i];
 			paddr = QTN_HOST_ADDR(le32_to_cpu(txbd->addr_h),
 					      le32_to_cpu(txbd->addr));
 			pci_unmap_single(priv->pdev, paddr, skb->len,
@@ -767,11 +728,13 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *priv)
 	spin_unlock_irqrestore(&priv->tx_reclaim_lock, flags);
 }
 
-static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv = &ps->base;
+
 	if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 			priv->tx_bd_num)) {
-		qtnf_pcie_data_tx_reclaim(priv);
+		qtnf_pcie_data_tx_reclaim(ps);
 
 		if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 				priv->tx_bd_num)) {
@@ -786,7 +749,8 @@ static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_state *priv)
 
 static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
-	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	dma_addr_t txbd_paddr, skb_paddr;
 	struct qtnf_pearl_tx_bd *txbd;
 	unsigned long flags;
@@ -796,7 +760,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 
 	spin_lock_irqsave(&priv->tx_lock, flags);
 
-	if (!qtnf_tx_queue_ready(priv)) {
+	if (!qtnf_tx_queue_ready(ps)) {
 		if (skb->dev) {
 			netif_tx_stop_all_queues(skb->dev);
 			priv->tx_stopped = 1;
@@ -818,7 +782,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 		goto tx_done;
 	}
 
-	txbd = &priv->tx_bd_vbase[i];
+	txbd = &ps->tx_bd_vbase[i];
 	txbd->addr = cpu_to_le32(QTN_HOST_LO32(skb_paddr));
 	txbd->addr_h = cpu_to_le32(QTN_HOST_HI32(skb_paddr));
 
@@ -829,14 +793,14 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	dma_wmb();
 
 	/* write new TX descriptor to PCIE_RX_FIFO on EP */
-	txbd_paddr = priv->tx_bd_pbase + i * sizeof(struct qtnf_pearl_tx_bd);
+	txbd_paddr = ps->tx_bd_pbase + i * sizeof(struct qtnf_pearl_tx_bd);
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	writel(QTN_HOST_HI32(txbd_paddr),
-	       PCIE_HDP_HOST_WR_DESC0_H(priv->pcie_reg_base));
+	       PCIE_HDP_HOST_WR_DESC0_H(ps->pcie_reg_base));
 #endif
 	writel(QTN_HOST_LO32(txbd_paddr),
-	       PCIE_HDP_HOST_WR_DESC0(priv->pcie_reg_base));
+	       PCIE_HDP_HOST_WR_DESC0(ps->pcie_reg_base));
 
 	if (++i >= priv->tx_bd_num)
 		i = 0;
@@ -854,14 +818,14 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	priv->tx_done_count++;
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
-	qtnf_pcie_data_tx_reclaim(priv);
+	qtnf_pcie_data_tx_reclaim(ps);
 
 	return NETDEV_TX_OK;
 }
 
 static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
-	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
 	int ret;
 
 	ret = qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
@@ -877,54 +841,55 @@ static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 static irqreturn_t qtnf_interrupt(int irq, void *data)
 {
 	struct qtnf_bus *bus = (struct qtnf_bus *)data;
-	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	u32 status;
 
 	priv->pcie_irq_count++;
-	status = readl(PCIE_HDP_INT_STATUS(priv->pcie_reg_base));
+	status = readl(PCIE_HDP_INT_STATUS(ps->pcie_reg_base));
 
 	qtnf_shm_ipc_irq_handler(&priv->shm_ipc_ep_in);
 	qtnf_shm_ipc_irq_handler(&priv->shm_ipc_ep_out);
 
-	if (!(status & priv->pcie_irq_mask))
+	if (!(status & ps->pcie_irq_mask))
 		goto irq_done;
 
 	if (status & PCIE_HDP_INT_RX_BITS)
-		priv->pcie_irq_rx_count++;
+		ps->pcie_irq_rx_count++;
 
 	if (status & PCIE_HDP_INT_TX_BITS)
-		priv->pcie_irq_tx_count++;
+		ps->pcie_irq_tx_count++;
 
 	if (status & PCIE_HDP_INT_HHBM_UF)
-		priv->pcie_irq_uf_count++;
+		ps->pcie_irq_uf_count++;
 
 	if (status & PCIE_HDP_INT_RX_BITS) {
-		qtnf_dis_rxdone_irq(priv);
+		qtnf_dis_rxdone_irq(ps);
 		napi_schedule(&bus->mux_napi);
 	}
 
 	if (status & PCIE_HDP_INT_TX_BITS) {
-		qtnf_dis_txdone_irq(priv);
+		qtnf_dis_txdone_irq(ps);
 		tasklet_hi_schedule(&priv->reclaim_tq);
 	}
 
 irq_done:
 	/* H/W workaround: clean all bits, not only enabled */
-	qtnf_non_posted_write(~0U, PCIE_HDP_INT_STATUS(priv->pcie_reg_base));
+	qtnf_non_posted_write(~0U, PCIE_HDP_INT_STATUS(ps->pcie_reg_base));
 
 	if (!priv->msi_enabled)
-		qtnf_deassert_intx(priv);
+		qtnf_deassert_intx(ps);
 
 	return IRQ_HANDLED;
 }
 
-static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_state *ps)
 {
-	u16 index = priv->rx_bd_r_index;
+	u16 index = ps->base.rx_bd_r_index;
 	struct qtnf_pearl_rx_bd *rxbd;
 	u32 descw;
 
-	rxbd = &priv->rx_bd_vbase[index];
+	rxbd = &ps->rx_bd_vbase[index];
 	descw = le32_to_cpu(rxbd->info);
 
 	if (descw & QTN_TXDONE_MASK)
@@ -936,7 +901,8 @@ static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_state *priv)
 static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct qtnf_bus *bus = container_of(napi, struct qtnf_bus, mux_napi);
-	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	struct net_device *ndev = NULL;
 	struct sk_buff *skb = NULL;
 	int processed = 0;
@@ -950,13 +916,11 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 	int ret;
 
 	while (processed < budget) {
-
-
-		if (!qtnf_rx_data_ready(priv))
+		if (!qtnf_rx_data_ready(ps))
 			goto rx_out;
 
 		r_idx = priv->rx_bd_r_index;
-		rxbd = &priv->rx_bd_vbase[r_idx];
+		rxbd = &ps->rx_bd_vbase[r_idx];
 		descw = le32_to_cpu(rxbd->info);
 
 		skb = priv->rx_skb[r_idx];
@@ -1018,7 +982,7 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 			if (++w_idx >= priv->rx_bd_num)
 				w_idx = 0;
 
-			ret = skb2rbd_attach(priv, w_idx);
+			ret = skb2rbd_attach(ps, w_idx);
 			if (ret) {
 				pr_err("failed to allocate new rx_skb[%d]\n",
 				       w_idx);
@@ -1032,7 +996,7 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 rx_out:
 	if (processed < budget) {
 		napi_complete(napi);
-		qtnf_en_rxdone_irq(priv);
+		qtnf_en_rxdone_irq(ps);
 	}
 
 	return processed;
@@ -1041,25 +1005,25 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 static void
 qtnf_pcie_data_tx_timeout(struct qtnf_bus *bus, struct net_device *ndev)
 {
-	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
 
-	tasklet_hi_schedule(&priv->reclaim_tq);
+	tasklet_hi_schedule(&ps->base.reclaim_tq);
 }
 
 static void qtnf_pcie_data_rx_start(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
 
-	qtnf_enable_hdp_irqs(priv);
+	qtnf_enable_hdp_irqs(ps);
 	napi_enable(&bus->mux_napi);
 }
 
 static void qtnf_pcie_data_rx_stop(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
 
 	napi_disable(&bus->mux_napi);
-	qtnf_disable_hdp_irqs(priv);
+	qtnf_disable_hdp_irqs(ps);
 }
 
 static const struct qtnf_bus_ops qtnf_pcie_bus_ops = {
@@ -1076,7 +1040,7 @@ static const struct qtnf_bus_ops qtnf_pcie_bus_ops = {
 static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_pearl_state *priv = get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
 
 	seq_printf(s, "%d\n", priv->mps);
 
@@ -1086,7 +1050,7 @@ static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
 static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_pearl_state *priv = get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
 
 	seq_printf(s, "%u\n", priv->msi_enabled);
 
@@ -1096,20 +1060,20 @@ static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
 static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_pearl_state *priv = get_bus_priv(bus);
-	u32 reg = readl(PCIE_HDP_INT_EN(priv->pcie_reg_base));
+	struct qtnf_pcie_pearl_state *ps = get_bus_priv(bus);
+	u32 reg = readl(PCIE_HDP_INT_EN(ps->pcie_reg_base));
 	u32 status;
 
-	seq_printf(s, "pcie_irq_count(%u)\n", priv->pcie_irq_count);
-	seq_printf(s, "pcie_irq_tx_count(%u)\n", priv->pcie_irq_tx_count);
+	seq_printf(s, "pcie_irq_count(%u)\n", ps->base.pcie_irq_count);
+	seq_printf(s, "pcie_irq_tx_count(%u)\n", ps->pcie_irq_tx_count);
 	status = reg &  PCIE_HDP_INT_TX_BITS;
 	seq_printf(s, "pcie_irq_tx_status(%s)\n",
 		   (status == PCIE_HDP_INT_TX_BITS) ? "EN" : "DIS");
-	seq_printf(s, "pcie_irq_rx_count(%u)\n", priv->pcie_irq_rx_count);
+	seq_printf(s, "pcie_irq_rx_count(%u)\n", ps->pcie_irq_rx_count);
 	status = reg &  PCIE_HDP_INT_RX_BITS;
 	seq_printf(s, "pcie_irq_rx_status(%s)\n",
 		   (status == PCIE_HDP_INT_RX_BITS) ? "EN" : "DIS");
-	seq_printf(s, "pcie_irq_uf_count(%u)\n", priv->pcie_irq_uf_count);
+	seq_printf(s, "pcie_irq_uf_count(%u)\n", ps->pcie_irq_uf_count);
 	status = reg &  PCIE_HDP_INT_HHBM_UF;
 	seq_printf(s, "pcie_irq_hhbm_uf_status(%s)\n",
 		   (status == PCIE_HDP_INT_HHBM_UF) ? "EN" : "DIS");
@@ -1120,7 +1084,8 @@ static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
 static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_pearl_state *priv = get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps = get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv = &ps->base;
 
 	seq_printf(s, "tx_full_count(%u)\n", priv->tx_full_count);
 	seq_printf(s, "tx_done_count(%u)\n", priv->tx_done_count);
@@ -1129,7 +1094,7 @@ static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
 
 	seq_printf(s, "tx_bd_r_index(%u)\n", priv->tx_bd_r_index);
 	seq_printf(s, "tx_bd_p_index(%u)\n",
-		   readl(PCIE_HDP_RX0DMA_CNT(priv->pcie_reg_base))
+		   readl(PCIE_HDP_RX0DMA_CNT(ps->pcie_reg_base))
 			& (priv->tx_bd_num - 1));
 	seq_printf(s, "tx_bd_w_index(%u)\n", priv->tx_bd_w_index);
 	seq_printf(s, "tx queue len(%u)\n",
@@ -1138,7 +1103,7 @@ static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
 
 	seq_printf(s, "rx_bd_r_index(%u)\n", priv->rx_bd_r_index);
 	seq_printf(s, "rx_bd_p_index(%u)\n",
-		   readl(PCIE_HDP_TX0DMA_CNT(priv->pcie_reg_base))
+		   readl(PCIE_HDP_TX0DMA_CNT(ps->pcie_reg_base))
 			& (priv->rx_bd_num - 1));
 	seq_printf(s, "rx_bd_w_index(%u)\n", priv->rx_bd_w_index);
 	seq_printf(s, "rx alloc queue len(%u)\n",
@@ -1151,7 +1116,7 @@ static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
 static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_pearl_state *priv = get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
 
 	seq_printf(s, "shm_ipc_ep_in.tx_packet_count(%zu)\n",
 		   priv->shm_ipc_ep_in.tx_packet_count);
@@ -1165,10 +1130,10 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *priv, uint32_t size,
+static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *ps, uint32_t size,
 			   int blk, const u8 *pblk, const u8 *fw)
 {
-	struct pci_dev *pdev = priv->pdev;
+	struct pci_dev *pdev = ps->base.pdev;
 	struct qtnf_bus *bus = pci_get_drvdata(pdev);
 
 	struct qtnf_pearl_fw_hdr *hdr;
@@ -1214,7 +1179,7 @@ static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *priv, uint32_t size,
 }
 
 static int
-qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv, const u8 *fw, u32 fw_size)
+qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *ps, const u8 *fw, u32 fw_size)
 {
 	int blk_size = QTN_PCIE_FW_BUFSZ - sizeof(struct qtnf_pearl_fw_hdr);
 	int blk_count = fw_size / blk_size + ((fw_size % blk_size) ? 1 : 0);
@@ -1231,25 +1196,25 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv, const u8 *fw, u32 fw_size)
 			return -ETIMEDOUT;
 		}
 
-		len = qtnf_ep_fw_send(priv, fw_size, blk, pblk, fw);
+		len = qtnf_ep_fw_send(ps, fw_size, blk, pblk, fw);
 		if (len <= 0)
 			continue;
 
 		if (!((blk + 1) & QTN_PCIE_FW_DLMASK) ||
 		    (blk == (blk_count - 1))) {
-			qtnf_set_state(&priv->bda->bda_rc_state,
+			qtnf_set_state(&ps->bda->bda_rc_state,
 				       QTN_RC_FW_SYNC);
-			if (qtnf_poll_state(&priv->bda->bda_ep_state,
+			if (qtnf_poll_state(&ps->bda->bda_ep_state,
 					    QTN_EP_FW_SYNC,
 					    QTN_FW_DL_TIMEOUT_MS)) {
 				pr_err("FW upload failed: SYNC timed out\n");
 				return -ETIMEDOUT;
 			}
 
-			qtnf_clear_state(&priv->bda->bda_ep_state,
+			qtnf_clear_state(&ps->bda->bda_ep_state,
 					 QTN_EP_FW_SYNC);
 
-			if (qtnf_is_state(&priv->bda->bda_ep_state,
+			if (qtnf_is_state(&ps->bda->bda_ep_state,
 					  QTN_EP_FW_RETRY)) {
 				if (blk == (blk_count - 1)) {
 					int last_round =
@@ -1262,14 +1227,14 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv, const u8 *fw, u32 fw_size)
 					pblk -= QTN_PCIE_FW_DLMASK * blk_size;
 				}
 
-				qtnf_clear_state(&priv->bda->bda_ep_state,
+				qtnf_clear_state(&ps->bda->bda_ep_state,
 						 QTN_EP_FW_RETRY);
 
 				pr_warn("FW upload retry: block #%d\n", blk);
 				continue;
 			}
 
-			qtnf_pcie_data_tx_reclaim(priv);
+			qtnf_pcie_data_tx_reclaim(ps);
 		}
 
 		pblk += len;
@@ -1283,8 +1248,8 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv, const u8 *fw, u32 fw_size)
 static void qtnf_fw_work_handler(struct work_struct *work)
 {
 	struct qtnf_bus *bus = container_of(work, struct qtnf_bus, fw_work);
-	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
-	struct pci_dev *pdev = priv->pdev;
+	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
+	struct pci_dev *pdev = ps->base.pdev;
 	const struct firmware *fw;
 	int ret;
 	u32 state = QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK;
@@ -1300,9 +1265,9 @@ static void qtnf_fw_work_handler(struct work_struct *work)
 		}
 	}
 
-	qtnf_set_state(&priv->bda->bda_rc_state, state);
+	qtnf_set_state(&ps->bda->bda_rc_state, state);
 
-	if (qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_LOADRDY,
+	if (qtnf_poll_state(&ps->bda->bda_ep_state, QTN_EP_FW_LOADRDY,
 			    QTN_FW_DL_TIMEOUT_MS)) {
 		pr_err("card is not ready\n");
 
@@ -1312,14 +1277,14 @@ static void qtnf_fw_work_handler(struct work_struct *work)
 		goto fw_load_fail;
 	}
 
-	qtnf_clear_state(&priv->bda->bda_ep_state, QTN_EP_FW_LOADRDY);
+	qtnf_clear_state(&ps->bda->bda_ep_state, QTN_EP_FW_LOADRDY);
 
 	if (flashboot) {
 		pr_info("booting firmware from flash\n");
 	} else {
 		pr_info("starting firmware upload: %s\n", fwname);
 
-		ret = qtnf_ep_fw_load(priv, fw->data, fw->size);
+		ret = qtnf_ep_fw_load(ps, fw->data, fw->size);
 		release_firmware(fw);
 		if (ret) {
 			pr_err("firmware upload error\n");
@@ -1327,7 +1292,7 @@ static void qtnf_fw_work_handler(struct work_struct *work)
 		}
 	}
 
-	if (qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_DONE,
+	if (qtnf_poll_state(&ps->bda->bda_ep_state, QTN_EP_FW_DONE,
 			    QTN_FW_DL_TIMEOUT_MS)) {
 		pr_err("firmware bringup timed out\n");
 		goto fw_load_fail;
@@ -1336,7 +1301,7 @@ static void qtnf_fw_work_handler(struct work_struct *work)
 	bus->fw_state = QTNF_FW_STATE_FW_DNLD_DONE;
 	pr_info("firmware is up and running\n");
 
-	if (qtnf_poll_state(&priv->bda->bda_ep_state,
+	if (qtnf_poll_state(&ps->bda->bda_ep_state,
 			    QTN_EP_FW_QLINK_DONE, QTN_FW_QLINK_TIMEOUT_MS)) {
 		pr_err("firmware runtime failure\n");
 		goto fw_load_fail;
@@ -1367,7 +1332,7 @@ static void qtnf_fw_work_handler(struct work_struct *work)
 
 static void qtnf_bringup_fw_async(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
 	struct pci_dev *pdev = priv->pdev;
 
 	get_device(&pdev->dev);
@@ -1377,56 +1342,56 @@ static void qtnf_bringup_fw_async(struct qtnf_bus *bus)
 
 static void qtnf_reclaim_tasklet_fn(unsigned long data)
 {
-	struct qtnf_pcie_pearl_state *priv = (void *)data;
+	struct qtnf_pcie_pearl_state *ps = (void *)data;
 
-	qtnf_pcie_data_tx_reclaim(priv);
-	qtnf_en_txdone_irq(priv);
+	qtnf_pcie_data_tx_reclaim(ps);
+	qtnf_en_txdone_irq(ps);
 }
 
 static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct qtnf_pcie_pearl_state *pcie_priv;
+	struct qtnf_pcie_pearl_state *ps;
 	struct qtnf_bus *bus;
 	int ret;
 
 	bus = devm_kzalloc(&pdev->dev,
-			   sizeof(*bus) + sizeof(*pcie_priv), GFP_KERNEL);
+			   sizeof(*bus) + sizeof(*ps), GFP_KERNEL);
 	if (!bus)
 		return -ENOMEM;
 
-	pcie_priv = get_bus_priv(bus);
+	ps = get_bus_priv(bus);
 
 	pci_set_drvdata(pdev, bus);
 	bus->bus_ops = &qtnf_pcie_bus_ops;
 	bus->dev = &pdev->dev;
 	bus->fw_state = QTNF_FW_STATE_RESET;
-	pcie_priv->pdev = pdev;
+	ps->base.pdev = pdev;
 
 	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
-	spin_lock_init(&pcie_priv->tx_lock);
-	spin_lock_init(&pcie_priv->irq_lock);
-	spin_lock_init(&pcie_priv->tx_reclaim_lock);
+	spin_lock_init(&ps->base.tx_lock);
+	spin_lock_init(&ps->irq_lock);
+	spin_lock_init(&ps->base.tx_reclaim_lock);
 
 	/* init stats */
-	pcie_priv->tx_full_count = 0;
-	pcie_priv->tx_done_count = 0;
-	pcie_priv->pcie_irq_count = 0;
-	pcie_priv->pcie_irq_rx_count = 0;
-	pcie_priv->pcie_irq_tx_count = 0;
-	pcie_priv->pcie_irq_uf_count = 0;
-	pcie_priv->tx_reclaim_done = 0;
-	pcie_priv->tx_reclaim_req = 0;
-
-	tasklet_init(&pcie_priv->reclaim_tq, qtnf_reclaim_tasklet_fn,
-		     (unsigned long)pcie_priv);
+	ps->base.tx_full_count = 0;
+	ps->base.tx_done_count = 0;
+	ps->base.pcie_irq_count = 0;
+	ps->pcie_irq_rx_count = 0;
+	ps->pcie_irq_tx_count = 0;
+	ps->pcie_irq_uf_count = 0;
+	ps->base.tx_reclaim_done = 0;
+	ps->base.tx_reclaim_req = 0;
+
+	tasklet_init(&ps->base.reclaim_tq, qtnf_reclaim_tasklet_fn,
+		     (unsigned long)ps);
 
 	init_dummy_netdev(&bus->mux_dev);
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
 		       qtnf_rx_poll, 10);
 
-	pcie_priv->workqueue = create_singlethread_workqueue("QTNF_PEARL_PCIE");
-	if (!pcie_priv->workqueue) {
+	ps->base.workqueue = create_singlethread_workqueue("QTNF_PEARL_PCIE");
+	if (!ps->base.workqueue) {
 		pr_err("failed to alloc bus workqueue\n");
 		ret = -ENODEV;
 		goto err_init;
@@ -1438,7 +1403,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_base;
 	}
 
-	qtnf_tune_pcie_mps(pcie_priv);
+	qtnf_tune_pcie_mps(&ps->base);
 
 	ret = pcim_enable_device(pdev);
 	if (ret) {
@@ -1459,9 +1424,9 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	pci_set_master(pdev);
-	qtnf_pcie_init_irq(pcie_priv);
+	qtnf_pcie_init_irq(&ps->base);
 
-	ret = qtnf_pcie_init_memory(pcie_priv);
+	ret = qtnf_pcie_init_memory(ps);
 	if (ret < 0) {
 		pr_err("PCIE memory init failed\n");
 		goto err_base;
@@ -1469,23 +1434,23 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_save_state(pdev);
 
-	ret = qtnf_pcie_init_shm_ipc(pcie_priv);
+	ret = qtnf_pcie_init_shm_ipc(ps);
 	if (ret < 0) {
 		pr_err("PCIE SHM IPC init failed\n");
 		goto err_base;
 	}
 
-	ret = qtnf_pcie_init_xfer(pcie_priv);
+	ret = qtnf_pcie_init_xfer(ps);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
 		goto err_ipc;
 	}
 
 	/* init default irq settings */
-	qtnf_init_hdp_irqs(pcie_priv);
+	qtnf_init_hdp_irqs(ps);
 
 	/* start with disabled irqs */
-	qtnf_disable_hdp_irqs(pcie_priv);
+	qtnf_disable_hdp_irqs(ps);
 
 	ret = devm_request_irq(&pdev->dev, pdev->irq, &qtnf_interrupt, 0,
 			       "qtnf_pcie_irq", (void *)bus);
@@ -1499,18 +1464,18 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_xfer:
-	qtnf_free_xfer_buffers(pcie_priv);
+	qtnf_free_xfer_buffers(ps);
 
 err_ipc:
-	qtnf_pcie_free_shm_ipc(pcie_priv);
+	qtnf_pcie_free_shm_ipc(&ps->base);
 
 err_base:
-	flush_workqueue(pcie_priv->workqueue);
-	destroy_workqueue(pcie_priv->workqueue);
-	netif_napi_del(&bus->mux_napi);
+	flush_workqueue(ps->base.workqueue);
+	destroy_workqueue(ps->base.workqueue);
 
 err_init:
-	tasklet_kill(&pcie_priv->reclaim_tq);
+	tasklet_kill(&ps->base.reclaim_tq);
+	netif_napi_del(&bus->mux_napi);
 	pci_set_drvdata(pdev, NULL);
 
 	return ret;
@@ -1518,7 +1483,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void qtnf_pcie_remove(struct pci_dev *pdev)
 {
-	struct qtnf_pcie_pearl_state *priv;
+	struct qtnf_pcie_pearl_state *ps;
 	struct qtnf_bus *bus;
 
 	bus = pci_get_drvdata(pdev);
@@ -1531,18 +1496,16 @@ static void qtnf_pcie_remove(struct pci_dev *pdev)
 	    bus->fw_state == QTNF_FW_STATE_EP_DEAD)
 		qtnf_core_detach(bus);
 
-	priv = get_bus_priv(bus);
-
+	ps = get_bus_priv(bus);
+	qtnf_reset_card(ps);
 	netif_napi_del(&bus->mux_napi);
-	flush_workqueue(priv->workqueue);
-	destroy_workqueue(priv->workqueue);
-	tasklet_kill(&priv->reclaim_tq);
+	flush_workqueue(ps->base.workqueue);
+	destroy_workqueue(ps->base.workqueue);
+	tasklet_kill(&ps->base.reclaim_tq);
 
-	qtnf_free_xfer_buffers(priv);
+	qtnf_free_xfer_buffers(ps);
+	qtnf_pcie_free_shm_ipc(&ps->base);
 	qtnf_debugfs_remove(bus);
-
-	qtnf_pcie_free_shm_ipc(priv);
-	qtnf_reset_card(priv);
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
index af528b8..b87505d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
@@ -43,11 +43,6 @@
 #define QTN_RC_FW_LOADRDY	BIT(8)
 #define QTN_RC_FW_SYNC		BIT(9)
 
-/* state transition timeouts */
-#define QTN_FW_DL_TIMEOUT_MS	3000
-#define QTN_FW_QLINK_TIMEOUT_MS	30000
-#define QTN_EP_RESET_WAIT_MS	1000
-
 #define PCIE_HDP_INT_RX_BITS (0		\
 	| PCIE_HDP_INT_EP_TXDMA		\
 	| PCIE_HDP_INT_EP_TXEMPTY	\
@@ -77,8 +72,6 @@
 #define PCIE_BDA_NAMELEN		32
 #define PCIE_HHBM_MAX_SIZE		2048
 
-#define SKB_BUF_SIZE		2048
-
 #define QTN_PCIE_BOARDFLG	"PCIEQTN"
 #define QTN_PCIE_FW_DLMASK	0xF
 #define QTN_PCIE_FW_BUFSZ	2048
-- 
2.9.5

