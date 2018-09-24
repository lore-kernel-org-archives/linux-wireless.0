Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B955C43382
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18DF2204EC
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:16:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18DF2204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbeIYEUf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:20:35 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46852 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1728585AbeIYETr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:47 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOH012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 07/11] qtnfmac_pcie: rename platform-specific functions
Date:   Mon, 24 Sep 2018 15:15:10 -0700
Message-Id: <20180924221514.4273-8-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rename several functions to indicate that they are platform specific.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 101 +++++++++++----------
 1 file changed, 52 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 97f3001..fd11dd2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -226,7 +226,7 @@ static void qtnf_deassert_intx(struct qtnf_pcie_pearl_state *ps)
 	qtnf_non_posted_write(cfg, reg);
 }
 
-static void qtnf_reset_card(struct qtnf_pcie_pearl_state *ps)
+static void qtnf_pearl_reset_ep(struct qtnf_pcie_pearl_state *ps)
 {
 	const u32 data = QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_EP_RESET);
 	void __iomem *reg = ps->base.sysctl_bar +
@@ -237,7 +237,7 @@ static void qtnf_reset_card(struct qtnf_pcie_pearl_state *ps)
 	pci_restore_state(ps->base.pdev);
 }
 
-static void qtnf_ipc_gen_ep_int(void *arg)
+static void qtnf_pcie_pearl_ipc_gen_ep_int(void *arg)
 {
 	const struct qtnf_pcie_pearl_state *ps = arg;
 	const u32 data = QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_IPC_IRQ);
@@ -297,7 +297,8 @@ static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
 	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
-	const struct qtnf_shm_ipc_int ipc_int = { qtnf_ipc_gen_ep_int, ps };
+	const struct qtnf_shm_ipc_int ipc_int = {
+					qtnf_pcie_pearl_ipc_gen_ep_int, ps };
 	const struct qtnf_shm_ipc_rx_callback rx_callback = {
 					qtnf_pcie_control_rx_callback, ps };
 
@@ -442,7 +443,7 @@ static int alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
 	return 0;
 }
 
-static int alloc_bd_table(struct qtnf_pcie_pearl_state *ps)
+static int pearl_alloc_bd_table(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	dma_addr_t paddr;
@@ -494,7 +495,7 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state *ps)
 	return 0;
 }
 
-static int skb2rbd_attach(struct qtnf_pcie_pearl_state *ps, u16 index)
+static int pearl_skb2rbd_attach(struct qtnf_pcie_pearl_state *ps, u16 index)
 {
 	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	struct qtnf_pearl_rx_bd *rxbd;
@@ -538,7 +539,7 @@ static int skb2rbd_attach(struct qtnf_pcie_pearl_state *ps, u16 index)
 	return 0;
 }
 
-static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *ps)
+static int pearl_alloc_rx_buffers(struct qtnf_pcie_pearl_state *ps)
 {
 	u16 i;
 	int ret = 0;
@@ -547,7 +548,7 @@ static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *ps)
 	       ps->base.rx_bd_num * sizeof(struct qtnf_pearl_rx_bd));
 
 	for (i = 0; i < ps->base.rx_bd_num; i++) {
-		ret = skb2rbd_attach(ps, i);
+		ret = pearl_skb2rbd_attach(ps, i);
 		if (ret)
 			break;
 	}
@@ -556,7 +557,7 @@ static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *ps)
 }
 
 /* all rx/tx activity should have ceased before calling this function */
-static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *ps)
+static void qtnf_pearl_free_xfer_buffers(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	struct qtnf_pearl_tx_bd *txbd;
@@ -594,7 +595,7 @@ static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *ps)
 	}
 }
 
-static int qtnf_hhbm_init(struct qtnf_pcie_pearl_state *ps)
+static int pearl_hhbm_init(struct qtnf_pcie_pearl_state *ps)
 {
 	u32 val;
 
@@ -612,7 +613,7 @@ static int qtnf_hhbm_init(struct qtnf_pcie_pearl_state *ps)
 	return 0;
 }
 
-static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *ps)
+static int qtnf_pcie_pearl_init_xfer(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	int ret;
@@ -649,7 +650,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *ps)
 		return -EINVAL;
 	}
 
-	ret = qtnf_hhbm_init(ps);
+	ret = pearl_hhbm_init(ps);
 	if (ret) {
 		pr_err("failed to init h/w queues\n");
 		return ret;
@@ -661,13 +662,13 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *ps)
 		return ret;
 	}
 
-	ret = alloc_bd_table(ps);
+	ret = pearl_alloc_bd_table(ps);
 	if (ret) {
 		pr_err("failed to allocate bd table\n");
 		return ret;
 	}
 
-	ret = alloc_rx_buffers(ps);
+	ret = pearl_alloc_rx_buffers(ps);
 	if (ret) {
 		pr_err("failed to allocate rx buffers\n");
 		return ret;
@@ -676,7 +677,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *ps)
 	return ret;
 }
 
-static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *ps)
+static void qtnf_pearl_data_tx_reclaim(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_pcie_bus_priv *priv = &ps->base;
 	struct qtnf_pearl_tx_bd *txbd;
@@ -734,7 +735,7 @@ static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_state *ps)
 
 	if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 			priv->tx_bd_num)) {
-		qtnf_pcie_data_tx_reclaim(ps);
+		qtnf_pearl_data_tx_reclaim(ps);
 
 		if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 				priv->tx_bd_num)) {
@@ -818,7 +819,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	priv->tx_done_count++;
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
-	qtnf_pcie_data_tx_reclaim(ps);
+	qtnf_pearl_data_tx_reclaim(ps);
 
 	return NETDEV_TX_OK;
 }
@@ -838,7 +839,7 @@ static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	return ret;
 }
 
-static irqreturn_t qtnf_interrupt(int irq, void *data)
+static irqreturn_t qtnf_pcie_pearl_interrupt(int irq, void *data)
 {
 	struct qtnf_bus *bus = (struct qtnf_bus *)data;
 	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
@@ -898,7 +899,7 @@ static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_state *ps)
 	return 0;
 }
 
-static int qtnf_rx_poll(struct napi_struct *napi, int budget)
+static int qtnf_pcie_pearl_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct qtnf_bus *bus = container_of(napi, struct qtnf_bus, mux_napi);
 	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
@@ -982,7 +983,7 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 			if (++w_idx >= priv->rx_bd_num)
 				w_idx = 0;
 
-			ret = skb2rbd_attach(ps, w_idx);
+			ret = pearl_skb2rbd_attach(ps, w_idx);
 			if (ret) {
 				pr_err("failed to allocate new rx_skb[%d]\n",
 				       w_idx);
@@ -1026,7 +1027,7 @@ static void qtnf_pcie_data_rx_stop(struct qtnf_bus *bus)
 	qtnf_disable_hdp_irqs(ps);
 }
 
-static const struct qtnf_bus_ops qtnf_pcie_bus_ops = {
+static const struct qtnf_bus_ops qtnf_pcie_pearl_bus_ops = {
 	/* control path methods */
 	.control_tx	= qtnf_pcie_control_tx,
 
@@ -1234,7 +1235,7 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *ps, const u8 *fw, u32 fw_size)
 				continue;
 			}
 
-			qtnf_pcie_data_tx_reclaim(ps);
+			qtnf_pearl_data_tx_reclaim(ps);
 		}
 
 		pblk += len;
@@ -1245,7 +1246,7 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *ps, const u8 *fw, u32 fw_size)
 	return 0;
 }
 
-static void qtnf_fw_work_handler(struct work_struct *work)
+static void qtnf_pearl_fw_work_handler(struct work_struct *work)
 {
 	struct qtnf_bus *bus = container_of(work, struct qtnf_bus, fw_work);
 	struct qtnf_pcie_pearl_state *ps = (void *)get_bus_priv(bus);
@@ -1336,19 +1337,20 @@ static void qtnf_bringup_fw_async(struct qtnf_bus *bus)
 	struct pci_dev *pdev = priv->pdev;
 
 	get_device(&pdev->dev);
-	INIT_WORK(&bus->fw_work, qtnf_fw_work_handler);
+	INIT_WORK(&bus->fw_work, qtnf_pearl_fw_work_handler);
 	schedule_work(&bus->fw_work);
 }
 
-static void qtnf_reclaim_tasklet_fn(unsigned long data)
+static void qtnf_pearl_reclaim_tasklet_fn(unsigned long data)
 {
 	struct qtnf_pcie_pearl_state *ps = (void *)data;
 
-	qtnf_pcie_data_tx_reclaim(ps);
+	qtnf_pearl_data_tx_reclaim(ps);
 	qtnf_en_txdone_irq(ps);
 }
 
-static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int qtnf_pcie_pearl_probe(struct pci_dev *pdev,
+				 const struct pci_device_id *id)
 {
 	struct qtnf_pcie_pearl_state *ps;
 	struct qtnf_bus *bus;
@@ -1362,7 +1364,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ps = get_bus_priv(bus);
 
 	pci_set_drvdata(pdev, bus);
-	bus->bus_ops = &qtnf_pcie_bus_ops;
+	bus->bus_ops = &qtnf_pcie_pearl_bus_ops;
 	bus->dev = &pdev->dev;
 	bus->fw_state = QTNF_FW_STATE_RESET;
 	ps->base.pdev = pdev;
@@ -1383,12 +1385,12 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ps->base.tx_reclaim_done = 0;
 	ps->base.tx_reclaim_req = 0;
 
-	tasklet_init(&ps->base.reclaim_tq, qtnf_reclaim_tasklet_fn,
+	tasklet_init(&ps->base.reclaim_tq, qtnf_pearl_reclaim_tasklet_fn,
 		     (unsigned long)ps);
 
 	init_dummy_netdev(&bus->mux_dev);
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
-		       qtnf_rx_poll, 10);
+		       qtnf_pcie_pearl_rx_poll, 10);
 
 	ps->base.workqueue = create_singlethread_workqueue("QTNF_PEARL_PCIE");
 	if (!ps->base.workqueue) {
@@ -1440,7 +1442,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_base;
 	}
 
-	ret = qtnf_pcie_init_xfer(ps);
+	ret = qtnf_pcie_pearl_init_xfer(ps);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
 		goto err_ipc;
@@ -1452,7 +1454,8 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* start with disabled irqs */
 	qtnf_disable_hdp_irqs(ps);
 
-	ret = devm_request_irq(&pdev->dev, pdev->irq, &qtnf_interrupt, 0,
+	ret = devm_request_irq(&pdev->dev, pdev->irq,
+			       &qtnf_pcie_pearl_interrupt, 0,
 			       "qtnf_pcie_irq", (void *)bus);
 	if (ret) {
 		pr_err("failed to request pcie irq %d\n", pdev->irq);
@@ -1464,7 +1467,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_xfer:
-	qtnf_free_xfer_buffers(ps);
+	qtnf_pearl_free_xfer_buffers(ps);
 
 err_ipc:
 	qtnf_pcie_free_shm_ipc(&ps->base);
@@ -1481,7 +1484,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
-static void qtnf_pcie_remove(struct pci_dev *pdev)
+static void qtnf_pcie_pearl_remove(struct pci_dev *pdev)
 {
 	struct qtnf_pcie_pearl_state *ps;
 	struct qtnf_bus *bus;
@@ -1497,24 +1500,24 @@ static void qtnf_pcie_remove(struct pci_dev *pdev)
 		qtnf_core_detach(bus);
 
 	ps = get_bus_priv(bus);
-	qtnf_reset_card(ps);
+	qtnf_pearl_reset_ep(ps);
 	netif_napi_del(&bus->mux_napi);
 	flush_workqueue(ps->base.workqueue);
 	destroy_workqueue(ps->base.workqueue);
 	tasklet_kill(&ps->base.reclaim_tq);
 
-	qtnf_free_xfer_buffers(ps);
+	qtnf_pearl_free_xfer_buffers(ps);
 	qtnf_pcie_free_shm_ipc(&ps->base);
 	qtnf_debugfs_remove(bus);
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int qtnf_pcie_suspend(struct device *dev)
+static int qtnf_pcie_pearl_suspend(struct device *dev)
 {
 	return -EOPNOTSUPP;
 }
 
-static int qtnf_pcie_resume(struct device *dev)
+static int qtnf_pcie_pearl_resume(struct device *dev)
 {
 	return 0;
 }
@@ -1522,8 +1525,8 @@ static int qtnf_pcie_resume(struct device *dev)
 
 #ifdef CONFIG_PM_SLEEP
 /* Power Management Hooks */
-static SIMPLE_DEV_PM_OPS(qtnf_pcie_pm_ops, qtnf_pcie_suspend,
-			 qtnf_pcie_resume);
+static SIMPLE_DEV_PM_OPS(qtnf_pcie_pearl_pm_ops, qtnf_pcie_pearl_suspend,
+			 qtnf_pcie_pearl_resume);
 #endif
 
 static const struct pci_device_id qtnf_pcie_devid_table[] = {
@@ -1536,32 +1539,32 @@ static const struct pci_device_id qtnf_pcie_devid_table[] = {
 
 MODULE_DEVICE_TABLE(pci, qtnf_pcie_devid_table);
 
-static struct pci_driver qtnf_pcie_drv_data = {
+static struct pci_driver qtnf_pcie_pearl_drv_data = {
 	.name = DRV_NAME,
 	.id_table = qtnf_pcie_devid_table,
-	.probe = qtnf_pcie_probe,
-	.remove = qtnf_pcie_remove,
+	.probe = qtnf_pcie_pearl_probe,
+	.remove = qtnf_pcie_pearl_remove,
 #ifdef CONFIG_PM_SLEEP
 	.driver = {
-		.pm = &qtnf_pcie_pm_ops,
+		.pm = &qtnf_pcie_pearl_pm_ops,
 	},
 #endif
 };
 
-static int __init qtnf_pcie_register(void)
+static int __init qtnf_pcie_pearl_register(void)
 {
 	pr_info("register Quantenna QSR10g FullMAC PCIE driver\n");
-	return pci_register_driver(&qtnf_pcie_drv_data);
+	return pci_register_driver(&qtnf_pcie_pearl_drv_data);
 }
 
-static void __exit qtnf_pcie_exit(void)
+static void __exit qtnf_pcie_pearl_exit(void)
 {
 	pr_info("unregister Quantenna QSR10g FullMAC PCIE driver\n");
-	pci_unregister_driver(&qtnf_pcie_drv_data);
+	pci_unregister_driver(&qtnf_pcie_pearl_drv_data);
 }
 
-module_init(qtnf_pcie_register);
-module_exit(qtnf_pcie_exit);
+module_init(qtnf_pcie_pearl_register);
+module_exit(qtnf_pcie_pearl_exit);
 
 MODULE_AUTHOR("Quantenna Communications");
 MODULE_DESCRIPTION("Quantenna QSR10g PCIe bus driver for 802.11 wireless LAN.");
-- 
2.9.5

