Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:36899 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756801AbdGYBO2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:28 -0400
Received: by mail-pg0-f44.google.com with SMTP id y129so63969736pgy.4
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:28 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 17/20] mwifiex: pcie: disable device DMA before unmapping/freeing buffers
Date: Mon, 24 Jul 2017 18:13:33 -0700
Message-Id: <20170725011336.99993-18-briannorris@chromium.org> (sfid-20170725_031621_381703_90ECCAF6)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In testing the mwifiex reset code path, I've noticed KASAN complaining
about some "overwritten poison values" in our RX buffer descriptors.
Because KASAN didn't notice this at the time of a CPU write, this seems
to suggest that the device is writing to this memory.

This makes a little sense, because when resetting, we don't necessarily
expect the device to be responsive, so we don't have a chance to disable
everything cleanly.

We can at least take the precaution of disabling DMA for the device
though, and in my testing that seems to clear up this particular issue.

This patch reorders the removal path so that we disable the device
*before* releasing our last PCIe buffers, and it clears/sets the bus
master feature from the PCI device when resetting.

Along the way, remove the insufficient (and confusing) error path in
mwifiex_pcie_up_dev() (it doesn't unwind things well enough, and it
doesn't propagate its errors upward anyway).

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
new in v2
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c08ebb55a7e8..a1907e8e620f 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2958,15 +2958,17 @@ static void mwifiex_cleanup_pcie(struct mwifiex_adapter *adapter)
 				    "Failed to write driver not-ready signature\n");
 	}
 
-	mwifiex_pcie_free_buffers(adapter);
-
 	if (pdev) {
+		pci_disable_device(pdev);
+
 		pci_iounmap(pdev, card->pci_mmap);
 		pci_iounmap(pdev, card->pci_mmap1);
 		pci_disable_device(pdev);
 		pci_release_region(pdev, 2);
 		pci_release_region(pdev, 0);
 	}
+
+	mwifiex_pcie_free_buffers(adapter);
 }
 
 static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
@@ -3142,7 +3144,6 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 static void mwifiex_pcie_up_dev(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
-	int ret;
 	struct pci_dev *pdev = card->dev;
 
 	/* tx_buf_size might be changed to 3584 by firmware during
@@ -3150,11 +3151,9 @@ static void mwifiex_pcie_up_dev(struct mwifiex_adapter *adapter)
 	 */
 	adapter->tx_buf_size = card->pcie.tx_buf_size;
 
-	ret = mwifiex_pcie_alloc_buffers(adapter);
-	if (!ret)
-		return;
+	mwifiex_pcie_alloc_buffers(adapter);
 
-	pci_iounmap(pdev, card->pci_mmap1);
+	pci_set_master(pdev);
 }
 
 /* This function cleans up the PCI-E host memory space. */
@@ -3162,10 +3161,13 @@ static void mwifiex_pcie_down_dev(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+	struct pci_dev *pdev = card->dev;
 
 	if (mwifiex_write_reg(adapter, reg->drv_rdy, 0x00000000))
 		mwifiex_dbg(adapter, ERROR, "Failed to write driver not-ready signature\n");
 
+	pci_clear_master(pdev);
+
 	adapter->seq_num = 0;
 
 	mwifiex_pcie_free_buffers(adapter);
-- 
2.14.0.rc0.284.gd933b75aa4-goog
