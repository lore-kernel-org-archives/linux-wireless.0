Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:48288 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab2BCCsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 21:48:38 -0500
Received: by qafk1 with SMTP id k1so2064242qaf.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 18:48:37 -0800 (PST)
From: Rick Farina <sidhayn@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Rick Farina <sidhayn@gmail.com>
Subject: [PATCH 2/2] cleanup modprobe calls
Date: Thu,  2 Feb 2012 21:48:22 -0500
Message-Id: <1328237302-13423-2-git-send-email-sidhayn@gmail.com> (sfid-20120203_034841_839777_E6860D66)
In-Reply-To: <1328237302-13423-1-git-send-email-sidhayn@gmail.com>
References: <1328237302-13423-1-git-send-email-sidhayn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were a lot of needless calls to "modprobe -l <drivername>" and even more confusingly $(MODPROBE).
None of this is needed on a modern distro, and it errors on when modprobe -l is removed (such as KMOD in Arch Linux)

Signed-of-By: Rick Farina <sidhayn@gmail.com>
---
 Makefile |  260 +-------------------------------------------------------------
 1 files changed, 4 insertions(+), 256 deletions(-)

diff --git a/Makefile b/Makefile
index 1f8ab91..d586f45 100644
--- a/Makefile
+++ b/Makefile
@@ -91,34 +91,11 @@ $(CREL_CHECK):
 
 btinstall: btuninstall bt-install-modules
 
-bt-install-modules: bt $(MODPROBE)
+bt-install-modules: bt
 	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) $(KMODDIR_ARG) $(KMODPATH_ARG) BT=TRUE \
 		modules_install
 	@/sbin/depmod -ae
 	@echo
-	@echo "Currently detected bluetooth subsystem modules:"
-	@echo
-	@$(MODPROBE) -l ath3k       
-	@$(MODPROBE) -l bcm203x
-	@$(MODPROBE) -l bluecard_cs
-	@$(MODPROBE) -l bluetooth
-	@$(MODPROBE) -l bnep
-	@$(MODPROBE) -l bpa10x
-	@$(MODPROBE) -l bt3c_cs
-	@$(MODPROBE) -l btmrvl
-	@$(MODPROBE) -l btmrvl_sdio
-	@$(MODPROBE) -l btsdio
-	@$(MODPROBE) -l btusb
-	@$(MODPROBE) -l btuart_cs
-	@$(MODPROBE) -l	cmtp
-	@$(MODPROBE) -l	dtl1_cs
-	@$(MODPROBE) -l hidp
-	@$(MODPROBE) -l	hci_vhci
-	@$(MODPROBE) -l	hci_uart
-	@$(MODPROBE) -l l2cap
-	@$(MODPROBE) -l rfcomm
-	@$(MODPROBE) -l sco
-	@echo
 	@echo Now run:
 	@echo
 	@echo sudo make btunload:
@@ -126,7 +103,7 @@ bt-install-modules: bt $(MODPROBE)
 	@echo And then load the needed bluetooth modules. If unsure reboot.
 	@echo
 
-btuninstall: $(MODPROBE)
+btuninstall:
 	@# New location, matches upstream
 	@rm -rf $(KLIB)/$(KMODDIR)/net/bluetooth/
 	@rm -rf $(KLIB)/$(KMODDIR)/drivers/bluetooth/
@@ -136,27 +113,6 @@ btuninstall: $(MODPROBE)
 	@echo
 	@echo "Your old bluetooth subsystem modules were left intact:"
 	@echo
-	@$(MODPROBE) -l ath3k       
-	@$(MODPROBE) -l bcm203x
-	@$(MODPROBE) -l bluecard_cs
-	@$(MODPROBE) -l bluetooth
-	@$(MODPROBE) -l bnep
-	@$(MODPROBE) -l bpa10x
-	@$(MODPROBE) -l bt3c_cs
-	@$(MODPROBE) -l btmrvl
-	@$(MODPROBE) -l btmrvl_sdio
-	@$(MODPROBE) -l btsdio
-	@$(MODPROBE) -l btusb
-	@$(MODPROBE) -l btuart_cs
-	@$(MODPROBE) -l	cmtp
-	@$(MODPROBE) -l	dtl1_cs
-	@$(MODPROBE) -l hidp
-	@$(MODPROBE) -l	hci_vhci
-	@$(MODPROBE) -l	hci_uart
-	@$(MODPROBE) -l l2cap
-	@$(MODPROBE) -l rfcomm
-	@$(MODPROBE) -l sco
-	@echo
 
 btclean:
 	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) BT=TRUE clean
@@ -169,7 +125,7 @@ install-modules: modules
 		modules_install
 	@./scripts/update-initramfs
 
-install-scripts: $(MODPROBE)
+install-scripts:
 	@# All the scripts we can use
 	@mkdir -p $(DESTDIR)/usr/lib/compat-wireless/
 	@install scripts/modlib.sh	$(DESTDIR)/usr/lib/compat-wireless/
@@ -212,109 +168,6 @@ install-scripts: $(MODPROBE)
 	@# Udev stuff needed for the new compat_firmware_class.
 	@./compat/scripts/compat_firmware_install
 	@/sbin/depmod -a
-	@echo
-	@echo "Currently detected wireless subsystem modules:"
-	@echo 
-	@$(MODPROBE) -l mac80211
-	@$(MODPROBE) -l cfg80211
-	@$(MODPROBE) -l lib80211
-	@$(MODPROBE) -l adm8211
-	@$(MODPROBE) -l ar9170usb
-	@$(MODPROBE) -l at76c50x-usb
-	@$(MODPROBE) -l ath
-	@$(MODPROBE) -l ath5k
-	@$(MODPROBE) -l ath6kl
-	@$(MODPROBE) -l ath9k
-	@$(MODPROBE) -l ath9k_htc
-	@$(MODPROBE) -l b43
-	@$(MODPROBE) -l b43legacy
-	@$(MODPROBE) -l b44
-	@$(MODPROBE) -l carl9170
-	@$(MODPROBE) -l brcm80211
-	@$(MODPROBE) -l cdc_ether
-	@$(MODPROBE) -l eeprom_93cx6
-	@$(MODPROBE) -l ipw2100
-	@$(MODPROBE) -l ipw2200
-	@$(MODPROBE) -l iwl3945
-	@$(MODPROBE) -l iwlagn
-	@$(MODPROBE) -l iwlcore
-	@$(MODPROBE) -l iwmc3200wifi
-	@$(MODPROBE) -l lib80211_crypt_ccmp
-	@$(MODPROBE) -l lib80211_crypt_tkip
-	@$(MODPROBE) -l lib80211_crypt_wep
-	@$(MODPROBE) -l libertas
-	@$(MODPROBE) -l libertas_cs
-	@$(MODPROBE) -l libertas_sdio
-	@$(MODPROBE) -l libertas_spi
-	@$(MODPROBE) -l libertas_tf
-	@$(MODPROBE) -l libertas_tf_usb
-	@$(MODPROBE) -l libipw
-	@$(MODPROBE) -l mac80211_hwsim
-	@$(MODPROBE) -l mwl8k
-	@$(MODPROBE) -l orinoco_cs
-	@$(MODPROBE) -l orinoco_nortel
-	@$(MODPROBE) -l orinoco_pci
-	@$(MODPROBE) -l orinoco_plx
-	@$(MODPROBE) -l orinoco_tld
-	@$(MODPROBE) -l orinoco_usb
-	@$(MODPROBE) -l orinoco
-	@$(MODPROBE) -l p54common
-	@$(MODPROBE) -l p54pci
-	@$(MODPROBE) -l p54spi
-	@$(MODPROBE) -l p54usb
-	@$(MODPROBE) -l rndis_host
-	@$(MODPROBE) -l rndis_wlan
-	@$(MODPROBE) -l rt2400pci
-	@$(MODPROBE) -l rt2500pci
-	@$(MODPROBE) -l rt2500usb
-	@$(MODPROBE) -l rt2800pci
-	@$(MODPROBE) -l rt2800usb
-	@$(MODPROBE) -l rt2x00lib
-	@$(MODPROBE) -l rt2x00pci
-	@$(MODPROBE) -l rt2x00usb
-	@$(MODPROBE) -l rt61pci
-	@$(MODPROBE) -l rt73usb
-	@$(MODPROBE) -l rtl8180
-	@$(MODPROBE) -l rtl8187
-	@$(MODPROBE) -l rtlwifi
-	@$(MODPROBE) -l rtl8192ce
-	@$(MODPROBE) -l spectrum_cs
-	@$(MODPROBE) -l ssb
-	@$(MODPROBE) -l usb8xxx
-	@$(MODPROBE) -l usbnet
-	@$(MODPROBE) -l wl1251
-	@$(MODPROBE) -l wl12xx
-	@$(MODPROBE) -l zd1211rw
-	@echo
-	@echo "Currently detected ethernet subsystem modules:"
-	@echo
-	@$(MODPROBE) -l atl1
-	@$(MODPROBE) -l atl2
-	@$(MODPROBE) -l atl1e
-	@$(MODPROBE) -l atl1c
-	@echo
-	@echo "Currently detected bluetooth subsystem modules:"
-	@echo
-	@$(MODPROBE) -l ath3k           
-	@$(MODPROBE) -l bcm203x
-	@$(MODPROBE) -l bluecard_cs
-	@$(MODPROBE) -l bluetooth
-	@$(MODPROBE) -l bnep
-	@$(MODPROBE) -l bpa10x
-	@$(MODPROBE) -l bt3c_cs
-	@$(MODPROBE) -l btmrvl
-	@$(MODPROBE) -l btmrvl_sdio
-	@$(MODPROBE) -l btsdio
-	@$(MODPROBE) -l btusb
-	@$(MODPROBE) -l btuart_cs
-	@$(MODPROBE) -l	cmtp
-	@$(MODPROBE) -l	dtl1_cs
-	@$(MODPROBE) -l hidp
-	@$(MODPROBE) -l	hci_vhci
-	@$(MODPROBE) -l	hci_uart
-	@$(MODPROBE) -l l2cap
-	@$(MODPROBE) -l rfcomm
-	@$(MODPROBE) -l sco
 	@echo 
 	@echo Now run:
 	@echo 
@@ -326,7 +179,7 @@ install-scripts: $(MODPROBE)
 	@echo If unsure reboot.
 	@echo
 
-uninstall: $(MODPROBE)
+uninstall:
 	@# New location, matches upstream
 	@rm -rf $(KLIB)/$(KMODDIR)/compat/
 	@rm -rf $(KLIB)/$(KMODDIR)/net/mac80211/
@@ -343,111 +196,6 @@ uninstall: $(MODPROBE)
 	@rm -f $(KLIB)/$(KMODDIR)/drivers/misc/eeprom_93cx6.ko*
 	@rm -f $(KLIB)/$(KMODDIR)/drivers/net/b44.ko*
 	@/sbin/depmod -a
-	@echo
-	@echo "Your old wireless subsystem modules were left intact:"
-	@echo 
-	@$(MODPROBE) -l mac80211
-	@$(MODPROBE) -l cfg80211
-	@$(MODPROBE) -l lib80211
-	@$(MODPROBE) -l adm8211
-	@$(MODPROBE) -l ar9170usb
-	@$(MODPROBE) -l at76c50x-usb
-	@$(MODPROBE) -l ath
-	@$(MODPROBE) -l ath5k
-	@$(MODPROBE) -l ath6kl
-	@$(MODPROBE) -l ath9k
-	@$(MODPROBE) -l ath9k_htc
-	@$(MODPROBE) -l b43
-	@$(MODPROBE) -l b43legacy
-	@$(MODPROBE) -l b44
-	@$(MODPROBE) -l carl9170
-	@$(MODPROBE) -l brcm80211
-	@$(MODPROBE) -l cdc_ether
-	@$(MODPROBE) -l eeprom_93cx6
-	@$(MODPROBE) -l ipw2100
-	@$(MODPROBE) -l ipw2200
-	@$(MODPROBE) -l iwl3945
-	@$(MODPROBE) -l iwlagn
-	@$(MODPROBE) -l iwlcore
-	@$(MODPROBE) -l iwmc3200wifi
-	@$(MODPROBE) -l lib80211_crypt_ccmp
-	@$(MODPROBE) -l lib80211_crypt_tkip
-	@$(MODPROBE) -l lib80211_crypt_wep
-	@$(MODPROBE) -l libertas
-	@$(MODPROBE) -l libertas_cs
-	@$(MODPROBE) -l libertas_sdio
-	@$(MODPROBE) -l libertas_spi
-	@$(MODPROBE) -l libertas_tf
-	@$(MODPROBE) -l libertas_tf_usb
-	@$(MODPROBE) -l libipw
-	@$(MODPROBE) -l mac80211_hwsim
-	@$(MODPROBE) -l mwl8k
-	@$(MODPROBE) -l orinoco_cs
-	@$(MODPROBE) -l orinoco_nortel
-	@$(MODPROBE) -l orinoco_pci
-	@$(MODPROBE) -l orinoco_plx
-	@$(MODPROBE) -l orinoco_tld
-	@$(MODPROBE) -l orinoco_usb
-	@$(MODPROBE) -l orinoco
-	@$(MODPROBE) -l p54common
-	@$(MODPROBE) -l p54pci
-	@$(MODPROBE) -l p54spi
-	@$(MODPROBE) -l p54usb
-	@$(MODPROBE) -l rndis_host
-	@$(MODPROBE) -l rndis_wlan
-	@$(MODPROBE) -l rt2400pci
-	@$(MODPROBE) -l rt2500pci
-	@$(MODPROBE) -l rt2500usb
-	@$(MODPROBE) -l rt2800pci
-	@$(MODPROBE) -l rt2800usb
-	@$(MODPROBE) -l rt2x00lib
-	@$(MODPROBE) -l rt2x00pci
-	@$(MODPROBE) -l rt2x00usb
-	@$(MODPROBE) -l rt61pci
-	@$(MODPROBE) -l rt73usb
-	@$(MODPROBE) -l rtl8180
-	@$(MODPROBE) -l rtl8187
-	@$(MODPROBE) -l rtlwifi
-	@$(MODPROBE) -l rtl8192ce
-	@$(MODPROBE) -l spectrum_cs
-	@$(MODPROBE) -l ssb
-	@$(MODPROBE) -l usb8xxx
-	@$(MODPROBE) -l usbnet
-	@$(MODPROBE) -l wl1251
-	@$(MODPROBE) -l wl12xx
-	@$(MODPROBE) -l zd1211rw
-	@echo
-	@echo "Your old ethernet subsystem modules are left intact:"
-	@echo
-	@$(MODPROBE) -l atl1
-	@$(MODPROBE) -l atl2
-	@$(MODPROBE) -l atl1e
-	@$(MODPROBE) -l atl1c
-	@echo
-	@echo "Your old bluetooth subsystem modules were left intact:"
-	@echo
-	@$(MODPROBE) -l ath3k           
-	@$(MODPROBE) -l bcm203x
-	@$(MODPROBE) -l bluecard_cs
-	@$(MODPROBE) -l bluetooth
-	@$(MODPROBE) -l bnep
-	@$(MODPROBE) -l bpa10x
-	@$(MODPROBE) -l bt3c_cs
-	@$(MODPROBE) -l btmrvl
-	@$(MODPROBE) -l btmrvl_sdio
-	@$(MODPROBE) -l btsdio
-	@$(MODPROBE) -l btusb
-	@$(MODPROBE) -l btuart_cs
-	@$(MODPROBE) -l	cmtp
-	@$(MODPROBE) -l	dtl1_cs
-	@$(MODPROBE) -l hidp
-	@$(MODPROBE) -l	hci_vhci
-	@$(MODPROBE) -l	hci_uart
-	@$(MODPROBE) -l l2cap
-	@$(MODPROBE) -l rfcomm
-	@$(MODPROBE) -l sco
-	@
-	@echo 
 
 clean:
 	@if [ -d net -a -d $(KLIB_BUILD) ]; then \
-- 
1.7.3.4

