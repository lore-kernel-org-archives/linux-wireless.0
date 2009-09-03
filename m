Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48027 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809AbZICACR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 20:02:17 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 17:02:20 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: propagate errors on ath_init_device() and request_irq()
Date: Wed, 2 Sep 2009 17:02:18 -0700
Message-ID: <1251936138-16631-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've cleaned up ath_init_device() and its children enough
to pass meaninful errors back from probe. When this fails
it means our device could not be initialized and a meaninful
error will have been passed.

Do the same for request_irq() and also synchronize the error
messages while at it.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c |    8 +++-----
 drivers/net/wireless/ath/ath9k/pci.c |   12 ++++++------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 5618fc2..7dc6301 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -120,16 +120,14 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	sc->irq = irq;
 
 	ret = ath_init_device(AR5416_AR9100_DEVID, sc);
-	if (ret != 0) {
-		dev_err(&pdev->dev, "failed to attach device, err=%d\n", ret);
-		ret = -ENODEV;
+	if (ret) {
+		dev_err(&pdev->dev, "failed to initialize device\n");
 		goto err_free_hw;
 	}
 
 	ret = request_irq(irq, ath_isr, IRQF_SHARED, "ath9k", sc);
 	if (ret) {
-		dev_err(&pdev->dev, "request_irq failed, err=%d\n", ret);
-		ret = -EIO;
+		dev_err(&pdev->dev, "request_irq failed\n");
 		goto err_detach;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 17862cc..bc4bc2c 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -179,17 +179,17 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->mem = mem;
 	sc->bus_ops = &ath_pci_bus_ops;
 
-	if (ath_init_device(id->device, sc) != 0) {
-		ret = -ENODEV;
+	ret = ath_init_device(id->device, sc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to initialize device\n");
 		goto bad3;
 	}
 
 	/* setup interrupt service routine */
 
-	if (request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath", sc)) {
-		printk(KERN_ERR "%s: request_irq failed\n",
-			wiphy_name(hw->wiphy));
-		ret = -EIO;
+	ret = request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath", sc);
+	if (ret) {
+		dev_err(&pdev->dev, "request_irq failed\n");
 		goto bad4;
 	}
 
-- 
1.6.3.3

