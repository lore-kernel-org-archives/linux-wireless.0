Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57106
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbXKGUZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 15:25:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix kconfig dependencies for rfkill and leds
Date: Wed, 7 Nov 2007 21:24:07 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711072124.07308.mb@bu3sch.de> (sfid-20071107_202522_854700_FDD32B15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix dependencies for built-in b43.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

I thought that I already submitted this patch, but it's not in wireless-2.6.
Maybe it was lost somewhere inbetween us or I simply forgot to send it.

Stefano, can you check if this patch is already applied to b43legacy?

Index: wireless-2.6/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/Kconfig	2007-10-27 13:28:16.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/Kconfig	2007-10-27 14:29:28.000000000 +0200
@@ -61,16 +61,18 @@ config B43_PCMCIA
 
 	  If unsure, say N.
 
-# LED support
+# This config option automatically enables b43 LEDS support,
+# if it's possible.
 config B43_LEDS
 	bool
-	depends on B43 && MAC80211_LEDS
+	depends on B43 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = B43)
 	default y
 
-# RFKILL support
+# This config option automatically enables b43 RFKILL support,
+# if it's possible.
 config B43_RFKILL
 	bool
-	depends on B43 && RFKILL && RFKILL_INPUT && INPUT_POLLDEV
+	depends on B43 && (RFKILL = y || RFKILL = B43) && RFKILL_INPUT && (INPUT_POLLDEV = y || INPUT_POLLDEV = B43)
 	default y
 
 config B43_DEBUG
