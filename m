Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728140AbeIFNzQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:55:16 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 41/42] mt76x0: remove some usb specific code from mt76x0_register_device
Date: Thu,  6 Sep 2018 11:18:57 +0200
Message-Id: <1536225538-16454-42-git-send-email-sgruszka@redhat.com> (sfid-20180906_112052_121152_EFFF29CB)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initial effort to make mt76x0_register_device bus neutral.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c |  8 --------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c  | 12 ++++++++++--
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 0e4a13fa42cb..4a899904d518 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -518,14 +518,6 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	struct wiphy *wiphy = hw->wiphy;
 	int ret;
 
-	ret = mt76u_mcu_init_rx(mdev);
-	if (ret < 0)
-		return ret;
-
-	ret = mt76u_alloc_queues(mdev);
-	if (ret < 0)
-		return ret;
-
 	ret = mt76x0_init_hardware(dev);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index b9382092f47f..9a803fb0cd5d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -46,7 +46,7 @@ static struct usb_device_id mt76x0_device_table[] = {
 	{ 0, }
 };
 
-static int mt76x0_probe(struct usb_interface *usb_intf,
+static int mt76x0u_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
 	struct usb_device *usb_dev = interface_to_usbdev(usb_intf);
@@ -84,6 +84,14 @@ static int mt76x0_probe(struct usb_interface *usb_intf,
 	if (!(mt76_rr(dev, MT_EFUSE_CTRL) & MT_EFUSE_CTRL_SEL))
 		dev_warn(dev->mt76.dev, "Warning: eFUSE not present\n");
 
+	ret = mt76u_mcu_init_rx(&dev->mt76);
+	if (ret < 0)
+		goto err;
+
+	ret = mt76u_alloc_queues(&dev->mt76);
+	if (ret < 0)
+		goto err;
+
 	ret = mt76x0_register_device(dev);
 	if (ret)
 		goto err_hw;
@@ -170,7 +178,7 @@ MODULE_LICENSE("GPL");
 static struct usb_driver mt76x0_driver = {
 	.name		= KBUILD_MODNAME,
 	.id_table	= mt76x0_device_table,
-	.probe		= mt76x0_probe,
+	.probe		= mt76x0u_probe,
 	.disconnect	= mt76x0_disconnect,
 	.suspend	= mt76x0_suspend,
 	.resume		= mt76x0_resume,
-- 
2.7.5
