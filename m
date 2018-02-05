Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0069.outbound.protection.outlook.com ([104.47.36.69]:44244
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753170AbeBEPFm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Feb 2018 10:05:42 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 3/6] qtnfmac: fix rmmod for firmware version mismatch
Date: Mon,  5 Feb 2018 18:05:13 +0300
Message-Id: <20180205150516.16030-4-sergey.matyukevich.os@quantenna.com> (sfid-20180205_160631_594565_2F14397A)
In-Reply-To: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
References: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify qtnf_pcie_probe error paths to fix rmmod of qtnfmac kernel
modules in the case when there is a version mismatch between
firmware and driver.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 44 ++++++++++------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 7aa222286d8e..c0d1c5d94ef0 100644
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
@@ -1256,10 +1254,8 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	bus = devm_kzalloc(&pdev->dev,
 			   sizeof(*bus) + sizeof(*pcie_priv), GFP_KERNEL);
-	if (!bus) {
-		ret = -ENOMEM;
-		goto err_init;
-	}
+	if (!bus)
+		return -ENOMEM;
 
 	pcie_priv = get_bus_priv(bus);
 
@@ -1286,11 +1282,14 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pcie_priv->tx_reclaim_done = 0;
 	pcie_priv->tx_reclaim_req = 0;
 
+	tasklet_init(&pcie_priv->reclaim_tq, qtnf_reclaim_tasklet_fn,
+		     (unsigned long)pcie_priv);
+
 	pcie_priv->workqueue = create_singlethread_workqueue("QTNF_PEARL_PCIE");
 	if (!pcie_priv->workqueue) {
 		pr_err("failed to alloc bus workqueue\n");
 		ret = -ENODEV;
-		goto err_priv;
+		goto err_init;
 	}
 
 	if (!pci_is_pcie(pdev)) {
@@ -1320,12 +1319,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1344,7 +1338,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = qtnf_pcie_init_xfer(pcie_priv);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
-		goto err_base;
+		goto err_ipc;
 	}
 
 	/* init default irq settings */
@@ -1360,33 +1354,31 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_xfer;
 	}
 
-	tasklet_init(&pcie_priv->reclaim_tq, qtnf_reclaim_tasklet_fn,
-		     (unsigned long)pcie_priv);
 	init_dummy_netdev(&bus->mux_dev);
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
 		       qtnf_rx_poll, 10);
 
 	ret = qtnf_bringup_fw(bus);
 	if (ret < 0)
-		goto err_bringup_fw;
+		goto err_fw;
 	else if (ret)
 		wait_for_completion(&bus->request_firmware_complete);
 
 	if (bus->fw_state != QTNF_FW_STATE_FW_DNLD_DONE) {
 		pr_err("failed to start FW\n");
-		goto err_bringup_fw;
+		goto err_fw;
 	}
 
 	if (qtnf_poll_state(&pcie_priv->bda->bda_ep_state, QTN_EP_FW_QLINK_DONE,
 			    QTN_FW_QLINK_TIMEOUT_MS)) {
 		pr_err("FW runtime failure\n");
-		goto err_bringup_fw;
+		goto err_fw;
 	}
 
 	ret = qtnf_core_attach(bus);
 	if (ret) {
 		pr_err("failed to attach core\n");
-		goto err_bringup_fw;
+		goto err_fw;
 	}
 
 	qtnf_debugfs_init(bus, DRV_NAME);
@@ -1398,20 +1390,24 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
-err_bringup_fw:
+err_fw:
+	qtnf_reset_card(pcie_priv);
 	netif_napi_del(&bus->mux_napi);
 
 err_xfer:
 	qtnf_free_xfer_buffers(pcie_priv);
 
+err_ipc:
+	qtnf_pcie_free_shm_ipc(pcie_priv);
+
 err_base:
 	flush_workqueue(pcie_priv->workqueue);
 	destroy_workqueue(pcie_priv->workqueue);
 
-err_priv:
+err_init:
+	tasklet_kill(&pcie_priv->reclaim_tq);
 	pci_set_drvdata(pdev, NULL);
 
-err_init:
 	return ret;
 }
 
-- 
2.11.0
