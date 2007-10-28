Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45965
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbXJ1MI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 08:08:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rfkill: Register LED triggers before registering switch
Date: Sun, 28 Oct 2007 13:07:54 +0100
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200710281307.54552.mb@bu3sch.de> (sfid-20071028_120900_993510_66F1E41B)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Registering the switch triggers a LED event, so we must register
LED triggers before the switch.
This has a potential to fix a crash, depending on how the device
driver initializes the rfkill data structure.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/net/rfkill/rfkill.c
===================================================================
--- wireless-2.6.orig/net/rfkill/rfkill.c	2007-10-27 13:28:33.000000000 +0200
+++ wireless-2.6/net/rfkill/rfkill.c	2007-10-28 12:57:12.000000000 +0100
@@ -388,19 +388,20 @@ int rfkill_register(struct rfkill *rfkil
 	if (!rfkill->toggle_radio)
 		return -EINVAL;
 
+	snprintf(dev->bus_id, sizeof(dev->bus_id),
+		 "rfkill%ld", (long)atomic_inc_return(&rfkill_no) - 1);
+
+	rfkill_led_trigger_register(rfkill);
+
 	error = rfkill_add_switch(rfkill);
 	if (error)
 		return error;
 
-	snprintf(dev->bus_id, sizeof(dev->bus_id),
-		 "rfkill%ld", (long)atomic_inc_return(&rfkill_no) - 1);
-
 	error = device_add(dev);
 	if (error) {
 		rfkill_remove_switch(rfkill);
 		return error;
 	}
-	rfkill_led_trigger_register(rfkill);
 
 	return 0;
 }
@@ -416,9 +417,9 @@ EXPORT_SYMBOL(rfkill_register);
  */
 void rfkill_unregister(struct rfkill *rfkill)
 {
-	rfkill_led_trigger_unregister(rfkill);
 	device_del(&rfkill->dev);
 	rfkill_remove_switch(rfkill);
+	rfkill_led_trigger_unregister(rfkill);
 	put_device(&rfkill->dev);
 }
 EXPORT_SYMBOL(rfkill_unregister);
