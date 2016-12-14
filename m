Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34805 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752680AbcLNOLi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 09:11:38 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/5] mwifiex: get rid of mwifiex_do_flr wrapper
Date: Wed, 14 Dec 2016 19:40:47 +0530
Message-ID: <1481724651-30397-1-git-send-email-akarwar@marvell.com> (sfid-20161214_151143_102738_A49E5580)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch gets rid of mwifiex_do_flr. We will call
mwifiex_shutdown_sw() and mwifiex_reinit_sw() directly.
These two general purpose functions will be useful for
sdio card reset handler.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 31 +++++------------------------
 drivers/net/wireless/marvell/mwifiex/main.h |  3 ++-
 drivers/net/wireless/marvell/mwifiex/pcie.c |  4 ++--
 3 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index c1821aa..3fc6221 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1348,7 +1348,7 @@ static void mwifiex_main_work_queue(struct work_struct *work)
  * This function gets called during PCIe function level reset. Required
  * code is extracted from mwifiex_remove_card()
  */
-static int
+int
 mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_private *priv;
@@ -1417,13 +1417,13 @@ static void mwifiex_main_work_queue(struct work_struct *work)
 exit_return:
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mwifiex_shutdown_sw);
 
 /* This function gets called during PCIe function level reset. Required
  * code is extracted from mwifiex_add_card()
  */
-static int
-mwifiex_reinit_sw(struct mwifiex_adapter *adapter, struct completion *fw_done,
-		  struct mwifiex_if_ops *if_ops, u8 iface_type)
+int
+mwifiex_reinit_sw(struct mwifiex_adapter *adapter)
 {
 	char fw_name[32];
 	struct pcie_service_card *card = adapter->card;
@@ -1432,9 +1432,6 @@ static void mwifiex_main_work_queue(struct work_struct *work)
 	if (adapter->if_ops.up_dev)
 		adapter->if_ops.up_dev(adapter);
 
-	adapter->iface_type = iface_type;
-	adapter->fw_done = fw_done;
-
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
 	adapter->surprise_removed = false;
 	init_waitqueue_head(&adapter->init_wait_q);
@@ -1507,25 +1504,7 @@ static void mwifiex_main_work_queue(struct work_struct *work)
 
 	return -1;
 }
-
-/* This function processes pre and post PCIe function level resets.
- * It performs software cleanup without touching PCIe specific code.
- * Also, during initialization PCIe stuff is skipped.
- */
-void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare)
-{
-	struct mwifiex_if_ops if_ops;
-
-	if (!prepare) {
-		mwifiex_reinit_sw(adapter, adapter->fw_done, &if_ops,
-				  adapter->iface_type);
-	} else {
-		memcpy(&if_ops, &adapter->if_ops,
-		       sizeof(struct mwifiex_if_ops));
-		mwifiex_shutdown_sw(adapter);
-	}
-}
-EXPORT_SYMBOL_GPL(mwifiex_do_flr);
+EXPORT_SYMBOL_GPL(mwifiex_reinit_sw);
 
 static irqreturn_t mwifiex_irq_wakeup_handler(int irq, void *priv)
 {
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index d501d03..5f7a010 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1666,5 +1666,6 @@ void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
 void mwifiex_dev_debugfs_init(struct mwifiex_private *priv);
 void mwifiex_dev_debugfs_remove(struct mwifiex_private *priv);
 #endif
-void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare);
+int mwifiex_reinit_sw(struct mwifiex_adapter *adapter);
+int mwifiex_shutdown_sw(struct mwifiex_adapter *adapter);
 #endif /* !_MWIFIEX_MAIN_H_ */
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 55c79e3..02f6db0 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -375,7 +375,7 @@ static void mwifiex_pcie_reset_notify(struct pci_dev *pdev, bool prepare)
 		 * Cleanup all software without cleaning anything related to
 		 * PCIe and HW.
 		 */
-		mwifiex_do_flr(adapter, prepare);
+		mwifiex_shutdown_sw(adapter);
 		adapter->surprise_removed = true;
 	} else {
 		/* Kernel stores and restores PCIe function context before and
@@ -383,7 +383,7 @@ static void mwifiex_pcie_reset_notify(struct pci_dev *pdev, bool prepare)
 		 * and firmware including firmware redownload
 		 */
 		adapter->surprise_removed = false;
-		mwifiex_do_flr(adapter, prepare);
+		mwifiex_reinit_sw(adapter);
 	}
 	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
 }
-- 
1.9.1
