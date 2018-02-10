Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0056.outbound.protection.outlook.com ([104.47.42.56]:51356
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751053AbeBJOEi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Feb 2018 09:04:38 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 3/4] qtnfmac: implement asynchronous firmware loading
Date: Sat, 10 Feb 2018 17:04:19 +0300
Message-Id: <20180210140420.17013-4-sergey.matyukevich.os@quantenna.com> (sfid-20180210_150448_152243_D06C1478)
In-Reply-To: <20180210140420.17013-1-sergey.matyukevich.os@quantenna.com>
References: <20180210140420.17013-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In pci probe() function start firmware loading, protocol handshake
and driver core initialization, and not wait for completion.

Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |   3 +-
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 375 ++++++++++-----------
 2 files changed, 180 insertions(+), 198 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wireless/quantenna/qtnfmac/bus.h
index 56e5fed92a2a..0a1604683bab 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -59,8 +59,9 @@ struct qtnf_bus {
 	char fwname[32];
 	struct napi_struct mux_napi;
 	struct net_device mux_dev;
-	struct completion request_firmware_complete;
+	struct completion firmware_init_complete;
 	struct workqueue_struct *workqueue;
+	struct work_struct fw_work;
 	struct work_struct event_work;
 	struct mutex bus_lock; /* lock during command/event processing */
 	struct dentry *dbg_dir;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 7aa222286d8e..f117904d9120 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -127,7 +127,7 @@ static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
 
-static int qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
 {
 	struct pci_dev *pdev = priv->pdev;
 
@@ -148,8 +148,6 @@ static int qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
 		pr_warn("legacy PCIE interrupts enabled\n");
 		pci_intx(pdev, 1);
 	}
-
-	return 0;
 }
 
 static void qtnf_deassert_intx(struct qtnf_pcie_bus_priv *priv)
@@ -956,6 +954,98 @@ static const struct qtnf_bus_ops qtnf_pcie_bus_ops = {
 	.data_rx_stop		= qtnf_pcie_data_rx_stop,
 };
 
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
+static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	u32 reg = readl(PCIE_HDP_INT_EN(priv->pcie_reg_base));
+	u32 status;
+
+	seq_printf(s, "pcie_irq_count(%u)\n", priv->pcie_irq_count);
+	seq_printf(s, "pcie_irq_tx_count(%u)\n", priv->pcie_irq_tx_count);
+	status = reg &  PCIE_HDP_INT_TX_BITS;
+	seq_printf(s, "pcie_irq_tx_status(%s)\n",
+		   (status == PCIE_HDP_INT_TX_BITS) ? "EN" : "DIS");
+	seq_printf(s, "pcie_irq_rx_count(%u)\n", priv->pcie_irq_rx_count);
+	status = reg &  PCIE_HDP_INT_RX_BITS;
+	seq_printf(s, "pcie_irq_rx_status(%s)\n",
+		   (status == PCIE_HDP_INT_RX_BITS) ? "EN" : "DIS");
+	seq_printf(s, "pcie_irq_uf_count(%u)\n", priv->pcie_irq_uf_count);
+	status = reg &  PCIE_HDP_INT_HHBM_UF;
+	seq_printf(s, "pcie_irq_hhbm_uf_status(%s)\n",
+		   (status == PCIE_HDP_INT_HHBM_UF) ? "EN" : "DIS");
+
+	return 0;
+}
+
+static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+
+	seq_printf(s, "tx_full_count(%u)\n", priv->tx_full_count);
+	seq_printf(s, "tx_done_count(%u)\n", priv->tx_done_count);
+	seq_printf(s, "tx_reclaim_done(%u)\n", priv->tx_reclaim_done);
+	seq_printf(s, "tx_reclaim_req(%u)\n", priv->tx_reclaim_req);
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
 static int qtnf_ep_fw_send(struct qtnf_pcie_bus_priv *priv, uint32_t size,
 			   int blk, const u8 *pblk, const u8 *fw)
 {
@@ -1071,181 +1161,102 @@ qtnf_ep_fw_load(struct qtnf_pcie_bus_priv *priv, const u8 *fw, u32 fw_size)
 	return 0;
 }
 
-static void qtnf_firmware_load(const struct firmware *fw, void *context)
-{
-	struct qtnf_pcie_bus_priv *priv = (void *)context;
-	struct pci_dev *pdev = priv->pdev;
-	struct qtnf_bus *bus = pci_get_drvdata(pdev);
-	int ret;
-
-	if (!fw) {
-		pr_err("failed to get firmware %s\n", bus->fwname);
-		goto fw_load_err;
-	}
-
-	ret = qtnf_ep_fw_load(priv, fw->data, fw->size);
-	if (ret) {
-		pr_err("FW upload error\n");
-		goto fw_load_err;
-	}
-
-	if (qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_DONE,
-			    QTN_FW_DL_TIMEOUT_MS)) {
-		pr_err("FW bringup timed out\n");
-		goto fw_load_err;
-	}
-
-	bus->fw_state = QTNF_FW_STATE_FW_DNLD_DONE;
-	pr_info("firmware is up and running\n");
-
-fw_load_err:
-
-	if (fw)
-		release_firmware(fw);
-
-	complete(&bus->request_firmware_complete);
-}
-
-static int qtnf_bringup_fw(struct qtnf_bus *bus)
+static void qtnf_fw_work_handler(struct work_struct *work)
 {
+	struct qtnf_bus *bus = container_of(work, struct qtnf_bus, fw_work);
 	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
 	struct pci_dev *pdev = priv->pdev;
+	const struct firmware *fw;
 	int ret;
 	u32 state = QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK;
 
-	if (flashboot)
+	if (flashboot) {
 		state |= QTN_RC_FW_FLASHBOOT;
+	} else {
+		ret = request_firmware(&fw, bus->fwname, &pdev->dev);
+		if (ret < 0) {
+			pr_err("failed to get firmware %s\n", bus->fwname);
+			goto fw_load_fail;
+		}
+	}
 
 	qtnf_set_state(&priv->bda->bda_rc_state, state);
 
 	if (qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_LOADRDY,
 			    QTN_FW_DL_TIMEOUT_MS)) {
 		pr_err("card is not ready\n");
-		return -ETIMEDOUT;
+		goto fw_load_fail;
 	}
 
 	qtnf_clear_state(&priv->bda->bda_ep_state, QTN_EP_FW_LOADRDY);
 
 	if (flashboot) {
-		pr_info("Booting FW from flash\n");
-
-		if (!qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_DONE,
-				     QTN_FW_DL_TIMEOUT_MS))
-			bus->fw_state = QTNF_FW_STATE_FW_DNLD_DONE;
+		pr_info("booting firmware from flash\n");
+	} else {
+		pr_info("starting firmware upload: %s\n", bus->fwname);
 
-		return 0;
+		ret = qtnf_ep_fw_load(priv, fw->data, fw->size);
+		release_firmware(fw);
+		if (ret) {
+			pr_err("firmware upload error\n");
+			goto fw_load_fail;
+		}
 	}
 
-	pr_info("starting firmware upload: %s\n", bus->fwname);
-
-	ret = request_firmware_nowait(THIS_MODULE, 1, bus->fwname, &pdev->dev,
-				      GFP_KERNEL, priv, qtnf_firmware_load);
-	if (ret < 0)
-		pr_err("request_firmware_nowait error %d\n", ret);
-	else
-		ret = 1;
-
-	return ret;
-}
-
-static void qtnf_reclaim_tasklet_fn(unsigned long data)
-{
-	struct qtnf_pcie_bus_priv *priv = (void *)data;
-
-	qtnf_pcie_data_tx_reclaim(priv);
-	qtnf_en_txdone_irq(priv);
-}
-
-static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
-{
-	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
-
-	seq_printf(s, "%d\n", priv->mps);
+	if (qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_DONE,
+			    QTN_FW_DL_TIMEOUT_MS)) {
+		pr_err("firmware bringup timed out\n");
+		goto fw_load_fail;
+	}
 
-	return 0;
-}
+	bus->fw_state = QTNF_FW_STATE_FW_DNLD_DONE;
+	pr_info("firmware is up and running\n");
 
-static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
-{
-	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	if (qtnf_poll_state(&priv->bda->bda_ep_state,
+			    QTN_EP_FW_QLINK_DONE, QTN_FW_QLINK_TIMEOUT_MS)) {
+		pr_err("firmware runtime failure\n");
+		goto fw_load_fail;
+	}
 
-	seq_printf(s, "%u\n", priv->msi_enabled);
+	ret = qtnf_core_attach(bus);
+	if (ret) {
+		pr_err("failed to attach core\n");
+		goto fw_load_fail;
+	}
 
-	return 0;
-}
+	qtnf_debugfs_init(bus, DRV_NAME);
+	qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
+	qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
+	qtnf_debugfs_add_entry(bus, "hdp_stats", qtnf_dbg_hdp_stats);
+	qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
+	qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
 
-static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
-{
-	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
-	u32 reg = readl(PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	u32 status;
+	goto fw_load_exit;
 
-	seq_printf(s, "pcie_irq_count(%u)\n", priv->pcie_irq_count);
-	seq_printf(s, "pcie_irq_tx_count(%u)\n", priv->pcie_irq_tx_count);
-	status = reg &  PCIE_HDP_INT_TX_BITS;
-	seq_printf(s, "pcie_irq_tx_status(%s)\n",
-		   (status == PCIE_HDP_INT_TX_BITS) ? "EN" : "DIS");
-	seq_printf(s, "pcie_irq_rx_count(%u)\n", priv->pcie_irq_rx_count);
-	status = reg &  PCIE_HDP_INT_RX_BITS;
-	seq_printf(s, "pcie_irq_rx_status(%s)\n",
-		   (status == PCIE_HDP_INT_RX_BITS) ? "EN" : "DIS");
-	seq_printf(s, "pcie_irq_uf_count(%u)\n", priv->pcie_irq_uf_count);
-	status = reg &  PCIE_HDP_INT_HHBM_UF;
-	seq_printf(s, "pcie_irq_hhbm_uf_status(%s)\n",
-		   (status == PCIE_HDP_INT_HHBM_UF) ? "EN" : "DIS");
+fw_load_fail:
+	bus->fw_state = QTNF_FW_STATE_DEAD;
 
-	return 0;
+fw_load_exit:
+	complete(&bus->firmware_init_complete);
+	put_device(&pdev->dev);
 }
 
-static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
+static void qtnf_bringup_fw_async(struct qtnf_bus *bus)
 {
-	struct qtnf_bus *bus = dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
-
-	seq_printf(s, "tx_full_count(%u)\n", priv->tx_full_count);
-	seq_printf(s, "tx_done_count(%u)\n", priv->tx_done_count);
-	seq_printf(s, "tx_reclaim_done(%u)\n", priv->tx_reclaim_done);
-	seq_printf(s, "tx_reclaim_req(%u)\n", priv->tx_reclaim_req);
-
-	seq_printf(s, "tx_bd_r_index(%u)\n", priv->tx_bd_r_index);
-	seq_printf(s, "tx_bd_p_index(%u)\n",
-		   readl(PCIE_HDP_RX0DMA_CNT(priv->pcie_reg_base))
-			& (priv->tx_bd_num - 1));
-	seq_printf(s, "tx_bd_w_index(%u)\n", priv->tx_bd_w_index);
-	seq_printf(s, "tx queue len(%u)\n",
-		   CIRC_CNT(priv->tx_bd_w_index, priv->tx_bd_r_index,
-			    priv->tx_bd_num));
-
-	seq_printf(s, "rx_bd_r_index(%u)\n", priv->rx_bd_r_index);
-	seq_printf(s, "rx_bd_p_index(%u)\n",
-		   readl(PCIE_HDP_TX0DMA_CNT(priv->pcie_reg_base))
-			& (priv->rx_bd_num - 1));
-	seq_printf(s, "rx_bd_w_index(%u)\n", priv->rx_bd_w_index);
-	seq_printf(s, "rx alloc queue len(%u)\n",
-		   CIRC_SPACE(priv->rx_bd_w_index, priv->rx_bd_r_index,
-			      priv->rx_bd_num));
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct pci_dev *pdev = priv->pdev;
 
-	return 0;
+	get_device(&pdev->dev);
+	INIT_WORK(&bus->fw_work, qtnf_fw_work_handler);
+	schedule_work(&bus->fw_work);
 }
 
-static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
+static void qtnf_reclaim_tasklet_fn(unsigned long data)
 {
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
+	struct qtnf_pcie_bus_priv *priv = (void *)data;
 
-	return 0;
+	qtnf_pcie_data_tx_reclaim(priv);
+	qtnf_en_txdone_irq(priv);
 }
 
 static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -1256,10 +1267,8 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	bus = devm_kzalloc(&pdev->dev,
 			   sizeof(*bus) + sizeof(*pcie_priv), GFP_KERNEL);
-	if (!bus) {
-		ret = -ENOMEM;
-		goto err_init;
-	}
+	if (!bus)
+		return -ENOMEM;
 
 	pcie_priv = get_bus_priv(bus);
 
@@ -1270,7 +1279,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pcie_priv->pdev = pdev;
 
 	strcpy(bus->fwname, QTN_PCI_PEARL_FW_NAME);
-	init_completion(&bus->request_firmware_complete);
+	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
 	spin_lock_init(&pcie_priv->tx0_lock);
 	spin_lock_init(&pcie_priv->irq_lock);
@@ -1286,11 +1295,18 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pcie_priv->tx_reclaim_done = 0;
 	pcie_priv->tx_reclaim_req = 0;
 
+	tasklet_init(&pcie_priv->reclaim_tq, qtnf_reclaim_tasklet_fn,
+		     (unsigned long)pcie_priv);
+
+	init_dummy_netdev(&bus->mux_dev);
+	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
+		       qtnf_rx_poll, 10);
+
 	pcie_priv->workqueue = create_singlethread_workqueue("QTNF_PEARL_PCIE");
 	if (!pcie_priv->workqueue) {
 		pr_err("failed to alloc bus workqueue\n");
 		ret = -ENODEV;
-		goto err_priv;
+		goto err_init;
 	}
 
 	if (!pci_is_pcie(pdev)) {
@@ -1320,12 +1336,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	pci_set_master(pdev);
-
-	ret = qtnf_pcie_init_irq(pcie_priv);
-	if (ret < 0) {
-		pr_err("irq init failed\n");
-		goto err_base;
-	}
+	qtnf_pcie_init_irq(pcie_priv);
 
 	ret = qtnf_pcie_init_memory(pcie_priv);
 	if (ret < 0) {
@@ -1344,7 +1355,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = qtnf_pcie_init_xfer(pcie_priv);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
-		goto err_base;
+		goto err_ipc;
 	}
 
 	/* init default irq settings */
@@ -1360,58 +1371,25 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_xfer;
 	}
 
-	tasklet_init(&pcie_priv->reclaim_tq, qtnf_reclaim_tasklet_fn,
-		     (unsigned long)pcie_priv);
-	init_dummy_netdev(&bus->mux_dev);
-	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
-		       qtnf_rx_poll, 10);
-
-	ret = qtnf_bringup_fw(bus);
-	if (ret < 0)
-		goto err_bringup_fw;
-	else if (ret)
-		wait_for_completion(&bus->request_firmware_complete);
-
-	if (bus->fw_state != QTNF_FW_STATE_FW_DNLD_DONE) {
-		pr_err("failed to start FW\n");
-		goto err_bringup_fw;
-	}
-
-	if (qtnf_poll_state(&pcie_priv->bda->bda_ep_state, QTN_EP_FW_QLINK_DONE,
-			    QTN_FW_QLINK_TIMEOUT_MS)) {
-		pr_err("FW runtime failure\n");
-		goto err_bringup_fw;
-	}
-
-	ret = qtnf_core_attach(bus);
-	if (ret) {
-		pr_err("failed to attach core\n");
-		goto err_bringup_fw;
-	}
-
-	qtnf_debugfs_init(bus, DRV_NAME);
-	qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
-	qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
-	qtnf_debugfs_add_entry(bus, "hdp_stats", qtnf_dbg_hdp_stats);
-	qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
-	qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
+	qtnf_bringup_fw_async(bus);
 
 	return 0;
 
-err_bringup_fw:
-	netif_napi_del(&bus->mux_napi);
-
 err_xfer:
 	qtnf_free_xfer_buffers(pcie_priv);
 
+err_ipc:
+	qtnf_pcie_free_shm_ipc(pcie_priv);
+
 err_base:
 	flush_workqueue(pcie_priv->workqueue);
 	destroy_workqueue(pcie_priv->workqueue);
+	netif_napi_del(&bus->mux_napi);
 
-err_priv:
+err_init:
+	tasklet_kill(&pcie_priv->reclaim_tq);
 	pci_set_drvdata(pdev, NULL);
 
-err_init:
 	return ret;
 }
 
@@ -1424,11 +1402,14 @@ static void qtnf_pcie_remove(struct pci_dev *pdev)
 	if (!bus)
 		return;
 
+	wait_for_completion(&bus->firmware_init_complete);
+
+	if (bus->fw_state == QTNF_FW_STATE_ACTIVE)
+		qtnf_core_detach(bus);
+
 	priv = get_bus_priv(bus);
 
-	qtnf_core_detach(bus);
 	netif_napi_del(&bus->mux_napi);
-
 	flush_workqueue(priv->workqueue);
 	destroy_workqueue(priv->workqueue);
 	tasklet_kill(&priv->reclaim_tq);
-- 
2.11.0
