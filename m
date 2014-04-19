Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaDSKMi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2014 06:12:38 -0400
Date: Sat, 19 Apr 2014 12:12:36 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] NFC: microread: Auto-select core module
Message-ID: <20140419121236.3f28be34@endymion.delvare> (sfid-20140419_121300_796141_56CA04AA)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As I understand it, the core nfc_microread module is useless without
either the I2C or the MEI access module. So hide NFC_MICROREAD and
select it automatically if either NFC_MICROREAD_I2C or
NFC_MICROREAD_MEI is selected.

This avoids presenting NFC_MICROREAD when neither NFC_MICROREAD_I2C
nor NFC_MICROREAD_MEI can be selected.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/microread/Kconfig |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- linux-3.15-rc1.orig/drivers/nfc/microread/Kconfig	2014-03-31 05:40:15.000000000 +0200
+++ linux-3.15-rc1/drivers/nfc/microread/Kconfig	2014-04-18 18:50:54.969927674 +0200
@@ -1,20 +1,15 @@
 config NFC_MICROREAD
-	tristate "Inside Secure microread NFC driver"
-	depends on NFC_HCI
+	tristate
 	select CRC_CCITT
-	default n
 	---help---
 	  This module contains the main code for Inside Secure microread
 	  NFC chipsets. It implements the chipset HCI logic and hooks into
 	  the NFC kernel APIs. Physical layers will register against it.
 
-	  To compile this driver as a module, choose m here. The module will
-	  be called microread.
-	  Say N if unsure.
-
 config NFC_MICROREAD_I2C
-	tristate "NFC Microread i2c support"
-	depends on NFC_MICROREAD && I2C && NFC_SHDLC
+	tristate "Inside Seccure Microread device support (I2C)"
+	depends on NFC_HCI && I2C && NFC_SHDLC
+	select NFC_MICROREAD
 	---help---
 	  This module adds support for the i2c interface of adapters using
 	  Inside microread chipsets.  Select this if your platform is using
@@ -24,8 +19,9 @@ config NFC_MICROREAD_I2C
 	  Say N if unsure.
 
 config NFC_MICROREAD_MEI
-	tristate "NFC Microread MEI support"
-	depends on NFC_MICROREAD && NFC_MEI_PHY
+	tristate "Inside Secure Microread device support (MEI)"
+	depends on NFC_HCI && NFC_MEI_PHY
+	select NFC_MICROREAD
 	---help---
 	  This module adds support for the mei interface of adapters using
 	  Inside microread chipsets.  Select this if your microread chipset


-- 
Jean Delvare
SUSE L3 Support
