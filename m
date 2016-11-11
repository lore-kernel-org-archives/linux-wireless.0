Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39779 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750849AbcKKLPr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 06:15:47 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>
Subject: [PATCH v2 1/3] mwifiex: Allow mwifiex early access to device structure
Date: Fri, 11 Nov 2016 16:45:09 +0530
Message-ID: <1478862911-15498-1-git-send-email-akarwar@marvell.com> (sfid-20161111_121551_427858_DA1A6029)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajat Jain <rajatja@google.com>

Today all the interface drivers (usb/pcie/sdio) assign the
adapter->dev in the register_dev() callback, although they
have this piece of info well before hand.

This patch makes the device structure available for mwifiex
right at the beginning, so that it can be used for early
initialization if needed.

This is needed for subsequent patches in this patchset that
intend to unify and consolidate some of the code that would
otherwise have to be duplicated among the interface drivers
(sdio, pcie, usb).

Signed-off-by: Rajat Jain <rajatja@google.com>
---
v2: Same as v1
---
 drivers/net/wireless/marvell/mwifiex/main.c | 4 +++-
 drivers/net/wireless/marvell/mwifiex/main.h | 3 ++-
 drivers/net/wireless/marvell/mwifiex/pcie.c | 4 +---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 5 +----
 drivers/net/wireless/marvell/mwifiex/usb.c  | 3 +--
 5 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 2478ccd..dcceab2 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1567,7 +1567,8 @@ void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare)
  */
 int
 mwifiex_add_card(void *card, struct semaphore *sem,
-		 struct mwifiex_if_ops *if_ops, u8 iface_type)
+		 struct mwifiex_if_ops *if_ops, u8 iface_type,
+		 struct device *dev)
 {
 	struct mwifiex_adapter *adapter;
 
@@ -1579,6 +1580,7 @@ void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare)
 		goto err_init_sw;
 	}
 
+	adapter->dev = dev;
 	adapter->iface_type = iface_type;
 	adapter->card_sem = sem;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index d61fe3a..2664513 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1412,7 +1412,8 @@ static inline u8 mwifiex_is_tdls_link_setup(u8 status)
 
 int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 			     u32 func_init_shutdown);
-int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8);
+int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8,
+		     struct device *);
 int mwifiex_remove_card(struct mwifiex_adapter *, struct semaphore *);
 
 void mwifiex_get_version(struct mwifiex_adapter *adapter, char *version,
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index fed6a1d..de6939c 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -231,7 +231,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 	}
 
 	ret = mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
-			       MWIFIEX_PCIE);
+			       MWIFIEX_PCIE, &pdev->dev);
 	if (ret) {
 		pr_err("%s failed\n", __func__);
 		goto err_free;
@@ -2999,11 +2999,9 @@ static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
-	struct pci_dev *pdev = card->dev;
 
 	/* save adapter pointer in card */
 	card->adapter = adapter;
-	adapter->dev = &pdev->dev;
 
 	if (mwifiex_pcie_request_irq(adapter))
 		return -1;
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 807af13..c95f41f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -206,7 +206,7 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
 	}
 
 	ret = mwifiex_add_card(card, &add_remove_card_sem, &sdio_ops,
-			       MWIFIEX_SDIO);
+			       MWIFIEX_SDIO, &func->dev);
 	if (ret) {
 		dev_err(&func->dev, "add card failed\n");
 		goto err_disable;
@@ -2106,9 +2106,6 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 		return ret;
 	}
 
-
-	adapter->dev = &func->dev;
-
 	strcpy(adapter->fw_name, card->firmware);
 	if (card->fw_dump_enh) {
 		adapter->mem_type_mapping_tbl = generic_mem_type_map;
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 73eb084..f847fff 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -476,7 +476,7 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	usb_set_intfdata(intf, card);
 
 	ret = mwifiex_add_card(card, &add_remove_card_sem, &usb_ops,
-			       MWIFIEX_USB);
+			       MWIFIEX_USB, &card->udev->dev);
 	if (ret) {
 		pr_err("%s: mwifiex_add_card failed: %d\n", __func__, ret);
 		usb_reset_device(udev);
@@ -932,7 +932,6 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
 
 	card->adapter = adapter;
-	adapter->dev = &card->udev->dev;
 
 	switch (le16_to_cpu(card->udev->descriptor.idProduct)) {
 	case USB8997_PID_1:
-- 
1.9.1
