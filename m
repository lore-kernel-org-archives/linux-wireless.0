Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37086 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1FBHSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 03:18:14 -0400
Received: by eyx24 with SMTP id 24so188693eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 00:18:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: add an option to register BROKEN bcma driver
Date: Thu,  2 Jun 2011 09:56:04 +0200
Message-Id: <1307001364-9006-1-git-send-email-zajec5@gmail.com> (sfid-20110602_091818_280197_26BA2AF2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It does nothing useful yet, so it is matched as BROKEN.
For now this is just an option for b43, in future we may want to make
b43 support SSB or BCMA (note: or, not xor).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Kconfig |    5 ++++
 drivers/net/wireless/b43/b43.h   |    1 +
 drivers/net/wireless/b43/main.c  |   44 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 480595f..fe26bf4 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -26,6 +26,11 @@ config B43
 	  This driver can be built as a module (recommended) that will be called "b43".
 	  If unsure, say M.
 
+config B43_BCMA
+	bool "Support for BCMA bus"
+	depends on B43 && BCMA && BROKEN
+	default y
+
 # Auto-select SSB PCI-HOST support, if possible
 config B43_PCI_AUTOSELECT
 	bool
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 0a3c701..81d78bf 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -5,6 +5,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/hw_random.h>
+#include <linux/bcma/bcma.h>
 #include <linux/ssb/ssb.h>
 #include <net/mac80211.h>
 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 1b9d3cc..b0ccd0f 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -113,6 +113,16 @@ static int b43_modparam_pio = B43_PIO_DEFAULT;
 module_param_named(pio, b43_modparam_pio, int, 0644);
 MODULE_PARM_DESC(pio, "Use PIO accesses by default: 0=DMA, 1=PIO");
 
+#ifdef CONFIG_B43_BCMA
+static const struct bcma_device_id b43_bcma_tbl[] = {
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x17, BCMA_ANY_CLASS),
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x18, BCMA_ANY_CLASS),
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x1D, BCMA_ANY_CLASS),
+	BCMA_CORETABLE_END
+};
+MODULE_DEVICE_TABLE(bcma, b43_bcma_tbl);
+#endif
+
 static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 6),
@@ -4986,6 +4996,26 @@ static struct b43_wl *b43_wireless_init(struct ssb_device *dev)
 	return wl;
 }
 
+#ifdef CONFIG_B43_BCMA
+static int b43_bcma_probe(struct bcma_device *core)
+{
+	b43err(NULL, "BCMA is not supported yet!");
+	return -EOPNOTSUPP;
+}
+
+static void b43_bcma_remove(struct bcma_device *core)
+{
+	/* TODO */
+}
+
+static struct bcma_driver b43_bcma_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= b43_bcma_tbl,
+	.probe		= b43_bcma_probe,
+	.remove		= b43_bcma_remove,
+};
+#endif
+
 static
 int b43_ssb_probe(struct ssb_device *sdev, const struct ssb_device_id *id)
 {
@@ -5116,13 +5146,22 @@ static int __init b43_init(void)
 	err = b43_sdio_init();
 	if (err)
 		goto err_pcmcia_exit;
-	err = ssb_driver_register(&b43_ssb_driver);
+#ifdef CONFIG_B43_BCMA
+	err = bcma_driver_register(&b43_bcma_driver);
 	if (err)
 		goto err_sdio_exit;
+#endif
+	err = ssb_driver_register(&b43_ssb_driver);
+	if (err)
+		goto err_bcma_driver_exit;
 	b43_print_driverinfo();
 
 	return err;
 
+err_bcma_driver_exit:
+#ifdef CONFIG_B43_BCMA
+	bcma_driver_unregister(&b43_bcma_driver);
+#endif
 err_sdio_exit:
 	b43_sdio_exit();
 err_pcmcia_exit:
@@ -5135,6 +5174,9 @@ err_dfs_exit:
 static void __exit b43_exit(void)
 {
 	ssb_driver_unregister(&b43_ssb_driver);
+#ifdef CONFIG_B43_BCMA
+	bcma_driver_unregister(&b43_bcma_driver);
+#endif
 	b43_sdio_exit();
 	b43_pcmcia_exit();
 	b43_debugfs_exit();
-- 
1.7.3.4

