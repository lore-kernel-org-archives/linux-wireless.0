Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60479 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab1FBQfk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:35:40 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/9] compat-wireless: rename CONFIG_COMPAT_KERNEL_
Date: Thu,  2 Jun 2011 18:35:18 +0200
Message-Id: <1307032525-18916-3-git-send-email-hauke@hauke-m.de> (sfid-20110602_183603_834175_5D50D9CE)
In-Reply-To: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
References: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename CONFIG_COMPAT_KERNEL_XX to CONFIG_COMPAT_KERNEL_26XX.
This is needed to support kernel version 3.XX. It will get
CONFIG_COMPAT_KERNEL_3XX. This patch needs a additional change in
compat.git.

Add to compat-3.0-stable

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                      |   86 ++++++++++++++++++++--------------------
 scripts/gen-compat-autoconf.sh |    4 +-
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/config.mk b/config.mk
index 9a18441..57903e0 100644
--- a/config.mk
+++ b/config.mk
@@ -18,11 +18,11 @@ ifneq ($(wildcard $(KLIB_BUILD)/Makefile),)
 COMPAT_LATEST_VERSION = 39
 KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
 COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
-$(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
+$(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_26$(ver)=y))
 
-ifdef CONFIG_COMPAT_KERNEL_24
+ifdef CONFIG_COMPAT_KERNEL_2624
 $(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
-endif #CONFIG_COMPAT_KERNEL_24
+endif #CONFIG_COMPAT_KERNEL_2624
 
 ifeq ($(CONFIG_CFG80211),y)
 $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
@@ -92,20 +92,20 @@ else
 endif
 
 # The Bluetooth compatibility only builds on kernels >= 2.6.27 for now
-ifndef CONFIG_COMPAT_KERNEL_27
+ifndef CONFIG_COMPAT_KERNEL_2627
 ifeq ($(CONFIG_BT),y)
 # we'll ignore compiling bluetooth
 else
  CONFIG_COMPAT_BLUETOOTH=y
  CONFIG_COMPAT_BLUETOOTH_MODULES=m
 endif
-endif #CONFIG_COMPAT_KERNEL_27
+endif #CONFIG_COMPAT_KERNEL_2627
 
-ifdef CONFIG_COMPAT_KERNEL_33
+ifdef CONFIG_COMPAT_KERNEL_2633
 ifdef CONFIG_FW_LOADER
  CONFIG_COMPAT_FIRMWARE_CLASS=m
 endif #CONFIG_FW_LOADER
-endif #CONFIG_COMPAT_KERNEL_33
+endif #CONFIG_COMPAT_KERNEL_2633
 
 # Wireless subsystem stuff
 CONFIG_MAC80211=m
@@ -165,9 +165,9 @@ CONFIG_BT_BNEP_PROTO_FILTER=y
 ifdef CONFIG_ISDN_CAPI
 CONFIG_BT_CMTP=m
 endif #CONFIG_ISDN_CAPI
-ifndef CONFIG_COMPAT_KERNEL_28
+ifndef CONFIG_COMPAT_KERNEL_2628
 CONFIG_COMPAT_BT_HIDP=m
-endif #CONFIG_COMPAT_KERNEL_28
+endif #CONFIG_COMPAT_KERNEL_2628
 
 CONFIG_BT_HCIUART=M
 CONFIG_BT_HCIUART_H4=y
@@ -345,11 +345,11 @@ CONFIG_MWL8K=m
 CONFIG_ATL1=m
 CONFIG_ATL2=m
 CONFIG_ATL1E=m
-ifdef CONFIG_COMPAT_KERNEL_27
+ifdef CONFIG_COMPAT_KERNEL_2627
 CONFIG_ATL1C=n
-else #CONFIG_COMPAT_KERNEL_27
+else #CONFIG_COMPAT_KERNEL_2627
 CONFIG_ATL1C=m
-endif #CONFIG_COMPAT_KERNEL_27
+endif #CONFIG_COMPAT_KERNEL_2627
 
 ifdef CONFIG_WIRELESS_EXT
 CONFIG_HERMES=m
@@ -379,13 +379,13 @@ endif #CONFIG_PCI
 
 ifdef CONFIG_PCMCIA
 
-ifdef CONFIG_COMPAT_KERNEL_27
+ifdef CONFIG_COMPAT_KERNEL_2627
 CONFIG_LIBERTAS=n
 CONFIG_LIBERTAS_CS=n
-else #CONFIG_COMPAT_KERNEL_27
+else #CONFIG_COMPAT_KERNEL_2627
 CONFIG_LIBERTAS_CS=m
 NEED_LIBERTAS=y
-endif #CONFIG_COMPAT_KERNEL_27
+endif #CONFIG_COMPAT_KERNEL_2627
 
 endif #CONFIG_PCMCIA
 ## end of PCMCIA
@@ -395,10 +395,10 @@ CONFIG_EEPROM_93CX6=m
 
 # USB Drivers
 ifdef CONFIG_USB
-ifndef CONFIG_COMPAT_KERNEL_29
+ifndef CONFIG_COMPAT_KERNEL_2629
 CONFIG_COMPAT_ZD1211RW=m
 # CONFIG_ZD1211RW_DEBUG=y
-endif #CONFIG_COMPAT_KERNEL_29
+endif #CONFIG_COMPAT_KERNEL_2629
 
 # Sorry, rndis_wlan uses cancel_work_sync which is new and can't be done in compat...
 
@@ -407,12 +407,12 @@ endif #CONFIG_COMPAT_KERNEL_29
 # is only wireless RNDIS chip known to date.
 # Note: this depends on CONFIG_USB_NET_RNDIS_HOST and CONFIG_USB_NET_CDCETHER
 # it also requires new RNDIS_HOST and CDC_ETHER modules which we add
-ifdef CONFIG_COMPAT_KERNEL_29
+ifdef CONFIG_COMPAT_KERNEL_2629
 CONFIG_USB_COMPAT_USBNET=n
 CONFIG_USB_NET_COMPAT_RNDIS_HOST=n
 CONFIG_USB_NET_COMPAT_RNDIS_WLAN=n
 CONFIG_USB_NET_COMPAT_CDCETHER=n
-else #CONFIG_COMPAT_KERNEL_29
+else #CONFIG_COMPAT_KERNEL_2629
 CONFIG_USB_COMPAT_USBNET=m
 ifdef CONFIG_USB_NET_CDCETHER
 CONFIG_USB_NET_COMPAT_RNDIS_HOST=m
@@ -423,7 +423,7 @@ CONFIG_USB_NET_COMPAT_RNDIS_HOST=m
 CONFIG_USB_NET_COMPAT_RNDIS_WLAN=m
 endif #CONFIG_USB_NET_CDCETHER
 CONFIG_USB_NET_COMPAT_CDCETHER=m
-endif #CONFIG_COMPAT_KERNEL_29
+endif #CONFIG_COMPAT_KERNEL_2629
 
 
 CONFIG_P54_USB=m
@@ -434,14 +434,14 @@ endif #CONFIG_MAC80211_LEDS
 
 CONFIG_AT76C50X_USB=m
 
-ifndef CONFIG_COMPAT_KERNEL_29
+ifndef CONFIG_COMPAT_KERNEL_2629
 CONFIG_CARL9170=m
 ifdef CONFIG_MAC80211_LEDS
 CONFIG_CARL9170_LEDS=y
 endif #CONFIG_MAC80211_LEDS
 # CONFIG_CARL9170_DEBUGFS=y
 # CONFIG_CARL9170_WPC=y
-endif #CONFIG_COMPAT_KERNEL_29
+endif #CONFIG_COMPAT_KERNEL_2629
 
 # This activates a threading fix for usb urb.
 # this is mainline commit: b3e670443b7fb8a2d29831b62b44a039c283e351
@@ -467,15 +467,15 @@ ifdef CONFIG_CRC_ITU_T
 CONFIG_RT73USB=m
 endif #CONFIG_CRC_ITU_T
 
-ifdef CONFIG_COMPAT_KERNEL_27
+ifdef CONFIG_COMPAT_KERNEL_2627
 CONFIG_LIBERTAS_THINFIRM_USB=n
 CONFIG_LIBERTAS_USB=n
 NEED_LIBERTAS=n
-else #CONFIG_COMPAT_KERNEL_27
+else #CONFIG_COMPAT_KERNEL_2627
 CONFIG_LIBERTAS_THINFIRM_USB=m
 CONFIG_LIBERTAS_USB=m
 NEED_LIBERTAS=y
-endif #CONFIG_COMPAT_KERNEL_27
+endif #CONFIG_COMPAT_KERNEL_2627
 
 CONFIG_ORINOCO_USB=m
 
@@ -490,7 +490,7 @@ CONFIG_RTL8192CU=m
 endif #CONFIG_USB end of USB driver list
 
 ifdef CONFIG_SPI_MASTER
-ifndef CONFIG_COMPAT_KERNEL_25
+ifndef CONFIG_COMPAT_KERNEL_2625
 
 ifdef CONFIG_CRC7
 CONFIG_WL1251_SPI=m
@@ -498,15 +498,15 @@ CONFIG_WL12XX_SPI=m
 endif #CONFIG_CRC7
 CONFIG_P54_SPI=m
 
-ifdef CONFIG_COMPAT_KERNEL_27
+ifdef CONFIG_COMPAT_KERNEL_2627
 CONFIG_LIBERTAS_SPI=n
 NEED_LIBERTAS=n
-else #CONFIG_COMPAT_KERNEL_27
+else #CONFIG_COMPAT_KERNEL_2627
 CONFIG_LIBERTAS_SPI=m
 NEED_LIBERTAS=y
-endif #CONFIG_COMPAT_KERNEL_27
+endif #CONFIG_COMPAT_KERNEL_2627
 
-endif #CONFIG_COMPAT_KERNEL_25
+endif #CONFIG_COMPAT_KERNEL_2625
 endif #CONFIG_SPI_MASTER end of SPI driver list
 
 ifdef CONFIG_MMC
@@ -519,23 +519,23 @@ ifdef CONFIG_WL12XX_PLATFORM_DATA
 CONFIG_COMPAT_WL1251_SDIO=m
 endif #CONFIG_WL12XX_PLATFORM_DATA
 
-ifndef CONFIG_COMPAT_KERNEL_32
+ifndef CONFIG_COMPAT_KERNEL_2632
 ifdef CONFIG_WL12XX_PLATFORM_DATA
 CONFIG_COMPAT_WL12XX_SDIO=m
 endif #CONFIG_WL12XX_PLATFORM_DATA
-endif #CONFIG_COMPAT_KERNEL_32
+endif #CONFIG_COMPAT_KERNEL_2632
 
 endif #CONFIG_CRC7
 
 CONFIG_MWIFIEX_SDIO=m
 
-ifdef CONFIG_COMPAT_KERNEL_27
+ifdef CONFIG_COMPAT_KERNEL_2627
 CONFIG_LIBERTAS_SDIO=n
 NEED_LIBERTAS=n
-else #CONFIG_COMPAT_KERNEL_27
+else #CONFIG_COMPAT_KERNEL_2627
 CONFIG_LIBERTAS_SDIO=m
 NEED_LIBERTAS=y
-endif #CONFIG_COMPAT_KERNEL_27
+endif #CONFIG_COMPAT_KERNEL_2627
 
 CONFIG_IWM=m
 # CONFIG_IWM_DEBUG=y
@@ -574,13 +574,13 @@ CONFIG_RT2800_LIB=m
 CONFIG_RT2X00_LIB_FIRMWARE=y
 CONFIG_RT2X00_LIB_CRYPTO=y
 # CONFIG_RT2X00_LIB_SOC=y
-ifdef CONFIG_COMPAT_KERNEL_25
+ifdef CONFIG_COMPAT_KERNEL_2625
 CONFIG_RT2X00_LIB_LEDS=n
-else #CONFIG_COMPAT_KERNEL_25
+else #CONFIG_COMPAT_KERNEL_2625
 ifdef CONFIG_LEDS_CLASS
 CONFIG_RT2X00_LIB_LEDS=y
 endif #CONFIG_LEDS_CLASS
-endif #CONFIG_COMPAT_KERNEL_25
+endif #CONFIG_COMPAT_KERNEL_2625
 # CONFIG_RT2X00_DEBUG=y
 # CONFIG_RT2X00_LIB_DEBUGFS
 endif
@@ -608,24 +608,24 @@ endif #CONFIG_CRC7
 
 CONFIG_MWIFIEX=m
 
-ifdef CONFIG_COMPAT_KERNEL_27
+ifdef CONFIG_COMPAT_KERNEL_2627
 CONFIG_LIBERTAS=n
-else #CONFIG_COMPAT_KERNEL_27
+else #CONFIG_COMPAT_KERNEL_2627
 ifeq ($(NEED_LIBERTAS),y)
 CONFIG_LIBERTAS_THINFIRM=m
 CONFIG_LIBERTAS=m
 CONFIG_LIBERTAS_MESH=y
 # CONFIG_LIBERTAS_DEBUG=y
 endif
-endif #CONFIG_COMPAT_KERNEL_27
+endif #CONFIG_COMPAT_KERNEL_2627
 
 # We need the backported rfkill module on kernel < 2.6.31.
 # In more recent kernel versions use the in kernel rfkill module.
-ifdef CONFIG_COMPAT_KERNEL_31
+ifdef CONFIG_COMPAT_KERNEL_2631
 CONFIG_RFKILL_BACKPORT=m
 ifdef CONFIG_LEDS_TRIGGERS
 CONFIG_RFKILL_BACKPORT_LEDS=y
 endif #CONFIG_LEDS_TRIGGERS
 CONFIG_RFKILL_BACKPORT_INPUT=y
-endif #CONFIG_COMPAT_KERNEL_31
+endif #CONFIG_COMPAT_KERNEL_2631
 
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 9f6e6d2..0dc091c 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -148,11 +148,11 @@ kernel_version_req $OLDEST_KERNEL_SUPPORTED
 for i in $(egrep '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else #CONFIG_' $COMPAT_CONFIG | sed 's/ /+/'); do
 	case $i in
 	'ifdef+CONFIG_'* )
-		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifdef \)\(CONFIG_[^:space:]*\)/#if defined(\2) || defined(\2_MODULE)/'
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_26\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifdef \)\(CONFIG_[^:space:]*\)/#if defined(\2) || defined(\2_MODULE)/'
 		continue
 		;;
 	'ifndef+CONFIG_'* )
-		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_26\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
 		continue
 		;;
 	'else+#CONFIG_'* | 'endif+#CONFIG_'* )
-- 
1.7.4.1

