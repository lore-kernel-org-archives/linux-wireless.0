Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:61618 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2BSPuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 10:50:23 -0500
Received: by qafk1 with SMTP id k1so5170891qaf.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2012 07:50:22 -0800 (PST)
From: Rick Farina <sidhayn@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Rick Farina <sidhayn@gmail.com>
Subject: [PATCH] [compat-wireless] cleanup modprobe calls
Date: Sun, 19 Feb 2012 10:49:52 -0500
Message-Id: <1329666592-19702-1-git-send-email-sidhayn@gmail.com> (sfid-20120219_165046_377380_BA038FEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a lot of needless calls to "modprobe -l <drivername>"
None of this is needed, and it errors when modprobe -l is removed
(such as when KMOD replaces modutils). Since modprobe -l is already
legacy, let's just remove it.

Signed-off-by: Rick Farina <sidhayn@gmail.com>
---
 Makefile |  255 --------------------------------------------------------------
 1 files changed, 0 insertions(+), 255 deletions(-)

diff --git a/Makefile b/Makefile
index 5ab1ff9..4149d8d 100644
--- a/Makefile
+++ b/Makefile
@@ -104,29 +104,6 @@ bt-install-modules: bt $(MODPROBE)
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
@@ -142,29 +119,6 @@ btuninstall: $(MODPROBE)
 	@# on the misc directory.
 	@/sbin/depmod -ae
 	@echo
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
-	@echo
 
 btclean:
 	$(MAKE) -C /lib/modules/$(shell uname -r)/build M=$(PWD) BT=TRUE clean
@@ -230,110 +184,6 @@ install-scripts: $(MODPROBE)
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
-	@$(MODPROBE) -l alx
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
@@ -362,111 +212,6 @@ uninstall: $(MODPROBE)
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
-	@$(MODPROBE) -l alx
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
 	@echo 
 
 clean:
-- 
1.7.3.4

