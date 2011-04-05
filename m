Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55086 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab1DET35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 15:29:57 -0400
Received: by eyx24 with SMTP id 24so225525eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 12:29:56 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>,
	Arend van Spriel <arend@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [TESTING ONLY][PATCH] b43: subscribe to bcmai
Date: Tue,  5 Apr 2011 22:07:08 +0200
Message-Id: <1302034028-1947-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/b43/b43.h  |    1 +
 drivers/net/wireless/b43/main.c |   43 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index bd4cb75..283ee1d 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -6,6 +6,7 @@
 #include <linux/interrupt.h>
 #include <linux/hw_random.h>
 #include <linux/ssb/ssb.h>
+#include <linux/bcmai/bcmai.h>
 #include <net/mac80211.h>
 
 #include "debugfs.h"
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 57eb5b6..b35c49b 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -125,9 +125,15 @@ static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 16),
 	SSB_DEVTABLE_END
 };
-
 MODULE_DEVICE_TABLE(ssb, b43_ssb_tbl);
 
+static const struct bcmai_device_id b43_bcmai_tbl[] = {
+	BCMAI_CORE(BCMAI_MANUF_BCM, SSB_DEV_80211, 0x17),
+	BCMAI_CORE(BCMAI_MANUF_BCM, SSB_DEV_80211, 0x18),
+	BCMAI_CORETABLE_END
+};
+MODULE_DEVICE_TABLE(bcmai, b43_bcmai_tbl);
+
 /* Channel and ratetables are shared for all devices.
  * They can't be const, because ieee80211 puts some precalculated
  * data in there. This data is the same for all devices, so we don't
@@ -5069,6 +5075,28 @@ static void b43_remove(struct ssb_device *dev)
 	}
 }
 
+static int b43_bcmai_probe(struct bcmai_device *core)
+{
+	printk(KERN_INFO "Success! Hello world! :)\n");
+
+	bcmai_core_enable(core, 0x4);
+
+	u16 tmp = bcmai_read16(core, B43_MMIO_PHY_VER);
+	u16 analog_type = (tmp & B43_PHYVER_ANALOG) >> B43_PHYVER_ANALOG_SHIFT;
+	u16 phy_type = (tmp & B43_PHYVER_TYPE) >> B43_PHYVER_TYPE_SHIFT;
+	u16 phy_rev = (tmp & B43_PHYVER_VERSION);
+
+	bcmai_info("PHY (Analog %u, Type %u, Revision %u)\n",
+		analog_type, phy_type, phy_rev);
+
+	return 0;
+}
+
+static void b43_bcmai_remove(struct bcmai_device *core)
+{
+	printk(KERN_INFO "Success! Bye :)\n");
+}
+
 /* Perform a hardware reset. This can be called from any context. */
 void b43_controller_restart(struct b43_wldev *dev, const char *reason)
 {
@@ -5086,6 +5114,13 @@ static struct ssb_driver b43_ssb_driver = {
 	.remove		= b43_remove,
 };
 
+static struct bcmai_driver b43_bcmai_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= b43_bcmai_tbl,
+	.probe		= b43_bcmai_probe,
+	.remove		= b43_bcmai_remove,
+};
+
 static void b43_print_driverinfo(void)
 {
 	const char *feat_pci = "", *feat_pcmcia = "", *feat_nphy = "",
@@ -5127,6 +5162,9 @@ static int __init b43_init(void)
 	err = ssb_driver_register(&b43_ssb_driver);
 	if (err)
 		goto err_sdio_exit;
+	err = bcmai_driver_register(&b43_bcmai_driver);
+	if (err)
+		goto err_ssb_driver_exit;
 	b43_print_driverinfo();
 
 	return err;
@@ -5137,11 +5175,14 @@ err_pcmcia_exit:
 	b43_pcmcia_exit();
 err_dfs_exit:
 	b43_debugfs_exit();
+err_ssb_driver_exit:
+	ssb_driver_unregister(&b43_ssb_driver);
 	return err;
 }
 
 static void __exit b43_exit(void)
 {
+	bcmai_driver_unregister(&b43_bcmai_driver);
 	ssb_driver_unregister(&b43_ssb_driver);
 	b43_sdio_exit();
 	b43_pcmcia_exit();
-- 
1.7.3.4

