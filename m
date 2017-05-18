Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36498 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756626AbdERQez (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 12:34:55 -0400
Received: by mail-pf0-f176.google.com with SMTP id m17so26359647pfg.3
        for <linux-wireless@vger.kernel.org>; Thu, 18 May 2017 09:34:55 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2] mwifiex: pcie: de-duplicate buffer allocation code
Date: Thu, 18 May 2017 09:34:47 -0700
Message-Id: <20170518163447.29496-1-briannorris@chromium.org> (sfid-20170518_183529_665048_75B13C0E)
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
v2: rebased, since first 3 patches were merged separately; no changes

 drivers/net/wireless/marvell/mwifiex/pcie.c | 157 ++++++++++++----------------
 1 file changed, 66 insertions(+), 91 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 78688ff6ecd0..8729809aa248 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2860,6 +2860,61 @@ static void mwifiex_pcie_card_reset(struct mwifiex_adapter *adapter)
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
@@ -2877,20 +2932,12 @@ static void mwifiex_pcie_free_buffers(struct mwifiex_adapter *adapter)
 
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
 
@@ -2939,37 +2986,13 @@ static int mwifiex_init_pcie(struct mwifiex_adapter *adapter)
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
@@ -3183,73 +3206,25 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
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
 
 	/* tx_buf_size might be changed to 3584 by firmware during
 	 * data transfer, we should reset it to default size.
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
2.13.0.303.g4ebf302169-goog
