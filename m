Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45546 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754409AbcLANIs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 08:08:48 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: use module_*_driver helper macros
Date: Thu, 1 Dec 2016 18:38:20 +0530
Message-ID: <1480597700-2456-1-git-send-email-akarwar@marvell.com> (sfid-20161201_140851_732344_473B5A9B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After user_rmmod global flag removal, *_init_module() and
*_cleanup_module() have become just a wrapper functions.
We will get rid of them with the help of module_*_driver() macros.

For pcie, existing ".init_if" handler has same name as what
module_pcie_driver() macro will create. Let's rename it to
avoid conflict.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 47 ++++-------------------------
 drivers/net/wireless/marvell/mwifiex/sdio.c | 29 +-----------------
 drivers/net/wireless/marvell/mwifiex/usb.c  | 35 +--------------------
 3 files changed, 8 insertions(+), 103 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 079bb09..462f014 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2754,7 +2754,7 @@ static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
  *      - Allocate command response ring buffer
  *      - Allocate sleep cookie buffer
  */
-static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
+static int mwifiex_init_pcie(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	int ret;
@@ -2863,7 +2863,7 @@ static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
  *      - Command response ring buffer
  *      - Sleep cookie buffer
  */
-static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
+static void mwifiex_cleanup_pcie(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	struct pci_dev *pdev = card->dev;
@@ -3063,7 +3063,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
  *      - Allocate event BD ring buffers
  *      - Allocate command response ring buffer
  *      - Allocate sleep cookie buffer
- * Part of mwifiex_pcie_init(), not reset the PCIE registers
+ * Part of mwifiex_init_pcie(), not reset the PCIE registers
  */
 static void mwifiex_pcie_up_dev(struct mwifiex_adapter *adapter)
 {
@@ -3146,8 +3146,8 @@ static void mwifiex_pcie_down_dev(struct mwifiex_adapter *adapter)
 }
 
 static struct mwifiex_if_ops pcie_ops = {
-	.init_if =			mwifiex_pcie_init,
-	.cleanup_if =			mwifiex_pcie_cleanup,
+	.init_if =			mwifiex_init_pcie,
+	.cleanup_if =			mwifiex_cleanup_pcie,
 	.check_fw_status =		mwifiex_check_fw_status,
 	.check_winner_status =          mwifiex_check_winner_status,
 	.prog_fw =			mwifiex_prog_fw_w_helper,
@@ -3173,42 +3173,7 @@ static void mwifiex_pcie_down_dev(struct mwifiex_adapter *adapter)
 	.up_dev =			mwifiex_pcie_up_dev,
 };
 
-/*
- * This function initializes the PCIE driver module.
- *
- * This registers the device with PCIE bus.
- */
-static int mwifiex_pcie_init_module(void)
-{
-	int ret;
-
-	pr_debug("Marvell PCIe Driver\n");
-
-	ret = pci_register_driver(&mwifiex_pcie);
-	if (ret)
-		pr_err("Driver register failed!\n");
-	else
-		pr_debug("info: Driver registered successfully!\n");
-
-	return ret;
-}
-
-/*
- * This function cleans up the PCIE driver.
- *
- * The following major steps are followed for cleanup -
- *      - Resume the device if its suspended
- *      - Disconnect the device if connected
- *      - Shutdown the firmware
- *      - Unregister the device from PCIE bus.
- */
-static void mwifiex_pcie_cleanup_module(void)
-{
-	pci_unregister_driver(&mwifiex_pcie);
-}
-
-module_init(mwifiex_pcie_init_module);
-module_exit(mwifiex_pcie_cleanup_module);
+module_pci_driver(mwifiex_pcie);
 
 MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell WiFi-Ex PCI-Express Driver version " PCIE_VERSION);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 9a16e61..db01794 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2698,34 +2698,7 @@ static void mwifiex_sdio_device_dump(struct mwifiex_adapter *adapter)
 	.deaggr_pkt = mwifiex_deaggr_sdio_pkt,
 };
 
-/*
- * This function initializes the SDIO driver.
- *
- * This registers the device with SDIO bus.
- */
-static int
-mwifiex_sdio_init_module(void)
-{
-	return sdio_register_driver(&mwifiex_sdio);
-}
-
-/*
- * This function cleans up the SDIO driver.
- *
- * The following major steps are followed for cleanup -
- *      - Resume the device if its suspended
- *      - Disconnect the device if connected
- *      - Shutdown the firmware
- *      - Unregister the device from SDIO bus.
- */
-static void
-mwifiex_sdio_cleanup_module(void)
-{
-	sdio_unregister_driver(&mwifiex_sdio);
-}
-
-module_init(mwifiex_sdio_init_module);
-module_exit(mwifiex_sdio_cleanup_module);
+module_driver(mwifiex_sdio, sdio_register_driver, sdio_unregister_driver);
 
 MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell WiFi-Ex SDIO Driver version " SDIO_VERSION);
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 53881c4..9cf3334 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -1200,40 +1200,7 @@ static void mwifiex_usb_submit_rem_rx_urbs(struct mwifiex_adapter *adapter)
 	.is_port_ready =	mwifiex_usb_is_port_ready,
 };
 
-/* This function initializes the USB driver module.
- *
- * This registers the device with USB bus.
- */
-static int mwifiex_usb_init_module(void)
-{
-	int ret;
-
-	pr_debug("Marvell USB8797 Driver\n");
-
-	ret = usb_register(&mwifiex_usb_driver);
-	if (ret)
-		pr_err("Driver register failed!\n");
-	else
-		pr_debug("info: Driver registered successfully!\n");
-
-	return ret;
-}
-
-/* This function cleans up the USB driver.
- *
- * The following major steps are followed in .disconnect for cleanup:
- *      - Resume the device if its suspended
- *      - Disconnect the device if connected
- *      - Shutdown the firmware
- *      - Unregister the device from USB bus.
- */
-static void mwifiex_usb_cleanup_module(void)
-{
-	usb_deregister(&mwifiex_usb_driver);
-}
-
-module_init(mwifiex_usb_init_module);
-module_exit(mwifiex_usb_cleanup_module);
+module_usb_driver(mwifiex_usb_driver);
 
 MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell WiFi-Ex USB Driver version" USB_VERSION);
-- 
1.9.1
