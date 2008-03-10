Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:51611 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYCJXdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 19:33:12 -0400
Date: Mon, 10 Mar 2008 19:33:07 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Franz Apeltauer <franz.apeltauer@gmx.at>,
	linux-wireless@vger.kernel.org
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
Message-ID: <20080310233307.GT28995@ruslug.rutgers.edu> (sfid-20080310_235451_004488_16ED82FB)
References: <47CB3B5E.4020701@gmx.at> <43e72e890803071859r2788075cp12272cad0920d2b0@mail.gmail.com> <47D5AAFC.80401@gmx.at> <200803102321.35909.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200803102321.35909.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 10, 2008 at 11:21:35PM +0100, Ivo van Doorn wrote:
> On Monday 10 March 2008, Franz Apeltauer wrote:
> > Luis R. Rodriguez schrieb:
> > >>  b) Test on a PC with MSI PC54G2 ... RaLink rt2500
> > > 
> > > You can test this now, I've enabled rt2x00 drivers by fixing
> > > dependencies on config.mk. Forced re-generation of new tarball based
> > > on latest updates too.
> > > 
> > >   Luis
> > 
> > Loaded today's tarball (10.3.).
> > The "redefinition of rt2x00lib_load_firmware" error is back.
> > 
> > I believe, that there should be 2 additional lines in rt2x00firmware.c:
> > a) line #115, before "int rt2x00lib_load_firmware":
> >      #ifdef CONFIG_RT2X00_LIB_FIRMWARE
> > b) at the end of the file:
> >      #endif /* CONFIG_RT2X00_LIB_FIRMWARE */
> > to be consistent with #ifdef/#else/#endif in rt2x00lib.h lines 124, 127, 
> > 135.
> > Then it compiles fine. install, unload, load.
> > ... and now I see wlan0 and wmaster0!  Yippee!
> 
> How about not linking rt2x00firmware.c at all when RT2X00_LIB_FIRMWARE
> is not set? That should be a clean solution that can be made in the Makefile...

Actually Ivo, I think you're fine, this is an issue with
compat-wireless. I've applied the patch below to correct this.

The issue seems to have come from scripts/gen-compat-autoconf.sh, in the 
the "skip vars that weren't actually set due to dependencies"
section.

Frankz, I generated a new tarball with this applied. You can either
patch your local tarball with this patch or just download the
tarball again.

  Luis

commit d4097ab3593a721fc1d99823d2442464debf7f09
Author: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
Date:   Mon Mar 10 19:20:33 2008 -0400

    Fix rt2x00 firmware build issue, fix typo with IPW2200 radiotap options
    
    Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

diff --git a/config.mk b/config.mk
index a146854..b9d537d 100644
--- a/config.mk
+++ b/config.mk
@@ -59,11 +59,11 @@ CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
 
 # The Intel ipws
 CONFIG_IPW2100=m
-IPW2100_MONITOR=y
+CONFIG_IPW2100_MONITOR=y
 CONFIG_IPW2200=m
-IPW2200_MONITOR=y
-IPW2200_RADIOTAP=y
-IPW2200_PROMISCUOUS=y
+CONFIG_IPW2200_MONITOR=y
+CONFIG_IPW2200_RADIOTAP=y
+CONFIG_IPW2200_PROMISCUOUS=y
 # The above enables use a second interface prefixed 'rtap'.
 #           Example usage:
 #
@@ -76,7 +76,7 @@ IPW2200_PROMISCUOUS=y
 # it on via sysfs:
 #
 # % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
-IPW2200_QOS=y
+CONFIG_IPW2200_QOS=y
 
 NEED_IEEE80211=y
 
@@ -113,9 +113,12 @@ CONFIG_EEPROM_93CX6=m
 ifneq ($(CONFIG_USB),)
 CONFIG_ZD1211RW=m
 
-# Sorry, it uses cancel_work_sync which is new and can't be done in compat...
+# Stuff here things which depend on kernel versions for USB
+ifeq ($(shell test -e $(KLIB_BUILD)/Makefile && echo yes),yes)
 ifeq ($(shell test $(shell sed 's/^SUBLEVEL = //;t;d' < $(KLIB_BUILD)/Makefile) -gt 21 && echo yes),yes)
 
+# Sorry, rndis_wlan uses cancel_work_sync which is new and can't be done in compat...
+
 # Wireless RNDIS USB support (RTL8185 802.11g) A-Link WL54PC
 # All of these devices are based on Broadcom 4320 chip which
 # is only wireless RNDIS chip known to date.
@@ -125,12 +128,14 @@ CONFIG_USB_NET_RNDIS_HOST=m
 CONFIG_USB_NET_RNDIS_WLAN=m
 
 endif
+endif
 
 CONFIG_P54_USB=m
 CONFIG_RTL8187=m
 
 # RT2500USB does not require firmware
 CONFIG_RT2500USB=m
+CONFIG_RT2X00_LIB_USB=m
 NEED_RT2X00=y
 # RT73USB requires firmware
 ifneq ($(CONFIG_CRC_ITU_T),)
@@ -144,12 +149,12 @@ endif # end of USB driver list
 ifeq ($(NEED_RT2X00),y)
 CONFIG_RT2X00=m
 CONFIG_RT2X00_LIB=m
+# CONFIG_RT2X00_LIB_DEBUGFS is not set
+# CONFIG_RT2X00_DEBUG is not set
 endif
 
 ifeq ($(NEED_RT2X00_FIRMWARE),y)
 CONFIG_RT2X00_LIB_FIRMWARE=y
-# CONFIG_RT2X00_LIB_DEBUGFS is not set
-# CONFIG_RT2X00_DEBUG is not set
 endif
 
 # p54
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 4c97835..173431f 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -127,9 +127,9 @@ for i in $(grep '^CONFIG_' $COMPAT_CONFIG); do
 	VALUE=$(echo $i | cut -d"=" -f 2)
 
 	# skip vars that weren't actually set due to dependencies
-	if [ "${!VAR}" = "" ] ; then
-		continue
-	fi
+	#if [ "${!VAR}" = "" ] ; then
+	#	continue
+	#fi
 
 	# Handle core kernel module depenencies here.
 	case $VAR in
