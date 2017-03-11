Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:33742 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933361AbdCKBjf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 20:39:35 -0500
Received: by mail-pg0-f51.google.com with SMTP id 25so44852230pgy.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 17:39:34 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rajat Jain <rajatja@google.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 4/4] mwifiex: pcie: de-duplicate buffer allocation code
Date: Fri, 10 Mar 2017 17:39:24 -0800
Message-Id: <20170311013924.73348-5-briannorris@chromium.org> (sfid-20170311_024040_670120_7580CBBF)
In-Reply-To: <20170311013924.73348-1-briannorris@chromium.org>
References: <20170311013924.73348-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code was duplicated as part of the PCIe FLR code added to this
driver. Let's de-duplicate it to:

 * make things easier to read (mwifiex_pcie_free_buffers() now has a
   corresponding mwifiex_pcie_alloc_buffers())
 * reduce likelihood of bugs
 * make error logging equally verbose
 * save lines of code!

Also drop some of the commentary that isn't really needed.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 157 ++++++++++++----------------
 1 file changed, 66 insertions(+), 91 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index eae1cc58a310..889d87086913 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2732,6 +2732,61 @@ static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
 	schedule_work(&card->work);
 }
 
+static int mwifiex_pcie_alloc_buffers(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+	int ret;
+
+	card->cmdrsp_buf = NULL;
+	ret = mwifiex_pcie_create_txbd_ring(adapter);
+	if (ret) {
+		mwifiex_dbg(adapter, ERROR, "Failed to create txbd ring\n");
+		goto err_cre_txbd;
+	}
+
+	ret = mwifiex_pcie_create_rxbd_ring(adapter);
+	if (ret) {
+		mwifiex_dbg(adapter, ERROR, "Failed to create rxbd ring\n");
+		goto err_cre_rxbd;
+	}
+
+	ret = mwifiex_pcie_create_evtbd_ring(adapter);
+	if (ret) {
+		mwifiex_dbg(adapter, ERROR, "Failed to create evtbd ring\n");
+		goto err_cre_evtbd;
+	}
+
+	ret = mwifiex_pcie_alloc_cmdrsp_buf(adapter);
+	if (ret) {
+		mwifiex_dbg(adapter, ERROR, "Failed to allocate cmdbuf buffer\n");
+		goto err_alloc_cmdbuf;
+	}
+
+	if (reg->sleep_cookie) {
+		ret = mwifiex_pcie_alloc_sleep_cookie_buf(adapter);
+		if (ret) {
+			mwifiex_dbg(adapter, ERROR, "Failed to allocate sleep_cookie buffer\n");
+			goto err_alloc_cookie;
+		}
+	} else {
+		card->sleep_cookie_vbase = NULL;
+	}
+
+	return 0;
+
+err_alloc_cookie:
+	mwifiex_pcie_delete_cmdrsp_buf(adapter);
+err_alloc_cmdbuf:
+	mwifiex_pcie_delete_evtbd_ring(adapter);
+err_cre_evtbd:
+	mwifiex_pcie_delete_rxbd_ring(adapter);
+err_cre_rxbd:
+	mwifiex_pcie_delete_txbd_ring(adapter);
+err_cre_txbd:
+	return ret;
+}
+
 static void mwifiex_pcie_free_buffers(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
@@ -2749,20 +2804,12 @@ static void mwifiex_pcie_free_buffers(struct mwifiex_adapter *adapter)
 
 /*
  * This function initializes the PCI-E host memory space, WCB rings, etc.
- *
- * The following initializations steps are followed -
- *      - Allocate TXBD ring buffers
- *      - Allocate RXBD ring buffers
- *      - Allocate event BD ring buffers
- *      - Allocate command response ring buffer
- *      - Allocate sleep cookie buffer
  */
 static int mwifiex_init_pcie(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	int ret;
 	struct pci_dev *pdev = card->dev;
-	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
 	pci_set_drvdata(pdev, card);
 
@@ -2811,37 +2858,13 @@ static int mwifiex_init_pcie(struct mwifiex_adapter *adapter)
 	pr_notice("PCI memory map Virt0: %p PCI memory map Virt2: %p\n",
 		  card->pci_mmap, card->pci_mmap1);
 
-	card->cmdrsp_buf = NULL;
-	ret = mwifiex_pcie_create_txbd_ring(adapter);
+	ret = mwifiex_pcie_alloc_buffers(adapter);
 	if (ret)
-		goto err_cre_txbd;
-	ret = mwifiex_pcie_create_rxbd_ring(adapter);
-	if (ret)
-		goto err_cre_rxbd;
-	ret = mwifiex_pcie_create_evtbd_ring(adapter);
-	if (ret)
-		goto err_cre_evtbd;
-	ret = mwifiex_pcie_alloc_cmdrsp_buf(adapter);
-	if (ret)
-		goto err_alloc_cmdbuf;
-	if (reg->sleep_cookie) {
-		ret = mwifiex_pcie_alloc_sleep_cookie_buf(adapter);
-		if (ret)
-			goto err_alloc_cookie;
-	} else {
-		card->sleep_cookie_vbase = NULL;
-	}
-	return ret;
+		goto err_alloc_buffers;
 
-err_alloc_cookie:
-	mwifiex_pcie_delete_cmdrsp_buf(adapter);
-err_alloc_cmdbuf:
-	mwifiex_pcie_delete_evtbd_ring(adapter);
-err_cre_evtbd:
-	mwifiex_pcie_delete_rxbd_ring(adapter);
-err_cre_rxbd:
-	mwifiex_pcie_delete_txbd_ring(adapter);
-err_cre_txbd:
+	return 0;
+
+err_alloc_buffers:
 	pci_iounmap(pdev, card->pci_mmap1);
 err_iomap2:
 	pci_release_region(pdev, 2);
@@ -3053,22 +3076,15 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 	card->adapter = NULL;
 }
 
-/* This function initializes the PCI-E host memory space, WCB rings, etc.
- *
- * The following initializations steps are followed -
- *      - Allocate TXBD ring buffers
- *      - Allocate RXBD ring buffers
- *      - Allocate event BD ring buffers
- *      - Allocate command response ring buffer
- *      - Allocate sleep cookie buffer
- * Part of mwifiex_init_pcie(), not reset the PCIE registers
+/*
+ * This function initializes the PCI-E host memory space, WCB rings, etc.,
+ * similar to mwifiex_init_pcie(), but without resetting PCI-E state.
  */
 static void mwifiex_pcie_up_dev(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	int ret;
 	struct pci_dev *pdev = card->dev;
-	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
 	/* Bluetooth is not on pcie interface. Download Wifi only firmware
 	 * during pcie FLR, so that bluetooth part of firmware which is
@@ -3081,51 +3097,10 @@ static void mwifiex_pcie_up_dev(struct mwifiex_adapter *adapter)
 	 */
 	adapter->tx_buf_size = card->pcie.tx_buf_size;
 
-	card->cmdrsp_buf = NULL;
-	ret = mwifiex_pcie_create_txbd_ring(adapter);
-	if (ret) {
-		mwifiex_dbg(adapter, ERROR, "Failed to create txbd ring\n");
-		goto err_cre_txbd;
-	}
-
-	ret = mwifiex_pcie_create_rxbd_ring(adapter);
-	if (ret) {
-		mwifiex_dbg(adapter, ERROR, "Failed to create rxbd ring\n");
-		goto err_cre_rxbd;
-	}
-
-	ret = mwifiex_pcie_create_evtbd_ring(adapter);
-	if (ret) {
-		mwifiex_dbg(adapter, ERROR, "Failed to create evtbd ring\n");
-		goto err_cre_evtbd;
-	}
-
-	ret = mwifiex_pcie_alloc_cmdrsp_buf(adapter);
-	if (ret) {
-		mwifiex_dbg(adapter, ERROR, "Failed to allocate cmdbuf buffer\n");
-		goto err_alloc_cmdbuf;
-	}
-
-	if (reg->sleep_cookie) {
-		ret = mwifiex_pcie_alloc_sleep_cookie_buf(adapter);
-		if (ret) {
-			mwifiex_dbg(adapter, ERROR, "Failed to allocate sleep_cookie buffer\n");
-			goto err_alloc_cookie;
-		}
-	} else {
-		card->sleep_cookie_vbase = NULL;
-	}
-	return;
+	ret = mwifiex_pcie_alloc_buffers(adapter);
+	if (!ret)
+		return;
 
-err_alloc_cookie:
-	mwifiex_pcie_delete_cmdrsp_buf(adapter);
-err_alloc_cmdbuf:
-	mwifiex_pcie_delete_evtbd_ring(adapter);
-err_cre_evtbd:
-	mwifiex_pcie_delete_rxbd_ring(adapter);
-err_cre_rxbd:
-	mwifiex_pcie_delete_txbd_ring(adapter);
-err_cre_txbd:
 	pci_iounmap(pdev, card->pci_mmap1);
 }
 
-- 
2.12.0.246.ga2ecc84866-goog
