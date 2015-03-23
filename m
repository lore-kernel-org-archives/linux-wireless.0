Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55866 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbbCWGEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 02:04:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2N64HBU020204
	for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2015 23:04:35 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1t9r4ptgtt-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2015 23:04:35 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: Fix issue in the SDIO reset path of mwifiex.
Date: Sun, 22 Mar 2015 23:01:25 -0700
Message-ID: <1427090485-29336-1-git-send-email-akarwar@marvell.com> (sfid-20150323_070456_218633_D8B7D431)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maithili Hinge <maithili@marvell.com>

SDIO reset was not happening properly on mwifiex as cancel_work_sync
in mwifiex_sdio_remove used to kill the calling work function itself.
Due to this, the interface was not getting removed and card was not
getting added again. Reset work function has been made independent
of adapter variable and cancel_work_sync has been moved to cleanup
function.

Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |  3 ---
 drivers/net/wireless/mwifiex/main.h |  2 --
 drivers/net/wireless/mwifiex/pcie.c | 21 ++++++++++----------
 drivers/net/wireless/mwifiex/sdio.c | 38 ++++++++++++++++++-------------------
 4 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index eaaacec..a3c2bb1 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -1149,9 +1149,6 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 		INIT_WORK(&adapter->rx_work, mwifiex_rx_work_queue);
 	}
 
-	if (adapter->if_ops.iface_work)
-		INIT_WORK(&adapter->iface_work, adapter->if_ops.iface_work);
-
 	/* Register the device. Fill up the private data structure with relevant
 	   information from the card. */
 	if (adapter->if_ops.register_dev(adapter)) {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 842fa0b..b97b85b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -898,8 +898,6 @@ struct mwifiex_adapter {
 	bool ext_scan;
 	u8 fw_api_ver;
 	u8 key_api_major_ver, key_api_minor_ver;
-	struct work_struct iface_work;
-	unsigned long iface_work_flags;
 	struct memory_type_mapping *mem_type_mapping_tbl;
 	u8 num_mem_types;
 	u8 curr_mem_idx;
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index b31c9a7..bcc7751 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -234,8 +234,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	cancel_work_sync(&adapter->iface_work);
-
 	if (user_rmmod) {
 #ifdef CONFIG_PM_SLEEP
 		if (adapter->is_suspended)
@@ -2373,25 +2371,26 @@ done:
 	adapter->curr_mem_idx = 0;
 }
 
+static unsigned long iface_work_flags;
+static struct mwifiex_adapter *save_adapter;
 static void mwifiex_pcie_work(struct work_struct *work)
 {
-	struct mwifiex_adapter *adapter =
-			container_of(work, struct mwifiex_adapter, iface_work);
-
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_FW_DUMP,
-			       &adapter->iface_work_flags))
-		mwifiex_pcie_fw_dump_work(adapter);
+			       &iface_work_flags))
+		mwifiex_pcie_fw_dump_work(save_adapter);
 }
 
+static DECLARE_WORK(pcie_work, mwifiex_pcie_work);
 /* This function dumps FW information */
 static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 {
-	if (test_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &adapter->iface_work_flags))
+	save_adapter = adapter;
+	if (test_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &iface_work_flags))
 		return;
 
-	set_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &adapter->iface_work_flags);
+	set_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &iface_work_flags);
 
-	schedule_work(&adapter->iface_work);
+	schedule_work(&pcie_work);
 }
 
 /*
@@ -2619,7 +2618,6 @@ static struct mwifiex_if_ops pcie_ops = {
 	.init_fw_port =			mwifiex_pcie_init_fw_port,
 	.clean_pcie_ring =		mwifiex_clean_pcie_ring_buf,
 	.fw_dump =			mwifiex_pcie_fw_dump,
-	.iface_work =			mwifiex_pcie_work,
 };
 
 /*
@@ -2665,6 +2663,7 @@ static void mwifiex_pcie_cleanup_module(void)
 	/* Set the flag as user is removing this module. */
 	user_rmmod = 1;
 
+	cancel_work_sync(&pcie_work);
 	pci_unregister_driver(&mwifiex_pcie);
 }
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 4f08c58..6af7a082 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -47,6 +47,7 @@
 static u8 user_rmmod;
 
 static struct mwifiex_if_ops sdio_ops;
+static unsigned long iface_work_flags;
 
 static struct semaphore add_remove_card_sem;
 
@@ -200,8 +201,6 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	cancel_work_sync(&adapter->iface_work);
-
 	if (user_rmmod) {
 		if (adapter->is_suspended)
 			mwifiex_sdio_resume(adapter->dev);
@@ -2040,6 +2039,7 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 		port, card->mp_data_port_mask);
 }
 
+static struct mwifiex_adapter *save_adapter;
 static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
@@ -2108,10 +2108,8 @@ rdwr_status mwifiex_sdio_rdwr_firmware(struct mwifiex_adapter *adapter,
 }
 
 /* This function dump firmware memory to file */
-static void mwifiex_sdio_fw_dump_work(struct work_struct *work)
+static void mwifiex_sdio_fw_dump_work(struct mwifiex_adapter *adapter)
 {
-	struct mwifiex_adapter *adapter =
-			container_of(work, struct mwifiex_adapter, iface_work);
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
 	unsigned int reg, reg_start, reg_end;
@@ -2233,36 +2231,36 @@ done:
 
 static void mwifiex_sdio_work(struct work_struct *work)
 {
-	struct mwifiex_adapter *adapter =
-			container_of(work, struct mwifiex_adapter, iface_work);
-
-	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
-			       &adapter->iface_work_flags))
-		mwifiex_sdio_card_reset_work(adapter);
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_FW_DUMP,
-			       &adapter->iface_work_flags))
-		mwifiex_sdio_fw_dump_work(work);
+			       &iface_work_flags))
+		mwifiex_sdio_fw_dump_work(save_adapter);
+	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
+			       &iface_work_flags))
+		mwifiex_sdio_card_reset_work(save_adapter);
 }
 
+static DECLARE_WORK(sdio_work, mwifiex_sdio_work);
 /* This function resets the card */
 static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
 {
-	if (test_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &adapter->iface_work_flags))
+	save_adapter = adapter;
+	if (test_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &iface_work_flags))
 		return;
 
-	set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &adapter->iface_work_flags);
+	set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &iface_work_flags);
 
-	schedule_work(&adapter->iface_work);
+	schedule_work(&sdio_work);
 }
 
 /* This function dumps FW information */
 static void mwifiex_sdio_fw_dump(struct mwifiex_adapter *adapter)
 {
-	if (test_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &adapter->iface_work_flags))
+	save_adapter = adapter;
+	if (test_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &iface_work_flags))
 		return;
 
-	set_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &adapter->iface_work_flags);
-	schedule_work(&adapter->iface_work);
+	set_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &iface_work_flags);
+	schedule_work(&sdio_work);
 }
 
 /* Function to dump SDIO function registers and SDIO scratch registers in case
@@ -2378,7 +2376,6 @@ static struct mwifiex_if_ops sdio_ops = {
 	.cmdrsp_complete = mwifiex_sdio_cmdrsp_complete,
 	.event_complete = mwifiex_sdio_event_complete,
 	.card_reset = mwifiex_sdio_card_reset,
-	.iface_work = mwifiex_sdio_work,
 	.fw_dump = mwifiex_sdio_fw_dump,
 	.reg_dump = mwifiex_sdio_reg_dump,
 	.deaggr_pkt = mwifiex_deaggr_sdio_pkt,
@@ -2418,6 +2415,7 @@ mwifiex_sdio_cleanup_module(void)
 
 	/* Set the flag as user is removing this module. */
 	user_rmmod = 1;
+	cancel_work_sync(&sdio_work);
 
 	sdio_unregister_driver(&mwifiex_sdio);
 }
-- 
1.8.1.4

