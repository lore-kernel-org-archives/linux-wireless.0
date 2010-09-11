Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33779 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab0IKQTJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:19:09 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/8] compat-wireless: add conditions form config into compat_autoconf.h
Date: Sat, 11 Sep 2010 18:18:30 +0200
Message-Id: <1284221913-22455-7-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284221913-22455-1-git-send-email-hauke@hauke-m.de>
References: <1284221913-22455-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not have to use "ifneq ($(CONFIG_...),)", "ifdef CONFIG_..." will
also work. It does not matter if it was set to m or y.
Now this can be added into compat_autoconf.h without changing the script.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   86 ++++++++++++++++++++++++++++++------------------------------
 1 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/config.mk b/config.mk
index 8b0038c..b7ef1ce 100644
--- a/config.mk
+++ b/config.mk
@@ -102,9 +102,9 @@ endif
 endif #CONFIG_COMPAT_KERNEL_27
 
 ifdef CONFIG_COMPAT_KERNEL_33
-ifneq ($(CONFIG_FW_LOADER),)
+ifdef CONFIG_FW_LOADER
  CONFIG_COMPAT_FIRMWARE_CLASS=m
-endif
+endif #CONFIG_FW_LOADER
 endif #CONFIG_COMPAT_KERNEL_33
 
 
@@ -161,9 +161,9 @@ CONFIG_BT_BNEP=m
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
@@ -175,12 +175,12 @@ CONFIG_BT_HCIUART_LL=y
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
@@ -194,19 +194,19 @@ endif
 #
 # For newer kernels we'll just respect your own kernel's
 # autoconf.h
-ifneq ($(CONFIG_WIRELESS_EXT),)
+ifdef CONFIG_WIRELESS_EXT
  CONFIG_CFG80211_WEXT=y
-endif
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
@@ -233,9 +233,9 @@ CONFIG_IWL3945=m
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
@@ -282,7 +282,7 @@ endif #CONFIG_WEXT_PRIV
 endif #CONFIG_WEXT_SPY
 endif #CONFIG_WIRELESS_EXT
 
-ifneq ($(CONFIG_SSB),)
+ifdef CONFIG_SSB
 # Sonics Silicon Backplane
 CONFIG_SSB_SPROM=y
 # CONFIG_SSB_DEBUG=y
@@ -290,12 +290,12 @@ CONFIG_SSB_SPROM=y
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
 
@@ -309,22 +309,22 @@ CONFIG_ADM8211=m
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
 
@@ -343,25 +343,25 @@ ifdef CONFIG_WEXT_SPY
 ifdef CONFIG_WEXT_PRIV
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
 endif #CONFIG_WEXT_PRIV
 endif #CONFIG_WEXT_SPY
 endif #CONFIG_WIRELESS_EXT
 
-endif
+endif #CONFIG_PCI
 ## end of PCI
 
-ifneq ($(CONFIG_PCMCIA),)
+ifdef CONFIG_PCMCIA
 
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS=n
@@ -371,14 +371,14 @@ CONFIG_LIBERTAS_CS=m
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
 
@@ -420,19 +420,19 @@ CONFIG_ATH9K_HTC=m
 
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
@@ -452,15 +452,15 @@ CONFIG_BT_HCIBPA10X=m
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
@@ -472,21 +472,21 @@ NEED_LIBERTAS=y
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
@@ -516,7 +516,7 @@ CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
 CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
 CONFIG_ATH6K_LEGACY=m
 endif #CONFIG_WIRELESS_EXT
-endif
+endif #CONFIG_MMC
 
 
 endif # end of SDIO driver list
@@ -551,10 +551,10 @@ CONFIG_ATH_COMMON=m
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
-- 
1.7.0.4

