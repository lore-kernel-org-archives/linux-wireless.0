Return-Path: <SRS0=GdFy=TN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594BEC04AA7
	for <linux-wireless@archiver.kernel.org>; Mon, 13 May 2019 10:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 367B8208C2
	for <linux-wireless@archiver.kernel.org>; Mon, 13 May 2019 10:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbfEMKoK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 May 2019 06:44:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:27307 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729128AbfEMKoG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 May 2019 06:44:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 03:44:05 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 13 May 2019 03:44:03 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 9E6E9455; Mon, 13 May 2019 13:43:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 05/12] NFC: nxp-nci: Get rid of code duplication in ->probe()
Date:   Mon, 13 May 2019 13:43:51 +0300
Message-Id: <20190513104358.59716-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190513104358.59716-1-andriy.shevchenko@linux.intel.com>
References: <20190513104358.59716-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since OF and ACPI case almost the same get rid of code duplication
by moving gpiod_get() calls directly to ->probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/nxp-nci/i2c.c | 68 +++++++++------------------------------
 1 file changed, 15 insertions(+), 53 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 9a65dd6cd405..9eeb59d1199a 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -267,48 +267,10 @@ static const struct acpi_gpio_mapping acpi_nxp_nci_gpios[] = {
 	{ }
 };
 
-static int nxp_nci_i2c_parse_devtree(struct i2c_client *client)
-{
-	struct nxp_nci_i2c_phy *phy = i2c_get_clientdata(client);
-
-	phy->gpiod_en = devm_gpiod_get(&client->dev, "enable", GPIOD_OUT_LOW);
-	if (IS_ERR(phy->gpiod_en)) {
-		nfc_err(&client->dev, "Failed to get EN gpio\n");
-		return PTR_ERR(phy->gpiod_en);
-	}
-
-	phy->gpiod_fw = devm_gpiod_get(&client->dev, "firmware", GPIOD_OUT_LOW);
-	if (IS_ERR(phy->gpiod_fw)) {
-		nfc_err(&client->dev, "Failed to get FW gpio\n");
-		return PTR_ERR(phy->gpiod_fw);
-	}
-
-	return 0;
-}
-
-static int nxp_nci_i2c_acpi_config(struct nxp_nci_i2c_phy *phy)
-{
-	struct i2c_client *client = phy->i2c_dev;
-	int r;
-
-	r = devm_acpi_dev_add_driver_gpios(&client->dev, acpi_nxp_nci_gpios);
-	if (r)
-		return r;
-
-	phy->gpiod_en = devm_gpiod_get(&client->dev, "enable", GPIOD_OUT_LOW);
-	phy->gpiod_fw = devm_gpiod_get(&client->dev, "firmware", GPIOD_OUT_LOW);
-
-	if (IS_ERR(phy->gpiod_en) || IS_ERR(phy->gpiod_fw)) {
-		nfc_err(&client->dev, "No GPIOs\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int nxp_nci_i2c_probe(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
+	struct device *dev = &client->dev;
 	struct nxp_nci_i2c_phy *phy;
 	int r;
 
@@ -328,20 +290,20 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 	phy->i2c_dev = client;
 	i2c_set_clientdata(client, phy);
 
-	if (client->dev.of_node) {
-		r = nxp_nci_i2c_parse_devtree(client);
-		if (r < 0) {
-			nfc_err(&client->dev, "Failed to get DT data\n");
-			goto probe_exit;
-		}
-	} else if (ACPI_HANDLE(&client->dev)) {
-		r = nxp_nci_i2c_acpi_config(phy);
-		if (r < 0)
-			goto probe_exit;
-	} else {
-		nfc_err(&client->dev, "No platform data\n");
-		r = -EINVAL;
-		goto probe_exit;
+	r = devm_acpi_dev_add_driver_gpios(dev, acpi_nxp_nci_gpios);
+	if (r)
+		return r;
+
+	phy->gpiod_en = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_en)) {
+		nfc_err(dev, "Failed to get EN gpio\n");
+		return PTR_ERR(phy->gpiod_en);
+	}
+
+	phy->gpiod_fw = devm_gpiod_get(dev, "firmware", GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_fw)) {
+		nfc_err(dev, "Failed to get FW gpio\n");
+		return PTR_ERR(phy->gpiod_fw);
 	}
 
 	r = nxp_nci_probe(phy, &client->dev, &i2c_phy_ops,
-- 
2.20.1

