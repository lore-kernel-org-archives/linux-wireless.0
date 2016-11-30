Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55714 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932242AbcK3Ox2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 09:53:28 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/2] mwifiex: get rid of global user_rmmod flag
Date: Wed, 30 Nov 2016 20:22:17 +0530
Message-ID: <1480517537-9920-2-git-send-email-akarwar@marvell.com> (sfid-20161130_155333_251055_725B5C35)
In-Reply-To: <1480517537-9920-1-git-send-email-akarwar@marvell.com>
References: <1480517537-9920-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

bus.remove() callback function is called when user removes this module
from kernel space or ejects the card from the slot. The driver handles
these 2 cases differently. Few commands (FUNC_SHUTDOWN etc.) are sent to
the firmware only for module unload case.

The variable 'user_rmmod' is used to distinguish between these two
scenarios.

This patch checks hardware status and get rid of global variable
user_rmmod.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 23 ++++++++++++-----------
 drivers/net/wireless/marvell/mwifiex/sdio.c | 27 ++++-----------------------
 drivers/net/wireless/marvell/mwifiex/usb.c  |  6 +-----
 3 files changed, 17 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 7aa16a5..079bb09 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -31,8 +31,6 @@
 #define PCIE_VERSION	"1.0"
 #define DRV_NAME        "Marvell mwifiex PCIe"
 
-static u8 user_rmmod;
-
 static struct mwifiex_if_ops pcie_ops;
 
 static const struct of_device_id mwifiex_pcie_of_match_table[] = {
@@ -284,6 +282,9 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	struct pcie_service_card *card;
 	struct mwifiex_adapter *adapter;
 	struct mwifiex_private *priv;
+	const struct mwifiex_pcie_card_reg *reg;
+	u32 fw_status;
+	int ret;
 
 	card = pci_get_drvdata(pdev);
 
@@ -295,7 +296,11 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 
 	cancel_work_sync(&card->work);
 
-	if (user_rmmod && !adapter->mfg_mode) {
+	reg = card->pcie.reg;
+	if (reg)
+		ret = mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
+
+	if (fw_status == FIRMWARE_READY_PCIE && !adapter->mfg_mode) {
 		mwifiex_deauthenticate_all(adapter);
 
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
@@ -310,7 +315,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 
 static void mwifiex_pcie_shutdown(struct pci_dev *pdev)
 {
-	user_rmmod = 1;
 	mwifiex_pcie_remove(pdev);
 
 	return;
@@ -2864,8 +2868,11 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	struct pci_dev *pdev = card->dev;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+	int ret;
+	u32 fw_status;
 
-	if (user_rmmod) {
+	ret = mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
+	if (fw_status == FIRMWARE_READY_PCIE) {
 		mwifiex_dbg(adapter, INFO,
 			    "Clearing driver ready signature\n");
 		if (mwifiex_write_reg(adapter, reg->drv_rdy, 0x00000000))
@@ -3177,9 +3184,6 @@ static int mwifiex_pcie_init_module(void)
 
 	pr_debug("Marvell PCIe Driver\n");
 
-	/* Clear the flag in case user removes the card. */
-	user_rmmod = 0;
-
 	ret = pci_register_driver(&mwifiex_pcie);
 	if (ret)
 		pr_err("Driver register failed!\n");
@@ -3200,9 +3204,6 @@ static int mwifiex_pcie_init_module(void)
  */
 static void mwifiex_pcie_cleanup_module(void)
 {
-	/* Set the flag as user is removing this module. */
-	user_rmmod = 1;
-
 	pci_unregister_driver(&mwifiex_pcie);
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 6fcaf26..9a16e61 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -31,21 +31,6 @@
 
 #define SDIO_VERSION	"1.0"
 
-/* The mwifiex_sdio_remove() callback function is called when
- * user removes this module from kernel space or ejects
- * the card from the slot. The driver handles these 2 cases
- * differently.
- * If the user is removing the module, the few commands (FUNC_SHUTDOWN,
- * HS_CANCEL etc.) are sent to the firmware.
- * If the card is removed, there is no need to send these command.
- *
- * The variable 'user_rmmod' is used to distinguish these two
- * scenarios. This flag is initialized as FALSE in case the card
- * is removed, and will be set to TRUE for module removal when
- * module_exit function is called.
- */
-static u8 user_rmmod;
-
 static void mwifiex_sdio_work(struct work_struct *work);
 static DECLARE_WORK(sdio_work, mwifiex_sdio_work);
 
@@ -391,6 +376,8 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
 	struct mwifiex_private *priv;
+	int ret = 0;
+	u16 firmware_stat;
 
 	card = sdio_get_drvdata(func);
 	if (!card)
@@ -404,7 +391,8 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
 
 	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
 
-	if (user_rmmod && !adapter->mfg_mode) {
+	ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
+	if (firmware_stat == FIRMWARE_READY_SDIO && !adapter->mfg_mode) {
 		mwifiex_deauthenticate_all(adapter);
 
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
@@ -2718,9 +2706,6 @@ static void mwifiex_sdio_device_dump(struct mwifiex_adapter *adapter)
 static int
 mwifiex_sdio_init_module(void)
 {
-	/* Clear the flag in case user removes the card. */
-	user_rmmod = 0;
-
 	return sdio_register_driver(&mwifiex_sdio);
 }
 
@@ -2736,10 +2721,6 @@ static void mwifiex_sdio_device_dump(struct mwifiex_adapter *adapter)
 static void
 mwifiex_sdio_cleanup_module(void)
 {
-	/* Set the flag as user is removing this module. */
-	user_rmmod = 1;
-	cancel_work_sync(&sdio_work);
-
 	sdio_unregister_driver(&mwifiex_sdio);
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index c563160..53881c4 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -22,7 +22,6 @@
 
 #define USB_VERSION	"1.0"
 
-static u8 user_rmmod;
 static struct mwifiex_if_ops usb_ops;
 
 static struct usb_device_id mwifiex_usb_table[] = {
@@ -618,7 +617,7 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	if (user_rmmod && !adapter->mfg_mode) {
+	if (card->udev->state != USB_STATE_NOTATTACHED && !adapter->mfg_mode) {
 		mwifiex_deauthenticate_all(adapter);
 
 		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
@@ -1230,9 +1229,6 @@ static int mwifiex_usb_init_module(void)
  */
 static void mwifiex_usb_cleanup_module(void)
 {
-	/* set the flag as user is removing this module */
-	user_rmmod = 1;
-
 	usb_deregister(&mwifiex_usb_driver);
 }
 
-- 
1.9.1
