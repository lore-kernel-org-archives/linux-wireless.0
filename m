Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58549
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965194AbXBTUCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 15:02:39 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix max_rssi values signedness bug
Date: Tue, 20 Feb 2007 21:02:14 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702202102.14354.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

char is not signed on all architectures.
This fixes a compiletime warning and bug on PPC.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt2500pci.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/net/wireless/d80211/rt2x00/rt2500pci.c	2007-02-20 20:35:17.000000000 +0100
+++ bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt2500pci.c	2007-02-20 20:58:50.000000000 +0100
@@ -2630,7 +2630,7 @@ static int rt2500pci_init_eeprom(struct 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
 	rt2x00dev->hw->max_rssi =
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
-	if (rt2x00dev->hw->max_rssi == 0x00 || rt2x00dev->hw->max_rssi == (char)0xff)
+	if (rt2x00dev->hw->max_rssi == 0x00 || rt2x00dev->hw->max_rssi == (s8)0xff)
 		rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->max_noise = -110;
 
Index: bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt2500usb.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/net/wireless/d80211/rt2x00/rt2500usb.c	2007-02-20 20:54:20.000000000 +0100
+++ bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt2500usb.c	2007-02-20 20:59:23.000000000 +0100
@@ -2474,7 +2474,7 @@ static int rt2500usb_init_eeprom(struct 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
 	rt2x00dev->hw->max_rssi =
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
-	if (rt2x00dev->hw->max_rssi == 0x00 || rt2x00dev->hw->max_rssi == (char)0xff)
+	if (rt2x00dev->hw->max_rssi == 0x00 || rt2x00dev->hw->max_rssi == (s8)0xff)
 		rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->max_noise = -110;
 

-- 
Greetings Michael.
