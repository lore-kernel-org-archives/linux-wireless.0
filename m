Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbbIYItl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2015 04:49:41 -0400
Date: Fri, 25 Sep 2015 10:49:36 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] NFC: pn544: Auto-select core module
Message-ID: <20150925104936.3b526b68@endymion.delvare> (sfid-20150925_104947_179541_CDC8B9A5)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As I understand it, the core nfc_pn544 module is useless without
either the I2C or the MEI access module. So hide NFC_PN544 and
select it automatically if either NFC_PN544_I2C or NFC_PN544_MEI is
selected.

This avoids presenting NFC_PN544 when neither NFC_PN544_I2C nor
NFC_PN544_MEI can be selected.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
Already sent on 2014-04-19.

Note that the s3fwrn5 NFC driver is already implemented the same way.

 drivers/nfc/pn544/Kconfig |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- linux-3.15-rc1.orig/drivers/nfc/pn544/Kconfig	2014-04-18 19:18:55.998723014 +0200
+++ linux-3.15-rc1/drivers/nfc/pn544/Kconfig	2014-04-18 19:19:16.195149146 +0200
@@ -1,20 +1,15 @@
 config NFC_PN544
-	tristate "NXP PN544 NFC driver"
-	depends on NFC_HCI
+	tristate
 	select CRC_CCITT
-	default n
 	---help---
 	  NXP PN544 core driver.
 	  This is a driver based on the HCI NFC kernel layers and
 	  will thus not work with NXP libnfc library.
 
-	  To compile this driver as a module, choose m here. The module will
-	  be called pn544.
-	  Say N if unsure.
-
 config NFC_PN544_I2C
-	tristate "NFC PN544 i2c support"
-	depends on NFC_PN544 && I2C && NFC_SHDLC
+	tristate "NXP PN544 device support (I2C)"
+	depends on NFC_HCI && I2C && NFC_SHDLC
+	select NFC_PN544
 	---help---
 	  This module adds support for the NXP pn544 i2c interface.
 	  Select this if your platform is using the i2c bus.
@@ -23,8 +18,9 @@ config NFC_PN544_I2C
 	  Say N if unsure.
 
 config NFC_PN544_MEI
-	tristate "NFC PN544 MEI support"
-	depends on NFC_PN544 && NFC_MEI_PHY
+	tristate "NXP PN544 device support (MEI)"
+	depends on NFC_HCI && NFC_MEI_PHY
+	select NFC_PN544
 	---help---
 	  This module adds support for the mei interface of adapters using
 	  NXP pn544 chipsets.  Select this if your pn544 chipset


-- 
Jean Delvare
SUSE L3 Support
