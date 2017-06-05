Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62555 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751276AbdFEUUr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:20:47 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 05/12] NFC: fdp: Convert to use devres API
Date: Mon,  5 Jun 2017 23:20:02 +0300
Message-Id: <20170605202009.78561-6-andriy.shevchenko@linux.intel.com> (sfid-20170605_222051_268745_2E775682)
In-Reply-To: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
References: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like there are two leftovers, at least one of which can leak
the resource (IRQ).

Convert both places to use devm variants of functions.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/fdp/fdp.c | 15 ++++-----------
 drivers/nfc/fdp/i2c.c | 10 +++++-----
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 7c1eaea3b685..8946eb21128d 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -750,11 +750,9 @@ int fdp_nci_probe(struct fdp_i2c_phy *phy, struct nfc_phy_ops *phy_ops,
 	u32 protocols;
 	int r;
 
-	info = kzalloc(sizeof(struct fdp_nci_info), GFP_KERNEL);
-	if (!info) {
-		r = -ENOMEM;
-		goto err_info_alloc;
-	}
+	info = devm_kzalloc(dev, sizeof(struct fdp_nci_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
 
 	info->phy = phy;
 	info->phy_ops = phy_ops;
@@ -776,8 +774,7 @@ int fdp_nci_probe(struct fdp_i2c_phy *phy, struct nfc_phy_ops *phy_ops,
 				   tx_tailroom);
 	if (!ndev) {
 		nfc_err(dev, "Cannot allocate nfc ndev\n");
-		r = -ENOMEM;
-		goto err_alloc_ndev;
+		return -ENOMEM;
 	}
 
 	r = nci_register_device(ndev);
@@ -793,9 +790,6 @@ int fdp_nci_probe(struct fdp_i2c_phy *phy, struct nfc_phy_ops *phy_ops,
 
 err_regdev:
 	nci_free_device(ndev);
-err_alloc_ndev:
-	kfree(info);
-err_info_alloc:
 	return r;
 }
 EXPORT_SYMBOL(fdp_nci_probe);
@@ -809,7 +803,6 @@ void fdp_nci_remove(struct nci_dev *ndev)
 
 	nci_unregister_device(ndev);
 	nci_free_device(ndev);
-	kfree(info);
 }
 EXPORT_SYMBOL(fdp_nci_remove);
 
diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 754d8d89c580..250cbaddb5a9 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -303,8 +303,7 @@ static int fdp_nci_i2c_probe(struct i2c_client *client)
 		return -ENODEV;
 	}
 
-	phy = devm_kzalloc(dev, sizeof(struct fdp_i2c_phy),
-			   GFP_KERNEL);
+	phy = devm_kzalloc(dev, sizeof(struct fdp_i2c_phy), GFP_KERNEL);
 	if (!phy)
 		return -ENOMEM;
 
@@ -312,9 +311,10 @@ static int fdp_nci_i2c_probe(struct i2c_client *client)
 	phy->next_read_size = FDP_NCI_I2C_MIN_PAYLOAD;
 	i2c_set_clientdata(client, phy);
 
-	r = request_threaded_irq(client->irq, NULL, fdp_nci_i2c_irq_thread_fn,
-				 IRQF_TRIGGER_RISING | IRQF_ONESHOT,
-				 FDP_I2C_DRIVER_NAME, phy);
+	r = devm_request_threaded_irq(dev, client->irq,
+				      NULL, fdp_nci_i2c_irq_thread_fn,
+				      IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				      FDP_I2C_DRIVER_NAME, phy);
 
 	if (r < 0) {
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
-- 
2.11.0
