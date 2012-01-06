Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43040 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758788Ab2AFQTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 11:19:30 -0500
Subject: [PATCH] compat-wireless: Handle name change from iwlagn to iwlwifi
 in 3.2
From: Don Fry <donald.h.fry@intel.com>
To: mcgrof@frijolero.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Jan 2012 08:18:51 -0800
Message-ID: <1325866731.9160.3.camel@dfry-linux1> (sfid-20120106_171934_327784_23D8F766)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

With linux-3.2 the iwlagn driver is renamed iwlwifi.  For some kernels
(like 3.1.5) this causes the non-compat iwlagn.ko to try and run against
the compat mac80211 resulting in a kernel oops.  This change prevents the
non-compat iwlagn.ko from being loaded.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
---
 Makefile            |   17 +++++++++++++++--
 scripts/iwl-enable  |   11 ++++++++++-
 scripts/unload.sh   |    2 +-
 scripts/wlunload.sh |    2 +-
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index d3a9d93..d66ebe4 100644
--- a/Makefile
+++ b/Makefile
@@ -9,7 +9,9 @@ export KLIB_BUILD ?=	$(KLIB)/build
 # Sometimes not available in the path
 MODPROBE := /sbin/modprobe
 MADWIFI=$(shell $(MODPROBE) -l ath_pci)
-OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
+NEW_IWL=$(shell $(MODPROBE) -l iwlwifi)
+OLD_IWL=$(shell $(MODPROBE) -l iwlagn)
+ANCIENT_IWL=$(shell $(MODPROBE) -l iwl4965)
 
 DESTDIR?=
 
@@ -187,7 +189,7 @@ install-scripts:
 		echo Running athenable ath5k...;\
 		/usr/sbin/athenable ath5k ;\
 	fi
-	@if [ ! -z "$(OLD_IWL)" ] && [ -z "$(DESTDIR)" ]; then \
+	@if [ ! -z "$(ANCIENT_IWL)" ] && [ ! -z "$(OLD_IWL)" ] && [ -z "$(DESTDIR)" ]; then \
 		echo ;\
 		echo -n "Note: iwl4965 detected, we're going to disable it. "  ;\
 		echo "If you would like to enable it later you can run:"  ;\
@@ -196,6 +198,15 @@ install-scripts:
 		echo Running iwl-enable iwlagn...;\
 		/usr/sbin/iwl-enable iwlagn ;\
 	fi
+	@if [ ! -z "$(NEW_IWL)" ] && [ ! -z "$(OLD_IWL)" ] && [ -z "$(DESTDIR)" ]; then \
+		echo ;\
+		echo -n "Note: iwlagn detected, we're going to disable it. "  ;\
+		echo "If you would like to enable it later you can run:"  ;\
+		echo "    sudo iwl-load iwlagn"  ;\
+		echo ;\
+		echo Running iwl-enable iwlwifi...;\
+		/usr/sbin/iwl-enable iwlwifi ;\
+	fi
 	@# If on distributions like Mandriva which like to
 	@# compress their modules this will find out and do
 	@# it for you. Reason is some old version of modutils
@@ -234,6 +245,7 @@ install-scripts:
 	@$(MODPROBE) -l ipw2200
 	@$(MODPROBE) -l iwl3945
 	@$(MODPROBE) -l iwlagn
+	@$(MODPROBE) -l iwlwifi
 	@$(MODPROBE) -l iwlcore
 	@$(MODPROBE) -l iwmc3200wifi
 	@$(MODPROBE) -l lib80211_crypt_ccmp
@@ -364,6 +376,7 @@ uninstall:
 	@$(MODPROBE) -l ipw2100
 	@$(MODPROBE) -l ipw2200
 	@$(MODPROBE) -l iwl3945
+	@$(MODPROBE) -l iwlwifi
 	@$(MODPROBE) -l iwlagn
 	@$(MODPROBE) -l iwlcore
 	@$(MODPROBE) -l iwmc3200wifi
diff --git a/scripts/iwl-enable b/scripts/iwl-enable
index 765195b..0737024 100755
--- a/scripts/iwl-enable
+++ b/scripts/iwl-enable
@@ -17,7 +17,14 @@ IWL_NEW="iwlagn"
 IWL_OLD="iwl4965"
 
 # Appended to module file at the end when we want to ignore one
-USAGE="Usage: $0 [ $IWL_NEW | $IWL_OLD ]"
+USAGE="Usage: $0 [ $IWL_NEW | $IWL_OLD | iwlwifi]"
+
+function enable_iwlwifi {
+	for i in $IWL_OLD $IWL_NEW; do
+		module_disable $i
+	done
+	module_enable iwlwifi
+}
 
 function enable_iwlagn {
 	module_disable $IWL_OLD
@@ -41,6 +48,8 @@ if [ "$MODULE" == "iwl4965" ]; then
 	module_enable $IWL_OLD
 elif [ "$MODULE" == "iwlagn" ]; then
 	enable_iwlagn
+elif [ "$MODULE" == "iwlwifi" ]; then
+	enable_iwlwifi
 else
 	echo "$USAGE"
 	exit
diff --git a/scripts/unload.sh b/scripts/unload.sh
index abc5e72..b791b6e 100755
--- a/scripts/unload.sh
+++ b/scripts/unload.sh
@@ -15,7 +15,7 @@ MODULES="$MODULES adm8211 zd1211rw"
 MODULES="$MODULES orinoco_cs orinoco_nortel orinoco_pci orinoco_plx"
 MODULES="$MODULES orinoco_tld orinoco_usb spectrum_cs orinoco"
 MODULES="$MODULES b43 b44 b43legacy brcm80211 ssb"
-MODULES="$MODULES iwl3945 iwlagn iwlcore"
+MODULES="$MODULES iwl3945 iwlwifi iwlagn iwlcore"
 MODULES="$MODULES ath9k ath9k_htc ath9k_common ath9k_hw "
 MODULES="$MODULES ath5k ath ath6kl ar9170usb carl9170"
 MODULES="$MODULES p54pci p54usb p54spi p54common"
diff --git a/scripts/wlunload.sh b/scripts/wlunload.sh
index cd6298d..c6c6af9 100755
--- a/scripts/wlunload.sh
+++ b/scripts/wlunload.sh
@@ -15,7 +15,7 @@ MODULES="$MODULES adm8211 zd1211rw"
 MODULES="$MODULES orinoco_cs orinoco_nortel orinoco_pci orinoco_plx"
 MODULES="$MODULES orinoco_tld orinoco_usb spectrum_cs orinoco"
 MODULES="$MODULES b43 b44 b43legacy brcm80211 ssb"
-MODULES="$MODULES iwl3945 iwlagn iwlcore"
+MODULES="$MODULES iwl3945 iwlwifi iwlagn iwlcore"
 MODULES="$MODULES ath9k ath9k_htc ath9k_common ath9k_hw "
 MODULES="$MODULES ath5k ath ath6kl ar9170usb carl9170"
 MODULES="$MODULES p54pci p54usb p54spi p54common"
-- 
1.7.4.4



