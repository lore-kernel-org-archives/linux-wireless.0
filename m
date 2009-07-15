Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:34574 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756156AbZGOWlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 18:41:18 -0400
Message-ID: <4A5E5AD6.5090509@redfish-solutions.com>
Date: Wed, 15 Jul 2009 15:40:22 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org, mcgrof@winlab.rutgers.edu
Subject: Re: Build instructions for cross-compilation environment
References: <4A5E377E.6090705@redfish-solutions.com> <b6c5339f0907151451r2ae9e3bcvcafd921b300fb040@mail.gmail.com>
In-Reply-To: <b6c5339f0907151451r2ae9e3bcvcafd921b300fb040@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060507060907050205050900"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060507060907050205050900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Bob Copeland wrote:
> On Wed, Jul 15, 2009 at 4:09 PM, Philip A.
> Prindeville<philipp_subx@redfish-solutions.com> wrote:
>> Also, a list of what CONFIG_xxx symbols I need to turn off to ensure
>> that there is no "residue" left over from the kernel build to interfere
>> with the compat-wireless build would be helpful (or alternatively,
>> what's the bare essential list of CONFIG_xxx symbols that need to be
>> enabled to "hook" compat-wireless into an existing kernel).
> 
> At least CONFIG_{CFG80211,MAC80211}=m but you'll likely need to experiment.
> 
>> Looking at the Makefiles, it doesn't seem that cross-compilation is
>> ready out-of-the-box:
> 
> Perhaps it isn't for the installation stuff, but I've had no problems
> building the modules with a cross compiler.  And you said you wanted to
> customize installation anyway (just copy the built modules under 'kernel'
> if that's what you want.  It doesn't matter where they live as long as
> depmod finds them;'updates' is nice for rollback, however.)
> 
> Here's my dumb cross compilation script, make-arm.sh:
> 
> #!/bin/bash
> 
> DIR=/home/bob/ext/linux-2.6
> XGCC=/home/bob/projects/xgcc
> export PATH="$XGCC/arm-2008q3/bin/:$PATH"
> make ARCH=arm CROSS_COMPILE=arm-none-eabi- KLIB=$DIR KLIB_BUILD=$DIR "$@"
> 
>> Please reply to me directly (or even on Cc).  I tried to join the list a
>> couple of weeks ago, but my request hasn't yet been processed.
> 
> Perhaps try again?  majordomo can be slow but two weeks slow sounds
> off...
> 


Hmmmm...  Found that a certain amount of patching was in order...  attached.

Now when I build, however, I'm getting some linkage warnings (below).  Is there an easy way to skip the PC-card/PCMCIA-based drivers?

Also, built my kernel with CONFIG_RFKILL=m ... that seems to be an issue.  Do I need to build it with =y instead?

Ditto with CONFIG_CRC_ITU_T=m

Logs:

make -j5 -C /home/philipp/kernel/build_i586/compat-wireless-2.6.30 \
		HOSTCC=gcc CC=/home/philipp/kernel/build_i586/staging_dir/bin/i586-linux-uclibc-gcc ARCH=i386 \
		KLIB=/lib/modules/2.6.27.26-astlinux KLIB_BUILD=/home/philipp/kernel/build_i586/linux-2.6.27.26-astlinux \
		MODPROBE='true' PWD=/home/philipp/kernel/build_i586/compat-wireless-2.6.30 \
		KMODDIR= \
		KMODPATH_ARG='INSTALL_MOD_PATH=/home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux' \
		install-modules
make[1]: Entering directory `/home/philipp/kernel/build_i586/compat-wireless-2.6.30'
make -C /home/philipp/kernel/build_i586/linux-2.6.27.26-astlinux M=/home/philipp/kernel/build_i586/compat-wireless-2.6.30 "INSTALL_MOD_DIR=" INSTALL_MOD_PATH=/home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux \
		modules_install
make[2]: Entering directory `/home/philipp/kernel/build_i586/linux-2.6.27.26-astlinux'
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/b44.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/usb/rndis_host.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/usb/cdc_ether.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/misc/eeprom/eeprom_93cx6.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/usb/usbnet.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/at76c50x-usb.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/adm8211.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/ath5k/ath5k.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/ath9k/ath9k.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/b43legacy/b43legacy.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/b43/b43.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/ipw2x00/ipw2100.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/ipw2x00/libipw.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/ipw2x00/ipw2200.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/iwlwifi/iwl3945.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/iwlwifi/iwlcore.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/libertas/libertas.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/iwlwifi/iwlagn.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/libertas/usb8xxx.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/mac80211_hwsim.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/mwl8k.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/p54/p54common.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/p54/p54pci.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/p54/p54usb.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/rndis_wlan.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/rt2x00/rt2400pci.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/rt2x00/rt2500pci.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/rt2x00/rt2500usb.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/rt2x00/rt2x00pci.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/rt2x00/rt2x00lib.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/rt2x00/rt2x00usb.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/rt2x00/rt73usb.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/rt2x00/rt61pci.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/rtl818x/rtl8180.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/rtl818x/rtl8187.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/net/wireless/zd1211rw/zd1211rw.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/net/mac80211/mac80211.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/drivers/ssb/ssb.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/net/wireless/cfg80211.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/net/wireless/lib80211.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/net/wireless/lib80211_crypt_ccmp.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/net/wireless/lib80211_crypt_wep.ko
  INSTALL /home/philipp/kernel/build_i586/compat-wireless-2.6.30/net/wireless/lib80211_crypt_tkip.ko
  DEPMOD  2.6.27.26-astlinux
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/rt2x00/rt73usb.ko needs unknown symbol crc_itu_t_table
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/rt2x00/rt73usb.ko needs unknown symbol crc_itu_t
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/rt2x00/rt61pci.ko needs unknown symbol crc_itu_t_table
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/rt2x00/rt61pci.ko needs unknown symbol crc_itu_t
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/ath9k/ath9k.ko needs unknown symbol rfkill_force_state
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/ath9k/ath9k.ko needs unknown symbol rfkill_unregister
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/ath9k/ath9k.ko needs unknown symbol rfkill_free
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/ath9k/ath9k.ko needs unknown symbol rfkill_allocate
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/ath9k/ath9k.ko needs unknown symbol rfkill_register
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_disable_device
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_unregister_driver
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_map_mem_page
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/b43/b43.ko needs unknown symbol pccard_get_first_tuple
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_request_window
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_request_configuration
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/b43/b43.ko needs unknown symbol pccard_get_tuple_data
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_register_driver
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/b43/b43.ko needs unknown symbol pccard_parse_tuple
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_request_irq
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/ssb/ssb.ko needs unknown symbol pccard_get_first_tuple
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/ssb/ssb.ko needs unknown symbol pcmcia_access_configuration_register
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/ssb/ssb.ko needs unknown symbol pccard_get_tuple_data
WARNING: /home/philipp/kernel/build_i586/root//lib/modules/2.6.27.26-astlinux/lib/modules/2.6.27.26-astlinux/drivers/ssb/ssb.ko needs unknown symbol pccard_get_next_tuple
make[2]: Leaving directory `/home/philipp/kernel/build_i586/linux-2.6.27.26-astlinux'
make[1]: Leaving directory `/home/philipp/kernel/build_i586/compat-wireless-2.6.30'
/sbin/depmod -ae -F /home/philipp/kernel/build_i586/linux-2.6.27.26-astlinux/System.map -b /home/philipp/kernel/build_i586/root -r 2.6.27.26-astlinux
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_disable_device
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_unregister_driver
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_map_mem_page
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/net/wireless/b43/b43.ko needs unknown symbol pccard_get_first_tuple
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_request_window
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_request_configuration
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/net/wireless/b43/b43.ko needs unknown symbol pccard_get_tuple_data
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_register_driver
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/net/wireless/b43/b43.ko needs unknown symbol pccard_parse_tuple
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_request_irq
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/ssb/ssb.ko needs unknown symbol pccard_get_first_tuple
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/ssb/ssb.ko needs unknown symbol pcmcia_access_configuration_register
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/ssb/ssb.ko needs unknown symbol pccard_get_tuple_data
WARNING: /home/philipp/kernel/build_i586/root/lib/modules/2.6.27.26-astlinux/extra/drivers/ssb/ssb.ko needs unknown symbol pccard_get_next_tuple


--------------060507060907050205050900
Content-Type: text/plain;
 name="compat-wireless-makefile.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="compat-wireless-makefile.patch"

--- compat-wireless-2.6.30/Makefile.orig	2009-06-10 17:24:42.000000000 -0700
+++ compat-wireless-2.6.30/Makefile	2009-07-15 14:13:21.000000000 -0700
@@ -1,6 +1,6 @@
 export KMODDIR?=       updates
 KMODDIR_ARG:=   "INSTALL_MOD_DIR=$(KMODDIR)"
-ifneq ($(origin $(KLIB)), undefined)
+ifneq ($(origin KLIB), undefined)
 KMODPATH_ARG:=  "INSTALL_MOD_PATH=$(KLIB)"
 else
 export KLIB:=          /lib/modules/$(shell uname -r)
@@ -11,6 +11,8 @@ MODPROBE := /sbin/modprobe
 MADWIFI=$(shell $(MODPROBE) -l ath_pci)
 OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
 
+DESTDIR?=
+
 ifneq ($(KERNELRELEASE),)
 
 include $(M)/$(COMPAT_CONFIG)
@@ -58,21 +60,25 @@ $(CREL_CHECK):
 	@touch $@
 	@md5sum $(COMPAT_CONFIG) > $(CONFIG_CHECK)
 
-install: uninstall modules
+install: uninstall install-modules install-scripts
+
+install-modules: modules
 	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) $(KMODDIR_ARG) $(KMODPATH_ARG) \
 		modules_install
+
+install-scripts:
 	@# All the scripts we can use
-	@mkdir -p /usr/lib/compat-wireless/
-	@install scripts/modlib.sh	/usr/lib/compat-wireless/
-	@install scripts/madwifi-unload	/usr/sbin/
+	@mkdir -p $(DESTDIR)/usr/lib/compat-wireless/
+	@install scripts/modlib.sh	$(DESTDIR)/usr/lib/compat-wireless/
+	@install scripts/madwifi-unload	$(DESTDIR)/usr/sbin/
 	@# This is to allow switching between drivers without blacklisting
-	@install scripts/athenable	/usr/sbin/
-	@install scripts/b43enable	/usr/sbin/
-	@install scripts/iwl-enable	/usr/sbin/
-	@install scripts/athload	/usr/sbin/
-	@install scripts/b43load	/usr/sbin/
-	@install scripts/iwl-load	/usr/sbin/
-	@if [ ! -z $(MADWIFI) ]; then \
+	@install scripts/athenable	$(DESTDIR)/usr/sbin/
+	@install scripts/b43enable	$(DESTDIR)/usr/sbin/
+	@install scripts/iwl-enable	$(DESTDIR)/usr/sbin/
+	@install scripts/athload	$(DESTDIR)/usr/sbin/
+	@install scripts/b43load	$(DESTDIR)/usr/sbin/
+	@install scripts/iwl-load	$(DESTDIR)/usr/sbin/
+	@if [ ! -z $(MADWIFI) && -z "$(DESTDIR)" ]; then \
 		echo ;\
 		echo -n "Note: madwifi detected, we're going to disable it. "  ;\
 		echo "If you would like to enable it later you can run:"  ;\
@@ -81,7 +88,7 @@ install: uninstall modules
 		echo Running athenable ath5k...;\
 		/usr/sbin/athenable ath5k ;\
 	fi
-	@if [ ! -z $(OLD_IWL) ]; then \
+	@if [ ! -z $(OLD_IWL) && -z "$(DESTDIR)" ]; then \
 		echo ;\
 		echo -n "Note: iwl4965 detected, we're going to disable it. "  ;\
 		echo "If you would like to enable it later you can run:"  ;\

--------------060507060907050205050900--
