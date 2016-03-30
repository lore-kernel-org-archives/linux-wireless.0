Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57429 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbcC3Av2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 20:51:28 -0400
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?=
	<clement.perrochaud@effinnov.com>,
	Charles Gorand <charles.gorand@effinnov.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-nfc@lists.01.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND] nfc: Drop owner assignment from i2c_driver
Date: Wed, 30 Mar 2016 09:51:04 +0900
Message-id: <1459299064-20644-1-git-send-email-k.kozlowski@samsung.com> (sfid-20160330_025147_386147_EDA8FC7C)
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
index 11520f472f98..36099e557730 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -418,7 +418,6 @@ MODULE_DEVICE_TABLE(acpi, acpi_id);
 static struct i2c_driver nxp_nci_i2c_driver = {
 	.driver = {
 		   .name = NXP_NCI_I2C_DRIVER_NAME,
-		   .owner  = THIS_MODULE,
 		   .acpi_match_table = ACPI_PTR(acpi_id),
 		   .of_match_table = of_match_ptr(of_nxp_nci_i2c_match),
 		  },
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 45d0e667d7ae..f837c39a8017 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -1106,7 +1106,6 @@ MODULE_DEVICE_TABLE(of, of_pn544_i2c_match);
 static struct i2c_driver pn544_hci_i2c_driver = {
 	.driver = {
 		   .name = PN544_HCI_I2C_DRIVER_NAME,
-		   .owner  = THIS_MODULE,
 		   .of_match_table = of_match_ptr(of_pn544_i2c_match),
 		   .acpi_match_table = ACPI_PTR(pn544_hci_i2c_acpi_match),
 		  },
diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 8a56b5c6e4c4..925dbeef74db 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -416,7 +416,6 @@ MODULE_DEVICE_TABLE(of, of_st_nci_i2c_match);
 
 static struct i2c_driver st_nci_i2c_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = ST_NCI_I2C_DRIVER_NAME,
 		.of_match_table = of_match_ptr(of_st_nci_i2c_match),
 		.acpi_match_table = ACPI_PTR(st_nci_i2c_acpi_match),
diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 1f44a151d206..640b4de05793 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -721,7 +721,6 @@ MODULE_DEVICE_TABLE(of, of_st21nfca_i2c_match);
 
 static struct i2c_driver st21nfca_hci_i2c_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = ST21NFCA_HCI_I2C_DRIVER_NAME,
 		.of_match_table = of_match_ptr(of_st21nfca_i2c_match),
 		.acpi_match_table = ACPI_PTR(st21nfca_hci_i2c_acpi_match),
-- 
2.5.0

