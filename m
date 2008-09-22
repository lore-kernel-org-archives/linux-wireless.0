Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:20092 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbYIVXaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 19:30:12 -0400
Message-ID: <48D82A43.7040604@oracle.com> (sfid-20080923_013017_503715_741E7BAB)
Date: Mon, 22 Sep 2008 16:29:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
CC: linville@tuxdriver.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] rt2x00: fix Kconfig dependencies
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

If RT2X00=y but RFKILL=m, these build errors happen:

(.text+0x7c7d6): undefined reference to `rfkill_free'
rt2x00rfkill.c:(.text+0x7c830): undefined reference to `rfkill_force_state'
(.text+0x7c88d): undefined reference to `rfkill_unregister'
(.text+0x7c8cd): undefined reference to `rfkill_register'
(.text+0x7ca1a): undefined reference to `rfkill_allocate'

so restrict RT2X00's RFKILL config level to that of the main RFKILL option.
This is done by making the former a tristate instead of a bool
config option.


If RT2X00=y but LEDS_CLASS=m, these build errors happen:

(.text+0x11859f): undefined reference to `led_classdev_resume'
(.text+0x1185b3): undefined reference to `led_classdev_resume'
(.text+0x1185c7): undefined reference to `led_classdev_resume'
(.text+0x1185e4): undefined reference to `led_classdev_suspend'
(.text+0x1185f8): undefined reference to `led_classdev_suspend'
(.text+0x11860c): undefined reference to `led_classdev_suspend'
rt2x00leds.c:(.text+0x118620): undefined reference to `led_classdev_unregister'
rt2x00leds.c:(.text+0x118695): undefined reference to `led_classdev_register'

so restrict RT2X00's LEDS config level to that of the main LEDS_CLASS option.
This is done by making the former a tristate instead of a bool
config option.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/rt2x00/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2008-0922-0136.orig/drivers/net/wireless/rt2x00/Kconfig
+++ mmotm-2008-0922-0136/drivers/net/wireless/rt2x00/Kconfig
@@ -38,13 +38,13 @@ config RT2X00_LIB_CRYPTO
 	depends on RT2X00_LIB
 
 config RT2X00_LIB_RFKILL
-	boolean
+	tristate
 	depends on RT2X00_LIB
 	depends on RFKILL
 	default y
 
 config RT2X00_LIB_LEDS
-	boolean
+	tristate
 	depends on RT2X00_LIB
 	depends on NEW_LEDS
 	depends on LEDS_CLASS

