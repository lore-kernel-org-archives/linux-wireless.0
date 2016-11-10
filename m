Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35026 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755713AbcKJL6J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 06:58:09 -0500
Received: by mail-pf0-f195.google.com with SMTP id i88so3963552pfk.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2016 03:58:09 -0800 (PST)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH RESEND v2 11/11] mwifiex: pcie: stop checking for NULL adapter->card
Date: Thu, 10 Nov 2016 19:57:12 +0800
Message-Id: <1478779032-5165-11-git-send-email-huxinming820@marvell.com> (sfid-20161110_125843_698604_17E8B0B2)
In-Reply-To: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
References: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

It should never be NULL here, and to think otherwise makes things
confusing.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: Same as v1
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 55 +++++++++++++----------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 3b6d908..65f1f92 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3021,31 +3021,28 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
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
@@ -3128,18 +3125,14 @@ static void mwifiex_pcie_down_dev(struct mwifiex_adapter *adapter)
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
