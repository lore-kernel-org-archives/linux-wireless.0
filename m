Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53200 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbaFPQiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:52 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 22/25] wil6210: work around for platforms with broken INTx
Date: Mon, 16 Jun 2014 19:37:20 +0300
Message-ID: <1402936643-31819-23-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190457_881936_D33A1319)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are platforms where INTx can't be routed by ACPI,
this leads to pci_enable_device failure. Re-try pretending we have
MSI already configured; in this case pci_enable_device do not try
to configure INTx. However, MSI could still work.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 05c1c9d..77b6272 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -35,6 +35,13 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 {
 	struct pci_dev *pdev = wil->pdev;
 	int rc;
+	/* on platforms with buggy ACPI, pdev->msi_enabled may be set to
+	 * allow pci_enable_device to work. This indicates INTx was not routed
+	 * and only MSI should be used
+	 */
+	int msi_only = pdev->msi_enabled;
+
+	pdev->msi_enabled = 0;
 
 	pci_set_master(pdev);
 
@@ -66,6 +73,12 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 
 	wil->n_msi = use_msi;
 
+	if ((wil->n_msi == 0) && msi_only) {
+		wil_err(wil, "Interrupt pin not routed, unable to use INTx\n");
+		rc = -ENODEV;
+		goto stop_master;
+	}
+
 	rc = wil6210_init_irq(wil, pdev->irq);
 	if (rc)
 		goto stop_master;
@@ -124,9 +137,16 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
-		dev_err(&pdev->dev, "pci_enable_device failed\n");
-		return -ENODEV;
+		dev_err(&pdev->dev,
+			"pci_enable_device failed, retry with MSI only\n");
+		/* Work around for platforms that can't allocate IRQ:
+		 * retry with MSI only
+		 */
+		pdev->msi_enabled = 1;
+		rc = pci_enable_device(pdev);
 	}
+	if (rc)
+		return -ENODEV;
 	/* rollback to err_disable_pdev */
 
 	rc = pci_request_region(pdev, 0, WIL_NAME);
-- 
1.9.1

