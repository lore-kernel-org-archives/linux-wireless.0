Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38248 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbZCEUaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 15:30:14 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] p54: unify ieee80211 device registration
Date: Thu, 5 Mar 2009 21:30:10 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903052130.11112.chunkeey@web.de> (sfid-20090305_213023_189097_08794807)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All three drivers (p54pci, p54usb and p54spi) are implementing the
same functionality three times. So, why not put it into the shared library?!

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-03-05 14:49:27.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-03-05 15:10:35.000000000 +0100
@@ -2481,6 +2481,21 @@ struct ieee80211_hw *p54_init_common(siz
 }
 EXPORT_SYMBOL_GPL(p54_init_common);
 
+int p54_register_common(struct ieee80211_hw *dev, struct device *pdev)
+{
+	int err;
+
+	err = ieee80211_register_hw(dev);
+	if (err) {
+		dev_err(pdev, "Cannot register device (%d).\n", err);
+		return err;
+	}
+
+	dev_info(pdev, "is registered as '%s'\n", wiphy_name(dev->wiphy));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(p54_register_common);
+
 void p54_free_common(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2009-03-05 14:49:27.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2009-03-05 15:08:21.000000000 +0100
@@ -165,6 +165,7 @@ int p54_parse_firmware(struct ieee80211_
 int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len);
 int p54_read_eeprom(struct ieee80211_hw *dev);
 struct ieee80211_hw *p54_init_common(size_t priv_data_len);
+int p54_register_common(struct ieee80211_hw *dev, struct device *pdev);
 void p54_free_common(struct ieee80211_hw *dev);
 
 #endif /* P54_H */
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2009-03-05 14:49:27.000000000 +0100
+++ b/drivers/net/wireless/p54/p54pci.c	2009-03-05 15:07:16.000000000 +0100
@@ -565,12 +565,9 @@ static int __devinit p54p_probe(struct p
 	if (err)
 		goto err_free_common;
 
-	err = ieee80211_register_hw(dev);
-	if (err) {
-		printk(KERN_ERR "%s (p54pci): Cannot register netdevice\n",
-		       pci_name(pdev));
+	err = p54_register_common(dev, &pdev->dev);
+	if (err)
 		goto err_free_common;
-	}
 
 	return 0;
 
diff -Nurp a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
--- a/drivers/net/wireless/p54/p54spi.c	2009-03-05 14:49:27.000000000 +0100
+++ b/drivers/net/wireless/p54/p54spi.c	2009-03-05 15:08:06.000000000 +0100
@@ -694,15 +694,10 @@ static int __devinit p54spi_probe(struct
 	if (ret)
 		goto err_free_common;
 
-	ret = ieee80211_register_hw(hw);
-	if (ret) {
-		dev_err(&priv->spi->dev, "unable to register "
-					 "mac80211 hw: %d", ret);
+	ret = p54_register_common(hw, &priv->spi->dev);
+	if (ret)
 		goto err_free_common;
-	}
 
-	dev_info(&priv->spi->dev, "device is bound to %s\n",
-		 wiphy_name(hw->wiphy));
 	return 0;
 
 err_free_common:
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2009-03-05 14:49:43.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.c	2009-03-05 15:07:41.000000000 +0100
@@ -976,11 +976,9 @@ static int __devinit p54u_probe(struct u
 	if (err)
 		goto err_free_dev;
 
-	err = ieee80211_register_hw(dev);
-	if (err) {
-		dev_err(&udev->dev, "(p54usb) Cannot register netdevice\n");
+	err = p54_register_common(dev, &udev->dev);
+	if (err)
 		goto err_free_dev;
-	}
 
 	return 0;
 
