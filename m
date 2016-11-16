Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42769 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753144AbcKPNKd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 08:10:33 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 5/5] mwifiex: move pcie_work and related variables inside card
Date: Wed, 16 Nov 2016 18:39:09 +0530
Message-ID: <1479301749-14803-5-git-send-email-akarwar@marvell.com> (sfid-20161116_141036_323341_D16F6672)
In-Reply-To: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
References: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

Currently pcie_work and related variables are global. It may create
problem while supporting multiple devices simultaneously. Let's move
it inside card structure so that separate instance will be created/
cancelled in init/teardown threads of each connected devices.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v3: This patch is introduced in v3
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 23 ++++++++++++-----------
 drivers/net/wireless/marvell/mwifiex/pcie.h |  2 ++
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c8e69a4..32fa4ed 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -52,7 +52,6 @@ static int mwifiex_pcie_probe_of(struct device *dev)
 }
 
 static void mwifiex_pcie_work(struct work_struct *work);
-static DECLARE_WORK(pcie_work, mwifiex_pcie_work);
 
 static int
 mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
@@ -222,6 +221,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 		card->pcie.mem_type_mapping_tbl = data->mem_type_mapping_tbl;
 		card->pcie.num_mem_types = data->num_mem_types;
 		card->pcie.can_ext_scan = data->can_ext_scan;
+		INIT_WORK(&card->work, mwifiex_pcie_work);
 	}
 
 	/* device tree node parsing and platform specific configuration*/
@@ -257,7 +257,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	cancel_work_sync(&pcie_work);
+	cancel_work_sync(&card->work);
 
 	if (user_rmmod && !adapter->mfg_mode) {
 		mwifiex_deauthenticate_all(adapter);
@@ -2718,25 +2718,27 @@ static void mwifiex_pcie_device_dump_work(struct mwifiex_adapter *adapter)
 	mwifiex_upload_device_dump(adapter, drv_info, drv_info_size);
 }
 
-static unsigned long iface_work_flags;
-static struct mwifiex_adapter *save_adapter;
 static void mwifiex_pcie_work(struct work_struct *work)
 {
+	struct pcie_service_card *card =
+		container_of(work, struct pcie_service_card, work);
+
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
-			       &iface_work_flags))
-		mwifiex_pcie_device_dump_work(save_adapter);
+			       &card->work_flags))
+		mwifiex_pcie_device_dump_work(card->adapter);
 }
 
 /* This function dumps FW information */
 static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
 {
-	save_adapter = adapter;
-	if (test_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags))
+	struct pcie_service_card *card = adapter->card;
+
+	if (test_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags))
 		return;
 
-	set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags);
+	set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
 
-	schedule_work(&pcie_work);
+	schedule_work(&card->work);
 }
 
 /*
@@ -3202,7 +3204,6 @@ static void mwifiex_pcie_cleanup_module(void)
 	/* Set the flag as user is removing this module. */
 	user_rmmod = 1;
 
-	cancel_work_sync(&pcie_work);
 	pci_unregister_driver(&mwifiex_pcie);
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index ae3365d..21ba5e6 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -386,6 +386,8 @@ struct pcie_service_card {
 #endif
 	struct mwifiex_msix_context msix_ctx[MWIFIEX_NUM_MSIX_VECTORS];
 	struct mwifiex_msix_context share_irq_ctx;
+	struct work_struct work;
+	unsigned long work_flags;
 };
 
 static inline int
-- 
1.9.1
