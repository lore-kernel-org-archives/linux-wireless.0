Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47820 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbbFGN4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 09:56:45 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 6/6] wil6210: reorder init sequence
Date: Sun,  7 Jun 2015 16:56:31 +0300
Message-Id: <1433685391-9026-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150607_155652_907945_FB6EF7D8)
In-Reply-To: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Need to reorder init sequence to run wil_platform_init
before pci_enable_device. Assumption is platform init
may be required before device may be enabled.
Another issue, platform uninit should be called after
pci_disable_device because platform uninit may render
pci device non-accessible.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c       |  3 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c     | 77 ++++++++++++++-----------
 drivers/net/wireless/ath/wil6210/wil6210.h      |  2 +-
 drivers/net/wireless/ath/wil6210/wil_platform.c |  5 +-
 4 files changed, 48 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 6042f61..8ef18ac 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -132,7 +132,7 @@ static void wil_dev_setup(struct net_device *dev)
 	dev->tx_queue_len = WIL_TX_Q_LEN_DEFAULT;
 }
 
-void *wil_if_alloc(struct device *dev, void __iomem *csr)
+void *wil_if_alloc(struct device *dev)
 {
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
@@ -147,7 +147,6 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 	}
 
 	wil = wdev_to_wil(wdev);
-	wil->csr = csr;
 	wil->wdev = wdev;
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index a4417d4..aa3ecc6 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -163,7 +163,6 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct wil6210_priv *wil;
 	struct device *dev = &pdev->dev;
-	void __iomem *csr;
 	int rc;
 
 	/* check HW */
@@ -178,9 +177,28 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENODEV;
 	}
 
+	wil = wil_if_alloc(dev);
+	if (IS_ERR(wil)) {
+		rc = (int)PTR_ERR(wil);
+		dev_err(dev, "wil_if_alloc failed: %d\n", rc);
+		return rc;
+	}
+	wil->pdev = pdev;
+	pci_set_drvdata(pdev, wil);
+	/* rollback to if_free */
+
+	wil->platform_handle =
+			wil_platform_init(&pdev->dev, &wil->platform_ops);
+	if (!wil->platform_handle) {
+		rc = -ENODEV;
+		wil_err(wil, "wil_platform_init failed\n");
+		goto if_free;
+	}
+	/* rollback to err_plat */
+
 	rc = pci_enable_device(pdev);
 	if (rc) {
-		dev_err(&pdev->dev,
+		wil_err(wil,
 			"pci_enable_device failed, retry with MSI only\n");
 		/* Work around for platforms that can't allocate IRQ:
 		 * retry with MSI only
@@ -188,47 +206,37 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		pdev->msi_enabled = 1;
 		rc = pci_enable_device(pdev);
 	}
-	if (rc)
-		return -ENODEV;
+	if (rc) {
+		wil_err(wil,
+			"pci_enable_device failed, even with MSI only\n");
+		goto err_plat;
+	}
 	/* rollback to err_disable_pdev */
 
 	rc = pci_request_region(pdev, 0, WIL_NAME);
 	if (rc) {
-		dev_err(&pdev->dev, "pci_request_region failed\n");
+		wil_err(wil, "pci_request_region failed\n");
 		goto err_disable_pdev;
 	}
 	/* rollback to err_release_reg */
 
-	csr = pci_ioremap_bar(pdev, 0);
-	if (!csr) {
-		dev_err(&pdev->dev, "pci_ioremap_bar failed\n");
+	wil->csr = pci_ioremap_bar(pdev, 0);
+	if (!wil->csr) {
+		wil_err(wil, "pci_ioremap_bar failed\n");
 		rc = -ENODEV;
 		goto err_release_reg;
 	}
 	/* rollback to err_iounmap */
-	dev_info(&pdev->dev, "CSR at %pR -> 0x%p\n", &pdev->resource[0], csr);
-
-	wil = wil_if_alloc(dev, csr);
-	if (IS_ERR(wil)) {
-		rc = (int)PTR_ERR(wil);
-		dev_err(dev, "wil_if_alloc failed: %d\n", rc);
-		goto err_iounmap;
-	}
-	/* rollback to if_free */
+	wil_info(wil, "CSR at %pR -> 0x%p\n", &pdev->resource[0], wil->csr);
 
-	pci_set_drvdata(pdev, wil);
-	wil->pdev = pdev;
 	wil_set_capabilities(wil);
 	wil6210_clear_irq(wil);
 
-	wil->platform_handle =
-			wil_platform_init(&pdev->dev, &wil->platform_ops);
-
 	/* FW should raise IRQ when ready */
 	rc = wil_if_pcie_enable(wil);
 	if (rc) {
 		wil_err(wil, "Enable device failed\n");
-		goto if_free;
+		goto err_iounmap;
 	}
 	/* rollback to bus_disable */
 
@@ -243,18 +251,19 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
- bus_disable:
+bus_disable:
 	wil_if_pcie_disable(wil);
- if_free:
+err_iounmap:
+	pci_iounmap(pdev, wil->csr);
+err_release_reg:
+	pci_release_region(pdev, 0);
+err_disable_pdev:
+	pci_disable_device(pdev);
+err_plat:
 	if (wil->platform_ops.uninit)
 		wil->platform_ops.uninit(wil->platform_handle);
+if_free:
 	wil_if_free(wil);
- err_iounmap:
-	pci_iounmap(pdev, csr);
- err_release_reg:
-	pci_release_region(pdev, 0);
- err_disable_pdev:
-	pci_disable_device(pdev);
 
 	return rc;
 }
@@ -269,12 +278,12 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 	wil6210_debugfs_remove(wil);
 	wil_if_remove(wil);
 	wil_if_pcie_disable(wil);
-	if (wil->platform_ops.uninit)
-		wil->platform_ops.uninit(wil->platform_handle);
-	wil_if_free(wil);
 	pci_iounmap(pdev, csr);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
+	if (wil->platform_ops.uninit)
+		wil->platform_ops.uninit(wil->platform_handle);
+	wil_if_free(wil);
 }
 
 static const struct pci_device_id wil6210_pcie_ids[] = {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 78c7536..275355d 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -686,7 +686,7 @@ void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
 void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 			size_t count);
 
-void *wil_if_alloc(struct device *dev, void __iomem *csr);
+void *wil_if_alloc(struct device *dev);
 void wil_if_free(struct wil6210_priv *wil);
 int wil_if_add(struct wil6210_priv *wil);
 void wil_if_remove(struct wil6210_priv *wil);
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.c b/drivers/net/wireless/ath/wil6210/wil_platform.c
index 1db680f..de15f14 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.c
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.c
@@ -35,10 +35,11 @@ void wil_platform_modexit(void)
  */
 void *wil_platform_init(struct device *dev, struct wil_platform_ops *ops)
 {
-	void *handle = NULL;
+	void *handle = ops; /* to return some non-NULL for 'void' impl. */
 
 	if (!ops) {
-		dev_err(dev, "Invalid parameter. Cannot init platform module\n");
+		dev_err(dev,
+			"Invalid parameter. Cannot init platform module\n");
 		return NULL;
 	}
 
-- 
2.1.4

