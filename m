Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55969 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1DHTMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 15:12:41 -0400
Received: by eyx24 with SMTP id 24so1197674eyx.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 12:12:40 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [TESTING ONLY][PATCH] b43: subscribe to axi
Date: Fri,  8 Apr 2011 21:49:57 +0200
Message-Id: <1302292197-2191-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/b43/b43.h  |    1 +
 drivers/net/wireless/b43/main.c |   72 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 72 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index bd4cb75..991a08d 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -6,6 +6,7 @@
 #include <linux/interrupt.h>
 #include <linux/hw_random.h>
 #include <linux/ssb/ssb.h>
+#include <linux/axi/axi.h>
 #include <net/mac80211.h>
 
 #include "debugfs.h"
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 57eb5b6..102bf5f 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -125,9 +125,15 @@ static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 16),
 	SSB_DEVTABLE_END
 };
-
 MODULE_DEVICE_TABLE(ssb, b43_ssb_tbl);
 
+static const struct axi_device_id b43_axi_tbl[] = {
+	AXI_CORE(AXI_MANUF_BCM, AXI_CORE_80211, 0x17, AXI_ANY_CLASS),
+	AXI_CORE(AXI_MANUF_BCM, AXI_CORE_80211, 0x18, AXI_ANY_CLASS),
+	AXI_CORETABLE_END
+};
+MODULE_DEVICE_TABLE(axi, b43_axi_tbl);
+
 /* Channel and ratetables are shared for all devices.
  * They can't be const, because ieee80211 puts some precalculated
  * data in there. This data is the same for all devices, so we don't
@@ -5069,6 +5075,57 @@ static void b43_remove(struct ssb_device *dev)
 	}
 }
 
+static int b43_axi_probe(struct axi_device *core)
+{
+	printk(KERN_INFO "Success! Hello world! :)\n");
+
+	axi_core_enable(core, 0x4);
+
+	u16 tmp = axi_read16(core, B43_MMIO_PHY_VER);
+	u16 analog_type = (tmp & B43_PHYVER_ANALOG) >> B43_PHYVER_ANALOG_SHIFT;
+	u16 phy_type = (tmp & B43_PHYVER_TYPE) >> B43_PHYVER_TYPE_SHIFT;
+	u16 phy_rev = (tmp & B43_PHYVER_VERSION);
+
+	axi_info("PHY (Analog %u, Type %u, Revision %u)\n",
+		analog_type, phy_type, phy_rev);
+
+	u16 radio_manuf = 0, radio_ver = 0, radio_rev, radio_id;
+	if (core->id.rev >= 24) {
+		axi_write16(core, 0x3D8, 0);
+		u16 r0 = axi_read16(core, 0x3DA);
+
+		axi_write16(core, 0x3D8, 1);
+		u16 r1 = axi_read16(core, 0x3DA);
+
+		axi_write16(core, 0x3D8, 2);
+		u16 r2 = axi_read16(core, 0x3DA);
+
+		radio_ver = (r0 & 0xF0) >> 4;
+		radio_id = (r2 << 8) | r1;
+		radio_rev = (r0 & 0xF);
+
+
+	} else {
+		axi_write16(core, B43_MMIO_RADIO_CONTROL, B43_RADIOCTL_ID);
+		u32 tmpx = axi_read16(core, B43_MMIO_RADIO_DATA_LOW);
+		axi_write16(core, B43_MMIO_RADIO_CONTROL, B43_RADIOCTL_ID);
+		tmpx |= (u32)axi_read16(core, B43_MMIO_RADIO_DATA_HIGH) << 16;
+
+		radio_manuf = (tmpx & 0x00000FFF);
+		radio_id = (tmpx & 0x0FFFF000) >> 12;
+		radio_rev = (tmpx & 0xF0000000) >> 28;
+	}
+	axi_info("RADIO (Manuf 0x%X, Version 0x%X, Id 0x%X, Revision %u)\n",
+		 radio_manuf, radio_ver, radio_id, radio_rev);
+
+	return 0;
+}
+
+static void b43_axi_remove(struct axi_device *core)
+{
+	printk(KERN_INFO "Success! Bye :)\n");
+}
+
 /* Perform a hardware reset. This can be called from any context. */
 void b43_controller_restart(struct b43_wldev *dev, const char *reason)
 {
@@ -5086,6 +5143,13 @@ static struct ssb_driver b43_ssb_driver = {
 	.remove		= b43_remove,
 };
 
+static struct axi_driver b43_axi_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= b43_axi_tbl,
+	.probe		= b43_axi_probe,
+	.remove		= b43_axi_remove,
+};
+
 static void b43_print_driverinfo(void)
 {
 	const char *feat_pci = "", *feat_pcmcia = "", *feat_nphy = "",
@@ -5127,6 +5191,9 @@ static int __init b43_init(void)
 	err = ssb_driver_register(&b43_ssb_driver);
 	if (err)
 		goto err_sdio_exit;
+	err = axi_driver_register(&b43_axi_driver);
+	if (err)
+		goto err_ssb_driver_exit;
 	b43_print_driverinfo();
 
 	return err;
@@ -5137,11 +5204,14 @@ err_pcmcia_exit:
 	b43_pcmcia_exit();
 err_dfs_exit:
 	b43_debugfs_exit();
+err_ssb_driver_exit:
+	ssb_driver_unregister(&b43_ssb_driver);
 	return err;
 }
 
 static void __exit b43_exit(void)
 {
+	axi_driver_unregister(&b43_axi_driver);
 	ssb_driver_unregister(&b43_ssb_driver);
 	b43_sdio_exit();
 	b43_pcmcia_exit();
-- 
1.7.3.4

