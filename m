Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54646 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0IDPHI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Sep 2010 11:07:08 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/5] compat-wireless: add conditions form config into compat_autoconf.h
Date: Sat,  4 Sep 2010 17:06:45 +0200
Message-Id: <1283612809-6798-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1283612809-6798-1-git-send-email-hauke@hauke-m.de>
References: <1283612809-6798-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not have to use "ifneq ($(CONFIG_...),)", "ifdef CONFIG_..." will
also work. It does not matter if it was set to m or y.
Now this can be added into compat_autoconf.h without changing the script.

The special handling for CONFIG_CFG80211_WEXT is not needed any more,
because it is only activated when CONFIG_WIRELESS_EXT is also set.
Enabling this condition only for kernel <= 2.6.32 was wrong. In compat-
wireless we are able to deactivate CONFIG_WIRELESS_EXT for every
kernel. For activating it we need CONFIG_WIRELESS_EXT on every kernel.
If kernel <= 2.6.31 was build with cfg80211 support CONFIG_WIRELESS_EXT
was also selected, so it was activated in most cases for that kernel
versions. But it is possible to build compat-wireless without having
cfg80211 while building the kernel and that caused problems in the past.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                      |   88 ++++++++++++++++++++--------------------
 scripts/gen-compat-autoconf.sh |    4 --
 2 files changed, 44 insertions(+), 48 deletions(-)

diff --git a/config.mk b/config.mk
index 3c6d416..9991bfa 100644
--- a/config.mk
+++ b/config.mk
@@ -100,9 +100,9 @@ endif
 endif #CONFIG_COMPAT_KERNEL_27
 
 ifdef CONFIG_COMPAT_KERNEL_33
-ifneq ($(CONFIG_FW_LOADER),)
+ifdef CONFIG_FW_LOADER
  CONFIG_COMPAT_FIRMWARE_CLASS=m
-endif
+endif #CONFIG_FW_LOADER
 endif #CONFIG_COMPAT_KERNEL_33
 
 
@@ -159,9 +159,9 @@ CONFIG_BT_BNEP=m
 CONFIG_BT_BNEP_MC_FILTER=y
 CONFIG_BT_BNEP_PROTO_FILTER=y
 # CONFIG_BT_CMTP depends on ISDN_CAPI
-ifneq ($(CONFIG_ISDN_CAPI),)
+ifdef CONFIG_ISDN_CAPI
 CONFIG_BT_CMTP=m
-endif
+endif #CONFIG_ISDN_CAPI
 CONFIG_BT_HIDP=m
 
 CONFIG_BT_HCIUART=M
@@ -173,12 +173,12 @@ CONFIG_BT_HCIUART_LL=y
 CONFIG_BT_HCIVHCI=m
 CONFIG_BT_MRVL=m
 
-ifneq ($(CONFIG_PCMCIA),)
+ifdef CONFIG_PCMCIA
 CONFIG_BT_HCIDTL1=m
 CONFIG_BT_HCIBT3C=m
 CONFIG_BT_HCIBLUECARD=m
 CONFIG_BT_HCIBTUART=m
-endif
+endif #CONFIG_PCMCIA
 
 
 # CONFIG_CFG80211_WEXT will be resepected for
@@ -192,19 +192,19 @@ endif
 #
 # For newer kernels we'll just respect your own kernel's
 # autoconf.h
-ifneq ($(CONFIG_WIRELESS_EXT),)
- CONFIG_CFG80211_WEXT=y
-endif
+ifdef CONFIG_WIRELESS_EXT
+CONFIG_CFG80211_WEXT=y
+endif #CONFIG_WIRELESS_EXT
 
 ifneq ($(CONFIG_STAGING),)
-CONFIG_COMPAT_STAGING=m
+ CONFIG_COMPAT_STAGING=m
 endif
 
 # mac80211 test driver
 CONFIG_MAC80211_HWSIM=m
 
 # PCI Drivers
-ifneq ($(CONFIG_PCI),)
+ifdef CONFIG_PCI
 
 CONFIG_ATH5K=m
 # CONFIG_ATH5K_DEBUG=y
@@ -231,9 +231,9 @@ CONFIG_IWL3945=m
 CONFIG_B43=m
 CONFIG_B43_HWRNG=y
 CONFIG_B43_PCI_AUTOSELECT=y
-ifneq ($(CONFIG_PCMCIA),)
+ifdef CONFIG_PCMCIA
 CONFIG_B43_PCMCIA=y
-endif
+endif #CONFIG_PCMCIA
 CONFIG_B43_LEDS=y
 CONFIG_B43_PHY_LP=y
 CONFIG_B43_NPHY=y
@@ -275,7 +275,7 @@ CONFIG_IPW2200_QOS=y
 #
 # % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
 
-ifneq ($(CONFIG_SSB),)
+ifdef CONFIG_SSB
 # Sonics Silicon Backplane
 CONFIG_SSB_SPROM=y
 # CONFIG_SSB_DEBUG=y
@@ -283,12 +283,12 @@ CONFIG_SSB_SPROM=y
 CONFIG_SSB_BLOCKIO=y
 CONFIG_SSB_PCIHOST=y
 CONFIG_SSB_B43_PCI_BRIDGE=y
-ifneq ($(CONFIG_PCMCIA),)
+ifdef CONFIG_PCMCIA
 CONFIG_SSB_PCMCIAHOST=y
-endif
+endif #CONFIG_PCMCIA
 # CONFIG_SSB_DEBUG=y
 CONFIG_SSB_DRIVER_PCICORE=y
-endif
+endif #CONFIG_SSB
 
 CONFIG_P54_PCI=m
 
@@ -302,22 +302,22 @@ CONFIG_ADM8211=m
 CONFIG_RT2X00_LIB_PCI=m
 CONFIG_RT2400PCI=m
 CONFIG_RT2500PCI=m
-ifneq ($(CONFIG_CRC_CCITT),)
+ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800PCI=m
 CONFIG_RT2800PCI_PCI=y
 # CONFIG_RT2800PCI_RT30XX=y
 # CONFIG_RT2800PCI_RT35XX=y
 # CONFIG_RT2800PCI_SOC=y
-endif
+endif #CONFIG_CRC_CCITT
 NEED_RT2X00=y
 
 # Two rt2x00 drivers require firmware: rt61pci and rt73usb. They depend on
 # CRC to check the firmware. We check here first for the PCI
 # driver as we're in the PCI section.
-ifneq ($(CONFIG_CRC_ITU_T),)
+ifdef CONFIG_CRC_ITU_T
 CONFIG_RT61PCI=m
 NEED_RT2X00_FIRMWARE=y
-endif
+endif #CONFIG_CRC_ITU_T
 
 CONFIG_MWL8K=m
 
@@ -333,22 +333,22 @@ endif #CONFIG_COMPAT_KERNEL_27
 
 CONFIG_HERMES=m
 CONFIG_HERMES_CACHE_FW_ON_INIT=y
-ifneq ($(CONFIG_PPC_PMAC),)
+ifdef CONFIG_PPC_PMAC
 CONFIG_APPLE_AIRPORT=m
-endif
+endif #CONFIG_PPC_PMAC
 CONFIG_PLX_HERMES=m
 CONFIG_TMD_HERMES=m
 CONFIG_NORTEL_HERMES=m
 CONFIG_PCI_HERMES=m
-ifneq ($(CONFIG_PCMCIA),)
+ifdef CONFIG_PCMCIA
 CONFIG_PCMCIA_HERMES=m
 CONFIG_PCMCIA_SPECTRUM=m
-endif
+endif #CONFIG_PCMCIA
 
-endif
+endif #CONFIG_PCI
 ## end of PCI
 
-ifneq ($(CONFIG_PCMCIA),)
+ifdef CONFIG_PCMCIA
 
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS=n
@@ -358,14 +358,14 @@ CONFIG_LIBERTAS_CS=m
 NEED_LIBERTAS=y
 endif #CONFIG_COMPAT_KERNEL_27
 
-endif
+endif #CONFIG_PCMCIA
 ## end of PCMCIA
 
 # This is required for some cards
 CONFIG_EEPROM_93CX6=m
 
 # USB Drivers
-ifneq ($(CONFIG_USB),)
+ifdef CONFIG_USB
 CONFIG_ZD1211RW=m
 # CONFIG_ZD1211RW_DEBUG=y
 
@@ -407,19 +407,19 @@ CONFIG_ATH9K_HTC=m
 
 # RT2500USB does not require firmware
 CONFIG_RT2500USB=m
-ifneq ($(CONFIG_CRC_CCITT),)
+ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800USB=m
 CONFIG_RT2800USB_RT30XX=y
 CONFIG_RT2800USB_RT35XX=y
 CONFIG_RT2800USB_UNKNOWN=y
-endif
+endif #CONFIG_CRC_CCITT
 CONFIG_RT2X00_LIB_USB=m
 NEED_RT2X00=y
 # RT73USB requires firmware
-ifneq ($(CONFIG_CRC_ITU_T),)
+ifdef CONFIG_CRC_ITU_T
 CONFIG_RT73USB=m
 NEED_RT2X00_FIRMWARE=y
-endif
+endif #CONFIG_CRC_ITU_T
 
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_THINFIRM_USB=n
@@ -439,15 +439,15 @@ CONFIG_BT_HCIBPA10X=m
 CONFIG_BT_HCIBFUSB=m
 CONFIG_BT_ATH3K=m
 
-endif # end of USB driver list
+endif #CONFIG_USB end of USB driver list
 
-ifneq ($(CONFIG_SPI_MASTER),)
+ifdef CONFIG_SPI_MASTER
 ifndef CONFIG_COMPAT_KERNEL_25
 
-ifneq ($(CONFIG_CRC7),)
+ifdef CONFIG_CRC7
 CONFIG_WL1251_SPI=m
 CONFIG_WL1271_SPI=m
-endif
+endif #CONFIG_CRC7
 CONFIG_P54_SPI=m
 
 ifdef CONFIG_COMPAT_KERNEL_27
@@ -459,21 +459,21 @@ NEED_LIBERTAS=y
 endif #CONFIG_COMPAT_KERNEL_27
 
 endif #CONFIG_COMPAT_KERNEL_25
-endif # end of SPI driver list
+endif #CONFIG_SPI_MASTER end of SPI driver list
 
-ifneq ($(CONFIG_MMC),)
+ifdef CONFIG_MMC
 
 CONFIG_SSB_SDIOHOST=y
 CONFIG_B43_SDIO=y
 
-ifneq ($(CONFIG_CRC7),)
+ifdef CONFIG_CRC7
 CONFIG_WL1251_SDIO=m
 
 ifndef CONFIG_COMPAT_KERNEL_32
 CONFIG_WL1271_SDIO=m
 endif #CONFIG_COMPAT_KERNEL_32
 
-endif
+endif #CONFIG_CRC7
 
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_SDIO=n
@@ -503,7 +503,7 @@ CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
 CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
 CONFIG_ATH6K_LEGACY=m
 endif #CONFIG_COMPAT_KERNEL_32
-endif
+endif #CONFIG_MMC
 
 
 endif # end of SDIO driver list
@@ -538,10 +538,10 @@ CONFIG_ATH_COMMON=m
 # CONFIG_ATH_DEBUG=y
 
 CONFIG_WL12XX=y
-ifneq ($(CONFIG_CRC7),)
+ifdef CONFIG_CRC7
 CONFIG_WL1251=m
 CONFIG_WL1271=m
-endif
+endif #CONFIG_CRC7
 
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS=n
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 5d38ea1..bd189a2 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -195,10 +195,6 @@ if [ -f $KLIB_BUILD/Makefile ]; then
 		echo CONFIG_NETDEVICES_MULTIQUEUE >> $MULT_DEP_FILE
 		define_config_multiple_deps CONFIG_MAC80211_QOS y $ALL_DEPS
 		rm -f $MULT_DEP_FILE
-		# Kernels >= 2.6.32 can disable WEXT :D
-		if [ $SUBLEVEL -le 32 ]; then
-			define_config_dep CONFIG_CFG80211_WEXT 1 CONFIG_WIRELESS_EXT
-		fi
 	fi
 fi
 echo "#endif /* COMPAT_AUTOCONF_INCLUDED */"
-- 
1.7.0.4

