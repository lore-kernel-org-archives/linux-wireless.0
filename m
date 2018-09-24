Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr700049.outbound.protection.outlook.com ([40.107.70.49]:61600
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727398AbeIXLPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:15:06 -0400
From: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 07/11] qtnfmac_pcie: rename platform-specific functions
Date: Mon, 24 Sep 2018 05:13:30 +0000
Message-ID: <20180924051246.13371-8-igor.mitsyanko.os@quantenna.com> (sfid-20180924_071450_655303_A0C9CFBD)
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
In-Reply-To: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename several functions to indicate that they are platform specific.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 100 +++++++++++------=
----
 1 file changed, 51 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 97f3001..f3655de 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -226,7 +226,7 @@ static void qtnf_deassert_intx(struct qtnf_pcie_pearl_s=
tate *ps)
 	qtnf_non_posted_write(cfg, reg);
 }
=20
-static void qtnf_reset_card(struct qtnf_pcie_pearl_state *ps)
+static void qtnf_pearl_reset_ep(struct qtnf_pcie_pearl_state *ps)
 {
 	const u32 data =3D QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_EP_RESET);
 	void __iomem *reg =3D ps->base.sysctl_bar +
@@ -237,7 +237,7 @@ static void qtnf_reset_card(struct qtnf_pcie_pearl_stat=
e *ps)
 	pci_restore_state(ps->base.pdev);
 }
=20
-static void qtnf_ipc_gen_ep_int(void *arg)
+static void qtnf_pcie_pearl_ipc_gen_ep_int(void *arg)
 {
 	const struct qtnf_pcie_pearl_state *ps =3D arg;
 	const u32 data =3D QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_IPC_IRQ);
@@ -297,7 +297,8 @@ static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_pear=
l_state *ps)
 {
 	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
 	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
-	const struct qtnf_shm_ipc_int ipc_int =3D { qtnf_ipc_gen_ep_int, ps };
+	const struct qtnf_shm_ipc_int ipc_int =3D
+					{ qtnf_pcie_pearl_ipc_gen_ep_int, ps };
 	const struct qtnf_shm_ipc_rx_callback rx_callback =3D {
 					qtnf_pcie_control_rx_callback, ps };
=20
@@ -442,7 +443,7 @@ static int alloc_skb_array(struct qtnf_pcie_bus_priv *p=
riv)
 	return 0;
 }
=20
-static int alloc_bd_table(struct qtnf_pcie_pearl_state *ps)
+static int pearl_alloc_bd_table(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	dma_addr_t paddr;
@@ -494,7 +495,7 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state =
*ps)
 	return 0;
 }
=20
-static int skb2rbd_attach(struct qtnf_pcie_pearl_state *ps, u16 index)
+static int pearl_skb2rbd_attach(struct qtnf_pcie_pearl_state *ps, u16 inde=
x)
 {
 	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	struct qtnf_pearl_rx_bd *rxbd;
@@ -538,7 +539,7 @@ static int skb2rbd_attach(struct qtnf_pcie_pearl_state =
*ps, u16 index)
 	return 0;
 }
=20
-static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *ps)
+static int pearl_alloc_rx_buffers(struct qtnf_pcie_pearl_state *ps)
 {
 	u16 i;
 	int ret =3D 0;
@@ -547,7 +548,7 @@ static int alloc_rx_buffers(struct qtnf_pcie_pearl_stat=
e *ps)
 	       ps->base.rx_bd_num * sizeof(struct qtnf_pearl_rx_bd));
=20
 	for (i =3D 0; i < ps->base.rx_bd_num; i++) {
-		ret =3D skb2rbd_attach(ps, i);
+		ret =3D pearl_skb2rbd_attach(ps, i);
 		if (ret)
 			break;
 	}
@@ -556,7 +557,7 @@ static int alloc_rx_buffers(struct qtnf_pcie_pearl_stat=
e *ps)
 }
=20
 /* all rx/tx activity should have ceased before calling this function */
-static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *ps)
+static void qtnf_pearl_free_xfer_buffers(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	struct qtnf_pearl_tx_bd *txbd;
@@ -594,7 +595,7 @@ static void qtnf_free_xfer_buffers(struct qtnf_pcie_pea=
rl_state *ps)
 	}
 }
=20
-static int qtnf_hhbm_init(struct qtnf_pcie_pearl_state *ps)
+static int pearl_hhbm_init(struct qtnf_pcie_pearl_state *ps)
 {
 	u32 val;
=20
@@ -612,7 +613,7 @@ static int qtnf_hhbm_init(struct qtnf_pcie_pearl_state =
*ps)
 	return 0;
 }
=20
-static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *ps)
+static int qtnf_pcie_pearl_init_xfer(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	int ret;
@@ -649,7 +650,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_s=
tate *ps)
 		return -EINVAL;
 	}
=20
-	ret =3D qtnf_hhbm_init(ps);
+	ret =3D pearl_hhbm_init(ps);
 	if (ret) {
 		pr_err("failed to init h/w queues\n");
 		return ret;
@@ -661,13 +662,13 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl=
_state *ps)
 		return ret;
 	}
=20
-	ret =3D alloc_bd_table(ps);
+	ret =3D pearl_alloc_bd_table(ps);
 	if (ret) {
 		pr_err("failed to allocate bd table\n");
 		return ret;
 	}
=20
-	ret =3D alloc_rx_buffers(ps);
+	ret =3D pearl_alloc_rx_buffers(ps);
 	if (ret) {
 		pr_err("failed to allocate rx buffers\n");
 		return ret;
@@ -676,7 +677,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_s=
tate *ps)
 	return ret;
 }
=20
-static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *ps)
+static void qtnf_pearl_data_tx_reclaim(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	struct qtnf_pearl_tx_bd *txbd;
@@ -734,7 +735,7 @@ static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_s=
tate *ps)
=20
 	if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 			priv->tx_bd_num)) {
-		qtnf_pcie_data_tx_reclaim(ps);
+		qtnf_pearl_data_tx_reclaim(ps);
=20
 		if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 				priv->tx_bd_num)) {
@@ -818,7 +819,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
 	priv->tx_done_count++;
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
=20
-	qtnf_pcie_data_tx_reclaim(ps);
+	qtnf_pearl_data_tx_reclaim(ps);
=20
 	return NETDEV_TX_OK;
 }
@@ -838,7 +839,7 @@ static int qtnf_pcie_control_tx(struct qtnf_bus *bus, s=
truct sk_buff *skb)
 	return ret;
 }
=20
-static irqreturn_t qtnf_interrupt(int irq, void *data)
+static irqreturn_t qtnf_pcie_pearl_interrupt(int irq, void *data)
 {
 	struct qtnf_bus *bus =3D (struct qtnf_bus *)data;
 	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
@@ -898,7 +899,7 @@ static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_st=
ate *ps)
 	return 0;
 }
=20
-static int qtnf_rx_poll(struct napi_struct *napi, int budget)
+static int qtnf_pcie_pearl_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct qtnf_bus *bus =3D container_of(napi, struct qtnf_bus, mux_napi);
 	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
@@ -982,7 +983,7 @@ static int qtnf_rx_poll(struct napi_struct *napi, int b=
udget)
 			if (++w_idx >=3D priv->rx_bd_num)
 				w_idx =3D 0;
=20
-			ret =3D skb2rbd_attach(ps, w_idx);
+			ret =3D pearl_skb2rbd_attach(ps, w_idx);
 			if (ret) {
 				pr_err("failed to allocate new rx_skb[%d]\n",
 				       w_idx);
@@ -1026,7 +1027,7 @@ static void qtnf_pcie_data_rx_stop(struct qtnf_bus *b=
us)
 	qtnf_disable_hdp_irqs(ps);
 }
=20
-static const struct qtnf_bus_ops qtnf_pcie_bus_ops =3D {
+static const struct qtnf_bus_ops qtnf_pcie_pearl_bus_ops =3D {
 	/* control path methods */
 	.control_tx	=3D qtnf_pcie_control_tx,
=20
@@ -1234,7 +1235,7 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *ps, con=
st u8 *fw, u32 fw_size)
 				continue;
 			}
=20
-			qtnf_pcie_data_tx_reclaim(ps);
+			qtnf_pearl_data_tx_reclaim(ps);
 		}
=20
 		pblk +=3D len;
@@ -1245,7 +1246,7 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *ps, con=
st u8 *fw, u32 fw_size)
 	return 0;
 }
=20
-static void qtnf_fw_work_handler(struct work_struct *work)
+static void qtnf_pearl_fw_work_handler(struct work_struct *work)
 {
 	struct qtnf_bus *bus =3D container_of(work, struct qtnf_bus, fw_work);
 	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
@@ -1336,19 +1337,19 @@ static void qtnf_bringup_fw_async(struct qtnf_bus *=
bus)
 	struct pci_dev *pdev =3D priv->pdev;
=20
 	get_device(&pdev->dev);
-	INIT_WORK(&bus->fw_work, qtnf_fw_work_handler);
+	INIT_WORK(&bus->fw_work, qtnf_pearl_fw_work_handler);
 	schedule_work(&bus->fw_work);
 }
=20
-static void qtnf_reclaim_tasklet_fn(unsigned long data)
+static void qtnf_pearl_reclaim_tasklet_fn(unsigned long data)
 {
 	struct qtnf_pcie_pearl_state *ps =3D (void *)data;
=20
-	qtnf_pcie_data_tx_reclaim(ps);
+	qtnf_pearl_data_tx_reclaim(ps);
 	qtnf_en_txdone_irq(ps);
 }
=20
-static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_i=
d *id)
+static int qtnf_pcie_pearl_probe(struct pci_dev *pdev, const struct pci_de=
vice_id *id)
 {
 	struct qtnf_pcie_pearl_state *ps;
 	struct qtnf_bus *bus;
@@ -1362,7 +1363,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
 	ps =3D get_bus_priv(bus);
=20
 	pci_set_drvdata(pdev, bus);
-	bus->bus_ops =3D &qtnf_pcie_bus_ops;
+	bus->bus_ops =3D &qtnf_pcie_pearl_bus_ops;
 	bus->dev =3D &pdev->dev;
 	bus->fw_state =3D QTNF_FW_STATE_RESET;
 	ps->base.pdev =3D pdev;
@@ -1383,12 +1384,12 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, co=
nst struct pci_device_id *id)
 	ps->base.tx_reclaim_done =3D 0;
 	ps->base.tx_reclaim_req =3D 0;
=20
-	tasklet_init(&ps->base.reclaim_tq, qtnf_reclaim_tasklet_fn,
+	tasklet_init(&ps->base.reclaim_tq, qtnf_pearl_reclaim_tasklet_fn,
 		     (unsigned long)ps);
=20
 	init_dummy_netdev(&bus->mux_dev);
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
-		       qtnf_rx_poll, 10);
+		       qtnf_pcie_pearl_rx_poll, 10);
=20
 	ps->base.workqueue =3D create_singlethread_workqueue("QTNF_PEARL_PCIE");
 	if (!ps->base.workqueue) {
@@ -1440,7 +1441,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
 		goto err_base;
 	}
=20
-	ret =3D qtnf_pcie_init_xfer(ps);
+	ret =3D qtnf_pcie_pearl_init_xfer(ps);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
 		goto err_ipc;
@@ -1452,7 +1453,8 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
 	/* start with disabled irqs */
 	qtnf_disable_hdp_irqs(ps);
=20
-	ret =3D devm_request_irq(&pdev->dev, pdev->irq, &qtnf_interrupt, 0,
+	ret =3D devm_request_irq(&pdev->dev, pdev->irq,
+			       &qtnf_pcie_pearl_interrupt, 0,
 			       "qtnf_pcie_irq", (void *)bus);
 	if (ret) {
 		pr_err("failed to request pcie irq %d\n", pdev->irq);
@@ -1464,7 +1466,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
 	return 0;
=20
 err_xfer:
-	qtnf_free_xfer_buffers(ps);
+	qtnf_pearl_free_xfer_buffers(ps);
=20
 err_ipc:
 	qtnf_pcie_free_shm_ipc(&ps->base);
@@ -1481,7 +1483,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
 	return ret;
 }
=20
-static void qtnf_pcie_remove(struct pci_dev *pdev)
+static void qtnf_pcie_pearl_remove(struct pci_dev *pdev)
 {
 	struct qtnf_pcie_pearl_state *ps;
 	struct qtnf_bus *bus;
@@ -1497,24 +1499,24 @@ static void qtnf_pcie_remove(struct pci_dev *pdev)
 		qtnf_core_detach(bus);
=20
 	ps =3D get_bus_priv(bus);
-	qtnf_reset_card(ps);
+	qtnf_pearl_reset_ep(ps);
 	netif_napi_del(&bus->mux_napi);
 	flush_workqueue(ps->base.workqueue);
 	destroy_workqueue(ps->base.workqueue);
 	tasklet_kill(&ps->base.reclaim_tq);
=20
-	qtnf_free_xfer_buffers(ps);
+	qtnf_pearl_free_xfer_buffers(ps);
 	qtnf_pcie_free_shm_ipc(&ps->base);
 	qtnf_debugfs_remove(bus);
 }
=20
 #ifdef CONFIG_PM_SLEEP
-static int qtnf_pcie_suspend(struct device *dev)
+static int qtnf_pcie_pearl_suspend(struct device *dev)
 {
 	return -EOPNOTSUPP;
 }
=20
-static int qtnf_pcie_resume(struct device *dev)
+static int qtnf_pcie_pearl_resume(struct device *dev)
 {
 	return 0;
 }
@@ -1522,8 +1524,8 @@ static int qtnf_pcie_resume(struct device *dev)
=20
 #ifdef CONFIG_PM_SLEEP
 /* Power Management Hooks */
-static SIMPLE_DEV_PM_OPS(qtnf_pcie_pm_ops, qtnf_pcie_suspend,
-			 qtnf_pcie_resume);
+static SIMPLE_DEV_PM_OPS(qtnf_pcie_pearl_pm_ops, qtnf_pcie_pearl_suspend,
+			 qtnf_pcie_pearl_resume);
 #endif
=20
 static const struct pci_device_id qtnf_pcie_devid_table[] =3D {
@@ -1536,32 +1538,32 @@ static const struct pci_device_id qtnf_pcie_devid_t=
able[] =3D {
=20
 MODULE_DEVICE_TABLE(pci, qtnf_pcie_devid_table);
=20
-static struct pci_driver qtnf_pcie_drv_data =3D {
+static struct pci_driver qtnf_pcie_pearl_drv_data =3D {
 	.name =3D DRV_NAME,
 	.id_table =3D qtnf_pcie_devid_table,
-	.probe =3D qtnf_pcie_probe,
-	.remove =3D qtnf_pcie_remove,
+	.probe =3D qtnf_pcie_pearl_probe,
+	.remove =3D qtnf_pcie_pearl_remove,
 #ifdef CONFIG_PM_SLEEP
 	.driver =3D {
-		.pm =3D &qtnf_pcie_pm_ops,
+		.pm =3D &qtnf_pcie_pearl_pm_ops,
 	},
 #endif
 };
=20
-static int __init qtnf_pcie_register(void)
+static int __init qtnf_pcie_pearl_register(void)
 {
 	pr_info("register Quantenna QSR10g FullMAC PCIE driver\n");
-	return pci_register_driver(&qtnf_pcie_drv_data);
+	return pci_register_driver(&qtnf_pcie_pearl_drv_data);
 }
=20
-static void __exit qtnf_pcie_exit(void)
+static void __exit qtnf_pcie_pearl_exit(void)
 {
 	pr_info("unregister Quantenna QSR10g FullMAC PCIE driver\n");
-	pci_unregister_driver(&qtnf_pcie_drv_data);
+	pci_unregister_driver(&qtnf_pcie_pearl_drv_data);
 }
=20
-module_init(qtnf_pcie_register);
-module_exit(qtnf_pcie_exit);
+module_init(qtnf_pcie_pearl_register);
+module_exit(qtnf_pcie_pearl_exit);
=20
 MODULE_AUTHOR("Quantenna Communications");
 MODULE_DESCRIPTION("Quantenna QSR10g PCIe bus driver for 802.11 wireless L=
AN.");
--=20
2.9.5
