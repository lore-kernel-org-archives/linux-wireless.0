Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45896 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932825AbcKKNL4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 08:11:56 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v3 11/11] mwifiex: pcie: stop checking for NULL adapter->card
Date: Fri, 11 Nov 2016 18:40:18 +0530
Message-ID: <1478869818-4340-11-git-send-email-akarwar@marvell.com> (sfid-20161111_141200_295543_E485DB07)
In-Reply-To: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
References: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

It should never be NULL here, and to think otherwise makes things
confusing.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: Same as v1
v3: Below checkpatch warnings are resolved
WARNING: please, no spaces at the start of a line
#50: FILE: drivers/net/wireless/marvell/mwifiex/pcie.c:3037:
+       } else {$

WARNING: please, no spaces at the start of a line
#62: FILE: drivers/net/wireless/marvell/mwifiex/pcie.c:3044:
+       }$
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 53 +++++++++++++----------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 3b6d908..fb2b22d 100644
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
+	} else {
+		mwifiex_dbg(adapter, INFO,
+			    "%s(): calling free_irq()\n", __func__);
+	       free_irq(card->dev->irq, &card->share_irq_ctx);
 
-			if (card->msi_enable)
-				pci_disable_msi(pdev);
-	       }
-		card->adapter = NULL;
+		if (card->msi_enable)
+			pci_disable_msi(pdev);
 	}
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
1.9.1
