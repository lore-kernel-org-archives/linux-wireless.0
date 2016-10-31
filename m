Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33511 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761999AbcJaIDI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 04:03:08 -0400
Received: by mail-pf0-f196.google.com with SMTP id a136so4722953pfa.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2016 01:03:07 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 12/12] mwifiex: pcie: stop checking for NULL adapter->card
Date: Mon, 31 Oct 2016 16:02:20 +0800
Message-Id: <1477900940-10549-12-git-send-email-huxinming820@marvell.com> (sfid-20161031_092412_324099_62BCFE22)
In-Reply-To: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
References: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

It should never be NULL here, and to think otherwise makes things
confusing.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 55 +++++++++++++----------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c061d00..86e8ce6 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2990,31 +2990,28 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
-	struct pci_dev *pdev;
+	struct pci_dev *pdev = card->dev;
 	int i;
 
-	if (card) {
-		pdev = card->dev;
-		if (card->msix_enable) {
-			for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)
-				synchronize_irq(card->msix_entries[i].vector);
+	if (card->msix_enable) {
+		for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)
+			synchronize_irq(card->msix_entries[i].vector);
 
-			for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)
-				free_irq(card->msix_entries[i].vector,
-					 &card->msix_ctx[i]);
+		for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)
+			free_irq(card->msix_entries[i].vector,
+				 &card->msix_ctx[i]);
 
-			card->msix_enable = 0;
-			pci_disable_msix(pdev);
-	       } else {
-			mwifiex_dbg(adapter, INFO,
-				    "%s(): calling free_irq()\n", __func__);
-		       free_irq(card->dev->irq, &card->share_irq_ctx);
+		card->msix_enable = 0;
+		pci_disable_msix(pdev);
+       } else {
+		mwifiex_dbg(adapter, INFO,
+			    "%s(): calling free_irq()\n", __func__);
+	       free_irq(card->dev->irq, &card->share_irq_ctx);
 
-			if (card->msi_enable)
-				pci_disable_msi(pdev);
-	       }
-		card->adapter = NULL;
-	}
+		if (card->msi_enable)
+			pci_disable_msi(pdev);
+       }
+	card->adapter = NULL;
 }
 
 /* This function initializes the PCI-E host memory space, WCB rings, etc.
@@ -3097,18 +3094,14 @@ static void mwifiex_pcie_down_dev(struct mwifiex_adapter *adapter)
 	adapter->seq_num = 0;
 	adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
 
-	if (card) {
-		if (reg->sleep_cookie)
-			mwifiex_pcie_delete_sleep_cookie_buf(adapter);
-
-		mwifiex_pcie_delete_cmdrsp_buf(adapter);
-		mwifiex_pcie_delete_evtbd_ring(adapter);
-		mwifiex_pcie_delete_rxbd_ring(adapter);
-		mwifiex_pcie_delete_txbd_ring(adapter);
-		card->cmdrsp_buf = NULL;
-	}
+	if (reg->sleep_cookie)
+		mwifiex_pcie_delete_sleep_cookie_buf(adapter);
 
-	return;
+	mwifiex_pcie_delete_cmdrsp_buf(adapter);
+	mwifiex_pcie_delete_evtbd_ring(adapter);
+	mwifiex_pcie_delete_rxbd_ring(adapter);
+	mwifiex_pcie_delete_txbd_ring(adapter);
+	card->cmdrsp_buf = NULL;
 }
 
 static struct mwifiex_if_ops pcie_ops = {
-- 
1.8.1.4
