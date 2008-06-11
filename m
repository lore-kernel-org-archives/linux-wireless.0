Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:52032 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYFKUeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 16:34:16 -0400
Date: Wed, 11 Jun 2008 13:32:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-next@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] next-20080611 rt2x00: LEDS build failure
Message-Id: <20080611133222.77c4a3f4.randy.dunlap@oracle.com> (sfid-20080611_223420_156864_77003E59)
In-Reply-To: <200806112159.00779.IvDoorn@gmail.com>
References: <20080611100748.d35829f4.randy.dunlap@oracle.com>
	<200806112103.58517.IvDoorn@gmail.com>
	<20080611123245.4089f47b.randy.dunlap@oracle.com>
	<200806112159.00779.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Config symbols that select LEDS_CLASS need to depend on NEW_LEDS so that
undefined symbols are not used in the build.

The alternative is to select NEW_LEDS, which some drivers do.

This patch fixes the led_* symbols build errors.

(.text+0x174cdc): undefined reference to `input_unregister_device'
(.text+0x174d9f): undefined reference to `input_allocate_device'
(.text+0x174e2d): undefined reference to `input_register_device'
(.text+0x174e53): undefined reference to `input_free_device'
rt2x00rfkill.c:(.text+0x176dc4): undefined reference to `input_allocate_polled_device'
rt2x00rfkill.c:(.text+0x176e8b): undefined reference to `input_event'
rt2x00rfkill.c:(.text+0x176e9f): undefined reference to `input_event'
(.text+0x176eca): undefined reference to `input_unregister_polled_device'
(.text+0x176efc): undefined reference to `input_free_polled_device'
(.text+0x176f37): undefined reference to `input_free_polled_device'
(.text+0x176fd8): undefined reference to `input_register_polled_device'
(.text+0x1772c0): undefined reference to `led_classdev_resume'
(.text+0x1772d4): undefined reference to `led_classdev_resume'
(.text+0x1772e8): undefined reference to `led_classdev_resume'
(.text+0x17730a): undefined reference to `led_classdev_suspend'
(.text+0x17731e): undefined reference to `led_classdev_suspend'
(.text+0x17732f): undefined reference to `led_classdev_suspend'
rt2x00leds.c:(.text+0x177348): undefined reference to `led_classdev_unregister'
rt2x00leds.c:(.text+0x1773c0): undefined reference to `led_classdev_register'
rfkill-input.c:(.text+0x209e4c): undefined reference to `input_close_device'
rfkill-input.c:(.text+0x209e53): undefined reference to `input_unregister_handle'
rfkill-input.c:(.text+0x209ea1): undefined reference to `input_register_handle'
rfkill-input.c:(.text+0x209eae): undefined reference to `input_open_device'
rfkill-input.c:(.text+0x209ebb): undefined reference to `input_unregister_handle'
rfkill-input.c:(.init.text+0x17405): undefined reference to `input_register_handler'
rfkill-input.c:(.exit.text+0x194f): undefined reference to `input_unregister_handler'
make[1]: *** [vmlinux] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/rt2x00/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-next-20080611.orig/drivers/net/wireless/rt2x00/Kconfig
+++ linux-next-20080611/drivers/net/wireless/rt2x00/Kconfig
@@ -42,7 +42,7 @@ config RT2X00_LIB_RFKILL
 
 config RT2X00_LIB_LEDS
 	boolean
-	depends on RT2X00_LIB
+	depends on RT2X00_LIB && NEW_LEDS
 
 config RT2400PCI
 	tristate "Ralink rt2400 (PCI/PCMCIA) support"
@@ -66,7 +66,7 @@ config RT2400PCI_RFKILL
 
 config RT2400PCI_LEDS
 	bool "Ralink rt2400 leds support"
-	depends on RT2400PCI
+	depends on RT2400PCI && NEW_LEDS
 	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
@@ -94,7 +94,7 @@ config RT2500PCI_RFKILL
 
 config RT2500PCI_LEDS
 	bool "Ralink rt2500 leds support"
-	depends on RT2500PCI
+	depends on RT2500PCI && NEW_LEDS
 	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
@@ -124,7 +124,7 @@ config RT61PCI_RFKILL
 
 config RT61PCI_LEDS
 	bool "Ralink rt2501/rt61 leds support"
-	depends on RT61PCI
+	depends on RT61PCI && NEW_LEDS
 	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
@@ -162,7 +162,7 @@ config RT73USB
 
 config RT73USB_LEDS
 	bool "Ralink rt2501/rt73 leds support"
-	depends on RT73USB
+	depends on RT73USB && NEW_LEDS
 	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
