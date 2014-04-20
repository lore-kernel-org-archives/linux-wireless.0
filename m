Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:43239 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbaDTSbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 14:31:17 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so3110572eek.8
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 11:31:16 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [wireless-next][PATCH 1/2] b43: ssb: refuse to support more than IEEE 802.11 core
Date: Sun, 20 Apr 2014 20:30:58 +0200
Message-Id: <1398018659-17263-1-git-send-email-zajec5@gmail.com> (sfid-20140420_203121_344063_FB9DE27A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some ancient Broadcom devices had one core per band, e.g.:
ssb: Found chip with id 0x4306, rev 0x02 and package 0x00
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x02, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x04, vendor 0x4243)
ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x01, vendor 0x4243)
ssb: Core 3 found: V90 (cc 0x807, rev 0x01, vendor 0x4243)
ssb: Core 4 found: PCI (cc 0x804, rev 0x07, vendor 0x4243)
ssb: Core 5 found: IEEE 802.11 (cc 0x812, rev 0x04, vendor 0x4243)

This hardware model was dropped for newer devices handled by b43.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
With this patchset I'm still able to use my BCM4321, so I guess it's
alright & safe :)
---
 drivers/net/wireless/b43/main.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 69fc3d6..cf84cf2 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5486,39 +5486,42 @@ int b43_ssb_probe(struct ssb_device *sdev, const struct ssb_device_id *id)
 	struct b43_bus_dev *dev;
 	struct b43_wl *wl;
 	int err;
-	int first = 0;
 
 	dev = b43_bus_dev_ssb_init(sdev);
 	if (!dev)
 		return -ENOMEM;
 
 	wl = ssb_get_devtypedata(sdev);
-	if (!wl) {
-		/* Probing the first core. Must setup common struct b43_wl */
-		first = 1;
-		b43_sprom_fixup(sdev->bus);
-		wl = b43_wireless_init(dev);
-		if (IS_ERR(wl)) {
-			err = PTR_ERR(wl);
-			goto out;
-		}
-		ssb_set_devtypedata(sdev, wl);
-		B43_WARN_ON(ssb_get_devtypedata(sdev) != wl);
+	if (wl) {
+		b43err(NULL, "Dual-core devices are not supported\n");
+		err = -ENOTSUPP;
+		goto err_ssb_kfree_dev;
 	}
+
+	b43_sprom_fixup(sdev->bus);
+
+	wl = b43_wireless_init(dev);
+	if (IS_ERR(wl)) {
+		err = PTR_ERR(wl);
+		goto err_ssb_kfree_dev;
+	}
+	ssb_set_devtypedata(sdev, wl);
+	B43_WARN_ON(ssb_get_devtypedata(sdev) != wl);
+
 	err = b43_one_core_attach(dev, wl);
 	if (err)
-		goto err_wireless_exit;
+		goto err_ssb_wireless_exit;
 
 	/* setup and start work to load firmware */
 	INIT_WORK(&wl->firmware_load, b43_request_firmware);
 	schedule_work(&wl->firmware_load);
 
-      out:
 	return err;
 
-      err_wireless_exit:
-	if (first)
-		b43_wireless_exit(dev, wl);
+err_ssb_wireless_exit:
+	b43_wireless_exit(dev, wl);
+err_ssb_kfree_dev:
+	kfree(dev);
 	return err;
 }
 
-- 
1.8.4.5

