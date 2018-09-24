Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397EEC43382
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CED19204EC
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CED19204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbeIYEUe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:20:34 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46854 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1728636AbeIYETr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:47 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOJ012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 09/11] qtnfmac_pcie: extract platform-independent PCIe code
Date:   Mon, 24 Sep 2018 15:15:12 -0700
Message-Id: <20180924221514.4273-10-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Extract platform-independent PCIe driver code into a separate file, and
use it from platform-specific modules.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/Makefile    |   1 +
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 393 +++++++++++++++++++
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |  15 +
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 425 +++------------------
 .../quantenna/qtnfmac/pcie/pearl_pcie_ipc.h        |   4 -
 5 files changed, 455 insertions(+), 383 deletions(-)
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c

diff --git a/drivers/net/wireless/quantenna/qtnfmac/Makefile b/drivers/net/wireless/quantenna/qtnfmac/Makefile
index 9eeddea..17cd7ad 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Makefile
+++ b/drivers/net/wireless/quantenna/qtnfmac/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_QTNFMAC_PEARL_PCIE) += qtnfmac_pearl_pcie.o
 
 qtnfmac_pearl_pcie-objs += \
 	shm_ipc.o \
+	pcie/pcie.o \
 	pcie/pearl_pcie.o
 
 qtnfmac_pearl_pcie-$(CONFIG_DEBUG_FS) += debug.o
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
new file mode 100644
index 0000000..f83951c
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -0,0 +1,393 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2018 Quantenna Communications, Inc. All rights reserved. */
+
+#include <linux/printk.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/seq_file.h>
+#include <linux/workqueue.h>
+#include <linux/completion.h>
+
+#include "pcie_priv.h"
+#include "bus.h"
+#include "shm_ipc.h"
+#include "core.h"
+#include "debug.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"qtnf_pcie: %s: " fmt, __func__
+
+#define QTN_SYSCTL_BAR	0
+#define QTN_SHMEM_BAR	2
+#define QTN_DMA_BAR	3
+
+int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	int ret;
+
+	ret = qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
+
+	if (ret == -ETIMEDOUT) {
+		pr_err("EP firmware is dead\n");
+		bus->fw_state = QTNF_FW_STATE_EP_DEAD;
+	}
+
+	return ret;
+}
+
+int qtnf_pcie_alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
+{
+	struct sk_buff **vaddr;
+	int len;
+
+	len = priv->tx_bd_num * sizeof(*priv->tx_skb) +
+		priv->rx_bd_num * sizeof(*priv->rx_skb);
+	vaddr = devm_kzalloc(&priv->pdev->dev, len, GFP_KERNEL);
+
+	if (!vaddr)
+		return -ENOMEM;
+
+	priv->tx_skb = vaddr;
+
+	vaddr += priv->tx_bd_num;
+	priv->rx_skb = vaddr;
+
+	return 0;
+}
+
+void qtnf_pcie_bringup_fw_async(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	struct pci_dev *pdev = priv->pdev;
+
+	get_device(&pdev->dev);
+	schedule_work(&bus->fw_work);
+}
+
+static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+
+	seq_printf(s, "%d\n", priv->mps);
+
+	return 0;
+}
+
+static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+
+	seq_printf(s, "%u\n", priv->msi_enabled);
+
+	return 0;
+}
+
+static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+
+	seq_printf(s, "shm_ipc_ep_in.tx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_in.tx_packet_count);
+	seq_printf(s, "shm_ipc_ep_in.rx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_in.rx_packet_count);
+	seq_printf(s, "shm_ipc_ep_out.tx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_out.tx_timeout_count);
+	seq_printf(s, "shm_ipc_ep_out.rx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_out.rx_packet_count);
+
+	return 0;
+}
+
+void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool boot_success,
+			    const char *drv_name)
+{
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	struct pci_dev *pdev = priv->pdev;
+	int ret;
+
+	if (boot_success) {
+		bus->fw_state = QTNF_FW_STATE_FW_DNLD_DONE;
+
+		ret = qtnf_core_attach(bus);
+		if (ret) {
+			pr_err("failed to attach core\n");
+			boot_success = false;
+		}
+	}
+
+	if (boot_success) {
+		qtnf_debugfs_init(bus, drv_name);
+		qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
+		qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
+		qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
+	} else {
+		bus->fw_state = QTNF_FW_STATE_DETACHED;
+	}
+
+	complete(&bus->firmware_init_complete);
+	put_device(&pdev->dev);
+}
+
+static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
+{
+	struct pci_dev *pdev = priv->pdev;
+	struct pci_dev *parent;
+	int mps_p, mps_o, mps_m, mps;
+	int ret;
+
+	/* current mps */
+	mps_o = pcie_get_mps(pdev);
+
+	/* maximum supported mps */
+	mps_m = 128 << pdev->pcie_mpss;
+
+	/* suggested new mps value */
+	mps = mps_m;
+
+	if (pdev->bus && pdev->bus->self) {
+		/* parent (bus) mps */
+		parent = pdev->bus->self;
+
+		if (pci_is_pcie(parent)) {
+			mps_p = pcie_get_mps(parent);
+			mps = min(mps_m, mps_p);
+		}
+	}
+
+	ret = pcie_set_mps(pdev, mps);
+	if (ret) {
+		pr_err("failed to set mps to %d, keep using current %d\n",
+		       mps, mps_o);
+		priv->mps = mps_o;
+		return;
+	}
+
+	pr_debug("set mps to %d (was %d, max %d)\n", mps, mps_o, mps_m);
+	priv->mps = mps;
+}
+
+static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv, bool use_msi)
+{
+	struct pci_dev *pdev = priv->pdev;
+
+	/* fall back to legacy INTx interrupts by default */
+	priv->msi_enabled = 0;
+
+	/* check if MSI capability is available */
+	if (use_msi) {
+		if (!pci_enable_msi(pdev)) {
+			pr_debug("enabled MSI interrupt\n");
+			priv->msi_enabled = 1;
+		} else {
+			pr_warn("failed to enable MSI interrupts");
+		}
+	}
+
+	if (!priv->msi_enabled) {
+		pr_warn("legacy PCIE interrupts enabled\n");
+		pci_intx(pdev, 1);
+	}
+}
+
+static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 index)
+{
+	void __iomem *vaddr;
+	dma_addr_t busaddr;
+	size_t len;
+	int ret;
+
+	ret = pcim_iomap_regions(priv->pdev, 1 << index, "qtnfmac_pcie");
+	if (ret)
+		return IOMEM_ERR_PTR(ret);
+
+	busaddr = pci_resource_start(priv->pdev, index);
+	len = pci_resource_len(priv->pdev, index);
+	vaddr = pcim_iomap_table(priv->pdev)[index];
+	if (!vaddr)
+		return IOMEM_ERR_PTR(-ENOMEM);
+
+	pr_debug("BAR%u vaddr=0x%p busaddr=%pad len=%u\n",
+		 index, vaddr, &busaddr, (int)len);
+
+	return vaddr;
+}
+
+static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_priv *priv)
+{
+	int ret = -ENOMEM;
+
+	priv->sysctl_bar = qtnf_map_bar(priv, QTN_SYSCTL_BAR);
+	if (IS_ERR(priv->sysctl_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_SYSCTL_BAR);
+		return ret;
+	}
+
+	priv->dmareg_bar = qtnf_map_bar(priv, QTN_DMA_BAR);
+	if (IS_ERR(priv->dmareg_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_DMA_BAR);
+		return ret;
+	}
+
+	priv->epmem_bar = qtnf_map_bar(priv, QTN_SHMEM_BAR);
+	if (IS_ERR(priv->epmem_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_SHMEM_BAR);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t len)
+{
+	struct qtnf_pcie_bus_priv *priv = arg;
+	struct qtnf_bus *bus = pci_get_drvdata(priv->pdev);
+	struct sk_buff *skb;
+
+	if (unlikely(len == 0)) {
+		pr_warn("zero length packet received\n");
+		return;
+	}
+
+	skb = __dev_alloc_skb(len, GFP_KERNEL);
+
+	if (unlikely(!skb)) {
+		pr_err("failed to allocate skb\n");
+		return;
+	}
+
+	skb_put_data(skb, buf, len);
+
+	qtnf_trans_handle_rx_ctl_packet(bus, skb);
+}
+
+void qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv,
+			    struct qtnf_shm_ipc_region __iomem *ipc_tx_reg,
+			    struct qtnf_shm_ipc_region __iomem *ipc_rx_reg,
+			    const struct qtnf_shm_ipc_int *ipc_int)
+{
+	const struct qtnf_shm_ipc_rx_callback rx_callback = {
+					qtnf_pcie_control_rx_callback, priv };
+
+	qtnf_shm_ipc_init(&priv->shm_ipc_ep_in, QTNF_SHM_IPC_OUTBOUND,
+			  ipc_tx_reg, priv->workqueue,
+			  ipc_int, &rx_callback);
+	qtnf_shm_ipc_init(&priv->shm_ipc_ep_out, QTNF_SHM_IPC_INBOUND,
+			  ipc_rx_reg, priv->workqueue,
+			  ipc_int, &rx_callback);
+}
+
+int qtnf_pcie_probe(struct pci_dev *pdev, size_t priv_size,
+		    const struct qtnf_bus_ops *bus_ops, u64 dma_mask,
+		    bool use_msi)
+{
+	struct qtnf_pcie_bus_priv *pcie_priv;
+	struct qtnf_bus *bus;
+	int ret;
+
+	bus = devm_kzalloc(&pdev->dev,
+			   sizeof(*bus) + priv_size, GFP_KERNEL);
+	if (!bus)
+		return -ENOMEM;
+
+	pcie_priv = get_bus_priv(bus);
+
+	pci_set_drvdata(pdev, bus);
+	bus->bus_ops = bus_ops;
+	bus->dev = &pdev->dev;
+	bus->fw_state = QTNF_FW_STATE_RESET;
+	pcie_priv->pdev = pdev;
+	pcie_priv->tx_stopped = 0;
+
+	init_completion(&bus->firmware_init_complete);
+	mutex_init(&bus->bus_lock);
+	spin_lock_init(&pcie_priv->tx_lock);
+	spin_lock_init(&pcie_priv->tx_reclaim_lock);
+
+	pcie_priv->tx_full_count = 0;
+	pcie_priv->tx_done_count = 0;
+	pcie_priv->pcie_irq_count = 0;
+	pcie_priv->tx_reclaim_done = 0;
+	pcie_priv->tx_reclaim_req = 0;
+
+	pcie_priv->workqueue = create_singlethread_workqueue("QTNF_PCIE");
+	if (!pcie_priv->workqueue) {
+		pr_err("failed to alloc bus workqueue\n");
+		ret = -ENODEV;
+		goto err_init;
+	}
+
+	init_dummy_netdev(&bus->mux_dev);
+
+	if (!pci_is_pcie(pdev)) {
+		pr_err("device %s is not PCI Express\n", pci_name(pdev));
+		ret = -EIO;
+		goto err_base;
+	}
+
+	qtnf_tune_pcie_mps(pcie_priv);
+
+	ret = pcim_enable_device(pdev);
+	if (ret) {
+		pr_err("failed to init PCI device %x\n", pdev->device);
+		goto err_base;
+	} else {
+		pr_debug("successful init of PCI device %x\n", pdev->device);
+	}
+
+	ret = dma_set_mask_and_coherent(&pdev->dev, dma_mask);
+	if (ret) {
+		pr_err("PCIE DMA coherent mask init failed\n");
+		goto err_base;
+	}
+
+	pci_set_master(pdev);
+	qtnf_pcie_init_irq(pcie_priv, use_msi);
+
+	ret = qtnf_pcie_init_memory(pcie_priv);
+	if (ret < 0) {
+		pr_err("PCIE memory init failed\n");
+		goto err_base;
+	}
+
+	pci_save_state(pdev);
+
+	return 0;
+
+err_base:
+	flush_workqueue(pcie_priv->workqueue);
+	destroy_workqueue(pcie_priv->workqueue);
+err_init:
+	pci_set_drvdata(pdev, NULL);
+
+	return ret;
+}
+
+static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus_priv *priv)
+{
+	qtnf_shm_ipc_free(&priv->shm_ipc_ep_in);
+	qtnf_shm_ipc_free(&priv->shm_ipc_ep_out);
+}
+
+void qtnf_pcie_remove(struct qtnf_bus *bus, struct qtnf_pcie_bus_priv *priv)
+{
+	wait_for_completion(&bus->firmware_init_complete);
+
+	if (bus->fw_state == QTNF_FW_STATE_ACTIVE ||
+	    bus->fw_state == QTNF_FW_STATE_EP_DEAD)
+		qtnf_core_detach(bus);
+
+	netif_napi_del(&bus->mux_napi);
+	flush_workqueue(priv->workqueue);
+	destroy_workqueue(priv->workqueue);
+	tasklet_kill(&priv->reclaim_tq);
+
+	qtnf_pcie_free_shm_ipc(priv);
+	qtnf_debugfs_remove(bus);
+	pci_set_drvdata(priv->pdev, NULL);
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
index 8da9612..5c70fb4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
@@ -12,6 +12,7 @@
 #include <linux/interrupt.h>
 
 #include "shm_ipc.h"
+#include "bus.h"
 
 #define SKB_BUF_SIZE		2048
 
@@ -59,6 +60,20 @@ struct qtnf_pcie_bus_priv {
 	u8 tx_stopped;
 };
 
+int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb);
+int qtnf_pcie_alloc_skb_array(struct qtnf_pcie_bus_priv *priv);
+void qtnf_pcie_bringup_fw_async(struct qtnf_bus *bus);
+void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool boot_success,
+			    const char *drv_name);
+void qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv,
+			    struct qtnf_shm_ipc_region __iomem *ipc_tx_reg,
+			    struct qtnf_shm_ipc_region __iomem *ipc_rx_reg,
+			    const struct qtnf_shm_ipc_int *ipc_int);
+int qtnf_pcie_probe(struct pci_dev *pdev, size_t priv_size,
+		    const struct qtnf_bus_ops *bus_ops, u64 dma_mask,
+		    bool use_msi);
+void qtnf_pcie_remove(struct qtnf_bus *bus, struct qtnf_pcie_bus_priv *priv);
+
 static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
 {
 	writel(val, basereg);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index fd11dd2..6d72a9d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -193,29 +193,6 @@ static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_pearl_state *ps)
 	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
 
-static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
-{
-	struct pci_dev *pdev = priv->pdev;
-
-	/* fall back to legacy INTx interrupts by default */
-	priv->msi_enabled = 0;
-
-	/* check if MSI capability is available */
-	if (use_msi) {
-		if (!pci_enable_msi(pdev)) {
-			pr_debug("MSI interrupt enabled\n");
-			priv->msi_enabled = 1;
-		} else {
-			pr_warn("failed to enable MSI interrupts");
-		}
-	}
-
-	if (!priv->msi_enabled) {
-		pr_warn("legacy PCIE interrupts enabled\n");
-		pci_intx(pdev, 1);
-	}
-}
-
 static void qtnf_deassert_intx(struct qtnf_pcie_pearl_state *ps)
 {
 	void __iomem *reg = ps->base.sysctl_bar + PEARL_PCIE_CFG0_OFFSET;
@@ -247,148 +224,6 @@ static void qtnf_pcie_pearl_ipc_gen_ep_int(void *arg)
 	qtnf_non_posted_write(data, reg);
 }
 
-static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 index)
-{
-	void __iomem *vaddr;
-	dma_addr_t busaddr;
-	size_t len;
-	int ret;
-
-	ret = pcim_iomap_regions(priv->pdev, 1 << index, DRV_NAME);
-	if (ret)
-		return IOMEM_ERR_PTR(ret);
-
-	busaddr = pci_resource_start(priv->pdev, index);
-	len = pci_resource_len(priv->pdev, index);
-	vaddr = pcim_iomap_table(priv->pdev)[index];
-	if (!vaddr)
-		return IOMEM_ERR_PTR(-ENOMEM);
-
-	pr_debug("BAR%u vaddr=0x%p busaddr=%pad len=%u\n",
-		 index, vaddr, &busaddr, (int)len);
-
-	return vaddr;
-}
-
-static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t len)
-{
-	struct qtnf_pcie_bus_priv *priv = arg;
-	struct qtnf_bus *bus = pci_get_drvdata(priv->pdev);
-	struct sk_buff *skb;
-
-	if (unlikely(len == 0)) {
-		pr_warn("zero length packet received\n");
-		return;
-	}
-
-	skb = __dev_alloc_skb(len, GFP_KERNEL);
-
-	if (unlikely(!skb)) {
-		pr_err("failed to allocate skb\n");
-		return;
-	}
-
-	skb_put_data(skb, buf, len);
-
-	qtnf_trans_handle_rx_ctl_packet(bus, skb);
-}
-
-static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_pearl_state *ps)
-{
-	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
-	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
-	const struct qtnf_shm_ipc_int ipc_int = {
-					qtnf_pcie_pearl_ipc_gen_ep_int, ps };
-	const struct qtnf_shm_ipc_rx_callback rx_callback = {
-					qtnf_pcie_control_rx_callback, ps };
-
-	ipc_tx_reg = &ps->bda->bda_shm_reg1;
-	ipc_rx_reg = &ps->bda->bda_shm_reg2;
-
-	qtnf_shm_ipc_init(&ps->base.shm_ipc_ep_in, QTNF_SHM_IPC_OUTBOUND,
-			  ipc_tx_reg, ps->base.workqueue,
-			  &ipc_int, &rx_callback);
-	qtnf_shm_ipc_init(&ps->base.shm_ipc_ep_out, QTNF_SHM_IPC_INBOUND,
-			  ipc_rx_reg, ps->base.workqueue,
-			  &ipc_int, &rx_callback);
-
-	return 0;
-}
-
-static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus_priv *priv)
-{
-	qtnf_shm_ipc_free(&priv->shm_ipc_ep_in);
-	qtnf_shm_ipc_free(&priv->shm_ipc_ep_out);
-}
-
-static int qtnf_pcie_init_memory(struct qtnf_pcie_pearl_state *ps)
-{
-	struct qtnf_pcie_bus_priv *priv = &ps->base;
-	int ret = -ENOMEM;
-
-	priv->sysctl_bar = qtnf_map_bar(priv, QTN_SYSCTL_BAR);
-	if (IS_ERR(priv->sysctl_bar)) {
-		pr_err("failed to map BAR%u\n", QTN_SYSCTL_BAR);
-		return ret;
-	}
-
-	priv->dmareg_bar = qtnf_map_bar(priv, QTN_DMA_BAR);
-	if (IS_ERR(priv->dmareg_bar)) {
-		pr_err("failed to map BAR%u\n", QTN_DMA_BAR);
-		return ret;
-	}
-
-	priv->epmem_bar = qtnf_map_bar(priv, QTN_SHMEM_BAR);
-	if (IS_ERR(priv->epmem_bar)) {
-		pr_err("failed to map BAR%u\n", QTN_SHMEM_BAR);
-		return ret;
-	}
-
-	ps->pcie_reg_base = priv->dmareg_bar;
-	ps->bda = priv->epmem_bar;
-	writel(priv->msi_enabled, &ps->bda->bda_rc_msi_enabled);
-
-	return 0;
-}
-
-static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
-{
-	struct pci_dev *pdev = priv->pdev;
-	struct pci_dev *parent;
-	int mps_p, mps_o, mps_m, mps;
-	int ret;
-
-	/* current mps */
-	mps_o = pcie_get_mps(pdev);
-
-	/* maximum supported mps */
-	mps_m = 128 << pdev->pcie_mpss;
-
-	/* suggested new mps value */
-	mps = mps_m;
-
-	if (pdev->bus && pdev->bus->self) {
-		/* parent (bus) mps */
-		parent = pdev->bus->self;
-
-		if (pci_is_pcie(parent)) {
-			mps_p = pcie_get_mps(parent);
-			mps = min(mps_m, mps_p);
-		}
-	}
-
-	ret = pcie_set_mps(pdev, mps);
-	if (ret) {
-		pr_err("failed to set mps to %d, keep using current %d\n",
-		       mps, mps_o);
-		priv->mps = mps_o;
-		return;
-	}
-
-	pr_debug("set mps to %d (was %d, max %d)\n", mps, mps_o, mps_m);
-	priv->mps = mps;
-}
-
 static int qtnf_is_state(__le32 __iomem *reg, u32 state)
 {
 	u32 s = readl(reg);
@@ -423,26 +258,6 @@ static int qtnf_poll_state(__le32 __iomem *reg, u32 state, u32 delay_in_ms)
 	return 0;
 }
 
-static int alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
-{
-	struct sk_buff **vaddr;
-	int len;
-
-	len = priv->tx_bd_num * sizeof(*priv->tx_skb) +
-		priv->rx_bd_num * sizeof(*priv->rx_skb);
-	vaddr = devm_kzalloc(&priv->pdev->dev, len, GFP_KERNEL);
-
-	if (!vaddr)
-		return -ENOMEM;
-
-	priv->tx_skb = vaddr;
-
-	vaddr += priv->tx_bd_num;
-	priv->rx_skb = vaddr;
-
-	return 0;
-}
-
 static int pearl_alloc_bd_table(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_pcie_bus_priv *priv = &ps->base;
@@ -656,7 +471,7 @@ static int qtnf_pcie_pearl_init_xfer(struct qtnf_pcie_pearl_state *ps)
 		return ret;
 	}
 
-	ret = alloc_skb_array(priv);
+	ret = qtnf_pcie_alloc_skb_array(priv);
 	if (ret) {
 		pr_err("failed to allocate skb array\n");
 		return ret;
@@ -750,7 +565,7 @@ static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_state *ps)
 
 static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
-	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps = get_bus_priv(bus);
 	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	dma_addr_t txbd_paddr, skb_paddr;
 	struct qtnf_pearl_tx_bd *txbd;
@@ -824,25 +639,10 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
-{
-	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
-	int ret;
-
-	ret = qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
-
-	if (ret == -ETIMEDOUT) {
-		pr_err("EP firmware is dead\n");
-		bus->fw_state = QTNF_FW_STATE_EP_DEAD;
-	}
-
-	return ret;
-}
-
 static irqreturn_t qtnf_pcie_pearl_interrupt(int irq, void *data)
 {
 	struct qtnf_bus *bus = (struct qtnf_bus *)data;
-	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps = get_bus_priv(bus);
 	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	u32 status;
 
@@ -902,7 +702,7 @@ static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_state *ps)
 static int qtnf_pcie_pearl_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct qtnf_bus *bus = container_of(napi, struct qtnf_bus, mux_napi);
-	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps = get_bus_priv(bus);
 	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	struct net_device *ndev = NULL;
 	struct sk_buff *skb = NULL;
@@ -1038,26 +838,6 @@ static const struct qtnf_bus_ops qtnf_pcie_pearl_bus_ops = {
 	.data_rx_stop		= qtnf_pcie_data_rx_stop,
 };
 
-static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
-{
-	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
-
-	seq_printf(s, "%d\n", priv->mps);
-
-	return 0;
-}
-
-static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
-{
-	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
-
-	seq_printf(s, "%u\n", priv->msi_enabled);
-
-	return 0;
-}
-
 static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus = dev_get_drvdata(s->private);
@@ -1114,27 +894,9 @@ static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
-{
-	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
-
-	seq_printf(s, "shm_ipc_ep_in.tx_packet_count(%zu)\n",
-		   priv->shm_ipc_ep_in.tx_packet_count);
-	seq_printf(s, "shm_ipc_ep_in.rx_packet_count(%zu)\n",
-		   priv->shm_ipc_ep_in.rx_packet_count);
-	seq_printf(s, "shm_ipc_ep_out.tx_packet_count(%zu)\n",
-		   priv->shm_ipc_ep_out.tx_timeout_count);
-	seq_printf(s, "shm_ipc_ep_out.rx_packet_count(%zu)\n",
-		   priv->shm_ipc_ep_out.rx_packet_count);
-
-	return 0;
-}
-
-static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *ps, uint32_t size,
+static int qtnf_ep_fw_send(struct pci_dev *pdev, uint32_t size,
 			   int blk, const u8 *pblk, const u8 *fw)
 {
-	struct pci_dev *pdev = ps->base.pdev;
 	struct qtnf_bus *bus = pci_get_drvdata(pdev);
 
 	struct qtnf_pearl_fw_hdr *hdr;
@@ -1197,7 +959,7 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *ps, const u8 *fw, u32 fw_size)
 			return -ETIMEDOUT;
 		}
 
-		len = qtnf_ep_fw_send(ps, fw_size, blk, pblk, fw);
+		len = qtnf_ep_fw_send(ps->base.pdev, fw_size, blk, pblk, fw);
 		if (len <= 0)
 			continue;
 
@@ -1255,6 +1017,7 @@ static void qtnf_pearl_fw_work_handler(struct work_struct *work)
 	int ret;
 	u32 state = QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK;
 	const char *fwname = QTN_PCI_PEARL_FW_NAME;
+	bool fw_boot_success = false;
 
 	if (flashboot) {
 		state |= QTN_RC_FW_FLASHBOOT;
@@ -1262,7 +1025,7 @@ static void qtnf_pearl_fw_work_handler(struct work_struct *work)
 		ret = request_firmware(&fw, fwname, &pdev->dev);
 		if (ret < 0) {
 			pr_err("failed to get firmware %s\n", fwname);
-			goto fw_load_fail;
+			goto fw_load_exit;
 		}
 	}
 
@@ -1275,13 +1038,14 @@ static void qtnf_pearl_fw_work_handler(struct work_struct *work)
 		if (!flashboot)
 			release_firmware(fw);
 
-		goto fw_load_fail;
+		goto fw_load_exit;
 	}
 
 	qtnf_clear_state(&ps->bda->bda_ep_state, QTN_EP_FW_LOADRDY);
 
 	if (flashboot) {
 		pr_info("booting firmware from flash\n");
+
 	} else {
 		pr_info("starting firmware upload: %s\n", fwname);
 
@@ -1289,56 +1053,33 @@ static void qtnf_pearl_fw_work_handler(struct work_struct *work)
 		release_firmware(fw);
 		if (ret) {
 			pr_err("firmware upload error\n");
-			goto fw_load_fail;
+			goto fw_load_exit;
 		}
 	}
 
 	if (qtnf_poll_state(&ps->bda->bda_ep_state, QTN_EP_FW_DONE,
 			    QTN_FW_DL_TIMEOUT_MS)) {
 		pr_err("firmware bringup timed out\n");
-		goto fw_load_fail;
+		goto fw_load_exit;
 	}
 
-	bus->fw_state = QTNF_FW_STATE_FW_DNLD_DONE;
 	pr_info("firmware is up and running\n");
 
 	if (qtnf_poll_state(&ps->bda->bda_ep_state,
 			    QTN_EP_FW_QLINK_DONE, QTN_FW_QLINK_TIMEOUT_MS)) {
 		pr_err("firmware runtime failure\n");
-		goto fw_load_fail;
-	}
-
-	ret = qtnf_core_attach(bus);
-	if (ret) {
-		pr_err("failed to attach core\n");
-		goto fw_load_fail;
+		goto fw_load_exit;
 	}
 
-	qtnf_debugfs_init(bus, DRV_NAME);
-	qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
-	qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
-	qtnf_debugfs_add_entry(bus, "hdp_stats", qtnf_dbg_hdp_stats);
-	qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
-	qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
-
-	goto fw_load_exit;
-
-fw_load_fail:
-	bus->fw_state = QTNF_FW_STATE_DETACHED;
+	fw_boot_success = true;
 
 fw_load_exit:
-	complete(&bus->firmware_init_complete);
-	put_device(&pdev->dev);
-}
+	qtnf_pcie_fw_boot_done(bus, fw_boot_success, DRV_NAME);
 
-static void qtnf_bringup_fw_async(struct qtnf_bus *bus)
-{
-	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
-	struct pci_dev *pdev = priv->pdev;
-
-	get_device(&pdev->dev);
-	INIT_WORK(&bus->fw_work, qtnf_pearl_fw_work_handler);
-	schedule_work(&bus->fw_work);
+	if (fw_boot_success) {
+		qtnf_debugfs_add_entry(bus, "hdp_stats", qtnf_dbg_hdp_stats);
+		qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
+	}
 }
 
 static void qtnf_pearl_reclaim_tasklet_fn(unsigned long data)
@@ -1352,100 +1093,47 @@ static void qtnf_pearl_reclaim_tasklet_fn(unsigned long data)
 static int qtnf_pcie_pearl_probe(struct pci_dev *pdev,
 				 const struct pci_device_id *id)
 {
+	struct qtnf_shm_ipc_int ipc_int;
 	struct qtnf_pcie_pearl_state *ps;
 	struct qtnf_bus *bus;
 	int ret;
+	u64 dma_mask;
 
-	bus = devm_kzalloc(&pdev->dev,
-			   sizeof(*bus) + sizeof(*ps), GFP_KERNEL);
-	if (!bus)
-		return -ENOMEM;
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	dma_mask = DMA_BIT_MASK(64);
+#else
+	dma_mask = DMA_BIT_MASK(32);
+#endif
 
-	ps = get_bus_priv(bus);
+	ret = qtnf_pcie_probe(pdev, sizeof(*ps), &qtnf_pcie_pearl_bus_ops,
+			      dma_mask, use_msi);
+	if (ret)
+		return ret;
 
-	pci_set_drvdata(pdev, bus);
-	bus->bus_ops = &qtnf_pcie_pearl_bus_ops;
-	bus->dev = &pdev->dev;
-	bus->fw_state = QTNF_FW_STATE_RESET;
-	ps->base.pdev = pdev;
+	bus = pci_get_drvdata(pdev);
+	ps = get_bus_priv(bus);
 
-	init_completion(&bus->firmware_init_complete);
-	mutex_init(&bus->bus_lock);
-	spin_lock_init(&ps->base.tx_lock);
 	spin_lock_init(&ps->irq_lock);
-	spin_lock_init(&ps->base.tx_reclaim_lock);
-
-	/* init stats */
-	ps->base.tx_full_count = 0;
-	ps->base.tx_done_count = 0;
-	ps->base.pcie_irq_count = 0;
-	ps->pcie_irq_rx_count = 0;
-	ps->pcie_irq_tx_count = 0;
-	ps->pcie_irq_uf_count = 0;
-	ps->base.tx_reclaim_done = 0;
-	ps->base.tx_reclaim_req = 0;
 
 	tasklet_init(&ps->base.reclaim_tq, qtnf_pearl_reclaim_tasklet_fn,
 		     (unsigned long)ps);
-
-	init_dummy_netdev(&bus->mux_dev);
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
 		       qtnf_pcie_pearl_rx_poll, 10);
+	INIT_WORK(&bus->fw_work, qtnf_pearl_fw_work_handler);
 
-	ps->base.workqueue = create_singlethread_workqueue("QTNF_PEARL_PCIE");
-	if (!ps->base.workqueue) {
-		pr_err("failed to alloc bus workqueue\n");
-		ret = -ENODEV;
-		goto err_init;
-	}
-
-	if (!pci_is_pcie(pdev)) {
-		pr_err("device %s is not PCI Express\n", pci_name(pdev));
-		ret = -EIO;
-		goto err_base;
-	}
-
-	qtnf_tune_pcie_mps(&ps->base);
-
-	ret = pcim_enable_device(pdev);
-	if (ret) {
-		pr_err("failed to init PCI device %x\n", pdev->device);
-		goto err_base;
-	} else {
-		pr_debug("successful init of PCI device %x\n", pdev->device);
-	}
-
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-#else
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-#endif
-	if (ret) {
-		pr_err("PCIE DMA coherent mask init failed\n");
-		goto err_base;
-	}
-
-	pci_set_master(pdev);
-	qtnf_pcie_init_irq(&ps->base);
-
-	ret = qtnf_pcie_init_memory(ps);
-	if (ret < 0) {
-		pr_err("PCIE memory init failed\n");
-		goto err_base;
-	}
-
-	pci_save_state(pdev);
+	ps->pcie_reg_base = ps->base.dmareg_bar;
+	ps->bda = ps->base.epmem_bar;
+	writel(ps->base.msi_enabled, &ps->bda->bda_rc_msi_enabled);
 
-	ret = qtnf_pcie_init_shm_ipc(ps);
-	if (ret < 0) {
-		pr_err("PCIE SHM IPC init failed\n");
-		goto err_base;
-	}
+	ipc_int.fn = qtnf_pcie_pearl_ipc_gen_ep_int;
+	ipc_int.arg = ps;
+	qtnf_pcie_init_shm_ipc(&ps->base, &ps->bda->bda_shm_reg1,
+			       &ps->bda->bda_shm_reg2, &ipc_int);
 
 	ret = qtnf_pcie_pearl_init_xfer(ps);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
-		goto err_ipc;
+		goto error;
 	}
 
 	/* init default irq settings */
@@ -1462,24 +1150,14 @@ static int qtnf_pcie_pearl_probe(struct pci_dev *pdev,
 		goto err_xfer;
 	}
 
-	qtnf_bringup_fw_async(bus);
+	qtnf_pcie_bringup_fw_async(bus);
 
 	return 0;
 
 err_xfer:
 	qtnf_pearl_free_xfer_buffers(ps);
-
-err_ipc:
-	qtnf_pcie_free_shm_ipc(&ps->base);
-
-err_base:
-	flush_workqueue(ps->base.workqueue);
-	destroy_workqueue(ps->base.workqueue);
-
-err_init:
-	tasklet_kill(&ps->base.reclaim_tq);
-	netif_napi_del(&bus->mux_napi);
-	pci_set_drvdata(pdev, NULL);
+error:
+	qtnf_pcie_remove(bus, &ps->base);
 
 	return ret;
 }
@@ -1493,22 +1171,11 @@ static void qtnf_pcie_pearl_remove(struct pci_dev *pdev)
 	if (!bus)
 		return;
 
-	wait_for_completion(&bus->firmware_init_complete);
-
-	if (bus->fw_state == QTNF_FW_STATE_ACTIVE ||
-	    bus->fw_state == QTNF_FW_STATE_EP_DEAD)
-		qtnf_core_detach(bus);
-
 	ps = get_bus_priv(bus);
-	qtnf_pearl_reset_ep(ps);
-	netif_napi_del(&bus->mux_napi);
-	flush_workqueue(ps->base.workqueue);
-	destroy_workqueue(ps->base.workqueue);
-	tasklet_kill(&ps->base.reclaim_tq);
 
+	qtnf_pcie_remove(bus, &ps->base);
+	qtnf_pearl_reset_ep(ps);
 	qtnf_pearl_free_xfer_buffers(ps);
-	qtnf_pcie_free_shm_ipc(&ps->base);
-	qtnf_debugfs_remove(bus);
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
index b87505d..f21e97e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
@@ -63,10 +63,6 @@
 #define QTN_HOST_ADDR(h, l)	((u32)l)
 #endif
 
-#define QTN_SYSCTL_BAR	0
-#define QTN_SHMEM_BAR	2
-#define QTN_DMA_BAR	3
-
 #define QTN_PCIE_BDA_VERSION		0x1002
 
 #define PCIE_BDA_NAMELEN		32
-- 
2.9.5

