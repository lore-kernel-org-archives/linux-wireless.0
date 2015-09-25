Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768AbbIYIw3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2015 04:52:29 -0400
Date: Fri, 25 Sep 2015 10:52:26 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 2/3] NFC: microread: Auto-select core module
Message-ID: <20150925105226.6608f5ab@endymion.delvare> (sfid-20150925_105238_432926_D592079E)
In-Reply-To: <20150925104936.3b526b68@endymion.delvare>
References: <20150925104936.3b526b68@endymion.delvare>
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
Already sent on 2014-04-19. Changes since v1: typo fixed.

Note that the s3fwrn5 NFC driver is already implemented the same way.

 drivers/nfc/microread/Kconfig |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- linux-4.3-rc2.orig/drivers/nfc/microread/Kconfig	2015-09-24 11:44:28.178747561 +0200
+++ linux-4.3-rc2/drivers/nfc/microread/Kconfig	2015-09-25 10:43:21.202108737 +0200
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
+	tristate "Inside Secure Microread device support (I2C)"
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
