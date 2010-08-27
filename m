Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59834 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab0H0SlX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:41:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/7] compat-wireless: add ifdefs into compat_autoconf.h
Date: Fri, 27 Aug 2010 20:40:52 +0200
Message-Id: <1282934453-18093-7-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
References: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using ifdef or ifndef in config.mk these conditions are now also
written into compat_autoconf.h. This replaces some special handling in
gen-compat-autoconf.sh. This was needed because CONFIG_RT2X00_LIB_LEDS
should only be selected for kernel > 2.6.24.
The script adds ifdefs, ifndefs else and endif into the header file. It
adds endif and else only if it is followed by " #CONFIG_" This is
needed because we do not support something like "ifneq
($(CONFIG_CRC7),)" or "ifeq ($(wildcard $(KLIB_BUILD)/.config),)" for
now.
Now egrep is needed because grep does not support the needed regular
expressions.
The spaces in the egrep part have to be replaced by some other
character, a + is used here.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                      |   50 ++++++++++++++++++++-------------------
 scripts/gen-compat-autoconf.sh |   46 ++++++++++++++++++------------------
 2 files changed, 49 insertions(+), 47 deletions(-)

diff --git a/config.mk b/config.mk
index 110291d..27e2322 100644
--- a/config.mk
+++ b/config.mk
@@ -27,7 +27,7 @@ $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
 
 ifdef CONFIG_COMPAT_KERNEL_25
 $(error "ERROR: compat-wireless by default supports kernels >= 2.6.25, try enabling only one driver though")
-endif
+endif #CONFIG_COMPAT_KERNEL_25
 
 ifeq ($(CONFIG_CFG80211),y)
 $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
@@ -97,13 +97,13 @@ else
  CONFIG_COMPAT_BLUETOOTH=y
  CONFIG_COMPAT_BLUETOOTH_MODULES=m
 endif
-endif # Kernel >= 2.6.26
+endif #CONFIG_COMPAT_KERNEL_27
 
-ifeq ($(CONFIG_COMPAT_KERNEL_33),y)
+ifdef CONFIG_COMPAT_KERNEL_33
 ifneq ($(CONFIG_FW_LOADER),)
  CONFIG_COMPAT_FIRMWARE_CLASS=m
 endif
-endif
+endif #CONFIG_COMPAT_KERNEL_33
 
 
 # Wireless subsystem stuff
@@ -323,9 +323,9 @@ CONFIG_ATL2=m
 CONFIG_ATL1E=m
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_ATL1C=n
-else
+else #CONFIG_COMPAT_KERNEL_27
 CONFIG_ATL1C=m
-endif
+endif #CONFIG_COMPAT_KERNEL_27
 
 CONFIG_HERMES=m
 CONFIG_HERMES_CACHE_FW_ON_INIT=y
@@ -349,10 +349,10 @@ ifneq ($(CONFIG_PCMCIA),)
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS=n
 CONFIG_LIBERTAS_CS=n
-else
+else #CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_CS=m
 NEED_LIBERTAS=y
-endif
+endif #CONFIG_COMPAT_KERNEL_27
 
 endif
 ## end of PCMCIA
@@ -377,12 +377,14 @@ CONFIG_USB_COMPAT_USBNET=n
 CONFIG_USB_NET_COMPAT_RNDIS_HOST=n
 CONFIG_USB_NET_COMPAT_RNDIS_WLAN=n
 CONFIG_USB_NET_COMPAT_CDCETHER=n
-else
+else #CONFIG_COMPAT_KERNEL_29
 CONFIG_USB_COMPAT_USBNET=m
+ifdef CONFIG_USB_NET_CDCETHER
 CONFIG_USB_NET_COMPAT_RNDIS_HOST=m
 CONFIG_USB_NET_COMPAT_RNDIS_WLAN=m
+endif #CONFIG_USB_NET_CDCETHER
 CONFIG_USB_NET_COMPAT_CDCETHER=m
-endif
+endif #CONFIG_COMPAT_KERNEL_29
 
 
 CONFIG_P54_USB=m
@@ -394,7 +396,7 @@ CONFIG_AT76C50X_USB=m
 ifndef CONFIG_COMPAT_KERNEL_28
 CONFIG_AR9170_USB=m
 CONFIG_AR9170_LEDS=y
-endif
+endif #CONFIG_COMPAT_KERNEL_28
 
 CONFIG_ATH9K_HTC=m
 # CONFIG_ATH9K_HTC_DEBUGFS=y
@@ -419,11 +421,11 @@ ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_THINFIRM_USB=n
 CONFIG_LIBERTAS_USB=n
 NEED_LIBERTAS=n
-else
+else #CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_THINFIRM_USB=m
 CONFIG_LIBERTAS_USB=m
 NEED_LIBERTAS=y
-endif
+endif #CONFIG_COMPAT_KERNEL_27
 
 CONFIG_ORINOCO_USB=m
 
@@ -447,12 +449,12 @@ CONFIG_P54_SPI=m
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_SPI=n
 NEED_LIBERTAS=n
-else
+else #CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_SPI=m
 NEED_LIBERTAS=y
-endif
+endif #CONFIG_COMPAT_KERNEL_27
 
-endif
+endif #CONFIG_COMPAT_KERNEL_25
 endif # end of SPI driver list
 
 ifneq ($(CONFIG_MMC),)
@@ -465,17 +467,17 @@ CONFIG_WL1251_SDIO=m
 
 ifndef CONFIG_COMPAT_KERNEL_32
 CONFIG_WL1271_SDIO=m
-endif
+endif #CONFIG_COMPAT_KERNEL_32
 
 endif
 
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_SDIO=n
 NEED_LIBERTAS=n
-else
+else #CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_SDIO=m
 NEED_LIBERTAS=y
-endif
+endif #CONFIG_COMPAT_KERNEL_27
 
 CONFIG_IWM=m
 # CONFIG_IWM_DEBUG=y
@@ -495,9 +497,9 @@ CONFIG_RT2X00_LIB_FIRMWARE=y
 CONFIG_RT2X00_LIB_CRYPTO=y
 ifdef CONFIG_COMPAT_KERNEL_25
 CONFIG_RT2X00_LIB_LEDS=n
-else
+else #CONFIG_COMPAT_KERNEL_25
 CONFIG_RT2X00_LIB_LEDS=y
-endif
+endif #CONFIG_COMPAT_KERNEL_25
 # CONFIG_RT2X00_DEBUG=y
 # CONFIG_RT2X00_LIB_DEBUGFS
 endif
@@ -522,14 +524,14 @@ endif
 
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS=n
-else
+else #CONFIG_COMPAT_KERNEL_27
 ifeq ($(NEED_LIBERTAS),y)
 CONFIG_LIBERTAS_THINFIRM=m
 CONFIG_LIBERTAS=m
 CONFIG_LIBERTAS_MESH=y
 # CONFIG_LIBERTAS_DEBUG=y
 endif
-endif
+endif #CONFIG_COMPAT_KERNEL_27
 
 # We need the backported rfkill module on kernel < 2.6.31.
 # In more recent kernel versions use the in kernel rfkill module.
@@ -537,5 +539,5 @@ ifdef CONFIG_COMPAT_KERNEL_31
 CONFIG_RFKILL_BACKPORT=m
 CONFIG_RFKILL_BACKPORT_LEDS=y
 CONFIG_RFKILL_BACKPORT_INPUT=y
-endif
+endif #CONFIG_COMPAT_KERNEL_31
 
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 1e3002e..7b5773c 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -145,36 +145,36 @@ EOF
 kernel_version_req $OLDEST_KERNEL_SUPPORTED
 
 # For each CONFIG_FOO=x option
-for i in $(grep '^CONFIG_' $COMPAT_CONFIG); do
-	# Get the element on the left of the "="
-	VAR=$(echo $i | cut -d"=" -f 1)
-	# Get the element on the right of the "="
-	VALUE=$(echo $i | cut -d"=" -f 2)
-
-	# skip vars that weren't actually set due to dependencies
-	#if [ "${!VAR}" = "" ] ; then
-	#	continue
-	#fi
-
-	# Handle core kernel module depenencies here.
-	case $VAR in
-	CONFIG_USB_NET_RNDIS_WLAN)
-		define_config_dep $VAR $VALUE CONFIG_USB_NET_CDCETHER
+for i in $(egrep '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else #CONFIG_' $COMPAT_CONFIG | sed 's/ /+/'); do
+	case $i in
+	'ifdef+CONFIG_'* | 'ifndef+CONFIG_'* ) #
+		echo "#$i" | sed 's/+/ /' | sed 's/\(ifdef CONFIG_COMPAT_KERNEL_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/'
 		continue
 		;;
-	CONFIG_USB_NET_RNDIS_HOST)
-		define_config_dep $VAR $VALUE CONFIG_USB_NET_CDCETHER
+	'else+#CONFIG_'* | 'endif+#CONFIG_'* )
+		echo "#$i */" |sed -e 's/+#/ \/* /g'
 		continue
 		;;
-	# ignore this, we have a special hanlder for this at the botttom
-	# instead. We still need to keep this in config.mk to let Makefiles
-	# know its enabled so just ignore it here.
-	CONFIG_MAC80211_QOS)
+	CONFIG_* )
+		# Get the element on the left of the "="
+		VAR=$(echo $i | cut -d"=" -f 1)
+		# Get the element on the right of the "="
+		VALUE=$(echo $i | cut -d"=" -f 2)
+
+		# Handle core kernel module depenencies here.
+		case $VAR in
+		# ignore this, we have a special hanlder for this at the botttom
+		# instead. We still need to keep this in config.mk to let Makefiles
+		# know its enabled so just ignore it here.
+		CONFIG_MAC80211_QOS)
+			continue
+			;;
+		esac
+		# Any other module which can *definitely* be built as a module goes here
+		define_config $VAR $VALUE
 		continue
 		;;
 	esac
-	# Any other module which can *definitely* be built as a module goes here
-	define_config $VAR $VALUE
 done
 
 # Deal with special cases. CONFIG_MAC80211_QOS is such a case.
-- 
1.7.0.4

