Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54899 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623Ab0BMR0g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 12:26:36 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: update config options
Date: Sat, 13 Feb 2010 18:26:28 +0100
Message-Id: <1266081988-16012-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1266081988-16012-1-git-send-email-hauke@hauke-m.de>
References: <1266081988-16012-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed some not reverenced config options.
Doing grep for the removed options had no result.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   32 ++++++++------------------------
 1 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/config.mk b/config.mk
index 0cad764..5565e12 100644
--- a/config.mk
+++ b/config.mk
@@ -9,7 +9,6 @@ ifeq ($(wildcard $(KLIB_BUILD)/.config),)
  CONFIG_PCI=y
  CONFIG_USB=y
  CONFIG_PCMCIA=y
- CONFIG_SSB_POSSIBLE=y
  CONFIG_SSB=m
 else
 include $(KLIB_BUILD)/.config
@@ -112,7 +111,6 @@ CONFIG_MAC80211=m
 
 # CONFIG_MAC80211_DEBUGFS=y
 # CONFIG_MAC80211_DEBUG_MENU=y
-# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=y
 # CONFIG_MAC80211_NOINLINE=y
 # CONFIG_MAC80211_VERBOSE_DEBUG=y
 # CONFIG_MAC80211_HT_DEBUG=y
@@ -201,7 +199,6 @@ CONFIG_ATH9K_COMMON=m
 
 
 CONFIG_IWLWIFI=m
-CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=y
 # CONFIG_IWLWIFI_DEBUG=y
 # CONFIG_IWLWIFI_DEBUGFS=y
 # CONFIG_IWLWIFI_DEVICE_TRACING=y
@@ -209,33 +206,26 @@ CONFIG_IWLAGN=m
 CONFIG_COMPAT_IWL4965=y
 CONFIG_IWL5000=y
 CONFIG_IWL3945=m
-CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
 
 
 CONFIG_B43=m
 CONFIG_B43_HWRNG=y
 CONFIG_B43_PCI_AUTOSELECT=y
-CONFIG_B43_PCICORE_AUTOSELECT=y
 ifneq ($(CONFIG_PCMCIA),)
 CONFIG_B43_PCMCIA=y
 endif
-CONFIG_B43_PIO=y
 CONFIG_B43_LEDS=y
 CONFIG_B43_PHY_LP=y
+CONFIG_B43_NPHY=y
 # CONFIG_B43_DEBUG=y
-# CONFIG_B43_FORCE_PIO=y
 
 CONFIG_B43LEGACY=m
 CONFIG_B43LEGACY_HWRNG=y
 CONFIG_B43LEGACY_PCI_AUTOSELECT=y
-CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
 CONFIG_B43LEGACY_LEDS=y
 # CONFIG_B43LEGACY_DEBUG=y
 CONFIG_B43LEGACY_DMA=y
 CONFIG_B43LEGACY_PIO=y
-CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
-# CONFIG_B43LEGACY_DMA_MODE=y
-# CONFIG_B43LEGACY_PIO_MODE=y
 
 # The Intel ipws
 CONFIG_LIBIPW=m
@@ -270,31 +260,23 @@ CONFIG_SSB_SPROM=y
 # CONFIG_SSB_DEBUG=y
 
 CONFIG_SSB_BLOCKIO=y
-CONFIG_SSB_PCIHOST_POSSIBLE=y
 CONFIG_SSB_PCIHOST=y
 CONFIG_SSB_B43_PCI_BRIDGE=y
 ifneq ($(CONFIG_PCMCIA),)
-CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
 CONFIG_SSB_PCMCIAHOST=y
 endif
 # CONFIG_SSB_DEBUG=y
-CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
 CONFIG_SSB_DRIVER_PCICORE=y
 endif
 
 CONFIG_P54_PCI=m
 
 CONFIG_B44=m
-CONFIG_B44_PCI_AUTOSELECT=y
-CONFIG_B44_PCICORE_AUTOSELECT=y
 CONFIG_B44_PCI=y
 
 CONFIG_RTL8180=m
 
 CONFIG_ADM8211=m
-ifneq ($(CONFIG_PCMCIA),)
-CONFIG_PCMCIA_ATMEL=m
-endif
 
 CONFIG_RT2X00_LIB_PCI=m
 CONFIG_RT2400PCI=m
@@ -311,9 +293,6 @@ CONFIG_RT61PCI=m
 NEED_RT2X00_FIRMWARE=y
 endif
 
-CONFIG_ATMEL=m
-CONFIG_PCI_ATMEL=m
-
 CONFIG_MWL8K=m
 
 # Ethernet drivers go here
@@ -403,6 +382,7 @@ endif # end of USB driver list
 ifneq ($(CONFIG_SPI_MASTER),)
 
 CONFIG_WL1251=m
+CONFIG_WL1251_SPI=m
 CONFIG_P54_SPI=m
 
 ifdef CONFIG_COMPAT_KERNEL_27
@@ -417,6 +397,10 @@ endif # end of SPI driver list
 
 ifneq ($(CONFIG_MMC),)
 
+CONFIG_SSB_SDIOHOST=y
+CONFIG_B43_SDIO=y
+CONFIG_WL1251_SDIO=m
+
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_SDIO=n
 NEED_LIBERTAS=n
@@ -444,6 +428,7 @@ CONFIG_RT2X00_LIB_FIRMWARE=y
 CONFIG_RT2X00_LIB_CRYPTO=y
 CONFIG_RT2X00_LIB_LEDS=y
 # CONFIG_RT2X00_DEBUG=y
+# CONFIG_RT2X00_LIB_DEBUGFS
 endif
 
 ifeq ($(NEED_RT2X00_FIRMWARE),y)
@@ -460,8 +445,6 @@ CONFIG_ATH_COMMON=m
 
 CONFIG_WL12XX=y
 CONFIG_WL1251=m
-CONFIG_WL1251_SPI=m
-CONFIG_WL1251_SDIO=m
 CONFIG_WL1271=m
 
 ifdef CONFIG_COMPAT_KERNEL_27
@@ -470,6 +453,7 @@ else
 ifeq ($(NEED_LIBERTAS),y)
 CONFIG_LIBERTAS_THINFIRM=m
 CONFIG_LIBERTAS=m
+CONFIG_LIBERTAS_MESH=y
 # CONFIG_LIBERTAS_DEBUG=y
 endif
 endif
-- 
1.6.3.3

