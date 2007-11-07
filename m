Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:42020 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753475AbXKGX3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 18:29:25 -0500
Date: Thu, 8 Nov 2007 00:28:00 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: fix kconfig dependecies for rfkill and leds
Message-ID: <20071108002800.3d73dced@morte> (sfid-20071107_232942_693076_464EC65F)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix dependencies for built-in b43legacy.

The patch to b43 by Michael Buesch <mb@bu3sch.de> has been ported to
b43legacy.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

Index: wireless-2.6/drivers/net/wireless/b43legacy/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/Kconfig
+++ wireless-2.6/drivers/net/wireless/b43legacy/Kconfig
@@ -35,15 +35,19 @@ config B43LEGACY_PCICORE_AUTOSELECT
 	default y
 
 # LED support
+# This config option automatically enables b43legacy LEDS support,
+# if it's possible.
 config B43LEGACY_LEDS
 	bool
-	depends on B43LEGACY && MAC80211_LEDS
+	depends on B43LEGACY && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = B43LEGACY)
 	default y
 
 # RFKILL support
+# This config option automatically enables b43legacy RFKILL support,
+# if it's possible.
 config B43LEGACY_RFKILL
 	bool
-	depends on B43LEGACY && RFKILL && RFKILL_INPUT && INPUT_POLLDEV
+	depends on B43LEGACY && (RFKILL = y || RFKILL = B43LEGACY) && RFKILL_INPUT && (INPUT_POLLDEV = y || INPUT_POLLDEV = B43LEGACY)
 	default y
 
 config B43LEGACY_DEBUG



-- 
Ciao
Stefano
