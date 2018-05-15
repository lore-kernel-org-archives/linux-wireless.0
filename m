Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58132 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752925AbeEOJPI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:15:08 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/8] mwifiex: support sysfs initiated device coredump
Date: Tue, 15 May 2018 11:14:47 +0200
Message-Id: <1526375691-31789-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180515_111545_746323_10CA4D4E)
In-Reply-To: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
it is possible to initiate a device coredump from user-space. This
patch adds support for it adding the .coredump() driver callback.
As there is no longer a need to initiate it through debugfs remove
that code.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/marvell/mwifiex/debugfs.c | 31 +-------------------------
 drivers/net/wireless/marvell/mwifiex/pcie.c    | 18 +++++++++++++--
 drivers/net/wireless/marvell/mwifiex/sdio.c    | 12 ++++++++++
 drivers/net/wireless/marvell/mwifiex/usb.c     | 13 +++++++++++
 4 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index db2872d..0745393 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -154,34 +154,6 @@
 }
 
 /*
- * Proc device dump read handler.
- *
- * This function is called when the 'device_dump' file is opened for
- * reading.
- * This function dumps driver information and firmware memory segments
- * (ex. DTCM, ITCM, SQRAM etc.) for
- * debugging.
- */
-static ssize_t
-mwifiex_device_dump_read(struct file *file, char __user *ubuf,
-			 size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv = file->private_data;
-
-	/* For command timeouts, USB firmware will automatically emit
-	 * firmware dump events, so we don't implement device_dump().
-	 * For user-initiated dumps, we trigger it ourselves.
-	 */
-	if (priv->adapter->iface_type == MWIFIEX_USB)
-		mwifiex_send_cmd(priv, HostCmd_CMD_FW_DUMP_EVENT,
-				 HostCmd_ACT_GEN_SET, 0, NULL, true);
-	else
-		priv->adapter->if_ops.device_dump(priv->adapter);
-
-	return 0;
-}
-
-/*
  * Proc getlog file read handler.
  *
  * This function is called when the 'getlog' file is opened for reading
@@ -980,7 +952,6 @@
 MWIFIEX_DFS_FILE_READ_OPS(info);
 MWIFIEX_DFS_FILE_READ_OPS(debug);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
-MWIFIEX_DFS_FILE_READ_OPS(device_dump);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
 MWIFIEX_DFS_FILE_OPS(memrw);
@@ -1011,7 +982,7 @@
 	MWIFIEX_DFS_ADD_FILE(getlog);
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
-	MWIFIEX_DFS_ADD_FILE(device_dump);
+
 	MWIFIEX_DFS_ADD_FILE(memrw);
 	MWIFIEX_DFS_ADD_FILE(hscfg);
 	MWIFIEX_DFS_ADD_FILE(histogram);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 7538543..0c42b72 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -320,6 +320,19 @@ static void mwifiex_pcie_shutdown(struct pci_dev *pdev)
 	return;
 }
 
+static void mwifiex_pcie_coredump(struct device *dev)
+{
+	struct pci_dev *pdev;
+	struct pcie_service_card *card;
+
+	pdev = container_of(dev, struct pci_dev, dev);
+	card = pci_get_drvdata(pdev);
+
+	if (!test_and_set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
+			      &card->work_flags))
+		schedule_work(&card->work);
+}
+
 static const struct pci_device_id mwifiex_ids[] = {
 	{
 		PCIE_VENDOR_ID_MARVELL, PCIE_DEVICE_ID_MARVELL_88W8766P,
@@ -415,11 +428,12 @@ static SIMPLE_DEV_PM_OPS(mwifiex_pcie_pm_ops, mwifiex_pcie_suspend,
 	.id_table = mwifiex_ids,
 	.probe    = mwifiex_pcie_probe,
 	.remove   = mwifiex_pcie_remove,
-#ifdef CONFIG_PM_SLEEP
 	.driver   = {
+		.coredump = mwifiex_pcie_coredump,
+#ifdef CONFIG_PM_SLEEP
 		.pm = &mwifiex_pcie_pm_ops,
-	},
 #endif
+	},
 	.shutdown = mwifiex_pcie_shutdown,
 	.err_handler = &mwifiex_pcie_err_handler,
 };
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a828801..47d2dcc 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -466,6 +466,17 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	return ret;
 }
 
+static void mwifiex_sdio_coredump(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct sdio_mmc_card *card;
+
+	card = sdio_get_drvdata(func);
+	if (!test_and_set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
+			      &card->work_flags))
+		schedule_work(&card->work);
+}
+
 /* Device ID for SD8786 */
 #define SDIO_DEVICE_ID_MARVELL_8786   (0x9116)
 /* Device ID for SD8787 */
@@ -515,6 +526,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	.remove = mwifiex_sdio_remove,
 	.drv = {
 		.owner = THIS_MODULE,
+		.coredump = mwifiex_sdio_coredump,
 		.pm = &mwifiex_sdio_pm_ops,
 	}
 };
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 4bc2448..7aa39878 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -653,6 +653,16 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 	usb_put_dev(interface_to_usbdev(intf));
 }
 
+static void mwifiex_usb_coredump(struct device *dev)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_card_rec *card = usb_get_intfdata(intf);
+
+	mwifiex_send_cmd(mwifiex_get_priv(card->adapter, MWIFIEX_BSS_ROLE_ANY),
+			 HostCmd_CMD_FW_DUMP_EVENT, HostCmd_ACT_GEN_SET, 0,
+			 NULL, true);
+}
+
 static struct usb_driver mwifiex_usb_driver = {
 	.name = "mwifiex_usb",
 	.probe = mwifiex_usb_probe,
@@ -661,6 +671,9 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 	.suspend = mwifiex_usb_suspend,
 	.resume = mwifiex_usb_resume,
 	.soft_unbind = 1,
+	.drvwrap.driver = {
+		.coredump = mwifiex_usb_coredump,
+	},
 };
 
 static int mwifiex_write_data_sync(struct mwifiex_adapter *adapter, u8 *pbuf,
-- 
1.9.1
