Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:37793 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYFKTdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 15:33:22 -0400
Date: Wed, 11 Jun 2008 12:32:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-next@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [Rt2400-devel] next-20080611 rt2x00: build failure
Message-Id: <20080611123245.4089f47b.randy.dunlap@oracle.com> (sfid-20080611_213326_996775_654FA771)
In-Reply-To: <200806112103.58517.IvDoorn@gmail.com>
References: <20080611100748.d35829f4.randy.dunlap@oracle.com>
	<20080611181000.GA32331@tuxdriver.com>
	<200806112103.58517.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 11 Jun 2008 21:03:58 +0200 Ivo van Doorn wrote:

> On Wednesday 11 June 2008, John W. Linville wrote:
> > On Wed, Jun 11, 2008 at 10:07:48AM -0700, Randy Dunlap wrote:
> > > when CONFIG_INPUT=n and
> > > # CONFIG_NEW_LEDS is not set
> > > CONFIG_LEDS_CLASS=y
> > > 
> > > (full config attached)
> > > 
> > > vmlinux.o: In function `iwl_rfkill_unregister':
> > > (.text+0x174cdc): undefined reference to `input_unregister_device'
> > > vmlinux.o: In function `iwl_rfkill_init':
> > > (.text+0x174d9f): undefined reference to `input_allocate_device'
> > > vmlinux.o: In function `iwl_rfkill_init':
> > > (.text+0x174e2d): undefined reference to `input_register_device'
> > > vmlinux.o: In function `iwl_rfkill_init':
> > > (.text+0x174e53): undefined reference to `input_free_device'
> > > vmlinux.o: In function `rt2x00rfkill_allocate_polldev':
> > > rt2x00rfkill.c:(.text+0x176dc4): undefined reference to `input_allocate_polled_device'
> > > vmlinux.o: In function `rt2x00rfkill_poll':
> > > rt2x00rfkill.c:(.text+0x176e8b): undefined reference to `input_event'
> > > rt2x00rfkill.c:(.text+0x176e9f): undefined reference to `input_event'
> > 
> > <snip>
> > 
> > Ick, what a mess...
> > 
> > So what combination of depends and select of INPUT, INPUT_POLLDEV,
> > and RFKILL_INPUT do we need to resolve this?
> 
> Well RFKILL_INPUT shouldn't be selected by a driver, in fact any driver that
> selects or depends on RFKILL_INPUT is wrong. But selecting it only makes
> matters worse since that will bypass the INPUT dependency.
> When INPUT_POLLDEV is required I guess it is best to depend on INPUT and
> select INPUT_POLLDEV.
> 
> iwlwifi is selecting RFKILL_INPUT and preferably they should drop the select
> altogether (not replacing it with a depend), but since I am not sure about the
> reason for the select

Yes, that easily causes a build failure.

> rt2x00 is selecting INPUT_POLLDEV but should depend on INPUT first (as done
> in the patch in my previous mail).
> 
> b43 shouldn't really depend on RFKILL_INPUT but their Kconfig is correct and
> shouldn't cause the above build failure.

Patch below fixes the RFKILL/INPUT build problems for me.  I haven't addresses
the leds_* build problems yet.


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
---
 drivers/net/wireless/rt2x00/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
