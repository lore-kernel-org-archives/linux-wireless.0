Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56005 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1FNFkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 01:40:51 -0400
Received: by fxm17 with SMTP id 17so3266761fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 22:40:50 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: add Kconfig option for compiling SSB driver
Date: Tue, 14 Jun 2011 08:18:59 +0200
Message-Id: <1308032339-2844-1-git-send-email-zajec5@gmail.com> (sfid-20110614_074054_832625_EC5F145D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is always "y" for now, b43 will not compile without CONFIG_SSB yet.
This is just a first step of dropping SSB dependency.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Kconfig |    5 +++++
 drivers/net/wireless/b43/bus.c   |    3 ++-
 drivers/net/wireless/b43/main.c  |   25 +++++++++++++++++--------
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index e02db1b..f302eb0 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -31,6 +31,11 @@ config B43_BCMA
 	depends on B43 && BCMA && BROKEN
 	default y
 
+config B43_SSB
+	bool
+	depends on B43 && SSB
+	default y
+
 # Auto-select SSB PCI-HOST support, if possible
 config B43_PCI_AUTOSELECT
 	bool
diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 6c63aec..1511789 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -25,7 +25,7 @@
 
 
 /* SSB */
-
+#ifdef CONFIG_B43_SSB
 static inline int b43_bus_ssb_bus_may_powerdown(struct b43_bus_dev *dev)
 {
 	return ssb_bus_may_powerdown(dev->sdev->bus);
@@ -120,3 +120,4 @@ struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 
 	return dev;
 }
+#endif /* CONFIG_B43_SSB */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index ea9e737..891083b 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -123,6 +123,7 @@ static const struct bcma_device_id b43_bcma_tbl[] = {
 MODULE_DEVICE_TABLE(bcma, b43_bcma_tbl);
 #endif
 
+#ifdef CONFIG_B43_SSB
 static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 6),
@@ -136,8 +137,8 @@ static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 16),
 	SSB_DEVTABLE_END
 };
-
 MODULE_DEVICE_TABLE(ssb, b43_ssb_tbl);
+#endif
 
 /* Channel and ratetables are shared for all devices.
  * They can't be const, because ieee80211 puts some precalculated
@@ -5031,6 +5032,7 @@ static struct bcma_driver b43_bcma_driver = {
 };
 #endif
 
+#ifdef CONFIG_B43_SSB
 static
 int b43_ssb_probe(struct ssb_device *sdev, const struct ssb_device_id *id)
 {
@@ -5106,6 +5108,14 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 	}
 }
 
+static struct ssb_driver b43_ssb_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= b43_ssb_tbl,
+	.probe		= b43_ssb_probe,
+	.remove		= b43_ssb_remove,
+};
+#endif /* CONFIG_B43_SSB */
+
 /* Perform a hardware reset. This can be called from any context. */
 void b43_controller_restart(struct b43_wldev *dev, const char *reason)
 {
@@ -5116,13 +5126,6 @@ void b43_controller_restart(struct b43_wldev *dev, const char *reason)
 	ieee80211_queue_work(dev->wl->hw, &dev->restart_work);
 }
 
-static struct ssb_driver b43_ssb_driver = {
-	.name		= KBUILD_MODNAME,
-	.id_table	= b43_ssb_tbl,
-	.probe		= b43_ssb_probe,
-	.remove		= b43_ssb_remove,
-};
-
 static void b43_print_driverinfo(void)
 {
 	const char *feat_pci = "", *feat_pcmcia = "", *feat_nphy = "",
@@ -5166,14 +5169,18 @@ static int __init b43_init(void)
 	if (err)
 		goto err_sdio_exit;
 #endif
+#ifdef CONFIG_B43_SSB
 	err = ssb_driver_register(&b43_ssb_driver);
 	if (err)
 		goto err_bcma_driver_exit;
+#endif
 	b43_print_driverinfo();
 
 	return err;
 
+#ifdef CONFIG_B43_SSB
 err_bcma_driver_exit:
+#endif
 #ifdef CONFIG_B43_BCMA
 	bcma_driver_unregister(&b43_bcma_driver);
 err_sdio_exit:
@@ -5188,7 +5195,9 @@ err_dfs_exit:
 
 static void __exit b43_exit(void)
 {
+#ifdef CONFIG_B43_SSB
 	ssb_driver_unregister(&b43_ssb_driver);
+#endif
 #ifdef CONFIG_B43_BCMA
 	bcma_driver_unregister(&b43_bcma_driver);
 #endif
-- 
1.7.3.4

