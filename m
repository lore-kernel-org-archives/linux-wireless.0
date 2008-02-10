Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:10956 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbYBJVsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:48:33 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1187667nfb.21
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:48:32 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 02/14] rt2x00: Make rt2x00 less verbose
Date: Sun, 10 Feb 2008 22:47:17 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102247.17863.IvDoorn@gmail.com> (sfid-20080210_214837_805761_47667692)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the debug messages regarding initialization from
EEPROM. The values are vendor specific, and are not really
needed for debug purposes. If they ever become usefull we
still have access to them through debugfs which also
prints the exact same values...

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    4 ----
 drivers/net/wireless/rt2x00/rt2500pci.c |    4 ----
 drivers/net/wireless/rt2x00/rt2500usb.c |    4 ----
 drivers/net/wireless/rt2x00/rt61pci.c   |    4 ----
 drivers/net/wireless/rt2x00/rt73usb.c   |    4 ----
 5 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 693f3d3..330b162 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -797,19 +797,15 @@ continue_csr_init:
 	rt2400pci_bbp_write(rt2x00dev, 30, 0x21);
 	rt2400pci_bbp_write(rt2x00dev, 31, 0x00);
 
-	DEBUG(rt2x00dev, "Start initialization from EEPROM...\n");
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
 
 		if (eeprom != 0xffff && eeprom != 0x0000) {
 			reg_id = rt2x00_get_field16(eeprom, EEPROM_BBP_REG_ID);
 			value = rt2x00_get_field16(eeprom, EEPROM_BBP_VALUE);
-			DEBUG(rt2x00dev, "BBP: 0x%02x, value: 0x%02x.\n",
-			      reg_id, value);
 			rt2400pci_bbp_write(rt2x00dev, reg_id, value);
 		}
 	}
-	DEBUG(rt2x00dev, "...End initialization from EEPROM.\n");
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 7ad8967..a590416 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -951,19 +951,15 @@ continue_csr_init:
 	rt2500pci_bbp_write(rt2x00dev, 61, 0x6d);
 	rt2500pci_bbp_write(rt2x00dev, 62, 0x10);
 
-	DEBUG(rt2x00dev, "Start initialization from EEPROM...\n");
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
 
 		if (eeprom != 0xffff && eeprom != 0x0000) {
 			reg_id = rt2x00_get_field16(eeprom, EEPROM_BBP_REG_ID);
 			value = rt2x00_get_field16(eeprom, EEPROM_BBP_VALUE);
-			DEBUG(rt2x00dev, "BBP: 0x%02x, value: 0x%02x.\n",
-			      reg_id, value);
 			rt2500pci_bbp_write(rt2x00dev, reg_id, value);
 		}
 	}
-	DEBUG(rt2x00dev, "...End initialization from EEPROM.\n");
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index eb98d28..1ae9e3c 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -881,19 +881,15 @@ continue_csr_init:
 	rt2500usb_bbp_write(rt2x00dev, 62, 0x10);
 	rt2500usb_bbp_write(rt2x00dev, 75, 0xff);
 
-	DEBUG(rt2x00dev, "Start initialization from EEPROM...\n");
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
 
 		if (eeprom != 0xffff && eeprom != 0x0000) {
 			reg_id = rt2x00_get_field16(eeprom, EEPROM_BBP_REG_ID);
 			value = rt2x00_get_field16(eeprom, EEPROM_BBP_VALUE);
-			DEBUG(rt2x00dev, "BBP: 0x%02x, value: 0x%02x.\n",
-			      reg_id, value);
 			rt2500usb_bbp_write(rt2x00dev, reg_id, value);
 		}
 	}
-	DEBUG(rt2x00dev, "...End initialization from EEPROM.\n");
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 9fd2dd8..da0491b 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1282,19 +1282,15 @@ continue_csr_init:
 	rt61pci_bbp_write(rt2x00dev, 102, 0x16);
 	rt61pci_bbp_write(rt2x00dev, 107, 0x04);
 
-	DEBUG(rt2x00dev, "Start initialization from EEPROM...\n");
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
 
 		if (eeprom != 0xffff && eeprom != 0x0000) {
 			reg_id = rt2x00_get_field16(eeprom, EEPROM_BBP_REG_ID);
 			value = rt2x00_get_field16(eeprom, EEPROM_BBP_VALUE);
-			DEBUG(rt2x00dev, "BBP: 0x%02x, value: 0x%02x.\n",
-			      reg_id, value);
 			rt61pci_bbp_write(rt2x00dev, reg_id, value);
 		}
 	}
-	DEBUG(rt2x00dev, "...End initialization from EEPROM.\n");
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 146135f..ee2ee7b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1087,19 +1087,15 @@ continue_csr_init:
 	rt73usb_bbp_write(rt2x00dev, 102, 0x16);
 	rt73usb_bbp_write(rt2x00dev, 107, 0x04);
 
-	DEBUG(rt2x00dev, "Start initialization from EEPROM...\n");
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
 
 		if (eeprom != 0xffff && eeprom != 0x0000) {
 			reg_id = rt2x00_get_field16(eeprom, EEPROM_BBP_REG_ID);
 			value = rt2x00_get_field16(eeprom, EEPROM_BBP_VALUE);
-			DEBUG(rt2x00dev, "BBP: 0x%02x, value: 0x%02x.\n",
-			      reg_id, value);
 			rt73usb_bbp_write(rt2x00dev, reg_id, value);
 		}
 	}
-	DEBUG(rt2x00dev, "...End initialization from EEPROM.\n");
 
 	return 0;
 }
-- 
1.5.4

