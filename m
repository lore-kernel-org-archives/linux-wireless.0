Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9362 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbbGJGZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 02:25:54 -0400
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?=
	<clement.perrochaud@effinnov.com>,
	Charles Gorand <charles.gorand@effinnov.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] nfc: Drop owner assignment from i2c_driver
Date: Fri, 10 Jul 2015 15:25:50 +0900
Message-id: <1436509550-21453-1-git-send-email-k.kozlowski@samsung.com> (sfid-20150710_082615_892345_1EABEE99)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i2c_driver does not need to set an owner because i2c_register_driver()
will set it.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

The coccinelle script which generated the patch was sent here:
http://www.spinics.net/lists/kernel/msg2029903.html
---
 drivers/nfc/nxp-nci/i2c.c  | 1 -
 drivers/nfc/pn544/i2c.c    | 1 -
 drivers/nfc/st-nci/i2c.c   | 1 -
 drivers/nfc/st21nfca/i2c.c | 1 -
 4 files changed, 4 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 2f77f1d03638..6c5e63cd0022 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -450,7 +450,6 @@ MODULE_DEVICE_TABLE(acpi, acpi_id);
 static struct i2c_driver nxp_nci_i2c_driver = {
 	.driver = {
 		   .name = NXP_NCI_I2C_DRIVER_NAME,
-		   .owner  = THIS_MODULE,
 		   .acpi_match_table = ACPI_PTR(acpi_id),
 		   .of_match_table = of_match_ptr(of_nxp_nci_i2c_match),
 		  },
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index fa75c53f3fa5..a095523309cf 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -1162,7 +1162,6 @@ MODULE_DEVICE_TABLE(of, of_pn544_i2c_match);
 static struct i2c_driver pn544_hci_i2c_driver = {
 	.driver = {
 		   .name = PN544_HCI_I2C_DRIVER_NAME,
-		   .owner  = THIS_MODULE,
 		   .of_match_table = of_match_ptr(of_pn544_i2c_match),
 		   .acpi_match_table = ACPI_PTR(pn544_hci_i2c_acpi_match),
 		  },
diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 06175ce769bb..c21c45c656c0 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -370,7 +370,6 @@ MODULE_DEVICE_TABLE(of, of_st_nci_i2c_match);
 
 static struct i2c_driver st_nci_i2c_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = ST_NCI_I2C_DRIVER_NAME,
 		.of_match_table = of_match_ptr(of_st_nci_i2c_match),
 	},
diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index a32143951616..6f987fa36371 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -680,7 +680,6 @@ MODULE_DEVICE_TABLE(of, of_st21nfca_i2c_match);
 
 static struct i2c_driver st21nfca_hci_i2c_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = ST21NFCA_HCI_I2C_DRIVER_NAME,
 		.of_match_table = of_match_ptr(of_st21nfca_i2c_match),
 	},
-- 
1.9.1

