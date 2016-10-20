Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53916 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935962AbcJTN1A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 09:27:00 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <briannorris@google.com>, <dmitry.torokhov@gmail.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v5 4/4] mwifiex: fix race for card->adapter
Date: Thu, 20 Oct 2016 18:56:19 +0530
Message-ID: <1476969979-28554-4-git-send-email-akarwar@marvell.com> (sfid-20161020_152703_422772_D0A70F48)
In-Reply-To: <1476969979-28554-1-git-send-email-akarwar@marvell.com>
References: <1476969979-28554-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

card->adapter is set/reset in register/unregister calls. Firmware gets
downloaded asynchronously in a separate thread during init. We have a
unregister call when firmware initialization fails. It may have a race
with suspend thread where "card->adapter" is being read.

This patch adds spinlock to fix the problem.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
New patch introduced in v5 to address race between driver init and suspend
threads.
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 38 +++++++++++++++++++++++------
 drivers/net/wireless/marvell/mwifiex/pcie.h |  2 ++
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 94f75be..9147e6a 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -102,23 +102,32 @@ static int mwifiex_pcie_suspend(struct device *dev)
 	struct mwifiex_adapter *adapter;
 	struct pcie_service_card *card;
 	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long flags;
 
 	card = pci_get_drvdata(pdev);
-	if (!card || !card->adapter ||
-	    card->adapter->hw_status == MWIFIEX_HW_STATUS_RESET ||
-	    card->adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY) {
-		pr_err("Card or adapter structure is not valid or hw_status shows failure\n");
+	if (!card) {
+		pr_err("Card is not valid\n");
 		return 0;
 	}
 
+	spin_lock_irqsave(&card->adapter_lock, flags);
 	adapter = card->adapter;
+	if (!adapter ||
+	    adapter->hw_status == MWIFIEX_HW_STATUS_RESET ||
+	    adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY) {
+		spin_unlock_irqrestore(&card->adapter_lock, flags);
+		pr_err("Adapter structure is not valid or hw_status shows failure\n");
+		return 0;
+	}
 
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING ||
 	    adapter->hw_status == MWIFIEX_HW_STATUS_INIT_DONE ||
 	    adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING) {
+		spin_unlock_irqrestore(&card->adapter_lock, flags);
 		pr_err("We are in the middle of initialzaion or closing\n");
 		return -EBUSY;
 	}
+	spin_unlock_irqrestore(&card->adapter_lock, flags);
 
 	/* Enable the Host Sleep */
 	if (!mwifiex_enable_hs(adapter)) {
@@ -150,16 +159,22 @@ static int mwifiex_pcie_resume(struct device *dev)
 	struct mwifiex_adapter *adapter;
 	struct pcie_service_card *card;
 	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long flags;
 
 	card = pci_get_drvdata(pdev);
-
-	if (!card || !card->adapter ||
-	    card->adapter->hw_status != MWIFIEX_HW_STATUS_READY) {
-		pr_err("Card or adapter structure is not valid or hw_status is not ready\n");
+	if (!card) {
+		pr_err("Card is not valid\n");
 		return 0;
 	}
 
+	spin_lock_irqsave(&card->adapter_lock, flags);
 	adapter = card->adapter;
+	if (!adapter || adapter->hw_status != MWIFIEX_HW_STATUS_READY) {
+		spin_unlock_irqrestore(&card->adapter_lock, flags);
+		pr_err("adapter structure is not valid or hw_status is not ready\n");
+		return 0;
+	}
+	spin_unlock_irqrestore(&card->adapter_lock, flags);
 
 	if (!adapter->is_suspended) {
 		mwifiex_dbg(adapter, WARN,
@@ -195,6 +210,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	card->dev = pdev;
+	spin_lock_init(&card->adapter_lock);
 
 	if (ent->driver_data) {
 		struct mwifiex_pcie_device *data = (void *)ent->driver_data;
@@ -2973,9 +2989,12 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	struct pci_dev *pdev = card->dev;
+	unsigned long flags;
 
+	spin_lock_irqsave(&card->adapter_lock, flags);
 	/* save adapter pointer in card */
 	card->adapter = adapter;
+	spin_unlock_irqrestore(&card->adapter_lock, flags);
 	adapter->dev = &pdev->dev;
 
 	if (mwifiex_pcie_request_irq(adapter))
@@ -3001,6 +3020,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	struct pci_dev *pdev;
 	int i;
+	unsigned long flags;
 
 	if (card) {
 		pdev = card->dev;
@@ -3022,7 +3042,9 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 			if (card->msi_enable)
 				pci_disable_msi(pdev);
 	       }
+		spin_lock_irqsave(&card->adapter_lock, flags);
 		card->adapter = NULL;
+		spin_unlock_irqrestore(&card->adapter_lock, flags);
 	}
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 46f99ca..f6e20ea 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -344,6 +344,8 @@ struct mwifiex_msix_context {
 struct pcie_service_card {
 	struct pci_dev *dev;
 	struct mwifiex_adapter *adapter;
+	/* spin lock for card->adapter */
+	spinlock_t adapter_lock;
 	struct mwifiex_pcie_device pcie;
 
 	u8 txbd_flush;
-- 
1.9.1
