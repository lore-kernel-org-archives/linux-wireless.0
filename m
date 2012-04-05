Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2DEMJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 08:09:17 -0400
Message-ID: <1333627753.3494.5.camel@jlt3.sipsolutions.net> (sfid-20120405_140949_403987_61A19668)
Subject: [PATCH] compat-wireless: add export to commented out config vars
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 05 Apr 2012 14:09:13 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This makes it easier to enable config items correctly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---

--- a/config.mk
+++ b/config.mk
@@ -148,22 +148,22 @@ ifndef CONFIG_COMPAT_KERNEL_2_6_33
 export CONFIG_COMPAT_MAC80211_DRIVER_API_TRACER=y
 endif #CONFIG_COMPAT_KERNEL_2_6_33
 
-# CONFIG_MAC80211_DEBUGFS=y
-# CONFIG_MAC80211_NOINLINE=y
-# CONFIG_MAC80211_VERBOSE_DEBUG=y
-# CONFIG_MAC80211_HT_DEBUG=y
-# CONFIG_MAC80211_TKIP_DEBUG=y
-# CONFIG_MAC80211_IBSS_DEBUG=y
-# CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
-# CONFIG_MAC80211_VERBOSE_MPL_DEBUG=y
-# CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG=y
-# CONFIG_MAC80211_VERBOSE_TDLS_DEBUG
-# CONFIG_MAC80211_DEBUG_COUNTERS=y
+# export CONFIG_MAC80211_DEBUGFS=y
+# export CONFIG_MAC80211_NOINLINE=y
+# export CONFIG_MAC80211_VERBOSE_DEBUG=y
+# export CONFIG_MAC80211_HT_DEBUG=y
+# export CONFIG_MAC80211_TKIP_DEBUG=y
+# export CONFIG_MAC80211_IBSS_DEBUG=y
+# export CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
+# export CONFIG_MAC80211_VERBOSE_MPL_DEBUG=y
+# export CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG=y
+# export CONFIG_MAC80211_VERBOSE_TDLS_DEBUG
+# export CONFIG_MAC80211_DEBUG_COUNTERS=y
 
 # choose between pid and minstrel as default rate control algorithm
 export CONFIG_MAC80211_RC_DEFAULT=minstrel_ht
 export CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
-# CONFIG_MAC80211_RC_DEFAULT_PID=y
+# export CONFIG_MAC80211_RC_DEFAULT_PID=y
 # This is the one used by our compat-wireless net/mac80211/rate.c
 # in case you have and old kernel which is overriding this to pid.
 export CONFIG_COMPAT_MAC80211_RC_DEFAULT=minstrel_ht
@@ -179,18 +179,18 @@ export CONFIG_MAC80211_MESH=y
 
 export CONFIG_CFG80211=m
 export CONFIG_CFG80211_DEFAULT_PS=y
-# CONFIG_CFG80211_DEBUGFS=y
-# CONFIG_NL80211_TESTMODE=y
-# CONFIG_CFG80211_DEVELOPER_WARNINGS=y
-# CONFIG_CFG80211_REG_DEBUG=y
-# CONFIG_CFG80211_INTERNAL_REGDB=y
+# export CONFIG_CFG80211_DEBUGFS=y
+# export CONFIG_NL80211_TESTMODE=y
+# export CONFIG_CFG80211_DEVELOPER_WARNINGS=y
+# export CONFIG_CFG80211_REG_DEBUG=y
+# export CONFIG_CFG80211_INTERNAL_REGDB=y
 # See below for wext stuff
 
 export CONFIG_LIB80211=m
 export CONFIG_LIB80211_CRYPT_WEP=m
 export CONFIG_LIB80211_CRYPT_CCMP=m
 export CONFIG_LIB80211_CRYPT_TKIP=m
-# CONFIG_LIB80211_DEBUG=y
+# export CONFIG_LIB80211_DEBUG=y
 
 export CONFIG_BT=m
 export CONFIG_BT_RFCOMM=m
@@ -229,7 +229,7 @@ endif #CONFIG_PCMCIA
 # function on struct wiphy. This struct is shipped with compat-wireless 
 # and changes from kernel version to version. We are using the 
 # wireless_handlers attribute which will be activated by 
-# CONFIG_WIRELESS_EXT. 
+# export CONFIG_WIRELESS_EXT. 
 ifdef CONFIG_WIRELESS_EXT
 export CONFIG_CFG80211_WEXT=y
 else #CONFIG_CFG80211_WEXT
@@ -244,16 +244,16 @@ endif #CONFIG_STAGING
 export CONFIG_MAC80211_HWSIM=m
 
 export CONFIG_ATH5K=m
-# CONFIG_ATH5K_DEBUG=y
-# CONFIG_ATH5K_TRACER=y
-# CONFIG_ATH5K_AHB=y
+# export CONFIG_ATH5K_DEBUG=y
+# export CONFIG_ATH5K_TRACER=y
+# export CONFIG_ATH5K_AHB=y
 
 export CONFIG_ATH9K=m
 export CONFIG_ATH9K_HW=m
 export CONFIG_ATH9K_COMMON=m
-# CONFIG_ATH9K_DEBUGFS=y
-# CONFIG_ATH9K_AHB=y
-# CONFIG_ATH9K_PKTLOG=y
+# export CONFIG_ATH9K_DEBUGFS=y
+# export CONFIG_ATH9K_AHB=y
+# export CONFIG_ATH9K_PKTLOG=y
 
 # Disable this to get minstrel as default, we leave the ath9k
 # rate control algorithm as the default for now as that is also
@@ -273,16 +273,16 @@ export CONFIG_ATH9K_PCI=y
 
 export CONFIG_IWLWIFI=m
 export CONFIG_IWLWIFI_P2P=y
-# CONFIG_IWLWIFI_DEBUG=y
-# CONFIG_IWLWIFI_DEBUGFS=y
-# CONFIG_IWLWIFI_DEVICE_TRACING=y
-# CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
+# export CONFIG_IWLWIFI_DEBUG=y
+# export CONFIG_IWLWIFI_DEBUGFS=y
+# export CONFIG_IWLWIFI_DEVICE_TRACING=y
+# export CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
 
 export CONFIG_IWLEGACY=m
 export CONFIG_COMPAT_IWL4965=m
 export CONFIG_IWL3945=m
-# CONFIG_IWLEGACY_DEBUG=y
-# CONFIG_IWLEGACY_DEBUGFS=y
+# export CONFIG_IWLEGACY_DEBUG=y
+# export CONFIG_IWLEGACY_DEBUGFS=y
 
 
 export CONFIG_B43=m
@@ -297,8 +297,8 @@ endif #CONFIG_MAC80211_LEDS
 export CONFIG_B43_PHY_LP=y
 export CONFIG_B43_PHY_N=y
 export CONFIG_B43_PHY_HT=y
-# CONFIG_B43_PHY_LCN=y
-# CONFIG_B43_DEBUG=y
+# export CONFIG_B43_PHY_LCN=y
+# export CONFIG_B43_DEBUG=y
 
 export CONFIG_B43LEGACY=m
 export CONFIG_B43LEGACY_HWRNG=y
@@ -306,24 +306,24 @@ export CONFIG_B43LEGACY_PCI_AUTOSELECT=y
 ifdef CONFIG_MAC80211_LEDS
 export CONFIG_B43LEGACY_LEDS=y
 endif #CONFIG_MAC80211_LEDS
-# CONFIG_B43LEGACY_DEBUG=y
+# export CONFIG_B43LEGACY_DEBUG=y
 export CONFIG_B43LEGACY_DMA=y
 export CONFIG_B43LEGACY_PIO=y
 
 ifdef CONFIG_WIRELESS_EXT
 # The Intel ipws
 export CONFIG_LIBIPW=m
-# CONFIG_LIBIPW_DEBUG=y
+# export CONFIG_LIBIPW_DEBUG=y
 
 export CONFIG_IPW2100=m
 export CONFIG_IPW2100_MONITOR=y
-# CONFIG_IPW2100_DEBUG=y
+# export CONFIG_IPW2100_DEBUG=y
 export CONFIG_IPW2200=m
 export CONFIG_IPW2200_MONITOR=y
 export CONFIG_IPW2200_RADIOTAP=y
 export CONFIG_IPW2200_PROMISCUOUS=y
 export CONFIG_IPW2200_QOS=y
-# CONFIG_IPW2200_DEBUG=y
+# export CONFIG_IPW2200_DEBUG=y
 # The above enables use a second interface prefixed 'rtap'.
 #           Example usage:
 #
@@ -348,7 +348,7 @@ export CONFIG_SSB_B43_PCI_BRIDGE=y
 ifdef CONFIG_PCMCIA
 export CONFIG_SSB_PCMCIAHOST=y
 endif #CONFIG_PCMCIA
-# CONFIG_SSB_DEBUG=y
+# export CONFIG_SSB_DEBUG=y
 export CONFIG_SSB_DRIVER_PCICORE=y
 export CONFIG_B43_SSB=y
 endif #CONFIG_SSB
@@ -356,7 +356,7 @@ endif #CONFIG_SSB
 export CONFIG_BCMA=m
 export CONFIG_BCMA_BLOCKIO=y
 export CONFIG_BCMA_HOST_PCI=y
-# CONFIG_BCMA_DEBUG=y
+# export CONFIG_BCMA_DEBUG=y
 export CONFIG_B43_BCMA=y
 export CONFIG_B43_BCMA_EXTRA=y
 
@@ -448,7 +448,7 @@ export CONFIG_EEPROM_93CX6=m
 ifdef CONFIG_USB
 ifndef CONFIG_COMPAT_KERNEL_2_6_29
 export CONFIG_COMPAT_ZD1211RW=m
-# CONFIG_ZD1211RW_DEBUG=y
+# export CONFIG_ZD1211RW_DEBUG=y
 endif #CONFIG_COMPAT_KERNEL_2_6_29
 
 # Sorry, rndis_wlan uses cancel_work_sync which is new and can't be done in compat...
@@ -490,7 +490,7 @@ export CONFIG_CARL9170=m
 ifdef CONFIG_MAC80211_LEDS
 export CONFIG_CARL9170_LEDS=y
 endif #CONFIG_MAC80211_LEDS
-# CONFIG_CARL9170_DEBUGFS=y
+# export CONFIG_CARL9170_DEBUGFS=y
 export CONFIG_CARL9170_WPC=y
 endif #CONFIG_COMPAT_KERNEL_2_6_29
 
@@ -500,7 +500,7 @@ endif #CONFIG_COMPAT_KERNEL_2_6_29
 export CONFIG_COMPAT_USB_URB_THREAD_FIX=y
 
 export CONFIG_ATH9K_HTC=m
-# CONFIG_ATH9K_HTC_DEBUGFS=y
+# export CONFIG_ATH9K_HTC_DEBUGFS=y
 
 # RT2500USB does not require firmware
 export CONFIG_RT2500USB=m
@@ -586,15 +586,15 @@ NEED_LIBERTAS=y
 endif #CONFIG_COMPAT_KERNEL_2_6_32
 
 export CONFIG_IWM=m
-# CONFIG_IWM_DEBUG=y
-# CONFIG_IWM_TRACING=y
+# export CONFIG_IWM_DEBUG=y
+# export CONFIG_IWM_TRACING=y
 
 export CONFIG_BT_HCIBTSDIO=m
 export CONFIG_BT_MRVL_SDIO=m
 
 ifndef CONFIG_COMPAT_KERNEL_2_6_27
 export CONFIG_ATH6KL=m
-# CONFIG_ATH6KL_DEBUG=y
+# export CONFIG_ATH6KL_DEBUG=y
 endif #CONFIG_COMPAT_KERNEL_2_6_27
 
 ifndef CONFIG_COMPAT_KERNEL_2_6_29
@@ -614,7 +614,7 @@ export CONFIG_RT2X00_LIB=m
 export CONFIG_RT2800_LIB=m
 export CONFIG_RT2X00_LIB_FIRMWARE=y
 export CONFIG_RT2X00_LIB_CRYPTO=y
-# CONFIG_RT2X00_LIB_SOC=y
+# export CONFIG_RT2X00_LIB_SOC=y
 ifdef CONFIG_COMPAT_KERNEL_2_6_25
 export CONFIG_RT2X00_LIB_LEDS=n
 else #CONFIG_COMPAT_KERNEL_2_6_25
@@ -622,8 +622,8 @@ ifdef CONFIG_LEDS_CLASS
 export CONFIG_RT2X00_LIB_LEDS=y
 endif #CONFIG_LEDS_CLASS
 endif #CONFIG_COMPAT_KERNEL_2_6_25
-# CONFIG_RT2X00_DEBUG=y
-# CONFIG_RT2X00_LIB_DEBUGFS=y
+# export CONFIG_RT2X00_DEBUG=y
+# export CONFIG_RT2X00_LIB_DEBUGFS=y
 endif
 
 # p54
@@ -634,10 +634,10 @@ endif #CONFIG_MAC80211_LEDS
 
 # Atheros
 export CONFIG_ATH_COMMON=m
-# CONFIG_ATH_DEBUG=y
+# export CONFIG_ATH_DEBUG=y
 
 export CONFIG_BRCMUTIL=m
-# CONFIG_BRCMDBG=y
+# export CONFIG_BRCMDBG=y
 
 ifdef CONFIG_CRC7
 export CONFIG_WL1251=m
@@ -661,7 +661,7 @@ ifeq ($(NEED_LIBERTAS),y)
 export CONFIG_LIBERTAS_THINFIRM=m
 export CONFIG_LIBERTAS=m
 export CONFIG_LIBERTAS_MESH=y
-# CONFIG_LIBERTAS_DEBUG=y
+# export CONFIG_LIBERTAS_DEBUG=y
 endif
 endif #CONFIG_COMPAT_KERNEL_2_6_27
 


