Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:33738 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932614AbdCKBjd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 20:39:33 -0500
Received: by mail-pg0-f48.google.com with SMTP id 25so44851997pgy.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 17:39:32 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rajat Jain <rajatja@google.com>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH 1/4] mwifiex: pcie: don't leak DMA buffers when removing
Date: Fri, 10 Mar 2017 17:39:21 -0800
Message-Id: <20170311013924.73348-2-briannorris@chromium.org> (sfid-20170311_024038_975629_3A5B1031)
In-Reply-To: <20170311013924.73348-1-briannorris@chromium.org>
References: <20170311013924.73348-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When PCIe FLR support was added, much of the remove/release code for
PCIe was migrated to ->down_dev(), but ->down_dev() is never called for
device removal. Let's refactor the cleanup to be done in both cases.

Also, drop the comments above mwifiex_cleanup_pcie(), because they were
clearly wrong, and it's better to have clear and obvious code than to
detail the code steps in comments anyway.

Fixes: 4c5dae59d2e9 ("mwifiex: add PCIe function level reset support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
I don't think there's any code path in which we see ->down_dev() followed by
->cleanup_if(), with no ->up_dev() in between? (Or, what happens if PCIe FLR
fails?) But if so, then this could cause a double free. It could use a close
review.

 drivers/net/wireless/marvell/mwifiex/pcie.c | 38 ++++++++++++++---------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 5438483fcefe..eae1cc58a310 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2732,6 +2732,21 @@ static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
 	schedule_work(&card->work);
 }
 
+static void mwifiex_pcie_free_buffers(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+
+	if (reg->sleep_cookie)
+		mwifiex_pcie_delete_sleep_cookie_buf(adapter);
+
+	mwifiex_pcie_delete_cmdrsp_buf(adapter);
+	mwifiex_pcie_delete_evtbd_ring(adapter);
+	mwifiex_pcie_delete_rxbd_ring(adapter);
+	mwifiex_pcie_delete_txbd_ring(adapter);
+	card->cmdrsp_buf = NULL;
+}
+
 /*
  * This function initializes the PCI-E host memory space, WCB rings, etc.
  *
@@ -2843,13 +2858,6 @@ static int mwifiex_init_pcie(struct mwifiex_adapter *adapter)
 
 /*
  * This function cleans up the allocated card buffers.
- *
- * The following are freed by this function -
- *      - TXBD ring buffers
- *      - RXBD ring buffers
- *      - Event BD ring buffers
- *      - Command response ring buffer
- *      - Sleep cookie buffer
  */
 static void mwifiex_cleanup_pcie(struct mwifiex_adapter *adapter)
 {
@@ -2868,6 +2876,8 @@ static void mwifiex_cleanup_pcie(struct mwifiex_adapter *adapter)
 				    "Failed to write driver not-ready signature\n");
 	}
 
+	mwifiex_pcie_free_buffers(adapter);
+
 	if (pdev) {
 		pci_iounmap(pdev, card->pci_mmap);
 		pci_iounmap(pdev, card->pci_mmap1);
@@ -3119,10 +3129,7 @@ static void mwifiex_pcie_up_dev(struct mwifiex_adapter *adapter)
 	pci_iounmap(pdev, card->pci_mmap1);
 }
 
-/* This function cleans up the PCI-E host memory space.
- * Some code is extracted from mwifiex_unregister_dev()
- *
- */
+/* This function cleans up the PCI-E host memory space. */
 static void mwifiex_pcie_down_dev(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
@@ -3133,14 +3140,7 @@ static void mwifiex_pcie_down_dev(struct mwifiex_adapter *adapter)
 
 	adapter->seq_num = 0;
 
-	if (reg->sleep_cookie)
-		mwifiex_pcie_delete_sleep_cookie_buf(adapter);
-
-	mwifiex_pcie_delete_cmdrsp_buf(adapter);
-	mwifiex_pcie_delete_evtbd_ring(adapter);
-	mwifiex_pcie_delete_rxbd_ring(adapter);
-	mwifiex_pcie_delete_txbd_ring(adapter);
-	card->cmdrsp_buf = NULL;
+	mwifiex_pcie_free_buffers(adapter);
 }
 
 static struct mwifiex_if_ops pcie_ops = {
-- 
2.12.0.246.ga2ecc84866-goog
