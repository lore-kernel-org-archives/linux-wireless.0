Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:46882 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648AbYFKT7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 15:59:00 -0400
Date: Wed, 11 Jun 2008 12:57:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-next@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] [Rt2400-devel] next-20080611 rt2x00: build failure
Message-Id: <20080611125758.613692ab.randy.dunlap@oracle.com> (sfid-20080611_215907_322280_1ED84991)
In-Reply-To: <200806112159.00779.IvDoorn@gmail.com>
References: <20080611100748.d35829f4.randy.dunlap@oracle.com>
	<200806112103.58517.IvDoorn@gmail.com>
	<20080611123245.4089f47b.randy.dunlap@oracle.com>
	<200806112159.00779.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Could you include the RT61PCI_RFKILL change as well?

<quilt refresh needed :( >

> After that you can add:
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>


Updated patch.  Thanks.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Config symbols that select RFKILL need to depend on INPUT so that
undefined symbols are not used in the build.

This patch fixes the input_* symbols build errors.

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
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-next-20080611.orig/drivers/net/wireless/rt2x00/Kconfig
+++ linux-next-20080611/drivers/net/wireless/rt2x00/Kconfig
@@ -36,6 +36,7 @@ config RT2X00_LIB_FIRMWARE
 config RT2X00_LIB_RFKILL
 	boolean
 	depends on RT2X00_LIB
+	depends on INPUT
 	select RFKILL
 	select INPUT_POLLDEV
 
@@ -56,7 +57,7 @@ config RT2400PCI
 
 config RT2400PCI_RFKILL
 	bool "Ralink rt2400 rfkill support"
-	depends on RT2400PCI
+	depends on RT2400PCI && INPUT
 	select RT2X00_LIB_RFKILL
 	---help---
 	  This adds support for integrated rt2400 hardware that features a
@@ -84,7 +85,7 @@ config RT2500PCI
 
 config RT2500PCI_RFKILL
 	bool "Ralink rt2500 rfkill support"
-	depends on RT2500PCI
+	depends on RT2500PCI && INPUT
 	select RT2X00_LIB_RFKILL
 	---help---
 	  This adds support for integrated rt2500 hardware that features a
@@ -114,7 +115,7 @@ config RT61PCI
 
 config RT61PCI_RFKILL
 	bool "Ralink rt2501/rt61 rfkill support"
-	depends on RT61PCI
+	depends on RT61PCI && INPUT
 	select RT2X00_LIB_RFKILL
 	---help---
 	  This adds support for integrated rt61 hardware that features a
