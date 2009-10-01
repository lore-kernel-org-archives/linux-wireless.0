Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45381 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750869AbZJAEcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 00:32:17 -0400
From: Malte Gell <malte.gell@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: PATCH ar9170usb LEDs are confused
Date: Thu, 1 Oct 2009 06:32:12 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_MDDxKFu5halZwZl"
Message-Id: <200910010632.12571.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_MDDxKFu5halZwZl
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

I first noticed the LEDs are confused, when I ran my AVM Fritz USBN N under 
Windows, where the LEDs had the right order. I made a little patch that put 
the assoc and the tx LEDs in the right order.

That patch was built against compat-wireless-2009-09-29.

Regards
Malte

--Boundary-00=_MDDxKFu5halZwZl
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ar9170-led.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ar9170-led.patch"

--- drivers/net/wireless/ath/ar9170/led_c_orig	2009-10-01 05:55:55.000000000 +0200
+++ drivers/net/wireless/ath/ar9170/led.c	2009-10-01 06:02:26.000000000 +0200
@@ -161,13 +161,13 @@
 
 	INIT_DELAYED_WORK(&ar->led_work, ar9170_update_leds);
 
-	err = ar9170_register_led(ar, 0, "tx",
-				  ieee80211_get_tx_led_name(ar->hw));
+	err = ar9170_register_led(ar, 0, "assoc",
+				  ieee80211_get_assoc_led_name(ar->hw));
 	if (err)
 		goto fail;
 
-	err = ar9170_register_led(ar, 1, "assoc",
-				 ieee80211_get_assoc_led_name(ar->hw));
+	err = ar9170_register_led(ar, 1, "tx",
+				 ieee80211_get_tx_led_name(ar->hw));
 	if (err)
 		goto fail;
 

--Boundary-00=_MDDxKFu5halZwZl--
